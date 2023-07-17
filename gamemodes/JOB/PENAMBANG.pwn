function nambang1(playerid)
{
	new dapetbatu = RandomEx(1,3);
    pData[playerid][pBatu] += dapetbatu;
    new str[500];
	format(str, sizeof(str), "Received_%dx", dapetbatu);
	ShowItemBox(playerid, "Batu", str, 905, 4);
	TogglePlayerControllable(playerid, true);
	RemovePlayerAttachedObject(playerid, 9);
	return 1;
}
CMD:nambangAufa1(playerid, params[])
{
	if(pData[playerid][pJob] != 6) return 1;
	if(pData[playerid][pDutyJob] != 2) return ErrorMsg(playerid, "Anda belum memakai Baju kerja");
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress");
	ShowProgressbar(playerid, "Menambang..", 5);
	SetPlayerAttachedObject(playerid, 9, 19631, 5, 0.1, 0.02, -0.05, 0, 0, 0, 1, 1, 1);
	ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 1, 1, 1, 0, 1);
	TogglePlayerControllable(playerid, false);
	SetTimerEx("nambang1", 5000, false, "d", playerid);
	return 1;
}
enum E_PENAMBANG
{
    STREAMER_TAG_MAP_ICON:LockerMap,
    STREAMER_TAG_MAP_ICON:NambangMap,
    STREAMER_TAG_MAP_ICON:CuciMap,
    STREAMER_TAG_MAP_ICON:PeleburanMap,
    STREAMER_TAG_MAP_ICON:PenjualanMap,
	STREAMER_TAG_CP:LockerTambang,
	STREAMER_TAG_CP:TakeCarTambang,
	STREAMER_TAG_CP:Nambang,
	STREAMER_TAG_CP:Nambang2,
	STREAMER_TAG_CP:Nambang3,
	STREAMER_TAG_CP:Nambang4,
	STREAMER_TAG_CP:Nambang5,
	STREAMER_TAG_CP:Nambang6,
	STREAMER_TAG_CP:CuciBatu,
	STREAMER_TAG_CP:Peleburan,
	STREAMER_TAG_CP:Penjualan,
}
new PenambangArea[MAX_PLAYERS][E_PENAMBANG];

DeletePenambangCP(playerid)
{
	if(IsValidDynamicCP(PenambangArea[playerid][LockerTambang]))
	{
		DestroyDynamicCP(PenambangArea[playerid][LockerTambang]);
		PenambangArea[playerid][LockerTambang] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenambangArea[playerid][Nambang]))
	{
		DestroyDynamicCP(PenambangArea[playerid][Nambang]);
		PenambangArea[playerid][Nambang] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenambangArea[playerid][Nambang2]))
	{
		DestroyDynamicCP(PenambangArea[playerid][Nambang2]);
		PenambangArea[playerid][Nambang2] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenambangArea[playerid][Nambang3]))
	{
		DestroyDynamicCP(PenambangArea[playerid][Nambang3]);
		PenambangArea[playerid][Nambang3] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenambangArea[playerid][Nambang4]))
	{
		DestroyDynamicCP(PenambangArea[playerid][Nambang4]);
		PenambangArea[playerid][Nambang4] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenambangArea[playerid][Nambang5]))
	{
		DestroyDynamicCP(PenambangArea[playerid][Nambang5]);
		PenambangArea[playerid][Nambang5] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenambangArea[playerid][Nambang6]))
	{
		DestroyDynamicCP(PenambangArea[playerid][Nambang6]);
		PenambangArea[playerid][Nambang6] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenambangArea[playerid][CuciBatu]))
	{
		DestroyDynamicCP(PenambangArea[playerid][CuciBatu]);
		PenambangArea[playerid][CuciBatu] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PenambangArea[playerid][Peleburan]))
	{
		DestroyDynamicCP(PenambangArea[playerid][Peleburan]);
		PenambangArea[playerid][Peleburan] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicMapIcon(PenambangArea[playerid][LockerMap]))
	{
		DestroyDynamicMapIcon(PenambangArea[playerid][LockerMap]);
		PenambangArea[playerid][LockerMap] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicMapIcon(PenambangArea[playerid][NambangMap]))
	{
		DestroyDynamicMapIcon(PenambangArea[playerid][NambangMap]);
		PenambangArea[playerid][NambangMap] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicMapIcon(PenambangArea[playerid][CuciMap]))
	{
		DestroyDynamicMapIcon(PenambangArea[playerid][CuciMap]);
		PenambangArea[playerid][CuciMap] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicMapIcon(PenambangArea[playerid][PeleburanMap]))
	{
		DestroyDynamicMapIcon(PenambangArea[playerid][PeleburanMap]);
		PenambangArea[playerid][PeleburanMap] = STREAMER_TAG_MAP_ICON: -1;
	}
}

