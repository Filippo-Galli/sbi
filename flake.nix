{
  description = "sbi package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nflows = {
      url = "github:Filippo-Galli/nflows";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zuko = {
      url = "github:Filippo-Galli/zuko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    torchtestcase = {
      url = "github:Filippo-Galli/torch-test-case";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nflows,
      zuko,
      torchtestcase,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        {
          sbi = pkgs.python3Packages.callPackage ./. {
            nflows = nflows.packages.${system}.default;
            zuko = zuko.packages.${system}.default;
            torchtestcase = torchtestcase.packages.${system}.default;
          };

          default = self.packages.${system}.sbi;
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        {
          default = pkgs.callPackage ./shell.nix {
          };
        }
      );
    };
}
