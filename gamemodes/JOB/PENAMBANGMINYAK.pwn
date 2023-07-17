enum E_MINYAK
{
    STREAMER_TAG_MAP_ICON:LockerMap,
    STREAMER_TAG_MAP_ICON:NambangMap,
    STREAMER_TAG_MAP_ICON:NambangMapp,
    STREAMER_TAG_MAP_ICON:OlahMap,
	STREAMER_TAG_CP:LockerTambang,
	STREAMER_TAG_CP:Nambang,
	STREAMER_TAG_CP:Nambangg,
	STREAMER_TAG_CP:OlahMinyak
}
new MinyakArea[MAX_PLAYERS][E_MINYAK];

DeleteMinyakCP(playerid)
{
	if(IsValidDynamicCP(MinyakArea[playerid][LockerTambang]))
	{
		DestroyDynamicCP(MinyakArea[playerid][LockerTambang]);
		MinyakArea[playerid][LockerTambang] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(MinyakArea[playerid][Nambang]))
	{
		DestroyDynamicCP(MinyakArea[playerid][Nambang]);
		MinyakArea[playerid][Nambang] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(MinyakArea[playerid][Nambangg]))
	{
		DestroyDynamicCP(MinyakArea[playerid][Nambangg]);
		MinyakArea[playerid][Nambangg] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(MinyakArea[playerid][OlahMinyak]))
	{
		DestroyDynamicCP(MinyakArea[playerid][OlahMinyak]);
		MinyakArea[playerid][OlahMinyak] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicMapIcon(MinyakArea[playerid][LockerMap]))
	{
		DestroyDynamicMapIcon(MinyakArea[playerid][LockerMap]);
		MinyakArea[playerid][LockerMap] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicMapIcon(MinyakArea[playerid][NambangMap]))
	{
		DestroyDynamicMapIcon(MinyakArea[playerid][NambangMap]);
		MinyakArea[playerid][NambangMap] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicMapIcon(MinyakArea[playerid][NambangMapp]))
	{
		DestroyDynamicMapIcon(MinyakArea[playerid][NambangMapp]);
		MinyakArea[playerid][NambangMapp] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicMapIcon(MinyakArea[playerid][OlahMap]))
	{
		DestroyDynamicMapIcon(MinyakArea[playerid][OlahMap]);
		MinyakArea[playerid][OlahMap] = STREAMER_TAG_MAP_ICON: -1;
	}
}

RefreshJobTambangMinyak(playerid)
{
	DeleteMinyakCP(playerid);

	if(pData[playerid][pJob] == 4)
	{
			MinyakArea[playerid][Nambang] = CreateDynamicCP(435.119323,1264.405517,9.370626, 2.0, -1, -1, playerid, 30.0);
			MinyakArea[playerid][Nambangg] = CreateDynamicCP(490.874359,1294.272338,9.020936, 2.0, -1, -1, playerid, 30.0);
			MinyakArea[playerid][OlahMinyak] = CreateDynamicCP(570.088989,1219.789794,11.711267, 2.0, -1, -1, playerid, 30.0);
			MinyakArea[playerid][NambangMap] = CreateDynamicMapIcon(435.119323,1264.405517,9.370626, 9, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
			MinyakArea[playerid][OlahMap] = CreateDynamicMapIcon(570.088989,1219.789794,11.711267, 9, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
			MinyakArea[playerid][NambangMapp] = CreateDynamicMapIcon(490.874359,1294.272338,9.020936, 9, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
	}
	return 1;
}

function Minyak1(playerid)
{
	ShowItemBox(playerid, "Minyak", "Received_5x", 2969, 4);
	pData[playerid][pMinyak] += 2;
	return 1;
}

CMD:kerjaminyak1(playerid, params[])
{
	if(pData[playerid][pJob] != 4) return 1;
	if(pData[playerid][pDutyJob] != 1) return ErrorMsg(playerid, "Anda belum memakai Baju kerja");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
	if(pData[playerid][pMinyak] > 100) return ErrorMsg(playerid, "Anda Tidak Bisa Membawa Lebih Dari 100");
	ShowProgressbar(playerid, "Mengambil Minyak..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	SetTimerEx("Minyak1", 10000, false, "d", playerid);
	return 1;
}

CMD:kerjaminyak2(playerid, params[])
{
    if(pData[playerid][pJob] != 4) return 1;
	if(pData[playerid][pDutyJob] != 1) return ErrorMsg(playerid, "Anda belum memakai Baju kerja");
    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if(pData[playerid][pMinyak] > 100) return ErrorMsg(playerid, "Anda Tidak Bisa Membawa Lebih Dari 100");
	ShowProgressbar(playerid, "Mengambil Minyak..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	SetTimerEx("Minyak1", 10000, false, "d", playerid);
	return 1;
}

CMD:saringminyak(playerid, params[])
{
    if(pData[playerid][pJob] != 4) return 1;
	if(pData[playerid][pDutyJob] != 1) return ErrorMsg(playerid, "Anda belum memakai Baju kerja");
    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	if(pData[playerid][pMinyak] < 5) return ErrorMsg(playerid, "Minyak anda kurang dari 5");
    new pay = pData[playerid][pMinyak] * 1;
    pData[playerid][pMinyak] -= 5;
	pData[playerid][pEssence] += 5;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Essence", str, 3015, 3);
	format(str, sizeof(str), "Removed_%dx", 5);
	ShowItemBox(playerid, "Minyak", str, 2969, 3);
	ShowProgressbar(playerid, "Mengolah Minyak..", 5);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
    Inventory_Update(playerid);
	return 1;
}

CMD:jualminyakaufa(playerid, params[])
{
    new total = pData[playerid][pEssence];
    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if(pData[playerid][pEssence] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Essence");
    ShowProgressbar(playerid, "Menjual Minyak..", 6);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pEssence] * 50;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pEssence] -= total;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, 5);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Essence", str, 3015, 5);
    Inventory_Update(playerid);
	return 1;
}
