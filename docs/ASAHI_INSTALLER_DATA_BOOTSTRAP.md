# asahi-installer-data Bootstrap Outline

## Purpose
This note defines the minimum bootstrap shape for a future `SociOS-Linux/asahi-installer-data` repository.

The goal is to externalize install profiles, payload references, pins, and hashes while keeping Apple Silicon bootstrap flow in `SociOS-Linux/asahi-installer`.

## Initial repository shape

```text
asahi-installer-data/
  installer_data.json
  os/
    <payload archives or references>
  boot/
    <boot objects or references>
  firmware/
    <firmware manifests or references>
  docs/
    PROFILES.md
    HASH_POLICY.md
    PROVENANCE.md
```

## Required top-level artifacts

### `installer_data.json`
Must define at minimum:
- `os_list`
- install template names
- `default_os_name`
- partition templates
- `boot_object`
- `next_object` (optional)
- `supported_fw` (optional)
- payload references for `package`, `image`, or `source`

### `os/`
Contains or references OS package payloads resolved by installer templates.

### `boot/`
Contains or references boot objects used by template handoff.

### `firmware/`
Contains firmware manifests and provenance metadata when firmware payloads are copied during install.

## Policy expectations

Each payload entry should eventually carry:
- source URL or upstream ref
- pin (tag / commit / version)
- sha256 or equivalent integrity hash
- license identifier
- provenance notes

## Ownership split

### `SociOS-Linux/asahi-installer`
Owns:
- runtime bootstrap flow
- macOS / APFS / recovery / bless behavior
- installer packaging

### `SociOS-Linux/asahi-installer-data`
Owns:
- install profile catalog
- payload references and pins
- hashes / provenance metadata
- SourceOS Apple Silicon variants

## Rule

If a change is about *how Apple Silicon install executes*, it belongs in `asahi-installer`.
If a change is about *which payloads, profiles, pins, or variants are offered*, it belongs in installer data.
