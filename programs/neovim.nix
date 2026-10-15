{ pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      telescope-nvim
      tokyonight-nvim
    ];
    initLua = lib.concatMapStrings builtins.readFile [
      ./nvim/options.lua
      ./nvim/keymaps.lua
      ./nvim/lsp.lua
      ./nvim/theme.lua
      ./nvim/plugins/telescope.lua
    ];
  };
}
