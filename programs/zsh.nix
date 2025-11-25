{ ... }:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    history = {
      size = 9999999;
      save = 9999999;
      share = true;
      extended = true;
    };
    initContent = ''
      ${builtins.readFile ./zshrc}
    '';
  };
}
