//-------------[ Player Commands ]-------------//
CMD:kencing(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid))
		return ErrorMsg(playerid, "Anda harus berada di luar kendaraan.");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda harus menunggu progress selesai!");
	if(pData[playerid][pKencing] < 25) return ErrorMsg(playerid, "Anda sedang tidak ingin kencing!");
	ShowProgressbar(playerid, "Kencing..", 10);
	SetPlayerSpecialAction(playerid, 68);
	SetTimerEx("SedangKencing", 10000, false, "d", playerid);
	return 1;
}

CMD:playerkont(playerid)
{
	return 1;
}
CMD:cursor(playerid, params[])
{
	SelectTextDraw(playerid, COLOR_BLUE);
	SuccesMsg(playerid, "Menggunakan Fitur Cursor");
	return 1;
}
CMD:fixvisu(playerid, params[])
{
   SetPlayerInterior(playerid, 0);
   SetPlayerVirtualWorld(playerid, 0);
   InfoMsg(playerid, "Visual Anda Kembali Normal Tchuy");
   return 1;
}
CMD:pernikahan(playerid, params[])
{
	if(Nikahan == false) return ErrorMsg(playerid, "Sedang tidak ada pernikahan disini!");
    if(pData[playerid][pDelaypernikahan] > 0) return Error(playerid, "Kamu masih cooldown %d detik", pData[playerid][pDelaypernikahan]);
    ShowProgressbar(playerid, "Mengambil Makanan gratis..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	ShowItemBox(playerid, "Ayam Goreng", "Received_1x", 19847, 4);
	ShowItemBox(playerid, "Mineral", "Received_1x", 2958, 4);
	SuccesMsg(playerid, "Kamu berhasil mendapatkan Makanan!");
	pData[playerid][pMineral] ++;
	pData[playerid][pChiken] ++;
    pData[playerid][pDelaypernikahan] = 100;
	return 1;
}

/*CMD:pricelist(playerid, params[])
{
	new str[1000];
	format(str, sizeof(str), "\t\tEkonomi Kota\n\tHarga Batu = ")
}*/

CMD:isibensin(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 2.0, pData[playerid][pCapX], pData[playerid][pCapY], pData[playerid][pCapZ]))
	{
		if(pData[playerid][pFillStatus] == 1)
			return ErrorMsg(playerid, "Anda sedang mengisi bahan bakar, mohon ditunggu!");

		if(pData[playerid][pGrabFuel] == false)
			return ErrorMsg(playerid, "Anda tidak memegang gagang bensin");

		new str[128];
		format(str, sizeof(str), "Harga Bensin %d$/1liter", GasOilPrice);
		ShowPlayerDialog(playerid, DIALOG_ISIBENSIN, DIALOG_STYLE_INPUT, "Bensin", str, "Yes", "No");
	}
	return 1;
}

CMD:bukatanki(playerid)
{
	new Float:pos[3];

	if(!IsPlayerInAnyVehicle(playerid))
		return Error(playerid, "Anda tidak berada dalam mobil");

	GetPosNearVehiclePart(GetPlayerVehicleID(playerid), VEH_PART_PCAP, pos[0], pos[1], pos[2], 0.25);
	if(pData[playerid][pFillCapOpen] == 0)
	{
		pData[playerid][pCapX] = pos[0];
		pData[playerid][pCapY] = pos[1];
		pData[playerid][pCapZ] = pos[2];
		pData[playerid][pFillVeh] = GetPlayerVehicleID(playerid);
		pData[playerid][pFillCapOpen] = 1;
		InfoMsg(playerid, "Tanki mobil terbuka");
	}
	else
	{
		pData[playerid][pFillCapOpen] = 0;
		InfoMsg(playerid, "Tanki mobil tertutup");
	}
 	return 1;
}
CMD:map(playerid)
{
	new
 	han2[MAX_DEALERSHIP * 32];

	han2 = "ID\tName\tType\tLocation\n";

    new type[128];
   	foreach(new bid : Dealer)
	{
		if(DealerData[bid][dealerType] == 1)
		{
			type = "Motorcycle";
		}
		else if(DealerData[bid][dealerType] == 2)
		{
			type = "Cars";
		}
		else if(DealerData[bid][dealerType] == 3)
		{
			type = "Unique Cars";
		}
		else if(DealerData[bid][dealerType] == 4)
		{
			type = "Job Cars";
		}
		else if(DealerData[bid][dealerType] == 5)
		{
			type = "Truck";
		}
		else
		{
			type = "Unknow";
		}

	    format(han2, sizeof(han2), "%s%d\t%s\t%s\t"RED_E"%.1f m\n", han2,
	    bid, DealerData[bid][dealerName], type, GetPlayerDistanceFromPoint(playerid, DealerData[bid][dealerPosX], DealerData[bid][dealerPosY], DealerData[bid][dealerPosZ]));
	}
	ShowPlayerDialog(playerid, DIALOG_FIND_DEALER, DIALOG_STYLE_TABLIST_HEADERS, "Dealership Location", han2, "Select", "Close");
	return 1;
}

CMD:flist(playerid, params[])
{
	new duty[16], lstr[1024];
	format(lstr, sizeof(lstr), "Name\tRank\tStatus\tDuty Time\n");
	foreach(new i: Player)
	{
		if(pData[i][pFaction] == 1)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s\t%d detik", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty, pData[i][pOnDutyTime]);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
	}
	format(lstr, sizeof(lstr), "%s\n", lstr);
	ShowPlayerDialog(playerid, DIALOG_ONDUTY, DIALOG_STYLE_TABLIST_HEADERS, "Police Online", lstr, "Close", "");
	return 1;
}
CMD:hbemode(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_HBEMODE, DIALOG_STYLE_LIST, "Executive - HBE Mode", ""LG_E"Simple\n"LG_E"Modern", "Pilih", "Tutup");
    return 1;
}
CMD:belijerigen(playerid, params[])
{
    if(pData[playerid][pGas] > 5) return ErrorMsg(playerid, "Anda Tidak Bisa Membawa Jerigen Lebih dari 5");
    pData[playerid][pGas] += 1;
	GivePlayerMoneyEx(playerid, -50);
	ShowItemBox(playerid, "Uang", "Removed_$50", 1212, 4);
	ShowItemBox(playerid, "Jerigen", "Received_1x", 1650, 4);
	return 1;
}
stock Jembut(playerid, string[], time)//Time in Sec.
{
	new validtime = time*1000;

	if (PlayerInfo[playerid][Kontol])
	{
	    KillTimer(PlayerInfo[playerid][Memek]);
	}
	PlayerTextDrawSetString(playerid, AltTD[playerid][3], string);
	PlayerTextDrawShow(playerid, AltTD[playerid][0]);
	PlayerTextDrawShow(playerid, AltTD[playerid][1]);
	PlayerTextDrawShow(playerid, AltTD[playerid][2]);
	PlayerTextDrawShow(playerid, AltTD[playerid][3]);
	PlayerTextDrawShow(playerid, AltTD[playerid][4]);
    PlayerPlaySound(playerid, 1057 , 0.0, 0.0, 0.0);
	PlayerInfo[playerid][Kontol] = true;
	PlayerInfo[playerid][Memek] = SetTimerEx("HideMessageAje", validtime, false, "d", playerid);
	return 1;
}
function HideMessageAje(playerid)
{
	if (!PlayerInfo[playerid][Kontol])
	    return 0;

	PlayerInfo[playerid][Kontol] = false;
	return HideSemua(playerid);
}

stock HideSemua(playerid)
{
    PlayerTextDrawHide(playerid, AltTD[playerid][0]);
	PlayerTextDrawHide(playerid, AltTD[playerid][1]);
	PlayerTextDrawHide(playerid, AltTD[playerid][2]);
	PlayerTextDrawHide(playerid, AltTD[playerid][3]);
	PlayerTextDrawHide(playerid, AltTD[playerid][4]);
	return 1;
}
CMD:setrobwarung(playerid, params[])
{
    Warung = false;
    SuccesMsg(playerid, "Mereset Coldown Rob warung");
    return 1;
}

CMD:savepos(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Gunakan: /savepos [judul]");

    extract params -> new string:message[1000]; else return SendClientMessage(playerid, 0xCECECEFF, "Gunakan: /savepos [judul]");

   	GetPlayerVehicleID(playerid);
	new msg[500];
	new Float:PPos[5];

	GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
	GetPlayerFacingAngle(playerid, PPos[3]);
	format(msg, sizeof(msg), "\nSetPlayerPos(playerid, %f,%f,%f);\nSetPlayerFacingAngle(playerid, %f);\nJudul : %s", PPos[0], PPos[1], PPos[2], PPos[3], message);
/*	DCC_SendChannelMessage(g_discord_savepos, msg);*/
    new File:fhandle;
    fhandle = fopen("coordinates.txt",io_append);
    fwrite(fhandle, msg);
    fclose(fhandle);
	SuccesMsg(playerid, "Coordinat Posisi Kamu Berhasil Di Save!");

    return 1;
}
CMD:eatkebab(playerid, params[])
{
    if(pData[playerid][pKebab] < 1) return ErrorMsg(playerid,"Anda tidak memiliki kebab!.");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
	if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
	    pData[playerid][pKebab]--;
	    pData[playerid][sampahsaya]++;
	    Inventory_Update(playerid);
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Kebab", "Removed_1x", 2769, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
	    SetPlayerChatBubble(playerid,"> Makan Kebab..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Makan Kebab..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	    SetPlayerAttachedObject(playerid, 3, 2769, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pHunger] += 30;
	    return 1;
    }
}
CMD:eatroti(playerid, params[])
{
    if(pData[playerid][pRoti] < 1) return ErrorMsg(playerid,"Anda tidak memiliki roti!.");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
	if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
	    pData[playerid][pRoti]--;
	    pData[playerid][sampahsaya]++;
	    Inventory_Update(playerid);
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Roti", "Removed_1x", 19883, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
	    SetPlayerChatBubble(playerid,"> Makan Roti..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Makan Roti..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	    SetPlayerAttachedObject(playerid, 3, 19883, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pHunger] += 25;
	    return 1;
    }
}
CMD:eatsnack(playerid, params[])
{
    if(pData[playerid][pSnack] < 1) return ErrorMsg(playerid,"Anda tidak memiliki snack!.");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
	if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
	    pData[playerid][pSnack]--;
	    pData[playerid][sampahsaya]++;
	    Inventory_Update(playerid);
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Snack", "Removed_1x", 2821, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
	    SetPlayerChatBubble(playerid,"> Makan Snack..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Makan..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	    SetPlayerAttachedObject(playerid, 3, 2821, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pHunger] += 10;
	    return 1;
    }
}
CMD:chiken(playerid, params[])
{
    if(pData[playerid][pChiken] < 1) return ErrorMsg(playerid,"Anda tidak memiliki Cappucino!.");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
	if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
	    pData[playerid][pChiken]--;
	    pData[playerid][sampahsaya]++;
	    Inventory_Update(playerid);
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Chiken", "Removed_1x", 19847, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
	    SetPlayerChatBubble(playerid,"> Memakan Chiken..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Memakan chiken..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	    SetPlayerAttachedObject(playerid, 3, 19835, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pHunger] += 10;
	    return 1;
    }
}
CMD:steak(playerid, params[])
{
    if(pData[playerid][pSteak] < 1) return ErrorMsg(playerid,"Anda tidak memiliki Steak!.");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
	if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
	    pData[playerid][pSteak]--;
	    pData[playerid][sampahsaya]++;
	    Inventory_Update(playerid);
        Inventory_Close(playerid);
        ShowItemBox(playerid, "steak", "Removed_1x", 19811, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
	    SetPlayerChatBubble(playerid,"> Memakan Steak..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Memakan Steak..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	    SetPlayerAttachedObject(playerid, 3, 19835, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pHunger] += 40;
	    return 1;
    }
}
CMD:drinkcappucino(playerid, params[])
{
    if(pData[playerid][pCappucino] < 1) return ErrorMsg(playerid,"Anda tidak memiliki Cappucino!.");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
	if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
	    pData[playerid][pCappucino]--;
	    pData[playerid][sampahsaya]++;
	    Inventory_Update(playerid);
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Cappucino", "Removed_1x", 19835, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
	    SetPlayerChatBubble(playerid,"> Minum Cappucino..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Minum Cappucino..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	    SetPlayerAttachedObject(playerid, 3, 19835, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pEnergy] += 40;
	    return 1;
    }
}
CMD:drinkwater(playerid, params[])
{
    if(pData[playerid][pSprunk] < 1) return ErrorMsg(playerid,"Anda tidak memiliki water!.");
    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
    if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
		pData[playerid][sampahsaya]++;
    	pData[playerid][pSprunk]--;
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Water", "Removed_1x", 2958, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
		Inventory_Update(playerid);
	    SetPlayerChatBubble(playerid,"> Minum..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Minum..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	    SetPlayerAttachedObject(playerid, 3, 2958, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pEnergy] += 35;
	    return 1;
    }
}
CMD:drinkstarling(playerid, params[])
{
    if(pData[playerid][pStarling] < 1) return ErrorMsg(playerid,"Anda tidak memiliki starling!.");
    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
    if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
		pData[playerid][sampahsaya]++;
    	pData[playerid][pStarling]--;
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Starling", "Removed_1x", 1455, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
		Inventory_Update(playerid);
	    SetPlayerChatBubble(playerid,"> Minum Starling..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Minum Starling..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	    SetPlayerAttachedObject(playerid, 3, 1455, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pEnergy] += 30;
	    return 1;
    }
}
CMD:drinkmilk(playerid, params[])
{
    if(pData[playerid][pMilxMax] < 1) return ErrorMsg(playerid,"Anda tidak memiliki milk!.");
    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
    if(pData[playerid][sampahsaya] == 10) return ErrorMsg(playerid, "Buang sampah anda terlebih dahulu");
    {
		pData[playerid][sampahsaya]++;
    	pData[playerid][pMilxMax]--;
        Inventory_Close(playerid);
        ShowItemBox(playerid, "Milk_Max", "Removed_1x", 19570, 2);
		ShowItemBox(playerid, "Sampah", "Received_1x", 1265, 2);
		Inventory_Update(playerid);
	    SetPlayerChatBubble(playerid,"> Minum Susu..",COLOR_PURPLE,30.0,10000);
	    ShowProgressbar(playerid, "Minum MilxMax..", 1);
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0, 0, 0, 0, 0, 0,1);
	    SetPlayerAttachedObject(playerid, 3, 19570, 6, 0.000000, -0.025000, 0.066000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
		pData[playerid][pEnergy] += 30;
	    return 1;
    }
}
CMD:i(playerid, params[])
{
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	Inventory_Show(playerid);
	return 1;
}
CMD:h(playerid, params[])
{
    if(pData[playerid][pPhone] == 0) return ErrorMsg(playerid, "Anda tidak memiliki ponsel");
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    for(new i = 0; i < 21; i++)
    {
		TextDrawShowForPlayer(playerid, PhoneTD[i]);
	}
	TextDrawShowForPlayer(playerid, FINGERPRINT);
	TextDrawShowForPlayer(playerid, TANGGAL);
	TextDrawShowForPlayer(playerid, JAMLOCKSCREEN);
	new day, month, year;
    getdate(year,month,day);
   	new string[256];
	format(string, sizeof string, "%02d %s %02d", day, GetMonthName(month), year);
	TextDrawSetString(TANGGAL, string);
	SelectTextDraw(playerid, COLOR_BLUE);
	PlayerPlaySound(playerid, 3600, 0,0,0);
	return 1;
}
CMD:giveidcard(playerid, params[])
{
	if(pData[playerid][pIDCard] == 0) return ErrorMsg(playerid, "Anda tidak memiliki id card!");

	new otherid;
	if(sscanf(params, "u", otherid)) return SyntaxMsg(playerid, "/giveidcard [playerid/PartOfName]");

	new strings[256], fac[24];
	if(pData[playerid][pFaction] == 1)
	{
		fac = "Police";
	}
	else if(pData[playerid][pFaction] == 2)
	{
		fac = "Goverment";
	}
	else if(pData[playerid][pFaction] == 3)
	{
		fac = "Medic";
	}
	else if(pData[playerid][pFaction] == 4)
	{
		fac = "News";
	}
	else if(pData[playerid][pFaction] == 5)
	{
		fac = "Pedagang";
	}
	else if(pData[playerid][pFaction] == 6)
	{
		fac = "Gojek";
	}
	else
	{
		fac = "Pengangguran";
	}

	// Set name player
	format(strings, sizeof(strings), "%s", pData[playerid][pName]);
	PlayerTextDrawSetString(otherid, IDCard[playerid][17], strings);
	// Set birtdate
	format(strings, sizeof(strings), "%s", pData[playerid][pAge]);
	PlayerTextDrawSetString(otherid, IDCard[playerid][18], strings);
	// Set Job
	format(strings, sizeof(strings), "%s", fac);
	PlayerTextDrawSetString(otherid, IDCard[playerid][20], strings);
	// Set Expired IDCARD
	format(strings, sizeof(strings), "%s", ReturnTimelapse(gettime(), pData[playerid][pIDCardTime]));
	PlayerTextDrawSetString(otherid, IDCard[playerid][12], strings);
	// Set Skin Player
	if(GetPlayerSkin(playerid) != GetPVarInt(playerid, "ktp_skin"))
	{
		PlayerTextDrawSetPreviewModel(otherid, IDCard[playerid][24], GetPlayerSkin(playerid));
		PlayerTextDrawShow(otherid, IDCard[playerid][24]);
		SetPVarInt(playerid, "ktp_skin", GetPlayerSkin(playerid));
	}


	for(new txd; txd < 26; txd++)
	{
		PlayerTextDrawShow(otherid, IDCard[playerid][txd]);
		SelectTextDraw(otherid, 0x00FF00FF);
	}
	return 1;
}

CMD:hideidcard(playerid, params[])
{
	for(new txd; txd < 26; txd++)
	{
		PlayerTextDrawHide(playerid, IDCard[playerid][txd]);
	}
	return 1;
}

CMD:showidcard(playerid, params[])
{
	if(pData[playerid][pIDCard] == 0) return ErrorMsg(playerid, "Anda tidak memiliki id card!");

	new strings[256], fac[24];
	if(pData[playerid][pFaction] == 1)
	{
		fac = "Police";
	}
	else if(pData[playerid][pFaction] == 2)
	{
		fac = "Goverment";
	}
	else if(pData[playerid][pFaction] == 3)
	{
		fac = "Medic";
	}
	else if(pData[playerid][pFaction] == 4)
	{
		fac = "News";
	}
	else if(pData[playerid][pFaction] == 5)
	{
		fac = "Pedagang";
	}
	else if(pData[playerid][pFaction] == 6)
	{
		fac = "Gojek";
	}
	else
	{
		fac = "Pengangguran";
	}

	// Set name player
	format(strings, sizeof(strings), "%s", pData[playerid][pName]);
	PlayerTextDrawSetString(playerid, IDCard[playerid][17], strings);
	// Set birtdate
	format(strings, sizeof(strings), "%s", pData[playerid][pAge]);
	PlayerTextDrawSetString(playerid, IDCard[playerid][18], strings);
	// Set Job
	format(strings, sizeof(strings), "%s", fac);
	PlayerTextDrawSetString(playerid, IDCard[playerid][20], strings);
	// Set Expired IDCARD
	format(strings, sizeof(strings), "%s", ReturnTimelapse(gettime(), pData[playerid][pIDCardTime]));
	PlayerTextDrawSetString(playerid, IDCard[playerid][12], strings);
	// Set Skin Player
	if(GetPlayerSkin(playerid) != GetPVarInt(playerid, "ktp_skin"))
	{
		PlayerTextDrawSetPreviewModel(playerid, IDCard[playerid][24], GetPlayerSkin(playerid));
		PlayerTextDrawShow(playerid, IDCard[playerid][24]);
		SetPVarInt(playerid, "ktp_skin", GetPlayerSkin(playerid));
	}


	for(new txd; txd < 26; txd++)
	{
		PlayerTextDrawShow(playerid, IDCard[playerid][txd]);
		SelectTextDraw(playerid, 0x00FF00FF);
	}
	return 1;
}

CMD:hidelicensecard(playerid, params[])
{
	for(new txd; txd < 26; txd++)
	{
		PlayerTextDrawHide(playerid, LICCard[playerid][txd]);
	}
	return 1;
}

CMD:showlicensecard(playerid, params[])
{
	if(pData[playerid][pDriveLic] == 0) return ErrorMsg(playerid, "Anda tidak memiliki Driving License/SIM!");

	new strings[256], fac[24];
	if(pData[playerid][pFaction] == 1)
	{
		fac = "Police";
	}
	else if(pData[playerid][pFaction] == 2)
	{
		fac = "Goverment";
	}
	else if(pData[playerid][pFaction] == 3)
	{
		fac = "Medic";
	}
	else if(pData[playerid][pFaction] == 4)
	{
		fac = "News";
	}
	else if(pData[playerid][pFaction] == 5)
	{
		fac = "Pedagang";
	}
	else if(pData[playerid][pFaction] == 6)
	{
		fac = "Gojek";
	}
	else
	{
		fac = "Pengangguran";
	}

	// Set name player
	format(strings, sizeof(strings), "%s", pData[playerid][pName]);
	PlayerTextDrawSetString(playerid, LICCard[playerid][19], strings);

	// Set birtdate
	format(strings, sizeof(strings), "%s", pData[playerid][pAge]);
	PlayerTextDrawSetString(playerid, LICCard[playerid][20], strings);

	// Set Expired
	format(strings, sizeof(strings), "%s", ReturnTimelapse(gettime(), pData[playerid][pDriveLicTime]));
	PlayerTextDrawSetString(playerid, LICCard[playerid][12], strings);

	// Set Skin Player
	if(GetPlayerSkin(playerid) != GetPVarInt(playerid, "sim_skin"))
	{
		PlayerTextDrawSetPreviewModel(playerid, LICCard[playerid][25], GetPlayerSkin(playerid));
		PlayerTextDrawShow(playerid, LICCard[playerid][25]);
		SetPVarInt(playerid, "sim_skin", GetPlayerSkin(playerid));
	}


	for(new txd; txd < 26; txd++)
	{
		PlayerTextDrawShow(playerid, LICCard[playerid][txd]);
		SelectTextDraw(playerid, 0xFF0000FF);
	}
	return 1;
}

CMD:bshop(playerid, params[])
{
	if(pData[playerid][pFamily] == -1)
	return Error(playerid, "Kamu Bukan anggota family!");
	
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 291.35, -106.30, 1001.51)) return ErrorMsg(playerid, "Anda sedang tidak berada di black market");
	ShowPlayerDialog(playerid, DIALOG_BSHOP, DIALOG_STYLE_TABLIST_HEADERS, "BlackShop", "Barang\tHarga\nPanel Hacking\t{7fff00}$200", "Beli", "Keluar");
	return 1;
}



