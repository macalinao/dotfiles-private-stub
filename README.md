# dotfiles-private-stub

Minimal stub flake used as the default `dotfiles-private` input in [macalinao/dotfiles](https://github.com/macalinao/dotfiles).

## Why this exists

The dotfiles repo has a `dotfiles-private` input that points to a private repo (`~/dotfiles-private`) containing sensitive configuration (SSH hosts, secrets, Git identities, etc.). On local machines, `igm-switch` overrides this input to the real private repo via `--override-input`.

In CI, the real private repo isn't available, so we need a stub. The stub must be:

1. **A proper flake** -- the override in `igm-switch` needs `dotfiles-private` to resolve as a flake (not `flake = false`), otherwise the overridden input won't expose `darwinModules`/`homeModules`.
2. **Lockable** -- `nix flake check` in CI rejects unlocked inputs. A `path:` input has no content hash and can't be locked. A `github:` input can.

This repo provides both: a lockable GitHub-hosted flake that exports empty modules.
