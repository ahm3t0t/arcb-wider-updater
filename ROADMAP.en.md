# ARCB Wider Updater - Roadmap

> Continuing development as a shell script.

---

## ✅ Completed Versions

### v3.x Series - Stability & Infrastructure
- [x] Color and character fixes
- [x] DNF/APT lock mechanism
- [x] `--dry-run` mode
- [x] `--skip` and `--only` flags
- [x] Config file support
- [x] Logrotate integration
- [x] Release automation (GitHub Actions)
- [x] BATS unit test infrastructure

### v4.x Series - Security & Quality
- [x] CODENAME in installation message
- [x] GPG signed releases
- [x] TLS 1.2+ hardening
- [x] `--uninstall` and `--purge` options
- [x] `updater` symlink (English alias)
- [x] 95 BATS tests (guncel + install.sh)

### v5.0.0 "BigFour" - Multi-Distro Support
- [x] **APT** - Debian/Ubuntu/Zorin
- [x] **DNF** - Fedora/RHEL
- [x] **Pacman** - Arch Linux/Manjaro/EndeavourOS
- [x] **Zypper** - openSUSE Leap/Tumbleweed
- [x] Multi-distro CI test matrix
- [x] Docker test environment

### v5.2.0 "BigFive" - Alpine Support
- [x] **APK** - Alpine Linux
- [x] 5 package manager support
- [x] Alpine CI testing (alpine:3.20)

---

## 🔜 Planned Features

### v5.3 - JSON Output
- [ ] `--json` output format
- [ ] Monitoring tools integration (Prometheus, Grafana)
- [ ] Machine-readable output

### v5.4 - User Experience
- [ ] Graceful error messages
- [ ] Better error explanations
- [ ] Solution suggestions

### v5.5 - Advanced Configuration
- [ ] Email notifications (SMTP)
- [ ] Webhook notifications (Slack, Discord)
- [ ] Systemd timer template

### v6.0 - Internationalization (i18n)
- [ ] Move strings to separate file
- [ ] Translation framework
- [ ] Full English/Turkish support

---

## 💡 Ideas Under Consideration

| Idea | Status | Note |
|------|--------|------|
| Desktop notifications | 🤔 Uncertain | Evaluating for v6.x |
| Parallel updates | ❌ Deferred | Risky, complex |
| Rust migration | ❌ Deferred | Bash is sufficient |
| Web UI | ❌ Out of scope | Staying CLI-focused |
| Plugin system | ❌ Deferred | Complexity |
| DEB/RPM packaging | ❌ Deferred | curl-pipe-bash is sufficient |

---

## 📊 Test Status

| Component | Test Count | Status |
|-----------|------------|--------|
| guncel.bats | 60 | ✅ |
| install.bats | 35 | ✅ |
| **Total** | **95** | ✅ |

### CI Test Matrix

| Distro | Package Manager | Status |
|--------|-----------------|--------|
| Ubuntu 24.04 | APT | ✅ |
| Fedora 40 | DNF | ✅ |
| Arch Linux | Pacman | ✅ |
| openSUSE Tumbleweed | Zypper | ✅ |
| Alpine 3.20 | APK | ✅ |

---

## 🤝 Contributing

Feel free to open an [Issue](https://github.com/ahm3t0t/arcb-wider-updater/issues) for suggestions.

Detailed contribution guide: [CONTRIBUTING.en.md](CONTRIBUTING.en.md)