CMD:creatematext(playerid, params[])
{
	static
	    id,
		text[128];

	if(!pData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_WHITE, "ERROR: {FFFFFF}You don't have permission to use this Command!");

	if (sscanf(params, "s[128]", text))
	    return SendClientMessage(playerid, COLOR_WHITE, "SYNTAX: {FFFFFF}/creatematext [text]");

	id = Matext_Create(playerid, text);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_WHITE, "ERROR: {FFFFFF}The server has reached the limit for Material Text");

	SendClientMessageEx(playerid, COLOR_BLUE, "OBJECT: {FFFFFF}You have successfully Creating Material Text ID: %d.", id);
	EditDynamicObject(playerid, MatextData[id][mtCreate]);

	EditingMatext[playerid] = id;
	return 1;
}

CMD:createobject(playerid, params[])
{
	static
	    id,
		modelid;

	if(!pData[playerid][pAdmin])
	    return ErrorMsg(playerid, "You don't have permission to use this Command!");

	if (sscanf(params, "d", modelid))
	    return SendClientMessage(playerid, COLOR_WHITE, "SYNTAX: {FFFFFF}/createobject [modelid]");

	id = Object_Create(playerid, modelid);

	if (id == -1)
	    return SendClientMessage(playerid, COLOR_WHITE, "ERROR: {FFFFFF}The server has reached the limit for Created Object's");

	SendClientMessageEx(playerid, COLOR_WHITE, "OBJECT: {FFFFFF}You have successfully created Object ID: %d.", id);
	EditDynamicObject(playerid, ObjectData[id][objCreate]);

	EditingObject[playerid] = id;
	return 1;
}

CMD:editobject(playerid, params[])
{
	static
	    id,
	    type[24],
		string[128];

	if(!pData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_WHITE, "ERROR: {FFFFFF}You don't have permission to use this Command!");

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendClientMessage(playerid, COLOR_WHITE, "SYNTAX: {FFFFFF}/editobject [id] [option]");
	    SendClientMessage(playerid, COLOR_WHITE, "OPTION:{FFFFFF} position, model");
		return 1;
	}

	if ((id < 0 || id >= MAX_COBJECT) || !ObjectData[id][objExists])
	    return SendClientMessage(playerid, COLOR_WHITE, "ERROR: {FFFFFF} You have specified an invalid Created Object ID.");

	if (!strcmp(type, "position", true))
	{
		EditingObject[playerid] = id;
		ShowPlayerDialog(playerid, DIALOG_EDIT, DIALOG_STYLE_LIST, "Object Editing", "Edit with Move Object\nWith Coordinate", "Select", "Cancel");
	}
	else if(!strcmp(type, "model", true))
	{
	    new
	        mod;

	    if (sscanf(string, "d", mod))
	        return SendClientMessage(playerid, COLOR_WHITE, "SYNTAX: {FFFFFF}/editobject [id] [model] [modelid]");

		ObjectData[id][objModel] = mod;
		SendClientMessageEx(playerid, COLOR_WHITE, "OBJECT: {FFFFFF}Successfully Changed Model of Created Object ID %d", id);

		Object_Refresh(id);

		Object_Save(id);
	}
	return 1;
}

CMD:editmatext(playerid, params[])
{
	static
	    id,
	    type[24],
		string[128];

	if(!pData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_WHITE, "ERROR: {FFFFFF}You don't have permission to use this Command!");

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendClientMessage(playerid, COLOR_WHITE, "SYNTAX: {FFFFFF}/editmatext [id] [OPTION]");
	    SendClientMessage(playerid, COLOR_WHITE, "OPTION:{FFFFFF} bold, color, position, size");
		return 1;
	}
	if ((id < 0 || id >= MAX_MT) || !MatextData[id][mtExists])
	    return SendClientMessage(playerid, COLOR_WHITE, "ERROR: {FFFFFF}You have specified an invalid Material Text ID.");

	if (!strcmp(type, "size", true))
	{
	    new
	        ukuran;

	    if (sscanf(string, "d", ukuran))
	        return SendClientMessage(playerid, COLOR_WHITE, "SYNTAX: {FFFFFF}/editmatext [id] [size] [text size]");

		MatextData[id][mtSize] = ukuran;

		Matext_Refresh(id);
		Matext_Save(id);
		SendClientMessageEx(playerid, COLOR_WHITE, "MATEXT: {FFFFFF}Font Size changed to %d", ukuran);
	}
	else if (!strcmp(type, "color", true))
	{
	    new
	        col;

	    if (sscanf(string, "d", col))
	    {
			SendClientMessage(playerid, COLOR_WHITE, "SYNTAX: {FFFFFF}/editmatext [id] [color] [option]");
			SendClientMessage(playerid, COLOR_WHITE, "OPTION: {FFFFFF}1: White | 2: Blue | 3: Red | 4: Yellow");
		}

		if (col < 1 || col > 4)
		    return SendClientMessage(playerid, COLOR_WHITE, "ERROR: {FFFFFF}You have specified an invalid Color Option!");

		MatextData[id][mtColor] = col;

		Matext_Refresh(id);
		Matext_Save(id);
		SendClientMessageEx(playerid, COLOR_WHITE, "MATEXT: {FFFFFF}Material Text Color changed to Option %d", col);
	}
	else if (!strcmp(type, "position", true))
	{
	    EditingMatext[playerid] = id;

		ShowPlayerDialog(playerid, DIALOG_MTEDIT, DIALOG_STYLE_LIST, "Material Text", "With Move Object\nWith Coordinate", "Select", "Cancel");
	}
	else if (!strcmp(type, "bold", true))
	{
	    new
	        bold;

	    if (sscanf(string, "d", bold))
	    {
			SendClientMessage(playerid, COLOR_WHITE, "SYNTAX: {FFFFFF}/editmatext [id] [bold] [option]");
			SendClientMessage(playerid, COLOR_WHITE, "OPTION: {FFFFFF}0: No | 1: Yes");
		}

		if (bold < 1 || bold > 4)
		    return SendClientMessage(playerid, COLOR_WHITE, "ERROR: {FFFFFF}You have specified an invalid Bold Option!");

		MatextData[id][mtBold] = bold;

		Matext_Refresh(id);
		Matext_Save(id);
		SendClientMessageEx(playerid, COLOR_WHITE, "MATEXT: {FFFFFF}Material Text Bold changed to Option %d", bold);
	}
	return 1;
}

CMD:destroymatext(playerid, params[])
{
	static
	    id = 0;

	if(!pData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_WHITE, "ERROR: {FFFFFF}You don't have permission to use this Command!");

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "SYNTAX: {FFFFFF}/destroymatext [matextid]");

	if ((id < 0 || id >= MAX_MT) || !MatextData[id][mtExists])
	    return SendClientMessage(playerid, COLOR_WHITE, "ERROR: {FFFFFF} You have specified an invalid Material Text ID.");

	Matext_Delete(id);
	SendClientMessageEx(playerid, COLOR_WHITE, "OBJECT: {FFFFFF}You have successfully destroyed Material Text ID: %d.", id);
	return 1;
}

CMD:destroyobject(playerid, params[])
{
	static
	    id = 0;

	if(!pData[playerid][pAdmin])
	    return SendClientMessage(playerid, COLOR_WHITE, "ERROR: {FFFFFF}You don't have permission to use this Command!");

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, COLOR_WHITE, "SYNTAX: {FFFFFF}/destroyobject [object id]");

	if ((id < 0 || id >= MAX_COBJECT) || !ObjectData[id][objExists])
	    return SendClientMessage(playerid, COLOR_WHITE, "ERROR: {FFFFFF} You have specified an invalid Created Object ID.");

	Object_Delete(id);
	SendClientMessageEx(playerid, COLOR_WHITE, "OBJECT: {FFFFFF}You have successfully destroyed Created Object ID: %d.", id);
	return 1;
}

CMD:bbhelp(playerid, params[])
{
	SyntaxMsg(playerid, "/use boombox /setbb /pickupbb");
	return 1;
}

CMD:setbb(playerid, params[])
{
    if(pData[playerid][pBoombox] == 0)
	    return SendClientMessage(playerid, 0xCECECEFF, "Anda tidak memiliki boombox");

	if(GetPVarType(playerid, "PlacedBB"))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ")))
		{
			ShowPlayerDialog(playerid,DIALOG_BOOMBOX,DIALOG_STYLE_LIST,"Boombox","Turn Off Boombox\nInput URL","Select", "Cancel");
		}
		else
		{
   			return SendClientMessage(playerid, -1, "Anda tidak dekat dari boombox Anda");
		}
    }
    else
    {
        SendClientMessage(playerid, -1, "Anda tidak menempatkan boombox sebelumnya");
	}
	return 1;
}

CMD:pickupbb(playerid, params [])
{
    if(pData[playerid][pBoombox] == 0)
	    return SendClientMessage(playerid, 0xCECECEFF, "Anda tidak memiliki boombox");

	if(!GetPVarInt(playerid, "PlacedBB"))
    {
        SendClientMessage(playerid, -1, "Anda tidak perlu menempatkan boombox untuk diambil");
    }
	if(IsPlayerInRangeOfPoint(playerid, 3.0, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ")))
    {
        PickUpBoombox(playerid);
        SendClientMessage(playerid, -1, "boombox pickup");
    }
    return 1;
}
stock StopStream(playerid)
{
	DeletePVar(playerid, "pAudioStream");
    StopAudioStreamForPlayer(playerid);
}

stock PlayStream(playerid, url[], Float:posX = 0.0, Float:posY = 0.0, Float:posZ = 0.0, Float:distance = 50.0, usepos = 0)
{
	if(GetPVarType(playerid, "pAudioStream")) StopAudioStreamForPlayer(playerid);
	else SetPVarInt(playerid, "pAudioStream", 1);
    PlayAudioStreamForPlayer(playerid, url, posX, posY, posZ, distance, usepos);
}

stock PickUpBoombox(playerid)
{
    foreach(new i : Player)
	{
 		if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
   		{
     		StopStream(i);
		}
	}
	DeletePVar(playerid, "BBArea");
	DestroyDynamicObject(GetPVarInt(playerid, "PlacedBB"));
	DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "BBLabel"));
	DeletePVar(playerid, "PlacedBB"); DeletePVar(playerid, "BBLabel");
 	DeletePVar(playerid, "BBX"); DeletePVar(playerid, "BBY"); DeletePVar(playerid, "BBZ");
	DeletePVar(playerid, "BBInt");
	DeletePVar(playerid, "BBVW");
	DeletePVar(playerid, "BBStation");
	return 1;
}

CMD:help(playerid, params[])
{
	new str[512], info[512];
	format(str, sizeof(str), "Tentang\tPenjelasan\nHotKeys\t-> Berisi mengenai fungsi masing - masing tombol\nNeeds\t-> Petunjuk untuk Hbe System\nPerintah Dasar\t-> Berisi tentang petintah dasar\nPerintah Kendaraan\t-> Berisi tentang perintah kendaraan\nPerintah Organisasi\t-> Berisi tentang perintah organisasi\nPerintah Rumah\t-> Berisi tentang perintah rumah\nPerintah Bisnis\t-> Berisi tentang perintah bisnis");
	strcat(info, str);
	if(pData[playerid][pRobLeader] > 1 || pData[playerid][pMemberRob] > 1)
	{
		format(str, sizeof(str), "Robbery Help");
		strcat(info, str);	
	}
	ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Bantuan", info, "Pilih", "Tutup");
	return 1;
}

CMD:dcp(playerid)
{
    if(pData[playerid][pSideJob] > 1 || pData[playerid][pCP] > 1)
		return ErrorMsg(playerid, "Harap selesaikan Pekerjaan mu terlebih dahulu");
		
	DisablePlayerCheckpoint(playerid);
	DisablePlayerRaceCheckpoint(playerid);
	Servers(playerid, "Menghapus Checkpoint Sukses");
	return 1;
}
/*CMD:credits(playerid)
{
	new line1[1200], line2[300], line3[500];
	strcat(line3, ""LB_E"Coder: "YELLOW_E"Aufa for Update\n");
	strcat(line3, ""LB_E"Developer: "YELLOW_E"WagyuNanta (Aufa)\n");
	strcat(line3, ""LB_E"Website: "YELLOW_E"https://discord.gg/Executiverp\n");
	format(line2, sizeof(line2), ""LB_E"Server Support: "YELLOW_E"%s & All SA-MP Team\n\n\
	"GREEN_E"Terima kasih telah bergabung dengan kami! Copyright © 2022 | Executive Roleplay.", pData[playerid][pName]);
	format(line1, sizeof(line1), "%s%s", line3, line2);
   	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"Executive:RP: "WHITE_E"Server Credits", line1, "OK", "");
	return 1;
}*/

