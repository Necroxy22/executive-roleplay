function MuatBarang(playerid)
{
	pData[playerid][pKargo] = 1;
	InfoMsg(playerid, "Bawa muatan kembali ke ~y~Pelabuhan Executive ~w~ikutilah tanda.");
	SetPlayerRaceCheckpoint(playerid,1, -1040.951782,-656.037048,32.007812, 0.0, 0.0, 0.0, 3.5);
	return 1;
}
function MuatBarangRock(playerid)
{
	pData[playerid][pKargo] = 3;
	InfoMsg(playerid, "Bawa muatan kembali ke ~y~Pelabuhan Executive ~w~ikutilah tanda.");
	SetPlayerRaceCheckpoint(playerid,1, -1040.951782,-656.037048,32.007812, 0.0, 0.0, 0.0, 3.5);
	return 1;
}
function MuatBarangLva(playerid)
{
	pData[playerid][pKargo] = 5;
	InfoMsg(playerid, "Bawa muatan kembali ke ~y~Pelabuhan Executive ~w~ikutilah tanda.");
	SetPlayerRaceCheckpoint(playerid,1, -1040.951782,-656.037048,32.007812, 0.0, 0.0, 0.0, 3.5);
	return 1;
}
function TungguKargo(playerid)
{
	delaykargo = 0;
	return 1;
}
function BahanBakar(playerid)
{
	pData[playerid][pKargo] = 2;
	InfoMsg(playerid, "Bawa muatan kembali ke ~y~Pelabuhan Executive ~w~ikutilah tanda.");
	SetPlayerRaceCheckpoint(playerid,1, -1040.951782,-656.037048,32.007812, 0.0, 0.0, 0.0, 3.5);
	return 1;
}
function BahanBakarLv(playerid)
{
	pData[playerid][pKargo] = 4;
	InfoMsg(playerid, "Bawa muatan kembali ke ~y~Pelabuhan Executive ~w~ikutilah tanda.");
	SetPlayerRaceCheckpoint(playerid,1, -1040.951782,-656.037048,32.007812, 0.0, 0.0, 0.0, 3.5);
	return 1;
}
function BahanBakarSf(playerid)
{
	pData[playerid][pKargo] = 6;
	InfoMsg(playerid, "Bawa muatan kembali ke ~y~Pelabuhan Executive ~w~ikutilah tanda.");
	SetPlayerRaceCheckpoint(playerid,1, -1040.951782,-656.037048,32.007812, 0.0, 0.0, 0.0, 3.5);
	return 1;
}

enum E_KARGO
{
	STREAMER_TAG_CP:Kargo,
	STREAMER_TAG_MAP_ICON:KargoMap
}
new KargoArea[MAX_PLAYERS][E_KARGO];

DeleteKargoCP(playerid)
{
    if(IsValidDynamicCP(KargoArea[playerid][Kargo]))
	{
		DestroyDynamicCP(KargoArea[playerid][Kargo]);
		KargoArea[playerid][Kargo] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicMapIcon(KargoArea[playerid][KargoMap]))
	{
		DestroyDynamicMapIcon(KargoArea[playerid][KargoMap]);
		KargoArea[playerid][KargoMap] = STREAMER_TAG_MAP_ICON: -1;
	}
}

