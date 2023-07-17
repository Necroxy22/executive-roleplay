#define     VAULT_VIRTUALWORLD      (69)
#define     PICKUP_COOLDOWN         (3)
#define     DEPOSIT_MIN             (2500)
#define     DEPOSIT_MAX             (3500)

enum    e_objecttypes
{
	TYPE_LASER1 = 2,
	TYPE_LASER2,
	TYPE_LASER3,
	TYPE_VAULTDOOR = 6
};

enum 	e_labeltypes
{
	Text3D: TYPE_KEYPAD,
	Text3D: TYPE_EXPLOSIVE,
	Text3D: TYPE_TIMELOCK
};

enum    e_bankcontrols
{
	bool: Alarm,
	bool: LasersOn,
	VaultDoorState,
	KeypadHackTime,
	DoorInteractionTime
};

new
	BankEntryPickup = -1, BankExitPickup = -1, VaultEntryPickup = -1, VaultExitPickup = -1,
	AlarmArea = -1,
    VaultObjects[8] = {INVALID_OBJECT_ID, ...},
	Text3D: VaultLabels[e_labeltypes] = {Text3D: INVALID_3DTEXT_ID, ...},
	Text3D: InsideVaultLabels[8] = {Text3D: INVALID_3DTEXT_ID, ...},
	BankControls[e_bankcontrols],
	bool: DepositRobbed[8];
	
new
	RobberyTimer[MAX_PLAYERS] = {-1, ...},
	RobberyCounter[MAX_PLAYERS],
	RobberyType[MAX_PLAYERS],
	RobberyCash[MAX_PLAYERS],
	RobberyEscape[MAX_PLAYERS] = {-1, ...};


// new
// 	Float: DepositCoords[8][3] = {
// 		{2141.9255, 1629.3380, 993.5761},
// 		{2141.9255, 1633.2180, 993.5761},
// 		{2141.9255, 1637.0980, 993.5761},
// 		{2141.9255, 1640.9780, 993.5761},
// 		{2146.5600, 1629.3040, 993.5761},
// 		{2146.5600, 1633.1840, 993.5761},
// 		{2146.5600, 1637.0640, 993.5761},
// 		{2146.5600, 1640.9440, 993.5761}
// 	};

new
	Float: DepositCoords[8][3] = {
		{2940.3118, -1779.8121, 1178.4684},
		{2940.3408, -1776.0277, 1178.4684},
		{2940.2703, -1772.1333, 1178.4684},
		{2940.3281, -1768.2780, 1178.4684},
		{2943.0649, -1768.2814, 1178.4684},
		{2945.0198, -1768.1439, 1178.4684},
		{2944.9690, -1772.1642, 1178.4684},
		{2944.9553, -1776.2678, 1178.4684}
	};	
	
// new
// 	Float: GetawayLocations[][3] = {
//         {405.4649, 2451.4956, 16.5000},
//         {-1647.8981, 2497.6980, 86.2031},
//         {-911.9169, -498.3112, 25.9609}
// 	};

forward RobberyUpdate(playerid);
forward ResetLasers();
forward OpenVaultDoor(type, seconds);
forward ResetVaultDoor();
forward DisableAlarm();

stock ConvertToMinutesRobBank(time)
{
    // http://forum.sa-mp.com/showpost.php?p=3223897&postcount=11
    new string[15];//-2000000000:00 could happen, so make the string 15 chars to avoid any errors
    format(string, sizeof(string), "%02d:%02d", time / 60, time % 60);
    return string;
}

stock ResetRobbery(playerid, destroy = 0)
{
	if(RobberyTimer[playerid] != -1) KillTimer(RobberyTimer[playerid]);
    RobberyTimer[playerid] = -1;
    RobberyCounter[playerid] = 0;
    RobberyType[playerid] = 0;
    if(destroy)
    {
		if(IsValidDynamicCP(RobberyEscape[playerid])) DestroyDynamicCP(RobberyEscape[playerid]);
		RobberyEscape[playerid] = -1;
		RobberyCash[playerid] = 0;
	}
	
	return 1;
}

stock GetClosestDeposit(playerid, Float: range = 2.0)
{
	new id = -1, Float: dist = range, Float: tempdist;
	for(new i; i < sizeof(DepositCoords); ++i)
	{
	    tempdist = GetPlayerDistanceFromPoint(playerid, DepositCoords[i][0], DepositCoords[i][1], DepositCoords[i][2]);
		if(tempdist > range) continue;
		if(tempdist <= dist)
		{
			dist = tempdist;
			id = i;
			break;
		}
	}
	
	return id;
}

stock RandomExRobBank(min, max)
	return random(max - min) + min;

stock TriggerAlarm(reason = 0)
{
	if(BankControls[Alarm]) return 1;
    for(new i; i < GetMaxPlayers(); ++i)
	{
		if(!IsPlayerConnected(i)) continue;
		if(RobberyType[i] == 1)
		{
			ResetRobbery(i);
			ClearAnimations(i, 1);
		}
		
		//if(!GetPVarInt(i, "InsideBank")) continue;
		SetPVarInt(i, "Alarm", 1);
        PlayerPlaySound(i, 3401, 0.0, 0.0, 0.0);
	}
	
	SetTimer("DisableAlarm", 120000, false);
	BankControls[Alarm] = true;
	SendClientMessageToAll(-1, (reason == 1) ? ("{ff0000}BANK: {FFFFFF}Terdengar ledakan di dalam ruang brankas bank, perampokan sedang terjadi!") : ("{ff0000}BANK: {FFFFFF}Perampokan sedang terjadi di dalam bank!"));
	return 1;
}

