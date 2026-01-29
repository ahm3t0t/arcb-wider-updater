#!/usr/bin/env bats
# BATS Unit Tests for install.sh - ARCB Wider Updater Installer
# Night-V1.1.0

# Path to the install script
INSTALL_SCRIPT="${BATS_TEST_DIRNAME}/../install.sh"

# =============================================================================
# SCRIPT STRUCTURE TESTS
# =============================================================================

@test "install.sh has shebang" {
    head -1 "$INSTALL_SCRIPT" | grep -q '^#!/'
}

@test "install.sh uses bash" {
    head -1 "$INSTALL_SCRIPT" | grep -q 'bash'
}

@test "install.sh passes bash syntax check" {
    bash -n "$INSTALL_SCRIPT"
}

@test "install.sh has version comment" {
    grep -qE 'Night-V[0-9]+\.[0-9]+\.[0-9]+' "$INSTALL_SCRIPT"
}

# =============================================================================
# ERROR HANDLING TESTS
# =============================================================================

@test "install.sh uses strict error handling" {
    grep -q 'set -Eeuo pipefail' "$INSTALL_SCRIPT"
}

@test "install.sh has trap for cleanup" {
    grep -q 'trap.*EXIT' "$INSTALL_SCRIPT"
}

# =============================================================================
# COLOR VARIABLE TESTS
# =============================================================================

@test "RED color variable is defined in install.sh" {
    grep -q '^RED=' "$INSTALL_SCRIPT"
}

@test "GREEN color variable is defined in install.sh" {
    grep -q '^GREEN=' "$INSTALL_SCRIPT"
}

@test "YELLOW color variable is defined in install.sh" {
    grep -q '^YELLOW=' "$INSTALL_SCRIPT"
}

@test "BLUE color variable is defined in install.sh" {
    grep -q '^BLUE=' "$INSTALL_SCRIPT"
}

@test "NC (no color) variable is defined in install.sh" {
    grep -q '^NC=' "$INSTALL_SCRIPT"
}

# =============================================================================
# URL AND PATH TESTS
# =============================================================================

@test "INSTALL_PATH is set to /usr/local/bin/guncel" {
    grep -q 'INSTALL_PATH="/usr/local/bin/guncel"' "$INSTALL_SCRIPT"
}

@test "REPO_URL points to GitHub releases" {
    grep -q 'REPO_URL=.*releases/latest/download/guncel' "$INSTALL_SCRIPT"
}

@test "GPG_PUBKEY_URL is defined" {
    grep -q 'GPG_PUBKEY_URL=' "$INSTALL_SCRIPT"
}

@test "GPG_SHA256SUMS_URL is defined" {
    grep -q 'GPG_SHA256SUMS_URL=' "$INSTALL_SCRIPT"
}

# =============================================================================
# TLS HARDENING TESTS (Night-V1.1.0+)
# =============================================================================

@test "curl uses TLS 1.2+ in install.sh" {
    grep -q "\-\-proto '=https' --tlsv1.2" "$INSTALL_SCRIPT"
}

@test "wget uses TLS 1.2+ in install.sh" {
    grep -q "\-\-secure-protocol=TLSv1_2" "$INSTALL_SCRIPT"
}

@test "download_file function uses TLS hardening in install.sh" {
    awk '/^download_file\(\)/,/^}/' "$INSTALL_SCRIPT" | grep -q "tlsv1.2\|TLSv1_2"
}

# =============================================================================
# GPG VERIFICATION TESTS
# =============================================================================

@test "verify_gpg_signature function exists" {
    grep -qE '^verify_gpg_signature\(\)|^function verify_gpg_signature' "$INSTALL_SCRIPT"
}

@test "GPG signature verification downloads public key" {
    grep -q 'GPG_PUBKEY_URL' "$INSTALL_SCRIPT"
}

@test "GPG signature verification uses gpg --verify" {
    grep -q 'gpg --verify' "$INSTALL_SCRIPT"
}

@test "SHA256 checksum verification exists" {
    grep -q 'sha256sum' "$INSTALL_SCRIPT"
}

# =============================================================================
# FUNCTION EXISTENCE TESTS
# =============================================================================

@test "download_file function exists in install.sh" {
    grep -qE '^download_file\(\)|^function download_file' "$INSTALL_SCRIPT"
}

# =============================================================================
# UPDATER SYMLINK TESTS (Night-V1.1.0+)
# =============================================================================

@test "SYMLINK_PATH is defined for updater alias" {
    grep -q 'SYMLINK_PATH=' "$INSTALL_SCRIPT"
}

@test "Symlink creation uses ln -s" {
    grep -q 'ln -s' "$INSTALL_SCRIPT"
}

@test "Symlink points to guncel" {
    grep -q 'updater.*guncel\|INSTALL_PATH.*SYMLINK_PATH' "$INSTALL_SCRIPT"
}

# =============================================================================
# BACKUP TESTS
# =============================================================================

@test "Backup is created before installation" {
    grep -q '\.bak' "$INSTALL_SCRIPT"
}

@test "Rollback mechanism exists" {
    grep -qE 'rollback|\.bak' "$INSTALL_SCRIPT"
}

# =============================================================================
# LOGROTATE TESTS
# =============================================================================

@test "LOGROTATE_DEST is defined" {
    grep -q 'LOGROTATE_DEST=' "$INSTALL_SCRIPT"
}

@test "Logrotate config installation exists" {
    grep -q 'logrotate' "$INSTALL_SCRIPT"
}

# =============================================================================
# ROOT CHECK TESTS
# =============================================================================

@test "Root privilege check exists" {
    grep -q 'EUID' "$INSTALL_SCRIPT"
}

@test "Sudo elevation is attempted when not root" {
    grep -q 'sudo' "$INSTALL_SCRIPT"
}

# =============================================================================
# VALIDATION TESTS
# =============================================================================

@test "Script validation checks for empty file" {
    grep -qE '\[ ! -s|\[\[ ! -s' "$INSTALL_SCRIPT"
}

@test "Script validation checks for bash shebang" {
    grep -q 'grep.*#!/.*bash' "$INSTALL_SCRIPT"
}

@test "Script validation checks for ARCB signature" {
    grep -q 'ARCB Wider Updater' "$INSTALL_SCRIPT"
}
