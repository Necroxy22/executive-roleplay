//----------[ Function Login Register]----------
function OnPlayerDataLoaded(playerid, race_check)
{
    SetPlayerCameraPos(playerid,698.826049, -1404.027099, 41);
	SetPlayerCameraLookAt(playerid,703.825317, -1404.041990, 39.802570);
	InterpolateCameraPos(playerid, 698.826049, -1404.027099, 16.206615, 2045.292480, -1425.237182, 128.337753, 60000);
	InterpolateCameraLookAt(playerid, 703.825317, -1404.041990, 500000681, 2050.291992, -1425.306762, 128.361190, 50000);
	if (race_check != g_MysqlRaceCheck[playerid]) return Kick(playerid);

	cache_get_value_name(0, "password", pData[playerid][pPassword], 65);
	cache_get_value_name(0, "salt", pData[playerid][pSalt], 17);
	cache_get_value_name_int(0, "verifycode", pData[playerid][pVerifyCode]);

	new query[248], PlayerIP[16];
	if(cache_num_rows() > 0)
	{
		if(pData[playerid][pPassword] < 1)
		{
			new str[400];
			format(str, sizeof(str), "UCP: {15D4ED}%s\n{ffffff}Silahkan masukkan PIN yang sudah di kirimkan oleh ExecutiveBot", pData[playerid][pUCP]);
			ShowPlayerDialog(playerid, DIALOG_VERIFYCODE, DIALOG_STYLE_INPUT, "{BABABA}Executive - {ffffff}Verify Account", str, "Input", "Batal");
		}
		if(pData[playerid][pPassword] > 10)
		{
			new lstring[512];
			format(lstring, sizeof lstring, "Selamat datang kembali di server Executive Roleplay\n\nUsername: %s\nVersion: "TEXT_GAMEMODE"\n{FFFF00}(Silahkan Masukkan Kata Sandi Anda Di Bawah Ini:)", pData[playerid][pUCP]);
			ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login - Executive", lstring, "Masuk", "Keluar");
		}
		pData[playerid][LoginTimer] = SetTimerEx("OnLoginTimeout", SECONDS_TO_LOGIN * 1000, false, "i", playerid);
	}
	else
	{
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX,"Kota Executive - Tiket Karcis","Dari: Penjaga Pintu Executive #1\nKepada: Calon Aktor (Pemain Peran) di Kota Executive\n\nSilahkan Terlebih Dahulu mengambil tiket pintu Executive #1 di discord sebelum dapat memasuki Kota Executive\nLink Discord: bit.ly/Executive","Keluar","");
        SetTimerEx("KickTimer", 3000, 0, "i", playerid);

	}
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `banneds` WHERE `name` = '%s' OR `ip` = '%s' OR (`longip` != 0 AND (`longip` & %i) = %i) LIMIT 1", pData[playerid][pUCP], pData[playerid][pIP], BAN_MASK, (Ban_GetLongIP(PlayerIP) & BAN_MASK));
	mysql_tquery(g_SQL, query, "CheckBanUCP", "i", playerid);
	return 1;
}

stock ReturnIP(playerid)
{
	static
	    ip[16];

	GetPlayerIp(playerid, ip, sizeof(ip));
	return ip;
}

function OnClientCheckResponse(playerid, type, arg, response)
{
    switch(type)
    {       
        case 0x48:
        {
            SetPVarInt(playerid, "NotAndroid", 1);	
        }
    }
    return 1;
}

function CheckBanUCP(playerid)
{
	if(cache_num_rows() > 0)
	{
		new Reason[40], PlayerName[24], BannedName[24];
	    new banTime_Int, banDate, banIP[16];
		cache_get_value_name(0, "name", BannedName);
		cache_get_value_name(0, "admin", PlayerName);
		cache_get_value_name(0, "reason", Reason);
		cache_get_value_name(0, "ip", banIP);
		cache_get_value_name_int(0, "ban_expire", banTime_Int);
		cache_get_value_name_int(0, "ban_date", banDate);

		new currentTime = gettime();
        if(banTime_Int != 0 && banTime_Int <= currentTime) // Unban the player.
		{
			new query[248];
			mysql_format(g_SQL, query, sizeof(query), "DELETE FROM banneds WHERE name = '%s'", pData[playerid][pUCP]);
			mysql_tquery(g_SQL, query);
				
			Servers(playerid, "Welcome back to server, its been %s since your ban was lifted.", ReturnTimelapse(banTime_Int, gettime()));
		}
		else
		{
			foreach(new pid : Player)
			{
				if(pData[pid][pTogLog] == 0)
				{
					SendClientMessageEx(pid, COLOR_RED, "[SERVER]: "GREY2_E"%s(%i) has been auto-kicked for ban evading.", pData[playerid][pUCP], playerid);
				}
			}
			new query[248], PlayerIP[16];
  			mysql_format(g_SQL, query, sizeof query, "UPDATE `banneds` SET `last_activity_timestamp` = '%d' WHERE `name` = '%s'", gettime(), pData[playerid][pUCP]);
			mysql_tquery(g_SQL, query);
				
			pData[playerid][IsLoggedIn] = false;
			printf("[BANNED INFO]: Ban Getting Called on %s", pData[playerid][pUCP]);
			GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
			
			InfoTD_MSG(playerid, 5000, "~r~~h~You are banned from this server!");
			//for(new l; l < 20; l++) SendClientMessage(playerid, COLOR_DARK, "\n");
			SendClientMessage(playerid, COLOR_RED, "You are banned from this server!");
			if(banTime_Int == 0)
			{
				new lstr[512];
				format(lstr, sizeof(lstr), "{FFFFFF}Your UCP has been Banned from this server\n{FF0000}Reason: {FFFFFF}%s\n{FF0000}Banned By: {FFFFFF}%s\n{FF0000}Ends On: {FFFFFF}Permanent\n{FFFFFF}For Unbanned please visit our discord at {FF0000}https://discord.gg/ZxxJNY4ADk", Reason, BannedName, ReturnDate(banDate));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{FFFFFF}Banned Alert - UCP Ban", lstr, "Close", "");
			}
			else
			{
				new lstr[512];
				format(lstr, sizeof(lstr), "{FFFFFF}Your UCP has been Banned from this server\n{FF0000}Reason: {FFFFFF}%s\n{FF0000}Banned By: {FFFFFF}%s\n{FF0000}Ends On: {FFFFFF}%s\n{FFFFFF}For Unbanned please visit our discord at {FF0000}https://discord.gg/ZxxJNY4ADk", Reason, BannedName, ReturnDate(banDate));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{FFFFFF}Banned Alert - UCP Ban", lstr, "Close", "");
			}
			KickEx(playerid);
			return 1;
  		}
	}
	return 1;
}

function CheckBanAccount(playerid, namachar[])
{
	if(cache_num_rows() > 0)
	{
		new Reason[40], PlayerName[24], BannedName[24];
	    new banTime_Int, banDate, banIP[16];
		cache_get_value_name(0, "name", BannedName);
		cache_get_value_name(0, "admin", PlayerName);
		cache_get_value_name(0, "reason", Reason);
		cache_get_value_name(0, "ip", banIP);
		cache_get_value_name_int(0, "ban_expire", banTime_Int);
		cache_get_value_name_int(0, "ban_date", banDate);

		new currentTime = gettime();
        if(banTime_Int != 0 && banTime_Int <= currentTime) // Unban the player.
		{
			new query[248];
			mysql_format(g_SQL, query, sizeof(query), "DELETE FROM banneds WHERE name = '%s'", pData[playerid][pName]);
			mysql_tquery(g_SQL, query);
				
			Servers(playerid, "Welcome back to server, its been %s since your ban was lifted.", ReturnTimelapse(banTime_Int, gettime()));
		}
		else
		{
			foreach(new pid : Player)
			{
				if(pData[pid][pTogLog] == 0)
				{
					SendClientMessageEx(pid, COLOR_RED, "[SERVER]: "GREY2_E"%s(%i) has been auto-kicked for ban evading.", pData[playerid][pName], playerid);
				}
			}
			new query[248], PlayerIP[16];
  			mysql_format(g_SQL, query, sizeof query, "UPDATE `banneds` SET `last_activity_timestamp` = '%d' WHERE `name` = '%s'", gettime(), pData[playerid][pName]);
			mysql_tquery(g_SQL, query);
				
			pData[playerid][IsLoggedIn] = false;
			printf("[BANNED INFO]: Ban Getting Called on %s", pData[playerid][pName]);
			GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
			
			InfoTD_MSG(playerid, 5000, "~r~~h~You are account banned from this server!");
			//for(new l; l < 20; l++) SendClientMessage(playerid, COLOR_DARK, "\n");
			SendClientMessage(playerid, COLOR_RED, "You are account banned from this server!");
			if(banTime_Int == 0)
			{
				new lstr[512];
				format(lstr, sizeof(lstr), "{FF0000}You are account banned from this server!\n\n"LB2_E"Ban Info:\n{FF0000}Name : {778899}%s\n{FF0000}IP: {778899}%s\n{FF0000}Admin: {778899}%s\n{FF0000}Ban Date: {778899}%s\n{FF0000}Ban Reason: {778899}%s\n{FF0000}Ban Time: {778899}Permanent\n\n{FFFFFF}Merasa tidak bersalah terkena banned? Appeal di Discord", BannedName, PlayerIP, PlayerName, ReturnDate(banDate), Reason);
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"BANNED", lstr, "Exit", "");
			}
			else
			{
				new lstr[512];
				format(lstr, sizeof(lstr), "{FF0000}You are account banned from this server!\n\n"LB2_E"Ban Info:\n{FF0000}Name : {778899}%s\n{FF0000}IP: {778899}%s\n{FF0000}Admin: {778899}%s\n{FF0000}Ban Date: {778899}%s\n{FF0000}Ban Reason: {778899}%s\n\n{FFFFFF}Merasa tidak bersalah terkena banned? Appeal di Discord", BannedName, PlayerIP, PlayerName, ReturnDate(banDate), Reason);
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"BANNED", lstr, "Exit", "");
			}
			KickEx(playerid);
			return 1;
  		}
	}
	return 1;
}