CreateDynamicObjectBank()
{
	// BankExitPickup = CreatePickup(19197, 1, 2935.1228,-1804.1580,1191.0657);

	// AddPlayerClass(127,2942.8401,-1803.5818,1178.4606,356.5185,0,0,0,0,0,0); // 
	// AddPlayerClass(127,2942.7351,-1800.8103,1178.5803,2.1586,0,0,0,0,0,0); // 

	//AlarmArea = CreateDynamicRectangle(2940.75635, -1802.77637, 1179.29749,1);
	AlarmArea = CreateDynamicRectangle(2942.8401, -1803.5818, 2942.7351,-1800.8103, -1, 1);

// 	// VaultObjects[TYPE_LASER1] = CreateDynamicObject(18643, 2142.983, 1606.679, 993.188, 0.000, 0.000, 0.000, VAULT_VIRTUALWORLD); // laser
// 	// VaultObjects[TYPE_LASER2] = CreateDynamicObject(18643, 2142.983, 1606.679, 993.938, 0.000, 0.000, 0.000, VAULT_VIRTUALWORLD); // laser
// 	// VaultObjects[TYPE_LASER3] = CreateDynamicObject(18643, 2142.983, 1606.679, 994.688, 0.000, 0.000, 0.000, VAULT_VIRTUALWORLD); // laser

	VaultObjects[TYPE_LASER1] = CreateDynamicObject(18643, 2940.75635, -1802.77637, 1179.29749,   0.00000, 0.00000, 0.00000); // laser
	VaultObjects[TYPE_LASER2] = CreateDynamicObject(18643, 2940.58862, -1802.66724, 1178.04236, 0.000, 0.000, 0.000); // laser
	VaultObjects[TYPE_LASER3] = CreateDynamicObject(18643, 2940.58862, -1802.66724, 1178.04236, 0.000, 0.000, 0.000); // laser
	VaultObjects[5] = CreateDynamicObject(19273, 2944.55396, -1803.82056, 1179.12158, 0.000, 0.000, 270.000); // keypad
	VaultObjects[TYPE_VAULTDOOR] = CreateDynamicObject(19799, 2941.73730, -1782.29956, 1179.19226, 0.000, -0.400, -180.000); // vault door
	VaultObjects[7] = CreateDynamicObject(2922, 2940.25171, -1782.50732, 1178.83862,   0.00000, 0.00000, 176.14693); // timelock

	VaultLabels[TYPE_KEYPAD] = CreateDynamic3DTextLabel("{ff0000}[Keypad]\n{FFFF00}\"/rob hack\" {FFFFFF}untuk mematikan laser", 0xF39C12FF, 2944.55396, -1803.82056, 1179.12158, 15.0);
    VaultLabels[TYPE_EXPLOSIVE] = CreateDynamic3DTextLabel("{ff0000}[Vault Door]\n{FFFF00}\"/rob bomb\" {FFFFFF}untuk meledakkan pintu besi (cepat & keras)", 0xF39C12FF, 2941.73730, -1782.29956, 1179.19226, 10.0);
    VaultLabels[TYPE_TIMELOCK] = CreateDynamic3DTextLabel("{ff0000}[Vault Door]\n{FFFF00}\"/rob time\" {FFFFFF}untuk membuka pintu besi secara manual (lambat & senyap)", 0xF39C12FF, 2940.25171, -1782.50732, 1178.83862, 10.0);

	for(new i; i < sizeof(InsideVaultLabels); ++i)
	{
		InsideVaultLabels[i] = CreateDynamic3DTextLabel("{ff0000}[Deposit Boxes]\n{FFFF00}\"/rob empty\"{FFFFFF}", 0x2ECC71FF, DepositCoords[i][0], DepositCoords[i][1], DepositCoords[i][2], 15.0);
	}

	BankControls[LasersOn] = true;	

	return 1;
}

// LoadDynamicRobBank()
// {
// 	BankEntryPickup = CreatePickup(19197, 1, 2303.1777, -16.1625, 27.0);
// 	BankExitPickup = CreatePickup(19197, 1, 2305.5591, -16.1253, 27.0, -1);
// 	VaultEntryPickup = CreatePickup(19197, 1, 2315.5637, -0.1449, 27.0, -1);
// 	VaultExitPickup = CreatePickup(19197, 1, 2144.2788, 1602.5975, 998.0, VAULT_VIRTUALWORLD);
	
// 	AlarmArea = CreateDynamicRectangle(2130.6169, 1607.9010, 2156.9197,1625.2343, VAULT_VIRTUALWORLD, 1);
	
// 	// VaultObjects[0] = CreateDynamicObject(19446, 2144.333, 1601.475, 1001.387, 90.000, 90.199, 0.000, VAULT_VIRTUALWORLD); // wall
// 	// VaultObjects[1] = CreateDynamicObject(2947, 2145.037, 1601.421, 996.776, 0.000, 0.000, -89.500, VAULT_VIRTUALWORLD); // door
// 	// VaultObjects[TYPE_LASER1] = CreateDynamicObject(18643, 2142.983, 1606.679, 993.188, 0.000, 0.000, 0.000, VAULT_VIRTUALWORLD); // laser
// 	// VaultObjects[TYPE_LASER2] = CreateDynamicObject(18643, 2142.983, 1606.679, 993.938, 0.000, 0.000, 0.000, VAULT_VIRTUALWORLD); // laser
// 	// VaultObjects[TYPE_LASER3] = CreateDynamicObject(18643, 2142.983, 1606.679, 994.688, 0.000, 0.000, 0.000, VAULT_VIRTUALWORLD); // laser
// 	// VaultObjects[5] = CreateDynamicObject(19273, 2146.116, 1604.895, 994.118, 0.000, 0.000, 270.000, VAULT_VIRTUALWORLD); // keypad
// 	// VaultObjects[TYPE_VAULTDOOR] = CreateDynamicObject(19799, 2143.185, 1626.965, 994.298, 0.000, -0.400, -180.000, VAULT_VIRTUALWORLD); // vault door
// 	// VaultObjects[7] = CreateDynamicObject(2922, 2140.361, 1626.826, 993.978, 0.000, 0.000, 180.000, VAULT_VIRTUALWORLD); // timelock

