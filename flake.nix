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

  outputs =
    { nixpkgs, ... }:
    let
      lib = nixpkgs.lib;

      # No-op declarations for the `dotfiles-private.*` options that the real
      # private repo's home module defines. Consumers (e.g. ~/configuration)
      # set these unconditionally, so the stub must declare them or evaluation
      # fails with "The option `dotfiles-private' does not exist". The values
      # are ignored — this stub intentionally produces no config.
      stubHomeModule = {
        options.dotfiles-private = {
          identity = lib.mkOption {
            type = lib.types.str;
            default = "igm";
            description = "Identity preset name (no-op in the stub).";
          };
          managarr.enable = lib.mkEnableOption "managarr (no-op in the stub)";
        };
      };

      # The real private repo's `nixosModules.devbox` declares a handful of
      # ragenix secrets that ~/configuration reads (Caddy DNS/tunnel tokens,
      # the Immich backup creds, etc.). Mirror those declarations so the devbox
      # NixOS config evaluates against the stub — each points at a placeholder
      # file that is never actually decrypted (the stub is eval-only).
      stubSecrets = [
        "pilipili-cloudflared-tunnel"
        "pilipili-cloudflare-dns-token"
        "pilipili-tailscale-authkey"
        "igm-immich-api-key"
        "rclone-immich-backup"
      ];
      stubDevboxModule = {
        age.secrets = lib.genAttrs stubSecrets (_: {
          file = ./dummy-secret.age;
        });
      };
    in
    {
      homeModules = {
        default = stubHomeModule;
      };
      darwinModules = {
        default = { };
      };
      nixosModules = {
        default = { };
        hosts = { };
        devbox = stubDevboxModule;
      };
      overlays = {
        factorio = _: _: { };
      };
      lib = { };
    };
}
