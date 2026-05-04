{ name', email, ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = name';
        email = email;
      };
      ui.default-command = "log";
      aliases = {
        n = ["new"];
      };
    };
  };
}

