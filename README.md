# IRXVOICE

IRXVOICE packages a C++ voice server component/plugin and a GTA San Andreas client mod for the IRAutoX open.mp server.

## Compatibility choice

The implementation is based on [Voice Bridge](https://github.com/devbluen/omp-Voice-Bridge), pinned as a Git submodule at a known upstream commit. This is intentional: Voice Bridge already implements the SampVoice wire/API compatibility layer, including the legacy `Sv*` Pawn natives. Reimplementing that protocol independently would risk incompatibility with existing SampVoice clients.

- Server: open.mp component and SA-MP plugin.
- Client: `voice-bridge.asi` for SA-MP 0.3.7 R1/R2/R3/R4/R5 and 0.3.DL.
- Legacy clients: existing `sampvoice.asi` clients are accepted when enabled by server configuration.
- Legacy gamemodes: `#include <sampvoice>` can continue using the compatibility include shipped by the server package.
- Source: C++17, with the upstream source kept in `upstream/voice-bridge`.

The upstream code is MIT licensed. Its copyright and LICENSE file are retained in the submodule. IRXVOICE's top-level LICENSE remains the repository's existing GPL-3.0 license; the submodule keeps its separate license.

## Get the source

Clone with submodules:

```bash
git clone --recurse-submodules https://github.com/DeathAmir/IRXVOICE.git
cd IRXVOICE
```

If already cloned:

```bash
git submodule update --init --recursive
```

## Build locally (Windows)

Requirements: Visual Studio 2022 with Desktop development with C++, CMake 3.19+, Git, and PowerShell.

```powershell
powershell -ExecutionPolicy Bypass -File .\upstream\voice-bridge\build.ps1 -Target all -Package
```

The script builds the server plugin/component and 32-bit GTA client, runs upstream server tests, and collects packages under:

- `upstream/voice-bridge/dist/server/`
- `upstream/voice-bridge/dist/client/`

GitHub Actions runs this build on pushes, pull requests, and manual dispatch. Download the `IRXVOICE-Windows` workflow artifact after a successful run.

## Install on open.mp

1. Copy `voice-bridge.dll` from the server package into the server's `components/` directory.
2. Copy the supplied `.inc` files into `qawno/include/`.
3. Do not also load the same DLL from `plugins/`; open.mp should load it as a component.
4. Open the voice UDP port shown in the server log (default is game port + 1).
5. Add the Pawn integration from `examples/irautox-proximity.pwn` to the gamemode, merging callbacks rather than defining duplicate callbacks.
6. Players install either `voice-bridge.asi` or keep their compatible `sampvoice.asi`. Do not load both clients simultaneously.

For SA-MP legacy servers, place the DLL in `plugins/`, add `voice-bridge` to the `plugins` line, and copy includes to `pawno/include/`.

## Existing SampVoice gamemodes and clients

The server package contains `sampvoice.inc`, a compatibility include. Existing SampVoice Pawn scripts can use the old `Sv*` API without being rewritten. The server can accept both SampVoice and Voice Bridge clients; see the upstream `voice_allow_sampvoice` and `voice_allow_voicebridge` settings.

The newer Voice Bridge client supports the same server and also has an in-game F11 settings menu. If a player keeps `sampvoice.asi`, they do not need `voice-bridge.asi`.

## IRAutoX integration

See `examples/irautox-proximity.pwn` for the minimal proximity channel. It uses B as push-to-talk and creates one dynamic 3D stream per player. Merge its lifecycle and activation callbacks into `gungame.pwn`; do not duplicate callbacks already present in the gamemode.

For team radio, phones, faction channels, death-state restrictions, and custom UI, use the stream and speaker APIs documented in the upstream README and `include/voice-bridge.inc`.

## Upstream source and documentation

- [Voice Bridge source](https://github.com/devbluen/omp-Voice-Bridge)
- [Upstream API and configuration](https://github.com/devbluen/omp-Voice-Bridge/blob/main/README.md)
- [Upstream SampVoice compatibility example](https://github.com/devbluen/omp-Voice-Bridge/blob/main/examples/en/06-sampvoice-compatible.pwn)