//     VaultObjects[TYPE_LASER1] = CreateDynamicObject(18643, 2940.75635, -1802.77637, 1179.29749,   0.00000, 0.00000, 0.00000); // laser
// 	VaultObjects[TYPE_LASER2] = CreateDynamicObject(18643, 2940.58862, -1802.66724, 1178.04236, 0.000, 0.000, 0.000); // laser
// 	VaultObjects[TYPE_LASER3] = CreateDynamicObject(18643, 2940.58862, -1802.66724, 1178.04236, 0.000, 0.000, 0.000); // laser
// 	VaultObjects[5] = CreateDynamicObject(19273, 2944.55396, -1803.82056, 1179.12158, 0.000, 0.000, 270.000); // keypad
// 	VaultObjects[TYPE_VAULTDOOR] = CreateDynamicObject(19799, 2941.73730, -1782.29956, 1179.19226, 0.000, -0.400, -180.000); // vault door
// 	VaultObjects[7] = CreateDynamicObject(2922, 2940.25171, -1782.50732, 1178.83862,   0.00000, 0.00000, 176.14693); // timelock

// 	// VaultLabels[TYPE_KEYPAD] = CreateDynamic3DTextLabel("Keypad\n{FFFFFF}/starthack to disable lasers", 0xF39C12FF, 2145.85, 1604.9456, 993.5684, 15.0, .testlos = 1, .worldid = VAULT_VIRTUALWORLD);
//  //    VaultLabels[TYPE_EXPLOSIVE] = CreateDynamic3DTextLabel("Vault Door - Option 1\n{FFFFFF}/plantbomb to blow up vault door (fast & loud)", 0xF39C12FF, 2144.1624, 1626.25, 993.6882, 10.0, .testlos = 1, .worldid = VAULT_VIRTUALWORLD);
//  //    VaultLabels[TYPE_TIMELOCK] = CreateDynamic3DTextLabel("Vault Door - Option 2\n{FFFFFF}/timelock to start time lock (slow & silent)", 0xF39C12FF, 2140.2610, 1626.25, 993.6882, 10.0, .testlos = 1, .worldid = VAULT_VIRTUALWORLD);

// /*
// 	VaultLabels[TYPE_KEYPAD] = CreateDynamic3DTextLabel("Keypad\n{FFFFFF}/starthack Buat Nge nonaktifin Laser", 0xF39C12FF, 2944.55396, -1803.82056, 1179.12158, 15.0);
//     VaultLabels[TYPE_EXPLOSIVE] = CreateDynamic3DTextLabel("Pintu Brankas - Pilihan 1\n{FFFFFF}/pasangbomb Buat ngeledakin pintu (cepet tapi beresiko)", 0xF39C12FF, 2941.73730, -1782.29956, 1179.19226, 10.0);
//     VaultLabels[TYPE_TIMELOCK] = CreateDynamic3DTextLabel("Pintu Brankas - Pilihan 2\n{FFFFFF}/timelock Untuk mengakses atau nge hack kode (Lambat tapi aman)", 0xF39C12FF, 2940.25171, -1782.50732, 1178.83862, 10.0);

// */
// 	// VaultLabels[TYPE_KEYPAD] = CreateDynamic3DTextLabel("Keypad\n{FFFFFF}/starthack unutk mematikan laser", 0xF39C12FF, 2944.55396, -1803.82056, 1179.12158, 15.0, .testlos = 1, .worldid = VAULT_VIRTUALWORLD);  // Yang baru: 2944.55396, -1803.82056, 1179.12158, 15.0 || Yang lama: 
//  //    VaultLabels[TYPE_EXPLOSIVE] = CreateDynamic3DTextLabel("Vault Door - Option 1\n{FFFFFF}/plantbomb untuk meledakkan pintu besi (cepat & keras)", 0xF39C12FF, 2144.1624, 1626.25, 993.6882, 10.0, .testlos = 1, .worldid = VAULT_VIRTUALWORLD);
//  //    VaultLabels[TYPE_TIMELOCK] = CreateDynamic3DTextLabel("Vault Door - Option 2\n{FFFFFF}/timelock untuk membuka pintu besi secara manual (lambat & senyap)", 0xF39C12FF, 2140.2610, 1626.25, 993.6882, 10.0, .testlos = 1, .worldid = VAULT_VIRTUALWORLD);

// 	VaultLabels[TYPE_KEYPAD] = CreateDynamic3DTextLabel("Keypad\n{FFFF00}/rob hack {FFFFFF}untuk mematikan laser", 0xF39C12FF, 2944.55396, -1803.82056, 1179.12158, 5.0, .testlos = 1, .worldid = VAULT_VIRTUALWORLD);  // Yang baru: 2944.55396, -1803.82056, 1179.12158, 15.0 || Yang lama: 
//     VaultLabels[TYPE_EXPLOSIVE] = CreateDynamic3DTextLabel("Vault Door - Option 1\n{FFFF00}/rob bomb {FFFFFF}untuk meledakkan pintu besi (cepat & keras)", 0xF39C12FF, 2941.73730, -1782.29956, 1179.19226, 5.0, .testlos = 1, .worldid = VAULT_VIRTUALWORLD);
//     VaultLabels[TYPE_TIMELOCK] = CreateDynamic3DTextLabel("Vault Door - Option 2\n{FFFF00}/rob time {FFFFFF}untuk membuka pintu besi secara manual (lambat & senyap)", 0xF39C12FF, 2940.25171, -1782.50732, 1178.83862, 5.0, .testlos = 1, .worldid = VAULT_VIRTUALWORLD);

