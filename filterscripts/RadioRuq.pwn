/*

[=====---=====---=====---=====---=====---=====---=====---=====---=====---=====---=====---=====---=====---=====--]
[                                                                                                               |  
|       ███╗   ███╗███████╗██████╗ ██████╗  █████╗ ████████╗██╗    ██╗   ██╗ ██████╗ ██╗ ██████╗███████╗        ]
[       ████╗ ████║██╔════╝██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██║    ██║   ██║██╔═══██╗██║██╔════╝██╔════╝        |
|       ██╔████╔██║█████╗  ██████╔╝██████╔╝███████║   ██║   ██║    ██║   ██║██║   ██║██║██║     █████╗          ]
[       ██║╚██╔╝██║██╔══╝  ██╔══██╗██╔═══╝ ██╔══██║   ██║   ██║    ╚██╗ ██╔╝██║   ██║██║██║     ██╔══╝          |
|       ██║ ╚═╝ ██║███████╗██║  ██║██║     ██║  ██║   ██║   ██║     ╚████╔╝ ╚██████╔╝██║╚██████╗███████╗        ]
[       ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝   ╚═╝   ╚═╝      ╚═══╝   ╚═════╝ ╚═╝ ╚═════╝╚══════╝        |
|                                                                                                               ]
[---=====---=====---=====---=====---=====---=====---=====---=====---=====---=====---=====---=====---=====---====|
                           [ ALL VOICE SYSTEM BY FARUQ ]

*/

#define FILTERSCRIPT

#include <a_samp>
#include <core>
#include <float>
#include <sampvoice>
#include <dini>
#include <sscanf2>
#include <Pawn.CMD>
#include <a_mysql>

// DIALOG DEFINE
enum
{
    DIALOG_RADIOSETTINGS,
    DIALOG_SETFREQ,
    DIALOG_SETSFX,
    DIALOG_SHOPELE
}

// PLAYER DATA
enum E_PLAYERS
{
    pID,
    pName[MAX_PLAYER_NAME],
    pMoney,
    bool: IsLoggedIn,
    bool: dataTerload,
    pRadio,
    pTogRadio,
    pTogMic,
    pFreqRadio,
    pSfxTurnOn,
    pSfxTurnOff
};
new pData[MAX_PLAYERS][E_PLAYERS];

// ---=== HANDLE ===---
#include    "RUQVOICE\DEFINE.pwn"
#include    "RUQVOICE\FUNCTIONS.pwn"
//#include    "RUQVOICE\COMMANDS.pwn"
//#include    "RUQVOICE\DIALOGS.pwn"

main()
{

}
 
public OnFilterScriptInit()
{
    voiceData = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DATA);
    if(mysql_errno(voiceData) != 0)
    {
        //print("[MySQL]: Koneksi ke database mengalami kegagalan.");
    } else {
        print("[MySQL]: Sukses terhubung ke database.");
    }

    print("                                                                  ");
    print("[-|-----=====-----=====-----=====-----=====-----=====-----=====|-]");
    print("                                                                  ");
    print("                                                                  ");
    print("                                                                  ");
    print("             [ALL SYSTEM VOICE LOADED, BY FARUQ]         		 "); // Disini
    print("                                                                  ");
    print("                                                                  ");
    print("                                                                  ");  
    print("[-|=====-----=====-----=====-----=====-----=====-----=====-----|-]");
    print("                                                                  ");

    for(new i = 0; i < MAX_FREQUENSI; i++)
    {
        radioStream[i] = SvCreateGStream(0xDB881AFF, "RadioStream");
    }   
    return 1;
}

public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid, SV_UINT:keyid) 
{
    if(keyid == 0x42 && pData[playerid][pFreqRadio] >= 1 && pData[playerid][pTogMic] == 1 && pData[playerid][pTogRadio] == 1)
    {
        SfxSoundTurnOn(pData[playerid][pFreqRadio]);
        //if(pData[playerid][pSfxTurnOn] == 1) PlaySoundToFrequensi(pData[playerid][pFreqRadio], "http://20.213.160.211/music/micon.ogg");
    	ApplyAnimation(playerid, "ped", "phone_talk", 4.1, 1, 1, 1, 1, 1, 1);
        if(!IsPlayerAttachedObjectSlotUsed(playerid, 9)) SetPlayerAttachedObject(playerid, 9, 19942, 2, 0.0300, 0.1309, -0.1060, 118.8998, 19.0998, 164.2999);
        SvAttachSpeakerToStream(radioStream[pData[playerid][pFreqRadio]], playerid);
    } 	

    if (keyid == 0x42 && localStream[playerid]) SvAttachSpeakerToStream(localStream[playerid], playerid); // Local Stream
}

