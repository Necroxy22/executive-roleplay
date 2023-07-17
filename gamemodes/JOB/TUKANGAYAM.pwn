enum E_PEMOTONG
{
    STREAMER_TAG_MAP_ICON:LockerMap,
    STREAMER_TAG_MAP_ICON:TempatKerja,
    STREAMER_TAG_MAP_ICON:AmbilMap,
	STREAMER_TAG_CP:LockerPemotong,
	STREAMER_TAG_CP:AmbilAyam,
	STREAMER_TAG_CP:AmbilAyamHidup,
	STREAMER_TAG_CP:PotongAyam,
	STREAMER_TAG_CP:PotongAyam2,
	STREAMER_TAG_CP:PotongAyam3,
	STREAMER_TAG_CP:PackingAyam,
	STREAMER_TAG_CP:PackingAyam2
}
new PemotongArea[MAX_PLAYERS][E_PEMOTONG];

DeletePemotongCP(playerid)
{
	if(IsValidDynamicCP(PemotongArea[playerid][LockerPemotong]))
	{
		DestroyDynamicCP(PemotongArea[playerid][LockerPemotong]);
		PemotongArea[playerid][LockerPemotong] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PemotongArea[playerid][AmbilAyam]))
	{
		DestroyDynamicCP(PemotongArea[playerid][AmbilAyam]);
		PemotongArea[playerid][AmbilAyam] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PemotongArea[playerid][AmbilAyamHidup]))
	{
		DestroyDynamicCP(PemotongArea[playerid][AmbilAyamHidup]);
		PemotongArea[playerid][AmbilAyamHidup] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PemotongArea[playerid][PotongAyam]))
	{
		DestroyDynamicCP(PemotongArea[playerid][PotongAyam]);
		PemotongArea[playerid][PotongAyam] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PemotongArea[playerid][PotongAyam2]))
	{
		DestroyDynamicCP(PemotongArea[playerid][PotongAyam2]);
		PemotongArea[playerid][PotongAyam2] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PemotongArea[playerid][PotongAyam3]))
	{
		DestroyDynamicCP(PemotongArea[playerid][PotongAyam3]);
		PemotongArea[playerid][PotongAyam3] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PemotongArea[playerid][PackingAyam]))
	{
		DestroyDynamicCP(PemotongArea[playerid][PackingAyam]);
		PemotongArea[playerid][PackingAyam] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PemotongArea[playerid][PackingAyam2]))
	{
		DestroyDynamicCP(PemotongArea[playerid][PackingAyam2]);
		PemotongArea[playerid][PackingAyam2] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicMapIcon(PemotongArea[playerid][LockerMap]))
	{
		DestroyDynamicMapIcon(PemotongArea[playerid][LockerMap]);
		PemotongArea[playerid][LockerMap] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicMapIcon(PemotongArea[playerid][TempatKerja]))
	{
		DestroyDynamicMapIcon(PemotongArea[playerid][TempatKerja]);
		PemotongArea[playerid][TempatKerja] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicMapIcon(PemotongArea[playerid][AmbilMap]))
	{
		DestroyDynamicMapIcon(PemotongArea[playerid][AmbilMap]);
		PemotongArea[playerid][AmbilMap] = STREAMER_TAG_MAP_ICON: -1;
	}
}

