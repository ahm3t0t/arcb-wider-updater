# BigFive Updater v6.5.0 - Kapsamli Denetim Raporu

**Tarih:** 2026-02-06
**Versiyon:** v6.5.0 "Fluent Edition India"
**Arac:** Claude Code (Opus 4.6) - 4 paralel alt ajan

---

## Calisma Yontemi

### Kullanilan Ajanlar

| # | Ajan | Model | Sure | Token | Tool Cagri |
|---|------|-------|------|-------|------------|
| 1 | Kod Tarayici (Explore) | Opus 4.6 | ~231s | 158K | 56 |
| 2 | Dokumantasyon Tarayici (Explore) | Opus 4.6 | ~182s | 132K | 58 |
| 3 | Guvenlik Denetcisi (security-auditor) | Sonnet 4.5 | ~161s | 76K | 39 |
| 4 | Shell Inceleyici (shell-reviewer) | Sonnet 4.5 | ~69s | 76K | 36 |

### Taranan Dosyalar

**Kod dosyalari:**
- `guncel` (2618 satir, 52 fonksiyon)
- `install.sh` (491 satir)
- `release.sh` (353 satir)
- `tests/guncel.bats` (714 satir, ~90 test)
- `tests/install.bats` (217 satir, ~30 test)
- `tests/test_helper.bash` (46 satir)
- `tests/docker/run-tests.sh`, `quick-test.sh`, `build-base-images.sh`
- `docker-test-all.sh`
- `completions/guncel.bash`, `_guncel` (zsh), `guncel.fish`
- `lang/tr.sh`, `lang/en.sh`
- `packaging/rpm/bigfive-updater.spec`
- `packaging/aur/PKGBUILD`
- `packaging/alpine/APKBUILD`
- `packaging/alpine-repo/setup-key.sh`
- `.copr/Makefile`
- `logrotate.d/bigfive-updater`

**CI/CD workflow dosyalari (10 adet):**
- `.github/workflows/ci.yml`
- `.github/workflows/test.yml`
- `.github/workflows/release.yml`
- `.github/workflows/security.yml`
- `.github/workflows/packages.yml`
- `.github/workflows/copr.yml`
- `.github/workflows/aur.yml`
- `.github/workflows/alpine-repo.yml`
- `.github/workflows/docker-base-images.yml`
- `.github/dependabot.yml`

