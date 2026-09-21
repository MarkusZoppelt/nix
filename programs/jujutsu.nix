{ name', email, ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = name';
        email = email;
      };
      ui = {
        default-command = "log";
        pager = [
          "hunk"
          "pager"
        ];
        diff-formatter = ":git";
      };
      aliases = {
        n = [ "new" ];
        l = [
          "log"
          "--no-pager"
          "--limit"
          "10"
        ];
        s = [
          "st"
          "--no-pager"
        ];
        tug = [
          "bookmark"
          "move"
          "--from"
          "heads(::@- & bookmarks())"
          "--to"
          "@-"
        ];
      };
    };
  };
}