// 	for(new i; i < sizeof(InsideVaultLabels); ++i)
// 	{
// 		InsideVaultLabels[i] = CreateDynamic3DTextLabel("Deposit Boxes\n{FFFF00}/rob empty{FFFFFF}", 0x2ECC71FF, DepositCoords[i][0], DepositCoords[i][1], DepositCoords[i][2], 15.0, .testlos = 1, .worldid = VAULT_VIRTUALWORLD);
// 	}

// 	BankControls[LasersOn] = true;
// 	return 1;
// }

DestroyDynaimcRobBank()
{
	DestroyPickup(BankEntryPickup);
	DestroyPickup(BankExitPickup);
	DestroyPickup(VaultEntryPickup);
    DestroyPickup(VaultExitPickup);

	for(new i; i < GetMaxPlayers(); ++i)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if(GetPVarInt(i, "Alarm"))
	    {
	  		SetPVarInt(i, "Alarm", 0);
	        PlayerPlaySound(i, 3402, 0.0, 0.0, 0.0);
		}
		
	    ClearAnimations(i, 1);
		ResetRobbery(i, 1);
 	}
 	
	return 1;
}

public RobberyUpdate(playerid)
{
	if(RobberyCounter[playerid] > 1) {
	    RobberyCounter[playerid]--;

     	new string[32];
		switch(RobberyType[playerid])
		{
			case 1: format(string, sizeof(string), "~w~Hacking: %s%d", (RobberyCounter[playerid] <= 5) ? ("~r~~h~") : ("~y~"), RobberyCounter[playerid]);
			case 2: format(string, sizeof(string), "~w~Emptying: %s%d", (RobberyCounter[playerid] <= 3) ? ("~r~~h~") : ("~y~"), RobberyCounter[playerid]);
		}

		GameTextForPlayer(playerid, string, 1000, 4);
	}else if(RobberyCounter[playerid] == 1) {
        switch(RobberyType[playerid])
		{
			case 1:
			{
				BankControls[LasersOn] = false;
				SetDynamicObjectPos(VaultObjects[TYPE_LASER1], 2142.983, 1606.679, 990.0);
				SetDynamicObjectPos(VaultObjects[TYPE_LASER2], 2142.983, 1606.679, 990.0);
				SetDynamicObjectPos(VaultObjects[TYPE_LASER3], 2142.983, 1606.679, 990.0);
				SetTimer("ResetLasers", 240000, false);
				Info(playerid, "Anda telah menonaktifkan laser. Sekarang Anda dapat pergi ke pintu lemari besi tanpa membunyikan alarm.");
				Info(playerid, "Laser akan menyala kembali dalam 4 menit.");
			}

			case 2:
			{
			    new cash = RandomExRobBank(DEPOSIT_MIN, DEPOSIT_MAX);
			    if(BankControls[VaultDoorState] == 2) cash -= floatround(cash * 0.1, floatround_floor); // explosion damaged deposit boxes, 10% damage penalty
				pData[playerid][pRedMoney] += cash;
				//format(string, sizeof(string), "You've emptied a set of deposit boxes and stole {2ECC71}$%d {FFFFFF}worth of stuff.", cash);
				Info(playerid, "Anda telah mengosongkan satu set kotak penyimpanan dan mencuri {2ECC71}$%d {FFFFFF}Uang merah.", cash);

				new msg[256];
				format(msg, sizeof msg, "`[BANK]: %s(%d) memulai '/emptydeposit', Dan mendapatkan uang merah sebanyak %s jumlah uang merah dia %s` @everyone", pData[playerid][pName], playerid, FormatMoney(cash), FormatMoney(pData[playerid][pRedMoney]));
				//_SendChannelMessage(chLogsRobbank, msg);
			}
		}

		ClearAnimations(playerid, 1);
		ResetRobbery(playerid);
	}

	return 1;
}

public ResetLasers()
{
    BankControls[LasersOn] = true;
    SetDynamicObjectPos(VaultObjects[TYPE_LASER1], 2142.983, 1606.679, 993.188);
	SetDynamicObjectPos(VaultObjects[TYPE_LASER2], 2142.983, 1606.679, 993.938);
	SetDynamicObjectPos(VaultObjects[TYPE_LASER3], 2142.983, 1606.679, 994.688);

	if(IsAnyPlayerInDynamicArea(AlarmArea, 1)) TriggerAlarm();
	return 1;
}


