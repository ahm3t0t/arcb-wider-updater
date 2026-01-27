# Security Policy

## Supported Versions

| Version | Security Updates | Status |
|---------|-----------------|--------|
| v4.1.0+ | Yes | ✅ Active |
| v4.0.x  | Limited | 🟡 Critical only |
| v3.x    | No | ⚠️ Deprecated |

Only the **main** branch is actively maintained and supported.

## Reporting a Vulnerability

If you discover a security vulnerability, please report it **responsibly** and **privately**.

### Preferred Methods (in order):
1. 📧 **Email:** meet@calmkernel.tr
2. 🔒 **GitHub Security Advisory:** [Report a vulnerability](https://github.com/ahm3t0t/arcb-wider-updater/security/advisories/new)
3. 📋 **GitHub Issue (Public):** Use `security` label only after fix is discussed

### What to Include:
- Description of the vulnerability
- Steps to reproduce (if applicable)
- Potential impact
- Your suggested fix (if any)

**Timeline:** We aim to acknowledge reports within 48 hours and provide updates on progress.

Please avoid sharing sensitive details publicly before a fix is available. Thank you for helping keep ARCB secure! 🙏

---

## 🔐 Release Signature Verification (v4.1.0+)

From **v4.1.0 onwards**, all releases are **cryptographically signed with GPG**.

### Why Sign Releases?
- ✅ Proves releases come from official maintainer
- ✅ Detects tampering or man-in-the-middle attacks
- ✅ Ensures file integrity (SHA256SUMS)
- ✅ Industry standard security practice

### Quick Verification

#### Step 1: Import Public Key
```bash
# Import GPG key from GitHub
curl -fsSL https://github.com/ahm3t0t.gpg | gpg --import

# Verify key fingerprint
gpg --list-keys ahmet@tanrikulu.net
````
