<p align="center"><img src="assets/images/logo.svg" width="120" alt="AxiOm logo" /></p>

<h1 align="center">AxiOm</h1>

<p align="center">Multi-platform VPN / proxy client built on the <a href="https://github.com/SagerNet/sing-box">sing-box</a> core.</p>

<p align="center">
  <img alt="Platforms" src="https://img.shields.io/badge/platforms-Android%20%7C%20Windows%20%7C%20Linux%20%7C%20Web-blue?style=flat-square" />
  <img alt="Built with Flutter" src="https://img.shields.io/badge/built%20with-Flutter-02569B?style=flat-square&logo=flutter" />
</p>

---

## About

**AxiOm** is a customized client built on top of the open-source [Hiddify app](https://github.com/hiddify/hiddify-app), which itself wraps the [sing-box](https://github.com/SagerNet/sing-box) universal proxy tool-chain. It supports a wide range of protocols, automatic node selection, TUN mode, and remote profiles.

This repository is a **fork** focused on the AxiOm branding and feature set. iOS and macOS targets from the upstream project have been removed; AxiOm currently targets **Android, Windows, Linux, and Web**.

## Features

- Built on the battle-tested **sing-box** core with broad protocol support.
- Import remote subscription profiles and update them automatically.
- TUN mode (system-wide tunneling) and per-app **split tunneling**.
- **Connected-device count** indicator on the home screen.
- Light/dark theming and multi-language UI.

## Platforms

| Platform | Status |
| --- | --- |
| Android | ✅ `app.axiom.vpn` |
| Windows | ✅ |
| Linux   | ✅ |
| Web     | ✅ |
| iOS / macOS | ❌ removed in this fork |

## Building from source

AxiOm is a Flutter application. You need the Flutter SDK matching the version pinned in [`pubspec.yaml`](pubspec.yaml).

```bash
# Fetch dependencies
flutter pub get

# Run on a connected device / desktop
flutter run

# Build a release APK
flutter build apk --release

# Build a Windows release
flutter build windows --release
```

The [`Makefile`](Makefile) contains the full set of platform build targets used by the upstream project.

### Android signing

Release builds are signed using a keystore that is **not** committed to this repository. Create `android/key.properties` locally:

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=<your-alias>
storeFile=release.jks
```

Place your `release.jks` in `android/app/`. Both files are git-ignored — keep secure backups, as losing the keystore means you can no longer update a published app.

## Credits & license

AxiOm is derived from the following open-source projects — please support and credit the original authors:

- [Hiddify app](https://github.com/hiddify/hiddify-app) — the upstream client this fork is based on.
- [sing-box](https://github.com/SagerNet/sing-box) — the underlying proxy core.

This fork inherits the upstream license. See [LICENSE.md](LICENSE.md) for the full terms, which apply to all derivative work in this repository.

> The original upstream README (with full project background and translations) is preserved in the git history and in the language-specific files such as [README_ru.md](README_ru.md)