/*function YANGTIM(playerid)
{
	if(!STATUS_BOT2)
	{
		DCC_SetBotActivity("Aufa Devlopment");
		STATUS_BOT2 = true;
	}
	return 1;
}*/

function BackupDB(playerid)
{
	UpdatePlayerData(playerid);
	return 1;
}

function AssignPlayerData(playerid)
{
	new aname[MAX_PLAYER_NAME], name[MAX_PLAYER_NAME], ucp[22], twname[MAX_PLAYER_NAME], email[40], age[128], tng[128], brt[128], ip[128], regdate[50], lastlogin[50];
	
	cache_get_value_name_int(0, "reg_id", pData[playerid][pID]);
	if(pData[playerid][pID] < 1)
	{
		Error(playerid, "Database player not found!");
		KickEx(playerid);
		return 1;
	}	
	//cache_get_value_name_int(0, "reg_id", pData[playerid][pID]);
	cache_get_value_name(0, "ucp", ucp);
	format(pData[playerid][pUCP], 22, "%s", ucp);
	cache_get_value_name(0, "username", name);
	format(pData[playerid][pName], MAX_PLAYER_NAME, "%s", name);
	cache_get_value_name(0, "adminname", aname);
	format(pData[playerid][pAdminname], MAX_PLAYER_NAME, "%s", aname);
	cache_get_value_name(0, "twittername", twname);
	format(pData[playerid][pTwittername], MAX_PLAYER_NAME, "%s", twname);
	cache_get_value_name(0, "ip", ip);
	format(pData[playerid][pIP], 128, "%s", ip);
	cache_get_value_name(0, "email", email);
	format(pData[playerid][pEmail], 40, "%s", email);
	cache_get_value_name_int(0, "admin", pData[playerid][pAdmin]);
	cache_get_value_name_int(0, "servermod", pData[playerid][pServerModerator]);
	cache_get_value_name_int(0, "eventmod", pData[playerid][pEventModerator]);
	cache_get_value_name_int(0, "factionmod", pData[playerid][pFactionModerator]);
	cache_get_value_name_int(0, "familymod", pData[playerid][pFamilyModerator]);
	cache_get_value_name_int(0, "helper", pData[playerid][pHelper]);
	cache_get_value_name_int(0, "level", pData[playerid][pLevel]);
	cache_get_value_name_int(0, "levelup", pData[playerid][pLevelUp]);
	cache_get_value_name_int(0, "vip", pData[playerid][pVip]);
	cache_get_value_name_int(0, "vip_time", pData[playerid][pVipTime]);
	cache_get_value_name_int(0, "gold", pData[playerid][pGold]);
	cache_get_value_name(0, "reg_date", regdate);
	format(pData[playerid][pRegDate], 128, "%s", regdate);
	cache_get_value_name(0, "last_login", lastlogin);
	format(pData[playerid][pLastLogin], 128, "%s", lastlogin);
	cache_get_value_name_int(0, "money", pData[playerid][pMoney]);
	cache_get_value_name_int(0, "uanggudang", pData[playerid][UangGudang]);
	cache_get_value_name_int(0, "redmoney", pData[playerid][pRedMoney]);
	cache_get_value_name_int(0, "bmoney", pData[playerid][pBankMoney]);
	cache_get_value_name_int(0, "brek", pData[playerid][pBankRek]);
	cache_get_value_name_int(0, "starterpack", pData[playerid][pStarterpack]);
	cache_get_value_name_int(0, "phone", pData[playerid][pPhone]);
	cache_get_value_name_int(0, "phonestatus", pData[playerid][pPhoneStatus]);
	cache_get_value_name_int(0, "phonekuota", pData[playerid][pKuota]);
	cache_get_value_name_int(0, "phonecredit", pData[playerid][pPhoneCredit]);
	cache_get_value_name_int(0, "phonebook", pData[playerid][pPhoneBook]);
	cache_get_value_name_int(0, "phonebook", pData[playerid][pPhoneBook]);
	cache_get_value_name_int(0, "twitter", pData[playerid][pTwitter]);
	cache_get_value_name_int(0, "twitterstatus", pData[playerid][pTwitterStatus]);
	cache_get_value_name_int(0, "wt", pData[playerid][pWT]);
	cache_get_value_name_int(0, "hours", pData[playerid][pHours]);
	cache_get_value_name_int(0, "minutes", pData[playerid][pMinutes]);
	cache_get_value_name_int(0, "seconds", pData[playerid][pSeconds]);
	cache_get_value_name_int(0, "paycheck", pData[playerid][pPaycheck]);
	cache_get_value_name_int(0, "skin", pData[playerid][pSkin]);
	cache_get_value_name_int(0, "facskin", pData[playerid][pFacSkin]);
	cache_get_value_name_int(0, "gender", pData[playerid][pGender]);
	cache_get_value_name(0, "age", age);
	format(pData[playerid][pAge], 128, "%s", age);
	cache_get_value_name_int(0, "indoor", pData[playerid][pInDoor]);
	cache_get_value_name_int(0, "inhouse", pData[playerid][pInHouse]);
	cache_get_value_name_int(0, "inbiz", pData[playerid][pInBiz]);
	cache_get_value_name_int(0, "infamily", pData[playerid][pInFamily]);
	cache_get_value_name_float(0, "posx", pData[playerid][pPosX]);
	cache_get_value_name_float(0, "posy", pData[playerid][pPosY]);
	cache_get_value_name_float(0, "posz", pData[playerid][pPosZ]);
	cache_get_value_name_float(0, "posa", pData[playerid][pPosA]);
	cache_get_value_name_int(0, "interior", pData[playerid][pInt]);
	cache_get_value_name_int(0, "world", pData[playerid][pWorld]);
	cache_get_value_name_float(0, "health", pData[playerid][pHealth]);
	cache_get_value_name_float(0, "armour", pData[playerid][pArmour]);
	cache_get_value_name_int(0, "hunger", pData[playerid][pHunger]);
	cache_get_value_name_int(0, "energy", pData[playerid][pEnergy]);
	cache_get_value_name_int(0, "bladder", pData[playerid][pBladder]);
	cache_get_value_name_int(0, "sick", pData[playerid][pSick]);
	cache_get_value_name_int(0, "hospital", pData[playerid][pHospital]);
	cache_get_value_name_int(0, "injured", pData[playerid][pInjured]);
	cache_get_value_name_int(0, "duty", pData[playerid][pOnDuty]);
	cache_get_value_name_int(0, "dutytime", pData[playerid][pOnDutyTime]);
	cache_get_value_name_int(0, "faction", pData[playerid][pFaction]);
	cache_get_value_name_int(0, "factionrank", pData[playerid][pFactionRank]);
	cache_get_value_name_int(0, "factionlead", pData[playerid][pFactionLead]);
	cache_get_value_name_int(0, "family", pData[playerid][pFamily]);
	cache_get_value_name_int(0, "familyrank", pData[playerid][pFamilyRank]);
	cache_get_value_name_int(0, "jail", pData[playerid][pJail]);
	cache_get_value_name_int(0, "jail_time", pData[playerid][pJailTime]);
	cache_get_value_name_int(0, "arrest", pData[playerid][pArrest]);
	cache_get_value_name_int(0, "arrest_time", pData[playerid][pArrestTime]);
	cache_get_value_name_int(0, "suspect", pData[playerid][pSuspect]);
	cache_get_value_name_int(0, "suspect_time", pData[playerid][pSuspectTimer]);
	cache_get_value_name_int(0, "ask_time", pData[playerid][pAskTime]);
	cache_get_value_name_int(0, "warn", pData[playerid][pWarn]);
	cache_get_value_name_int(0, "job", pData[playerid][pJob]);
	cache_get_value_name_int(0, "job2", pData[playerid][pJob2]);
	cache_get_value_name_int(0, "characterstory", pData[playerid][pCs]);
	cache_get_value_name_int(0, "booster", pData[playerid][pBooster]);
	cache_get_value_name_int(0, "booster_time", pData[playerid][pBoostTime]);
	cache_get_value_name_int(0, "jobtime", pData[playerid][pJobTime]);
	cache_get_value_name_int(0, "sidejobtime", pData[playerid][pSideJobTime]);
	cache_get_value_name_int(0, "sidejob_bustime", pData[playerid][pBusTime]);
	cache_get_value_name_int(0, "job_spareparttime", pData[playerid][pSparepartTime]);
	cache_get_value_name_int(0, "exitjob", pData[playerid][pExitJob]);
	cache_get_value_name_int(0, "robtime", pData[playerid][pRobTime]);
	cache_get_value_name_int(0, "myricous", pData[playerid][pObat]);
	cache_get_value_name_int(0, "medicine", pData[playerid][pMedicine]);
	cache_get_value_name_int(0, "medkit", pData[playerid][pMedkit]);
	cache_get_value_name_int(0, "mask", pData[playerid][pMask]);
	cache_get_value_name_int(0, "helmet", pData[playerid][pHelmet]);
	cache_get_value_name_int(0, "snack", pData[playerid][pSnack]);
	cache_get_value_name_int(0, "sprunk", pData[playerid][pSprunk]);
	cache_get_value_name_int(0, "gas", pData[playerid][pGas]);
	cache_get_value_name_int(0, "bandage", pData[playerid][pBandage]);
	cache_get_value_name_int(0, "material", pData[playerid][pMaterial]);
	cache_get_value_name_int(0, "component", pData[playerid][pComponent]);
	cache_get_value_name_int(0, "price1", pData[playerid][pPrice1]);
	cache_get_value_name_int(0, "price2", pData[playerid][pPrice2]);
	cache_get_value_name_int(0, "price3", pData[playerid][pPrice3]);
	cache_get_value_name_int(0, "price4", pData[playerid][pPrice4]);
	cache_get_value_name_int(0, "marijuana", pData[playerid][pMarijuana]);
	cache_get_value_name_int(0, "kanabis", pData[playerid][pKanabis]);
	cache_get_value_name_int(0, "cig", pData[playerid][pCig]);
	cache_get_value_name_int(0, "plant", pData[playerid][pPlant]);
	cache_get_value_name_int(0, "plant_time", pData[playerid][pPlantTime]);
	cache_get_value_name_int(0, "fishtool", pData[playerid][pFishTool]);
	cache_get_value_name_int(0, "fish", pData[playerid][pFish]);
	cache_get_value_name_int(0, "worm", pData[playerid][pWorm]);
	cache_get_value_name_int(0, "idcard", pData[playerid][pIDCard]);
	cache_get_value_name_int(0, "idcard_time", pData[playerid][pIDCardTime]);
	cache_get_value_name_int(0, "drivelic", pData[playerid][pDriveLic]);
	cache_get_value_name_int(0, "drivelic_time", pData[playerid][pDriveLicTime]);
	cache_get_value_name_int(0, "weaponlic", pData[playerid][pWeaponLic]);
	cache_get_value_name_int(0, "weaponlic_time", pData[playerid][pWeaponLicTime]);
	cache_get_value_name_int(0, "bizlic", pData[playerid][pBizLic]);
	cache_get_value_name_int(0, "bizlic_time", pData[playerid][pBizLicTime]);
	cache_get_value_name_int(0, "bpjs", pData[playerid][pBpjs]);
	cache_get_value_name_int(0, "bpjs_time", pData[playerid][pBpjsTime]);
	cache_get_value_name_int(0, "hbemode", pData[playerid][pHBEMode]);
	cache_get_value_name_int(0, "togpm", pData[playerid][pTogPM]);
	cache_get_value_name_int(0, "toglog", pData[playerid][pTogLog]);
	cache_get_value_name_int(0, "togads", pData[playerid][pTogAds]);
	cache_get_value_name_int(0, "togwt", pData[playerid][pTogWT]);
	
	cache_get_value_name_int(0, "Gun1", pData[playerid][pGuns][0]);
	cache_get_value_name_int(0, "Gun2", pData[playerid][pGuns][1]);
	cache_get_value_name_int(0, "Gun3", pData[playerid][pGuns][2]);
	cache_get_value_name_int(0, "Gun4", pData[playerid][pGuns][3]);
	cache_get_value_name_int(0, "Gun5", pData[playerid][pGuns][4]);
	cache_get_value_name_int(0, "Gun6", pData[playerid][pGuns][5]);
	cache_get_value_name_int(0, "Gun7", pData[playerid][pGuns][6]);
	cache_get_value_name_int(0, "Gun8", pData[playerid][pGuns][7]);
	cache_get_value_name_int(0, "Gun9", pData[playerid][pGuns][8]);
	cache_get_value_name_int(0, "Gun10", pData[playerid][pGuns][9]);
	cache_get_value_name_int(0, "Gun11", pData[playerid][pGuns][10]);
	cache_get_value_name_int(0, "Gun12", pData[playerid][pGuns][11]);
	cache_get_value_name_int(0, "Gun13", pData[playerid][pGuns][12]);
	
	cache_get_value_name_int(0, "Ammo1", pData[playerid][pAmmo][0]);
	cache_get_value_name_int(0, "Ammo2", pData[playerid][pAmmo][1]);
	cache_get_value_name_int(0, "Ammo3", pData[playerid][pAmmo][2]);
	cache_get_value_name_int(0, "Ammo4", pData[playerid][pAmmo][3]);
	cache_get_value_name_int(0, "Ammo5", pData[playerid][pAmmo][4]);
	cache_get_value_name_int(0, "Ammo6", pData[playerid][pAmmo][5]);
	cache_get_value_name_int(0, "Ammo7", pData[playerid][pAmmo][6]);
	cache_get_value_name_int(0, "Ammo8", pData[playerid][pAmmo][7]);
	cache_get_value_name_int(0, "Ammo9", pData[playerid][pAmmo][8]);
	cache_get_value_name_int(0, "Ammo10", pData[playerid][pAmmo][9]);
	cache_get_value_name_int(0, "Ammo11", pData[playerid][pAmmo][10]);
	cache_get_value_name_int(0, "Ammo12", pData[playerid][pAmmo][11]);
	cache_get_value_name_int(0, "Ammo13", pData[playerid][pAmmo][12]);
	cache_get_value_name_int(0, "kepala", pData[playerid][pHead]);
	cache_get_value_name_int(0, "perut", pData[playerid][pPerut]);
	cache_get_value_name_int(0, "lengankiri", pData[playerid][pLHand]);
	cache_get_value_name_int(0, "lengankanan", pData[playerid][pRHand]);
	cache_get_value_name_int(0, "kakikiri", pData[playerid][pLFoot]);
	cache_get_value_name_int(0, "kakikanan", pData[playerid][pRFoot]);
	cache_get_value_name_int(0, "boombox", pData[playerid][pBoombox]);
	cache_get_value_name_int(0, "pizza", pData[playerid][pPizza]);
	cache_get_value_name_int(0, "mineral", pData[playerid][pMineral]);
	cache_get_value_name_int(0, "burger", pData[playerid][pBurger]);
	cache_get_value_name_int(0, "chiken", pData[playerid][pChiken]);
	cache_get_value_name_int(0, "cola", pData[playerid][pCola]);
	cache_get_value_name_int(0, "lockpick", pData[playerid][pLockPick]);
	cache_get_value_name_int(0, "robbanktime", pData[playerid][RobbankTime]);
	cache_get_value_name_int(0, "robbiztime", pData[playerid][RobbizTime]);
	cache_get_value_name_int(0, "robatmtime", pData[playerid][RobatmTime]);
	cache_get_value_name_int(0, "panelhacking", pData[playerid][pPanelHacking]);
	cache_get_value_name_int(0, "ayamhidup", pData[playerid][AyamHidup]);
	cache_get_value_name_int(0, "ayampotong", pData[playerid][AyamPotong]);
	cache_get_value_name_int(0, "ayamfillet", pData[playerid][AyamFillet]);
	cache_get_value_name_int(0, "bomb", pData[playerid][pBomb]);
	cache_get_value_name_int(0, "farm", pData[playerid][pFarm]);
	cache_get_value_name_int(0, "farmrank", pData[playerid][pFarmRank]);
	cache_get_value_name(0, "tinggi", tng);
	format(pData[playerid][pTinggi], 128, "%s", tng);
	cache_get_value_name(0, "berat", brt);
	format(pData[playerid][pBerat], 128, "%s", brt);
    cache_get_value_name_int(0, "batu", pData[playerid][pBatu]);
    cache_get_value_name_int(0, "batucucian", pData[playerid][pBatuCucian]);
    cache_get_value_name_int(0, "emas", pData[playerid][pEmas]);
    cache_get_value_name_int(0, "minyak", pData[playerid][pMinyak]);
    cache_get_value_name_int(0, "essence", pData[playerid][pEssence]);
    cache_get_value_name_int(0, "sampahsaya", pData[playerid][sampahsaya]);
	cache_get_value_name_int(0, "wool", pData[playerid][pWool]);
	cache_get_value_name_int(0, "kain", pData[playerid][pKain]);
	cache_get_value_name_int(0, "kayu", pData[playerid][pKayu]);
	cache_get_value_name_int(0, "papan", pData[playerid][pPapan]);
	cache_get_value_name_int(0, "pakaian", pData[playerid][pPakaian]);
    cache_get_value_name_int(0, "Susu", pData[playerid][pSusu]);
    cache_get_value_name_int(0, "SusuOlahan", pData[playerid][pSusuOlahan]);
    cache_get_value_name_int(0, "BuluAyam", pData[playerid][pBuluAyam]);
    cache_get_value_name_int(0, "InstallTweet", pData[playerid][pInstallTweet]);
    cache_get_value_name_int(0, "InstallMap", pData[playerid][pInstallMap]);
    cache_get_value_name_int(0, "InstallMbanking", pData[playerid][pInstallBank]);
    cache_get_value_name_int(0, "InstallGojek", pData[playerid][pInstallGojek]);
    cache_get_value_name_int(0, "Starling", pData[playerid][pStarling]);
    cache_get_value_name_int(0, "Kebab", pData[playerid][pKebab]);
    cache_get_value_name_int(0, "Cappucino", pData[playerid][pCappucino]);
    cache_get_value_name_int(0, "MilxMax", pData[playerid][pMilxMax]);
    cache_get_value_name_int(0, "Roti", pData[playerid][pRoti]);
    cache_get_value_name_int(0, "Wallpaper", pData[playerid][pWallpaper]);
    cache_get_value_name_int(0, "InstallDweb", pData[playerid][pInstallDweb]);
    cache_get_value_name_int(0, "padi", pData[playerid][pPadi]);
    cache_get_value_name_int(0, "jagung", pData[playerid][pJagung]);
    cache_get_value_name_int(0, "cabai", pData[playerid][pCabai]);
    cache_get_value_name_int(0, "tebu", pData[playerid][pTebu]);
    cache_get_value_name_int(0, "padiolahan", pData[playerid][pPadiOlahan]);
    cache_get_value_name_int(0, "jagungolahan", pData[playerid][pJagungOlahan]);
    cache_get_value_name_int(0, "cabaiolahan", pData[playerid][pCabaiOlahan]);
    cache_get_value_name_int(0, "tebuolahan", pData[playerid][pTebuOlahan]);
    cache_get_value_name_int(0, "beras", pData[playerid][pBeras]);
    cache_get_value_name_int(0, "tepung", pData[playerid][pTepung]);
    cache_get_value_name_int(0, "sambal", pData[playerid][pSambal]);
    cache_get_value_name_int(0, "gula", pData[playerid][pGula]);
    cache_get_value_name_int(0, "besi", pData[playerid][pBesi]);
    cache_get_value_name_int(0, "aluminium", pData[playerid][pAluminium]);
    cache_get_value_name_int(0, "penyu", pData[playerid][pPenyu]);
    cache_get_value_name_int(0, "makarel", pData[playerid][pMakarel]);
    cache_get_value_name_int(0, "nemo", pData[playerid][pNemo]);
    cache_get_value_name_int(0, "bluefish", pData[playerid][pBlueFish]);
    cache_get_value_name_int(0, "kencing", pData[playerid][pKencing]);
    cache_get_value_name_int(0, "perban", pData[playerid][pPerban]);
    cache_get_value_name_int(0, "obatstres", pData[playerid][pObatStress]);
    cache_get_value_name_int(0, "steak", pData[playerid][pSteak]);
    cache_get_value_name_int(0, "vest", pData[playerid][pVest]);
	cache_get_value_name_int(0, "blacklistbill", pData[playerid][BlacklistBill]);

	for (new i; i < 17; i++)
	{
		WeaponSettings[playerid][i][Position][0] = -0.116;
		WeaponSettings[playerid][i][Position][1] = 0.189;
		WeaponSettings[playerid][i][Position][2] = 0.088;
		WeaponSettings[playerid][i][Position][3] = 0.0;
		WeaponSettings[playerid][i][Position][4] = 44.5;
		WeaponSettings[playerid][i][Position][5] = 0.0;
		WeaponSettings[playerid][i][Bone] = 1;
		WeaponSettings[playerid][i][Hidden] = false;
	}
	if(pData[playerid][pJail] == 1)
	{
	    for(new i = 0; i < 22; i++)
		{
			TextDrawHideForPlayer(playerid, SpawnTD[i]);
			CancelSelectTextDraw(playerid);
		}
	}
	if(pData[playerid][pArrest] == 1)
	{
	    for(new i = 0; i < 22; i++)
		{
			TextDrawHideForPlayer(playerid, SpawnTD[i]);
			CancelSelectTextDraw(playerid);
		}
	}
	SambutanMuncul(playerid);
	SetTimerEx("SambutanHilang", 5000, false, "d", playerid);
	if(pData[playerid][pJail] == 0)
	{
	   	pilihanspawn(playerid);
	}
	if(pData[playerid][pJob] ==1)
	{
		Sopirbus++;
		RefreshJobBus(playerid);
	}
	else if(pData[playerid][pJob] == 2)
	{
		tukangayam++;
		pData[playerid][DutyPemotong] = false;
		RefreshJobPemotong(playerid);
	}
	else if(pData[playerid][pJob] == 3)
	{
		tukangtebang++;
	    pData[playerid][DutyPenebang] = false;
	    RefreshJobTebang(playerid);
	}
	else if(pData[playerid][pJob] == 4)
	{
		penambangminyak++;
		pData[playerid][DutyMinyak] = false;
		RefreshJobTambangMinyak(playerid);
	}
	else if(pData[playerid][pJob] == 5)
	{
	    pemerah++;
	    pData[playerid][pJobmilkduty] = false;
		RefreshMapJobSapi(playerid);
	}
	else if(pData[playerid][pJob] == 6)
	{
	    pData[playerid][DutyPenambang] = false;
	    RefreshJobTambang(playerid);
		penambang++;
	}
	else if(pData[playerid][pJob] == 7)
	{
		petani++;
		RefreshJobTani(playerid);
	}
	else if(pData[playerid][pJob] == 8)
	{
		Trucker++;
		RefreshJobKargo(playerid);
	}
	else if(pData[playerid][pJob] == 10)
	{
		penjahit++;
	}

	SetPlayerHealthEx(playerid, pData[playerid][pHealth]);
	SetPlayerArmourEx(playerid, pData[playerid][pArmour]);

	WeaponTick[playerid] = 0;
	WeaponTick[playerid] = 0;
	EditingWeapon[playerid] = 0;
	
	new string[128];
	mysql_format(g_SQL, string, sizeof(string), "SELECT * FROM weaponsettings WHERE Owner = '%d'", pData[playerid][pID]);
	mysql_tquery(g_SQL, string, "OnWeaponsLoaded", "d", playerid);

	new strong[128];
	mysql_format(g_SQL, strong, sizeof(strong), "SELECT * FROM `contacts` WHERE `ID` = '%d'", pData[playerid][pID]);
	mysql_tquery(g_SQL, strong, "LoadContact", "d", playerid);
	
	KillTimer(pData[playerid][LoginTimer]);
	pData[playerid][LoginTimer] = 0;
	pData[playerid][IsLoggedIn] = true;
	pData[playerid][pACTime] = gettime() + 5;
	SetSpawnInfo(playerid, NO_TEAM, pData[playerid][pSkin], pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pPosA], 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	MySQL_LoadPlayerToys(playerid);
	LoadPlayerVehicle(playerid);

    new DCC_Channel:connect, DCC_Embed:logss;
	logss = DCC_CreateEmbed("Executive Roleplay");
	connect = DCC_FindChannelById("1095732573004648499");
	DCC_SetEmbedTitle(logss, "Executive Roleplay | MoreThanCommunity");
	DCC_SetEmbedTimestamp(logss, "Penjaga pintu Executive");
	DCC_SetEmbedColor(logss, 0x00ff00);
	DCC_SetEmbedUrl(logss, "https://media.discordapp.net/attachments/1101454563908800553/1113354457460256778/Tak_berjudul21_20230513005034.png");
	DCC_SetEmbedThumbnail(logss, "https://media.discordapp.net/attachments/1101454563908800553/1113354457460256778/Tak_berjudul21_20230513005034.png");
	DCC_SetEmbedFooter(logss, "Executive ROLEPLAY | MORETHANCOMMUNITY", "");
	new stroi[5000];
	format(stroi, sizeof(stroi), "**s** telah masuk ke dalam Pintu Executive #1\n**UCP: %s**\n**Player ID:** %d\n**Negara:** Indonesia", pData[playerid][pName], pData[playerid][pUCP], playerid);
	DCC_AddEmbedField(logss, "Penjaga pintu Executive", stroi, true);
	DCC_SendChannelEmbedMessage(connect, logss);
	return 1;
}

