{  pkgs, ... }:
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
  programs.tmux.enable = true;
  programs.direnv.enable = true;


  # Set up npm so that it installs global packages in the user's home directory
  environment.variables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm";
    PATH = "$HOME/.npm/bin:${pkgs.lib.makeSearchPath "bin" [ pkgs.nodejs ]}:$PATH";
  };
}
