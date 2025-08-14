#!/usr/bin/env bash

declare awsprofiles
awsume() {
    if [ -z "$awsprofiles" ]; then
        awsprofiles=$(aws configure list-profiles)
    fi
    export AWS_PROFILE=$(echo "$awsprofiles" | fzf -1 -q "$*")
    echo "switched to profile: $AWS_PROFILE"
}

cognito() {
    printf '%-14s ' "user pool id:"
    poolID=$(aws cognito-idp list-user-pools --max-results 50 --output text --query 'UserPools[].Id' | fzf -1)
    if [ -z "$poolID" ]; then
        exit 1
    fi
    echo "$poolID"

    usernames=$(aws cognito-idp list-users --user-pool-id "$poolID" --query "Users[].Username" --output json | jq -r '.[]')
    printf '%-14s ' "username:"
    username=$(echo "$usernames" | fzf -1 -q "$1")
    if [ -z "$username" ]; then
        return
    fi
    echo "$username"

    availableGroups=$(aws cognito-idp list-groups --user-pool-id "$poolID" --output json --query "Groups[].GroupName" | jq -r '.[]')
    currentGroups=$(aws cognito-idp admin-list-groups-for-user --user-pool-id "$poolID" --username "$username" --output json --query "Groups[].GroupName" | jq -r '.[]')
    groups=$(echo "$availableGroups" | fzf --multi --preview-window="top:50%" --preview-label="Current groups" --preview "echo \"$currentGroups"\")
    if [ -z "$groups" ]; then
        return
    fi
    printf '%-14s ' "groups:"

    echo

    diff --color=always -u <(echo "$currentGroups" | sort) <(echo "$groups" | sort) | tail -n +4

    echo

    read -r -q "REPLY?continue? [y/N] "
    echo
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
        return
    fi

    for g in $groups; do
        if [[ ! " ${currentGroups[*]} " =~ $g ]]; then
            echo "* adding to $g"
            aws cognito-idp admin-add-user-to-group --user-pool-id "$poolID" --username "$username" --group-name "$g"
        fi
    done

    for g in $currentGroups; do
        if [[ ! " ${groups[*]} " =~ $g ]]; then
            echo "* removing from $g"
            aws cognito-idp admin-remove-user-from-group --user-pool-id "$poolID" --username "$username" --group-name "$g"
        fi
    done
}

# TODO: make region configurable in AWS scripts

ec2connect() {
    region="eu-central-1"

    instances=$(aws ec2 describe-instances --region $region --query "Reservations[*].Instances[*].{InstanceId:InstanceId,PrivateIP:PrivateIpAddress,Name:Tags[?Key=='Name']|[0].Value,Type:InstanceType}" --filters Name=instance-state-name,Values=running --output text)
    instanceID=$(echo "$instances" | fzf -1 -q "$*" | awk '{print $1}')

    if [ -z "$instanceID" ]; then
        echo "no instance selected"
    fi
    aws ssm start-session --region $region --target "$instanceID"
}

ecsconnect() {
    printf '%-12s ' "cluster:"
    cluster=$(aws ecs list-clusters --query 'clusterArns' | jq -r '.[]' | cut -d '/' -f2 | fzf -1 -q "$1")
    if [ -z "$cluster" ]; then
        echo "no cluster found"
        return
    fi
    echo "$cluster"

    printf '%-12s ' "service:"
    service=$(aws ecs list-services --cluster "$cluster" --query 'serviceArns' | jq -r '.[]' | cut -d '/' -f3 | fzf -1 -q "$2")
    if [ -z "$service" ]; then
        echo "no service found"
        return
    fi
    echo "$service"

    printf '%-12s ' "container:"
    taskDef=$(aws ecs describe-services --services "$service" --cluster "$cluster" | jq -r '.services[].taskDefinition')
    if [ -z "$taskDef" ]; then
        echo "no task definition found"
        return
    fi

    container=$(aws ecs describe-task-definition --task-definition "$taskDef" | jq -r '.taskDefinition.containerDefinitions[] | select(.linuxParameters.initProcessEnabled == true) | .name' | fzf -1 -q "$3")
    if [ -z "$container" ]; then
        echo "no container with SSM enabled found"
        return
    fi
    echo "$container"

    printf '%-12s ' "task:"
    taskID=$(aws ecs list-tasks --cluster "$cluster" --service "$service" --query 'taskArns' | jq -r '.[]' | cut -d'/' -f3 | fzf -1 -q "$4")
    if [ -z "$taskID" ]; then
        echo "no task found"
        return
    fi
    echo "$taskID"

    echo "---"

    echo "connecting to $cluster/$service/$taskID/$container"

    aws ecs execute-command --interactive --command /bin/sh --task "$taskID" --cluster "$cluster" --container "$container"
}

ecr() {
    region="eu-central-1"
    aws ecr get-login-password --region $region |
        docker login --password-stdin --username AWS \
            "$(aws sts get-caller-identity --query Account --output text).dkr.ecr.$region.amazonaws.com"
}

rdstunnel() {
    local region="eu-central-1"
    local bastion_id db_selection db_host db_port

    # query ec2 instance id for bastion
    bastion_id=$(aws ec2 describe-instances --region $region --filters "Name=tag:Name,Values=Bastion" --query "Reservations[*].Instances[*].InstanceId" --output text)
    if [ -z "$bastion_id" ]; then
        echo "no bastion ec2 instance found..."
        return 1
    fi

    # query db instances and select using fzf
    db_selection=$(aws rds describe-db-instances --region $region --query "DBInstances[*].[DBInstanceIdentifier, Endpoint.Address, Endpoint.Port]" --output text | column -t | fzf --ansi -1 -q "$*")
    if [ -z "$db_selection" ]; then
        echo "no database instance found..."
        return 1
    fi

    # extract db host and port
    read -r db_host db_port <<<"$(echo "$db_selection" | awk '{print $2, $3}')"

    # Generate IAM database authentication token
    echo "Generating IAM database authentication token..."
    db_token=$(aws rds generate-db-auth-token --region $region --hostname $db_host --port $db_port --username engineer)

    if [ $? -eq 0 ] && [ -n "$db_token" ]; then
        echo "✓ IAM token generated successfully, expires after 15 minutes!"
        echo "Connect using: mysql -h 127.0.0.1 -P $db_port -u engineer --enable-cleartext-plugin --password='$db_token'"
    else
        echo "⚠ Failed to generate IAM token - you may need to use traditional authentication"
    fi

    aws ssm start-session --region $region --target "$bastion_id" --document-name AWS-StartPortForwardingSessionToRemoteHost \
        --parameters "{\"host\":[\"$db_host\"],\"portNumber\":[\"$db_port\"],\"localPortNumber\":[\"$db_port\"]}"
}