CMD:vip(playerid)
{
	new longstr2[3500];
	strcat(longstr2, ""YELLOW_E"Looking for bonus features and commands? Get premium status today!\n\n"RED_E"Premium features:\n\
	"dot""GREEN_E"VIP Regular(1) "PINK_E"Rp.30.000/month"RED_E"|| "PINK_E"Features:\n\
	"YELLOW_E"1) "WHITE_E"Gratis "LB_E"20 "WHITE_E"VIP Gold.\n");
	strcat(longstr2, ""YELLOW_E"2) "WHITE_E"Mendapat "GREEN_E"2 "WHITE_E"slot job.\n");

	strcat(longstr2, ""YELLOW_E"3) "WHITE_E"Akses custom VIP room dan VIP locker.\n\
	"YELLOW_E"4) "WHITE_E"Mempunya "LB_E"4 "WHITE_E"slot untuk kendaraan pribadi.\n\
	"YELLOW_E"5) "WHITE_E"Mempunya "LB_E"2 "WHITE_E"Slot untuk rumah.\n");
	strcat(longstr2, ""YELLOW_E"6) "WHITE_E"Mempunyai "LB_E"2 "WHITE_E"slot untuk bisnis.\n\
	"YELLOW_E"7) "WHITE_E"Akses VIP chat dan VIP status "LB_E"/vips"WHITE_E".\n");
	strcat(longstr2, ""YELLOW_E"8) "WHITE_E"Waktu Paycheck/Payday "LB_E"5% "WHITE_E"lebih cepat.\n\
	"YELLOW_E"9) "WHITE_E"Mendapatkan "LB_E"10% "WHITE_E"bunga bank setiap kali paycheck.");


	strcat(longstr2, "\n\n"dot""YELLOW_E"Premium(2) "PINK_E"Rp.50,000/month "RED_E"|| "PINK_E"Features:\n\
	"YELLOW_E"1) "WHITE_E"Gratis "LB_E"30"WHITE_E" VIP Gold.\n\
	"YELLOW_E"2) "WHITE_E"Mendapat "GREEN_E"2 "WHITE_E"slot job.\n");
	strcat(longstr2, ""YELLOW_E"3) "WHITE_E"Akses custom VIP room dan VIP locker.\n\
	"YELLOW_E"4) "WHITE_E"Mempunyai "LB_E"5 "WHITE_E"slot untuk kendaraan pribadi.");

	strcat(longstr2, "\n"YELLOW_E"5) "WHITE_E"Mempunyai "LB_E"3 "WHITE_E"Slot untuk rumah.\n\
	"YELLOW_E"6) "WHITE_E"Mempunyai "LB_E"3 "WHITE_E"slot untuk bisnis.\n\
	"YELLOW_E"7) "WHITE_E"Akses VIP chat dan VIP status "LB_E"/vips"WHITE_E".\n");
	strcat(longstr2, ""YELLOW_E"8) "WHITE_E"Waktu Paycheck/Payday "LB_E"10% "WHITE_E"lebih cepat\n\
	"YELLOW_E"9) "WHITE_E"Mendapatkan "LB_E"15% "WHITE_E"bunga bank setiap kali paycheck.");

	strcat(longstr2, "\n\n"dot""PURPLE_E"VIP Diamond(3) "PINK_E"Rp.80,000/month "RED_E"|| "PINK_E"Features:\n\
	"YELLOW_E"1) "WHITE_E"Gratis "LB_E"40 "WHITE_E"VIP Gold.\n\
	"YELLOW_E"2) "WHITE_E"Mendapat "GREEN_E"2 "WHITE_E"slot job.\n\
	"YELLOW_E"3) "WHITE_E"Akses custom VIP room dan VIP locker.");
	strcat(longstr2, "\n"YELLOW_E"4) "WHITE_E"Mempunyai "LB_E"6 "WHITE_E"slot untuk kendaraan pribadi.\n\
	"YELLOW_E"5) "WHITE_E"Mempunyai "LB_E"4 "WHITE_E"Slot untuk rumah.\n\
	"YELLOW_E"6) "WHITE_E"Mempunyai "LB_E"4 "WHITE_E"slot untuk bisnis.\n\
	"YELLOW_E"7) "WHITE_E"Akses VIP chat dan VIP status "LB_E"/vips"WHITE_E".");
	strcat(longstr2, "\n"YELLOW_E"8) "WHITE_E"Waktu Paycheck/Payday "LB_E"15% "WHITE_E"lebih cepat.\n\
	"YELLOW_E"9) "WHITE_E"Mendapatkan "LB_E"20% "WHITE_E"bunga bank setiap kali paycheck.");

	strcat(longstr2, "\n\n"LB_E"Pembayaran Dana/Gopay/Bank BCA. "LB2_E"Harga VIP Gold "LB_E"Rp.5,000/Per Hari.\n\
	"YELLOW_E"Untuk informasi selengkapnya hubungi Guluu (Server Owner & Founder)!");
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"Executive:RP "PINK_E"VIP SYSTEM", longstr2, "Close", "");
	return 1;
}

CMD:email(playerid)
{
    if(pData[playerid][IsLoggedIn] == false)
		return ErrorMsg(playerid, "Kamu harus login!");

	ShowPlayerDialog(playerid, DIALOG_EMAIL, DIALOG_STYLE_INPUT, ""WHITE_E"Set Email", ""WHITE_E"Masukkan Email.\nIni akan digunakan sebagai ganti kata sandi.\n\n"RED_E"* "WHITE_E"Email mu tidak akan termunculkan untuk Publik\n"RED_E"* "WHITE_E"Email hanya berguna untuk verifikasi Password yang terlupakan dan berita lainnya\n\
	"RED_E"* "WHITE_E"Be sure to double-check and enter a valid email address!", "Enter", "Exit");
	return 1;
}

CMD:changepass(playerid)
{
    if(pData[playerid][IsLoggedIn] == false)
		return ErrorMsg(playerid, "Kamu harus login sebelum menggantinya!");

	ShowPlayerDialog(playerid, DIALOG_PASSWORD, DIALOG_STYLE_INPUT, ""WHITE_E"Change your password", "Masukkan Password untuk menggantinya!", "Change", "Exit");
	InfoTD_MSG(playerid, 3000, "~g~~h~Masukkan password yang sebelum nya anda pakai!");
	return 1;
}

CMD:Executivetopup(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return ErrorMsg(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	new Dstring[512];
	//format(Dstring, sizeof(Dstring), "Executive TOP-UP\tPrice\n\Ganti Nama\t500 Coin\n");
	format(Dstring, sizeof(Dstring), "Executive TOP-UP\tPrice\nGanti Nama\t800 Coin\n");
	format(Dstring, sizeof(Dstring), "%sClear warning\t1000 Coin\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sVIP Level 1(7 Days)\t100 Coin\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sVIP Level 2(7 Days)\t150 Coin\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sVIP Level 3(7 Days)\t200 Coin\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sUang IC 10,000\t200 Coin\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sMakanan 100\t150 Coin\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sMinuman 100\t150 Coin\n", Dstring);
	format(Dstring, sizeof(Dstring), "%Level +5\t70 Coin\n", Dstring);
	format(Dstring, sizeof(Dstring), "%Darah Full\t10 Coin\n", Dstring);
	format(Dstring, sizeof(Dstring), "%Darah Putih Full\t20 Coin\n", Dstring);
	format(Dstring, sizeof(Dstring), "%Material 100\t120 Coin\n", Dstring);
	format(Dstring, sizeof(Dstring), "%Component 100\t120 Coin\n", Dstring);
	format(Dstring, sizeof(Dstring), "%Skin/baju bebas pilih\t200 Coin\n", Dstring);
	format(Dstring, sizeof(Dstring), "%Kendaraan Import bebas pilih\t500 Coin\n", Dstring);
	ShowPlayerDialog(playerid, DIALOG_GOLDSHOP, DIALOG_STYLE_TABLIST_HEADERS, "Coin Executive", Dstring, "Buy", "Cancel");
	return 1;
}

CMD:getcord(playerid, params[])
{
	new int, Float:px,Float:py,Float:pz, Float:a;
	GetPlayerPos(playerid, px, py, pz);
	GetPlayerFacingAngle(playerid, a);
	int = GetPlayerInterior(playerid);
	new zone[MAX_ZONE_NAME];
	GetPlayer3DZone(playerid, zone, sizeof(zone));
	SendClientMessageEx(playerid, COLOR_WHITE, "Lokasi Anda Saat Ini: %s (%0.2f, %0.2f, %0.2f, %0.2f) Int = %d", zone, px, py, pz, a, int);
	return 1;
}

CMD:death(playerid, params[])
{
    if(pData[playerid][pInjured] == 0)
        return 1;
        
    if(pData[playerid][pJail] > 0)
        return ErrorMsg(playerid, "You can't do this when in jail!");
        
    if(pData[playerid][pArrest] > 0)
        return ErrorMsg(playerid, "You can't do this when in arrest sapd!");

    if((gettime()-GetPVarInt(playerid, "GiveUptime")) < 100)
        return ErrorMsg(playerid, "You must waiting 3 minutes for spawn to hospital");

    Servers(playerid, "You have given up and accepted your death.");
    pData[playerid][pHospitalTime] = 0;
    pData[playerid][pHospital] = 1;

    HideTdDeath(playerid);
    return 1;
}

CMD:sleep(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return ErrorMsg(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(pData[playerid][pInjured] == 1)
        return ErrorMsg(playerid, "Kamu tidak bisa melakukan ini disaat yang tidak tepat!");
	
	if(pData[playerid][pInHouse] == -1)
		return ErrorMsg(playerid, "Kamu tidak berada didalam rumah.");
	
	InfoTD_MSG(playerid, 10000, "Sleeping... Harap Tunggu");
	TogglePlayerControllable(playerid, 0);
	new time = (100 - pData[playerid][pEnergy]) * (400);
    SetTimerEx("UnfreezeSleep", time, 0, "i", playerid);
	switch(random(6))
	{
		case 0: ApplyAnimation(playerid, "INT_HOUSE", "BED_In_L",4.1,0,0,0,1,1);
		case 1: ApplyAnimation(playerid, "INT_HOUSE", "BED_In_R",4.1,0,0,0,1,1);
		case 2: ApplyAnimation(playerid, "INT_HOUSE", "BED_Loop_L",4.1,1,0,0,1,1);
		case 3: ApplyAnimation(playerid, "INT_HOUSE", "BED_Loop_R",4.1,1,0,0,1,1);
		case 4: ApplyAnimation(playerid, "INT_HOUSE", "BED_Out_L",4.1,0,1,1,0,0);
		case 5: ApplyAnimation(playerid, "INT_HOUSE", "BED_Out_R",4.1,0,1,1,0,0);
	}
	return 1;
}

CMD:ktp(playerid, params[])
{
	if(pData[playerid][pIDCard] == 0) return ErrorMsg(playerid, "Anda tidak memiliki ktp!");
	new sext[40];
	if(pData[playerid][pGender] == 1) { sext = "Male"; } else { sext = "Female"; }
	SendNearbyMessage(playerid, 20.0, COLOR_GREEN, "[ID-Card] "GREY3_E"Name: %s | Gender: %s | Brithday: %s | Expire: %s.", pData[playerid][pName], sext, pData[playerid][pAge], ReturnTimelapse(gettime(), pData[playerid][pIDCardTime]));
	return 1;
}

CMD:bpjs(playerid, params[])
{
	if(pData[playerid][pBpjs] == 0) return ErrorMsg(playerid, "Anda tidak memiliki bpjs card!");
	new sext[40];
	if(pData[playerid][pGender] == 1) { sext = "Male"; } else { sext = "Female"; }
	SendNearbyMessage(playerid, 20.0, COLOR_GREEN, "[BPJS-Card] "GREY3_E"Name: %s | Gender: %s | Brithday: %s | Expire: %s.", pData[playerid][pName], sext, pData[playerid][pAge], ReturnTimelapse(gettime(), pData[playerid][pIDCardTime]));
	return 1;
}

CMD:drivelic(playerid, params[])
{
	if(pData[playerid][pDriveLic] == 0) return ErrorMsg(playerid, "Anda tidak memiliki Driving License/SIM!");
	new sext[40];
	if(pData[playerid][pGender] == 1) { sext = "Male"; } else { sext = "Female"; }
	SendNearbyMessage(playerid, 20.0, COLOR_GREEN, "[Drive-Lic] "GREY3_E"Name: %s | Gender: %s | Brithday: %s | Expire: %s.", pData[playerid][pName], sext, pData[playerid][pAge], ReturnTimelapse(gettime(), pData[playerid][pDriveLicTime]));
	return 1;
}

CMD:buatktp(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1444.531616,-23.858947,-55.601955)) return ErrorMsg(playerid, "Anda harus berada di kantor pemerintah!");
	if(pData[playerid][pIDCard] != 0) return ErrorMsg(playerid, "Anda sudah memiliki ID Card!");
	new sext[40], mstr[128];
	if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(mstr, sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nBerlaku hingga 14 hari!", pData[playerid][pName], pData[playerid][pAge], sext);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "ID-Card", mstr, "Tutup", "");
	pData[playerid][pIDCard] = 1;
	pData[playerid][pIDCardTime] = gettime() + (30 * 86400);
	Server_AddMoney(25);
	ShowItemBox(playerid, "Ktp", "Received_1x", 1581, 4);
	return 1;
}

/*CMD:kasihktp(playerid, params[])
{
	if(IsPlayerConnected(playerid)) 
	{
		new name[24], ammount, otherid;
        if(sscanf(params, "us[24]d", otherid))
		{
			SyntaxMsg(playerid, "/give [playerid]");

			return 1;
		}
	}
}*/

CMD:newbpjs(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1330.39, 1566.83, 3010.90)) return ErrorMsg(playerid, "Anda harus berada di rumah sakit!");
	if(pData[playerid][pBpjs] != 0) return ErrorMsg(playerid, "Anda sudah memiliki Bpjs Card!");
	if(GetPlayerMoney(playerid) < 100) return ErrorMsg(playerid, "Anda butuh $100 untuk membuat Bpjs Card");
	new sext[40], mstr[128];
	if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(mstr, sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nBerlaku hingga 14 hari!", pData[playerid][pName], pData[playerid][pAge], sext);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "ID-Card", mstr, "Tutup", "");
	pData[playerid][pBpjs] = 1;
	pData[playerid][pBpjsTime] = gettime() + (30 * 86400);
	GivePlayerMoneyEx(playerid, -100);
	Server_AddMoney(25);
	return 1;
}

CMD:newdrivelic(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1295.64, -1367.56, 15.47)) return ErrorMsg(playerid, "Anda harus berada di Kantor kepolisian!");
	if(pData[playerid][pDriveLic] != 0) return ErrorMsg(playerid, "Anda sudah memiliki sim!");
	if(GetPlayerMoney(playerid) < 700) return ErrorMsg(playerid, "Anda butuh $700 untuk membuat sim.");
	pData[playerid][pDriveLic] = 1;
	pData[playerid][pDriveLicTime] = gettime() + (30 * 86400);
	GivePlayerMoneyEx(playerid, -700);
	ShowItemBox(playerid, "Uang", "REMOVED_$700", 1212, 4);
	Server_AddMoney(700);
	SuccesMsg(playerid, "Selamat Anda telah berhasil membuat SIM");
	return 1;
}
CMD:payticket(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1295.64, -1367.56, 15.47) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1295.64, -1367.56, 15.47)) return ErrorMsg(playerid, "Anda harus berada di kantor SAPD!");
	
	new vehid;
	if(sscanf(params, "d", vehid))
		return SyntaxMsg(playerid, "/payticket [vehid] | /myv - for find vehid");
		
	if(vehid == INVALID_VEHICLE_ID || !IsValidVehicle(vehid))
		return ErrorMsg(playerid, "Invalid id");
		
	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				new ticket = pvData[i][cTicket];
				
				if(ticket > GetPlayerMoney(playerid))
					return ErrorMsg(playerid, "Not enough money! check your ticket in /v insu.");
					
				if(ticket > 0)
				{
					GivePlayerMoneyEx(playerid, -ticket);
					pvData[i][cTicket] = 0;
					Info(playerid, "Anda telah berhasil membayar ticket tilang kendaraan %s(id: %d) sebesar "RED_E"%s", GetVehicleName(vehid), vehid, FormatMoney(ticket));
					return 1;
				}
			}
			else return ErrorMsg(playerid, "Kendaraan ini bukan milik anda! /myv - for find vehid");
		}
	}
	return 1;
}

CMD:buyplate(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1295.64, -1367.56, 15.47)) return ErrorMsg(playerid, "Anda harus berada di Kantor Polisi!");
		
	new vehid;
	if(sscanf(params, "d", vehid)) return SyntaxMsg(playerid, "/buyplate [vehid] | /myv - for find vehid");
	
	if(vehid == INVALID_VEHICLE_ID || !IsValidVehicle(vehid))
		return ErrorMsg(playerid, "Invalid id");
			
	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				if(GetPlayerMoney(playerid) < 500) return ErrorMsg(playerid, "Anda butuh $500 untuk membeli Plate baru.");
				GivePlayerMoneyEx(playerid, -500);
				new rand = RandomEx(1111, 9999);
				format(pvData[i][cPlate], 32, "GI-%d", rand);
				SetVehicleNumberPlate(pvData[i][cVeh], pvData[i][cPlate]);
				pvData[i][cPlateTime] = gettime() + (15 * 86400);
				ShowItemBox(playerid, "Uang", "REMOVED_$500", 1212, 4);
				Info(playerid, "Model: %s || New plate: %s || Plate Time: %s || Plate Price: $500", GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cPlateTime]));
			}
			else return ErrorMsg(playerid, "ID kendaraan ini bukan punya mu! gunakan /myv untuk mencari ID.");
		}
	}
	return 1;
}

CMD:sellpv(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1516.3483,-2177.7971,13.6174)) return ErrorMsg(playerid, "Kamu harus berada di Kantor Insurance!");
	
	new vehid;
	if(sscanf(params, "d", vehid)) return SyntaxMsg(playerid, "/sellpv [vehid] | /myv - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return ErrorMsg(playerid, "Invalid id");
			
	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				if(!IsValidVehicle(pvData[i][cVeh])) return ErrorMsg(playerid, "Your vehicle is not spanwed!");
				if(pvData[i][cRent] != 0) return ErrorMsg(playerid, "You can't sell rental vehicle!");
				new pay = pvData[i][cPrice] / 2;
				GivePlayerMoneyEx(playerid, pay);
				
				Info(playerid, "Anda menjual kendaraan model %s(%d) dengan seharga "LG_E"%s", GetVehicleName(vehid), GetVehicleModel(vehid), FormatMoney(pay));
				new str[150];
				format(str,sizeof(str),"[VEH]: %s menjual kendaraan %s seharga %s!", GetRPName(playerid), GetVehicleName(vehid), FormatMoney(pay));
				LogServer("Property", str);
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[i][cID]);
				mysql_tquery(g_SQL, query);
				if(IsValidVehicle(pvData[i][cVeh])) DestroyVehicle(pvData[i][cVeh]);
				pvData[i][cVeh] = INVALID_VEHICLE_ID;
				Iter_SafeRemove(PVehicles, i, i);
			}
			else return ErrorMsg(playerid, "ID kendaraan ini bukan punya mu! gunakan /myv untuk mencari ID.");
		}
	}
	return 1;
}

