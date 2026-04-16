{
  description = "Stub for dotfiles-private (used in CI where the real private repo is unavailable)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    homeModules = {
      default = { };
    };
    darwinModules = {
      default = { };
    };
    nixosModules = {
      default = { };
      hosts = { };
      devbox = { };
    };
    overlays = {
      factorio = _: _: { };
    };
    lib = { };
  };
}
