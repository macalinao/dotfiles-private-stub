{
  description = "Stub for dotfiles-private (used in CI where the real private repo is unavailable)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.agenix.inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = _: {
    homeModules.default = { };
    nixosModules.default = { };
    nixosModules.hosts = { };
    darwinModules.default = { };
  };
}