RefreshJobPemotong(playerid)
{
	DeletePemotongCP(playerid);

	if(pData[playerid][pJob] == 2)
	{
	    PemotongArea[playerid][AmbilAyam] = CreateDynamicCP(-1422.421142,-967.581909,200.775970, 2.0, -1, -1, playerid, 30.0);
	    PemotongArea[playerid][AmbilAyamHidup] = CreateDynamicCP(-1428.316528,-950.212158,201.093750, 2.0, -1, -1, playerid, 30.0);
	    PemotongArea[playerid][PotongAyam] = CreateDynamicCP(-2075.82, -2440.67, 30.6839, 2.0, -1, -1, playerid, 30.0);
	    PemotongArea[playerid][PotongAyam2] = CreateDynamicCP(-2074.63, -2439.26, 30.6739, 2.0, -1, -1, playerid, 30.0);
	    PemotongArea[playerid][PotongAyam3] = CreateDynamicCP(-2076.86, -2441.9, 30.6839, 2.0, -1, -1, playerid, 30.0);
	    PemotongArea[playerid][PackingAyam] = CreateDynamicCP(-2058.77, -2437.32, 30.6939, 2.0, -1, -1, playerid, 30.0);
	    PemotongArea[playerid][PackingAyam2] = CreateDynamicCP(-2060.71, -2439.79, 30.6939, 2.0, -1, -1, playerid, 30.0);
	    PemotongArea[playerid][AmbilMap] = CreateDynamicMapIcon(-1113.361328,-1660.300415,76.378242, 14, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
		PemotongArea[playerid][TempatKerja] = CreateDynamicMapIcon(-1422.421142,-967.581909,200.775970, 14, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
	}
	return 1;
}

CMD:ambilayam(playerid, params[])
{
    if(pData[playerid][pJob] == 2 || pData[playerid][pJob2] == 2)
    {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, -1428.316528,-950.212158,201.093750))
        {
            //if(pData[playerid][pPemotongStatus] == 1) return ErrorMsg(playerid, "Anda Masih Proses Ayam");
            if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
            {
                pData[playerid][pPemotongStatus] += 1;
                ayamjob[playerid] = SetTimerEx("getchicken", 2000, false, "id", playerid);
                ShowProgressbar(playerid, "Mengambil Ayam", 2);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
            } 
        }
        else return ErrorMsg(playerid, "Kamu Tidak Di Tempat Pengambilan Ayam.");
    }
    else ErrorMsg(playerid, "Anda bukan Bekerja Pemotong Ayam.");
    return 1;
}

CMD:izinayam(playerid, params[])
{
    if(pData[playerid][pJob] == 2 || pData[playerid][pJob2] == 2)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, -1422.421142,-967.581909,200.775970))
        {
            if(pData[playerid][DutyAmbilAyam] == 1) return ErrorMsg(playerid, "Silahkan selesaikan pekerjaan terlebih dahulu");
            if(pData[playerid][AyamHidup] == 30) return ErrorMsg(playerid, "Anda sudah membawa 30 Ayam Hidup!");
            SetPlayerPos(playerid, -1428.316528,-950.212158,201.093750);
            pData[playerid][DutyAmbilAyam] = 1;
            PlayerData[playerid][pPos][0] = -1428.316528,
			PlayerData[playerid][pPos][1] = -950.212158,
			PlayerData[playerid][pPos][2] = 201.093750;
			PlayerData[playerid][pPos][3] = pData[playerid][pPosA];
			InterpolateCameraPos(playerid, PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1],250.00,PlayerData[playerid][pPos][0]-2.5, PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]+2.5,2500,CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], 2500, CAMERA_MOVE);
			SetTimerEx("SetPlayerCameraBehindAyam", 2500, false, "i", playerid);
        }
        else return ErrorMsg(playerid, "Kamu Tidak Di Tempat Pengolah Ayam.");
    }
    else ErrorMsg(playerid, "Anda bukan Bekerja Pemotong Ayam.");
    return 1;
}

CMD:masukkandangayam(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 1.0, -1435.59, -1463.27, 101.711))
	{
		SetPlayerPos(playerid, -1433.84, -1461.69, 101.711);
	}
	return 1;
}

CMD:keluarkandangayam(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 1.0, -1433.84, -1461.69, 101.711))
	{
		SetPlayerPos(playerid, -1435.59, -1463.27, 101.711);
	}
	return 1;
}