CMD:newrek(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1448.5902,-1134.6410,23.9580)) return ErrorMsg(playerid, "Anda harus berada di Bank!");
	if(GetPlayerMoney(playerid) < 50) return ErrorMsg(playerid, "Not enough money!");
	new query[128], rand = RandomEx(111111, 999999);
	new rek = rand+pData[playerid][pID];
	mysql_format(g_SQL, query, sizeof(query), "SELECT brek FROM players WHERE brek='%d'", rek);
	mysql_tquery(g_SQL, query, "BankRek", "id", playerid, rek);
	Info(playerid, "New rekening bank!");
	GivePlayerMoneyEx(playerid, -50);
	Server_AddMoney(50);
	return 1;
}

CMD:bank(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1456.1683,-1128.3212,23.9580)) return ErrorMsg(playerid, "Anda harus berada di bank point!");
	new tstr[128];
	format(tstr, sizeof(tstr), ""ORANGE_E"No Rek: "LB_E"%d", pData[playerid][pBankRek]);
	ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, tstr, "Deposit Money\nWithdraw Money\nCheck Balance\nTransfer Money\nSign Paycheck", "Select", "Cancel");
	return 1;
}
CMD:handsup(playerid, params[])
{
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
	return 1;
}

CMD:getjobd(playerid, params[]) {
    if(!IsPlayerInRangeOfPoint(playerid, 6.0, 2355.0962, -658.8605, 128.0284))  return 1;
    if(JOB[playerid] != 0)  return SendClientMessage(playerid, ATENTIE, "Error: You already have a job. Type in [/quitjob]");
 
    JOB[playerid] = 1;
    inJOB[playerid] = 0;
    SendClientMessage(playerid, -1, "{1E90FF} You got a job at Hunter. To start work type[/work]. ");
 
    return 1;
}
 
CMD:workd(playerid, params[]) {
        if(!IsPlayerInRangeOfPoint(playerid, 1.0, 2351.7666, -658.1649, 128.0146)) {
            if(inJOB[playerid] == 1) return 1;
            else {
                SendClientMessage(playerid, ATENTIE, "* You have to be at the WORK place. Follow the CP on the map! ");
                SetPlayerCheckpoint(playerid, 2351.7666, -658.1649, 128.0146, 3.5); 
            }
        }else {
            if(inJOB[playerid] == 1)
                 SendClientMessage(playerid, ATENTIE, "Eroare: Deja muncesti! ");
            else {
                inJOB[playerid] = 1;
                new rand = random(3);
                switch(rand) {
                    case 1: {
                        Car_Job[playerid] = CreateVehicle(505, 2406.9773, -403.4681, 72.4926, -180.5998, 225, 142, 100);
                    }
                    case 2: {
                        Car_Job[playerid] = CreateVehicle(505, 2406.9773, -403.4681, 72.4926, 1.5600, 120, 131, 100);
                    }
                    default: Car_Job[playerid] = CreateVehicle(505, 2406.9773, -403.4681, 72.4926, 1.5600, 162, 215, 100);
                }
                GivePlayerWeapon(playerid, 33, 99999);
                PutPlayerInVehicle(playerid, Car_Job[playerid], 0);
                Deep_Deer[playerid] = 0;
                Shoot_Deer[playerid] = 0;
 
                SetTimerEx("Next_Deer", 1000, false, "i", playerid);
        }
    }
 
    return 1;
}
 
CMD:jobd(playerid, params[]) {
    SetPlayerPos(playerid, 2351.7666, -658.1649, 128.0146);
 
    return 1;
}

CMD:stats(playerid, params[])
{
	if(pData[playerid][IsLoggedIn] == false)
	{
	    ErrorMsg(playerid, "You must be logged in to check statistics!");
	    return 1;
	}
	
	DisplayStats(playerid, playerid);
	return 1;
}

CMD:settings(playerid)
{
	if(pData[playerid][IsLoggedIn] == false)
	{
	    ErrorMsg(playerid, "You must be logged in to check statistics!");
	    return 1;
	}
	
	new str[1024], hbemode[64], togpm[64], toglog[64], togads[64], togwt[64];
	if(pData[playerid][pHBEMode] == 1)
	{
		hbemode = ""LG_E"Enable (1)";
	}
 	else if(pData[playerid][pHBEMode] == 2)
	{
		hbemode = ""LG_E"Enable (2)";
	}
	else if(pData[playerid][pHBEMode] == 3)
	{
		hbemode = ""LG_E"Enable (3)";
	}
	else
	{
		hbemode = ""RED_E"Disable";
	}
	
	if(pData[playerid][pTogPM] == 0)
	{
		togpm = ""RED_E"Disable";
	}
	else
	{
		togpm = ""LG_E"Enable";
	}
	
	if(pData[playerid][pTogLog] == 0)
	{
		toglog = ""RED_E"Disable";
	}
	else
	{
		toglog = ""LG_E"Enable";
	}
	
	if(pData[playerid][pTogAds] == 0)
	{
		togads = ""RED_E"Disable";
	}
	else
	{
		togads = ""LG_E"Enable";
	}
	
	if(pData[playerid][pTogWT] == 0)
	{
		togwt = ""RED_E"Disable";
	}
	else
	{
		togwt = ""LG_E"Enable";
	}
	
	format(str, sizeof(str), "Settings\tStatus\n"WHITEP_E"Email:\t"GREY3_E"%s\n"WHITEP_E"Change Password\n"WHITEP_E"HUD HBE Mode:\t%s\n"WHITEP_E"Toggle PM:\t%s\n"WHITEP_E"Toggle Log Server:\t%s\n"WHITEP_E"Toggle Ads:\t%s\n"WHITEP_E"Toggle WT:\t%s",
	pData[playerid][pEmail], 
	hbemode, 
	togpm,
	toglog,
	togads,
	togwt
	);
	
	ShowPlayerDialog(playerid, DIALOG_SETTINGS, DIALOG_STYLE_TABLIST_HEADERS, "Settings", str, "Set", "Close");
	return 1;
}

CMD:frisk(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/frisk [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "Player tidak berada didekat mu.");

    if(otherid == playerid)
        return Error(playerid, "Kamu tidak bisa memeriksa dirimu sendiri.");

    pData[otherid][pFriskOffer] = playerid;

    Info(otherid, "%s has offered to frisk you (type \"/accept frisk or /deny frisk\").", ReturnName(playerid));
    Info(playerid, "You have offered to frisk %s.", ReturnName(otherid));
	return 1;
}

CMD:inspect(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/inspect [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "Player tidak berada didekat mu.");

    if(otherid == playerid)
        return Error(playerid, "Kamu tidak bisa memeriksa dirimu sendiri.");

    pData[otherid][pInsOffer] = playerid;

    Info(otherid, "%s has offered to inspect you (type \"/accept inspect or /deny inspect\").", ReturnName(playerid));
    Info(playerid, "You have offered to inspect %s.", ReturnName(otherid));
	return 1;
}

CMD:reqloc(playerid, params[])
{
	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/reqloc [playerid/PartOfName]");

    if(pData[playerid][pPhone] < 1)
    	return Error(playerid, "Anda tidak memiliki Handphone");

    if(otherid == playerid)
        return Error(playerid, "Kamu tidak bisa meminta lokasi kepada anda sendiri.");

    pData[otherid][pLocOffer] = playerid;

    Info(otherid, "%s telah menawarkan untuk meminta berbagi lokasinya (type \"/accept reqloc or /deny reqloc\").", ReturnName(playerid));
    Info(playerid, "Anda telah menawarkan untuk membagikan lokasi Anda %s.", ReturnName(otherid));
	return 1;
}

CMD:accept(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(IsPlayerConnected(playerid)) 
	{
        if(isnull(params)) 
		{
            SyntaxMsg(playerid, "SyntaxMsg: /accept [name]");
            Info(playerid, "Names: faction, family, drag, frisk, inspect, job, reqloc, rob");
            return 1;
        }
		if(strcmp(params,"faction",true) == 0) 
		{
            if(IsPlayerConnected(pData[playerid][pFacOffer])) 
			{
                if(pData[playerid][pFacInvite] > 0) 
				{
                    pData[playerid][pFaction] = pData[playerid][pFacInvite];
					pData[playerid][pFactionRank] = 1;
					Info(playerid, "Anda telah menerima invite faction dari %s", pData[pData[playerid][pFacOffer]][pName]);
					Info(pData[playerid][pFacOffer], "%s telah menerima invite faction yang anda tawari", pData[playerid][pName]);
					pData[playerid][pFacInvite] = 0;
					pData[playerid][pFacOffer] = -1;
				}
				else
				{
					Error(playerid, "Invalid faction id!");
					return 1;
				}
            }
            else 
			{
                Error(playerid, "Tidak ada player yang menawari anda!");
                return 1;
            }
        }
		if(strcmp(params,"family",true) == 0) 
		{
            if(IsPlayerConnected(pData[playerid][pFamOffer])) 
			{
                if(pData[playerid][pFamInvite] > -1) 
				{
                    pData[playerid][pFamily] = pData[playerid][pFamInvite];
					pData[playerid][pFamilyRank] = 1;
					Info(playerid, "Anda telah menerima invite family dari %s", pData[pData[playerid][pFamOffer]][pName]);
					Info(pData[playerid][pFamOffer], "%s telah menerima invite family yang anda tawari", pData[playerid][pName]);
					pData[playerid][pFamInvite] = 0;
					pData[playerid][pFamOffer] = -1;
				}
				else
				{
					Error(playerid, "Invalid family id!");
					return 1;
				}
            }
            else 
			{
                Error(playerid, "Tidak ada player yang menawari anda!");
                return 1;
            }
        }
		else if(strcmp(params,"drag",true) == 0)
		{
			new dragby = GetPVarInt(playerid, "DragBy");
			if(dragby == INVALID_PLAYER_ID || dragby == playerid)
				return Error(playerid, "Player itu Disconnect.");
        
			if(!NearPlayer(playerid, dragby, 5.0))
				return Error(playerid, "Kamu harus didekat Player.");
        
			pData[playerid][pDragged] = 1;
			pData[playerid][pDraggedBy] = dragby;

			pData[playerid][pDragTimer] = SetTimerEx("DragUpdate", 1000, true, "ii", dragby, playerid);
			SendNearbyMessage(dragby, 30.0, COLOR_PURPLE, "* %s grabs %s and starts dragging them, (/undrag).", ReturnName(dragby), ReturnName(playerid));
			return true;
		}
		else if(strcmp(params,"frisk",true) == 0)
		{
			if(pData[playerid][pFriskOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pFriskOffer]))
				return Error(playerid, "Player tersebut belum masuk!");
			
			if(!NearPlayer(playerid, pData[playerid][pFriskOffer], 5.0))
				return Error(playerid, "Kamu harus didekat Player.");
				
			DisplayItems(pData[playerid][pFriskOffer], playerid);
			Servers(playerid, "Anda telah berhasil menaccept tawaran frisk kepada %s.", ReturnName(pData[playerid][pFriskOffer]));
			pData[playerid][pFriskOffer] = INVALID_PLAYER_ID;
		}
		else if(strcmp(params,"inspect",true) == 0)
		{
			if(pData[playerid][pInsOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pFriskOffer]))
				return Error(playerid, "Player tersebut belum masuk!");
			
			if(!NearPlayer(playerid, pData[playerid][pInsOffer], 5.0))
				return Error(playerid, "Kamu harus didekat Player.");
				
			new hstring[512], info[512];
			new hh = pData[playerid][pHead];
			new hp = pData[playerid][pPerut];
			new htk = pData[playerid][pRHand];
			new htka = pData[playerid][pLHand];
			new hkk = pData[playerid][pRFoot];
			new hkka = pData[playerid][pLFoot];
			format(hstring, sizeof(hstring),"Bagian Tubuh\tKondisi\n{ffffff}Kepala\t{7fffd4}%d.0%\n{ffffff}Perut\t{7fffd4}%d.0%\n{ffffff}Tangan Kanan\t{7fffd4}%d.0%\n{ffffff}Tangan Kiri\t{7fffd4}%d.0%\n",hh,hp,htk,htka);
			strcat(info, hstring);
			format(hstring, sizeof(hstring),"{ffffff}Kaki Kanan\t{7fffd4}%d.0%\n{ffffff}Kaki Kiri\t{7fffd4}%d.0%\n",hkk,hkka);
			strcat(info, hstring);
			ShowPlayerDialog(pData[playerid][pInsOffer],DIALOG_HEALTH,DIALOG_STYLE_TABLIST_HEADERS,"Health Condition",info,"Oke","");
			Servers(playerid, "Anda telah berhasil menaccept tawaran Inspect kepada %s.", ReturnName(pData[playerid][pInsOffer]));
			pData[playerid][pInsOffer] = INVALID_PLAYER_ID;
		}
		else if(strcmp(params,"job",true) == 0) 
		{
			if(pData[playerid][pGetJob] > 0)
			{
				pData[playerid][pJob] = pData[playerid][pGetJob];
				Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
				pData[playerid][pGetJob] = 0;
				pData[playerid][pExitJob] = gettime() + (1 * 21600);
			}
			else if(pData[playerid][pGetJob2] > 0)
			{
				pData[playerid][pJob2] = pData[playerid][pGetJob2];
				Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
				pData[playerid][pGetJob2] = 0;
				pData[playerid][pExitJob] = gettime() + (1 * 21600);
			}
		}
		else if(strcmp(params,"reqloc",true) == 0)
		{
			if(pData[playerid][pLocOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pLocOffer]))
				return Error(playerid, "Player tersebut belum masuk!");
				
			new Float:sX, Float:sY, Float:sZ;
			GetPlayerPos(playerid, sX, sY, sZ);
			SetPlayerCheckpoint(pData[playerid][pLocOffer], sX, sY, sZ, 5.0);
			Servers(playerid, "Anda telah berhasil menaccept tawaran Share Lokasi kepada %s.", ReturnName(pData[playerid][pLocOffer]));
			Servers(pData[playerid][pLocOffer], "Lokasi %s telah tertandai.", ReturnName(playerid));
			pData[playerid][pLocOffer] = INVALID_PLAYER_ID;
		}
		else if(strcmp(params,"rob",true) == 0)
		{
			if(pData[playerid][pRobOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pRobOffer]))
				return Error(playerid, "Player tersebut belum masuk!");
			
			Servers(playerid, "Anda telah berhasil menaccept tawaran bergabung kedalam Robbery %s.", ReturnName(pData[playerid][pRobOffer]));
			Servers(pData[playerid][pRobOffer], "%s Menerima ajakan Robbing anda.", ReturnName(playerid));
			pData[playerid][pRobOffer] = INVALID_PLAYER_ID;
			pData[playerid][pMemberRob] = 1;
			pData[pData[playerid][pRobOffer]][pRobMember] += 1;
			RobMember += 1;
		}
	}
	return 1;
}

CMD:deny(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(IsPlayerConnected(playerid)) 
	{
        if(isnull(params)) 
		{
            SyntaxMsg(playerid, "/deny [name]");
            Info(playerid, "Names: drag, faction, frisk, inspect, reqloc, rob");
            return 1;
        }
		if(strcmp(params,"faction",true) == 0) 
		{
            if(pData[playerid][pFacOffer] > -1) 
			{
                if(pData[playerid][pFacInvite] > 0) 
				{
					Info(playerid, "Anda telah menolak faction dari %s", ReturnName(pData[playerid][pFacOffer]));
					Info(pData[playerid][pFacOffer], "%s telah menolak invite faction yang anda tawari", ReturnName(playerid));
					pData[playerid][pFacInvite] = 0;
					pData[playerid][pFacOffer] = -1;
				}
				else
				{
					Error(playerid, "Invalid faction id!");
					return 1;
				}
            }
            else 
			{
                Error(playerid, "Tidak ada player yang menawari anda!");
                return 1;
            }
        }
		else if(strcmp(params,"drag",true) == 0)
		{
			new dragby = GetPVarInt(playerid, "DragBy");
			if(dragby == INVALID_PLAYER_ID || dragby == playerid)
				return Error(playerid, "Player itu Disconnect.");

			Info(playerid, "Anda telah menolak drag.");
			Info(dragby, "Player telah menolak drag yang anda tawari.");
			
			DeletePVar(playerid, "DragBy");
			pData[playerid][pDragged] = 0;
			pData[playerid][pDraggedBy] = INVALID_PLAYER_ID;
			return 1;
		}
		else if(strcmp(params,"frisk",true) == 0)
		{
			if(pData[playerid][pFriskOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pFriskOffer]))
				return Error(playerid, "Player tersebut belum masuk!");
			
			Info(playerid, "Anda telah menolak tawaran frisk kepada %s.", ReturnName(pData[playerid][pFriskOffer]));
			pData[playerid][pFriskOffer] = INVALID_PLAYER_ID;
			return 1;
		}
		else if(strcmp(params,"inspect",true) == 0)
		{
			if(pData[playerid][pInsOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pInsOffer]))
				return Error(playerid, "Player tersebut belum masuk!");
			
			Info(playerid, "Anda telah menolak tawaran Inspect kepada %s.", ReturnName(pData[playerid][pInsOffer]));
			pData[playerid][pInsOffer] = INVALID_PLAYER_ID;
			return 1;
		}
		else if(strcmp(params,"reqloc",true) == 0) 
		{
			if(pData[playerid][pLocOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pLocOffer]))
				return Error(playerid, "Player tersebut belum masuk!");
			
			Info(playerid, "Anda telah menolak tawaran Share Lokasi kepada %s.", ReturnName(pData[playerid][pLocOffer]));
			pData[playerid][pLocOffer] = INVALID_PLAYER_ID;
		}
		else if(strcmp(params,"rob",true) == 0) 
		{
			if(pData[playerid][pRobOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pRobOffer]))
				return Error(playerid, "Player tersebut belum masuk!");
			
			Info(playerid, "Anda telah menolak tawaran Rob kepada %s.", ReturnName(pData[playerid][pRobOffer]));
			pData[playerid][pRobOffer] = INVALID_PLAYER_ID;
		}
	}
	return 1;
}

