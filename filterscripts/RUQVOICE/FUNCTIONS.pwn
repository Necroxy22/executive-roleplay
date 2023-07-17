function CheckDataVoicePlayer(playerid)
{
    if(cache_num_rows())
    {
        new Query[90];
        mysql_format(voiceData, Query, sizeof(Query), "SELECT * FROM voicedata WHERE pUsername = '%e'", GetPlayerNameEx(playerid));
        mysql_tquery(voiceData, Query, "LoadDataVoicePlayer", "i", playerid);
    }
    else if(!cache_num_rows())
    {
        new Query[90];
        mysql_format(voiceData, Query, sizeof(Query), "INSERT INTO `voicedata`(`pUsername`) VALUES ('%e')", GetPlayerNameEx(playerid));
        mysql_tquery(voiceData, Query, "CreateDataVoicePlayer", "i", playerid);             
    }
}

function CreateDataVoicePlayer(playerid)
{
    new Query[256];
    pData[playerid][pID] = cache_insert_id();
    printf("[MYSQL]: Player %s terdaftar Dengan ID %d", GetPlayerNameEx(playerid), pData[playerid][pID]);

    mysql_format(voiceData, Query, sizeof(Query), "SELECT * FROM voicedata WHERE pID='%i'", pData[playerid][pID]);
    mysql_query(voiceData, Query);

    LoadDataVoicePlayer(playerid);
}

function LoadDataVoicePlayer(playerid)
{
    if(pData[playerid][dataTerload] == true) return 1;
    cache_get_value_int(0, "pID", pData[playerid][pID]);
    cache_get_value_name(0, "pUsername", pData[playerid][pName], MAX_PLAYER_NAME+1);

    cache_get_value_int(0, "pRadio", pData[playerid][pRadio]);
    cache_get_value_int(0, "pTogRadio", pData[playerid][pTogRadio]);
    cache_get_value_int(0, "pTogMic", pData[playerid][pTogMic]);
    cache_get_value_int(0, "pFreqRadio", pData[playerid][pFreqRadio]);
    cache_get_value_int(0, "pSfxTurnOn", pData[playerid][pSfxTurnOn]);
    cache_get_value_int(0, "pSfxTurnOff", pData[playerid][pSfxTurnOff]);
    pData[playerid][dataTerload] = true;

    printf("[MySql]: Berhasil Mengambil Data Player %s Dengan ID %d", GetPlayerNameEx(playerid), pData[playerid][pID]);
    return 1;
}

function ConnectToFrequensi(playerid, freq, bool:rConnected)
{
    if(freq == 0) return 1;
    if(rConnected == true)
    {
        new msgToFreq[256];
        format(msgToFreq, 256, "{ff0000}(%s){FFFFFF} Telah Keluar Dari Frequensi: {ff0000}(%d).", GetPlayerNameEx(playerid), pData[playerid][pFreqRadio]);
        SendMessageToFrequensi(pData[playerid][pFreqRadio], msgToFreq);

        new msgFreq[256];
        format(msgFreq, sizeof msgFreq, ""WARNA_KUNING"[RADIO]: "WARNA_PUTIH"Anda telah terputus dari Frequensi: {ff0000}(%d){FFFFFF}, Dan terhubung ke Frequensi: {ff0000}(%d).", pData[playerid][pFreqRadio], freq);
        SendClientMessage(playerid, -1, msgFreq);

        SvDetachSpeakerFromStream(radioStream[pData[playerid][pFreqRadio]], playerid);
        SvDetachListenerFromStream(radioStream[pData[playerid][pFreqRadio]], playerid);

        pData[playerid][pFreqRadio] = freq;

        SvAttachListenerToStream(radioStream[freq], playerid);

        format(msgToFreq, 256, "{ff0000}(%s){FFFFFF} Telah Terhubung Ke Frequensi: {ff0000}(%d).", GetPlayerNameEx(playerid), pData[playerid][pFreqRadio]);
        SendMessageToFrequensi(pData[playerid][pFreqRadio], msgToFreq);        
    }
    else if(rConnected == false)
    {        
        pData[playerid][pFreqRadio] = freq;
        SvAttachListenerToStream(radioStream[freq], playerid);

        new string[128];
        format(string, 128, ""WARNA_KUNING"[RADIO]:"WARNA_PUTIH" Anda berhasil Terhubung ke Frequensi: {ff0000}(%d).", freq);
        SendClientMessage(playerid, 0x00AE00FF, string);

        format(string, 128, "{FF0000}(%s){FFFFFF} Telah Terhubung ke frequensi {ff0000}(%d)", GetPlayerNameEx(playerid), pData[playerid][pFreqRadio]);
        SendMessageToFrequensi(pData[playerid][pFreqRadio], string);
    }
    return 1;
}