CMD:stoptangkapayam(playerid, params[])
{
	if(pData[playerid][pJob] == 2 || pData[playerid][pJob2] == 2)
    {
		if(IsPlayerInRangeOfPoint(playerid, 1.0, -1433.84, -1461.69, 101.711))
		{
			if(pData[playerid][sedangambilayam] == false)
				return ErrorMsg(playerid, "Anda tidak sedang tangkap ayam");

			pData[playerid][sedangambilayam] = false;
			SuccesMsg(playerid, "Anda berhenti ambil ayam");
			DisablePlayerCheckpoint(playerid);
		}
	}
	return 1;
}
CMD:mulaitangkapayam(playerid, params[])
{
	if(pData[playerid][pJob] == 2 || pData[playerid][pJob2] == 2)
    {
		if(IsPlayerInRangeOfPoint(playerid, 1.0, -1433.84, -1461.69, 101.711))
		{
			if(pData[playerid][sedangambilayam] == true)
				return ErrorMsg(playerid, "Anda sedang Proses menangkap ayam");

			pData[playerid][sedangambilayam] = true;
			CallRemoteFunction("tangkapayam", "i", playerid);
		}
	}
	return 1;
}
forward ngambilayam(playerid);
public ngambilayam(playerid)
{
	ShowItemBox(playerid, "Ayam", "Received_1x", 16776, 2);
	pData[playerid][AyamHidup] += 1;
	pData[playerid][pEnergy] -= 1;
	CallRemoteFunction("tangkapayam", "i", playerid);
	return 1;
}
forward tangkapayam(playerid);
public tangkapayam(playerid)
{
    if(IsPlayerConnected(playerid) && pData[playerid][pJob] == 2)
	{
		new rand = RandomEx(1,8);
	    if(rand == 1)
	    {
			SetPlayerCheckpoint(playerid, -1426.06, -1462.3, 101.663, 2.0);
			InfoMsg(playerid, "Silahkan ke chekpoint untuk ambil ayam");
		}
		else if(rand == 2)
		{
			SetPlayerCheckpoint(playerid, -1430, -1461.22, 101.684, 2.0);
			InfoMsg(playerid, "Silahkan ke chekpoint untuk ambil ayam");
		}
		else if(rand == 3)
		{
			SetPlayerCheckpoint(playerid, -1433.06, -1458.36, 101.71, 2.0);
			InfoMsg(playerid, "Silahkan ke chekpoint untuk ambil ayam");
		}
		else if(rand == 4)
		{
			SetPlayerCheckpoint(playerid, -1425.98, -1455.66, 101.703, 2.0);
			InfoMsg(playerid, "Silahkan ke chekpoint untuk ambil ayam");
		}
		else if(rand == 5)
		{
			SetPlayerCheckpoint(playerid, -1422.85, -1452.48, 101.725, 2.0);
			InfoMsg(playerid, "Silahkan ke chekpoint untuk ambil ayam");
		}
		else if(rand == 6)
		{
			SetPlayerCheckpoint(playerid, -1420.94, -1455.88, 101.705, 2.0);
			InfoMsg(playerid, "Silahkan ke chekpoint untuk ambil ayam");
		}
	}
	return 1;
}

forward getchicken(playerid);
public getchicken(playerid)
{
    if(IsPlayerConnected(playerid) && pData[playerid][pJob] == 2)
	{
		new rand = RandomEx(1,4);
	    if(rand == 1)
	    {
	        InfoMsg(playerid, "Anda gagal mendapatkan ayam, coba lagi.");
			pData[playerid][pActivityTime] = 0;
			KillTimer(ayamjob[playerid]);
			pData[playerid][pPemotongStatus] = 0;
			pData[playerid][pEnergy] -= 1;
			ClearAnimations(playerid);
		}
		else if(rand == 2)
		{
		    SuccesMsg(playerid, "Anda telah mengambil Ayam Hidup.");
		  	ShowItemBox(playerid, "Ayam", "Received_1x", 16776, 5);
			pData[playerid][pActivityTime] = 0;
			KillTimer(ayamjob[playerid]);
			pData[playerid][pPemotongStatus] = 0;
			pData[playerid][AyamHidup] += 1;
			pData[playerid][AmbilAyam] += 1;
			pData[playerid][pEnergy] -= 1;
			ClearAnimations(playerid);
		}
		else if(rand == 3)
		{
		    SuccesMsg(playerid, "Anda telah mengambil Ayam Hidup.");
		  	ShowItemBox(playerid, "Ayam", "Received_1x", 16776, 5);
			pData[playerid][pActivityTime] = 0;
			KillTimer(ayamjob[playerid]);
			pData[playerid][pPemotongStatus] = 0;
			pData[playerid][AyamHidup] += 1;
			pData[playerid][AmbilAyam] += 1;
			pData[playerid][pEnergy] -= 1;
			ClearAnimations(playerid);
		}
		else if(rand == 4)
		{
		    InfoMsg(playerid, "Anda gagal mendapatkan ayam, coba lagi.");
			pData[playerid][pActivityTime] = 0;
			KillTimer(ayamjob[playerid]);
			pData[playerid][pPemotongStatus] = 0;
			pData[playerid][pEnergy] -= 1;
			ClearAnimations(playerid);
		}
	}
	return 1;
}

