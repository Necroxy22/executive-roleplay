/*
    Custom Player Nametags
    ----- by Nyzenic, edited by Bork -----
    https://www.burgershot.gg/showthread.php?tid=113
*/

#include <a_samp>
#include <streamer>
#include <YSI\y_hooks>
 
#define NT_DISTANCE 25.0 // Nametag render distance
 
new Text3D:cNametag[MAX_PLAYERS];
 
hook OnGameModeInit()
{
    ShowNameTags(0);
    print("--- Custom nametags by Nyzenic loaded. Edited by Bork ---");
    // OnPlayerUpdate causes lag and OnPlayer(Take/Give)Damage doesn't work with it
    SetTimer("UpdateNametag", 1000, true); // So we're using a timer, change the interval to what you want
    return 1;
}
 
hook OnPlayerConnect(playerid)
{
    cNametag[playerid] = CreateDynamic3DTextLabel("Loading nametag...", 0xFFFFFFFF, 0.0, 0.0, 0.1, NT_DISTANCE, .attachedplayer = playerid, .testlos = 1);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(IsValidDynamic3DTextLabel(cNametag[playerid]))
              DestroyDynamic3DTextLabel(cNametag[playerid]);
    return 1;
}

forward UpdateNametag();
public UpdateNametag()
{
    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(IsPlayerConnected(i))
        {
            new nametag[128], playername[MAX_PLAYER_NAME];
            GetPlayerName(i, playername, sizeof(playername));
            UpdateDynamic3DTextLabelText(cNametag[i], 0xFFFFFFFF, nametag);
        }
    }
}
