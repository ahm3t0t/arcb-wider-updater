# Contributing to ARCB Wider Updater

Teşekkürler! Katkıda bulunmayı düşündüğün için ❤️

Thanks for considering a contribution! ❤️

---

## 📋 İçindekiler / Table of Contents

- [Hızlı Kurallar / Quick Rules](#-hızlı-kurallar--quick-rules)
- [Geliştirme Ortamı / Development Setup](#️-geliştirme-ortamı--development-setup)
- [Kod Stili / Code Style](#-kod-stili--code-style)
- [Commit Mesaj Formatı / Commit Message Format](#-commit-mesaj-formatı--commit-message-format)
- [Sürüm Yönetimi / Version Management](#-sürüm-yönetimi--version-management)
- [Release Oluşturma / Creating Releases](#-release-oluşturma--creating-releases)
- [Test Senaryoları / Test Scenarios](#-test-senaryoları--test-scenarios)
- [PR Süreci / PR Process](#-pr-süreci--pr-process)
- [Komut Satırı Seçenekleri / Command Line Options](#-komut-satırı-seçenekleri--command-line-options)

---

## 🚀 Hızlı Kurallar / Quick Rules

- Basit, okunabilir ve güvenli kod yaz / Keep it simple, readable, and safe
- Mümkün olduğunca POSIX uyumlu shell kullan / Prefer POSIX-ish, portable shell where possible
- Asla log'lara secret yazdırma / Never print secrets to logs
- Yeni özellikler, araç yoksa graceful degrade etmeli / Any new feature should degrade gracefully if tools are missing

---

## 🛠️ Geliştirme Ortamı / Development Setup

```bash
git clone git@github.com:ahm3t0t/arcb-wider-updater.git
cd arcb-wider-updater
chmod +x guncel install.sh release.sh
./guncel --help
```

### Gerekli Araçlar / Required Tools

| Tool | Version | Purpose / Amaç |
|------|---------|----------------|
| `bash` | 4.0+ | Script execution / Script çalıştırma |
| `shellcheck` | latest | Lint / Kod analizi |
| `bats` | 1.10+ | Unit tests / Birim testler |
| `curl` or `wget` | - | Downloads / İndirmeler |

### Önerilen Araçlar / Recommended Tools

| Tool | Purpose / Amaç |
|------|----------------|
| `shfmt` | Bash formatter |
| `docker` | Multi-distro testing / Çoklu dağıtım testi |
| `act` | Local GitHub Actions / Yerel GitHub Actions |
| `gh` | GitHub CLI |

---

## 📝 Kod Stili / Code Style

### ShellCheck Kuralları / ShellCheck Rules

Tüm kod ShellCheck'ten geçmeli / All code must pass ShellCheck:

```bash
shellcheck -x guncel install.sh release.sh
```

### Girintileme / Indentation

- **4 space** kullan (tab değil) / Use **4 spaces** (not tabs)
- Nested bloklar için tutarlı girintileme / Consistent indentation for nested blocks

```bash
# ✅ Doğru / Correct
if [[ "$condition" == "true" ]]; then
    echo "4 space indent"
    if [[ "$nested" == "true" ]]; then
        echo "8 space for nested"
    fi
fi

# ❌ Yanlış / Wrong
if [[ "$condition" == "true" ]]; then
  echo "2 space - wrong"
fi
```

### POSIX Uyumluluğu / POSIX Compatibility

- `[[ ]]` yerine `[ ]` tercih et (mümkünse) / Prefer `[ ]` over `[[ ]]` where possible
- Bash-specific özellikler gerektiğinde `#!/usr/bin/env bash` kullan
- `local` değişkenler fonksiyonlarda kullanılmalı / Use `local` variables in functions

```bash
# ✅ Tercih edilen / Preferred
my_function() {
    local my_var="value"
    # ...
}

# Bash-specific gerektiğinde / When bash-specific is needed
if [[ "$string" =~ ^[0-9]+$ ]]; then
    # regex için [[ ]] gerekli / [[ ]] required for regex
fi
```

### Değişken Adlandırma / Variable Naming

- Global değişkenler / Global variables: `UPPER_SNAKE_CASE`
- Local değişkenler / Local variables: `lower_snake_case`
- Fonksiyonlar / Functions: `lower_snake_case`

```bash
# Global
VERSION="5.2.0"
LOG_FILE="/var/log/app.log"

# Local (fonksiyon içinde / inside function)
my_function() {
    local temp_file
    local counter=0
}
```

---

## 💬 Commit Mesaj Formatı / Commit Message Format

[Conventional Commits](https://www.conventionalcommits.org/) formatını kullanıyoruz:

```
type(scope): description

[optional body]

[optional footer]
```

### Type Değerleri / Type Values

| Type | Açıklama | Description |
|------|----------|-------------|
| `feat` | Yeni özellik | New feature |
| `fix` | Bug düzeltme | Bug fix |
| `docs` | Dokümantasyon | Documentation only |
| `style` | Kod formatı (işlevsel değişiklik yok) | Code style (no functional change) |
| `refactor` | Kod yeniden yapılandırma | Code refactoring |
| `test` | Test ekleme/düzeltme | Adding/fixing tests |
| `chore` | Build, CI, bağımlılık güncellemeleri | Build, CI, dependency updates |

### Scope Değerleri / Scope Values

| Scope | Açıklama / Description |
|-------|------------------------|
| `apt` | APT paket yöneticisi |
| `dnf` | DNF paket yöneticisi |
| `pacman` | Pacman paket yöneticisi (Arch) |
| `zypper` | Zypper paket yöneticisi (openSUSE) |
| `apk` | APK paket yöneticisi (Alpine) |
| `flatpak` | Flatpak güncellemeleri |
| `snap` | Snap güncellemeleri |
| `fwupd` | Firmware güncelleme |
| `install` | Kurulum scripti |
| `ci` | CI/CD workflow |
| `config` | Yapılandırma dosyaları |
| `docs` | Dokümantasyon |
| `test` | Test dosyaları |

### Örnekler / Examples

```bash
# Yeni özellik / New feature
feat(apk): add Alpine Linux package manager support

# Bug düzeltme / Bug fix
fix(pacman): resolve orphan package detection issue

# Dokümantasyon / Documentation
docs(readme): update BigFive support information

# CI güncellemesi / CI update
chore(ci): add Alpine to test matrix

# Refactoring
refactor(logging): consolidate print functions
```

---

## 📦 Sürüm Yönetimi / Version Management

Bu projede **iki ayrı versiyon sistemi** kullanılmaktadır:

This project uses **two separate version systems**:

### 1. Ana Script (guncel) - SemVer

**Format:** `MAJOR.MINOR.PATCH` (örn: 5.2.0)

| Segment | Ne Zaman Artırılır / When to Increment |
|---------|----------------------------------------|
| MAJOR | Geriye uyumsuz API değişiklikleri / Breaking changes |
| MINOR | Geriye uyumlu yeni özellikler / New features |
| PATCH | Geriye uyumlu bug düzeltmeleri / Bug fixes |

**Güncelleme Sıklığı / Update Frequency:** Her özellik veya fix'te / Every feature or fix

```bash
# guncel içinde / in guncel
VERSION="5.2.0"
CODENAME="BigFive"
```

### 2. Kurulum Scripti (install.sh) - Night Version

**Format:** `Night-Vx.x.x` (örn: Night-V1.1.0)

**Güncelleme Sıklığı / Update Frequency:** Sadece kurulum mantığı değiştiğinde / Only when install logic changes

```bash
# install.sh içinde / in install.sh
# ARCB Updater Installer Night-V1.1.0
```

### Neden Ayrı Sistemler? / Why Separate Systems?

| Sebep / Reason | Açıklama / Description |
|----------------|------------------------|
| **Farklı Değişim Hızları** | Ana script sık güncellenir, installer nadiren değişir |
| **Different Change Rates** | Main script updates often, installer rarely changes |
| **Bağımsız Takip** | Installer değişikliklerini ayrı izlemek daha kolay |
| **Independent Tracking** | Easier to track installer changes separately |

---

## 🚀 Release Oluşturma / Creating Releases

### release.sh Kullanımı / Using release.sh

```bash
# Patch release (bug fix): 5.2.0 → 5.2.1
./release.sh patch

# Minor release (new feature): 5.2.0 → 5.3.0
./release.sh minor

# Major release (breaking change): 5.2.0 → 6.0.0
./release.sh major

# Manuel versiyon / Manual version: → 5.2.5
./release.sh 5.2.5

# Otomatik onay / Auto-confirm (CI için)
./release.sh patch -y
```

### release.sh Ne Yapar? / What does release.sh do?

1. `guncel` dosyasındaki VERSION'ı günceller / Updates VERSION in guncel
2. Git commit oluşturur / Creates git commit
3. Git tag oluşturur / Creates git tag
4. GitHub'a push eder / Pushes to GitHub
5. GitHub Actions GPG ile imzalar / GitHub Actions signs with GPG

### Versiyon Güncelleme Checklist

- [ ] `guncel` içinde `VERSION` ve `CODENAME` güncelle
- [ ] `CHANGELOG.md`'ye entry ekle
- [ ] `SHA256SUMS` dosyasını güncelle (otomatik - GitHub Actions)
- [ ] (Gerekirse) `install.sh` versiyonunu güncelle

---

## 🧪 Test Senaryoları / Test Scenarios

### 1. ShellCheck Lint

```bash
shellcheck -x guncel install.sh release.sh
```

### 2. Bash Syntax Check

```bash
bash -n guncel
bash -n install.sh
bash -n release.sh
```

### 3. BATS Unit Tests

```bash
# Tüm testleri çalıştır / Run all tests
bats tests/*.bats

# Verbose çıktı / Verbose output
bats --tap tests/*.bats

# Sadece guncel testleri / Only guncel tests
bats tests/guncel.bats

# Sadece install testleri / Only install tests
bats tests/install.bats
```

### 4. Dry-Run Testi / Dry-Run Test

```bash
# Root olmadan (hata vermeli) / Without root (should error)
./guncel --dry-run

# Root ile / With root
sudo ./guncel --dry-run
```

### 5. Help Çıktı Kontrolü / Help Output Check

```bash
./guncel --help
# Çıktıda şunlar olmalı / Should contain:
# - VERSION ve CODENAME
# - Tüm seçenekler (--auto, --verbose, --quiet, --dry-run, --skip, --only)
# - Örnekler / Examples
```

### 6. Docker Multi-Distro Test

```bash
# Ubuntu test
docker run --rm -v "$(pwd):/app" ubuntu:24.04 bash -c "apt-get update && apt-get install -y curl && bash /app/install.sh && guncel --help"

# Fedora test
docker run --rm -v "$(pwd):/app" fedora:40 bash -c "dnf install -y curl && bash /app/install.sh && guncel --help"

# Arch test
docker run --rm -v "$(pwd):/app" archlinux:latest bash -c "pacman -Sy --noconfirm curl && bash /app/install.sh && guncel --help"

# openSUSE test
docker run --rm -v "$(pwd):/app" opensuse/tumbleweed:latest bash -c "zypper install -y curl gawk && bash /app/install.sh && guncel --help"

# Alpine test
docker run --rm -v "$(pwd):/app" alpine:3.20 sh -c "apk add bash curl && bash /app/install.sh && guncel --help"
```

### Test Status / Test Durumu

| Component | Tests | Status |
|-----------|-------|--------|
| guncel.bats | 60 | ✅ |
| install.bats | 35 | ✅ |
| **Total** | **95** | ✅ |

---

## 🔄 PR Süreci / PR Process

### Branch Naming Convention

```
type/short-description
```

**Örnekler / Examples:**
- `feat/alpine-support`
- `fix/pacman-orphan-detection`
- `docs/bigfive-readme`
- `chore/ci-alpine-matrix`

### PR Oluşturma Adımları / PR Creation Steps

1. **Fork & Clone**
   ```bash
   git clone git@github.com:YOUR_USERNAME/arcb-wider-updater.git
   cd arcb-wider-updater
   ```

2. **Feature Branch Oluştur / Create Feature Branch**
   ```bash
   git checkout -b feat/my-feature
   ```

3. **Değişiklikleri Yap & Test Et / Make Changes & Test**
   ```bash
   # Kod değişiklikleri / Code changes
   shellcheck -x guncel install.sh
   bash -n guncel
   bats tests/*.bats
   ./guncel --help
   ```

4. **Commit & Push**
   ```bash
   git add -A
   git commit -m "feat(scope): description"
   git push origin feat/my-feature
   ```

5. **PR Aç / Open PR**
   - Base: `main`
   - Compare: `feat/my-feature`

### PR Review Checklist

- [ ] ShellCheck hatasız geçiyor / ShellCheck passes
- [ ] `bash -n` syntax check başarılı / Syntax check passes
- [ ] `bats tests/*.bats` testler geçiyor / Tests pass
- [ ] `--help` çıktısı güncel / Help output updated
- [ ] `--dry-run` çalışıyor / Dry-run works
- [ ] CHANGELOG.md güncellendi (gerekirse) / CHANGELOG updated if needed
- [ ] Commit mesajları conventional format'ta / Commits follow convention

---

## 📋 Komut Satırı Seçenekleri / Command Line Options

Script şu flag'leri destekler / Script supports these flags:

| Flag | Açıklama | Description |
|------|----------|-------------|
| `--auto` | Otomatik mod - soru sormaz | Automatic mode - no prompts |
| `--verbose` | Detaylı çıktı | Verbose output |
| `--quiet` | Sessiz mod - sadece hata ve özet | Quiet mode - errors and summary only |
| `--dry-run` | Kuru çalıştırma - değişiklik yapmaz | Dry run - no changes made |
| `--skip <backend>` | Belirtilen backend'leri atla | Skip specified backends |
| `--only <backend>` | Sadece belirtilen backend'leri çalıştır | Run only specified backends |
| `--uninstall` | Aracı kaldır | Uninstall the tool |
| `--uninstall --purge` | Aracı ve config/log'ları kaldır | Remove with config/logs |
| `--help` | Yardım mesajı | Help message |

### Backend Değerleri / Backend Values

| Backend | Açıklama / Description |
|---------|------------------------|
| `system` | Tüm paket yöneticileri / All package managers |
| `apt` | APT (Debian/Ubuntu) |
| `dnf` | DNF (Fedora/RHEL) |
| `pacman` | Pacman (Arch) |
| `zypper` | Zypper (openSUSE) |
| `apk` | APK (Alpine) |
| `flatpak` | Flatpak |
| `snap` | Snap |
| `fwupd` | Firmware |
| `snapshot` | Timeshift/Snapper |

### Test Ederken / When Testing

```bash
# Tüm modları test et / Test all modes
sudo ./guncel --verbose
sudo ./guncel --quiet
sudo ./guncel --dry-run
sudo ./guncel --skip flatpak,snap
sudo ./guncel --only system
sudo ./guncel --only pacman    # Arch Linux
sudo ./guncel --only apk       # Alpine Linux
```

---

## 📞 İletişim / Contact

Sorularınız için issue açabilir veya PR'da yorum bırakabilirsiniz.

For questions, open an issue or leave a comment on your PR.

- **GitHub Issues:** [arcb-wider-updater/issues](https://github.com/ahm3t0t/arcb-wider-updater/issues)
- **Email:** ahmet@tanrikulu.net
