/*

	LADANG

*/

//LADANG TEXT

Ladangtext()
{
	new strings[128];
	//Job kecubung
	CreateDynamicPickup(1239, 23, -1108.1039,-1637.3304,76.3672, -1); 
	format(strings, sizeof(strings), "[JOB KECUBUNG]\n"WHITE_E"use '"YELLOW_E"/kecubung and /endkecubung"WHITE_E"' to kecubung");
	CreateDynamic3DTextLabel(strings, ARWIN, -1108.1039,-1637.3304,76.3672, 5.0); 

	//Job Borax
	CreateDynamicPickup(1239, 23, -375.41,-1037.53,59.16, -1); 
	format(strings, sizeof(strings), "[JOB BORAX]\n"WHITE_E"use '"YELLOW_E"/borax and /endborax"WHITE_E"' to Borax");
	CreateDynamic3DTextLabel(strings, ARWIN, -375.41,-1037.53,59.16, 5.0); 

	//Olah bahan Borax
	CreateDynamicPickup(1239, 23, -1433.7598,-964.9735,200.9849, -1); 
	format(strings, sizeof(strings), "[OLAH BORAX]\n"WHITE_E"use '"YELLOW_E"/olahborax atau Y"WHITE_E"' to olah");
	CreateDynamic3DTextLabel(strings, ARWIN, -1433.7598,-964.9735,200.9849, 5.0); 

	//Olah bahan Kecubung
	CreateDynamicPickup(1239, 23, 1550.1710,-33.4645,21.3340, -1); 
	format(strings, sizeof(strings), "[OLAH KECUBUNG]\n"WHITE_E"use '"YELLOW_E"/olahkecubung atau Y"WHITE_E"' to olah");
	CreateDynamic3DTextLabel(strings, ARWIN, 1550.1710,-33.4645,21.3340, 5.0); 

	//penjualan borax
	CreateDynamicPickup(1239, 23, -1425.7248,-1529.2584,102.2175, -1); 
	format(strings, sizeof(strings), "[JUAL BORAX]\n"WHITE_E"use '"YELLOW_E"/jualborax atau Y"WHITE_E"' to jual");
	CreateDynamic3DTextLabel(strings, ARWIN, -1425.7248,-1529.2584,102.2175, 5.0); //  

	//penjualan kecubung
	CreateDynamicPickup(1239, 23, 2847.6291,983.4310,10.7500, -1); 
	format(strings, sizeof(strings), "[JUAL KECUBUNG]\n"WHITE_E"use '"YELLOW_E"/jualkecubung atau Y"WHITE_E"' to jual");
	CreateDynamic3DTextLabel(strings, ARWIN, 2847.6291,983.4310,10.7500, 5.0); //  
	return 1;
}


//Mapingan borax dan kecubung