public OpenVaultDoor(type, seconds)
{
	if(seconds > 1) 
	{
	    seconds--;

	    new string[128];
        switch(type)
		{
			case 2: format(string, sizeof(string), "{ff0000}[Vault Door]\n{FFFF00}\"/rob bomb\" {FFFFFF}untuk meledakkan pintu besi (cepat & keras)\n{2ECC71}%s", ConvertToMinutesRobBank(seconds));
			case 3: format(string, sizeof(string), "{ff0000}[Vault Door]\n{FFFF00}\"/rob time\" {FFFFFF}untuk membuka pintu besi secara manual (lambat & senyap)\n{2ECC71}%s", ConvertToMinutesRobBank(seconds));
		}

		UpdateDynamic3DTextLabelText((type == 2) ? VaultLabels[TYPE_EXPLOSIVE] : VaultLabels[TYPE_TIMELOCK], 0xF39C12FF, string);
        SetTimerEx("OpenVaultDoor", 1000, false, "ii", type, seconds);
	}
	else if(seconds == 1) 
	{
        BankControls[VaultDoorState] = type;
		SetTimer("ResetVaultDoor", 120000, false);

		switch(type)
		{
			case 2:
			{
			    // explosive
			    CreateExplosion(2144.1624, 1626.25, 993.6882, 11, 5.0);
				SetDynamicObjectPos(VaultObjects[TYPE_VAULTDOOR], 2143.185, 1626.965, 985.298);
                UpdateDynamic3DTextLabelText(VaultLabels[TYPE_EXPLOSIVE], 0xF39C12FF, "{ff0000}[Vault Door]\n{FFFF00}\"/rob bomb\" {FFFFFF}untuk meledakkan pintu besi (cepat & keras)");
				TriggerAlarm(1);
			}

			case 3:
			{
			    // timelock
				MoveDynamicObject(VaultObjects[TYPE_VAULTDOOR], 2143.185, 1626.965, 994.35, 0.01, 0.000, -0.400, -270.0);
                UpdateDynamic3DTextLabelText(VaultLabels[TYPE_TIMELOCK], 0xF39C12FF, "{ff0000}[Vault Door]\n{FFFF00}\"/rob time\" {FFFFFF}untuk membuka pintu besi secara manual (lambat & senyap)");
			}
		}
	}

	return 1;
}

public ResetVaultDoor()
{
	switch(BankControls[VaultDoorState])
	{
		case 2: SetDynamicObjectPos(VaultObjects[TYPE_VAULTDOOR], 2143.185, 1626.965, 994.298);
		case 3: MoveDynamicObject(VaultObjects[TYPE_VAULTDOOR], 2143.185, 1626.965, 994.298, 0.01, 0.000, -0.400, -180.0);
	}

	for(new i; i < sizeof(DepositCoords); ++i)
	{
		DepositRobbed[i] = false;
		Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, InsideVaultLabels[i], E_STREAMER_COLOR, 0x2ECC71FF);
	}
	
	BankControls[VaultDoorState] = 0; // closed
	return 1;
}

public DisableAlarm()
{
	BankControls[Alarm] = false;
	for(new i; i < GetMaxPlayers(); ++i)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!GetPVarInt(i, "Alarm")) continue;
  		SetPVarInt(i, "Alarm", 0);
        PlayerPlaySound(i, 3402, 0.0, 0.0, 0.0);
	}
	return 1;
}

// CMD:starthack(playerid, params[])
// {
// 	new countPD = 0, coundMD = 0;
// 	new hour;
// 	gettime(hour);
// 	foreach(new i: Player)
// 	{
// 		if(pData[i][pFaction] == 1)
// 		{
// 			countPD++;
// 		}
// 		if(pData[i][pFaction] == 3)
// 		{
// 			coundMD++;
// 		}
// 	}

// 	if(countPD < 6 || coundMD < 3 || 19 <= hour <= 4)
// 	{
// 		pData[playerid][pJail] = 1;
// 		pData[playerid][pJailTime] = 120 * 60;
// 		JailPlayer(playerid);
// 		SendClientMessageToAllEx(-1, "{ff0000}[BANK]: {FFFFFF}Berhasil menangkap orang {ffff00}%s(%d){FFFFFF} karena melanggar uu kota merpati", pData[playerid][pName], playerid);

// 		new msgBank[256];
// 		format(msgBank, sizeof msgBank, "`[BANK]: %s(%d) Telah di tangkap karena melanggar peraturan Merpati`", pData[playerid][pName], playerid);
// 		DCC_SendChannelMessage(chLogsRobbank, msgBank);
// 		return 1;
// 	}

// 	if(pData[playerid][pCs] == 0) return Error(playerid, "Anda tidak memiliki Story Character");
// 	if(pData[playerid][pLevel] < 5) return Error(playerid, "Kamu belum mecapai level 5.");
// 	if(!IsPlayerInRangeOfPoint(playerid, 1.5, 2145.85, 1604.9456, 993.5684)) return Error(playerid, "Anda tidak berada di dekat keypad.");
// 	if(BankControls[Alarm]) return Error(playerid, "Alarm telah berbunyi, Anda tidak dapat meretas keypad.");
// 	if(!BankControls[LasersOn]) return Error(playerid, "Keypad telah diretas.");
// 	if(BankControls[KeypadHackTime] > gettime())
// 	{
// 	 	Error(playerid, "Kamu harus menunggu %s untuk meretas keypad lagi.", ConvertToMinutesRobBank(BankControls[KeypadHackTime] - gettime()));
// 		return 1;
// 	}
	
// 	new msg[256];
// 	format(msg, sizeof msg, "`[BANK]: %s(%d) memulai '/starthack'` @everyone", pData[playerid][pName], playerid);
// 	DCC_SendChannelMessage(chLogsRobbank, msg);

// 	ApplyAnimation(playerid, "COP_AMBIENT", "COPBROWSE_LOOP", 4.1, 1, 0, 0, 0, 0, 1);
// 	BankControls[KeypadHackTime] = gettime() + 600;
// 	RobberyType[playerid] = 1;
// 	RobberyCounter[playerid] = 20;
// 	RobberyTimer[playerid] = SetTimerEx("RobberyUpdate", 1000, true, "i", playerid);
// 	return 1;
// }

