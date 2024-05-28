{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    age
    age-plugin-yubikey
    fd
    fzf
    gh
    git
    go
    jq
    lazygit
    neovim
    nodejs
    passage
    qrencode
    restic
    rustup
    ripgrep
    starship
    tree
    unzip
    yt-dlp
    yubikey-manager
    zsh
    zsh-completions
    zsh-autosuggestions
  ];

  # users.users.your-username = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ];
  # };

  programs.zsh.enable = true;
}
