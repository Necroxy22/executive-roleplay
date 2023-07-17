task onlineTimer[1000]()
{	
	//Date and Time Textdraw
	new hours,
	minutes,
	days,
	months,
	years;
	up_seconds ++;
	if(up_seconds == 60)
	{
	    up_seconds = 0, up_minutes ++;
	    if(up_minutes == 60)
	    {
	        up_minutes = 0, up_hours ++;
	        if(up_hours == 24) up_hours = 0, up_days ++;
			new tstr[128], rand = RandomEx(0, 20);
			if(hours > 18)
			{
				SetWorldTime(0);
				WorldTime = 0;
			}
			else
			{
				SetWorldTime(hours);
				WorldTime = hours;
			}
			SetWeather(rand);
			WorldWeather = rand;

			new dateNow[20], timeNow[20];
			format(dateNow, sizeof(dateNow), "%02i/%02i/%02i", days, months, years);
			format(timeNow, sizeof(timeNow), "%02d:%02d", hours, minutes);

			new DCC_Embed:msgEmbed;
			msgEmbed = DCC_CreateEmbed();
			format(tstr, sizeof tstr, "[:timer:]: Server has been online for %s.", Uptime());
			DCC_AddEmbedField(msgEmbed, "Executive Uptime", tstr);
			format(tstr, sizeof tstr, "[:busts_in_silhouette:]: Players in the city %s/%d.", number_format(Iter_Count(Player)), GetMaxPlayers());
			DCC_AddEmbedField(msgEmbed, "Executive Player", tstr);
			format(tstr, sizeof tstr, "[:calendar_spiral:]: Now date in server %s, And now time on the server %s.", dateNow, timeNow);
			DCC_AddEmbedField(msgEmbed, "Executive time now", tstr);
			DCC_SetEmbedColor(msgEmbed, 0x00ff00);
			DCC_SetEmbedFooter(msgEmbed, "Executive Server Status || #staytune");
			DCC_SendChannelEmbedMessage(g_Discord_Serverstatus, msgEmbed);

			// Sync Server
			mysql_tquery(g_SQL, "OPTIMIZE TABLE `bisnis`,`houses`,`toys`,`vehicle`");
			//SetTimer("changeWeather", 10000, false);
		}
	}
	return 1;
}