// CMD:plantbomb(playerid, params[])
// {
// 	new countPD = 0, coundMD = 0;
// 	new hour;
// 	gettime(hour);
// 	foreach(new i: Player)
// 	{
// 		if(pData[i][pFaction] == 1)
// 		{
// 			countPD++;
// 		}
// 		if(pData[i][pFaction] == 3)
// 		{
// 			coundMD++;
// 		}
// 	}

// 	if(countPD < 6 || coundMD < 3 || 19 <= hour <= 4)
// 	{
// 		pData[playerid][pJail] = 1;
// 		pData[playerid][pJailTime] = 120 * 60;
// 		JailPlayer(playerid);
// 		SendClientMessageToAllEx(-1, "{ff0000}[BANK]: {FFFFFF}Berhasil menangkap player {00ff00}%s(%d){FFFFFF} karena melanggar uu kota merpati", pData[playerid][pName], playerid);

// 		new msgBank[256];
// 		format(msgBank, sizeof msgBank, "`[BANK]: %s(%d) Telah di tangkap karena melanggar peraturan Merpati", pData[playerid][pName], playerid);
// 		DCC_SendChannelMessage(chLogsRobbank, msgBank);
// 		return 1;
// 	}

// 	if(pData[playerid][pCs] == 0) return Error(playerid, "Anda tidak memiliki Story Character");
// 	if(pData[playerid][pLevel] < 5) return Error(playerid, "Anda belum mecapai level 5.");
//     if(!IsPlayerInRangeOfPoint(playerid, 1.5, 2144.1624, 1626.25, 993.6882)) return Error(playerid, "Anda tidak berada di dekat pintu brankas.");
// 	if(BankControls[VaultDoorState] != 0) return Error(playerid, "Pintu lemari besi sudah terbuka/sedang di buka.");
// 	if(BankControls[DoorInteractionTime] > gettime())
// 	{
// 	 	Error(playerid, "Kamu harus menunggu %s untuk membuka pintu lemari besi lagi.", ConvertToMinutesRobBank(BankControls[DoorInteractionTime] - gettime()));
// 		return 1;
// 	}
	
// 	new msg[256];
// 	format(msg, sizeof msg, "`[BANK]: %s(%d) memulai '/plantbomb'` @everyone", pData[playerid][pName], playerid);
// 	DCC_SendChannelMessage(chLogsRobbank, msg);

// 	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 0, 0, 1);
// 	BankControls[DoorInteractionTime] = gettime() + 600;
// 	BankControls[VaultDoorState] = 1; // opening
// 	SetTimerEx("OpenVaultDoor", 1000, false, "ii", 2, 6);
// 	SendClientMessage(playerid, -1, "Bom telah ditanam dan akan meledak dalam 6 detik. Berlindung!");
// 	return 1;
// }

// CMD:timelock(playerid, params[])
// {
// 	new countPD = 0, coundMD = 0;
// 	new hour;
// 	gettime(hour);
// 	foreach(new i: Player)
// 	{
// 		if(pData[i][pFaction] == 1)
// 		{
// 			countPD++;
// 		}
// 		if(pData[i][pFaction] == 3)
// 		{
// 			coundMD++;
// 		}
// 	}

// 	if(countPD < 6 || coundMD < 3 || 19 <= hour <= 4)
// 	{
// 		pData[playerid][pJail] = 1;
// 		pData[playerid][pJailTime] = 120 * 60;
// 		JailPlayer(playerid);
// 		SendClientMessageToAllEx(-1, "{ff0000}[BANK]: {FFFFFF}Berhasil menangkap player {00ff00}%s(%d){FFFFFF} karena melanggar uu kota merpati", pData[playerid][pName], playerid);

// 		new msgBank[256];
// 		format(msgBank, sizeof msgBank, "`[BANK]: %s(%d) Telah di tangkap karena melanggar peraturan Merpati", pData[playerid][pName], playerid);
// 		DCC_SendChannelMessage(chLogsRobbank, msgBank);
// 		return 1;
// 	}

// 	if(pData[playerid][pCs] == 0) return Error(playerid, "Anda tidak memiliki Story Character");
// 	if(pData[playerid][pLevel] < 10) return Error(playerid, "Kamu belum mecapai level 10.");
//     if(!IsPlayerInRangeOfPoint(playerid, 1.5, 2140.2610, 1626.25, 993.6882)) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not near the time lock.");
// 	if(BankControls[Alarm]) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Time lock disabled because of alarm.");
// 	if(BankControls[VaultDoorState] != 0) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}Vault door is already open/opening.");
// 	if(BankControls[DoorInteractionTime] > gettime())
// 	{
// 	    new string[72];
// 		format(string, sizeof(string), "ERROR: {FFFFFF}You have to wait %s to open the vault door again.", ConvertToMinutesRobBank(BankControls[DoorInteractionTime] - gettime()));
// 	 	SendClientMessage(playerid, 0xE74C3CFF, string);
// 		return 1;
// 	}

// 	new msg[256];
// 	format(msg, sizeof msg, "`[BANK]: %s(%d) memulai '/timelock'` @everyone", pData[playerid][pName], playerid);
// 	DCC_SendChannelMessage(chLogsRobbank, msg);

// 	BankControls[DoorInteractionTime] = gettime() + 600;
// 	BankControls[VaultDoorState] = 1; // opening
// 	SetTimerEx("OpenVaultDoor", 1000, false, "ii", 3, 30);
// 	SendClientMessage(playerid, -1, "You've started the time lock, vault door will open in 30 seconds.");
// 	return 1;
// }

