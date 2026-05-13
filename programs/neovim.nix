{ pkgs, ... }:
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
    initLua = ''
      ${builtins.readFile ./nvim/options.lua}
      ${builtins.readFile ./nvim/keymaps.lua}
      ${builtins.readFile ./nvim/lsp.lua}
      ${builtins.readFile ./nvim/theme.lua}
      ${builtins.readFile ./nvim/plugins/fidget.lua}
      ${builtins.readFile ./nvim/plugins/rustaceanvim.lua}
      ${builtins.readFile ./nvim/plugins/telescope.lua}
      ${builtins.readFile ./nvim/plugins/treesitter.lua}
    '';
  };
}