/*Ladang()
{
	new tmpobjid;
	tmpobjid = CreateObject(854, -359.836578, -1038.800170, 58.369045, 0.000000, 0.000000, 0.000000, 300.00); 
	SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetObjectMaterial(tmpobjid, 2, 19638, "fruitcrates1", "applesred1", 0x00000000);
	tmpobjid = CreateObject(854, -359.836578, -1044.331054, 58.369045, 0.000000, 0.000000, 0.000000, 300.00); 
	SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetObjectMaterial(tmpobjid, 2, 19638, "fruitcrates1", "applesred1", 0x00000000);
	tmpobjid = CreateObject(854, -353.496582, -1047.871215, 58.369045, 0.000000, 0.000000, 0.000000, 300.00); 
	SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetObjectMaterial(tmpobjid, 2, 19638, "fruitcrates1", "applesred1", 0x00000000);
	tmpobjid = CreateObject(854, -361.876708, -1049.991088, 58.369045, 0.000000, 0.000000, 0.000000, 300.00); 
	SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetObjectMaterial(tmpobjid, 2, 19638, "fruitcrates1", "applesred1", 0x00000000);
	tmpobjid = CreateObject(854, -367.956756, -1053.620971, 58.369045, 0.000000, 0.000000, 0.000000, 300.00); 
	SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetObjectMaterial(tmpobjid, 2, 19638, "fruitcrates1", "applesred1", 0x00000000);
	tmpobjid = CreateObject(854, -357.906646, -1059.170776, 58.369045, 0.000000, 0.000000, 0.000000, 300.00); 
	SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetObjectMaterial(tmpobjid, 2, 19638, "fruitcrates1", "applesred1", 0x00000000);
	tmpobjid = CreateObject(854, -347.776672, -1061.930664, 58.329032, 0.000000, 0.000000, 0.000000, 300.00); 
	SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetObjectMaterial(tmpobjid, 2, 19638, "fruitcrates1", "applesred1", 0x00000000);
	tmpobjid = CreateObject(854, -375.646392, -1049.189819, 58.259037, 0.000000, 0.000000, 0.000000, 300.00); 
	SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetObjectMaterial(tmpobjid, 2, 19638, "fruitcrates1", "applesred1", 0x00000000);
	tmpobjid = CreateObject(854, -369.426361, -1044.479736, 58.419025, 0.000000, 0.000000, 0.000000, 300.00); 
	SetObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetObjectMaterial(tmpobjid, 2, 19638, "fruitcrates1", "applesred1", 0x00000000);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	tmpobjid = CreateObject(773, 2384.189941, -68.632797, 25.640600, 0.000000, 0.000000, 6.999989, 300.00); 
	tmpobjid = CreateObject(3246, -379.198272, -1036.532104, 58.275436, 0.000000, 0.000000, 94.100006, 300.00); 
	tmpobjid = CreateObject(19473, -1016.487060, -1624.360229, 75.107200, 0.000000, 0.000000, 0.000000, 300.00); 
	tmpobjid = CreateObject(19473, -1012.417053, -1625.750244, 75.107200, 0.000000, 0.000000, 0.000000, 300.00); 
	tmpobjid = CreateObject(19473, -1016.487060, -1615.219970, 75.107200, 0.000000, 0.000000, 0.000000, 300.00); 
	tmpobjid = CreateObject(19473, -1010.486938, -1630.120849, 75.107200, 0.000000, 0.000000, 0.000000, 300.00); 
	tmpobjid = CreateObject(19473, -1004.556945, -1625.460449, 75.107200, 0.000000, 0.000000, 0.000000, 300.00); 
	tmpobjid = CreateObject(19473, -1008.266967, -1613.120727, 75.107200, 0.000000, 0.000000, 0.000000, 300.00); 
	tmpobjid = CreateObject(19473, -1002.776855, -1619.830932, 75.107200, 0.000000, 0.000000, 0.000000, 300.00); 
	tmpobjid = CreateObject(19473, -999.917236, -1612.200805, 75.107200, 0.000000, 0.000000, 0.000000, 300.00); 
	tmpobjid = CreateObject(19473, -1011.827636, -1619.680786, 75.107200, 0.000000, 0.000000, 0.000000, 300.00);
	return 1; 
}

//removebuilding
Removeladang(playerid)
{
	//borax
	RemoveBuildingForPlayer(playerid, 3250, -348.671, -1041.959, 58.312, 0.250);
	RemoveBuildingForPlayer(playerid, 3246, -378.890, -1040.880, 57.859, 0.250);
	RemoveBuildingForPlayer(playerid, 3425, -365.875, -1060.839, 69.289, 0.250);
	return 1;
}
*/
//===========================CMD=================================//

CMD:olahborax(playerid, params[])
{
	if(pData[playerid][pTukar] == 1) return Error(playerid, "Anda masih mengproses");
	if(pData[playerid][pFamily] == -1) return Error(playerid, "Only for family member!");
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, -1433.7598,-964.9735,200.9849))
		if(pData[playerid][pBorax] < 5) return Error(playerid, "Anda Kurang Paket Borax Untuk Menggapai 1 paket. (minaml:5)");
		{
			if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
			{
				pData[playerid][pBorax] -= 5;
				pData[playerid][pPaketborax] += 1;

				pData[playerid][pTukar] += 1;

				TogglePlayerControllable(playerid, 0);
				Info(playerid, "Anda sedang memperoses borax!");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				olahh[playerid] = SetTimerEx("olahladang", 700, true, "idd", playerid);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Olahh...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			}
		}
	}
	return 1;
}

CMD:olahkecubung(playerid, params[])
{
	if(pData[playerid][pTukar] == 1) return Error(playerid, "Anda masih mengproses");
	if(pData[playerid][pFamily] == -1) return Error(playerid, "Only for family member!");
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 1550.1710,-33.4645,21.3340))
		if(pData[playerid][pKecubung] < 5) return Error(playerid, "Anda Kurang Paket kecubung Untuk Menggapai 1 paket. (minaml:5)");
		{
			if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
			{
				pData[playerid][pKecubung] -= 5;
				pData[playerid][pPaketkecubung] += 1;

				pData[playerid][pTukar] += 1;

				TogglePlayerControllable(playerid, 0);
				Info(playerid, "Anda sedang memperoses kecubung!");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				olahh[playerid] = SetTimerEx("olahladang", 700, true, "idd", playerid);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Olahh...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			}
		}
	}
	return 1;
}