function CekNamaDobelJing(playerid, name[])
{
	new rows = cache_num_rows();
	if(rows > 0)
	{
		ShowPlayerDialog(playerid, DIALOG_MAKE_CHAR, DIALOG_STYLE_INPUT, "Create Character", "ERROR: This name is already used by the other player!\nInsert your new Character Name\n\nExample: Finn_Xanderz, Javier_Cooper etc.", "Create", "Back");
	}
	else 
	{
		new characterQuery[178];
		mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "INSERT INTO players ( username, ucp, reg_date ) VALUES ('%s', '%s', CURRENT_TIMESTAMP())", name, GetName(playerid));
		mysql_tquery(g_SQL, characterQuery, "OnPlayerRegister", "d", playerid);

		SetPlayerName(playerid, name);
		pData[playerid][pMasukinNama] = 1;
		format(pData[playerid][pName], MAX_PLAYER_NAME, name);
	 	new AtmInfo[560];
		format(AtmInfo,1000,"%s", name);
	   	PlayerTextDrawSetString(playerid, BuatKarakter[playerid][28], AtmInfo);
	}
}


function OnPlayerRegister(playerid)
{
	if(pData[playerid][IsLoggedIn] == true)
		return Error(playerid, "You already logged in!");
		
	pData[playerid][pID] = cache_insert_id();
	pData[playerid][IsLoggedIn] = true;

	pData[playerid][pPosX] = 1685.559448;
	pData[playerid][pPosY] = -2239.149658;
	pData[playerid][pPosZ] = 13.546875;
	pData[playerid][pPosA] = 175.810470;
	pData[playerid][pInt] = 0;
	pData[playerid][pWorld] = 0;
	pData[playerid][pGender] = 0;

	format(pData[playerid][pAdminname], MAX_PLAYER_NAME, "None");
	format(pData[playerid][pEmail], 40, "None");
	pData[playerid][pHealth] = 100.0;
	pData[playerid][pArmour] = 0.0;
	pData[playerid][pLevel] = 1;
	pData[playerid][pHunger] = 100;
	pData[playerid][pBladder] = 0;
	pData[playerid][pKencing] = 0;
	pData[playerid][pEnergy] = 100;
	pData[playerid][pMoney] = 300;
	pData[playerid][pBankMoney] = 50;

	pData[playerid][pHead] = 100;
	pData[playerid][pPerut] = 100;
	pData[playerid][pLHand] = 100;
	pData[playerid][pRHand] = 100;
	pData[playerid][pLFoot] = 100;
	pData[playerid][pRFoot] = 100;

	/*new rand = RandomEx(111111, 999999);
	new rek = rand+pData[playerid][pID];
	pData[playerid][pBankRek] = rek;*/
	
	new query[128], rand = RandomEx(111111, 999999);
	new rek = rand+pData[playerid][pID];
	mysql_format(g_SQL, query, sizeof(query), "SELECT brek FROM players WHERE brek='%d'", rek);
	mysql_tquery(g_SQL, query, "BankRek", "id", playerid, rek);
	
	SetSpawnInfo(playerid, NO_TEAM, 0, 2823.21,-2440.34,12.08,85.07, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	return 1;
}

function BankRek(playerid, brek)
{
	if(cache_num_rows() > 0)
	{
		//Rekening Exist
		new query[128], rand = RandomEx(11111, 99999);
		new rek = rand+pData[playerid][pID];
		mysql_format(g_SQL, query, sizeof(query), "SELECT brek FROM players WHERE brek='%d'", rek);
		mysql_tquery(g_SQL, query, "BankRek", "is", playerid, rek);
		Info(playerid, "Your Bank rekening number is same with someone. We will research new.");
	}
	else
	{
		new query[128];
	    mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET brek='%d' WHERE reg_id=%d", brek, pData[playerid][pID]);
		mysql_tquery(g_SQL, query);
		pData[playerid][pBankRek] = brek;
	}
    return true;
}

function PhoneNumber(playerid, phone)
{
	if(cache_num_rows() > 0)
	{
		//Rekening Exist
		new query[128], rand = RandomEx(1111, 9888);
		new phones = rand+pData[playerid][pID];
		mysql_format(g_SQL, query, sizeof(query), "SELECT phone FROM players WHERE phone='%d'", phones);
		mysql_tquery(g_SQL, query, "PhoneNumber", "is", playerid, phones);
		Info(playerid, "Your Phone number is same with someone. We will research new.");
	}
	else
	{
		new query[128];
	    mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET phone='%d' WHERE reg_id=%d", phone, pData[playerid][pID]);
		mysql_tquery(g_SQL, query);
		pData[playerid][pPhone] = phone;
	}
    return true;
}

function OnLoginTimeout(playerid)
{
	pData[playerid][LoginTimer] = 0;

	return 1;
}


function _KickPlayerDelayed(playerid)
{
	Kick(playerid);
	return 1;
}

function SafeLogin(playerid)
{

	// Main Menu Features.
	SetPlayerVirtualWorld(playerid, 0);
	
	/*if(!IsValidRoleplayName(pData[playerid][pName]))
    {
        Error(playerid, "Nama tidak sesuai format untuk server mode roleplay.");
        Error(playerid, "Penggunaan nama harus mengikuti format Firstname_Lastname.");
        Error(playerid, "Sebagai contoh, Steven_Dreschler, Nick_Raymond, dll.");
        KickEx(playerid);
    }*/
}

//---------[ Textdraw ]----------

// Info textdraw timer for hiding the textdraw
function InfoTD_MSG(playerid, ms_time, text[])
{
	if(GetPVarInt(playerid, "InfoTDshown") != -1)
	{
	    PlayerTextDrawHide(playerid, InfoTD[playerid]);
	    KillTimer(GetPVarInt(playerid, "InfoTDshown"));
	}

    PlayerTextDrawSetString(playerid, InfoTD[playerid], text);
    PlayerTextDrawShow(playerid, InfoTD[playerid]);
	SetPVarInt(playerid, "InfoTDshown", SetTimerEx("InfoTD_Hide", ms_time, false, "i", playerid));
}

function InfoTD_Hide(playerid)
{
	SetPVarInt(playerid, "InfoTDshown", -1);
	PlayerTextDrawHide(playerid, InfoTD[playerid]);
}

//---------[ Twitter Function ]---------
function a_ChangeTwitterName(otherplayer, playerid, twname[])
{
	if(cache_num_rows() > 0)
	{
		// Name Exists
		Error(playerid, "Akun "DARK_E"'%s' "GREY_E"Telah ada! Harap gunakan yang lain", twname);
	}
	else
	{
		new query[512];
	    format(query, sizeof(query), "UPDATE players SET twittername='%e' WHERE reg_id=%d", twname, pData[otherplayer][pID]);
		mysql_tquery(g_SQL, query);
		format(pData[otherplayer][pTwittername], MAX_PLAYER_NAME, "%s", twname);
		Servers(playerid, "You has set twitter name player %s to %s", pData[otherplayer][pName], twname);
	}
    return true;
}

//---------[Admin Function ]----------

function a_ChangeAdminName(otherplayer, playerid, nname[])
{
	if(cache_num_rows() > 0)
	{
		// Name Exists
		ErrorMsg(playerid, "Akun dengan nama ini Telah ada! Harap gunakan yang lain");
	}
	else
	{
		new query[512];
	    format(query, sizeof(query), "UPDATE players SET adminname='%e' WHERE reg_id=%d", nname, pData[otherplayer][pID]);
		mysql_tquery(g_SQL, query);
		format(pData[otherplayer][pAdminname], MAX_PLAYER_NAME, "%s", nname);
		new str[512];
		format(str, sizeof(str), "Anda telah mengubah nama admin %s menjadi %s", pData[otherplayer][pName], nname);
		SuccesMsg(playerid, str);
	}
    return true;
}

function LoadStats(playerid, PlayersName[])
{
	if(!cache_num_rows())
	{
		Error(playerid, "Account '%s' does not exist.", PlayersName);
	}
	else
	{
		new email[40], admin, helper, level, levelup, vip, viptime, coin, regdate[40], lastlogin[40], money, bmoney, brek,
			jam, menit, detik, gender, age[40], faction, family, warn, job, job2, int, world, ucp[30], reg_id, phonestatus, phone, twitter[40];
		cache_get_value_index(0, 0, email);
		cache_get_value_index_int(0, 1, admin);
		cache_get_value_index_int(0, 2, helper);
		cache_get_value_index_int(0, 3, level);
		cache_get_value_index_int(0, 4, levelup);
		cache_get_value_index_int(0, 5, vip);
		cache_get_value_index_int(0, 6, viptime);
		cache_get_value_index_int(0, 7, coin);
		cache_get_value_index(0, 8, regdate);
		cache_get_value_index(0, 9, lastlogin);
		cache_get_value_index_int(0, 10, money);
		cache_get_value_index_int(0, 11, bmoney);
		cache_get_value_index_int(0, 12, brek);
		cache_get_value_index_int(0, 13, jam);
		cache_get_value_index_int(0, 14, menit);
		cache_get_value_index_int(0, 15, detik);
		cache_get_value_index_int(0, 16, gender);
		cache_get_value_index(0, 17, age);
		cache_get_value_index_int(0, 18, faction);
		cache_get_value_index_int(0, 19, family);
		cache_get_value_index_int(0, 20, warn);
		cache_get_value_index_int(0, 21, job);
		cache_get_value_index_int(0, 22, job2);
		cache_get_value_index_int(0, 23, int);
		cache_get_value_index_int(0, 24, world);
		cache_get_value_index(0, 25, ucp);
		cache_get_value_index_int(0, 26, reg_id);
		cache_get_value_index_int(0, 27, phone);
		cache_get_value_index_int(0, 28, phonestatus);
		cache_get_value_index(0, 29, twitter);

		
		new header[248], scoremath = ((level)*5), fac[24], Cache:checkfamily, gstr[2468], query[128];
	
		if(faction == 1)
		{
			fac = "San Andreas Police";
		}
		else if(faction == 2)
		{
			fac = "San Andreas Goverment";
		}
		else if(faction == 3)
		{
			fac = "San Andreas Medic";
		}
		else if(faction == 4)
		{
			fac = "San Andreas News";
		}
		else
		{
			fac = "None";
		}
		
		new name1[30];
		if(vip == 1)
		{
			name1 = ""LG_E"Bronze";
		}
		else if(vip == 2)
		{
			name1 = ""YELLOW_E"Silver";
		}
		else if(vip == 3)
		{
			name1 = ""PURPLE_E"Diamond";
		}
		else
		{
			name1 = "None";
		}
		
		new pstatus[36];
		if(phonestatus == 1)
		{
			format(pstatus, 36, "{7fff00}Online{ffffff}");
		}
		else
		{
			format(pstatus, 36, "{ff0000}Offline{ffffff}");
		}

		format(query, sizeof(query), "SELECT * FROM `familys` WHERE `ID`='%d'", family);
		checkfamily = mysql_query(g_SQL, query);
		
		new atext[512];

		new boost = pData[playerid][pBooster];
		new boosttime = pData[playerid][pBoostTime];
		if(boost == 1)
		{
			atext = "{7fff00}Yes";
		}
		else
		{
			atext = "{ff0000}No";
		}
		
		new rows = cache_num_rows(), fname[128];
		
		if(rows)
		{
			new fam[128];
			cache_get_value_name(0, "name", fam);
			format(fname, 128, fam);
		}
		else
		{
			format(fname, 128, "None");
		}

		format(header,sizeof(header),"Statistics "WHITE_E"("BLUE_E"%s"WHITE_E")", ReturnTime());
		format(gstr,sizeof(gstr),""RED_E"In Character"WHITE_E"\n");
		format(gstr,sizeof(gstr),"%sGender: [%s] | Money: ["LG_E"%s"WHITE_E"] | Bank: ["LG_E"%s"WHITE_E"] | Rekening Bank: [%d]\n", gstr, (gender == 2) ? ("Female") : ("Male"), FormatMoney(money), FormatMoney(bmoney), brek);
		format(gstr,sizeof(gstr),"%sPhone Number: [%d] | Birdthdate: [%s] | Job: [%s] | Job2: [%s]\n", gstr, phone, age, GetJobName(job), GetJobName(job2));
		format(gstr,sizeof(gstr),"%sFaction: [%s] | Family: [%s] | Phone Status : [%s] | Twitter : [{0099ff}%s{ffffff}]\n\n", gstr, fac, fname, pstatus, twitter);
		format(gstr,sizeof(gstr),"%s"RED_E"Out of Character"WHITE_E"\n", gstr);
		format(gstr,sizeof(gstr),"%sUCP: [{15D4ED}%s{ffffff}] | Name: [{15D4ED}%s{ffffff}] | UID: [%d] | Level score: [%d/%d]\n", gstr, ucp, PlayersName, reg_id, levelup, scoremath);
		format(gstr,sizeof(gstr),"%sEmail: [%s] | Warning:[{ff0000}%d/20{ffffff}] | Last Login: [%s]\n", gstr, email, warn, lastlogin);
		format(gstr,sizeof(gstr),"%sStaff: [%s{FFFFFF}] | Time Played: [%d hour(s) %d minute(s) %02d second(s)] | Gold Coin: [{ffff00}%d{ffffff}]\n", gstr, GetStaffRank(admin), jam, menit, detik, coin);
		if(viptime != 0)
		{
			format(gstr,sizeof(gstr),"%sVIP Level: [%s{FFFFFF}] | VIP Time: [%s] | Roleplay Booster: [%s"WHITE_E"] | Boost Time: [%s]\n", gstr, name1, ReturnTimelapse(gettime(), viptime), boost, ReturnTimelapse(gettime(), boosttime));
		}
		else
		{
			format(gstr,sizeof(gstr),"%sVIP Level: [%s{FFFFFF}] | VIP Time: [None] | Roleplay Booster: [%s"WHITE_E"] | Boost Time: [%s]\n", gstr, name1, GetVipRank(vip), boost, ReturnTimelapse(gettime(), boosttime));
		}
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, header, gstr, "Close", "");
		
		cache_delete(checkfamily);
	}
	return true;
}

