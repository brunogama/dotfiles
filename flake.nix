{
  description = "Nix-first macOS dotfiles with nix-darwin and Home Manager";

  nixConfig.extra-experimental-features = [
    "nix-command"
    "flakes"
  ];

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      host = import ./nix/host.nix;
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      darwinConfiguration = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit host inputs self; };
        modules = [
          ./nix/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "pre-nix";
              extraSpecialArgs = { inherit host inputs self; };
              users.${host.username} = import ./nix/home.nix;
            };
          }
        ];
      };
    in
    {
      darwinConfigurations = {
        ${host.configurationName} = darwinConfiguration;
        default = darwinConfiguration;
      };

      packages.${host.system}.darwin-rebuild =
        nix-darwin.packages.${host.system}.darwin-rebuild;

      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = (import ./nix/packages.nix { inherit pkgs; }) ++ [
              pkgs.deadnix
              pkgs.nixfmt-tree
              pkgs.statix
            ];
          };
        }
      );

      formatter = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.nixfmt-tree
      );
    };
}
