// ---=== RADIO COMMANDS ====---
CMD:togmic(playerid)
{
    //if(pData[playerid][pRadio] == 0) return Error(playerid, "Anda tidak memiliki Radio, Silahkan membelinya di toko 24/7");

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
    return 1;
}

CMD:togradio(playerid)
{
    //if(pData[playerid][pRadio] == 0) return Error(playerid, "Anda tidak memiliki Radio, Silahkan membelinya di toko 24/7");

	if(pData[playerid][pTogRadio] == 0)
	{
		if(pData[playerid][pFreqRadio] >= 1)
		{
            new msgTogRadio[256];
            format(msgTogRadio, sizeof msgTogRadio, ""WARNA_KUNING"[RADIO]: "WARNA_PUTIH"Radio anda telah berhasil {7FFF00}dihidupakan{FFFFFF}, dan anda telah kembali terhubung ke Frequensi: {FF0000}(%d).", pData[playerid][pFreqRadio]);
            SendClientMessage(playerid, -1, msgTogRadio);
			ConnectToFrequensi(playerid, pData[playerid][pFreqRadio], false);
            pData[playerid][pTogRadio] = 1;
		}
        else
        {
            Info(playerid, "Radio anda berhasil Dihidupkan.");
            pData[playerid][pTogRadio] = 1;
        }
	}
	else if(pData[playerid][pTogRadio] == 1)
	{
		if(pData[playerid][pFreqRadio] >= 1)
		{
            new msgTogRadio[256];
            format(msgTogRadio, sizeof msgTogRadio, ""WARNA_KUNING"[RADIO]: "WARNA_PUTIH"Radio anda telah berhasil {FF0000}dimatikan{FFFFFF}, dan anda telah terputus dari Frequensi: {ff0000}(%d).", pData[playerid][pFreqRadio]);            
			SendClientMessage(playerid, -1, msgTogRadio);
            DisconnectToFrequensi(playerid, pData[playerid][pFreqRadio], true);
            pData[playerid][pTogRadio] = 0;
		}
        else
        {
            Info(playerid, "Radio anda berhasil Dimatikan.");
            pData[playerid][pTogRadio] = 0;
        }
	}
	return 1;
}

CMD:setradio(playerid, params[])
{
    //if(pData[playerid][pRadio] == 0) return Error(playerid, "Anda tidak memiliki Radio, Silahkan membelinya di toko 24/7");   
	if(pData[playerid][pTogRadio] == 0) return Error(playerid, "Radio anda sedang mati, Gunakan /togradio untuk menghidupkan radio anda.");

    new freq;
    if(sscanf(params, "d", freq)) return Usage(playerid, "/setradio [Frequensi]");
    if(freq > 9999 || freq < 0) return Error(playerid, "Frequensi Tidak Valid, Maksimal Frequensi 1 - 9999!");
    if(freq == pData[playerid][pFreqRadio]) return Error(playerid, "Kamu sedang berada di Frequensi Yang Anda Input.");

    if(freq == 0)
    {
    	DisconnectToFrequensi(playerid, pData[playerid][pFreqRadio], false);
    } 
    else 
    {
        if(pData[playerid][pFreqRadio] >= 1)
        {
            SetTimerEx("ConnectToFrequensi", 100, false, "idb", playerid, freq, true);
        }

        if(pData[playerid][pFreqRadio] == 0)
        {
            SetTimerEx("ConnectToFrequensi", 100, false, "idb", playerid, freq, false);            
        }
    }
    return 1;
}

CMD:radiosettings(playerid, params[])
{
    //if(pData[playerid][pRadio] == 0) return Error(playerid, "Anda tidak memiliki Radio, Silahkan membelinya di toko 24/7");

    new str[1024], togRadio[64], togMic[64], radioFreq[64];
    if(pData[playerid][pTogRadio] == 0)
    {
        togRadio = "{ff0000}Disable";
    }
    else if(pData[playerid][pTogRadio] == 1)
    {
        togRadio = "{00ff00}Enable";
    }
    
    if(pData[playerid][pTogMic] == 0)
    {
        togMic = "{ff0000}Disconnected";
    }
    else
    {
        togMic = "{00ff00}Connected";
    }  
    
    if(pData[playerid][pFreqRadio] == 0)
    {
        radioFreq = "{ff0000}Freq Not Connected";
    }
    else if(pData[playerid][pFreqRadio] >= 1)
    {
        format(radioFreq, sizeof radioFreq, "{00ff00}%d", pData[playerid][pFreqRadio]);
    }
    
    format(str, sizeof(str), "Radio Settings\tStatus\n{FFFFFF}Status Radio:\t%s\n{FFFFFF}Status Mic:\t%s\n{FFFFFF}Frequensi Radio:\t%s\n{FFFFFF}Atur FX Radio", togRadio, togMic, radioFreq);
    
    ShowPlayerDialog(playerid, DIALOG_RADIOSETTINGS, DIALOG_STYLE_TABLIST_HEADERS, "Radio Settings", str, "Set", "Close");

    return 1;
}

// ---=== MORE COMMANDS ===---

/*CMD:aagivemoney(playerid, params[])
{
    GivePlayerMoney(playerid, 20000);
    Info(playerid, "Sukses!!");
    return 1;
}*/
/*
CMD:go(playerid, params[])
{
    SetPlayerPos(playerid, -23.2736,-55.6267,1003.5469);
    return 1;
}
*/
CMD:saveradio(playerid, params[])
{
    SavePlayerDataVoice(playerid);
    Info(playerid, "Berhasil Di Simpan");
}

/*CMD:buyele(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, -23.2736,-55.6267,1003.5469)) return Info(playerid, "Kamu tidak berada di toko 24/7");
    ShowPlayerDialog(playerid, DIALOG_SHOPELE, DIALOG_STYLE_TABLIST_HEADERS, "SHOP ELETRONIC Living After", "Barang\tHarga Barang\nRadio\t{00ff00}$1.000\nHandPhone\t{00ff00}$2.000", "Beli", "Tutup");

    return 1;
}*/