CMD:give(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(IsPlayerConnected(playerid)) 
	{
		new name[24], ammount, otherid;
        if(sscanf(params, "us[24]d", otherid, name, ammount))
		{
			SyntaxMsg(playerid, "/give [playerid] [name] [ammount]");
			Info(playerid, "Names: bandage, ayamfillet, cigarette, redmoney, potato, food, pizza, burger, chiken");
			Info(playerid, "Names: cola, mineral, medicine, snack, sprunk, material, component, marijuana, obat, gps");
			Info(playerid, "Names: borak, kecubung");
			return 1;
		}
		if(otherid == INVALID_PLAYER_ID || otherid == playerid || !NearPlayer(playerid, otherid, 3.0))
			return Error(playerid, "Invalid playerid!");
			
		if(strcmp(name,"bandage",true) == 0) 
		{
			if(pData[playerid][pBandage] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");
			
			pData[playerid][pBandage] -= ammount;
			pData[otherid][pBandage] += ammount;
			Info(playerid, "Anda telah berhasil memberikan perban kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan perban kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"medicine",true) == 0) 
		{
			if(pData[playerid][pMedicine] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");
			
			pData[playerid][pMedicine] -= ammount;
			pData[otherid][pMedicine] += ammount;
			Info(playerid, "Anda telah berhasil memberikan medicine kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan medicine kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"cigarette",true) == 0)
		{
			if(pData[playerid][pCig] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");

			pData[playerid][pCig] -= ammount;
			pData[otherid][pCig] += ammount;
			Info(playerid, "Anda telah berhasil memberikan cigarette kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan cigarette kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"snack",true) == 0) 
		{
			if(pData[playerid][pSnack] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");
			
			pData[playerid][pSnack] -= ammount;
			pData[otherid][pSnack] += ammount;
			Info(playerid, "Anda telah berhasil memberikan snack kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan snack kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"pizza",true) == 0)
		{
			if(pData[playerid][pPizza] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");

			pData[playerid][pPizza] -= ammount;
			pData[otherid][pPizza] += ammount;
			Info(playerid, "Anda telah berhasil memberikan pizza kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan pizza kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"ayamfillet",true) == 0)
		{
			if(pData[playerid][AyamFillet] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");

			pData[playerid][AyamFillet] -= ammount;
			pData[otherid][AyamFillet] += ammount;
			Info(playerid, "Anda telah berhasil memberikan ayam fillet kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan ayam fillet kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"burger",true) == 0)
		{
			if(pData[playerid][pBurger] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");

			pData[playerid][pBurger] -= ammount;
			pData[otherid][pBurger] += ammount;
			Info(playerid, "Anda telah berhasil memberikan burger kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan burger kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"chiken",true) == 0)
		{
			if(pData[playerid][pSnack] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");

			pData[playerid][pChiken] -= ammount;
			pData[otherid][pChiken] += ammount;
			Info(playerid, "Anda telah berhasil memberikan fried chiken kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan fried chiken kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"mineral",true) == 0)
		{
			if(pData[playerid][pMineral] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");

			pData[playerid][pMineral] -= ammount;
			pData[otherid][pMineral] += ammount;
			Info(playerid, "Anda telah berhasil memberikan air mineral kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan air mineral kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"potato",true) == 0)
		{
			if(pData[playerid][pPotato] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");

			pData[playerid][pPotato] -= ammount;
			pData[otherid][pPotato] += ammount;
			Info(playerid, "Anda telah berhasil memberikan potato kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan potato kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"food",true) == 0)
		{
			if(pData[playerid][pFood] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");

			pData[playerid][pFood] -= ammount;
			pData[otherid][pFood] += ammount;
			Info(playerid, "Anda telah berhasil memberikan food kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan food kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"cola",true) == 0)
		{
			if(pData[playerid][pCola] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");

			pData[playerid][pCola] -= ammount;
			pData[otherid][pCola] += ammount;
			Info(playerid, "Anda telah berhasil memberikan coca cola kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan coca cola kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"redmoney",true) == 0) 
		{
			if(pData[playerid][pRedMoney] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");
			
			pData[playerid][pRedMoney] -= ammount;
			pData[otherid][pRedMoney] += ammount;
			Info(playerid, "Anda telah berhasil memberikan redmoney kepada %s sejumlah %s.", ReturnName(otherid), FormatMoney(ammount));
			Info(otherid, "%s telah berhasil memberikan redmoney kepada anda sejumlah %s.", ReturnName(playerid), FormatMoney(ammount));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"sprunk",true) == 0) 
		{
			if(pData[playerid][pSprunk] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");
			
			pData[playerid][pSprunk] -= ammount;
			pData[otherid][pSprunk] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Sprunk kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan Sprunk kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"material",true) == 0) 
		{
			if(pData[playerid][pMaterial] < ammount)
				return Error(playerid, "Item anda tidak cukup.");
			
			if(ammount > 500)
				return Error(playerid, "Invalid ammount 1 - 500");
			
			new maxmat = pData[otherid][pMaterial] + ammount;
			
			if(maxmat > 500)
				return Error(playerid, "That player already have maximum material!");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");
			
			pData[playerid][pMaterial] -= ammount;
			pData[otherid][pMaterial] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Material kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan Material kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"component",true) == 0) 
		{
			if(pData[playerid][pComponent] < ammount)
				return Error(playerid, "Item anda tidak cukup.");
			
			if(ammount > 500)
				return Error(playerid, "Invalid ammount 1 - 500");
			
			new maxcomp = pData[otherid][pComponent] + ammount;
			
			if(maxcomp > 500)
				return Error(playerid, "That player already have maximum component!");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");
			
			pData[playerid][pComponent] -= ammount;
			pData[otherid][pComponent] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Component kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan Component kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"marijuana",true) == 0) 
		{
			if(pData[playerid][pMarijuana] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");
			
			pData[playerid][pMarijuana] -= ammount;
			pData[otherid][pMarijuana] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Marijuana kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan Marijuana kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"obat",true) == 0) 
		{
			if(pData[playerid][pObat] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");
			
			pData[playerid][pObat] -= ammount;
			pData[otherid][pObat] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Obat kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan Obat kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"gps",true) == 0) 
		{
			if(pData[playerid][pGPS] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");
			
			pData[playerid][pGPS] -= ammount;
			pData[otherid][pGPS] += ammount;
			Info(playerid, "Anda telah berhasil memberikan GPS kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan GPS kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"borax",true) == 0) 
		{
			if(pData[playerid][pBorax] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");
			
			pData[playerid][pBorax] -= ammount;
			pData[otherid][pBorax] += ammount;
			Info(playerid, "Anda telah berhasil memberikan BORAX kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan BORAX kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"kecubung",true) == 0) 
		{
			if(pData[playerid][pKecubung] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");
			
			pData[playerid][pKecubung] -= ammount;
			pData[otherid][pKecubung] += ammount;
			Info(playerid, "Anda telah berhasil memberikan KECUBUNG kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan KECUBUNG kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"paketkecubung",true) == 0) 
		{
			if(pData[playerid][pPaketkecubung] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");
			
			pData[playerid][pPaketkecubung] -= ammount;
			pData[otherid][pPaketkecubung] += ammount;
			Info(playerid, "Anda telah berhasil memberikan PAKET KECUBUNG kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan PAKET KECUBUNG kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"paketborax",true) == 0) 
		{
			if(pData[playerid][pPaketborax] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return Error(playerid, "Can't Give below 1");
			
			pData[playerid][pPaketborax] -= ammount;
			pData[otherid][pPaketborax] += ammount;
			Info(playerid, "Anda telah berhasil memberikan PAKET BORAX kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan PAKET BORAX kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
	}
	return 1;
}

CMD:use(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	if(IsPlayerConnected(playerid)) 
	{
        if(isnull(params)) 
		{
            SyntaxMsg(playerid, "SyntaxMsg: /use [name]");
            Info(playerid, "Names: bandage, cigarette, snack, pizza, burger, chiken, cola, mineral, , sprunk, gas, medicine, marijuana, obat, boombox");
            return 1;
        }
		if(strcmp(params,"bandage",true) == 0) 
		{
			if(pData[playerid][pBandage] < 1)
				return Error(playerid, "Anda tidak memiliki perban.");
			
			new Float:darah;
			GetPlayerHealth(playerid, darah);
			pData[playerid][pBandage]--;
			SetPlayerHealthEx(playerid, darah+15);
			Info(playerid, "Anda telah berhasil menggunakan perban.");
			InfoTD_MSG(playerid, 3000, "Restore +15 Health");
		}
		else if(strcmp(params,"snack",true) == 0) 
		{
			if(pData[playerid][pSnack] < 1)
				return Error(playerid, "Anda tidak memiliki snack.");
			
			pData[playerid][pSnack]--;
			pData[playerid][pHunger] += 10;
			Info(playerid, "Anda telah berhasil menggunakan snack.");
			InfoTD_MSG(playerid, 3000, "Restore +10 Hunger");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"pizza",true) == 0)
		{
			if(pData[playerid][pPizza] < 1)
				return Error(playerid, "Anda tidak memiliki pizza.");

			pData[playerid][pPizza]--;
			pData[playerid][pHunger] += 25;
			Info(playerid, "Anda telah berhasil menggunakan pizza.");
			InfoTD_MSG(playerid, 3000, "Restore +25 Hunger");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"burger",true) == 0)
		{
			if(pData[playerid][pBurger] < 1)
				return Error(playerid, "Anda tidak memiliki burger.");

			pData[playerid][pBurger]--;
			pData[playerid][pHunger] += 20;
			Info(playerid, "Anda telah berhasil menggunakan burger.");
			InfoTD_MSG(playerid, 3000, "Restore +20 Hunger");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"chiken",true) == 0)
		{
			if(pData[playerid][pChiken] < 1)
				return Error(playerid, "Anda tidak memiliki fried chiken.");

			pData[playerid][pChiken]--;
			pData[playerid][pHunger] += 23;
			Info(playerid, "Anda telah berhasil menggunakan fried chiken.");
			InfoTD_MSG(playerid, 3000, "Restore +23 Hunger");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"cigarette",true) == 0)
		{
			if(pData[playerid][pCig] < 1)
				return Error(playerid, "Anda tidak memiliki rokok.");

			pData[playerid][pCig]--;
			Info(playerid, "Anda menyalakan rokok.");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"cola",true) == 0)
		{
			if(pData[playerid][pCola] < 1)
				return Error(playerid, "Anda tidak memiliki coca cola.");

			pData[playerid][pCola]--;
			pData[playerid][pEnergy] += 20;
			Info(playerid, "Anda telah berhasil meminum coca cola.");
			InfoTD_MSG(playerid, 3000, "Restore +20 Energy");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"mineral",true) == 0)
		{
			if(pData[playerid][pMineral] < 1)
				return Error(playerid, "Anda tidak memiliki air mineral.");

			pData[playerid][pSprunk]--;
			pData[playerid][pEnergy] += 8;
			Info(playerid, "Anda telah berhasil meminum air mineral.");
			InfoTD_MSG(playerid, 3000, "Restore +8 Energy");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"sprunk",true) == 0) 
		{
			if(pData[playerid][pSprunk] < 1)
				return Error(playerid, "Anda tidak memiliki sprunk.");
			
			pData[playerid][pSprunk]--;
			pData[playerid][pEnergy] += 10;
			Info(playerid, "Anda telah berhasil meminum sprunk.");
			InfoTD_MSG(playerid, 3000, "Restore +10 Energy");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		/*else if(strcmp(params,"sprunk",true) == 0) 
		{
			if(pData[playerid][pSprunk] < 1)
				return Error(playerid, "Anda tidak memiliki snack.");
			
			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_SPRUNK);
			//SendNearbyMessage(playerid, 10.0, COLOR_PURPLE,"* %s opens a can of sprunk.", ReturnName(playerid));
			SetPVarInt(playerid, "UsingSprunk", 1);
			pData[playerid][pSprunk]--;
		}*/
		else if(strcmp(params,"gas",true) == 0) 
		{
			if(pData[playerid][pGas] < 1)
				return Error(playerid, "Anda tidak memiliki gas.");
				
			if(IsPlayerInAnyVehicle(playerid))
				return Error(playerid, "Anda harus berada diluar kendaraan!");
			
			if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
			
			new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			if(IsValidVehicle(vehicleid))
			{
				new fuel = GetVehicleFuel(vehicleid);
			
				if(GetEngineStatus(vehicleid))
					return Error(playerid, "Turn off vehicle engine.");
			
				if(fuel >= 999.0)
					return Error(playerid, "This vehicle gas is full.");
			
				if(!IsEngineVehicle(vehicleid))
					return Error(playerid, "This vehicle can't be refull.");

				if(!GetHoodStatus(vehicleid))
					return Error(playerid, "The hood must be opened before refull the vehicle.");

				pData[playerid][pGas]--;
				Info(playerid, "Don't move from your position or you will failed to refulling this vehicle.");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				pData[playerid][pActivityStatus] = 1;
				pData[playerid][pActivity] = ("RefullCar", 1000, true, "id", playerid, vehicleid);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Refulling...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				/*InfoTD_MSG(playerid, 10000, "Refulling...");
				//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s starts to refulling the vehicle.", ReturnName(playerid));*/
				return 1;
			}
		}
		else if(strcmp(params,"medicine",true) == 0) 
		{
			if(pData[playerid][pMedicine] < 1)
				return Error(playerid, "Anda tidak memiliki medicine.");
			
			pData[playerid][pMedicine]--;
			pData[playerid][pSick] = 0;
			pData[playerid][pSickTime] = 0;
			SetPlayerDrunkLevel(playerid, 0);
			Info(playerid, "Anda menggunakan medicine.");
			
			//InfoTD_MSG(playerid, 3000, "Restore +15 Hunger");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"obat",true) == 0) 
		{
			if(pData[playerid][pObat] < 1)
				return Error(playerid, "Anda tidak memiliki Obat Myricous.");
			
			pData[playerid][pObat]--;
			pData[playerid][pSick] = 0;
			pData[playerid][pSickTime] = 0;
			pData[playerid][pHead] = 100;
			pData[playerid][pPerut] = 100;
			pData[playerid][pRHand] = 100;
			pData[playerid][pLHand] = 100;
			pData[playerid][pRFoot] = 100;
			pData[playerid][pLFoot] = 100;
			SetPlayerDrunkLevel(playerid, 0);
			Info(playerid, "Anda menggunakan Obat Myricous.");
			
			//InfoTD_MSG(playerid, 3000, "Restore +15 Hunger");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"marijuana",true) == 0) 
		{
			if(pData[playerid][pMarijuana] < 1)
				return Error(playerid, "You dont have marijuana.");
			
			new Float:armor;
			GetPlayerArmour(playerid, armor);
			if(armor+10 > 90) return Error(playerid, "Over dosis!");
			
			pData[playerid][pMarijuana]--;
			SetPlayerArmourEx(playerid, armor+10);
			SetPlayerDrunkLevel(playerid, 4000);
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"boombox",true) == 0)
		{
			if(pData[playerid][pBoombox] < 1)
				return Error(playerid, "Anda tidak memiliki boombox");

			new string[128], Float:BBCoord[4], pNames[MAX_PLAYER_NAME];
		    GetPlayerPos(playerid, BBCoord[0], BBCoord[1], BBCoord[2]);
		    GetPlayerFacingAngle(playerid, BBCoord[3]);
		    SetPVarFloat(playerid, "BBX", BBCoord[0]);
		    SetPVarFloat(playerid, "BBY", BBCoord[1]);
		    SetPVarFloat(playerid, "BBZ", BBCoord[2]);
		    GetPlayerName(playerid, pNames, sizeof(pNames));
		    BBCoord[0] += (2 * floatsin(-BBCoord[3], degrees));
		   	BBCoord[1] += (2 * floatcos(-BBCoord[3], degrees));
		   	BBCoord[2] -= 1.0;
			if(GetPVarInt(playerid, "PlacedBB")) return SCM(playerid, -1, "Kamu Sudah Memasang Boombox");
			foreach(new i : Player)
			{
		 		if(GetPVarType(i, "PlacedBB"))
		   		{
		  			if(IsPlayerInRangeOfPoint(playerid, 30.0, GetPVarFloat(i, "BBX"), GetPVarFloat(i, "BBY"), GetPVarFloat(i, "BBZ")))
					{
		   				SendClientMessage(playerid, COLOR_WHITE, "Kamu Tidak Dapat Memasang Boombox Disini, Karena Orang Sudah Lain Sudah Memasang Boombox Disini");
					    return 1;
					}
				}
			}
			new string2[128];
			format(string2, sizeof(string2), "%s Telah Memasang Boombox!", pNames);
			SendNearbyMessage(playerid, 15, COLOR_PURPLE, string2);
			SetPVarInt(playerid, "PlacedBB", CreateDynamicObject(2102, BBCoord[0], BBCoord[1], BBCoord[2], 0.0, 0.0, 0.0, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid)));
			format(string, sizeof(string), "Creator "WHITE_E"%s\n["RED_E"/bbhelp for info"WHITE_E"]", pNames);
			SetPVarInt(playerid, "BBLabel", _:CreateDynamic3DTextLabel(string, COLOR_YELLOW, BBCoord[0], BBCoord[1], BBCoord[2]+0.6, 5, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid)));
			SetPVarInt(playerid, "BBArea", CreateDynamicSphere(BBCoord[0], BBCoord[1], BBCoord[2], 30.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)));
			SetPVarInt(playerid, "BBInt", GetPlayerInterior(playerid));
			SetPVarInt(playerid, "BBVW", GetPlayerVirtualWorld(playerid));
			ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
		    ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
		}
	}
	return 1;
}

CMD:enter(playerid, params[])
{
	if(pData[playerid][pInjured] == 0)
    {
		foreach(new did : Doors)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ]))
			{
				if(dData[did][dGarage] == 1 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
				{
					if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
						return Error(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

					if(dData[did][dLocked])
						return Error(playerid, "Bangunan ini di Kunci untuk sementara.");
						
					if(dData[did][dFaction] > 0)
					{
						if(dData[did][dFaction] != pData[playerid][pFaction])
							return Error(playerid, "Pintu ini hanya untuk fraksi.");
					}
					if(dData[did][dFamily] > 0)
					{
						if(dData[did][dFamily] != pData[playerid][pFamily])
							return Error(playerid, "Pintu ini hanya untuk Family.");
					}
					
					if(dData[did][dVip] > pData[playerid][pVip])
						return Error(playerid, "VIP Level mu tidak cukup.");
					
					if(dData[did][dAdmin] > pData[playerid][pAdmin])
						return Error(playerid, "Admin level mu tidak cukup.");
						
					if(strlen(dData[did][dPass]))
					{
						if(sscanf(params, "s[256]", params)) return SyntaxMsg(playerid, "/enter [password]");
						if(strcmp(params, dData[did][dPass])) return Error(playerid, "Password Salah.");
						
						if(dData[did][dCustom])
						{
							SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						else
						{
							SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						pData[playerid][pInDoor] = did;
						SetPlayerInterior(playerid, dData[did][dIntint]);
						SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, 0);
					}
					else
					{
						if(dData[did][dCustom])
						{
							SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						else
						{
							SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						pData[playerid][pInDoor] = did;
						SetPlayerInterior(playerid, dData[did][dIntint]);
						SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, 0);
					}
				}
				else
				{
					if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
						return Error(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

					if(dData[did][dLocked])
						return Error(playerid, "Pintu ini ditutup sementara");
						
					if(dData[did][dFaction] > 0)
					{
						if(dData[did][dFaction] != pData[playerid][pFaction])
							return Error(playerid, "Pintu ini hanya untuk faction.");
					}
					if(dData[did][dFamily] > 0)
					{
						if(dData[did][dFamily] != pData[playerid][pFamily])
							return Error(playerid, "Pintu ini hanya untuk family.");
					}
					
					if(dData[did][dVip] > pData[playerid][pVip])
						return Error(playerid, "Your VIP level not enough to enter this door.");
					
					if(dData[did][dAdmin] > pData[playerid][pAdmin])
						return Error(playerid, "Your admin level not enough to enter this door.");

					if(strlen(dData[did][dPass]))
					{
						if(sscanf(params, "s[256]", params)) return SyntaxMsg(playerid, "/enter [password]");
						if(strcmp(params, dData[did][dPass])) return Error(playerid, "Invalid door password.");
						
						if(dData[did][dCustom])
						{
							SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						else
						{
							SetPlayerPosition(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						pData[playerid][pInDoor] = did;
						SetPlayerInterior(playerid, dData[did][dIntint]);
						SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, 0);
					}
					else
					{
						if(dData[did][dCustom])
						{
							SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						else
						{
							SetPlayerPosition(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						pData[playerid][pInDoor] = did;
						SetPlayerInterior(playerid, dData[did][dIntint]);
						SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, 0);
					}
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ]))
			{
				if(dData[did][dGarage] == 1 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
				{
					if(dData[did][dFaction] > 0)
					{
						if(dData[did][dFaction] != pData[playerid][pFaction])
							return Error(playerid, "Pintu ini hanya untuk faction.");
					}
				
					if(dData[did][dCustom])
					{
						SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
					}
					else
					{
						SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
					}
					pData[playerid][pInDoor] = -1;
					SetPlayerInterior(playerid, dData[did][dExtint]);
					SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, WorldWeather);
				}
				else
				{
					if(dData[did][dFaction] > 0)
					{
						if(dData[did][dFaction] != pData[playerid][pFaction])
							return Error(playerid, "Pintu ini hanya untuk faction.");
					}
					
					if(dData[did][dCustom])
						SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);

					else
						SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
					
					pData[playerid][pInDoor] = -1;
					SetPlayerInterior(playerid, dData[did][dExtint]);
					SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, WorldWeather);
				}
			}
        }
		//Houses
		foreach(new hid : Houses)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
			{
				if(hData[hid][hIntposX] == 0.0 && hData[hid][hIntposY] == 0.0 && hData[hid][hIntposZ] == 0.0)
					return Error(playerid, "Interior house masih kosong, atau tidak memiliki interior.");

				if(hData[hid][hLocked])
					return Error(playerid, "Rumah ini terkunci!");
				
				pData[playerid][pInHouse] = hid;
				SetPlayerPositionEx(playerid, hData[hid][hIntposX], hData[hid][hIntposY], hData[hid][hIntposZ], hData[hid][hIntposA]);

				SetPlayerInterior(playerid, hData[hid][hInt]);
				SetPlayerVirtualWorld(playerid, hid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inhouseid = pData[playerid][pInHouse];
		if(pData[playerid][pInHouse] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, hData[inhouseid][hIntposX], hData[inhouseid][hIntposY], hData[inhouseid][hIntposZ]))
		{
			SetPlayerPositionEx(playerid, hData[inhouseid][hExtposX], hData[inhouseid][hExtposY], hData[inhouseid][hExtposZ], hData[inhouseid][hExtposA]);

			pData[playerid][pInHouse] = -1;
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Bisnis
		foreach(new bid : Bisnis)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]))
			{
				if(bData[bid][bIntposX] == 0.0 && bData[bid][bIntposY] == 0.0 && bData[bid][bIntposZ] == 0.0)
					return Error(playerid, "Interior bisnis masih kosong, atau tidak memiliki interior.");

				if(bData[bid][bLocked])
					return Error(playerid, "Bisnis ini Terkunci!");
					
				pData[playerid][pInBiz] = bid;
				SetPlayerPositionEx(playerid, bData[bid][bIntposX], bData[bid][bIntposY], bData[bid][bIntposZ], bData[bid][bIntposA]);
				
				SetPlayerInterior(playerid, bData[bid][bInt]);
				SetPlayerVirtualWorld(playerid, bid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inbisnisid = pData[playerid][pInBiz];
		if(pData[playerid][pInBiz] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, bData[inbisnisid][bIntposX], bData[inbisnisid][bIntposY], bData[inbisnisid][bIntposZ]))
		{
			SetPlayerPositionEx(playerid, bData[inbisnisid][bExtposX], bData[inbisnisid][bExtposY], bData[inbisnisid][bExtposZ], bData[inbisnisid][bExtposA]);
			
			pData[playerid][pInBiz] = -1;
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Family
		foreach(new fid : FAMILYS)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ]))
			{
				if(fData[fid][fIntposX] == 0.0 && fData[fid][fIntposY] == 0.0 && fData[fid][fIntposZ] == 0.0)
					return Error(playerid, "Interior masih kosong, atau tidak memiliki interior.");

				if(pData[playerid][pFaction] == 0)
					if(pData[playerid][pFamily] == -1)
						return Error(playerid, "You dont have registered for this door!");
					
				pData[playerid][pInFamily] = fid;		
				SetPlayerPositionEx(playerid, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ], fData[fid][fIntposA]);

				SetPlayerInterior(playerid, fData[fid][fInt]);
				SetPlayerVirtualWorld(playerid, fid);
				SetCameraBehindPlayer(playerid);
				//pData[playerid][pInBiz] = fid;
				SetPlayerWeather(playerid, 0);
			}
			new difamily = pData[playerid][pInFamily];
			if(pData[playerid][pInFamily] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, fData[difamily][fIntposX], fData[difamily][fIntposY], fData[difamily][fIntposZ]))
			{
				pData[playerid][pInFamily] = -1;	
				SetPlayerPositionEx(playerid, fData[difamily][fExtposX], fData[difamily][fExtposY], fData[difamily][fExtposZ], fData[difamily][fExtposA]);

				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, WorldWeather);
			}
        }
	}
	return 1;
}

CMD:drag(playerid, params[])
{
	new otherid;
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/drag [playerid/PartOfName] || /undrag [playerid]");

    if(otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player itu Disconnect.");

    if(otherid == playerid)
        return Error(playerid, "Kamu tidak bisa menarik diri mu sendiri.");

    if(!NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "Kamu harus didekat Player.");

    if(!pData[otherid][pInjured])
        return Error(playerid, "kamu tidak bisa drag orang yang tidak mati.");

    SetPVarInt(otherid, "DragBy", playerid);
    Info(otherid, "%s Telah menawari drag kepada anda, /accept drag untuk menerimanya /deny drag untuk membatalkannya.", ReturnName(playerid));
	Info(playerid, "Anda berhasil menawari drag kepada player %s", ReturnName(otherid));
    return 1;
}

CMD:undrag(playerid, params[])
{
	new otherid;
    if(sscanf(params, "u", otherid)) return SyntaxMsg(playerid, "/undrag [playerid]");
	if(pData[otherid][pDragged])
    {
        DeletePVar(playerid, "DragBy");
        DeletePVar(otherid, "DragBy");
        pData[otherid][pDragged] = 0;
        pData[otherid][pDraggedBy] = INVALID_PLAYER_ID;

        KillTimer(pData[otherid][pDragTimer]);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s releases %s from their grip.", ReturnName(playerid), ReturnName(otherid));
    }
    return 1;
}

CMD:mask(playerid, params[])
{
	if(pData[playerid][pMask] <= 0)
		return Error(playerid, "Anda tidak memiliki topeng!");

	switch (pData[playerid][pMaskOn])
    {
        case 0:
        {
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes out a mask and puts it on.", ReturnName(playerid));
            pData[playerid][pMaskOn] = 1;
            new string[35];
            GetPlayerName(playerid, string, sizeof(string));
            format(string,sizeof(string), "Mask_%d", pData[playerid][pMaskID]);
      	 	SetPlayerName(playerid, string);
			for(new i = GetPlayerPoolSize(); i != -1; --i)
			{
				ShowPlayerNameTagForPlayer(i, playerid, 0);
			}
			//SetPlayerAttachedObject(playerid, 9, 18911, 2,0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754);
        }
        case 1:
        {
            pData[playerid][pMaskOn] = 0;
            SetPlayerName(playerid, pData[playerid][pName]);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes their mask off and puts it away.", ReturnName(playerid));
			for(new i = GetPlayerPoolSize(); i != -1; --i)
			{
				ShowPlayerNameTagForPlayer(i, playerid, 1);
			}
			//RemovePlayerAttachedObject(playerid, 9);
        }
    }
	return 1;
}
/*
CMD:mask(playerid, params[])
{
	if(pData[playerid][pMask] <= 0)
		return Error(playerid, "Anda tidak memiliki topeng!");
		
	switch (pData[playerid][pMaskOn])
    {
        case 0:
        {
			for(new i = GetPlayerPoolSize(); i != -1; --i)
			{
				new sstring[64];
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes out a mask and puts it on.", ReturnName(playerid));
				pData[playerid][pMaskOn] = 1;
				format(sstring, sizeof(sstring), "%s", ReturnName(playerid));
				pData[playerid][pMaskLabel] = CreateDynamic3DTextLabel(sstring, -1, 0, 0, -10, 10.0, playerid);
				Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, pData[playerid][pMaskLabel] , E_STREAMER_ATTACH_OFFSET_Z, 0.30);
				SendClientMessage(playerid, COLOR_ORANGE, "[MASKINFO]: {FFFFFF}Mask {00D900}ON!");
				ShowPlayerNameTagForPlayer(i, playerid, 0);
				return 1;
			}	
        }
        case 1:
        {
			for(new i = GetPlayerPoolSize(); i != -1; --i)
			{
				DestroyDynamic3DTextLabel(pData[playerid][pMaskLabel]);
				pData[playerid][pMaskOn] = 0;
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes their mask off and puts it away.", ReturnName(playerid));
				SendClientMessage(playerid, COLOR_ORANGE, "[MASKINFO]: {FFFFFF}Mask {FF0000}OFF!");
				ShowPlayerNameTagForPlayer(i, playerid, 1);
				return 1;
			}	
        }
    }
	return 1;
}
*/
CMD:stuck(playerid)
{
	if(pData[playerid][pFreeze] == 1)
		return Error(playerid, "Anda sedang di Freeze oleh staff, tidak dapat menggunakan ini");

	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	ShowPlayerDialog(playerid, DIALOG_STUCK, DIALOG_STYLE_LIST,"Stuck Options","Tersangkut DiGedung\nTersangkut setelah masuk/keluar Interior\nTersangkut diKendaraan","Pilih","Batal");
	return 1;
}
//Text and Chat Commands
CMD:try(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    if(isnull(params))
        return SyntaxMsg(playerid, "/try [action]");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s %.64s ..", ReturnName(playerid), params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s, %s", params[64], (random(2) == 0) ? ("and success") : ("but fail"));
    }
    else {
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s %s, %s", ReturnName(playerid), params, (random(2) == 0) ? ("and success") : ("but fail"));
    }
	printf("[TRY] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:ado(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    new flyingtext[164], Float:x, Float:y, Float:z;

    if(isnull(params))
	{
        SyntaxMsg(playerid, "/ado [text]");
		Info(playerid, "Use /ado off to disable or delete the ado tag.");
		return 1;
	}
    if(strlen(params) > 128)
        return Error(playerid, "Max text can only maximmum 128 characters.");

    if (!strcmp(params, "off", true))
    {
        if (!pData[playerid][pAdoActive])
            return Error(playerid, "You're not actived your 'ado' text.");

        if (IsValidDynamic3DTextLabel(pData[playerid][pAdoTag]))
            DestroyDynamic3DTextLabel(pData[playerid][pAdoTag]);

        Servers(playerid, "You're removed your ado text.");
        pData[playerid][pAdoActive] = false;
        return 1;
    }

    FixText(params);
    format(flyingtext, sizeof(flyingtext), "* %s *\n(( %s ))", ReturnName(playerid), params);

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [ADO]: %.64s ..", params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s", params[64]);
    }
    else 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [ADO]: %s", params);
    }

    GetPlayerPos(playerid, x, y, z);
    if(pData[playerid][pAdoActive])
    {
        if (IsValidDynamic3DTextLabel(pData[playerid][pAdoTag]))
            UpdateDynamic3DTextLabelText(pData[playerid][pAdoTag], COLOR_PURPLE, flyingtext);
        else
            pData[playerid][pAdoTag] = CreateDynamic3DTextLabel(flyingtext, COLOR_PURPLE, x, y, z, 15, _, _, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    }
    else
    {
        pData[playerid][pAdoActive] = true;
        pData[playerid][pAdoTag] = CreateDynamic3DTextLabel(flyingtext, COLOR_PURPLE, x, y, z, 15, _, _, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    }
	printf("[ADO] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:ab(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    new flyingtext[164], Float:x, Float:y, Float:z;

    if(isnull(params))
	{
        SyntaxMsg(playerid, "/ab [text]");
		Info(playerid, "Use /ab off to disable or delete the ado tag.");
		return 1;
	}
    if(strlen(params) > 128)
        return Error(playerid, "Max text can only maximmum 128 characters.");

    if (!strcmp(params, "off", true))
    {
        if (!pData[playerid][pBActive])
            return Error(playerid, "You're not actived your 'ab' text.");

        if (IsValidDynamic3DTextLabel(pData[playerid][pBTag]))
            DestroyDynamic3DTextLabel(pData[playerid][pBTag]);

        Servers(playerid, "You're removed your ab text.");
        pData[playerid][pBActive] = false;
        return 1;
    }

    FixText(params);
    format(flyingtext, sizeof(flyingtext), "* %s *\n(( OOC : %s ))", ReturnName(playerid), params);

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [AB]: %.64s ..", params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s", params[64]);
    }
    else 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [AB]: %s", params);
    }

    GetPlayerPos(playerid, x, y, z);
    if(pData[playerid][pBActive])
    {
        if (IsValidDynamic3DTextLabel(pData[playerid][pBTag]))
            UpdateDynamic3DTextLabelText(pData[playerid][pBTag], COLOR_PURPLE, flyingtext);
        else
            pData[playerid][pBTag] = CreateDynamic3DTextLabel(flyingtext, COLOR_PURPLE, x, y, z, 15, _, _, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    }
    else
    {
        pData[playerid][pBActive] = true;
        pData[playerid][pBTag] = CreateDynamic3DTextLabel(flyingtext, COLOR_PURPLE, x, y, z, 15, _, _, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    }
	printf("[AB] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:ame(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    new flyingtext[164];

    if(isnull(params))
        return SyntaxMsg(playerid, "/ame [action]");

    if(strlen(params) > 128)
        return Error(playerid, "Max action can only maximmum 128 characters.");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    format(flyingtext, sizeof(flyingtext), "* %s %s*", ReturnName(playerid), params);
    SetPlayerChatBubble(playerid, flyingtext, COLOR_PURPLE, 10.0, 10000);
	printf("[AME] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:me(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    if(isnull(params))
        return SyntaxMsg(playerid, "/me [action]");
	
	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s %.64s ..", ReturnName(playerid), params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s", params[64]);
    }
    else 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s %s", ReturnName(playerid), params);
    }
	printf("[ME] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:do(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

    if(isnull(params))
        return SyntaxMsg(playerid, "/do [description]");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64) 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %.64s ..", params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s (( %s ))", params[64], ReturnName(playerid));
    }
    else 
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s (( %s ))", params, ReturnName(playerid));
    }
	printf("[DO] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:toglog(playerid)
{
	if(!pData[playerid][pTogLog])
	{
		pData[playerid][pTogLog] = 1;
		Info(playerid, "Anda telah menonaktifkan log server.");
	}
	else
	{
		pData[playerid][pTogLog] = 0;
		Info(playerid, "Anda telah mengaktifkan log server.");
	}
	return 1;
}

CMD:togpm(playerid)
{
	if(!pData[playerid][pTogPM])
	{
		pData[playerid][pTogPM] = 1;
		Info(playerid, "Anda telah menonaktifkan PM");
	}
	else
	{
		pData[playerid][pTogPM] = 0;
		Info(playerid, "Anda telah mengaktifkan PM");
	}
	return 1;
}

CMD:togads(playerid)
{
	if(!pData[playerid][pTogAds])
	{
		pData[playerid][pTogAds] = 1;
		Info(playerid, "Anda telah menonaktifkan Ads/Iklan.");
	}
	else
	{
		pData[playerid][pTogAds] = 0;
		Info(playerid, "Anda telah mengaktifkan Ads/Iklan.");
	}
	return 1;
}

CMD:togwt(playerid)
{
	if(!pData[playerid][pTogWT])
	{
		pData[playerid][pTogWT] = 1;
		Info(playerid, "Anda telah menonaktifkan Walkie Talkie.");
	}
	else
	{
		pData[playerid][pTogWT] = 0;
		Info(playerid, "Anda telah mengaktifkan Walkie Talkie.");
	}
	return 1;
}

CMD:pm(playerid, params[])
{
    static text[128], otherid;
    if(sscanf(params, "us[128]", otherid, text))
        return SyntaxMsg(playerid, "/pm [playerid/PartOfName] [message]");

    if(pData[playerid][pTogPM])
        return Error(playerid, "You must enable private messaging first.");

    if(pData[otherid][pAdminDuty])
        return Error(playerid, "You can't pm'ing admin duty now!");
		
	if(otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player yang anda tuju tidak valid.");

    if(otherid == playerid)
        return Error(playerid, "Tidak dapan PM diri sendiri.");

    if(pData[otherid][pTogPM] && pData[playerid][pAdmin] < 1)
        return Error(playerid, "Player tersebut menonaktifkan pm.");

    if(IsPlayerInRangeOfPoint(otherid, 50, 2184.32, -1023.32, 1018.68))
				return Error(playerid, "Anda tidak dapat melakukan ini, orang yang dituju sedang berada di OOC Zone");

    //GameTextForPlayer(otherid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~New message!", 3000, 3);
    PlayerPlaySound(otherid, 1085, 0.0, 0.0, 0.0);

    SendClientMessageEx(otherid, COLOR_YELLOW, "(( PM from %s (%d): %s ))", pData[playerid][pName], playerid, text);
    SendClientMessageEx(playerid, COLOR_YELLOW, "(( PM to %s (%d): %s ))", pData[otherid][pName], otherid, text);
	//Info(otherid, "/togpm for tog enable/disable PM");

    foreach(new i : Player) if((pData[i][pAdmin]) && pData[playerid][pSPY] > 0)
    {
        SendClientMessageEx(i, COLOR_LIGHTGREEN, "[SPY PM] %s (%d) to %s (%d): %s", pData[playerid][pName], playerid, pData[otherid][pName], otherid, text);
    }
    return 1;
}

CMD:b(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "OOC Zone, Ketik biasa saja");

    if(isnull(params))
        return SyntaxMsg(playerid, "/b [local OOC]");

    new jembut[40];
	if(pData[playerid][pLevel] > 0)
	{
		jembut = "Newbie";
	}
	if(pData[playerid][pLevel] > 5)
	{
		jembut = "Trainee";
	}
	if(pData[playerid][pLevel] > 10)
	{
		jembut = "Novice";
	}
	if(pData[playerid][pLevel] > 15)
	{
		jembut = "Elilte";
	}
	if(pData[playerid][pLevel] > 20)
	{
		jembut = "Honor";
	}
	if(pData[playerid][pLevel] > 25)
	{
		jembut = "Epical";
	}
	if(pData[playerid][pLevel] > 30)
	{
		jembut = "Vanguard";
	}
	if(pData[playerid][pLevel] > 35)
	{
		jembut = "Master";
	}
	if(pData[playerid][pLevel] > 40)
	{
		jembut = "Legendary";
	}
	if(pData[playerid][pLevel] > 45)
	{
		jembut = "Nolife";
	}
	if(pData[playerid][pLevel] > 50)
	{
		jembut = "Supreme";
	}
	if(pData[playerid][pAdminDuty] == 1)
    {
		if(strlen(params) > 64)
		{
			SendNearbyMessage(playerid, 20.0, COLOR_RED, "%s:"WHITE_E" (( %.64s ..", GetRPName(playerid), params);
            SendNearbyMessage(playerid, 20.0, COLOR_WHITE, ".. %s ))", params[64]);
		}
		else
        {
            SendNearbyMessage(playerid, 20.0, COLOR_RED, "%s:"WHITE_E" (( %s ))", GetRPName(playerid), params);
            return 1;
        }
	}
	else
	{
		if(strlen(params) > 64)
		{
			SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s: (( %.64s ..", GetRPName(playerid), params);
            SendNearbyMessage(playerid, 20.0, COLOR_WHITE, ".. %s ))", params[64]);
		}
		else
        {
            SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "[L] %s {ffffff}%s [%d]: (( %s ))", jembut, pData[playerid][pUCP], playerid, params);
            return 1;
        }
	}
	//printf("[OOC] %s(%d) : %s", pData[playerid][pName], playerid, params);
	new str[150];
	format(str,sizeof(str),"[OOC] %s: %s", GetRPName(playerid), params);
	LogServer("Chat", str);
	SendDiscordMessage(2, str);
    return 1;
}

CMD:t(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	if(isnull(params))
		return SyntaxMsg(playerid, "/t [typo text]");

	if(strlen(params) < 10)
	{
		SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s : %.10s*", ReturnName(playerid), params);
	}
	//printf("[OOC] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}
CMD:callAufa(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	new ph;
	if(pData[playerid][pPhone] == 0) return Error(playerid, "Anda tidak memiliki Ponsel!");

	if(sscanf(params, "d", ph))
	{
		SyntaxMsg(playerid, "/call [phone number] 933 - Taxi Call | 911 - SAPD Crime Call | 922 - SAMD Medic Call");
		foreach(new ii : Player)
		{	
			if(pData[ii][pMechDuty] == 1)
			{
				SendClientMessageEx(playerid, COLOR_GREEN, "Mekanik Duty: %s | PH: [%d]", ReturnName(ii), pData[ii][pPhone]);
			}
		}
		return 1;
	}
	if(ph == 911)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());
		
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		Info(playerid, "Warning: This number for emergency crime only! please wait for SAPD respon!");
		SendFactionMessage(1, COLOR_BLUE, "[EMERGENCY CALL] "WHITE_E"%s calling the emergency crime! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
	
		pData[playerid][pCallTime] = gettime() + 60;
	}
	if(ph == 922)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());
		
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		Info(playerid, "Warning: This number for emergency medical only! please wait for SAMD respon!");
		SendFactionMessage(3, COLOR_YELLOW2, "[EMERGENCY CALL] "WHITE_E"%s calling the emergency medical! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
	
		pData[playerid][pCallTime] = gettime() + 60;
	}
	if(ph == 933)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());
		
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		Info(playerid, "Your calling has sent to the taxi driver. please wait for respon!");
		pData[playerid][pCallTime] = gettime() + 60;
		foreach(new tx : Player)
		{
			if(pData[tx][pJob] == 1 || pData[tx][pJob2] == 1)
			{
				SendClientMessageEx(tx, COLOR_YELLOW, "[TAXI CALL] "WHITE_E"%s calling the taxi for order! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
			}
		}
	}
	if(ph == pData[playerid][pPhone]) return Error(playerid, "Nomor sedang sibuk!");
	foreach(new ii : Player)
	{
		if(pData[ii][pPhone] == ph)
		{
			if(pData[ii][IsLoggedIn] == false || !IsPlayerConnected(ii)) return Error(playerid, "This number is not actived!");
			if(IsPlayerInRangeOfPoint(ii, 20, 2179.9531,-1009.7586,1021.6880))
				return Error(playerid, "Anda tidak dapat melakukan ini, orang yang dituju sedang berada di OOC Zone");

			if(pData[ii][pCall] == INVALID_PLAYER_ID)
			{
				pData[playerid][pCall] = ii;
				
				SendClientMessageEx(playerid, COLOR_YELLOW, "[CELLPHONE to %d] "WHITE_E"phone begins to ring, please wait for answer!", ph);
				SendClientMessageEx(ii, COLOR_YELLOW, "[CELLPHONE form %d] "WHITE_E"Your phonecell is ringing, type '/p' to answer it!", pData[playerid][pPhone]);
				PlayerPlaySound(playerid, 3600, 0,0,0);
				PlayerPlaySound(ii, 6003, 0,0,0);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
				SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s takes out a cellphone and calling someone.", ReturnName(playerid));
				pData[playerid][pCallLine] = ii;
				pData[playerid][pCalling] = 1;
				pData[playerid][pCallStage] = 0;

				pData[ii][pCallLine] = playerid;
				pData[ii][pCallStage] = 1;
				return 1;
			}
			else
			{
				Error(playerid, "Nomor ini sedang sibuk.");
				return 1;
			}
		}
	}
	return 1;
}

/*CMD:p(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	if(pData[playerid][pCall] != INVALID_PLAYER_ID)
		return Error(playerid, "Anda sudah sedang menelpon seseorang!");
		
	if(pData[playerid][pInjured] != 0)
		return Error(playerid, "You cant do that in this time.");
		
	foreach(new ii : Player)
	{
		if(playerid == pData[ii][pCall])
		{
			pData[ii][pPhoneCredit]--;
			
			pData[playerid][pCall] = ii;
			SendClientMessageEx(ii, COLOR_YELLOW, "[CELLPHONE] "WHITE_E"phone is connected, type '/hu' to stop!");
			SendClientMessageEx(playerid, COLOR_YELLOW, "[CELLPHONE] "WHITE_E"phone is connected, type '/hu' to stop!");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s answers their cellphone.", ReturnName(playerid));
			pData[ii][pCallStage] = 2;
			pData[playerid][pCallStage] = 2;
			pData[playerid][pTombolVoice] = 0;
			pData[ii][pTombolVoice] = 0;
			//////////Samp Voice/////////////////////////////////////////////////////////////
			StreamTelpon[playerid] = SvCreateGStream(0xffff0000, "Telpon");//yg di telpon
			StreamTelpon[pData[ii][pCallLine]] = SvCreateGStream(0xffff0000, "Telpon");// mulai telpon
			SvAttachListenerToStream(StreamTelpon[pData[playerid][pCallLine]], playerid); // yg di telpon ngomong ke penelpon
			SvAttachListenerToStream(StreamTelpon[playerid], pData[ii][pCallLine]); //penelpon ngomong ke yg di telpon
			/////////////////////////////////////////////////////////////////////////////////
			return 1;
		}
	}
	return 1;
}*/

/*CMD:hu(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	new caller = pData[playerid][pCall];
	if(IsPlayerConnected(caller) && caller != INVALID_PLAYER_ID)
	{
		pData[caller][pCall] = INVALID_PLAYER_ID;
		SetPlayerSpecialAction(caller, SPECIAL_ACTION_STOPUSECELLPHONE);
		SendNearbyMessage(caller, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(caller));
		
		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(playerid));
		pData[playerid][pCall] = INVALID_PLAYER_ID;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
		
		if(pData[playerid][pCallStage] == 2)
		{
			if(StreamTelpon[caller])
			{
				SvDeleteStream(StreamTelpon[caller]);
			}
			if(StreamTelpon[playerid])
			{
				SvDeleteStream(StreamTelpon[playerid]);
			}
			pData[playerid][pCallStage] = 0;
			pData[playerid][pCallLine] = INVALID_PLAYER_ID;
			pData[caller][pCallStage] = 0;
			pData[caller][pCallLine] = INVALID_PLAYER_ID;
			pData[playerid][pTombolVoice] = 1;
			pData[caller][pTombolVoice] = 1;
		}///////////////////////////////////////////////////
	}
	return 1;
}*/

CMD:number(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	if(pData[playerid][pPhoneBook] == 0)
		return Error(playerid, "You dont have a phone book.");
	
	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/number [playerid]");
	
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "That player is not listed in phone book.");
		
	if(pData[otherid][pPhone] == 0)
		return Error(playerid, "That player is not listed in phone book.");
	
	SendClientMessageEx(playerid, COLOR_YELLOW, "[CELLPHONE] Name: %s | Ph: %d.", ReturnName(otherid), pData[otherid][pPhone]);
	return 1;
}


CMD:setfreq(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");

	if(pData[playerid][pWT] == 0)
		return Error(playerid, "You dont have walkie talkie!");
	
	new channel;
	if(sscanf(params, "d", channel))
		return SyntaxMsg(playerid, "/setfreq [channel 1 - 1000]");
	
	if(pData[playerid][pTogWT] == 1) return Error(playerid, "Your walkie talkie is turned off.");
	if(channel == pData[playerid][pWT]) return Error(playerid, "You are already in this channel.");
	
	if(channel > 0 && channel <= 1000)
	{
		foreach(new i : Player)
		{
		    if(pData[i][pWT] == channel)
		    {
				SendClientMessageEx(i, COLOR_LIME, "[WT] "WHITE_E"%s has joined in to this channel!", ReturnName(playerid));
		    }
		}
		Info(playerid, "You have set your walkie talkie channel to "LIME_E"%d", channel);
		pData[playerid][pWT] = channel;
	}
	else
	{
		Error(playerid, "Invalid channel id! 1 - 1000");
	}
	return 1;
}

CMD:savestats(playerid, params[])
{
	UpdateWeapons(playerid);
	UpdatePlayerData(playerid);
	SuccesMsg(playerid, "Data karakter kamu berhasil disimpan!");
	return 1;
}

CMD:ads(playerid, params[])
{
	
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 792.0918,-1315.1270,710.3754)) return Error(playerid, "Kamu harus di kantor berita");
	if(pData[playerid][pDelayIklan] > 0) return Error(playerid, "Kamu masih cooldown %d detik", pData[playerid][pDelayIklan]);
	if(pData[playerid][pPhone] == 0) return Error(playerid, "Anda tidak memiliki Ponsel!");
	
	if(isnull(params))
	{
		SyntaxMsg(playerid, "/ads [text] | 1 character pay $2");
		return 1;
	}
	if(strlen(params) >= 100 ) return Error(playerid, "Maximum character is 100 text." );
	new payout = strlen(params) * 2;
	if(GetPlayerMoney(playerid) < payout) return Error(playerid, "Not enough money.");
	
	GivePlayerMoneyEx(playerid, -payout);
	Server_AddMoney(payout);
	pData[playerid][pDelayIklan] = 600;
	foreach(new ii : Player)
	{
		if(pData[ii][pTogAds] == 0)
		{
			SendClientMessageEx(ii, COLOR_ORANGE2, "[IKLAN] "GREEN_E"%s.", params);
			SendClientMessageEx(ii, COLOR_ORANGE2, "Contact Info: ["GREEN_E"%s"ORANGE_E2"] Ph: ["GREEN_E"%d"ORANGE_E2"] Bank Rek: ["GREEN_E"%d"ORANGE_E2"]", pData[playerid][pName], pData[playerid][pPhone], pData[playerid][pBankRek]);
		}
	}
	//SendClientMessageToAllEx(COLOR_ORANGE2, "[ADS] "GREEN_E"%s.", params);
	//SendClientMessageToAllEx(COLOR_ORANGE2, "Contact Info: ["GREEN_E"%s"ORANGE_E2"] Ph: ["GREEN_E"%d"ORANGE_E2"] Bank Rek: ["GREEN_E"%d"ORANGE_E2"]", pData[playerid][pName], pData[playerid][pPhone], pData[playerid][pBankRek]);
	return 1;
}

//------------------[ Bisnis and Buy Commands ]-------
CMD:buy(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		return Error(playerid, "Anda tidak dapat melakukan ini jika sedang berada di OOC Zone");
	//trucker product
	if(IsPlayerInRangeOfPoint(playerid, 3.5, -279.67, -2148.42, 28.54))
	{
		if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4)
		{
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
				new mstr[128];
				format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah product:\nProduct Stock: "GREEN_E"%d\n"WHITE_E"Product Price"GREEN_E"%s / item", Product, FormatMoney(ProductPrice));
				ShowPlayerDialog(playerid, DIALOG_PRODUCT, DIALOG_STYLE_INPUT, "Buy Product", mstr, "Buy", "Cancel");
			}
			else return Error(playerid, "You are not in vehicle trucker.");
		}
		else return Error(playerid, "You are not trucker job.");
	}
	if(IsPlayerInRangeOfPoint(playerid, 3.5, 336.70, 895.54, 20.40))
	{
		if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4)
		{
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
				new mstr[128];
				format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah liter gasoil:\nGasOil Stock: "GREEN_E"%d\n"WHITE_E"GasOil Price"GREEN_E"%s / liters", GasOil, FormatMoney(GasOilPrice));
				ShowPlayerDialog(playerid, DIALOG_GASOIL, DIALOG_STYLE_INPUT, "Buy GasOil", mstr, "Buy", "Cancel");
			}
			else return Error(playerid, "You are not in vehicle trucker.");
		}
		else return Error(playerid, "You are not trucker job.");
	}
	//Material
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 854.5555, -605.2056, 18.4219))
	{
		if(pData[playerid][pMaterial] >= 500) return Error(playerid, "Anda sudah membawa 500 Material!");
		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah material:\nMaterial Stock: "GREEN_E"%d\n"WHITE_E"Material Price"GREEN_E"%s / item", Material, FormatMoney(MaterialPrice));
		ShowPlayerDialog(playerid, DIALOG_MATERIAL, DIALOG_STYLE_INPUT, "Buy Material", mstr, "Buy", "Cancel");
	}
	//Component
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 854.5555, -605.2056, 18.4219))
	{
		if(pData[playerid][pComponent] >= 1500) return Error(playerid, "Anda sudah membawa 1500 Component!");
		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah component:\nComponent Stock: "GREEN_E"%d\n"WHITE_E"Component Price"GREEN_E"%s / item", Component, FormatMoney(ComponentPrice));
		ShowPlayerDialog(playerid, DIALOG_COMPONENT, DIALOG_STYLE_INPUT, "Buy Component", mstr, "Buy", "Cancel");
	}
	//Ayamfill
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 921.7545,-1299.1313,14.0938))
	{
		if(pData[playerid][AyamFillet] >= 100) return Error(playerid, "Anda sudah membawa 100 kg AyamFillet!");

		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah ayam:\nAyam Stock: "GREEN_E"%d\n"WHITE_E"Ayam Price"GREEN_E"%s / item", AyamFill, FormatMoney(AyamFillPrice));
		ShowPlayerDialog(playerid, DIALOG_AYAMFILL, DIALOG_STYLE_INPUT, "Buy Ayam", mstr, "Buy", "Cancel");
	}
	//Apotek
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 1344.85, 1572.11, 3010.90))
	{
		if(pData[playerid][pFaction] != 3)
			return Error(playerid, "Medical only!");
			
		new mstr[128];
		format(mstr, sizeof(mstr), "Product\tPrice\n\
		Medicine\t"GREEN_E"%s\n\
		Medkit\t"GREEN_E"%s\n\
		Bandage\t"GREEN_E"$100\n\
		", FormatMoney(MedicinePrice), FormatMoney(MedkitPrice));
		ShowPlayerDialog(playerid, DIALOG_APOTEK, DIALOG_STYLE_TABLIST_HEADERS, "Apotek", mstr, "Buy", "Cancel");
	}
	//Food and Seed
	if(IsPlayerInRangeOfPoint(playerid, 2.5, -381.44, -1426.13, 25.93))
	{
		new mstr[128];
		format(mstr, sizeof(mstr), "Product\tPrice\n\
		Food\t"GREEN_E"%s\n\
		Seed\t"GREEN_E"%s\n\
		", FormatMoney(FoodPrice), FormatMoney(SeedPrice));
		ShowPlayerDialog(playerid, DIALOG_FOOD, DIALOG_STYLE_TABLIST_HEADERS, "Food", mstr, "Buy", "Cancel");
	}
	//Drugs
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 874.52, -15.98, 63.19))
	{
		if(pData[playerid][pMarijuana] >= 100) return Error(playerid, "Anda sudah membawa 100 kg Marijuana!");
		
		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah marijuana:\nMarijuana Stock: "GREEN_E"%d\n"WHITE_E"Marijuana Price"GREEN_E"%s / item", Marijuana, FormatMoney(MarijuanaPrice));
		ShowPlayerDialog(playerid, DIALOG_DRUGS, DIALOG_STYLE_INPUT, "Buy Drugs", mstr, "Buy", "Cancel");
	}
	// Obat Myr
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 1339.00, 1579.14, 3010.90))
	{
		if(pData[playerid][pObat] >= 5) return Error(playerid, "Anda sudah membawa 5 Obat Myr!");
		
		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah Obat:\nObat Stock: "GREEN_E"%d\n"WHITE_E"Obat Price"GREEN_E"%s / item", ObatMyr, FormatMoney(ObatPrice));
		ShowPlayerDialog(playerid, DIALOG_OBAT, DIALOG_STYLE_INPUT, "Buy Obat", mstr, "Buy", "Cancel");
	}
	//Buy House
	foreach(new hid : Houses)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
		{
			if(hData[hid][hPrice] > GetPlayerMoney(playerid)) return Error(playerid, "Not enough money, you can't afford this houses.");
			if(strcmp(hData[hid][hOwner], "-")) return Error(playerid, "Someone already owns this house.");
			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 2) return Error(playerid, "Kamu tidak dapat membeli rumah lebih.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 3) return Error(playerid, "Kamu tidak dapat membeli rumah lebih.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 4) return Error(playerid, "Kamu tidak dapat membeli rumah lebih.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 1) return Error(playerid, "Kamu tidak dapat membeli rumah lebih.");
				#endif
			}
			GivePlayerMoneyEx(playerid, -hData[hid][hPrice]);
			Server_AddMoney(hData[hid][hPrice]);
			GetPlayerName(playerid, hData[hid][hOwner], MAX_PLAYER_NAME);
			hData[hid][hOwnerID] = pData[playerid][pID];
			hData[hid][hVisit] = gettime();
			new str[150];
			format(str,sizeof(str),"[HOUSE]: %s membeli rumah id %d seharga %s!", GetRPName(playerid), hid, FormatMoney(hData[hid][hPrice]));
			LogServer("Property", str);

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET owner='%s', ownerid='%d', visit='%d' WHERE ID='%d'", hData[hid][hOwner], hData[hid][hOwnerID], hData[hid][hVisit], hid);
			mysql_tquery(g_SQL, query);
			
			House_Refresh(hid);
		}
	}
	
	//Buy Vending Machine
	foreach(new vid : Vendings)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, VendingData[vid][vendingX], VendingData[vid][vendingY], VendingData[vid][vendingZ]))
		{
			if(VendingData[vid][vendingPrice] > GetPlayerMoney(playerid)) 
				return Error(playerid, "Not enough money, you can't afford this Vending.");

			if(strcmp(VendingData[vid][vendingOwner], "-") || VendingData[vid][vendingOwnerID] != 0) 
				return Error(playerid, "Someone already owns this Vending.");

			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more Vending.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more Vending.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more Vending.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more Vending.");
				#endif
			}

			SendClientMessageEx(playerid, COLOR_WHITE, "You has teleport to vending id %d", vid);
			GivePlayerMoneyEx(playerid, -VendingData[vid][vendingPrice]);
			Server_AddMoney(VendingData[vid][vendingPrice]);
			GetPlayerName(playerid, VendingData[vid][vendingOwner], MAX_PLAYER_NAME);
			VendingData[vid][vendingOwnerID] = pData[playerid][pID];
			new str[150];
			format(str,sizeof(str),"[VEND]: %s membeli vending id %d seharga %s!", GetRPName(playerid), vid, FormatMoney(VendingData[vid][vendingPrice]));
			LogServer("Property", str);
			
			Vending_RefreshText(vid);
			Vending_Save(vid);
		}
		for(new aaa = 1; aaa < sizeof(ModsPoint); aaa++)
		if(IsPlayerInRangeOfPoint(playerid, 5.0, ModsPoint[aaa][ModsPos][0], ModsPoint[aaa][ModsPos][1], ModsPoint[aaa][ModsPos][2]))
		{
			ShowPlayerDialog(playerid, DIALOG_MMENU, DIALOG_STYLE_LIST, "Vehicle Modshop", "Purchase Vehicle Toys\nPurchase Vehicle Parachute", "Select", "Back");
		}
		//Buy Workshop
		foreach(new wid : Workshop)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ]))
			{
				if(wsData[wid][wPrice] > GetPlayerMoney(playerid))
					return Error(playerid, "Not enough money, you can't afford this workshop.");
				if(wsData[wid][wOwnerID] != 0 || strcmp(wsData[wid][wOwner], "-")) 
					return Error(playerid, "Someone already owns this workshop.");

				#if LIMIT_PER_PLAYER > 0
				if(Player_WorkshopCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more workshop.");
				#endif

				GivePlayerMoneyEx(playerid, -wsData[wid][wPrice]);
				Server_AddMoney(wsData[wid][wPrice]);
				GetPlayerName(playerid, wsData[wid][wOwner], MAX_PLAYER_NAME);
				wsData[wid][wOwnerID] = pData[playerid][pID];
				new str[150];
				format(str,sizeof(str),"[WS]: %s membeli workshop id %d seharga %s!", GetRPName(playerid), wid, FormatMoney(wsData[wid][wPrice]));
				LogServer("Property", str);

				Workshop_Refresh(wid);
				Workshop_Save(wid);
			}
		}
	}
	return 1;
}

forward Revive(playerid);
public Revive(playerid)
{
	new otherid = GetPVarInt(playerid, "gcPlayer");
	TogglePlayerControllable(playerid,1);
	Servers(playerid, "Sukses revive");
	pData[playerid][pObat] -= 1;
    pData[otherid][pInjured] = 0;
    pData[otherid][pHospital] = 0;
    pData[otherid][pSick] = 0;
}

forward DownloadTwitter(playerid);
public DownloadTwitter(playerid)
{
	pData[playerid][pTwitter] = 1;
	pData[playerid][pKuota] -= 38000;
	Servers(playerid, "Twitter berhasil di Download");
}

CMD:selfie(playerid,params[])
{
	if(takingselfie[playerid] == 0)
	{
	    GetPlayerPos(playerid,lX[playerid],lY[playerid],lZ[playerid]);
		static Float: n1X, Float: n1Y;
		if(Degree[playerid] >= 360) Degree[playerid] = 0;
		Degree[playerid] += Speed;
		n1X = lX[playerid] + Radius * floatcos(Degree[playerid], degrees);
		n1Y = lY[playerid] + Radius * floatsin(Degree[playerid], degrees);
		SetPlayerCameraPos(playerid, n1X, n1Y, lZ[playerid] + Height);
		SetPlayerCameraLookAt(playerid, lX[playerid], lY[playerid], lZ[playerid]+1);
		SetPlayerFacingAngle(playerid, Degree[playerid] - 90.0);
		takingselfie[playerid] = 1;
		ApplyAnimation(playerid, "PED", "gang_gunstand", 4.1, 1, 1, 1, 1, 1, 1);
		return 1;
	}
    if(takingselfie[playerid] == 1)
	{
	    TogglePlayerControllable(playerid,1);
		SetCameraBehindPlayer(playerid);
	    takingselfie[playerid] = 0;
	    ApplyAnimation(playerid, "PED", "ATM", 4.1, 0, 1, 1, 0, 1, 1);
	    return 1;
	}
    return 1;
}
CMD:buyws(playerid, params[])
{
		foreach(new wid : Workshop)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ]))
			{
				if(wsData[wid][wPrice] > GetPlayerMoney(playerid))
					return Error(playerid, "Not enough money, you can't afford this workshop.");
				if(wsData[wid][wOwnerID] != 0 || strcmp(wsData[wid][wOwner], "-"))
					return Error(playerid, "Someone already owns this workshop.");

				#if LIMIT_PER_PLAYER > 0
				if(Player_WorkshopCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more workshop.");
				#endif

				GivePlayerMoneyEx(playerid, -wsData[wid][wPrice]);
				Server_AddMoney(wsData[wid][wPrice]);
				GetPlayerName(playerid, wsData[wid][wOwner], MAX_PLAYER_NAME);
				wsData[wid][wOwnerID] = pData[playerid][pID];
				new str[150];
				format(str,sizeof(str),"[WS]: %s membeli workshop id %d seharga %s!", GetRPName(playerid), wid, FormatMoney(wsData[wid][wPrice]));
				LogServer("Property", str);

				Workshop_Refresh(wid);
				Workshop_Save(wid);
			}
		}
		return 1;
}

DelaysPlayer(playerid, p2)
{
	new str[(1024 * 2)], headers[500];
	strcat(headers, "Name\tTime\n");

	if(pData[playerid][pExitJob] > 0)
    {
        format(str, sizeof(str), "%s{ff0000}Exit Jobs{ffffff}\t%i Second\n", str, ReturnTimelapse(gettime(), pData[playerid][pExitJob]));
	}
	if(pData[playerid][pJobTime] > 0)
    {
        format(str, sizeof(str), "%sJobs\t%i Second\n", str, pData[playerid][pJobTime]);
	}
	if(pData[playerid][pBusTime] > 0)
    {
        format(str, sizeof(str), "%sBus (Sidejob)\t%i Second\n", str, pData[playerid][pBusTime]);
	}
	if(pData[playerid][pSparepartTime] > 0)
    {
        format(str, sizeof(str), "%sJob Sparepart (Jobs)\t%i Second\n", str, pData[playerid][pSparepartTime]);
	}
	
	strcat(headers, str);

	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Delays", headers, "Okay", "");
	return 1;
}

CMD:washmoney(playerid, params[])
{
	new merah = pData[playerid][pRedMoney];
	new rumus = (merah/200)*10; // 5 discount percent
 	new total = merah-rumus;
	if(pData[playerid][pRedMoney] < 0)
	{
		return Error(playerid, "Kamu tidak memiliki uang merah.");
	}
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, -427.3773, -392.3799, 16.5802))
	{
		return Error(playerid, "Kamu harus berada di penukaran uang.");
	}
	Info(playerid, "Kamu mencuci uang dan menghasilkan %s.", FormatMoney(total));
	pData[playerid][pRedMoney] -= total;
	GivePlayerMoneyEx(playerid, total);
	return 1;
}

