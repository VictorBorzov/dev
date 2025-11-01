{
  ...
}: {
  vim = {
    globals.mapleader = " ";

    options = {
      number = true;
      relativenumber = false;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = false;
      autoindent = true;
      smartindent = true;
    };

    theme.enable = true;
    theme.name = "gruvbox";
    theme.style = "dark";

    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;

    lsp = {
      enable = true;
    };

    languages = {
      enableTreesitter = true;

      nix.enable = true;
      clang.enable = true;
    };
  };
}
