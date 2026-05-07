{ name', email, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = name';
        email = email;
      };
      branch.autosetuprebase = "always";
      color.ui = true;
      core = {
        editor = "nvim";
        askPass = ""; # needs to be empty to use terminal for ask pass
        pager = "hunk pager";
      };
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
      ".jj"
    ];
  };
}