CMD:jualborax(playerid, params[])
{
	if(pData[playerid][pTukar] == 1) return Error(playerid, "Anda masih mengproses");
	if(pData[playerid][pFamily] == -1) return Error(playerid, "Only for family member!");
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, -1425.7248,-1529.2584,102.2175))
		if(pData[playerid][pPaketborax] < 5) return Error(playerid, "Anda Kurang Paket borax Untuk menjual . (minaml:5)");
		{
			if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
			{
				new Randborax = Random(150, 200);
				pData[playerid][pPaketborax] -= 1;
				pData[playerid][pRedMoney] += Randborax;

				pData[playerid][pTukar] += 1;

				TogglePlayerControllable(playerid, 0);
				Info(playerid, "Anda sedang memperoses borax!");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				olahh[playerid] = SetTimerEx("olahladang", 700, true, "idd", playerid);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Olahh...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			}
		}
	}
	return 1;
}
CMD:jualkecubung(playerid, params[])
{
	if(pData[playerid][pTukar] == 1) return Error(playerid, "Anda masih mengproses");
	if(pData[playerid][pFamily] == -1) return Error(playerid, "Only for family member!");
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 2847.6291,983.4310,10.7500))
		if(pData[playerid][pPaketkecubung] < 5) return Error(playerid, "Anda Kurang Paket kecubung Untuk menjual. (minaml:5)");
		{
			if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
			{
				new Randkecubung = Random(165, 200);
				pData[playerid][pPaketkecubung] -= 5;
				pData[playerid][pRedMoney] += Randkecubung;

				pData[playerid][pTukar] += 1;

				TogglePlayerControllable(playerid, 0);
				Info(playerid, "Anda sedang memperoses kecubung!");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				olahh[playerid] = SetTimerEx("olahladang", 700, true, "idd", playerid);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Olahh...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			}
		}
	}
	return 1;
}

forward olahladang(playerid);
public olahladang(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(pData[playerid][pActivityTime] >= 100)
	{
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		TogglePlayerControllable(playerid, 1);
		pData[playerid][pActivityTime] = 0;
		pData[playerid][pTukar] -= 1;
		ClearAnimations(playerid);
		KillTimer(olahh[playerid]);
		SendClientMessage(playerid, COLOR_TWAQUA, "[SUKSES] {FFFFFF}Sukses menggolah!");
	}
	else if(pData[playerid][pActivityTime] < 100)
	{
		pData[playerid][pActivityTime] += 5;
		SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

//
CMD:kecubung(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, -1108.1039,-1637.3304,76.3672)) return Error(playerid, "Kamu Tidak Di Area kecubung.");
	{
		SetPlayerCheckpoint(playerid, -1011.65,-1619.78,76.36, 1.0);
		SendClientMessage(playerid,COLOR_YELLOW,"Silakan mengikuti checkpoint");
	}
	return 1;
}
CMD:endkecubung(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, -1108.1039,-1637.3304,76.3672)) return Error(playerid, "Kamu Tidak Di Area kecubung.");
	{
		DisablePlayerCheckpoint(playerid);
		SendClientMessage(playerid,COLOR_YELLOW,"Kamu Telah Berhenti Kerja Kecubung");
	}
	return 1;
}

CMD:borax(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, -375.41,-1037.53,59.16)) return Error(playerid, "Kamu Tidak Di Area borax.");
	{
		SetPlayerCheckpoint(playerid, -367.70,-1052.94,59.30, 1.0);
		SendClientMessage(playerid,COLOR_YELLOW,"Silakan mengikuti checkpoint");
	}	
	return 1;
}
CMD:endborax(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, -375.41,-1037.53,59.16)) return Error(playerid, "Kamu Tidak Di Area Borax.");
	{
		RemovePlayerAttachedObject(playerid,0);
		DisablePlayerCheckpoint(playerid);
		SendClientMessage(playerid,COLOR_YELLOW,"Kamu Telah Berhenti Kerja Borax");
	}
	return 1;
}