function DisconnectToFrequensi(playerid, freq, bool:togOnRadio)
{
    SvDetachListenerFromStream(radioStream[freq], playerid);
    SvDetachSpeakerFromStream(radioStream[freq], playerid);

    new msgToFreq[256];
    format(msgToFreq, 256, "{ff0000}(%s) {FFFFFF}Telah Keluar Dari Frequensi: {FF0000}(%d).", GetPlayerNameEx(playerid), freq);
    SendMessageToFrequensi(freq, msgToFreq);

    new msgFreq[256];
    format(msgFreq, 256, ""WARNA_KUNING"[RADIO]: "WARNA_PUTIH"Anda telah terputus dari Frequensi: {ff0000}(%d).", freq);
    SendClientMessage(playerid, -1, msgFreq);

    if(togOnRadio == false)
    {
        pData[playerid][pFreqRadio] = 0;
    }
    return 1;
}

// ---=== STOCK ===---

stock GetPlayerNameEx(playerid)
{
    new getName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, getName, MAX_PLAYER_NAME);
    return getName;
}

stock ResetDataVoicePlayer(playerid)
{
    pData[playerid][pID] = 0;
    pData[playerid][pRadio] = 0;
    pData[playerid][pTogRadio] = 0;
    pData[playerid][pTogMic] = 0;
    pData[playerid][pFreqRadio] = 0;
    pData[playerid][pSfxTurnOn] = 0;
    pData[playerid][pSfxTurnOff] = 0;
    pData[playerid][IsLoggedIn] = false;  
}

stock SavePlayerDataVoice(playerid)
{
    new Query[2560];  
    mysql_format(voiceData, Query, sizeof(Query), "UPDATE `voicedata` SET `pUsername`='%e',`pRadio`='%d',`pTogRadio`='%d',`pTogMic`='%d',`pFreqRadio`='%d',`pSfxTurnOn`='%d',`pSfxTurnOff`='%d' WHERE `pID`='%d'",
        pData[playerid][pName],
        pData[playerid][pRadio],
        pData[playerid][pTogRadio],
        pData[playerid][pTogMic],
        pData[playerid][pFreqRadio],
        pData[playerid][pSfxTurnOn],
        pData[playerid][pSfxTurnOff],
        pData[playerid][pID]
    );
    return 1;
}

/*GivePlayerMoneyEx(playerid, cashgiven)
{
    pData[playerid][pMoney] += cashgiven;
    GivePlayerMoney(playerid, cashgiven);
}*/

stock SendMessageToFrequensi(freq, msg[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(pData[i][pFreqRadio] > 0 && pData[i][pFreqRadio] == freq)
            {
            	new getMsg[256];
            	format(getMsg, 256, ""WARNA_KUNING"[RADIO]: "WARNA_PUTIH"%s", msg);
                SendClientMessage(i, -1, getMsg);
            }
        }
    }
    return 1;
}

stock PlaySoundToFrequensi(freq, getUrl[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(pData[i][pFreqRadio] > 0 && pData[i][pFreqRadio] == freq)
            {
                PlayAudioStreamForPlayer(i, getUrl);
            }
        }
    }
    return 1;
}

stock SfxSoundTurnOn(freq)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(pData[i][pFreqRadio] > 0 && pData[i][pFreqRadio] == freq && pData[i][pSfxTurnOn] == 1)
            {
                PlayAudioStreamForPlayer(i, "http://20.213.160.211/music/micon.ogg");
            }
        }
    }
}

stock SfxSoundTurnOff(freq)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(pData[i][pFreqRadio] > 0 && pData[i][pFreqRadio] == freq && pData[i][pSfxTurnOff] == 1)
            {
                PlayAudioStreamForPlayer(i, "http://20.213.160.211/music/micoff.ogg");
            }
        }
    }
}