function CheckPlayerIP(playerid, zplayerIP[])
{
	new count = cache_num_rows(), datez, line[248], tstr[64], lstr[128];
	if(count)
	{
		datez = 0;
 		line = "";
 		format(line, sizeof(line), "Names matching IP: %s:\n\n", zplayerIP);
 		for(new i = 0; i != count; i++)
		{
			// Get the name  ache and append it to the dialog content
			cache_get_value_index(i, 0, lstr);
			strcat(line, lstr);
			datez ++;

			if(datez == 5)
				strcat(line, "\n"), datez = 0;
			else
				strcat(line, "\t\t");
		}

		tstr = "{ACB5BA}Aliases for {70CAFA}", strcat(tstr, zplayerIP);
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, tstr, line, "Close", "");
	}
	else
 	{
		Error(playerid, "No other accounts from this IP!");
	}
	return 1;
}

stock GetDistance( Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2 )
{
    return floatround( floatsqroot( ( (x1 - x2) * (x1 - x2) ) + ( (y1 - y2) * (y1 - y2) ) + ( (z1 - z2) * (z1 - z2) ) )  );
}

function CheckPlayerIP2(playerid, zplayerIP[])
{
	new rows = cache_num_rows(), datez, line[248], tstr[64], lstr[128];
	if(!rows)
	{
		Error(playerid, "No other accounts from this IP!");
	}
	else
 	{
 		datez = 0;
 		line = "";
 		format(line, sizeof(line), "Names matching IP: %s:\n\n", zplayerIP);
 		for(new i = 0; i != rows; i++)
		{
			// Get the name from the cache and append it to the dialog content
			cache_get_value_index(i, 0, lstr);
			strcat(line, lstr);
			datez ++;

			if(datez == 5)
				strcat(line, "\n"), datez = 0;
			else
				strcat(line, "\t\t");
		}

		tstr = "{ACB5BA}Aliases for {70CAFA}", strcat(tstr, zplayerIP);
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, tstr, line, "Close", "");
	}
	return 1;
}

