# dotfiles-private-stub

Minimal stub flake used as the default `dotfiles-private` input in [macalinao/dotfiles](https://github.com/macalinao/dotfiles).

## Why this exists

The dotfiles repo has a `dotfiles-private` input that points to a private repo (`~/dotfiles-private`) containing sensitive configuration (SSH hosts, secrets, Git identities, etc.). On local machines, `igm-switch` overrides this input to the real private repo via `--override-input`.

In CI, the real private repo isn't available, so we need a stub. The stub must be:

1. **A proper flake** -- the override in `igm-switch` needs `dotfiles-private` to resolve as a flake (not `flake = false`), otherwise the overridden input won't expose `darwinModules`/`homeModules`.
2. **Lockable** -- `nix flake check` in CI rejects unlocked inputs. A `path:` input has no content hash and can't be locked. A `github:` input can.

This repo provides both: a lockable GitHub-hosted flake that exports no-op modules.

## What the stub mirrors

The modules produce no real configuration, but they must still declare the
public *interface* the real private repo exposes -- otherwise consumers that set
those options or read those secrets fail to evaluate. Currently mirrored:

- `homeModules.default` -- declares the `dotfiles-private.identity` and
  `dotfiles-private.managarr.enable` options as no-ops.
- `nixosModules.devbox` -- declares the ragenix secrets the real devbox module
  owns (`pilipili-cloudflared-tunnel`, `pilipili-cloudflare-dns-token`,
  `pilipili-tailscale-authkey`, `igm-immich-api-key`, `rclone-immich-backup`),
  each pointing at a placeholder `dummy-secret.age` that is never decrypted.

When the real repo gains a new option or secret that a consumer references
unconditionally, add a matching no-op declaration here.