RefreshJobTambang(playerid)
{
	DeletePenambangCP(playerid);

	if(pData[playerid][pJob] == 6)
	{
			PenambangArea[playerid][Nambang] = CreateDynamicCP(-396.967498,1260.187988,7.082924, 1.0, -1, -1, playerid, 5.0);
			PenambangArea[playerid][Nambang2] = CreateDynamicCP(-393.617950,1259.353393,7.093970, 1.0, -1, -1, playerid, 5.0);
			PenambangArea[playerid][Nambang3] = CreateDynamicCP(-396.943634,1254.083374,6.890728, 1.0, -1, -1, playerid, 5.0);
			PenambangArea[playerid][Nambang4] = CreateDynamicCP(-393.588256,1253.867553,6.928194, 1.0, -1, -1, playerid, 5.0);
			PenambangArea[playerid][Nambang5] = CreateDynamicCP(-393.591278,1249.288940,6.789647, 1.0, -1, -1, playerid, 5.0);
			PenambangArea[playerid][Nambang6] = CreateDynamicCP(-396.575592,1249.352050,6.749223, 1.0, -1, -1, playerid, 5.0);
			PenambangArea[playerid][CuciBatu] = CreateDynamicCP(-795.673522,-1928.231567,5.612922, 2.0, -1, -1, playerid, 30.0);
            PenambangArea[playerid][Peleburan] = CreateDynamicCP(2152.539062,-2263.646972,13.300081, 2.0, -1, -1, playerid, 30.0);
			PenambangArea[playerid][NambangMap] = CreateDynamicMapIcon(-396.575592,1249.352050,6.749223, 11, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
			PenambangArea[playerid][CuciMap] = CreateDynamicMapIcon(-795.673522,-1928.231567,5.612922, 11, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
			PenambangArea[playerid][PeleburanMap] = CreateDynamicMapIcon(2152.539062,-2263.646972,13.300081, 11, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
		}
		return 1;
	}
CMD:cucibatuAufa(playerid, params[])
{
    if(pData[playerid][pJob] != 6) return 1;
	if(pData[playerid][pDutyJob] != 2) return ErrorMsg(playerid, "Anda belum memakai Baju kerja");
    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if(pData[playerid][pBatu] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Batu");
	pData[playerid][pBatu] -= 1;
	pData[playerid][pBatuCucian] += 1;
	ShowItemBox(playerid, "Batu_Cucian", "Received_1x", 2936, 2);
	ShowItemBox(playerid, "Batu", "Removed_1x", 905, 2);
	ShowProgressbar(playerid, "Mencuci Batu..", 3);
    Inventory_Update(playerid);
    ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	return 1;
}

CMD:peleburanbatuAufa(playerid, params[])
{
    if(pData[playerid][pJob] != 6) return 1;
	if(pData[playerid][pDutyJob] != 2) return ErrorMsg(playerid, "Anda belum memakai Baju kerja");
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if(pData[playerid][pBatuCucian] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Batu Cucian");
 	SetTimerEx("leburkanbatuan", 4000, false, "d", playerid);
 	ShowProgressbar(playerid, "Meleburkan Batuan..", 4);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
    Inventory_Update(playerid);
	return 1;
}

function leburkanbatuan(playerid)
{
    if(IsPlayerConnected(playerid) && pData[playerid][pJob] == 6)
	{
		new rand = RandomEx(1,10);
	    if(rand == 1)
	    {
			pData[playerid][pEmas] += 1;
			pData[playerid][pBatuCucian] -= 1;
			ShowItemBox(playerid, "Emas", "Received_1x", 19941, 2);
			ShowItemBox(playerid, "Batu_Cucian", "Removed_1x", 2936, 2);
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
		else if(rand == 2)
		{
		    pData[playerid][pBesi] += 1;
		  	pData[playerid][pBatuCucian] -= 1;
			ShowItemBox(playerid, "Besi", "Received_1x", 1510, 2);
			ShowItemBox(playerid, "Batu_Cucian", "Removed_1x", 2936, 2);
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
		else if(rand == 3)
		{
		    pData[playerid][pAluminium] += 1;
		  	pData[playerid][pBatuCucian] -= 1;
			ShowItemBox(playerid, "Aluminium", "Received_1x", 19809, 2);
			ShowItemBox(playerid, "Batu_Cucian", "Removed_1x", 2936, 2);
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
		else if(rand == 4)
		{
		    pData[playerid][pBesi] += 1;
		  	pData[playerid][pBatuCucian] -= 1;
			ShowItemBox(playerid, "Besi", "Received_1x", 1510, 2);
			ShowItemBox(playerid, "Batu_Cucian", "Removed_1x", 2936, 2);
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
		else if(rand == 5)
		{
		    pData[playerid][pBesi] += 1;
		  	pData[playerid][pBatuCucian] -= 1;
			ShowItemBox(playerid, "Besi", "Received_1x", 1510, 2);
			ShowItemBox(playerid, "Batu_Cucian", "Removed_1x", 2936, 2);
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
		else if(rand == 6)
		{
		    pData[playerid][pAluminium] += 1;
		  	pData[playerid][pBatuCucian] -= 1;
			ShowItemBox(playerid, "Aluminium", "Received_1x", 19809, 2);
			ShowItemBox(playerid, "Batu_Cucian", "Removed_1x", 2936, 2);
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
		else if(rand == 7)
		{
		    pData[playerid][pBesi] += 1;
		  	pData[playerid][pBatuCucian] -= 1;
			ShowItemBox(playerid, "Besi", "Received_1x", 1510, 2);
			ShowItemBox(playerid, "Batu_Cucian", "Removed_1x", 2936, 2);
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
		else if(rand == 8)
		{
		    pData[playerid][pAluminium] += 1;
		  	pData[playerid][pBatuCucian] -= 1;
			ShowItemBox(playerid, "Aluminium", "Received_1x", 19809, 2);
			ShowItemBox(playerid, "Batu_Cucian", "Removed_1x", 2936, 2);
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
		else if(rand == 9)
		{
		    pData[playerid][pBesi] += 1;
		  	pData[playerid][pBatuCucian] -= 1;
			ShowItemBox(playerid, "Besi", "Received_1x", 1510, 2);
			ShowItemBox(playerid, "Batu_Cucian", "Removed_1x", 2936, 2);
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
		else if(rand == 10)
		{
		    pData[playerid][pAluminium] += 1;
		  	pData[playerid][pBatuCucian] -= 1;
			ShowItemBox(playerid, "Aluminium", "Received_1x", 19809, 2);
			ShowItemBox(playerid, "Batu_Cucian", "Removed_1x", 2936, 2);
			pData[playerid][pBladder] += 1;
			pData[playerid][pHunger] -= 1;
			pData[playerid][pEnergy] -= 1;
		}
	}
	return 1;
}

CMD:jualemasAufa(playerid, params[])
{
    new total = pData[playerid][pEmas];
    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if( pData[playerid][pEmas] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Emas");
    ShowProgressbar(playerid, "Menjual Emas..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pEmas] * 50;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pEmas] -= total;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, 4);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Emas", str, 19941, 4);
    Inventory_Update(playerid);
	return 1;
}

CMD:jualtembagaAufa(playerid, params[])
{
    new total = pData[playerid][pAluminium];
    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if( pData[playerid][pAluminium] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Tembaga");
    ShowProgressbar(playerid, "Menjual Tembaga..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pAluminium] * 45;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pAluminium] -= total;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, 4);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Aluminium", str, 19809, 4);
    Inventory_Update(playerid);
	return 1;
}
CMD:jualbesiAufa(playerid, params[])
{
    new total = pData[playerid][pBesi];
    if( pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if( pData[playerid][pBesi] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Besi");
    ShowProgressbar(playerid, "Menjual Besi..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pBesi] * 40;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pBesi] -= total;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, 4);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Besi", str, 1510, 4);
    Inventory_Update(playerid);
	return 1;
}

function TungguNambang1(playerid)
{
	pData[playerid][pTimeTambang1] = 0;
	return 1;
}
function TungguNambang2(playerid)
{
	pData[playerid][pTimeTambang2] = 0;
	return 1;
}
function TungguNambang3(playerid)
{
	pData[playerid][pTimeTambang3] = 0;
	return 1;
}
function TungguNambang4(playerid)
{
	pData[playerid][pTimeTambang4] = 0;
	return 1;
}
function TungguNambang5(playerid)
{
	pData[playerid][pTimeTambang5] = 0;
	return 1;
}
function TungguNambang6(playerid)
{
	pData[playerid][pTimeTambang6] = 0;
	return 1;
}
