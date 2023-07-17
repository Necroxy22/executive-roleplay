#include <a_samp>
#include <Pawn.CMD>
#include <sscanf2>
#include <sampvoice>
#include <streamer>
#define function%0(%1) forward %0(%1); public %0(%1)
#include <Notifikasi>
main() 
{}

public OnFilterScriptInit()
{
    printf("");
    printf("// -------- Voice System & Radio System Loaded! -------- // ");
    printf("");
}     
enum
{
	DIALOG_UNUSED,
	DIALOG_RADIO
}
public OnFilterScriptExit() 
{
    return 1;
}

//Local Voice
#define MAX_RADIOS 999
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
new SV_LSTREAM:lstream[MAX_PLAYERS] = { SV_NULL, ... };
new SV_GSTREAM:StreamTelpon[MAX_PLAYERS] = { SV_NULL, ... };
new SV_GSTREAM:StreamFreq[MAX_RADIOS] = SV_NULL;
new IDStream[MAX_PLAYERS];
new Text:Radio[4];

enum pEnum
{
	pTombolVoiceRadio,
	pRadioVoice,
	Text3D:TagVoice,
	pCallStage,
	pTombolVoice,
	pCallLine,
	pFrekuensi,
	pCall,
	pInjured,
	pFaction
};
new pData[MAX_PLAYERS][pEnum];

public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid, SV_UINT:keyid)
{
    if(pData[playerid][pTombolVoiceRadio] == 1)
	{
		if(pData[playerid][pRadioVoice] == 1)
		{
			if(keyid == 0x42 && IDStream[playerid] >= 1) SvAttachSpeakerToStream(StreamFreq[IDStream[playerid]], playerid);
			pData[playerid][TagVoice] = CreateDynamic3DTextLabel("[Radio]", 0x3BBD44FF, 0.0, 0.0, 0.2, 10.0, .attachedplayer = playerid, .testlos = 1);
		}
	}
	else if(pData[playerid][pCallStage] == 2)
	{
	    if (keyid == 0x42 && StreamTelpon[playerid]) SvAttachSpeakerToStream(StreamTelpon[playerid], playerid);
	    pData[playerid][TagVoice] = CreateDynamic3DTextLabel("[Menelepon]", 0x3BBD44FF, 0.0, 0.0, 0.2, 10.0, .attachedplayer = playerid, .testlos = 1);
	}
	else if(pData[playerid][pTombolVoice] == 1)
	{
		if (keyid == 0x42 && lstream[playerid])  SvAttachSpeakerToStream(lstream[playerid], playerid);
		pData[playerid][TagVoice] = CreateDynamic3DTextLabel("[Berbicara]", 0x3BBD44FF, 0.0, 0.0, 0.2, 10.0, .attachedplayer = playerid, .testlos = 1);
	}
}

public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid, SV_UINT:keyid)
{
	if(pData[playerid][pTombolVoiceRadio] == 1)
	{
		if(pData[playerid][pRadioVoice] == 1)
		{
			if(keyid == 0x42 && IDStream[playerid] >= 1) SvDetachSpeakerFromStream(StreamFreq[IDStream[playerid]], playerid);
			if(IsValidDynamic3DTextLabel(pData[playerid][TagVoice]))
              DestroyDynamic3DTextLabel(pData[playerid][TagVoice]);
		}
	}
	else if(pData[playerid][pCallStage] == 2)
	{
		if (keyid == 0x42 && StreamTelpon[playerid]) SvDetachSpeakerFromStream(StreamTelpon[playerid], playerid);
		if(IsValidDynamic3DTextLabel(pData[playerid][TagVoice]))
              DestroyDynamic3DTextLabel(pData[playerid][TagVoice]);
	}
	else if(pData[playerid][pTombolVoice] == 1)
	{
	    if(IsValidDynamic3DTextLabel(pData[playerid][TagVoice]))
              DestroyDynamic3DTextLabel(pData[playerid][TagVoice]);
		if (keyid == 0x42 && lstream[playerid]) SvDetachSpeakerFromStream(lstream[playerid], playerid);
	}
}

public OnPlayerConnect(playerid)
{
    if (SvGetVersion(playerid) == SV_NULL)
    {
		new lstr[512];
		format(lstr, sizeof(lstr), "Aufa System Detected:Executive Warning\nKepada:(pemain) Roleplay\n\nUntuk bermain peran di Executive Roleplay, maka anda harus memenuhi salah satu syarat yaitu memasang plugin voice di SAMP: {FFFF00}discord.gg/Executive");
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{FFFFFF}Executive Roleplay - Plugins Tidak Terdeteksi", lstr, "Keluar", "");
		SendClientMessage(playerid, -1, "{FFFF00}[i] Anda telah ditendang dari server karena {FF0000}Plugin Voice {FFFF00}tidak terdeteksi!");
    }
    else if (SvHasMicro(playerid) == SV_FALSE)
    {
        SendClientMessage(playerid, -1, "Mikrofon tidak dapat ditemukan.");
    }
    if ((lstream[playerid] = SvCreateDLStreamAtPlayer(15.0, SV_INFINITY, playerid, 0xff0000ff, "Berbicara")))
    {
        SvAddKey(playerid, 0x42);
    }
    pData[playerid][pRadioVoice] = 0;
	pData[playerid][pTombolVoice] = 1;
	pData[playerid][pTombolVoiceRadio] = 0;
}

