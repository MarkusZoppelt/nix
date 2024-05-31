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
    gum
    jq
    lazygit
    monaspace
    neovim
    nodejs
    passage
    qrencode
    restic
    ripgrep
    rustup
    starship
    tree
    unzip
    yt-dlp
    yubikey-manager
    zsh
    zsh-autosuggestions
    zsh-completions
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # We can't set enableAutosuggestions on darwin,
    # so we'll have to do it like this:
    interactiveShellInit = ''
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    '';
  };

  programs.tmux = {
    enable = true;
    # keep up to date with ~/.dotfiles/.tmux.conf
    # until I find a better way to do this...
    extraConfig = ''
      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix

      bind t split-window -f -l 15 -c "#{pane_current_path}"
      bind T split-window -h -f -p 35 -c "#{pane_current_path}"

      set -ag terminal-overrides ",xterm-256color:RGB"

      set -g history-limit 9999999

      set -g mouse on
      setw -g mouse on

      set -sg escape-time 0

      # make window/pane index start with 1
      set -g base-index 1
      setw -g pane-base-index 1

      # renumber windows when closing one
      set -g renumber-windows on

      # set bar colors
      set -g status-style fg="#3b4261",bg="#16161e"

      # set background color of current window to blue
      setw -g window-status-current-style bg=default,fg="#7aa2f7"
    '';
  };

  programs.direnv.enable = true;

  # Set up npm so that it installs global packages in the user's home directory
  environment.variables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm";
    PATH = "$HOME/.npm/bin:${pkgs.lib.makeSearchPath "bin" [ pkgs.nodejs ]}:$PATH";
  };
}
