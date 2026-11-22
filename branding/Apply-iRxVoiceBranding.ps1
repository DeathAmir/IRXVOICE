$ErrorActionPreference = 'Stop'
$root = Join-Path $PSScriptRoot '..\upstream\voice-bridge'
$root = [System.IO.Path]::GetFullPath($root)

function Replace-Exact([string]$relativePath, [string]$old, [string]$new, [int]$minimum = 1) {
    $path = Join-Path $root $relativePath
    $content = [System.IO.File]::ReadAllText($path)
    $count = ([regex]::Matches($content, [regex]::Escape($old))).Count
    if ($count -lt $minimum) {
        throw "Expected at least $minimum occurrence(s) of '$old' in $relativePath; found $count"
    }
    $content = $content.Replace($old, $new)
    [System.IO.File]::WriteAllText($path, $content, [System.Text.UTF8Encoding]::new($false))
    Write-Host "Branded $relativePath ($count replacement(s))"
}

Replace-Exact 'client/src/overlay.cpp' 'Voice Bridge' 'iRxVoice' 5
Replace-Exact 'client/src/overlay.cpp' 'VOICE-BRIDGE' 'IRXVOICE' 1
Replace-Exact 'client/src/overlay.cpp' '"voice-bridge" : status.server' '"iRxVoice" : status.server' 0
Replace-Exact 'server/src/log.cpp' '[VoiceBridge]' '[iRxVoice]' 4
Replace-Exact 'server/src/version.hpp.in' '#define VOICE_BRIDGE_AUTHOR "devbluen"' '#define VOICE_BRIDGE_AUTHOR "DeathAmir"' 1
Replace-Exact 'server/src/version.hpp.in' 'https://github.com/devbluen/omp-Voice-Bridge' 'https://github.com/DeathAmir/IRXVOICE' 1
Replace-Exact 'shared/version.rc.in' '"InternalName", "voice-bridge"' '"InternalName", "iRxVoice"' 1
Replace-Exact 'shared/version.rc.in' '"ProductName", "Voice Bridge"' '"ProductName", "DeathAmir iRxVoice"' 1
Replace-Exact 'CMakeLists.txt' 'DESCRIPTION "Voice chat for open.mp and SA-MP, compatible with SampVoice"' 'DESCRIPTION "DeathAmir iRxVoice voice chat for open.mp and SA-MP"' 1
Replace-Exact 'CMakeLists.txt' 'https://github.com/devbluen/omp-Voice-Bridge' 'https://github.com/DeathAmir/IRXVOICE' 1
Replace-Exact 'CMakeLists.txt' 'set(VOICE_BRIDGE_AUTHOR_RC "devbluen")' 'set(VOICE_BRIDGE_AUTHOR_RC "DeathAmir")' 1
Replace-Exact 'client/CMakeLists.txt' 'set(VB_RC_DESCRIPTION "Voice Bridge client for SA-MP")' 'set(VB_RC_DESCRIPTION "DeathAmir iRxVoice client for GTA San Andreas")' 1

$serverCmake = Join-Path $root 'server/CMakeLists.txt'
$serverText = [System.IO.File]::ReadAllText($serverCmake)
if ($serverText -notmatch 'set\(VB_RC_FILENAME "voice-bridge\.dll"\)') {
    throw 'Server DLL filename changed unexpectedly; refusing to alter it.'
}
Write-Host 'Verified server DLL filename remains voice-bridge.dll'
