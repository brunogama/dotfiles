{
  description = "Bruno's reproducible binary environment via Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Development shell with all tools
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core Unix utilities
            bat
            coreutils
            curl
            wget
            tree
            unzip
            zip

            # File/text processing
            fd
            fzf
            ripgrep
            jq
            sd
            grex

            # Version control & Git tools
            git
            gh
            git-delta
            gitpkgs.git-extras
            git-flow
            git-lfs
            git-secrets
            gitleaks

            # Development tools
            neovim
            tmux
            shellcheck
            clang-tools
            pre-commit
            lefthook

            # Language runtimes
            python311
            python39
            nodejs
            ruby

            # Language tools
            pyenv
            rbenv

            # Code analysis & formatting
            swiftformat
            swiftlint
            tokei

            # CLI utilities
            eza
            dust
            procs
            htop
            ncdu
            zoxide
            choose

            # Network utilities
            httpie
            hyperfine
            binwalk

            # Other tools
            docker
            gnupg
            watchman
            stow
            ripgrep

            # Shell enhancements
            zsh
          ];
        };

        # Package definitions for distribution
        packages = {
          default = self.packages.${system}.bundle;

          # CLI tools bundle
          bundle = pkgs.buildEnv {
            name = "bruno-tools";
            paths = with pkgs; [
              bat coreutils curl wget tree unzip zip
              fd fzf ripgrep jq sd grex
              git gh git-delta git-flow git-lfs git-secrets gitleaks
              neovim tmux shellcheck clang-tools
              python311 python39 nodejs ruby
              eza dust procs htop ncdu zoxide choose
              httpie hyperfine binwalk
              docker gnupg watchman stow
              zsh
            ];
          };

          # Individual tools
          git-credential-oauth = pkgs.rustPlatform.buildRustPackage rec {
            pname = "git-credential-oauth";
            version = "0.12.0"; # Update to latest from GitHub

            src = pkgs.fetchFromGitHub {
              owner = "hickford";
              repo = "git-credential-oauth";
              rev = "v${version}";
              sha256 = ""; # Run `nix flake update` to get the correct hash
            };

            cargoSha256 = ""; # Run `nix build` to get this

            meta = with pkgs.lib; {
              description = "Git credential helper that uses OAuth for authentication";
              homepage = "https://github.com/hickford/git-credential-oauth";
              license = licenses.asl20;
              platforms = platforms.unix;
            };
          };
        };

        # App definitions for easy running
        apps = {
          default = self.apps.${system}.shell;
          shell = {
            type = "app";
            program = "${self.devShells.${system}.default}/bin/bash";
          };
        };
      }
    );
}