CMD:clearchat(playerid, params[])
{
	ClearChat(playerid);
	return 1;
}

CMD:taclight(playerid, params[])
{
	if(!pData[playerid][pFlashlight]) 
		return Error(playerid, "Kamu tidak mempunyai senter.");
	if(pData[playerid][pUsedFlashlight] == 0)
	{
		if(IsPlayerAttachedObjectSlotUsed(playerid,8)) RemovePlayerAttachedObject(playerid,8);
		if(IsPlayerAttachedObjectSlotUsed(playerid,9)) RemovePlayerAttachedObject(playerid,9);
		SetPlayerAttachedObject(playerid, 8, 18656, 6, 0.25, -0.0175, 0.16, 86.5, -185, 86.5, 0.03, 0.1, 0.03);
		SetPlayerAttachedObject(playerid, 9, 18641, 6, 0.2, 0.01, 0.16, 90, -95, 90, 1, 1, 1);
		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s attach the flashlight to the gun.", ReturnName(playerid));

		pData[playerid][pUsedFlashlight] = 1;
	}
	else
	{
		RemovePlayerAttachedObject(playerid,8);
		RemovePlayerAttachedObject(playerid,9);
		pData[playerid][pUsedFlashlight] =0;
		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s take the flashlight off the gun.", ReturnName(playerid));
	}
	return 1;
}
CMD:flashlight(playerid, params[])
{
	if(!pData[playerid][pFlashlight])
		return Error(playerid, "Kamu tidak mempunyai senter.");

	if(pData[playerid][pUsedFlashlight] == 0)
	{
		if(IsPlayerAttachedObjectSlotUsed(playerid,8)) RemovePlayerAttachedObject(playerid,8);
		if(IsPlayerAttachedObjectSlotUsed(playerid,9)) RemovePlayerAttachedObject(playerid,9);
		SetPlayerAttachedObject(playerid, 8, 18656, 5, 0.1, 0.038, -0.01, -90, 180, 0, 0.03, 0.1, 0.03);
		SetPlayerAttachedObject(playerid, 9, 18641, 5, 0.1, 0.02, -0.05, 0, 0, 0, 1, 1, 1);
		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s take out the flashlight and turn on the flashlight.", ReturnName(playerid));

		pData[playerid][pUsedFlashlight] =1;
	}
	else
	{
 		RemovePlayerAttachedObject(playerid,8);
		RemovePlayerAttachedObject(playerid,9);
		pData[playerid][pUsedFlashlight] =0;
		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s turn off the flashlight and put it in.", ReturnName(playerid));
	}
	return 1;
}

