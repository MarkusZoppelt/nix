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
      };
    };
  };
}
