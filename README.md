# DeathAmir iRxVoice

**iRxVoice** is the IRAutoX-branded voice chat distribution for GTA San Andreas multiplayer and open.mp. It provides proximity voice, radio/frequency channels, phone calls, vehicle audio and SampVoice-compatible Pawn APIs.

- **Project:** DeathAmir iRxVoice
- **Repository:** https://github.com/DeathAmir/IRXVOICE
- **Official game server:** `play.irautox.ir:7777`
- **Official IPv4 endpoint:** `5.57.37.122:7777`
- **Official website/domain:** `irautox.ir`

## Implementation and licensing

The current C++ voice engine is based on [Voice Bridge](https://github.com/devbluen/omp-Voice-Bridge), pinned to a known upstream revision as a Git submodule. This is deliberate: it preserves the existing SampVoice network protocol and legacy `Sv*` Pawn API compatibility instead of introducing an incompatible voice protocol. The upstream MIT license and copyright notices are retained. The top-level repository license remains unchanged.

This repository owns the IRAutoX branding, packaging, build workflow, integration examples and distribution. The engine itself is not yet a clean-room rewrite.

## Clone

```bash
git clone --recurse-submodules https://github.com/DeathAmir/IRXVOICE.git
cd IRXVOICE
```

For an existing clone:

```bash
git submodule update --init --recursive
```

## Build (Windows)

Requirements: Visual Studio 2022 with Desktop development with C++, CMake 3.19+, Git and PowerShell.

```powershell
powershell -ExecutionPolicy Bypass -File .\upstream\voice-bridge\build.ps1 -Target all -Package
```

GitHub Actions builds the server and 32-bit GTA client, runs the upstream server tests and publishes the branded artifact **iRxVoice-Windows**. The client package is renamed to **iRxVoice.asi** during CI packaging.

## Install on open.mp

1. Copy `voice-bridge.dll` from the server package into the server's `components/` directory.
2. Copy the supplied Pawn include files into `qawno/include/`.
3. Do not also load the same DLL from `plugins/`; open.mp should load it as a component.
4. Open the voice UDP port reported in the server log (default: game port + 1; for game port 7777 this is normally UDP 7778).
5. Merge the example from `examples/irautox-proximity.pwn` into the gamemode, combining callbacks instead of defining duplicates.
6. Install **iRxVoice.asi** on client PCs. Do not load it alongside another SampVoice/Voice Bridge ASI at the same time.

For SA-MP legacy servers, put the server DLL in `plugins/`, add `voice-bridge` to the `plugins` line, and place includes in `pawno/include/`.

## IRAutoX integration

`examples/irautox-proximity.pwn` demonstrates a local 3D proximity stream with B as push-to-talk. Merge its connect/disconnect and activation-key callbacks into the existing `gungame.pwn` callbacks; do not duplicate them.

The upstream API and Pawn natives are documented at:
- [Voice Bridge API and configuration](https://github.com/devbluen/omp-Voice-Bridge/blob/main/README.md)
- [SampVoice-compatible example](https://github.com/devbluen/omp-Voice-Bridge/blob/main/examples/en/06-sampvoice-compatible.pwn)

## Important: server restriction status

The endpoints above identify the official IRAutoX deployment target. **This branding/build change does not yet cryptographically prevent the client or protocol from being used on another compatible server.** A real exclusive-server lock requires a coordinated server/client authentication change (signed server identity, client verification and server-side rejection), not just renaming the ASI or hardcoding an IP. Do not treat the current package as access-locked until that protocol work is implemented and tested.