function Detectare_Intrare(playerid)
{
    if(Seconds_timer[playerid] == 120)
	{
        Seconds_timer[playerid] = 0;
        inJOB[playerid] = 0;
        ResetPlayerWeapons(playerid);
        DestroyVehicle(Car_Job[playerid]);
        KillTimer(Meeters_BTWDeer[playerid]);
        DestroyObject(Hunter_Deer[playerid]);
        PlayerTextDrawHide(playerid, DistanceTD[playerid]);
        DisablePlayerCheckpoint(playerid);
        Deep_Deer[playerid] = 0;
        Deer[playerid] = 0;
        Shoot_Deer[playerid] = 0;
        KillTimer(timer_Car[playerid]);
    }
	else
	{
        Seconds_timer[playerid]++;
    }
    return 1;
}
function KeluarKendaraanKerja(playerid)
{
    if(TimerKeluar[playerid] == 15)
	{
        TimerKeluar[playerid] = 0;
        DestroyVehicle(pData[playerid][pKendaraanKerja]);
		DestroyVehicle(pData[playerid][pTrailer]);
        KillTimer(KeluarKerja[playerid]);
        DisablePlayerCheckpoint(playerid);
        DisablePlayerRaceCheckpoint(playerid);
    }
	else
	{
        TimerKeluar[playerid]++;
    }
    return 1;
}
 
