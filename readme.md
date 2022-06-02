# my .dotfiles repository

These are my dotfiles using darwin-nix and home-manager to configure my workstation

### Install nix + home-manager

```shell
sh <(curl -L https://nixos.org/nix/install)

mkdir -p ~/.config/nix



```

### Clone this repository

```shell
rm -rf ~/.config/nixpkgs/
git clone https://github.com/f0x7C90/.dotfiles.git
```

### Switch first generation

Run home-manager for the first time with this configuration

```shell
home-manager switch
```

### Decrypt secrets

The secrets are en- / decrypted using GPG, which should be installed by now

```shell
git-crypt unlock
```

