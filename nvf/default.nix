{
  pkgs,
  lib,
  ...
}: {
  vim = {
    theme.enable = true;
    theme.name = "gruvbox";
    theme.style = "dark";

    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;

    languages = {
      enableLSP = true;
      enableTreesitter = true;

      nix.enable = true;
      clang.enable = true;
    };
  };
}
