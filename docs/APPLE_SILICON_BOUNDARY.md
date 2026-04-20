# Apple Silicon Bootstrap Boundary

`SociOS-Linux/asahi-installer` is the Apple Silicon bootstrap lane for SourceOS / SociOS on M2/M4 systems.

It owns:
- macOS-side system interrogation and boot-state detection
- APFS / disk / partition planning and execution
- install-time eligibility checks
- stub macOS creation and recovery handoff
- IPSW / firmware preparation
- reduced-security / bless sequencing
- installer packaging

It does not own:
- generic runner/adapters
- generic workspace materialization
- cross-distro package catalog or mirror orchestration
- desktop theming canon

Adjacent repositories:
- `SourceOS-Linux/sourceos-spec` for normative contracts
- `SociOS-Linux/asahi-u-boot` for Apple Silicon boot chain
- proposed `SociOS-Linux/asahi-installer-data` for installer metadata and payload catalog
- proposed `SociOS-Linux/workstation-contracts` for generic runner/adapters/workspace/CI