CMD:potongayamAufa(playerid, params[])
{
    if(pData[playerid][pJob] == 2 || pData[playerid][pJob2] == 2)
    {
        if(pData[playerid][pPemotongStatus] == 1) return ErrorMsg(playerid, "Anda Masih potong Ayam");
        if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
        if(pData[playerid][AyamHidup] < 1) return ErrorMsg(playerid, "Kamu Tidak Mengambil Ayam Hidup.");
        {
            pData[playerid][pPemotongStatus] += 1;

            TogglePlayerControllable(playerid, 0);
            ShowProgressbar(playerid, "Memotong Ayam", 7);
            ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
            ayamjob[playerid] = SetTimerEx("frychicken", 7000, false, "i", playerid);
        }
    }
    else return ErrorMsg(playerid, "anda bukan Tukang Ayam!");
    return 1;
}

forward frychicken(playerid);
public frychicken(playerid)
{
	SuccesMsg(playerid, "Anda telah berhasil Memotong.");
 	TogglePlayerControllable(playerid, 1);
  	ShowItemBox(playerid, "Chicken", "Removed_1x", 16776, 3);
  	ShowItemBox(playerid, "Ayam_Potong", "Received_5x", 2806, 3);
   	KillTimer(ayamjob[playerid]);
    pData[playerid][pActivityTime] = 0;
    pData[playerid][AyamPotong] += 2;
    pData[playerid][AyamHidup] -= 1;
    pData[playerid][pPemotongStatus] -= 1;
    pData[playerid][pEnergy] -= 2;
    ClearAnimations(playerid);
    return 1;
}

CMD:packingayamAufa(playerid, params[])
{
    if(pData[playerid][pJob] == 2 || pData[playerid][pJob2] == 2)
    {
        if(pData[playerid][pPemotongStatus] == 1) return ErrorMsg(playerid, "Anda masih packing ayam");
        if(pData[playerid][AyamPotong] < 2) return ErrorMsg(playerid, "Anda harus mempunyai 2 ayam Potong");
        if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
        {
            pData[playerid][pPemotongStatus] += 1;

            TogglePlayerControllable(playerid, 0);
            ayamjob[playerid] = SetTimerEx("packingchicken", 5000, false, "i", playerid);
            ShowProgressbar(playerid, "Membungkus Ayam", 5);
            ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
        }
    }
    else return ErrorMsg(playerid, "anda bukan pekerja Pemotong Ayam!");
    return 1;
}
forward packingchicken(playerid);
public packingchicken(playerid)
{
	SuccesMsg(playerid, "Anda telah berhasil membungkus Ayam Potong.");
 	TogglePlayerControllable(playerid, 1);
  	KillTimer(ayamjob[playerid]);
   	pData[playerid][pActivityTime] = 0;
    pData[playerid][AyamFillet] += 1;
    ShowItemBox(playerid, "Ayam_Potong", "Removed_3x", 2806, 3);
    ShowItemBox(playerid, "Paket_Ayam", "Received_1x", 19566, 3);
    pData[playerid][AyamPotong] -= 3;
    pData[playerid][pPemotongStatus] -= 1;
    pData[playerid][pEnergy] -= 2;
    ClearAnimations(playerid);
    return 1;
}

CMD:jualayam(playerid, params[])
{
	if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
	if(pData[playerid][AyamFillet] < 1) return ErrorMsg(playerid, "Anda tidak memiliki 1 paket ayam!");
	new pay = pData[playerid][AyamFillet] * 45;
	new total = pData[playerid][AyamFillet];
	GivePlayerMoneyEx(playerid, pay);
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, total);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Paket_Ayam", str, 19566, total);
	AyamFill += total;
	Server_MinMoney(pay);
	pData[playerid][AyamFillet] = 0;
	ShowProgressbar(playerid, "Menjual Paket Ayam", 5);
	ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

