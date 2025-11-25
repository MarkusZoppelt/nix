{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Markus Zoppelt";
      user.email = "markus@zoppelt.net";
      branch.autosetuprebase = "always";
      color.ui = true;
      core.editor = "nvim";
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      github.user = "MarkusZoppelt";
      push.default = "simple";
      pull.rebase = true;
      init.defaultBranch = "main";
    };
    ignores = [
      "result"
      ".idea"
      "*~"
      "*.swp"
      ".DS_Store"
      ".Spotlight-V100"
      ".Trashes"
      ".vimrc.local"
      ".vim/.netrwhist"
      ".vim/spell/"
      ".vim/colors/"
      ".vscode/"
      "dump.rdb"
      ".opencode/"
      ".direnv"
    ];
  };
}
