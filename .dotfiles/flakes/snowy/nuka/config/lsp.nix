{
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
