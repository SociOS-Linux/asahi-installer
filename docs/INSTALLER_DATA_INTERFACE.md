# Installer Data Interface

## Purpose
This note defines the external data boundary consumed by `SociOS-Linux/asahi-installer`.

The installer should keep Apple Silicon bootstrap logic here, while install profiles, payload references, pins, and hashes move into a dedicated data repository.

## Current runtime boundary

The packaged installer invokes `main.py`, which:
- loads `installer_data.json`
- logs `INSTALLER_BASE`, `INSTALLER_DATA`, `REPO_BASE`, and `IPSW_BASE`
- selects OS templates and payloads from external data

`OSInstaller.load_package()` resolves package payloads from:
- `REPO_BASE + /os/<package>` when set
- local `./os/<package>` otherwise

## Required installer data concepts

A SourceOS Apple Silicon installer-data repository should provide:

### 1. Installer catalog
A machine-readable `installer_data.json` containing at minimum:
- `os_list`
- install templates and default names
- supported firmware/boot profile metadata

### 2. OS template fields
Each install template should define:
- `name`
- `default_os_name`
- `package` (optional payload archive reference)
- `boot_object`
- `next_object` (optional)
- `supported_fw` (optional)
- `partitions`

### 3. Partition template fields
Each partition entry should define:
- `name`
- `size`
- `type`

Optional fields currently consumed by the installer:
- `expand`
- `format`
- `image`
- `source`
- `copy_firmware`
- `copy_installer_data`
- `volume_id`

### 4. Payload repository layout
Expected payload roots:
- `os/` for OS package archives
- firmware payloads referenced by install templates
- boot assets referenced by `boot_object` / `next_object`

## Ownership split

### `SociOS-Linux/asahi-installer`
Owns:
- macOS/APFS/bootstrap/recovery/bless logic
- installer packaging
- execution of install templates

### Proposed `SociOS-Linux/asahi-installer-data`
Owns:
- `installer_data.json`
- install templates
- payload references and pins
- hashes / provenance for payloads
- SourceOS profile variants for Apple Silicon

## Rule

If a change is about Apple Silicon install flow or recovery behavior, it belongs in `asahi-installer`.
If a change is about which OS profiles, payloads, pins, hashes, or SourceOS variants are offered, it belongs in installer data.