function Done_Deer(playerid) 
{
	new mesaj[200];
    format(mesaj, sizeof(mesaj), "{1e90ff}(JOB):{FFFFFF} For the skin of this deer you received {7cfc00}${FFFFFF}$500.");
    SendClientMessage(playerid, -1, mesaj);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    ClearAnimations(playerid, 0);
    GivePlayerMoneyEx(playerid, 500);
    DestroyObject(Hunter_Deer[playerid]);
    TogglePlayerControllable(playerid, 1);
    SetTimerEx("Next_Deer", 1000, false, "i", playerid);
 
    return 1;
}
 
function Detect_M(playerid) {
    new Float:x, Float:y, Float:z, mesaj[256];
    GetPlayerPos(playerid, x, y, z);
    if(Deer[playerid] == 1) {
        Meeters[playerid] = GetDistance(x, y, z, 2046.7698, -799.4532, 127.0796);
    }else if(Deer[playerid] == 2) {
        Meeters[playerid] = GetDistance(x, y, z, 2021.18176, -494.02066, 76.19036);
    }else if(Deer[playerid] == 3) {
        Meeters[playerid] = GetDistance(x, y, z, 1632.5769, -599.7444, 62.0889);
    }else if(Deer[playerid] == 4) {
        Meeters[playerid] = GetDistance(x, y, z, 1741.4386, -979.5817, 36.9209);
    }else if(Deer[playerid] == 5) {
        Meeters[playerid] = GetDistance(x, y, z, 2553.6780, -963.4338, 82.0169);
    }else if(Deer[playerid] == 6) {
        Meeters[playerid] = GetDistance(x, y, z, 2637.4963, -380.2195, 58.2060);
    }else if(Deer[playerid] == 7) {
        Meeters[playerid] = GetDistance(x, y, z, 2406.9773, -403.4681, 72.4926);
    }
 
    format(mesaj, sizeof(mesaj), "Distance_%dM", Meeters[playerid]);
    InfoMsg(playerid, mesaj);
 
    return 1;
}
 