// CMD:emptydeposit(playerid, params[])
// {
// 	new countPD = 0, coundMD = 0;
// 	new hour;
// 	gettime(hour);
// 	foreach(new i: Player)
// 	{
// 		if(pData[i][pFaction] == 1)
// 		{
// 			countPD++;
// 		}
// 		if(pData[i][pFaction] == 3)
// 		{
// 			coundMD++;
// 		}
// 	}

// 	if(countPD < 6 || coundMD < 3 || 19 <= hour <= 4)
// 	{
// 		pData[playerid][pJail] = 1;
// 		pData[playerid][pJailTime] = 120 * 60;
// 		JailPlayer(playerid);
// 		SendClientMessageToAllEx(-1, "{ff0000}[BANK]: {FFFFFF}Berhasil menangkap player {00ff00}%s(%d){FFFFFF} karena melanggar uu kota merpati", pData[playerid][pName], playerid);

// 		new msgBank[256];
// 		format(msgBank, sizeof msgBank, "`[BANK]: %s(%d) Telah di tangkap karena melanggar peraturan Merpati", pData[playerid][pName], playerid);
// 		DCC_SendChannelMessage(chLogsRobbank, msgBank);
// 		return 1;
// 	}

// 	if(pData[playerid][pCs] == 0) return Error(playerid, "Anda tidak memiliki Story Character");
// 	if(pData[playerid][pLevel] < 5) return Error(playerid, "Kamu belum mecapai level 5.");
//     if(BankControls[VaultDoorState] < 2) return Error(playerid, "Anda tidak dapat mengosongkan kotak penyimpanan saat pintu lemari besi tidak terbuka.");
// 	new id = GetClosestDeposit(playerid);
// 	if(id == -1) return Error(playerid, "Anda tidak berada di dekat kotak penyimpanan mana pun.");
// 	if(DepositRobbed[id]) return Error(playerid, "Kotak penyimpanan yang Anda coba rampok sudah dirampok.");
// 	DepositRobbed[id] = true;
// 	Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, InsideVaultLabels[id], E_STREAMER_COLOR, 0xE74C3CFF);
// 	ApplyAnimation(playerid, "ROB_BANK", "CAT_Safe_Rob", 4.0, 1, 0, 0, 0, 0, 1);
// 	SetPlayerAttachedObject(playerid, 6, 1550, 3, 0.1, 0.1, -0.1, 0.0, 270.0, 0.0, 1, 1, 1, 0xFF00FF00);
// 	RobberyType[playerid] = 2; 
// 	RobberyCounter[playerid] = 10;
// 	RobberyTimer[playerid] = SetTimerEx("RobberyUpdate", 1000, true, "i", playerid);
// 	return 1;
// }

