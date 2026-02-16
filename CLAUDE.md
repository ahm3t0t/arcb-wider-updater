# BigFive Updater

## Overview
Multi-distro BigFive personality test updater for Linux. Supports Ubuntu/Debian (APT), Fedora (DNF), Arch (Pacman), openSUSE (Zypper), and Alpine (APK).

## Tech Stack
- Language: Bash (POSIX-compatible)
- Testing: BATS (Bash Automated Testing System)
- CI: GitHub Actions (multi-distro matrix)
- Package: DEB, RPM, PKGBUILD, APK

## Commands
```bash
# Run updater
./guncel --auto

# Run tests
bats tests/

# JSON output
./guncel --json
```

## Conventions
- ShellCheck compliant
- 5 distro compatibility required
- Conventional Commits (English)