RefreshJobKargo(playerid)
{
	DeleteKargoCP(playerid);
	if(pData[playerid][pJob] == 8)
	{
	    KargoArea[playerid][Kargo] = CreateDynamicCP(-999.998291,-683.041320,32.007812, 2.0, -1, -1, playerid, 15.0);
		KargoArea[playerid][KargoMap] = CreateDynamicMapIcon(-999.998291,-683.041320,32.007812, 51, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
	}
	return 1;
}
CMD:kargoaufa(playerid, params[])
{
    if(pData[playerid][pJob] == 8)
	{
	    if(delaykargo > 0) return ErrorMsg(playerid, "Mohon tunggu selama 10 detik");
		if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
		ShowPlayerDialog(playerid, DIALOG_KARGO, DIALOG_STYLE_TABLIST_HEADERS, "{BABABA}Executive - {FFFFFF}Pilih Kargo", "Jenis\nBarang\nPertamina", "Pilih", "Tutup");
	}
	return 1;
}
function KargoMinyak(playerid)
{
    if(IsPlayerConnected(playerid) && pData[playerid][pJob] == 8)
	{
		new rand = RandomEx(1,3);
	    if(rand == 1)
	    {
	        pData[playerid][pKendaraanKerja] = CreateVehicle(515,-1030.085327,-731.758789,33.008674,358.277282,0,0,120000,0);
			PutPlayerInVehicle(playerid, pData[playerid][pKendaraanKerja], 0);
			delaykargo = 10;
			SetTimerEx("TungguKargo", 10000, false, "d", playerid);
		  	SetVehicleNumberPlate(pData[playerid][pKendaraanKerja], "JOB VEHICLE");
			pData[playerid][pTrailer] = CreateVehicle(584,-1030.152465,-741.635375,32.007812,358.277282,0,0,120000,0);
			SetPlayerRaceCheckpoint(playerid,1, 249.263397,1443.614746,10.585937, 0.0, 0.0, 0.0, 3.5);
     		InfoMsg(playerid, "Silahkan ikuti tanda untuk mengangkut muatan ~y~Bahan Bakar ~w~yang terletak di Green Palms.");
		}
		else if(rand == 2)
		{
		    pData[playerid][pKendaraanKerja] = CreateVehicle(515,-1030.085327,-731.758789,33.008674,358.277282,0,0,120000,0);
			PutPlayerInVehicle(playerid, pData[playerid][pKendaraanKerja], 0);
			delaykargo = 10;
			SetTimerEx("TungguKargo", 10000, false, "d", playerid);
		  	SetVehicleNumberPlate(pData[playerid][pKendaraanKerja], "JOB VEHICLE");
			pData[playerid][pTrailer] = CreateVehicle(584,-1030.152465,-741.635375,32.007812,358.277282,0,0,120000,0);
			SetPlayerRaceCheckpoint(playerid,1, -1676.272094,412.909149,7.179687, 0.0, 0.0, 0.0, 3.5);
     		InfoMsg(playerid, "Silahkan ikuti tanda untuk mengangkut muatan ~y~Bahan Bakar ~w~yang terletak di Easter Basin.");
		}
		else if(rand == 3)
		{
		    pData[playerid][pKendaraanKerja] = CreateVehicle(515,-1030.085327,-731.758789,33.008674,358.277282,0,0,120000,0);
			PutPlayerInVehicle(playerid, pData[playerid][pKendaraanKerja], 0);
			delaykargo = 10;
			SetTimerEx("TungguKargo", 10000, false, "d", playerid);
		  	SetVehicleNumberPlate(pData[playerid][pKendaraanKerja], "JOB VEHICLE");
			pData[playerid][pTrailer] = CreateVehicle(584,-1030.152465,-741.635375,32.007812,358.277282,0,0,120000,0);
			SetPlayerRaceCheckpoint(playerid,1, -1326.462036,2688.859619,50.062500, 0.0, 0.0, 0.0, 3.5);
     		InfoMsg(playerid, "Silahkan ikuti tanda untuk mengangkut muatan ~y~Bahan Bakar ~w~yang terletak di Tierra Robada.");
		}
	}
	return 1;
}
function KargoBarang(playerid)
{
    if(IsPlayerConnected(playerid) && pData[playerid][pJob] == 8)
	{
		new rand = RandomEx(1,3);
	    if(rand == 1)
	    {
	        pData[playerid][pKendaraanKerja] = CreateVehicle(515,-1029.995971,-732.025512,33.029350,358.277282,0,0,120000,0);
			PutPlayerInVehicle(playerid, pData[playerid][pKendaraanKerja], 0);
    		SetVehicleNumberPlate(pData[playerid][pKendaraanKerja], "JOB VEHICLE");
    		delaykargo = 10;
    		SetTimerEx("TungguKargo", 10000, false, "d", playerid);
			pData[playerid][pTrailer] = CreateVehicle(435,-1030.152465,-741.635375,32.007812,358.277282,0,0,120000,0);
			SetPlayerRaceCheckpoint(playerid,1, 290.330383,2542.228027,16.820337, 0.0, 0.0, 0.0, 3.5);
			InfoMsg(playerid, "Silahkan ikuti tanda untuk mengangkut muatan ~y~Puing Pesawat ~w~yang terletak di Verdant Meadows.");
		}
		else if(rand == 2)
		{
		    pData[playerid][pKendaraanKerja] = CreateVehicle(515,-1029.995971,-732.025512,33.029350,358.277282,0,0,120000,0);
			PutPlayerInVehicle(playerid, pData[playerid][pKendaraanKerja], 0);
    		SetVehicleNumberPlate(pData[playerid][pKendaraanKerja], "JOB VEHICLE");
    		delaykargo = 10;
    		SetTimerEx("TungguKargo", 10000, false, "d", playerid);
			pData[playerid][pTrailer] = CreateVehicle(435,-1030.152465,-741.635375,32.007812,358.277282,0,0,120000,0);
			SetPlayerRaceCheckpoint(playerid,1, 2814.943847,964.729858,10.750000, 0.0, 0.0, 0.0, 3.5);
			InfoMsg(playerid, "Silahkan ikuti tanda untuk mengangkut muatan ~y~Barang ~w~yang terletak di Rockshore East.");
		}
		else if(rand == 3)
		{
		    pData[playerid][pKendaraanKerja] = CreateVehicle(515,-1029.995971,-732.025512,33.029350,358.277282,0,0,120000,0);
			PutPlayerInVehicle(playerid, pData[playerid][pKendaraanKerja], 0);
    		SetVehicleNumberPlate(pData[playerid][pKendaraanKerja], "JOB VEHICLE");
    		delaykargo = 10;
    		SetTimerEx("TungguKargo", 10000, false, "d", playerid);
			pData[playerid][pTrailer] = CreateVehicle(435,-1030.152465,-741.635375,32.007812,358.277282,0,0,120000,0);
			SetPlayerRaceCheckpoint(playerid,1, 1633.136718,971.050537,10.820312, 0.0, 0.0, 0.0, 3.5);
			InfoMsg(playerid, "Silahkan ikuti tanda untuk mengangkut muatan ~y~Barang ~w~yang terletak di Lva Freight Depot.");
		}
	}
	return 1;
}