public OnPlayerDisconnect(playerid, reason)
{
    if (lstream[playerid])
    {
        SvDeleteStream(lstream[playerid]);
        lstream[playerid] = SV_NULL;
    }
}

public OnGameModeInit()
{
    Radio[0] = TextDrawCreate(985.000000, 195.000000, "");
	TextDrawFont(Radio[0], 5);
	TextDrawLetterSize(Radio[0], 0.600000, 2.000000);
	TextDrawTextSize(Radio[0], 234.000000, 273.500000);
	TextDrawSetOutline(Radio[0], 0);
	TextDrawSetShadow(Radio[0], 0);
	TextDrawAlignment(Radio[0], 1);
	TextDrawColor(Radio[0], -1);
	TextDrawBackgroundColor(Radio[0], 0);
	TextDrawBoxColor(Radio[0], 255);
	TextDrawUseBox(Radio[0], 0);
	TextDrawSetProportional(Radio[0], 1);
	TextDrawSetSelectable(Radio[0], 0);

    Radio[0] = TextDrawCreate(385.000000, 195.000000, "Preview_Model");
	TextDrawFont(Radio[0], 5);
	TextDrawLetterSize(Radio[0], 0.600000, 2.000000);
	TextDrawTextSize(Radio[0], 234.000000, 273.500000);
	TextDrawSetOutline(Radio[0], 0);
	TextDrawSetShadow(Radio[0], 0);
	TextDrawAlignment(Radio[0], 1);
	TextDrawColor(Radio[0], -1);
	TextDrawBackgroundColor(Radio[0], 0);
	TextDrawBoxColor(Radio[0], 255);
	TextDrawUseBox(Radio[0], 0);
	TextDrawSetProportional(Radio[0], 1);
	TextDrawSetSelectable(Radio[0], 0);
	TextDrawSetPreviewModel(Radio[0], 2967);
	TextDrawSetPreviewRot(Radio[0], -95.000000, 0.000000, 180.000000, 1.000000);
	TextDrawSetPreviewVehCol(Radio[0], 1, 1);

	Radio[1] = TextDrawCreate(512.000000, 313.000000, "ld_bum:blkdot");
	TextDrawFont(Radio[1], 4);
	TextDrawLetterSize(Radio[1], 0.600000, 2.000000);
	TextDrawTextSize(Radio[1], 25.500000, 11.500000);
	TextDrawSetOutline(Radio[1], 1);
	TextDrawSetShadow(Radio[1], 0);
	TextDrawAlignment(Radio[1], 1);
	TextDrawColor(Radio[1], -1378294017);
	TextDrawBackgroundColor(Radio[1], 255);
	TextDrawBoxColor(Radio[1], 50);
	TextDrawUseBox(Radio[1], 1);
	TextDrawSetProportional(Radio[1], 1);
	TextDrawSetSelectable(Radio[1], 1);

	Radio[2] = TextDrawCreate(515.000000, 313.000000, "55.55");
	TextDrawFont(Radio[2], 1);
	TextDrawLetterSize(Radio[2], 0.195831, 1.149999);
	TextDrawTextSize(Radio[2], 400.000000, 17.000000);
	TextDrawSetOutline(Radio[2], 0);
	TextDrawSetShadow(Radio[2], 0);
	TextDrawAlignment(Radio[2], 1);
	TextDrawColor(Radio[2], 255);
	TextDrawBackgroundColor(Radio[2], 255);
	TextDrawBoxColor(Radio[2], 50);
	TextDrawUseBox(Radio[2], 0);
	TextDrawSetProportional(Radio[2], 1);
	TextDrawSetSelectable(Radio[2], 0);

	Radio[3] = TextDrawCreate(532.000000, 218.000000, "ld_beat:chit");
	TextDrawFont(Radio[3], 4);
	TextDrawLetterSize(Radio[3], 0.600000, 2.000000);
	TextDrawTextSize(Radio[3], 10.000000, 8.000000);
	TextDrawSetOutline(Radio[3], 1);
	TextDrawSetShadow(Radio[3], 0);
	TextDrawAlignment(Radio[3], 1);
	TextDrawColor(Radio[3], 255);
	TextDrawBackgroundColor(Radio[3], 255);
	TextDrawBoxColor(Radio[3], 50);
	TextDrawUseBox(Radio[3], 1);
	TextDrawSetProportional(Radio[3], 1);
	TextDrawSetSelectable(Radio[3], 1);
}

public OnGameModeExit()
{

}

stock GetPName(playerid)
{
	new namep[MAX_PLAYER_NAME+1];
	GetPlayerName(playerid, namep, MAX_PLAYER_NAME+1);
	return namep;
}

