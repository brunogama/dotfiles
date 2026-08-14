{
  # This is the only Nix host configuration file that should need editing for another user or Mac.
  configurationName = "naboo";
  username = "bruno";
  computerName = "naboo";
  hostName = "naboo";
  localHostName = "naboo";
  system = "aarch64-darwin";

  git = {
    name = "Bruno da Gama Porciuncula";
    email = "bruno@naboo.local";
  };

  # Set this to false when using Determinate Nix, which manages its own daemon.
  manageNix = true;
}