ptask PlayerDelay[1000](playerid)
{
	if(pData[playerid][IsLoggedIn] == false) return 0;
	NgecekCiter(playerid);
		//VIP Expired Checking
	if(pData[playerid][pVip] > 0)
	{
		if(pData[playerid][pVipTime] != 0 && pData[playerid][pVipTime] <= gettime())
		{
			Info(playerid, "Maaf, Level VIP player anda sudah habis! sekarang anda adalah player biasa!");
			pData[playerid][pVip] = 0;
			pData[playerid][pVipTime] = 0;
		}
	}
		//ID Card Expired Checking
	if(pData[playerid][pIDCard] > 0)
	{
		if(pData[playerid][pIDCardTime] != 0 && pData[playerid][pIDCardTime] <= gettime())
		{
			Info(playerid, "Masa berlaku ID Card anda telah habis, silahkan perpanjang kembali!");
			pData[playerid][pIDCard] = 0;
			pData[playerid][pIDCardTime] = 0;
		}
	}

	if(pData[playerid][pExitJob] != 0 && pData[playerid][pExitJob] <= gettime())
	{
		Info(playerid, "Now you can exit from your current job!");
		pData[playerid][pExitJob] = 0;
	}
	if(pData[playerid][pDriveLic] > 0)
	{
		if(pData[playerid][pDriveLicTime] != 0 && pData[playerid][pDriveLicTime] <= gettime())
		{
			Info(playerid, "Masa berlaku Driving anda telah habis, silahkan perpanjang kembali!");
			pData[playerid][pDriveLic] = 0;
			pData[playerid][pDriveLicTime] = 0;
		}
	}
	if(pData[playerid][pWeaponLic] > 0)
	{
		if(pData[playerid][pWeaponLicTime] != 0 && pData[playerid][pWeaponLicTime] <= gettime())
		{
			Info(playerid, "Masa berlaku License Weapon anda telah habis, silahkan perpanjang kembali!");
			pData[playerid][pWeaponLic] = 0;
			pData[playerid][pWeaponLicTime] = 0;
		}
	}
	if(pData[playerid][pJobTime] > 0)
	{
		pData[playerid][pJobTime]--;
	}
	if(pData[playerid][pSideJobTime] > 0)
	{
		pData[playerid][pSideJobTime]--;
	}
	if(pData[playerid][pBusTime] > 0)
	{
		pData[playerid][pBusTime]--;
	}
	if(pData[playerid][pSparepartTime] > 0)
	{
		pData[playerid][pSparepartTime]--;
	}
	//Twitter Post
	if(pData[playerid][pTwitterPostCooldown] > 0)
	{
		pData[playerid][pTwitterPostCooldown]--;
	}
	//Twitter Changename
	if(pData[playerid][pTwitterNameCooldown] > 0)
	{
		pData[playerid][pTwitterNameCooldown]--;
	}

		// Duty Delay
	if(pData[playerid][pDutyHour] > 0)
	{
		pData[playerid][pDutyHour]--;
	}
		// Rob Delay
	if(pData[playerid][pRobTime] > 0)
	{
		pData[playerid][pRobTime]--;
	}
		// Get Loc timer
	if(pData[playerid][pSuspectTimer] > 0)
	{
		pData[playerid][pSuspectTimer]--;
	}
	if(pData[playerid][pDelayIklan] > 0)
	{
		pData[playerid][pDelayIklan]--;
	}
		//Warn Player Check
	if(pData[playerid][pWarn] >= 20)
	{
		new ban_time = gettime() + (5 * 86400), query[512], PlayerIP[16], giveplayer[24];
		GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
		GetPlayerName(playerid, giveplayer, sizeof(giveplayer));
		pData[playerid][pWarn] = 0;
			//SetPlayerPosition(playerid, 227.46, 110.0, 999.02, 360.0000, 10);
		BanPlayerMSG(playerid, playerid, "20 Total Warning", true);
		SendClientMessageToAllEx(COLOR_RED, "Server: "GREY2_E"Player %s(%d) telah otomatis dibanned permanent dari server. [Reason: 20 Total Warning]", giveplayer, playerid);

		mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', 'Server Ban', '20 Total Warning', %i, %d)", giveplayer, PlayerIP, gettime(), ban_time);
		mysql_tquery(g_SQL, query);
		KickEx(playerid);
	}
	return 1;
}
ptask playerTimer[1000](playerid)
{
	if(pData[playerid][IsLoggedIn] == true)
	{
		pData[playerid][pPaycheck] ++;
		pData[playerid][pSeconds] ++, pData[playerid][pCurrSeconds] ++;
		if(pData[playerid][pOnDuty] >= 1)
		{
			pData[playerid][pOnDutyTime]++;
		}
		if(theftInfo[tTime] > 0)
		{
			theftInfo[tTime]--;
		}
		if(pData[playerid][pSeconds] == 60)
		{
			new scoremath = ((pData[playerid][pLevel])*5);

			pData[playerid][pMinutes]++, pData[playerid][pCurrMinutes] ++;
			pData[playerid][pSeconds] = 0, pData[playerid][pCurrSeconds] = 0;

			switch(pData[playerid][pMinutes])
			{				
				case 40:
				{
					if(pData[playerid][pPaycheck] >= 600)
					{
					    pData[playerid][pPaycheck] = 0;
					    pData[playerid][pBankMoney] += 150;
					    ShowInfo(playerid, "Mendapat kompensasi $150", BOXCOLOR_BLUE);
					}
				}
				case 60:
				{
					if(pData[playerid][pPaycheck] >= 600)
					{
					    pData[playerid][pPaycheck] = 0;
					    pData[playerid][pBankMoney] += 150;
					    ShowInfo(playerid, "Mendapat kompensasi $150", BOXCOLOR_BLUE);
					}

					pData[playerid][pHours] ++;
					pData[playerid][pLevelUp] += 1;
					pData[playerid][pMinutes] = 0;
					UpdatePlayerData(playerid);

					if(pData[playerid][pLevelUp] >= scoremath)
					{
						pData[playerid][pLevel] += 1;
						pData[playerid][pHours] ++;
						SetPlayerScore(playerid, pData[playerid][pLevel]);
					}
				}
			}
			if(pData[playerid][pCurrMinutes] == 60)
			{
				pData[playerid][pCurrMinutes] = 0;
				pData[playerid][pCurrHours] ++;
			}
		}
	}
	return 1;
}
