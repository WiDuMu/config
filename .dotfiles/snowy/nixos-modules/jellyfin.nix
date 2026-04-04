{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
  	../shared/sops.nix
  ];

  services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

  services.caddy = {
  	  enable = true;
  	  package = pkgs.caddy.withPlugins {
  	  	plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
  	  	hash = "sha256-Olz4W84Kiyldy+JtbIicVCL7dAYl4zq+2rxEOUTObxA=";
  	  };
  	  environmentFile = "/run/secrets/caddy.env";
  	  globalConfig = ''
  	     skip_install_trust
  	  '';
  	  virtualHosts."iris.widumu.dev".extraConfig = ''
  	      reverse_proxy http://127.0.0.1:8096
  	      tls {
  	      	dns cloudflare {env.CLOUDFLARE_API_TOKEN}
  	      }
  	    '';
  	  virtualHosts."http://192.168.68.102, https://192.168.68.102".extraConfig = ''
  	      reverse_proxy http://127.0.0.1:8096
  	  '';
  };

  sops = {
  	secrets."caddy.env" = {
  	   format = "json";
  	   sopsFile = ../secrets/caddy.json;
  	};
  };
  
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  
  environment.systemPackages = [
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ];
}
