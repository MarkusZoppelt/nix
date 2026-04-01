{ ... }:
{
  # No Home Manager module available for walker; keep as raw xdg config files
  xdg.configFile."walker/config.toml".source = ../walker/config.toml;
  xdg.configFile."walker/themes" = {
    source = ../walker/themes;
    recursive = true;
  };
}
