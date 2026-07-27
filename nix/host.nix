{
  # This is the only file that should need editing for another user or Mac.
  configurationName = "personal-mac";
  username = "bruno";
  system = "aarch64-darwin";

  git = {
    name = "Bruno da Gama Porciuncula";
    email = "bruno@naboo.local";
  };

  # Set this to false when using Determinate Nix, which manages its own daemon.
  manageNix = true;
}
