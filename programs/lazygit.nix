{ ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      git.autoFetch = false;
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never";
      };
    };
  };
}
