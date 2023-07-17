function ambilwool(playerid)
{
	ShowItemBox(playerid, "Wool", "ADD_1x", 2751, 4);
	pData[playerid][pWool] ++;
	return 1;
}

function buatkain(playerid)
{
	ShowItemBox(playerid, "Kain", "ADD_1x", 11747, 4);
	ShowItemBox(playerid, "Wool", "REMOVED_1x", 2751, 4);
	pData[playerid][pKain] ++;
	pData[playerid][pWool] --;
	return 1;
}

function buatbaju(playerid)
{
	ShowItemBox(playerid, "Pakaian", "ADD_1x", 2399, 4);
	ShowItemBox(playerid, "Kain", "REMOVED_1x", 11747, 4);
	pData[playerid][pPakaian] ++;
	pData[playerid][pKain] --;
	return 1;
}

CMD:ambilwool(playerid, params[])
{
	if(pData[playerid][pDutyJob] != 4) return ErrorMsg(playerid, "Anda belum ambil baju kerja");
	if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
	if(pData[playerid][pWool] > 20) return ErrorMsg(playerid, "Anda Tidak Bisa Membawa Lebih Dari 20");
	ShowProgressbar(playerid, "Mengambil Wool..", 5);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	SetTimerEx("ambilwool", 5000, false, "d", playerid);
	return 1;
}

CMD:buatkain(playerid, params[])
{
	if(pData[playerid][pDutyJob] != 4) return ErrorMsg(playerid, "Anda belum ambil baju kerja");
	if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
	if(pData[playerid][pWool] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Wool");
	ShowProgressbar(playerid, "Membuat Kain..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	SetTimerEx("buatkain", 10000, false, "d", playerid);
	return 1;
}

CMD:buatbaju(playerid, params[])
{
	if(pData[playerid][pDutyJob] != 4) return ErrorMsg(playerid, "Anda belum ambil baju kerja");
	if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
	if(pData[playerid][pPakaian] > 10) return ErrorMsg(playerid, "Anda tidak bisa membawa lebih dari 10 baju");
	if(pData[playerid][pKain] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Kain");
	ShowProgressbar(playerid, "Membuat Pakaian..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	SetTimerEx("buatbaju", 10000, false, "d", playerid);
	return 1;
}

CMD:jualpakaian(playerid, params[])
{
    new total = pData[playerid][pPakaian];
    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
    if(pData[playerid][pPakaian] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Pakaian Yang Akan Dijual");
    ShowProgressbar(playerid, "Menjual Pakaian..", total);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pPakaian] * 65;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pPakaian] -= total;
	new str[500];
	format(str, sizeof(str), "ADD_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, total);
	format(str, sizeof(str), "REMOVED_%dx", total);
	ShowItemBox(playerid, "Pakaian", str, 2399, total);
    Inventory_Update(playerid);
	return 1;
}
