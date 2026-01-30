# Docker Multi-Distro Tests

BigFive Updater'ı 5 farklı Linux dağıtımında test etmek için Docker container'ları.

## Desteklenen Dağıtımlar

| Distro | Paket Yöneticisi | Dockerfile |
|--------|------------------|------------|
| Ubuntu 24.04 | APT | Dockerfile.ubuntu |
| Fedora 40 | DNF | Dockerfile.fedora |
| Arch Linux | Pacman | Dockerfile.arch |
| openSUSE TW | Zypper | Dockerfile.opensuse |
| Alpine 3.20 | APK | Dockerfile.alpine |

## Kullanım

```bash
# Tek distro test et (dry-run)
./run-tests.sh ubuntu

# Tüm distroları test et
./run-tests.sh all

# Gerçek güncelleme testi
./run-tests.sh fedora --update

# Sadece image'ları build et
./run-tests.sh all --build
```

## Manuel Test

```bash
# Repo kökünden çalıştır
cd /path/to/bigfive-updater

# Image build et
docker build -f tests/docker/Dockerfile.ubuntu -t bigfive-test-ubuntu .

# Container'da test et
docker run --rm -e SELF_UPDATE_DISABLED=true bigfive-test-ubuntu \
    bash -c "chmod +x guncel && ./guncel --dry-run"
```

## Notlar

- `SELF_UPDATE_DISABLED=true` GitHub'dan güncelleme indirmesini engeller
- Testler repo kökünden build edilir, dosyalar container'a kopyalanır
- `--update` modu gerçek paket güncellemesi yapar (onay gerektirir)
