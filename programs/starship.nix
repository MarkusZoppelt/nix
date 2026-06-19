{ colors, ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$hostname$directory$git_branch$git_status$character";

      directory = {
        style = "fg:${colors.blue} bold";
        truncation_length = 3;
      };

      git_branch = {
        symbol = "";
        format = "on [[$branch](${colors.purple})]($style) ";
      };

      git_status = {
        format = "[[($all_status$ahead_behind )](fg:${colors.blue})]($style)";
      };

      hostname = {
        ssh_only = true;
        format = "[@$hostname](bold green) ";
      };
    };
  };
}