function Next_Deer(playerid) {
    new rand = random(8), mesaj[256];
    format(mesaj, sizeof(mesaj), "{1e90ff}(JOB):{FFFFFF} Go and kill the deer from a distance of at least 20M to be rewarded. ");
    SendClientMessage(playerid, -1, mesaj);
    switch(rand) {
        case 1: {
            Deer[playerid] = 1;
            Hunter_Deer[playerid] = CreateObject(19315, 2046.76978, -799.45319, 127.07957,   0.00000, 0.00000, 0.00000);
            SetPlayerCheckpoint(playerid, 2046.76978, -799.45319, 127.07957, 1.0);
            Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
        }
        case 2: {
            Deer[playerid] = 3;
            Hunter_Deer[playerid] = CreateObject(19315, 1632.57690, -599.74438, 62.08893,   0.00000, 0.00000, -52.38000);
            SetPlayerCheckpoint(playerid, 1632.5769, -599.7444, 62.0889, 1.0);
            Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
        }
        case 3: {
            Deer[playerid] = 4;
            Hunter_Deer[playerid] = CreateObject(19315, 1741.43860, -979.58167, 36.92095,   0.00000, 0.00000, -7.38000);
            SetPlayerCheckpoint(playerid, 1741.4386, -979.5817, 36.9209, 1.0);
            Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
        }
        case 4: {
            Deer[playerid] = 5;
            Hunter_Deer[playerid] = CreateObject(19315, 2553.67798, -963.43384, 82.01694,   0.00000, 0.00000, 0.00000);
            SetPlayerCheckpoint(playerid, 2553.6780, -963.4338, 82.0169, 1.0);
            Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
        }
        case 5: {
            Deer[playerid] = 6;
            Hunter_Deer[playerid] = CreateObject(19315, 2637.49634, -380.21954, 58.20603,   0.00000, 0.00000, -49.26000);
            SetPlayerCheckpoint(playerid, 2637.4963, -380.2195, 58.2060, 1.0);
            Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
        }
        case 6: {
            Deer[playerid] = 7;
            Hunter_Deer[playerid] = CreateObject(19315, 2406.97729, -403.46808, 72.49255,   0.00000, 0.00000, 0.00000);
            SetPlayerCheckpoint(playerid, 2406.9773, -403.4681, 72.4926, 1.0);
            Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
        }
        default: {
            Deer[playerid] = 2;
            Hunter_Deer[playerid] = CreateObject(19315, 2021.18176, -494.02066, 76.19036,   0.00000, 0.00000, -71.64002);
            SetPlayerCheckpoint(playerid, 2021.18176, -494.02066, 76.19036, 1.0);
            Meeters_BTWDeer[playerid] = SetTimerEx("Detect_M", 1000, true, "i", playerid);
        }
    }
 
    return 1;
}

stock PlayerPlaySoundEx(playerid, sound)
{
	new
		Float:x,
		Float:y,
		Float:z;

	GetPlayerPos(playerid, x, y, z);

	foreach (new i : Player) if (IsPlayerInRangeOfPoint(i, 20.0, x, y, z)) {
		PlayerPlaySound(i, sound, x, y, z);
	}
	return 1;
}

function JailPlayer(playerid)
{
	SetPlayerPositionEx(playerid, 563.0270,-2197.3640,4.7329,89.1805, 2000);
	SetPlayerInterior(playerid, 1);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerWantedLevel(playerid, 0);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	//ResetPlayerWeaponsEx(playerid);
	pData[playerid][pInBiz] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInFamily] = -1;	
	pData[playerid][pCuffed] = 0;
	PlayerPlaySound(playerid, 1186, 0, 0, 0);
	return true;
}

//-----------[ Banneds Function ]----------

