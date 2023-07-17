public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{    
    if(dialogid == DIALOG_RADIOSETTINGS)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    return callcmd::togradio(playerid);
                }
                case 1:
                {
                    return callcmd::togmic(playerid);                   
                }
                case 2:
                {
                    ShowPlayerDialog(playerid, DIALOG_SETFREQ, DIALOG_STYLE_INPUT, "Set Frequensi Radio", "Masukkan Frequensi Radio Yang Ingin Kamu Hubungkan (Maksimal 1 - 9999)", "Hubungkan", "Tutup");
                }
                case 3:
                {
                    new str[256], togSfxTurnOn[256], togSfxTurnOff[256];
                    if(pData[playerid][pSfxTurnOn] == 0)
                    {
                        togSfxTurnOn = "{ff0000}Disable";
                    }
                    else if(pData[playerid][pSfxTurnOn] == 1)
                    {
                        togSfxTurnOn = "{00ff00}Enable";
                    }
                                    
                    if(pData[playerid][pSfxTurnOff] == 0)
                    {
                        togSfxTurnOff = "{ff0000}Disable";
                    }
                    else if(pData[playerid][pSfxTurnOff] == 1)
                    {
                        togSfxTurnOff = "{00ff00}Enable";
                    }  

                    format(str, sizeof(str), "Sound Effect Settings\tStatus\n{FFFFFF}Status FX TurnON:\t%s\n{FFFFFF}Status FX TurnOFF:\t%s\n{FFFFFF}Hidupkan Semua FX\n{FFFFFF}Matikan Semua FX", togSfxTurnOn, togSfxTurnOff);
                    ShowPlayerDialog(playerid, DIALOG_SETSFX, DIALOG_STYLE_TABLIST_HEADERS, "FX Radio Settings", str, "Set", "Close");
                    // if(pData[playerid][pSfxTurnOn] == 0)
                    // {
                    //     pData[playerid][pSfxTurnOn] = 1;
                    //     Info(playerid, "(Sfx Turning On) Radio Berhasil Dihidupkan.");
                    // }
                    // else if(pData[playerid][pSfxTurnOn] == 1)
                    // {
                    //     pData[playerid][pSfxTurnOn] = 0;
                    //     Info(playerid, "(Sfx Turning On) Radio Berhasil Dimatikan.");
                    // }               
                }
                case 4:
                {
                    if(pData[playerid][pSfxTurnOff] == 0)
                    {
                        pData[playerid][pSfxTurnOff] = 1;
                        Info(playerid, "(Sfx Turning Off) Radio Berhasil Dihidupkan.");
                    }
                    else if(pData[playerid][pSfxTurnOff] == 1)
                    {
                        pData[playerid][pSfxTurnOff] = 0;
                        Info(playerid, "(Sfx Turning Off) Radio Berhasil Dimatikan.");
                    }                    
                }
            }   
        }
    }
    if(dialogid == DIALOG_SETFREQ)
    {
        if(response)
        {
            new Frequensi = strval(inputtext);
                
            if(isnull(inputtext))
            {
                ShowPlayerDialog(playerid, DIALOG_SETFREQ, DIALOG_STYLE_INPUT, "Set Frequensi Radio", "{ff0000}ERROR: {FFFFFF}Harap Input Frequensi Yang Benar\n\nMasukkan Frequensi Radio Yang Ingin Anda Hubungkan (Maksimal 1 - 9999)", "Hubungkan", "Tutup");
                return 1;
            }
            if(Frequensi > 9999 || Frequensi < 0)
            {
                ShowPlayerDialog(playerid, DIALOG_SETFREQ, DIALOG_STYLE_INPUT, "Set Frequensi Radio", "{ff0000}ERROR: {FFFFFF}Maksimal Frequensi 1 - 9999\n\nMasukkan Frequensi Radio Yang Ingin Anda Hubungkan (Maksimal 1 - 9999)", "Hubungkan", "Tutup");
                return 1;
            }

            if(pData[playerid][pFreqRadio] >= 1)
            {
                ConnectToFrequensi(playerid, Frequensi, true);
            }
            else if(pData[playerid][pFreqRadio] == 0)
            {
                ConnectToFrequensi(playerid, Frequensi, false);
            }
        }
    }
    if(dialogid == DIALOG_SETSFX)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    if(pData[playerid][pSfxTurnOn] == 0)
                    {
                        pData[playerid][pSfxTurnOn] = 1;
                        Info(playerid, "(FX) Radio TurnON Berhasil Dihidupkan.");
                    }
                    else if(pData[playerid][pSfxTurnOn] == 1)
                    {
                        pData[playerid][pSfxTurnOn] = 0;
                        Info(playerid, "(FX) Radio TurnON Berhasil Dimatikan.");
                    }               
                }
                case 1:
                {
                    if(pData[playerid][pSfxTurnOff] == 0)
                    {
                        pData[playerid][pSfxTurnOff] = 1;
                        Info(playerid, "(FX) Radio TurnOFF Berhasil Dihidupkan.");
                    }
                    else if(pData[playerid][pSfxTurnOff] == 1)
                    {
                        pData[playerid][pSfxTurnOff] = 0;
                        Info(playerid, "(FX) Radio TurnOFF Berhasil Dimatikan.");
                    }                    
                }
                case 2:
                {
                    if(pData[playerid][pSfxTurnOn] == 1 && pData[playerid][pSfxTurnOff] == 1) return Error(playerid, "(FX) Radio Anda telah Aktif");

                    pData[playerid][pSfxTurnOn] = 1;
                    pData[playerid][pSfxTurnOff] = 1;

                    Info(playerid, "(FX) Radio anda berhasil di aktifkan semua");
                }
                case 3:
                {
                    if(pData[playerid][pSfxTurnOn] == 0 && pData[playerid][pSfxTurnOff] == 0) return Error(playerid, "(FX) Radio Anda telah Nonaktif");

                    pData[playerid][pSfxTurnOn] = 0;
                    pData[playerid][pSfxTurnOff] = 0;

                    Info(playerid, "(FX) Radio anda berhasil di Nonaktifkan semua");
                }
            }
        }
    }
    if(dialogid == DIALOG_SHOPELE)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    new getMoney = GetPlayerMoney(playerid);
                    if(pData[playerid][pRadio] == 1) return Error(playerid, "Anda telah memiliki radio, tidak dapat memblinya lagi");
                    if(getMoney < 1000) return Error(playerid, "Anda tidak memiliki banyak uang");
                    GivePlayerMoney(playerid, -1000);
                    pData[playerid][pRadio] = 1;
                    Info(playerid, "Anda berhasil membeli radio dengan harga $15.0000");
                }
                case 1:
                {
                    Info(playerid, "Maaf fitur ini akan segera hadir :)");
                }
            }
        }
    }    
    return 1;
}