**Dokumantasyon dosyalari (28 adet):**
- README.md, README.en.md, README.tr.md
- CHANGELOG.en.md, CHANGELOG.tr.md
- ROADMAP.md, ROADMAP.en.md, ROADMAP.tr.md
- CONTRIBUTING.md, CONTRIBUTING.en.md, CONTRIBUTING.tr.md
- SECURITY.md, SECURITY.en.md, SECURITY.tr.md
- CODE_OF_CONDUCT.md, CODE_OF_CONDUCT.en.md, CODE_OF_CONDUCT.tr.md
- LICENSE
- docs/guncel.8, docs/guncel.8.tr, docs/guncel.8.md
- .github/PULL_REQUEST_TEMPLATE.md
- .github/ISSUE_TEMPLATE/bug_report.md, feature_request.md, config.yml
- .github/CODEOWNERS
- packaging/*/README.md (3 adet)
- tests/docker/README.md

---

## Bulgular

### A. Versiyon Tutarsizliklari

`guncel` scripti VERSION="6.5.0" ama diger dosyalar eski versiyonlarda kalmis:

| Dosya | Mevcut | Olmasi Gereken |
|-------|--------|----------------|
| `packaging/rpm/bigfive-updater.spec` | 6.4.0 | 6.5.0 |
| `packaging/aur/PKGBUILD` | 6.4.0 | 6.5.0 |
| `packaging/alpine/APKBUILD` | 6.4.0 | 6.5.0 |
| `lang/tr.sh` (yorum satiri) | 6.2.0 | 6.5.0 |
| `lang/en.sh` (yorum satiri) | 6.2.0 | 6.5.0 |
| `install.sh` satir 184 (banner) | Night-V1.4.2 | Night-V1.4.3 |
| `docs/guncel.8` (troff EN) | 6.1.0 | 6.5.0 |
| `docs/guncel.8.tr` (troff TR) | 6.1.0 | 6.5.0 |

### B. Shell Completion Eksiklikleri

Tum 3 completion dosyasinda `--security-only` ve `--jitter` secenekleri eksik:
- `completions/guncel.bash`
- `completions/_guncel` (zsh)
- `completions/guncel.fish`

### C. i18n Eksik Anahtarlar

`lang/en.sh` dosyasinda v6.3.0+ ile eklenen ~15 i18n anahtari eksik.
Ingilizce kullanicilar bu mesajlari Turkce olarak goruyor (hardcoded default):

```
MSG_INFO_JITTER, MSG_WARN_CONTAINER, MSG_HINT_CONTAINER
MSG_INFO_DISK_OK, MSG_ERR_LOW_DISK, MSG_HINT_LOW_DISK
MSG_WARN_DISK_CHECK_FAIL, MSG_INFO_SECURITY_ONLY
MSG_WARN_SECURITY_APT, MSG_WARN_SECURITY_PACMAN, MSG_WARN_SECURITY_APK
MSG_HOOK_RUNNING, MSG_HOOK_FAILED, MSG_HOOK_COMPLETE
MSG_ERR_SUDO_NOPASSWD, MSG_HINT_SUDO_NOPASSWD
MSG_HELP_OPT_JITTER, MSG_HELP_OPT_SECURITY, MSG_HELP_EX_SECURITY
```

### D. Man Page Sorunlari

- `docs/guncel.8` ve `docs/guncel.8.tr` v6.1.0'da kalmis
- `--jitter`, `--security-only`, hooks, notifications bolumleri eksik
- URL'ler `ahm3t0t` organizasyonunu gosteriyor, `CalmKernelTR` olmali
- `docs/guncel.8.md` (kaynak) guncel (6.5.0) ama derlenmus troff dosyalari eski

### E. GitHub URL Tutarsizligi

- `guncel` satir 6, 20-23: `ahm3t0t/bigfive-updater`
- `install.sh` satir 18, 23: `CalmKernelTR/bigfive-updater`
- `guncel` satir 24 (pubkey): `CalmKernelTR/bigfive-updater`

Self-update `ahm3t0t`'tan indiriyor, install.sh `CalmKernelTR`'den indiriyor.

### F. Kod Kalitesi Sorunlari

1. **Unquoted `$dnf_cmd` ve `$zypper_cmd`** (satir 1726, 1728, 1874) -- word splitting riski
2. **`check_connectivity` her zaman 0 donduruyor** -- dead code path (satir 2568-2572)
3. **`total_updates` sayisal sanitizasyon yok** (satir 2607) -- set -e altinda crash riski
4. **`pacman -Sy` without `-u`** (satir 1770) -- partial upgrade riski
5. **Self-update exec dongusu korumasi yok** (satir 1437)
6. **`do_history` BusyBox/Alpine `date -d` uyumsuz** (satir 1096)
7. **JSON output hostname/distro escape etmiyor** (satir 644, 705-706)
8. **`JITTER_MAX` ust sinir validasyonu yok** (satir 2430)

### G. Guvenlik Bulgulari

- **0 Critical, 0 High** guvenlik acigi
- **Medium:**
  - chmod 777 CI/CD workflow'larinda (alpine-repo.yml:40, packages.yml:73)
  - Hook script ownership validasyonu eksik
  - TOCTOU risk install.sh temp dosya (mktemp vs safe_mktemp)
  - Secret rotation dokumantasyonu eksik
- **Low:**
  - Notification URL validasyonu eksik
  - Pipe-to-bash install pattern (mitigation: GPG verification)
  - GPG keyring izolasyonu iyilestirilebilir

### H. Dokumantasyon Senkronizasyon Sorunlari

1. **ROADMAP.en.md + ROADMAP.tr.md:** v6.3.1-v6.5.0 tamamen eksik, codename "Chrom" yanlis
2. **SECURITY.en.md + SECURITY.tr.md:** v5.x "Active" diyor, v6.x olmali
3. **CODEOWNERS:** "ARCB Wider Updater" (eski proje adi)
4. **README CLI options tablosu:** --doctor, --history, --jitter, --security-only eksik
5. **PR Template:** CHANGELOG.md referansi var ama gercek dosya CHANGELOG.en.md/tr.md
6. **README.tr.md:** EN versiyondan ~320 satir daha kapsamli (FAQ, Troubleshooting eksik EN'de)
7. **CONTRIBUTING:** iletisim emaili tutarsiz (ahmet@tanrikulu.net vs meet@calmkernel.tr)
8. **bug_report.md:** Versiyon ornegi "3.7.1" (cok eski)
9. **ROADMAP.md:** Test sayisi tablosu 131/170 (134/173 olmali), codename tablosunda v6.5.0 eksik

### I. CI/CD Sorunlari

1. ci.yml ve test.yml ayni BATS testlerini tekrarliyor (CI dakika israfi)
2. ci.yml matrix'te `ghcr_image` tanimli ama kullanilmiyor (dead config)
3. TruffleHog `@main` branch'e pinlenmis (supply chain riski)
4. AUR workflow .SRCINFO leading whitespace sorunu
5. COPR workflow heredoc indentation config dosyasini bozabilir
6. Alpine build `|| true` hata yutma (packages.yml:96)
7. alpine-repo.yml default versiyon 6.0.2 (stale)

### J. Test Eksiklikleri

Mevcut: 173 BATS, %15.8 Codecov. Cogu test grep-tabanli (statik).

Eksik test senaryolari:
- `--json`/`--json-full` cikti validasyonu
- `--verbose`/`--quiet` cakisma testi
- `--jitter` ve `--security-only` flag testleri
- Notification ve hooks fonksiyonalitesi
- `safe_source`, `safe_mktemp`, `json_escape` unit testleri
- `check_disk_space` ve container detection testleri
- `test_helper.bash` 4 fonksiyon tanimli ama hic kullanilmiyor (dead code)

### K. Packaging Eksiklikleri

1. RPM spec `/usr/bin/` kuruyor ama doctor `/usr/local/bin/` kontrol ediyor
2. RPM spec Turkce man page ve man page symlink eksik
3. RPM spec 6.5.0 changelog entry eksik
4. PKGBUILD logrotate config kurulumu eksik
5. PKGBUILD ve APKBUILD hooks dizini olusturmuyor
6. APKBUILD `sha512sums="SKIP"` (gercek checksum olmali)

### L. Pozitif Bulgular

**Guvenlik (14+ kontrol):**
- `set -Eeuo pipefail` + `umask 0077`
- `safe_source()` (ownership + world-writable kontrol)
- `safe_mktemp()` (guvenli temp dosya)
- GPG imza dogrulama (izole keyring, 30s timeout)
- TLS 1.2+ zorunlu (curl + wget)
- SHA256 checksum validasyonu
- flock tabanli kilitleme
- Log dosyasi izinleri (chmod 600/700)
- Disk alani kontrolu, container ortami tespiti

**Kod Kalitesi:**
- ShellCheck: 3 script, 0 uyari
- 52 fonksiyon, temiz sorumluluk ayrimi
- snake_case fonksiyon adlandirma (Google Shell Style uyumlu)
- 2-space indentation tutarli

---

## Duzeltme Plani (Kolaydan Zora)

### Adim 1: Tek satirlik versiyon guncellemeleri (~5 dk)

```
Prompt: install.sh satir 184'te Night-V1.4.2 yi Night-V1.4.3 yap.
lang/tr.sh ve lang/en.sh satir 4'teki yorum versiyonunu 6.5.0 Fluent Edition India yap.
CODEOWNERS'daki "ARCB Wider Updater" yi "BigFive Updater" yap.
alpine-repo.yml satir 11'deki default versiyonu 6.5.0 yap.
bug_report.md'deki versiyon ornegini 6.5.0 yap.
PR Template'deki CHANGELOG.md referansini CHANGELOG.en.md / CHANGELOG.tr.md yap.
```

### Adim 2: Shell completion guncelleme (~10 dk)

```
Prompt: completions/guncel.bash, completions/_guncel (zsh), completions/guncel.fish
dosyalarinin hepsine --security-only ve --jitter seceneklerini ekle.
Versiyon yorumlarini v6.4.0+ olarak guncelle.
```

### Adim 3: Packaging dosyalari 6.5.0 guncelleme (~15 dk)

```
Prompt: packaging/rpm/bigfive-updater.spec Version'i 6.5.0 yap,
6.5.0-1 changelog entry ekle.
packaging/aur/PKGBUILD pkgver=6.5.0 yap.
packaging/alpine/APKBUILD pkgver=6.5.0 yap.
RPM spec'e Turkce man page kurulumu ve man page symlink ekle.
PKGBUILD'e logrotate config kurulumu ekle.
PKGBUILD ve APKBUILD'e hooks dizini olusturma ekle.
```

### Adim 4: lang/en.sh eksik i18n anahtarlari (~15 dk)

```
Prompt: guncel scriptinde ${MSG_..:-Turkce default} paterni ile kullanilan
ama lang/en.sh'da tanimlanmamis tum i18n anahtarlarini bul.
Her birinin Ingilizce cevirisini lang/en.sh'a ekle.
Ayni sekilde lang/tr.sh'a da dogru Turkce karsiligini ekle
(guncel'deki hardcoded default'lardan al).
```

### Adim 5: Man page derleme (~10 dk)

```
Prompt: docs/guncel.8.md (markdown kaynak, guncel v6.5.0) dosyasindan
docs/guncel.8 (EN troff) ve docs/guncel.8.tr (TR troff) dosyalarini
yeniden olustur. URL'leri CalmKernelTR olarak guncelle.
Tum v6.1.0 referanslarini v6.5.0 yap.
```

### Adim 6: Guvenlik duzeltmeleri (~10 dk)

```
Prompt: alpine-repo.yml ve packages.yml'daki chmod 777'leri chmod 755 + chown yap.
guncel'deki run_hooks fonksiyonuna hook script ownership kontrolu ekle
(root owned, not world-writable - safe_source ile ayni pattern).
security.yml'daki trufflesecurity/trufflehog@main'i spesifik commit SHA'ya pinle.
```

### Adim 7: Kod kalitesi duzeltmeleri (~20 dk)

```
Prompt: guncel'de su duzeltmeleri yap:
1. $dnf_cmd ve $zypper_cmd'yi array'e cevir ve quoted kullan
2. check_connectivity fonksiyonunun connectivity_failed durumunda
   0 degil 1 dondurmesini sagla
3. total_updates hesabina sayisal sanitizasyon ekle (tr -cd '0-9' pattern)
4. Self-update exec icin re-execution guard ekle (BIGFIVE_REEXEC env var)
5. JSON output'ta hostname ve distro degerlerini json_escape() ile escape et
```

### Adim 8: Dokumantasyon senkronizasyonu (~30 dk)

```
Prompt: ROADMAP.en.md ve ROADMAP.tr.md dosyalarini ROADMAP.md ile senkronize et.
v6.3.1, v6.4.0, v6.5.0 entrylerini ekle, codename'leri duzelt.
Test sayisi tablosunu 134/173 yap, codename tablosuna v6.5.0 India ekle.
SECURITY.en.md ve SECURITY.tr.md'de v5.x -> v6.x Active yap.
README.en.md ve README.tr.md CLI options tablolarina
--doctor, --history, --jitter, --security-only ekle.
CONTRIBUTING.en.md ve CONTRIBUTING.tr.md'de email adresini birlestir.
```

### Adim 9: CI/CD iyilestirmeleri (~20 dk)

```
Prompt: test.yml workflow'unu incele - ci.yml ile cakisan testleri kaldir
veya test.yml'i sil. ci.yml matrix'teki kullanilmayan ghcr_image'i kaldir.
AUR workflow .SRCINFO heredoc whitespace sorununu duzelt.
COPR workflow heredoc indentation sorununu duzelt.
packages.yml Alpine build || true'yu kaldir, hata kontrolu ekle.
```

### Adim 10: GitHub URL birlestirme (~10 dk)

```
Prompt: guncel scriptindeki ahm3t0t/bigfive-updater URL'lerini
CalmKernelTR/bigfive-updater olarak guncelle (satir 6, 20-23).
Tum dosyalarda ahm3t0t referanslarini tara ve CalmKernelTR ile degistir.
docs/guncel.8 ve docs/guncel.8.tr'deki URL'leri de guncelle.
```

### Adim 11: Test coverage artirma (~45 dk)

```
Prompt: tests/guncel.bats'a su testleri ekle:
- --jitter flag parsing testi
- --security-only flag testi
- --json cikti format validasyonu (jq ile)
- --verbose ve --quiet cakisma hata testi
- safe_source guvenlik testi (world-writable rejection)
- json_escape ozel karakter testi
- check_disk_space testi
test_helper.bash'taki kullanilmayan 4 fonksiyonu kaldir.
```

### Adim 12: Packaging uyumluluk duzeltmeleri (~15 dk)

```
Prompt: RPM spec'te install path sorununu duzelt:
guncel'deki do_doctor /usr/local/bin/guncel kontrol ediyor
ama RPM /usr/bin/guncel'e kuruyor. do_doctor'a her iki path'i
kontrol eden mantik ekle veya whence/which kullan.
APKBUILD'deki sha512sums="SKIP"'i gercek checksum ile degistir.
```

---

## Commit Plani

Her adim icin ayri commit onerisi:

```
Adim 1:  fix: update stale version strings across project
Adim 2:  feat(completions): add --security-only and --jitter options
Adim 3:  fix(packaging): bump all packaging files to v6.5.0
Adim 4:  feat(i18n): add missing English translations for v6.3.0+ messages
Adim 5:  docs(man): regenerate troff man pages from v6.5.0 markdown source
Adim 6:  security: fix chmod 777, add hook ownership validation, pin trufflehog
Adim 7:  fix: address code quality issues (quoting, connectivity, json escape)
Adim 8:  docs: synchronize ROADMAP, SECURITY, README, CONTRIBUTING across languages
Adim 9:  ci: remove duplicate test workflow, fix heredoc whitespace issues
Adim 10: fix: unify GitHub URLs from ahm3t0t to CalmKernelTR
Adim 11: test: add behavioral tests for new flags and security functions
Adim 12: fix(packaging): resolve install path and checksum issues
```

---

## Sonuc

BigFive Updater v6.5.0 **production-quality** bir proje.
0 Critical, 0 High guvenlik acigi tespit edildi.
Ana sorun: v6.5.0 release sonrasi cevresel dosyalarin (packaging, completions,
lang, man pages, docs) senkronize edilmemis olmasi.

12 adimlik plan ile tum sorunlar giderilebilir.
Tahmini toplam sure: ~3-4 saat (tek oturumda veya 2-3 gun icinde).
