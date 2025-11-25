{ pkgs, inputs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      cmp-buffer
      cmp-nvim-lsp
      harpoon
      lazygit-nvim
      mason-lspconfig-nvim
      mason-nvim
      nvim-cmp
      nvim-lspconfig
      nvim-notify
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
      nvim-treesitter-context
      oil-nvim
      plenary-nvim
      telescope-nvim
      tokyonight-nvim
      vim-fugitive
    ];
    extraLuaConfig = ''
      ${builtins.readFile ./nvim/options.lua}
      ${builtins.readFile ./nvim/keymaps.lua}
      ${builtins.readFile ./nvim/plugins/mason-lsp.lua}
      ${builtins.readFile ./nvim/plugins/cmp.lua}
      ${builtins.readFile ./nvim/plugins/telescope.lua}
      ${builtins.readFile ./nvim/plugins/harpoon.lua}
      ${builtins.readFile ./nvim/plugins/treesitter.lua}
      ${builtins.readFile ./nvim/plugins/lazygit.lua}
      ${builtins.readFile ./nvim/theme.lua}
      ${builtins.readFile ./nvim/oil.lua}
    '';
  };
}
