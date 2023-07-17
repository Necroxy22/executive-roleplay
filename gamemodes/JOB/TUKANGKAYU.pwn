enum E_NEBANG
{
	STREAMER_TAG_MAP_ICON:LockerMap,
	STREAMER_TAG_CP:LockerNebang,
    STREAMER_TAG_MAP_ICON:NebangMap,
	STREAMER_TAG_CP:Nebang,
	STREAMER_TAG_CP:Nebang1,
	STREAMER_TAG_CP:Nebang2,
	STREAMER_TAG_CP:Nebang3,
	STREAMER_TAG_CP:Nebang4,
	STREAMER_TAG_MAP_ICON:ProsesMap,
	STREAMER_TAG_CP:ProsesKayu,
	STREAMER_TAG_CP:ProsesKayu1,
}

new PenebangArea[MAX_PLAYERS][E_NEBANG];

DeletePenebangCP(playerid)
{
    if(IsValidDynamicCP(PenebangArea[playerid][Nebang]))
	{
		DestroyDynamicCP(PenebangArea[playerid][Nebang]);
		PenebangArea[playerid][Nebang] = STREAMER_TAG_CP: -1;
	}
    if(IsValidDynamicCP(PenebangArea[playerid][Nebang1]))
	{
		DestroyDynamicCP(PenebangArea[playerid][Nebang1]);
		PenebangArea[playerid][Nebang1] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenebangArea[playerid][Nebang2]))
	{
		DestroyDynamicCP(PenebangArea[playerid][Nebang2]);
		PenebangArea[playerid][Nebang2] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenebangArea[playerid][Nebang3]))
	{
		DestroyDynamicCP(PenebangArea[playerid][Nebang3]);
		PenebangArea[playerid][Nebang3] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenebangArea[playerid][Nebang4]))
	{
		DestroyDynamicCP(PenebangArea[playerid][Nebang4]);
		PenebangArea[playerid][Nebang4] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenebangArea[playerid][ProsesKayu]))
	{
		DestroyDynamicCP(PenebangArea[playerid][ProsesKayu]);
		PenebangArea[playerid][ProsesKayu] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenebangArea[playerid][ProsesKayu1]))
	{
		DestroyDynamicCP(PenebangArea[playerid][ProsesKayu1]);
		PenebangArea[playerid][ProsesKayu1] = STREAMER_TAG_CP: -1;
	}
}