public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid, SV_UINT:keyid)
{
    if(keyid == 0x42 && pData[playerid][pFreqRadio] >= 1 && pData[playerid][pTogMic] == 1 && pData[playerid][pTogRadio] == 1)
    {
        SfxSoundTurnOff(pData[playerid][pFreqRadio]);
        if(pData[playerid][pSfxTurnOff] == 1) PlaySoundToFrequensi(pData[playerid][pFreqRadio], "http://20.213.160.211/music/micoff.ogg");
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
        SvDetachSpeakerFromStream(radioStream[pData[playerid][pFreqRadio]], playerid);
        if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
    }

    if (keyid == 0x42 && localStream[playerid]) SvDetachSpeakerFromStream(localStream[playerid], playerid); // Local Stream
}

public OnPlayerConnect(playerid)
{
    if (SvGetVersion(playerid) == SV_NULL)
    {
    	Error(playerid, "Tidak dapat menemukan plugin sampvoice.");
    }
    else if (SvHasMicro(playerid) == SV_FALSE)
    {
    	Error(playerid, "Mikrofon tidak dapat ditemukan.");
    }
    else if ((localStream[playerid] = SvCreateDLStreamAtPlayer(20.0, SV_INFINITY, playerid)))
    {
    	Info(playerid, "Server Ini Menggunakan system voice only.");
        SvAddKey(playerid, 0x42);
    }

    GetPlayerName(playerid, pData[playerid][pName], MAX_PLAYER_NAME);
    pData[playerid][IsLoggedIn] = true;     
	return 1;
}

public OnPlayerSpawn(playerid)
{
    new Query[90];
    format(Query, sizeof(Query), "SELECT * FROM `voicedata` WHERE `pUsername` = '%s' LIMIT 1", GetPlayerNameEx(playerid));
    mysql_tquery(voiceData, Query, "CheckDataVoicePlayer", "d", playerid);     
    return 1;    
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_WALK))
	{
        if(pData[playerid][pRadio] == 0) return 1;
        if(pData[playerid][pTogMic] == 0)
        {
            if(pData[playerid][pTogRadio] == 0) return Error(playerid, "Radio anda sedang mati, Gunakan /togradio untuk menghidupkan radio anda.");
            if(pData[playerid][pFreqRadio] == 0) return Error(playerid, "Frequensi Anda Masih Berada Di {ff0000}(0){FFFFFF}, Tidak dapat menghidupkan Mic Radio");    

            new msgRadio[256];
            format(msgRadio, sizeof msgRadio, "{008000}[MIC]: {FFFFFF}Mic Radio Aktif, terhubung ke Frequensi: {ff0000}(%d).", pData[playerid][pFreqRadio]);
            SendClientMessage(playerid, -1, msgRadio);

            pData[playerid][pTogMic] = 1;
        }
        else if(pData[playerid][pTogMic] == 1)
        {
            if(pData[playerid][pTogRadio] == 0) return Error(playerid, "Radio anda sedang mati, Gunakan /togradio untuk menghidupkan radio anda.");
            if(pData[playerid][pFreqRadio] == 0) return Error(playerid, "Frequensi Anda Masih Berada Di {ff0000}(0){FFFFFF}, Tidak dapat menghidupkan Mic Radio");    

            new msgRadio[256];
            format(msgRadio, sizeof msgRadio, "{008000}[MIC]: {FFFFFF}Mic Radio NonAktif, terhubung ke Frequensi: {ff0000}(%d).", pData[playerid][pFreqRadio]);
            SendClientMessage(playerid, -1, msgRadio);

            pData[playerid][pTogMic] = 0;
        }  		
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if (localStream[playerid])
    {
        SvDeleteStream(localStream[playerid]);
        localStream[playerid] = SV_NULL;
    }   

    printf("[MySql]: Berhasil Menyimpan Data Player %s Dengan ID %d", GetPlayerNameEx(playerid), pData[playerid][pID]);

    pData[playerid][pTogRadio] = 0;
    SavePlayerDataVoice(playerid);
    ResetDataVoicePlayer(playerid);

    pData[playerid][dataTerload] = false;
    pData[playerid][IsLoggedIn] = false;
    return 1;
}

public OnFilterScriptExit()
{
    for(new i = 0; i < MAX_FREQUENSI; i++)
    {
        SvDeleteStream(radioStream[i]);
    }	
	return 1;
}
