#include <open.mp>
#include <sampvoice>

new SV_LSTREAM:gIRXLocalVoice[MAX_PLAYERS] = { SV_NULL, ... };

public OnPlayerConnect(playerid)
{
    gIRXLocalVoice[playerid] = SV_NULL;

    if(SvGetVersion(playerid) == SV_NULL)
    {
        SendClientMessage(playerid, 0xE74C3CFF, "[IRXVOICE] Voice client not detected.");
        return 1;
    }

    if(!SvHasMicro(playerid))
    {
        SendClientMessage(playerid, 0xE67E22FF, "[IRXVOICE] Microphone not detected or disabled.");
        return 1;
    }

    gIRXLocalVoice[playerid] = SvCreateDLStreamAtPlayer(35.0, SV_INFINITY, playerid, 0xA970FFFF, "IRAutoX Local");

    if(gIRXLocalVoice[playerid] != SV_NULL)
    {
        SvAddKey(playerid, 0x42);
        SendClientMessage(playerid, 0xA970FFFF, "[IRXVOICE] Press B to talk to nearby players.");
    }
    else
    {
        SendClientMessage(playerid, 0xE74C3CFF, "[IRXVOICE] Could not create your local voice stream.");
    }
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(gIRXLocalVoice[playerid] != SV_NULL)
    {
        SvDeleteStream(gIRXLocalVoice[playerid]);
        gIRXLocalVoice[playerid] = SV_NULL;
    }
    SvRemoveAllKeys(playerid);
    return 1;
}

public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid, SV_UINT:keyid)
{
    if(keyid == 0x42 && gIRXLocalVoice[playerid] != SV_NULL)
        SvAttachSpeakerToStream(gIRXLocalVoice[playerid], playerid);
}

public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid, SV_UINT:keyid)
{
    if(keyid == 0x42 && gIRXLocalVoice[playerid] != SV_NULL)
        SvDetachSpeakerFromStream(gIRXLocalVoice[playerid], playerid);
}
