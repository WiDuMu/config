{
  # Import all your configuration modules here
  imports = [];

  colorschemes.modus.enable = true;

  opts = {
    mouse = "a";
    number = true;
    relativenumber = false;
    shiftwidth = 3;

    # Search options
    ignorecase = true;
    smartcase = true;
  };

  plugins = {
    # Smooth scrolling
    neoscroll = {
      enable = true;
    };
    # Buffer line
    bufferline.enable = true;
    web-devicons.enable = true;
    # Fast bottom line
    lualine = {
      enable = true;
    };
  };

  # LSP plugins
  plugins.lsp = {
    autoLoad = true;
    enable = true;
    inlayHints = true;
    servers = {
      biome = {
        enable = true;
        filetypes = ["js" "ts"];
      };
      cssls.enable = true;
      html.enable = true;
      rust_analyzer = {
        enable = true;
        installRustfmt = true;
        installRustc = true;
        installCargo = true;
      };
    };
  };

  plugins.lsp-format = {
    autoLoad = true;
    enable = true;
  };

  plugins.lsp-lines = {
    enable = true;
  };
}