CMD:rob(playerid, params[])
{
	if(isnull(params))
	{
		Usage(playerid, "/rob [Name]");
		Info(playerid, "Bank: (hack, time, bomb, empty)");
		return 1;
	} 
	if(pData[playerid][pCs] == 0) return Error(playerid, "Anda tidak memiliki Story Character.");
	if(pData[playerid][pLevel] < 5) return Error(playerid, "Anda belum mecapai level 5.");	

	new countPD = 0, coundMD = 0;
	new hour;
	gettime(hour);
	foreach(new i: Player)
	{
		if(pData[i][pFaction] == 1)
		{
			countPD++;
		}
		if(pData[i][pFaction] == 3)
		{
			coundMD++;
		}
	}

	if(!strcmp(params, "hack", true))
	{
		if(pData[playerid][pPanelHacking] == 0) return Error(playerid, "Anda tidak memiliki panel hacking");
		// Yang baru: 2944.55396, -1803.82056, 1179.12158 || Yang lama: 2144.1624, 1626.25, 993.6882
	    if(!IsPlayerInRangeOfPoint(playerid, 1.5, 2944.55396, -1803.82056, 1179.12158)) return Error(playerid, "Anda tidak berada di dekat pintu brankas.");
		if(BankControls[VaultDoorState] != 0) return Error(playerid, "Pintu lemari besi sudah terbuka/sedang di buka.");
		if(BankControls[DoorInteractionTime] > gettime())
		{
		 	Error(playerid, "Kamu harus menunggu %s untuk membuka pintu lemari besi lagi.", ConvertToMinutesRobBank(BankControls[DoorInteractionTime] - gettime()));
			return 1;
		}

		if(countPD < 6) return Info(playerid, "Tidak dapat merampok bank saat ini dikarenakan anggota polisi sedikit (%d/6)", countPD);
		if(countPD < 3) return Info(playerid, "Tidak dapat merampok bank saat ini dikarenakan anggota dokter sedikit (%d/3)", coundMD);
		if(19 <= hour <= 4) return Info(playerid, "Tidak dapat merampok bank saat ini dikarenakan waktu yang tidak tepat");

		new msg[256];
		format(msg, sizeof msg, "```\n[BANK]: %s(%d) memulai mematikan panel laser\n``` @everyone", pData[playerid][pName], playerid);
		//DCC_SendChannelMessage(chLogsRobbank, msg);

		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 0, 0, 1);
		BankControls[DoorInteractionTime] = gettime() + 600;
		BankControls[VaultDoorState] = 1; // opening
		SetTimerEx("OpenVaultDoor", 1000, false, "ii", 2, 6);
		SendClientMessage(playerid, -1, "Bom telah ditanam dan akan meledak dalam 6 detik. Berlindung!");
	
	}
	else if(!strcmp(params, "bomb", true))
	{
		if(pData[playerid][pBomb] < 1) return Error(playerid, "Anda tidak memiliki sebuah bomb");
		// Yang baru: 2941.73730, -1782.29956, 1179.19226 || Yang lama: 2144.1624, 1626.25, 993.6882
	    if(!IsPlayerInRangeOfPoint(playerid, 1.5, 2941.73730, -1782.29956, 1179.19226)) return Error(playerid, "Anda tidak berada di dekat pintu brankas.");
		if(BankControls[VaultDoorState] != 0) return Error(playerid, "Pintu lemari besi sudah terbuka/sedang di buka.");
		if(BankControls[DoorInteractionTime] > gettime())
		{
		 	Error(playerid, "Kamu harus menunggu %s untuk membuka pintu lemari besi lagi.", ConvertToMinutesRobBank(BankControls[DoorInteractionTime] - gettime()));
			return 1;
		}
		
		if(countPD < 6) return Info(playerid, "Tidak dapat merampok bank saat ini dikarenakan anggota polisi sedikit (%d/6)", countPD);
		if(countPD < 3) return Info(playerid, "Tidak dapat merampok bank saat ini dikarenakan anggota dokter sedikit (%d/3)", coundMD);
		if(19 <= hour <= 4) return Info(playerid, "Tidak dapat merampok bank saat ini dikarenakan waktu yang tidak tepat");

		new msg[256];
		format(msg, sizeof msg, "```\n[BANK]: %s(%d) memulai memasang bomb waktu\n``` @everyone", pData[playerid][pName], playerid);
		//DCC_SendChannelMessage(chLogsRobbank, msg);

		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 0, 0, 1);
		pData[playerid][pBomb] -= 1;
		BankControls[DoorInteractionTime] = gettime() + 600;
		BankControls[VaultDoorState] = 1; // opening
		SetTimerEx("OpenVaultDoor", 1000, false, "ii", 2, 6);
		Info(playerid, "Bom telah ditanam dan akan meledak dalam 6 detik. Berlindunglah!");
	}
	else if(!strcmp(params, "time", true))
	{
		if(pData[playerid][pPanelHacking] == 0) return Error(playerid, "Anda tidak memiliki panel hacking");
		// Yang Baru: 2940.25171, -1782.50732, 1178.83862 || Yang Lama: 2140.2610, 1626.25, 993.6882
	    if(!IsPlayerInRangeOfPoint(playerid, 1.5, 2940.25171, -1782.50732, 1178.83862)) return Error(playerid, "Anda tidak dekat dengan brankas.");
		if(BankControls[Alarm]) return Error(playerid, "kunci waktu dinonaktifkan karena alarm.");
		if(BankControls[VaultDoorState] != 0) return Error(playerid, "Pintu lemari besi sudah terbuka/terbuka.");
		if(BankControls[DoorInteractionTime] > gettime())
		{
		 	Error(playerid, "You have to wait %s to open the vault door again.", ConvertToMinutesRobBank(BankControls[DoorInteractionTime] - gettime()));
			return 1;
		}

		if(countPD < 6) return Info(playerid, "Tidak dapat merampok bank saat ini dikarenakan anggota polisi sedikit (%d/6)", countPD);
		if(countPD < 3) return Info(playerid, "Tidak dapat merampok bank saat ini dikarenakan anggota dokter sedikit (%d/3)", coundMD);
		if(19 <= hour <= 4) return Info(playerid, "Tidak dapat merampok bank saat ini dikarenakan waktu yang tidak tepat");

		new msg[256];
		format(msg, sizeof msg, "```\n[BANK]: %s(%d) memulai merusak panel pin brankas\n``` @everyone", pData[playerid][pName], playerid);
		//DCC_SendChannelMessage(chLogsRobbank, msg);

		BankControls[DoorInteractionTime] = gettime() + 600;
		BankControls[VaultDoorState] = 1; // opening
		SetTimerEx("OpenVaultDoor", 1000, false, "ii", 3, 30);
		Info(playerid, "Anda telah memulai mengbongkar kunci, pintu lemari besi akan terbuka dalam 30 detik.");
	
	}	
	else if(!strcmp(params, "empty", true))
	{
	    if(BankControls[VaultDoorState] < 2) return Error(playerid, "Anda tidak dapat mengosongkan kotak penyimpanan saat pintu lemari besi tidak terbuka.");
		new id = GetClosestDeposit(playerid);
		if(id == -1) return Error(playerid, "Anda tidak berada di dekat kotak penyimpanan mana pun.");
		if(DepositRobbed[id]) return Error(playerid, "Kotak penyimpanan yang Anda coba rampok sudah dirampok.");

		if(countPD < 6) return Info(playerid, "Tidak dapat merampok bank saat ini dikarenakan anggota polisi sedikit (%d/6)", countPD);
		if(countPD < 3) return Info(playerid, "Tidak dapat merampok bank saat ini dikarenakan anggota dokter sedikit (%d/3)", coundMD);
		if(19 <= hour <= 4) return Info(playerid, "Tidak dapat merampok bank saat ini dikarenakan waktu yang tidak tepat");

		DepositRobbed[id] = true;
		Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, InsideVaultLabels[id], E_STREAMER_COLOR, 0xE74C3CFF);
		ApplyAnimation(playerid, "ROB_BANK", "CAT_Safe_Rob", 4.0, 1, 0, 0, 0, 0, 1);
		SetPlayerAttachedObject(playerid, 6, 1550, 3, 0.1, 0.1, -0.1, 0.0, 270.0, 0.0, 1, 1, 1, 0xFF00FF00);
		RobberyType[playerid] = 2; 
		RobberyCounter[playerid] = 10;
		RobberyTimer[playerid] = SetTimerEx("RobberyUpdate", 1000, true, "i", playerid);
	
	}	
	else
	{
		Usage(playerid, "/rob [Name]");
		Info(playerid, "Name: hack, time, bomb, empty");
	}
	return 1;
}