function OnOBanQueryData(adminid, NameToBan[], banReason[], banTime)
{
	new mstr[512];
	mstr = "";
	if(!cache_num_rows())
	{
		Error(adminid, "Account '%s' does not exist.", NameToBan);
	}
	else
	{
		new datez, PlayerIP[16];
		cache_get_value_index(0, 0, PlayerIP);
		if(banTime != 0)
	    {
			datez = gettime() + (banTime * 86400);
            Servers(adminid, "You have temp-banned %s (IP: %s) from the server.", NameToBan, PlayerIP);
			SendClientMessageToAllEx(COLOR_RED, "Server: "GREY2_E"Admin %s telah membanned offline player %s selama %d hari. [Reason: %s]", pData[adminid][pAdminname], NameToBan, banTime, banReason);
		}
		else
		{
			Servers(adminid, "You have permanent-banned %s (IP: %s) from the server.", NameToBan, PlayerIP);
			SendClientMessageToAllEx(COLOR_RED, "Server: "GREY2_E"Admin %s telah membanned offline player %s secara permanent. [Reason: %s]", pData[adminid][pAdminname], NameToBan, banReason);
		}
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', '%s', '%s', UNIX_TIMESTAMP(), %d)", NameToBan, PlayerIP, pData[adminid][pAdminname], banReason, datez);
		mysql_tquery(g_SQL, query);
	}
	return true;
}


//-------------[ Player Update Function ]----------

function DragUpdate(playerid, targetid)
{
    if(pData[targetid][pDragged] && pData[targetid][pDraggedBy] == playerid)
    {
        static
        Float:fX,
        Float:fY,
        Float:fZ,
        Float:fAngle;

        GetPlayerPos(playerid, fX, fY, fZ);
        GetPlayerFacingAngle(playerid, fAngle);

        fX -= 3.0 * floatsin(-fAngle, degrees);
        fY -= 3.0 * floatcos(-fAngle, degrees);

        SetPlayerPos(targetid, fX, fY, fZ);
        SetPlayerInterior(targetid, GetPlayerInterior(playerid));
        SetPlayerVirtualWorld(targetid, GetPlayerVirtualWorld(playerid));
		//ApplyAnimation(targetid, "PED", "BIKE_fall_off", 4.1, 0, 1, 1, 1, 0, 1);
		ApplyAnimation(targetid,"PED","WALK_civi",4.1,1,1,1,1,1);
    }
    return 1;
}

function UnfreezeSleep(playerid)
{
    TogglePlayerControllable(playerid, 1);
    pData[playerid][pEnergy] = 100;
	pData[playerid][pHunger] -= 3;
    ClearAnimations(playerid);
	StopLoopingAnim(playerid);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	InfoTD_MSG(playerid, 3000, "Sleeping Done!");
	return 1;
}

function RefullCar(playerid, vehicleid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	//if(!IsValidVehicle(vehicleid)) return 0;
	if(pData[playerid][pActivityStatus] != 1) return 0;
	if(GetNearestVehicleToPlayer(playerid, 3.8, false) == vehicleid)
    {
		if(pData[playerid][pActivityTime] >= 100 && IsValidVehicle(vehicleid))
		{
			new fuels = GetVehicleFuel(vehicleid);
		
			SetVehicleFuel(vehicleid, fuels+300);
			InfoTD_MSG(playerid, 8000, "Refulling done!");
			//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has successfully refulling the vehicle.", ReturnName(playerid));
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pActivityStatus] = 0;
			pData[playerid][pActivityTime] = 0;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		}
		else if(pData[playerid][pActivityTime] < 100 && IsValidVehicle(vehicleid))
		{
			pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		}
		else
		{
			Error(playerid, "Refulling fail! Anda tidak berada didekat kendaraan tersebut!");
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pActivityStatus] = 0;
			pData[playerid][pActivityTime] = 0;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		}
	}
	else
	{
		Error(playerid, "Refulling fail! Anda tidak berada didekat kendaraan tersebut!");
		KillTimer(pData[playerid][pActivity]);
		pData[playerid][pActivityStatus] = 0;
		pData[playerid][pActivityTime] = 0;
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		return 1;
	}
	return 1;
}

//Bank
function SearchRek(playerid, rek)
{
	if(!cache_num_rows())
	{
		// Rekening tidak ada
		Error(playerid, "Rekening bank "YELLOW_E"'%d' "WHITE_E"tidak terdaftar!", rek);
		pData[playerid][pTransfer] = 0;
	    
	}
	else
	{
	    // Proceed
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "SELECT username,brek FROM players WHERE brek='%d'", rek);
		mysql_tquery(g_SQL, query, "SearchRek2", "id", playerid, rek);
	}
}

function SearchRek2(playerid, rek)
{
	if(cache_num_rows())
	{
		new name[128], brek, mstr[128];
		cache_get_value_index(0, 0, name);
		cache_get_value_index_int(0, 1, brek);
		
		//format(pData[playerid][pTransferName], 128, "%s" name);
		pData[playerid][pTransferName] = name;
		pData[playerid][pTransferRek] = brek;
		format(mstr, sizeof(mstr), ""WHITE_E"No Rek Target: "YELLOW_E"%d\n"WHITE_E"Nama Target: "YELLOW_E"%s\n"WHITE_E"Jumlah: "GREEN_E"%s\n\n"WHITE_E"Anda yakin akan melanjutkan mentransfer?", brek, name, FormatMoney(pData[playerid][pTransfer]));
		ShowPlayerDialog(playerid, DIALOG_BANKCONFIRM, DIALOG_STYLE_MSGBOX, ""LB_E"Bank", mstr, "Transfer", "Cancel");
	}
	return true;
}

//----------[ JOB FUNCTION ]-------------

//Server Timer
function pCountDown()
{
	Count--;
	if(0 >= Count)
	{
		Count = -1;
		KillTimer(countTimer);
		foreach(new ii : Player)
		{
 			if(showCD[ii] == 1)
   			{
   				GameTextForPlayer(ii, "~w~GO~r~!~g~!~b~!", 2500, 6);
   				PlayerPlaySound(ii, 1057, 0, 0, 0);
   				showCD[ii] = 0;
   				if(IsAtEvent[ii] == 1)
   				{
   					TogglePlayerControllable(ii, 1);
   				}
			}
		}
	}
	else
	{
		foreach(new ii : Player)
		{
 			if(showCD[ii] == 1)
   			{
				GameTextForPlayer(ii, CountText[Count-1], 2500, 6);
				PlayerPlaySound(ii, 1056, 0, 0, 0);
   			}
		}
	}
	return 1;
}


//----------[ Other Function ]-----------

function SetPlayerToUnfreeze(playerid, Float:x, Float:y, Float:z, Float:a)
{
    if(!IsPlayerInRangeOfPoint(playerid, 15.0, x, y, z))
        return 0;

    pData[playerid][pFreeze] = 0;
    SetPlayerPos(playerid, x, y, z);
	SetPlayerFacingAngle(playerid, a);
    TogglePlayerControllable(playerid, 1);
    return 1;
}

function KickTimer(playerid)
{
	KickEx(playerid);
	return 1;
}

stock GetName(playerid)
{
	new name[MAX_PLAYER_NAME];
 	GetPlayerName(playerid,name,sizeof(name));
	return name;
}

function CheckPlayerSpawn3Titik(playerid)
{
	if(pData[playerid][pSpawnList] == 1)
	{
		SetPlayerPos(playerid, 1685.559448,-2239.149658,13.546875);
		SetPlayerFacingAngle(playerid, 175.810470);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		pData[playerid][pSpawnList] = 0;	
		ClearAnimations(playerid);
	}
}


function CheckUCP(playerid, nameucp[])
{
	new count = cache_num_rows(), datez, line[248], tstr[64], lstr[128];
	if(count)
	{
		datez = 0;
 		line = "";
 		format(line, sizeof(line), ">> List <<\n\n", nameucp);
 		for(new i = 0; i != count; i++)
		{
			// Get the name  ache and append it to the dialog content
			cache_get_value_index(i, 0, lstr);
			strcat(line, lstr);
			datez ++;

			if(datez == 5)
				strcat(line, "\n"), datez = 0;
			else
				strcat(line, "\n");
		}

		tstr = "UCP: {ff0000}", strcat(tstr, nameucp);
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, tstr, line, "Close", "");
	}
	else
 	{
		Error(playerid, "UCP %s tidak di temukan", nameucp);
	}
	return 1;
}

GetPlayerNameEx(playerid)
{
	new
		name[MAX_PLAYER_NAME];

	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

IsPlayerOnline(const name[], &id = INVALID_PLAYER_ID)
{
	foreach(new i : Player)
	{
	    if(!strcmp(GetPlayerNameEx(i), name))
	    {
	        id = i;
	        return 1;
		}
	}

	id = INVALID_PLAYER_ID;
	return 0;
}