CMD:newweaponlic(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2578.5625, -1383.2179, 1500.7570)) return Error(playerid, "Anda harus berada di Kantor SAPD!");
	if(pData[playerid][pDriveLic] != 0) return Error(playerid, "Anda sudah memiliki Weapon License!");
	if(GetPlayerMoney(playerid) < 4000) return Error(playerid, "Anda butuh $4,000 untuk membuat Weapon License.");
	pData[playerid][pWeaponLic] = 1;
	pData[playerid][pWeaponLicTime] = gettime() + (30 * 86400);
	GivePlayerMoneyEx(playerid, -4000);
	Server_AddMoney(4000);
	return 1;
}

/*CMD:blindfold(playerid,params[])
{
    new targetid;
	if(sscanf(params, "u", targetid))
	{
	    return SyntaxMsg(playerid, "/blindfold [playerid]");
	}
	if(pData[playerid][pBlindfold] <= 0)
	{
	    return Error(playerid, "Kamu tidak memiliki blindfold");
	}
	if(!IsPlayerInVehicle(targetid, GetPlayerVehicleID(playerid)))
	{
	    return Error(playerid, "Orang yang ditentukan terputus.");
	}
	if(GetPlayerState(targetid) == PLAYER_STATE_DRIVER)
	{
	    return Error(playerid, "Kamu tidak bisa menutup mata pengemudi.");
	}
	if(targetid == playerid)
	{
	    return Error(playerid, "Kamu tidak bisa menutup matamu sendiri.");
	}
	if(pBlind[targetid])
	{
	    return Error(playerid, "Orang itu sudah ditutup matanya. '/unblindfold' untuk melepas.");
	}
	if(pData[targetid][pAdminDuty])
	{
	    return Error(playerid, "Kamu tidak dapat menutup mata Administrator");
	}

	pData[playerid][pBlindfold]--;

	GameTextForPlayer(targetid, "~r~Penutup Mata", 3000, 3);
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA} %s menutup mata %s dengan bandana.", GetRPName(playerid), GetRPName(targetid));

	TogglePlayerControllable(targetid, 0);
	TextDrawShowForPlayer(targetid, Blind);
	pBlind[targetid] = 1;
    return 1;
}

CMD:unblindfold(playerid, params[])
{
	new targetid;

	if(sscanf(params, "u", targetid))
	{
	    return SCM(playerid, COLOR_SYNTAX, "Gunakan: /unblindfold [playerid]");
	}
	if(!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(playerid, targetid, 5.0))
	{
	    return Error(playerid, "Orang yang ditentukan terputus atau jauh darimu.");
	}
	if(targetid == playerid)
	{
	    return Error(playerid, "Kamu tidak dapat membuka penutup mata dirimu sendiri.");
	}
	if(!pBlind[targetid])
	{
	    return Error(playerid, "Orang itu bukan penutup mata.");
	}
	if(IsPlayerInAnyVehicle(targetid) && !IsPlayerInVehicle(playerid, GetPlayerVehicleID(targetid)))
	{
	    return Error(playerid, "Kamu harus berada di dalam kendaraan pemain itu untuk membuka penutup matanya.");
	}

	GameTextForPlayer(targetid, "~g~Buka penutup mata", 3000, 3);
	SendProximityMessage(playerid, 20.0, SERVER_COLOR, "**{C2A2DA} %s membuka penutup mata bandana dari %s.", GetRPName(playerid), GetRPName(targetid));

    TextDrawHideForPlayer(targetid, Blind);
	pBlind[targetid] = 0;
	return 1;
}*/


CMD:teriak(playerid, params[])
{
	if(pData[playerid][pInjured] != 1) return 1;
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		InfoMsg(playerid, "Info: Sinyal kamu Sudah berasil di sampaikan Silakan Tunggu Ems Datang!");
		SendFactionMessage(3, COLOR_PINK2, "[EMERGENCY DOWN] "WHITE_E"%s [ID: %d] NOMER INI MENGIRIM SINYAL! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), playerid, pData[playerid][pPhone], GetLocation(x, y, z));
	}
	return 1;
}