stock DisplayMicRadio(playerid)
{
	if(pData[playerid][pCallStage] == 2)
	{
		return ErrorMsg(playerid, "Kamu Sedang Menelpon");
	}
	else if(pData[playerid][pTombolVoiceRadio] == 0)
	{
		if(pData[playerid][pRadioVoice] == 0)
		{
			return ErrorMsg(playerid,"Kamu Tidak Terhubung Ke Frequensi Manapun");
		}
		pData[playerid][pTombolVoiceRadio] = 1;
		SuccesMsg(playerid, "MicRadio Menyala");
		SetPlayerAttachedObject(playerid, 9, 19942, 6, 0.083999, 0.030999, 0.000000, -7.699999, -29.100000, -164.100006, 1.000000, 1.000000, 1.000000);
	}
	else if(pData[playerid][pTombolVoiceRadio] == 1)
	{
		pData[playerid][pTombolVoiceRadio] = 0;
		SuccesMsg(playerid, "MicRadio Dimatikan");
		RemovePlayerAttachedObject(playerid, 9);
	}
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == Radio[1])
	{
        ShowPlayerDialog(playerid, DIALOG_RADIO, DIALOG_STYLE_INPUT, "Executive - Hubungkan radio", "Silakan tentukan saluran yang ingin Anda hubungkan", "Sambung", "Batal");
	}
	if(clickedid == Radio[3])
	{
	    TextDrawHideForPlayer(playerid, Radio[0]);
	    TextDrawHideForPlayer(playerid, Radio[1]);
	    TextDrawHideForPlayer(playerid, Radio[2]);
	    TextDrawHideForPlayer(playerid, Radio[3]);
	    CancelSelectTextDraw(playerid);
	}
}
CMD:setradio(playerid, params[])
{
	TextDrawShowForPlayer(playerid, Radio[0]);
	TextDrawShowForPlayer(playerid, Radio[1]);
	TextDrawShowForPlayer(playerid, Radio[2]);
	TextDrawShowForPlayer(playerid, Radio[3]);
	SelectTextDraw(playerid, 0xffffffff);
	return 1;
}
CMD:resetradio(playerid, params[])
{
    if(pData[playerid][pRadioVoice] == 0)
	{
		return ErrorMsg(playerid, "Anda perlu menghubungkan saluran radio");
    }
    pData[playerid][pRadioVoice] = 0;
	pData[playerid][pTombolVoiceRadio] = 0;
    SuccesMsg(playerid, "Terputus dari saluran radio.");
    SvDetachListenerFromStream(StreamFreq[IDStream[playerid]], playerid);
	pData[playerid][pFrekuensi] = 0;
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_YES) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		DisplayMicRadio(playerid);
	}
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_RADIO)
	{
		if(response)
        {
			new id;
			if(sscanf(inputtext, "i", id))
			{
				return 1;
			}
			if(pData[playerid][pCallStage] == 2)
			{
				return ErrorMsg(playerid, "Kamu Sedang Menelpon");
			}
			if(!(1 <= id <= 999))
			{
				return ErrorMsg(playerid, "Saluran radio yang ditentukan harus berkisar antara 1 dan 999.");
			}
			if(pData[playerid][pRadioVoice] == 1)
			{
				return ErrorMsg(playerid, "Anda perlu memutuskan sambungan dari saluran radio untuk menghubungkan saluran lain");
			}
			else if(id <= 10)
			{
				if(pData[playerid][pFaction] == 0)
				{
					return ErrorMsg(playerid, "Frekuensi Radio 1 - 10 Hannya Aparat Kepolisian Saja.");
				}
				else
				{
					IDStream[playerid] = id;
					pData[playerid][pFrekuensi] = id;

					if(StreamFreq[IDStream[playerid]] == SV_NULL)
					{
						pData[playerid][pRadioVoice] = 1;
						StreamFreq[IDStream[playerid]] = SvCreateGStream(0xFF0000FF, "Radio");
						SvAttachListenerToStream(StreamFreq[IDStream[playerid]], playerid);
						SuccesMsg(playerid, "> Berhasil terhubung ke saluran radio <");
					}
					else
					{
						pData[playerid][pRadioVoice] = 1;
						SvAttachListenerToStream(StreamFreq[IDStream[playerid]], playerid);
						SuccesMsg(playerid, "> Berhasil terhubung ke saluran radio <");
					}
				}
			}
			else
			{
				IDStream[playerid] = id;
				pData[playerid][pFrekuensi] = id;

				if(StreamFreq[IDStream[playerid]] == SV_NULL)
				{
					pData[playerid][pRadioVoice] = 1;
					StreamFreq[IDStream[playerid]] = SvCreateGStream(0xFF0000FF, "Radio");
					SvAttachListenerToStream(StreamFreq[IDStream[playerid]], playerid);
					SuccesMsg(playerid, "> Berhasil terhubung ke saluran radio <");
				}
				else
				{
					pData[playerid][pRadioVoice] = 1;
					SvAttachListenerToStream(StreamFreq[IDStream[playerid]], playerid);
					SuccesMsg(playerid, "> Berhasil terhubung ke saluran radio <");
				}
			}
        }
    }
	return 1;
}