RefreshJobTebang(playerid)
{
	DeletePenebangCP(playerid);

	if(pData[playerid][pJob] == 3)
	{
			PenebangArea[playerid][Nebang] = CreateDynamicCP(-1997.1274,-2420.9097,30.6250, 1.0, -1, -1, playerid, 5.0);
			PenebangArea[playerid][Nebang1] = CreateDynamicCP(-2001.2432,-2416.8083,30.6250, 1.0, -1, -1, playerid, 5.0);
			PenebangArea[playerid][Nebang2] = CreateDynamicCP(-2011.3643,-2404.0962,30.6250, 1.0, -1, -1, playerid, 5.0);
			PenebangArea[playerid][Nebang3] = CreateDynamicCP(-2021.2697,-2402.0901,30.6250, 1.0, -1, -1, playerid, 5.0);
			PenebangArea[playerid][Nebang4] = CreateDynamicCP(-2030.3298,-2391.3167,30.6250, 1.0, -1, -1, playerid, 5.0);
			PenebangArea[playerid][ProsesKayu] = CreateDynamicCP(-1986.3417,-2425.8486,30.6250, 2.0, -1, -1, playerid, 30.0);
            //PenebangArea[playerid][Proses1] = CreateDynamicCP(2152.539062,-2263.646972,13.300081, 2.0, -1, -1, playerid, 30.0);


			PenebangArea[playerid][LockerMap] = CreateDynamicMapIcon(-1992.7512,-2387.5115,30.6250, 11, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
			PenebangArea[playerid][NebangMap] = CreateDynamicMapIcon(-795.673522,-1928.231567,5.612922, 11, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
			PenebangArea[playerid][ProsesMap] = CreateDynamicMapIcon(-1986.3417,-2425.8486,30.6250, 11, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
		}
		return 1;
	}

function potongkayu(playerid)
{
	ShowItemBox(playerid, "kayu", "ADD_1x", 1463, 4);
	pData[playerid][pKayu] ++;
	return 1;
}

function proseskayu(playerid)
{
	ShowItemBox(playerid, "papan", "ADD_1x", 19366, 4);
	ShowItemBox(playerid, "kayu", "REMOVED_1x", 1463, 4);
	pData[playerid][pPapan] ++;
	pData[playerid][pKayu] --;
	return 1;
}

function jualkayu(playerid)
{
	ShowItemBox(playerid, "uang", "ADD_1x", 1212, 4);
	ShowItemBox(playerid, "papan", "REMOVED_1x", 19366, 4);
	pData[playerid][pMoney] ++;
	pData[playerid][pPapan] --;
	return 1;
}

CMD:potongkayu1(playerid, params[])
{
	if(pData[playerid][pJob] != 3) return 1;
	if(pData[playerid][pDutyJob] != 3) return ErrorMsg(playerid, "Anda belum memakai Baju kerja");
	if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
	if(pData[playerid][pKayu] == 5) return ErrorMsg(playerid, "Anda sudah membawa 5 kayu");
	ShowProgressbar(playerid, "memotong kayu..", 5);
	ApplyAnimation(playerid,"CHAINSAW","CSAW_G",4.0, 1, 0, 0, 0, 0,1);
	SetTimerEx("potongkayu", 5000, false, "d", playerid);
	return 1;
}

CMD:potongkayu2(playerid, params[])
{
	if(pData[playerid][pJob] != 3) return 1;
	if(pData[playerid][pDutyJob] != 3) return ErrorMsg(playerid, "Anda belum memakai Baju kerja");
	if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
	if(pData[playerid][pKayu] == 5) return ErrorMsg(playerid, "Anda sudah membawa 5 kayu");
	ShowProgressbar(playerid, "memotong kayu..", 5);
	ApplyAnimation(playerid,"CHAINSAW","CSAW_G",4.0, 1, 0, 0, 0, 0,1);
	SetTimerEx("potongkayu", 5000, false, "d", playerid);
	return 1;
}

CMD:potongkayu3(playerid, params[])
{
	if(pData[playerid][pJob] != 3) return 1;
	if(pData[playerid][pDutyJob] != 3) return ErrorMsg(playerid, "Anda belum memakai Baju kerja");
	if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
	if(pData[playerid][pKayu] == 5) return ErrorMsg(playerid, "Anda sudah membawa 5 kayu");
	ShowProgressbar(playerid, "memotong kayu..", 5);
	ApplyAnimation(playerid,"CHAINSAW","CSAW_G",4.0, 1, 0, 0, 0, 0,1);
	SetTimerEx("potongkayu", 5000, false, "d", playerid);
	return 1;
}

CMD:potongkayu4(playerid, params[])
{
	if(pData[playerid][pJob] != 3) return 1;
	if(pData[playerid][pDutyJob] != 3) return ErrorMsg(playerid, "Anda belum memakai Baju kerja");
	if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
	if(pData[playerid][pKayu] == 5) return ErrorMsg(playerid, "Anda sudah membawa 5 kayu");
	ShowProgressbar(playerid, "memotong kayu..", 5);
	ApplyAnimation(playerid,"CHAINSAW","CSAW_G",4.0, 1, 0, 0, 0, 0,1);
	SetTimerEx("potongkayu", 5000, false, "d", playerid);
	return 1;
}

CMD:potongkayu5(playerid, params[])
{
	if(pData[playerid][pJob] != 3) return 1;
	if(pData[playerid][pDutyJob] != 3) return ErrorMsg(playerid, "Anda belum memakai Baju kerja");
	if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
	if(pData[playerid][pKayu] == 5) return ErrorMsg(playerid, "Anda sudah membawa 5 kayu");
	ShowProgressbar(playerid, "memotong kayu..", 5);
	ApplyAnimation(playerid,"CHAINSAW","CSAW_G",4.0, 1, 0, 0, 0, 0,1);
	SetTimerEx("potongkayu", 5000, false, "d", playerid);
	return 1;
}

CMD:proseskayu1(playerid, params[])
{
	if(pData[playerid][pDutyJob] != 3) return 1;
	if(pData[playerid][pDutyJob] != 3) return ErrorMsg(playerid, "Anda belum memakai Baju kerja");
	if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
	if(pData[playerid][pKayu] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Kayu");
	ShowProgressbar(playerid, "Memproses kayu..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	SetTimerEx("proseskayu", 10000, false, "d", playerid);
	return 1;
}

CMD:proseskayu2(playerid, params[])
{
	if(pData[playerid][pDutyJob] != 3) return 1;
	if(pData[playerid][pDutyJob] != 3) return ErrorMsg(playerid, "Anda belum memakai Baju kerja");
	if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
	if(pData[playerid][pKayu] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Kayu");
	ShowProgressbar(playerid, "Memproses kayu..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	SetTimerEx("proseskayu", 10000, false, "d", playerid);
	return 1;
}

CMD:jualpapan(playerid, params[])
{
    new total = pData[playerid][pPapan];
    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
    if(pData[playerid][pPapan] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Papan");
    ShowProgressbar(playerid, "Menjual Papan..", total);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pPapan] * 60;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pPapan] -= total;
	new str[500];
	format(str, sizeof(str), "ADD_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, total);
	format(str, sizeof(str), "REMOVED_%dx", total);
	ShowItemBox(playerid, "Papan", str, 19366, total);
    Inventory_Update(playerid);
	return 1;
}

