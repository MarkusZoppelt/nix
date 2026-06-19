{ pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      fidget-nvim
      nvim-lspconfig
      (nvim-treesitter.withPlugins (p: [
        p.go
        p.javascript
        p.json
        p.lua
        p.nix
        p.rust
        p.toml
        p.typescript
      ]))
      plenary-nvim
      rustaceanvim
      telescope-nvim
      tokyonight-nvim
    ];
    initLua = lib.concatMapStrings builtins.readFile [
      ./nvim/options.lua
      ./nvim/keymaps.lua
      ./nvim/lsp.lua
      ./nvim/theme.lua
      ./nvim/plugins/fidget.lua
      ./nvim/plugins/rustaceanvim.lua
      ./nvim/plugins/telescope.lua
      ./nvim/plugins/treesitter.lua
    ];
  };
}
