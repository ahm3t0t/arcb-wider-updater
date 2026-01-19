# Rust Migration Roadmap (ARCB Wider Updater)

Goal: keep the **UX and behavior** of `guncel` but migrate to a safer, testable, distributable Rust CLI.

## Phase 0 — Freeze current behavior (now)
- Document current features and expected output
- Decide which OS families are supported:
  - Debian/Ubuntu (APT)
  - Fedora/RHEL-like (DNF)
- Define "optional" tools: flatpak, snap, fwupd, zenity

Deliverables:
- Stable README
- CI lint green
- Minimal issue templates

## Phase 1 — Extract a spec from the Bash script
Create a "behavior spec" without implementation details:
- Commands run (per PM)
- Logging format
- GUI behavior:
  - --gui uses zenity when available
  - otherwise fallback to terminal prompts
- Tool detection + optional installation prompts
- Kernel prune rules (APT):
  - keep running + one previous

Deliverables:
- SPEC.md (inputs/outputs, flow)
- A small sample log in docs/

## Phase 2 — Rust CLI skeleton
Build a Rust CLI that:
- Detects OS and package manager
- Implements the same flow but can run in "dry-run" mode

Suggested crates:
- clap (CLI args)
- anyhow or eyre (error handling)
- chrono (timestamps)
- sysinfo (system summary)
- which (tool detection)
- serde + toml/yaml (optional config later)

Deliverables:
- `arcb-wider-updater` binary (new name TBD)
- `--dry-run` and `--version`
- Basic logging to file

## Phase 3 — Implement update backends
Implement per-manager modules:
- apt: update/upgrade/full-upgrade/cleanup
- dnf: upgrade --refresh / autoremove / clean
Optional modules:
- flatpak update + unused uninstall
- snap refresh
- fwupd refresh + get-updates

Deliverables:
- Same behavior as Bash (no GUI yet)
- Integration tests using mocks

## Phase 4 — GUI strategy
Decide approach:
- Option A: Keep zenity as external tool (simple, minimal deps)
- Option B: Native TUI/GUI (more work)
Recommended: Option A initially (call zenity if exists).

Deliverables:
- `--gui` parity with Bash
- Fallback prompts if no zenity

## Phase 5 — Packaging & distribution
- Provide prebuilt binaries via GitHub Releases
- Consider:
  - .deb / .rpm packaging
  - Homebrew formula (optional)
- Installer script can shift to downloading release binaries (more stable than raw main)

Deliverables:
- Release artifacts
- Updated install.sh to fetch latest release

## Phase 6 — Deprecation plan for Bash
- Keep Bash `guncel` as "legacy" for a while
- Eventually point users to Rust binary

Deliverables:
- Migration note in README
- Legacy support window

## Success criteria
- CLI does not run hidden commands
- Logs are readable and consistent
- Safe defaults + graceful degradation
- Tests exist for core flow
