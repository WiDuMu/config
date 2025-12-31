{pkgs, ...}: {
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    declarative = true;
    package = pkgs.minecraftServers.vanilla-1-21;
    serverProperties = {
      #   server-port = 43000;
      difficulty = 2;
      gamemode = 0;
      #   max-players = 5;
      motd = "Minecraft server!";
      #   white-list = true;
      #   allow-cheats = true;
    };
    jvmOpts = "-Xms2048M -Xmx3072M";
  };
}
