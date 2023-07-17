CMD:nikahan(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
		return ErrorMsg(playerid, "Anda bukan administrator Executive");
    if(Nikahan == false)
    {
        Nikahan = true;
    	SuccesMsg(playerid, "Anda telah mengaktifkan makanan di pernikahan");
    }
    else
    {
        Nikahan = false;
    	SuccesMsg(playerid, "Anda telah menonaktifkan makanan di pernikahan");
    }
    return 1;
}
CMD:acmds(playerid)
{
	if(pData[playerid][pAdmin] < 1)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new line3[2480];
	if(pData[playerid][pAdmin] >= 1)
	{
		strcat(line3, "{ffff00}[Staff]: {ffffff}/reports, /ar, /dr, /asks, /ans, /nonrpname\n\n");
		strcat(line3, "{ff0000}[Helper]: {ffffff}/a, /aduty, /asay, /arevive, /sendto, /spec, /getip, /aka, /akaip, /vmodels, /vehname\n");
		strcat(line3, "{ff0000}[Helper]: {ffffff}/respawnsapd, /respawnsags, /respawnsamd, /respawnsana, /respawndmv, /respawnjobs\n\n");
	}
	if(pData[playerid][pAdmin] >= 2)
	{
		strcat(line3, "{ff0000}[Administrator]: {ffffff}/makequiz, /adminjail, /togooc /goto, /freeze, /unfreeze, /slap, /caps, /aitems, /astats, /adelays\n");
		strcat(line3, "{ff0000}[Administrator]: {ffffff}/ostats, /jetpack, /owarn, /ojail, /jail, /unjail, /kick, /ban, /unban, /warn, /respawnrad, /sethp, /setbone\n");
		strcat(line3, "{ff0000}[Administrator]: {ffffff}/veh, /destroyveh, /setadminname, /givemoneyall, /checkucp\n\n");
		
	}
	if(pData[playerid][pAdmin] >= 3)
	{
		strcat(line3, "{ff0000}[General A]: {ffffff}/gethere, /peject, /acuff, /auncuff, /banucp, /setam, /afuel, /afix, /setskin\n");
		strcat(line3, "{ff0000}[General A]: {ffffff}/ann, /cd, /oban, /banip, /unbanip, /reloadweap, /resetweap, /setvw, /setint, /setstock\n\n");
	}
	if(pData[playerid][pAdmin] >= 4)
	{
		strcat(line3, "{ff0000}[Head Admin]: {ffffff}/arelease, /settime, /setweather, /gotoco, /setlevel, /setname, /setvip, /giveweap\n");
		strcat(line3, "{ff0000}[Head Admin]: {ffffff}/setfaction, /setleader, /takemoney, /takegold, /sethelperlevel, /setmoney, /givemoney,/setpassword, /clearallchat\n\n");
	
	}
	if(pData[playerid][pAdmin] >= 5)
	{
		strcat(line3, "{ff0000}[Management]: {ffffff}/sethbe, /setbankmoney, /givebankmoney, /explode, /setadminlevel, /setgold, /givegold, /takegold\n");
		strcat(line3, "{ff0000}[Management]: {ffffff}/setprice, /anticheat, /setstat, /createactor, /editactor , /deleteactor, /gotoactor\n\n");
	}
	if(pData[playerid][pAdmin] >= 6)
	{
		strcat(line3, "{ff0000}[Developer]: {ffffff}/kickall, /anticheat\n\n");
	}
	
 	
	strcat(line3, "\n"BLUE_E"IndoLast:RP "WHITE_E"- Anti-Cheat is actived.\n\
	"PINK_E"NOTE: All admin commands log is saved in database! | Abuse Commands? Kick And Demote Premanent!.");
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Executive - Bantuan Admin", line3, "OK","");
	return true;
}
CMD:beton(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	SetPlayerHealth(playerid, 999999);
	Info(playerid, "SI KONTOL PAKEK BETON CUIH.");
	SendClientMessageToAll(COLOR_LIGHTRED, "ADIK ADIK ADA ADMIN PAKEK BETON, TOLONG REPORT YAH");
	return 1;
}
/*CMD:playerhax(playerid, params[])
{
    new string[400];
    format(string, sizeof(string), "%s Player Ini Telah Di Kick (USING APK CHENH4X)", GetName(playerid));
    SendClientMessageToAll(COLOR_LIGHTRED, string);
    KickEx(playerid);
    format(string, sizeof string, " __***USING APK CHENH4X***__\n***Username: %s\nUCP Name: %s\nIP Address: %d\nTelah Di Kick (USING APK CHENH4X)***", GetName(playerid), pData[playerid][pUCP], pData[playerid][pIP]);
    new DCC_Embed:CHENH4X = DCC_CreateEmbed("CHENH4X","");
    DCC_SetEmbedThumbnail(CHENH4X, "https://images-ext-1.discordapp.net/external/9Qj0AG_jwq-4SkZHurcCDWsTIEW6BF_NP7ZMK6GJ-Ek/https/www.dewa.gg/wp-content/uploads/2022/01/f6c256a1deeb17e117c76405c3f701d5b5dfc632.png?width=558&height=314");
    DCC_SetEmbedTitle(CHENH4X, "***KICK INFO***");
    DCC_SetEmbedDescription(CHENH4X, string);
    DCC_SendChannelEmbedMessage(g_Discord_CHENH4X,CHENH4X); 
    return 1;
}
CMD:jetpackhax(playerid, params[])
{
    new string[400];
    format(string, sizeof(string), "%s Player Ini Telah Di Kick (USING APK CHENH4X)", GetName(playerid));
    SendClientMessageToAll(COLOR_LIGHTRED, string);
    KickEx(playerid);
    format(string, sizeof string, " __***USING APK CHENH4X***__\n***Username: %s\nUCP Name: %s\nIP Address: %d\nTelah Di Kick (USING APK CHENH4X)***", GetName(playerid), pData[playerid][pUCP], pData[playerid][pIP]);
    new DCC_Embed:CHENH4X = DCC_CreateEmbed("CHENH4X","");
    DCC_SetEmbedThumbnail(CHENH4X, "https://images-ext-1.discordapp.net/external/9Qj0AG_jwq-4SkZHurcCDWsTIEW6BF_NP7ZMK6GJ-Ek/https/www.dewa.gg/wp-content/uploads/2022/01/f6c256a1deeb17e117c76405c3f701d5b5dfc632.png?width=558&height=314");
    DCC_SetEmbedTitle(CHENH4X, "***KICK INFO***");
    DCC_SetEmbedDescription(CHENH4X, string);
    DCC_SendChannelEmbedMessage(g_Discord_CHENH4X,CHENH4X); 
    return 1;
}*/

CMD:enableejrun(playerid, params[])
{
	SendClientMessageToAllEx(COLOR_RED, "AntiCmd: {778899}%s terkick karena menggunakan command ilegal [ Enableejrun ]", pData[playerid][pName]);
 	Kick(playerid);
	return 1;
}
CMD:weather1(playerid, params[])
{
	SendClientMessageToAllEx(COLOR_RED, "AntiCmd: {778899}%s terkick karena menggunakan command ilegal [ Weather ]", pData[playerid][pName]);
 	Kick(playerid);
	return 1;
}
CMD:weather2(playerid, params[])
{
	SendClientMessageToAllEx(COLOR_RED, "AntiCmd: {778899}%s terkick karena menggunakan command ilegal [ Weather ]", pData[playerid][pName]);
 	Kick(playerid);
	return 1;
}
CMD:weather3(playerid, params[])
{
	SendClientMessageToAllEx(COLOR_RED, "AntiCmd: {778899}%s terkick karena menggunakan command ilegal [ Weather ]", pData[playerid][pName]);
 	Kick(playerid);
	return 1;
}
CMD:weather4(playerid, params[])
{
	SendClientMessageToAllEx(COLOR_RED, "AntiCmd: {778899}%s terkick karena menggunakan command ilegal [ Weather ]", pData[playerid][pName]);
 	Kick(playerid);
	return 1;
}
CMD:weather5(playerid, params[])
{
	SendClientMessageToAllEx(COLOR_RED, "AntiCmd: {778899}%s terkick karena menggunakan command ilegal [ Weather ]", pData[playerid][pName]);
 	Kick(playerid);
	return 1;
}
CMD:weather6(playerid, params[])
{
	SendClientMessageToAllEx(COLOR_RED, "AntiCmd: {778899}%s terkick karena menggunakan command ilegal [ Weather ]", pData[playerid][pName]);
 	Kick(playerid);
	return 1;
}


CMD:weather7(playerid, params[])
{
	SendClientMessageToAllEx(COLOR_RED, "AntiCmd: {778899}%s terkick karena menggunakan command ilegal [ Weather ]", pData[playerid][pName]);
 	Kick(playerid);
	return 1;
}
CMD:weather8(playerid, params[])
{
	SendClientMessageToAllEx(COLOR_RED, "AntiCmd: {778899}%s terkick karena menggunakan command ilegal [ Weather ]", pData[playerid][pName]);
 	Kick(playerid);
	return 1;
}
CMD:weather9(playerid, params[])
{
	SendClientMessageToAllEx(COLOR_RED, "AntiCmd: {778899}%s terkick karena menggunakan command ilegal [ Weather ]", pData[playerid][pName]);
 	Kick(playerid);
	return 1;
}
CMD:speedheck(playerid, params[])
{
	SendClientMessageToAllEx(COLOR_RED, "AntiCmd: {778899}%s terkick karena menggunakan command ilegal [ Speed Heck ]", pData[playerid][pName]);
 	Kick(playerid);
	return 1;
}

CMD:giveredmoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    SyntaxMsg(playerid, "/givemoney <ID/Name> <money>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player not connected!");

	pData[otherid][pRedMoney] += money;

	Servers(playerid, "Kamu telah memberikan redmoney %s(%d) dengan jumlah %s!", pData[otherid][pName], otherid, FormatMoney(money));
	Servers(otherid, "Admin %s telah memberikan redmoney kepada anda dengan jumlah %s!", pData[playerid][pAdminname], FormatMoney(money));

	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("GIVEREDMONEY", playerid, otherid, tmp);
	return 1;
}

CMD:setphone(playerid, params[])
{
    if(pData[playerid][pAdmin] < 6)
        return ErrorMsg(playerid, "You don't have use permission");

    new targetid, option;
    if(sscanf(params,"ui", targetid, option)) return SyntaxMsg(playerid, "/setphone [player targetid or name] [number phone]");
    if(!IsPlayerConnected(targetid)) return ErrorMsg(playerid, "There is player not connect");
    Servers(playerid, "Kamu telah mengset phone number "BLUE_E"%s "YELLOW_E"menjadi = %s", ReturnName(targetid), option);
    Servers(targetid, "Admin "BLUE_E"%s "YELLOW_E"telah mengset Phone Number kamu menjadi menjadi = %s", ReturnName(playerid), option);
    pData[targetid][pPhone] = option;
    return 1;
}
CMD:setrek(playerid, params[])
{
    if(pData[playerid][pAdmin] < 6)
        return ErrorMsg(playerid, "You don't have use permission");

    new targetid, option;
    if(sscanf(params,"ui", targetid, option)) return SyntaxMsg(playerid, "/setrek [player targetid or name] [ bank rek]");
    if(!IsPlayerConnected(targetid)) return ErrorMsg(playerid, "There is player not connect");
    Servers(playerid, "Kamu telah mengset rekening "BLUE_E"%s "YELLOW_E"menjadi = %s", ReturnName(targetid), option);
    Servers(targetid, "Admin "BLUE_E"%s "YELLOW_E"telah mengset rekening kamu menjadi menjadi = %s", ReturnName(playerid), option);
    pData[targetid][pBankRek] = option;
    return 1;
}
CMD:gmx(playerid, params[])
{
		new String[256];
        if(pData[playerid][pAdmin] >= 6)
	    {
	    	if(CurGMX == 0)
	    	{
	    		format(String, sizeof(String), "GMX:"RED_E" %s "WHITE_E"has initiated a server restart, it will occur in the next "YELLOW_E"30 seconds.", pData[playerid][pAdminname]);
				SendClientMessageToAll(COLOR_LBLUE, String);
				SetTimer("DoGMX", 30000, false);
				CurGMX = 1;
	    	}
	    	else
	    	{
	        	SendClientMessage(playerid, COLOR_WHITE, "There already is a current GMX in execution.");
	    	}
	    }
		return 1;
}

CMD:mt(playerid, params[])
{
	if(pData[playerid][pAdmin] >= 6)
	{
		if(CurGMX == 0)
		{
			TextDrawShowForAll(BadaiInfo[0]);
			TextDrawShowForAll(BadaiInfo[1]);
			TextDrawShowForAll(BadaiInfo[2]);
			TextDrawShowForAll(BadaiInfo[3]);
			TextDrawShowForAll(BadaiInfo[4]);
			TextDrawShowForAll(BadaiInfo[5]);
			TextDrawShowForAll(BadaiInfo[6]);
			TextDrawShowForAll(BadaiInfo[7]);
			TextDrawShowForAll(BadaiInfo[8]);
			TextDrawShowForAll(BadaiInfo[9]);
			UpdateWeapons(playerid);
			UpdatePlayerData(playerid);
			SetTimer("DoGMX", 15000, false);
			CurGMX = 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_WHITE, "There already is a current SERVER in execution.");
		}
	}
	return 1;
}

CMD:setcs(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
	if(pData[playerid][pHelper] < 1)
        return ErrorMsg(playerid, "You don't have use permission");

	new targetid, option;
	if(sscanf(params,"ui", targetid, option)) return SyntaxMsg(playerid, "/setcs [player targetid or name] [0 = none 1 = approved]");
	if(!IsPlayerConnected(targetid)) return ErrorMsg(playerid, "There is player not connect");
	Servers(playerid, "Kamu telah mengset Character Story "BLUE_E"%s "YELLOW_E"menjadi = %s", ReturnName(targetid), option);
	Servers(targetid, "Admin "BLUE_E"%s "YELLOW_E"telah mengset Character Story kamu menjadi menjadi = %s", ReturnName(playerid), option);
	pData[targetid][pCs] = option;
	return 1;
}

CMD:arelease(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
        return ErrorMsg(playerid, "Kamu harus menjadi Admin level 5.");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    SyntaxMsg(playerid, "/arelease <ID/Name>");
	    return true;
	}

    if(otherid == INVALID_PLAYER_ID)
        return ErrorMsg(playerid, "Player tersebut belum masuk!");

	if(pData[otherid][pArrest] == 0)
	    return ErrorMsg(playerid, "The player isn't in arrest!");

	pData[otherid][pArrest] = 0;
	pData[otherid][pArrestTime] = 0;
	SetPlayerInterior(otherid, 0);
	SetPlayerVirtualWorld(otherid, 0);
	SetPlayerPositionEx(otherid, 1326.1808,-1354.0112,13.7228, 2000);
	SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);

	new str[150];
	format(str,sizeof(str),"Admin: %s mengeluarkan %s dari penjara!", GetRPName(playerid), GetRPName(otherid));
	LogServer("Admin", str);
	return true;
}

CMD:makequiz(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
	{
		new tmp[128], string[256], str[256], pr;
		if(sscanf(params, "s", tmp)) {
			SyntaxMsg(playerid, "/makequiz [option]");
			SyntaxMsg(playerid, "question, answer, price, end");
			Info(playerid, "Tolong buat jawabannya dulu.");
			return 1;
		}
		if(!strcmp(tmp, "question", true, 8))
		{
			if(sscanf(params, "s[128]s[256]", tmp, str)) return SyntaxMsg(playerid, "/makequiz question [question]");
			if (quiz == 1) return ErrorMsg(playerid, "Kuis sudah dimulai kamu bisa mengakhirinya dengan /makequiz end.");
			if (answermade == 0) return ErrorMsg(playerid, "tolong buat jawaban dulu...");
			if (qprs == 0) return ErrorMsg(playerid, "Tolong tambahkan hadiah terlebih dahulu.");
			format(string, sizeof(string), "{7fffd4}[QUIZ]: {ffff00}%s?, Hadiah {00FF00}$%d.", str, qprs);
			SendClientMessageToAll(0xFFFF00FF, string);
			SendClientMessageToAll(-1,"{ffff00}Anda bisa memberi jawaban dengan menggunakan /answer.");
			quiz = 1;
		}
		else if(!strcmp(tmp, "answer", true, 6))
		{
			if(sscanf(params, "s[128]s[256]", tmp, str)) return SyntaxMsg(playerid, "/makequiz answer [answer]");
			if (quiz == 1) return Info(playerid, "Kuis sudah dimulai kamu bisa mengakhirinya dengan /makequiz end.");
			answers = str;
			answermade = 1;
			format(string, sizeof(string), "Anda telah membuat jawaban, {00FF00}%s.", str);
			SendClientMessage(playerid, 0xFFFFFFFF, string);
		}
		else if(!strcmp(tmp, "price", true, 5))
		{
			if(sscanf(params, "s[128]d", tmp, pr)) return SyntaxMsg(playerid, "/makequiz price [amount]");
			if (quiz == 1) return ErrorMsg(playerid, "Kuis sudah dimulai kamu bisa mengakhirinya dengan / makequiz end.");
			if (answermade == 0) return ErrorMsg(playerid, " Membuat jawabannya lebih dulu...");
			if (pr <= 0) return ErrorMsg(playerid, "buat harga lebih besar dari 0!");
			qprs = pr;
			format(string, sizeof(string), "Anda telah menempatkan {00FF00}%d sebagai jumlah hadiah untuk kuis.", pr);
			SendClientMessage(playerid, 0xFFFFFFFF, string);
		}
		else if(!strcmp(tmp, "end", true, 3))
		{
			if (quiz == 0) return ErrorMsg(playerid, "Sayangnya tidak ada kuis dari admin server.");
			SendClientMessageToAll(0xFF0000FF, "Sayangnya Admin server telah mengakhiri kuis tersebut.");
			answermade = 0;
			quiz = 0;
			qprs = 0;
			answers = "";
		}
	}
	else return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	return 1;
}

CMD:answer(playerid, params[])
{
	new tmp[256], string[256];
	if (quiz == 0) return ErrorMsg(playerid, "Sayangnya tidak ada kuis dari admin server.");
	if (sscanf(params, "s[256]", tmp)) return SyntaxMsg(playerid, "/answer [jawaban]");
	if(strcmp(tmp, answers, true)==0)
	{
		GivePlayerMoneyEx(playerid, qprs);
		format(string, sizeof(string), "[QUIZ]: %s telah memberikan jawaban yang benar '%s' dari kuis dan mendapatkan hadiah {00FF00}%d.", ReturnName(playerid), answers, qprs);
		SendClientMessageToAll(0xFFFF00FF, string);
		answermade = 0;
		quiz = 0;
		qprs = 0;
		answers = "";
	}
	else
	{
		ErrorMsg(playerid,"Jawaban yang salah coba keberuntungan Anda lain kali.");
	}
	return 1;
}

CMD:hcmds(playerid)
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new line3[2480];
	strcat(line3, ""WHITE_E"Junior Helper Commands:"LB2_E"\n\
 	/aduty /h /asay /o /goto /sendto /gethere /freeze /unfreeze\n\
	/kick /slap /caps /acuff /auncuff /reports /ar /dr");

	strcat(line3, "\n\n"WHITE_E"Senior Helper Commands:"LB2_E"\n\
 	/spec /peject /astats /ostats /jetpack\n\
    /jail /unjail");

	strcat(line3, "\n\n"WHITE_E"Head Helper Commands:"LB2_E"\n\
	/respawnsapd /respawnsags /respawnsamd /respawnsana /respawnjobs\n");
 	
	strcat(line3, "\n"BLUE_E"ARP "WHITE_E"- Anti-Cheat is actived.\n\
	"PINK_E"NOTE: All admin commands log is saved in database! | Abuse Commands? Kick And Demote Premanent!.");
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"ARP: "YELLOW_E"Staff Commands", line3, "OK","");
	return true;
}

CMD:ahide(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
		if(pData[playerid][pHelper] == 0)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	PlayerData[playerid][pAhide] = (!PlayerData[playerid][pAhide]);
	SendClientMessageEx(playerid, COLOR_LIGHTRED, "INFO: {FFFFFF}You are now %s {FFFFFF}%s the admin list.", (PlayerData[playerid][pAhide]) ? ("Hidden") : ("Visible"), (PlayerData[playerid][pAhide]) ? ("from") : ("in"));
	return 1;
}
CMD:admins(playerid, params[])
{
	new count = 0;
	new location[4080], lstr[596];
    foreach (new i : Player) if (PlayerData[i][pAdmin] > 0 && !PlayerData[i][pAhide])
	{
		strcat(location,"Rank\tNickname\tAdmin Name\tPlayer ID\n",sizeof(location));
	
	if(count)
	{
		format(lstr,sizeof(lstr), "%s\t%s\t%s\t%d", GetStaffRank(i), pData[i][pName], PlayerData[i][pAdminname], i);
	}
		else format(lstr,sizeof(lstr), "%s\t%s\t%s\t%d", GetStaffRank(i), pData[i][pName], PlayerData[i][pAdminname], i);
		strcat(location,lstr,sizeof(location));
	}
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS,"Staff List | Kota Executive",location,"Tutup","");
	return 1;
}
CMD:bin(playerid, params[])
{
	for(new i = 0; i < MAX_Trash; i++)
	{
 		if(IsPlayerInRangeOfPoint(playerid, 2.3, TrashData[i][TrashX], TrashData[i][TrashY], TrashData[i][TrashZ]))
	{
	if(pData[playerid][pBotol] > 15) return ErrorMsg(playerid, "Anda tidak bisa membawa botol melebihi dari 15 botol");
	if(TrashData[i][Sampah] < 1) return ErrorMsg(playerid, "Tidak ada sampah di sini");
	if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid, "Tunggu Sebentar");
	{
			ShowProgressbar(playerid, "Memulung Sampah..", 1);
			pData[playerid][pBotol]++;
			ShowItemBox(playerid, "Botol", "ADD_1x", 1486, 2);
	  		Inventory_Update(playerid);
	    	TrashData[i][Sampah] -= 1;
			new query[128], str[512];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE trash SET sampah='%d' WHERE ID='%d'", TrashData[i][Sampah], i);
			mysql_tquery(g_SQL, query);
			Trash_Save(i);
	   		}
		}
	}
	return 1;
}
CMD:adminjail(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
		if(pData[playerid][pHelper] == 0)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	new count = 0, line3[512];
	foreach(new i:Player)
	{
		if(pData[i][pJail] > 0)
		{
			format(line3, sizeof(line3), "%s\n"WHITE_E"%s(ID: %d) [Jail Time: %d seconds]", line3, pData[i][pName], i, pData[i][pJailTime]);
			count++;
		}
	}
	if(count > 0)
	{
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Jail Player", line3, "Close", "");
	}
	else
	{
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Jail Player", "There are no player in jail!", "Close", "");
	}
	return 1;
}

//---------------------------[ Admin Level 1 ]--------------------
CMD:aduty(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return ErrorMsg(playerid, "Anda bukan staff Executive");
			
	if(!strcmp(pData[playerid][pAdminname], "None"))
		return ErrorMsg(playerid, "Kamu harus setting Nama Admin mu!");
	
	if(!pData[playerid][pAdminDuty])
    {
		if(pData[playerid][pAdmin] > 0)
		{
			SetPlayerColor(playerid, 0xFF000000);
			pData[playerid][pAdminDuty] = 1;
			SetPlayerName(playerid, pData[playerid][pAdminname]);
			SendStaffMessage(COLOR_YELLOW, "{7fffd4}%s telah on duty admin dengan nama %s.", pData[playerid][pName], pData[playerid][pAdminname]);
		}
		else
		{
			SetPlayerColor(playerid, COLOR_GREEN);
			pData[playerid][pAdminDuty] = 1;
			SetPlayerName(playerid, pData[playerid][pAdminname]);
			SendStaffMessage(COLOR_YELLOW, "{7fffd4}%s telah on helper duty dengan nama %s.", pData[playerid][pName], pData[playerid][pAdminname]);
		}
    }
    else
    {
        if(pData[playerid][pFaction] != -1 && pData[playerid][pOnDuty]) 
            SetFactionColor(playerid);
        else 
            SetPlayerColor(playerid, COLOR_WHITE);
                
        SetPlayerName(playerid, pData[playerid][pName]);
        pData[playerid][pAdminDuty] = 0;
        SendStaffMessage(COLOR_RED, "{7fffd4}%s telah off admin duty.", pData[playerid][pAdminname]);
    }
	return 1;
}

CMD:asay(playerid, params[]) 
{
    new text[225];

    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

    if(sscanf(params,"s[225]",text))
        return SyntaxMsg(playerid, "/asay [text]");
        
    SendClientMessageToAllEx(COLOR_RED,"{ff0000}[STAFF] (%s{ff0000}) "YELLOW_E"%s: "LG_E"%s", GetStaffRank(playerid), pData[playerid][pAdminname], ColouredText(text));
    return 1;
}


CMD:a(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	if(isnull(params))
	    return SyntaxMsg(playerid, "/a [admin chat]");
	    
	SendAdminMessage(COLOR_GREEN, "{3BBD44}(( Admin Chat | %s %s: %s ))", GetStaffRank(playerid), PlayerData[playerid][pAdminname], params);
	return 1;
}

CMD:togooc(playerid, params[])
{
    if(pData[playerid][pAdmin] < 2)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

    if(TogOOC == 0)
    {
        SendClientMessageToAllEx(COLOR_RED, "ExecutiveBot: {ffff00}Admin %s telah menonaktifkan global OOC chat.", pData[playerid][pAdminname]);
        TogOOC = 1;
    }
    else
    {
        SendClientMessageToAllEx(COLOR_RED, "ExecutiveBot: {ffff00}Admin %s telah mengaktifkan global OOC chat (DON'T SPAM).", pData[playerid][pAdminname]);
        TogOOC = 0;
    }
    return 1;
}

CMD:o(playerid, params[])
{
    if(TogOOC == 1 && pData[playerid][pAdmin] < 1 && pData[playerid][pHelper] < 1) 
            return ErrorMsg(playerid, "An administrator has disabled global OOC chat.");

    if(isnull(params))
        return SyntaxMsg(playerid, "/o [global OOC]");

    /*if(pData[playerid][pDisableOOC])
        return ErrorMsg(playerid, "You must enable OOC chat first.");*/

    if(strlen(params) < 90)
    {
        foreach (new i : Player) if(pData[i][IsLoggedIn] == true && pData[i][pSpawned] == 1)
        {
            if(pData[playerid][pAdmin] == 1) SendClientMessageEx(i, COLOR_PINK2, "[G] ADMINISTRATOR | %s: {FFFFFF}%s", pData[playerid][pAdminname], params);
            else if(pData[playerid][pAdmin] == 2) SendClientMessageEx(i, COLOR_PINK2, "[G] ADMINISTRATOR | %s: {FFFFFF}%s", pData[playerid][pAdminname], params);
            else if(pData[playerid][pAdmin] == 3) SendClientMessageEx(i, COLOR_PINK2, "[G] ADMINISTRATOR | %s: {FFFFFF}%s", pData[playerid][pAdminname], params);
            else if(pData[playerid][pAdmin] == 4) SendClientMessageEx(i, COLOR_PINK2, "[G] ADMINISTRATOR | %s: {FFFFFF}%s", pData[playerid][pAdminname], params);
            else if(pData[playerid][pAdmin] == 5) SendClientMessageEx(i, COLOR_PINK2, "[G] ADMINISTRATOR | %s: {FFFFFF}%s", pData[playerid][pAdminname], params);
            else if(pData[playerid][pAdmin] == 6) SendClientMessageEx(i, COLOR_PINK2, "[G] ADMINISTRATOR | %s: {FFFFFF}%s", pData[playerid][pAdminname], params);
			else if(pData[playerid][pHelper] > 0 && pData[playerid][pAdmin] == 0)
			{
				SendClientMessageEx(i, COLOR_PINK2, "[G] ADMINISTRATOR | %s: {FFFFFF}%s", pData[playerid][pAdminname], params);
			}
            else
            {
                SendClientMessageEx(i, COLOR_PINK2, "[G] WARGA | %s [%d]: {ffffff}%s", pData[playerid][pUCP], playerid, params);
            }
        }
    }
    else
        return ErrorMsg(playerid, "Teks yang anda masukan terlalu panjang, maksimal 90 kata");

    return 1;
}

CMD:id(playerid, params[])
{
	new otherid, vsamp[15];
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/id [playerid/PartOfName]");
	
	if(!IsPlayerConnected(otherid))
		return ErrorMsg(playerid, "No player online or name is not found!");

	if(IsPlayerCompat(playerid))
	{
		vsamp = "0.3DL-R1";
	}
	else
	{
		vsamp = "0.3.7 R4";
	}
	
	Servers(playerid, "Nama Karakter: %s | %s [%d] - Ping: (%d) - Client: (%s)", pData[otherid][pUCP], pData[otherid][pName], otherid, GetPlayerPing(otherid), vsamp);
	return 1;
}

CMD:goto(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/goto [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	SendPlayerToPlayer(playerid, otherid);
	new memek[500];
	format(memek,sizeof(memek),"%s telah teleport kepada anda.", pData[playerid][pName]);
	InfoMsg(otherid, memek);
	new str[500];
	format(str,sizeof(str),"Anda telah teleport kepada ~y~%s", pData[otherid][pName]);
	SuccesMsg(playerid, str);
	return 1;
}

CMD:sendto(playerid, params[])
{
    static
        type[24],
		otherid;

    if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

    if(sscanf(params, "us[32]", otherid, type))
    {
        SyntaxMsg(playerid, "/send [player] [name]");
        Info(playerid, "[NAMES]:{FFFFFF} ls, lv, sf, ooczone");
        return 1;
    }
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	if(!strcmp(type,"ls")) 
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER) 
		{
            SetVehiclePos(GetPlayerVehicleID(otherid),1482.0356,-1724.5726,13.5469);
        }
        else 
		{
            SetPlayerPosition(otherid,1482.0356,-1724.5726,13.5469,750);
        }
        SetPlayerFacingAngle(otherid,179.4088);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInBiz] = -1;
		pData[otherid][pInFamily] = -1;
    }
    else if(!strcmp(type,"sf")) 
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER) 
		{
            SetVehiclePos(GetPlayerVehicleID(otherid),-1425.8307,-292.4445,14.1484);
        }
        else 
		{
            SetPlayerPosition(otherid,-1425.8307,-292.4445,14.1484,750);
        }
        SetPlayerFacingAngle(otherid,179.4088);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInBiz] = -1;
		pData[otherid][pInFamily] = -1;
    }
    else if(!strcmp(type,"lv")) 
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER) 
		{
            SetVehiclePos(GetPlayerVehicleID(otherid),1686.0118,1448.9471,10.7695);
        }
        else 
		{
            SetPlayerPosition(otherid,1686.0118,1448.9471,10.7695,750);
        }
        SetPlayerFacingAngle(otherid,179.4088);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInBiz] = -1;
		pData[otherid][pInFamily] = -1;
    }
    else if(!strcmp(type,"ooczone")) 
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER) 
		        return ErrorMsg(playerid, "Pemain tersebut sedang menggunakan kendaraan");

		SetPlayerPosition(otherid,2183.71, -1017.67, 1020.63,750);
		SetPlayerFacingAngle(otherid,179.4088);
		SetPlayerInterior(otherid, 1);
		SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
	    Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = 1;
	    pData[otherid][pInHouse] = -1;
		pData[otherid][pInBiz] = -1;
		pData[otherid][pInFamily] = -1;
    }
    return 1;
}

CMD:apm(playerid, params[])
{
	static
	    userid,
	    text[128];

	if(pData[playerid][pAdmin] < 2)
   		if(pData[playerid][pHelper] == 0)
     		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	if (sscanf(params, "us[128]", userid, text))
		return SyntaxMsg(playerid, "/apm [playerid/PartOfName] [message]");

	if (userid == INVALID_PLAYER_ID)
	    return ErrorMsg(playerid, "You have specified an invalid player.");

	SendClientMessageEx(userid, COLOR_LIGHTRED, "PM From Admin: {FFFFFF}%s", text);
	SendAdminMessage(COLOR_LIGHTRED, "%s APM To %s: %s", PlayerData[playerid][pUCP], GetName(userid), text);
	PlayerPlaySound(userid, 1085, 0.0, 0.0, 0.0);
	return 1;
}


CMD:gethere(playerid, params[])
{
    new otherid;

	if(pData[playerid][pAdmin] < 2)
   		if(pData[playerid][pHelper] == 0)
     		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/gethere [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "The specified user(s) are not connected.");
	
	if(pData[playerid][pSpawned] == 0 || pData[otherid][pSpawned] == 0)
		return ErrorMsg(playerid, "Player/Target sedang tidak spawn!");
		
	if(pData[playerid][pJail] > 0 || pData[otherid][pJail] > 0)
		return ErrorMsg(playerid, "Player/Target sedang di jail");
		
	if(pData[playerid][pArrest] > 0 || pData[otherid][pArrest] > 0)
		return ErrorMsg(playerid, "Player/Target sedang di arrest");

	if(pData[playerid][pAdmin] < pData[otherid][pAdmin] > 0)
		return ErrorMsg(playerid, "Anda tidak dapat menarik Admin dengan level paling tinggi");

    SendPlayerToPlayer(otherid, playerid);

	new abc[500];
	format(abc,sizeof(abc), "%s telah menarik mu", pData[playerid][pName]);
    InfoMsg(otherid, abc);
    new str[500];
   	format(str,sizeof(str),"Anda menarik pemain ~y~%s", pData[otherid][pName]);
	SuccesMsg(playerid, str);
    return 1;
}

CMD:freeze(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
   		if(pData[playerid][pHelper] == 0)
     		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	new otherid;
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/freeze [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    pData[playerid][pFreeze] = 1;

    TogglePlayerControllable(otherid, 0);
    Servers(playerid, "You have frozen %s's movements.", ReturnName(otherid));
	Servers(otherid, "You have been frozen movements by admin %s.", pData[playerid][pAdminname]);
    return 1;
}

CMD:unfreeze(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
   		if(pData[playerid][pHelper] == 0)
     		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	new otherid;
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/unfreeze [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    pData[playerid][pFreeze] = 0;

    TogglePlayerControllable(otherid, 1);
    Servers(playerid, "You have unfrozen %s's movements.", ReturnName(otherid));
	Servers(otherid, "You have been unfrozen movements by admin %s.", pData[playerid][pAdminname]);
    return 1;
}

CMD:arevive(playerid, params[])
{

    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
     		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	new otherid;
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/arevive [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    if(!pData[otherid][pInjured])
        return ErrorMsg(playerid, "Tidak bisa revive karena tidak injured.");

    SetPlayerHealthEx(otherid, 100.0);
    pData[otherid][pInjured] = 0;
	pData[otherid][pHospital] = 0;
	pData[otherid][pSick] = 0;
	HideTdDeath(otherid);
	UpdateDynamic3DTextLabelText(pData[otherid][pInjuredLabel], COLOR_ORANGE, "");

    ClearAnimations(otherid);
	ApplyAnimation(otherid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);

    SendStaffMessage(COLOR_RED, "Staff %s have revived player %s.", pData[playerid][pAdminname], ReturnName(otherid));
    Info(otherid, "Staff %s has revived your character.", pData[playerid][pAdminname]);
    return 1;
}

CMD:spec(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 1)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

    if(!isnull(params) && !strcmp(params, "off", true))
    {
        if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
            return ErrorMsg(playerid, "You are not spectating any player.");

		pData[pData[playerid][pSpec]][playerSpectated]--;
        PlayerSpectatePlayer(playerid, INVALID_PLAYER_ID);
        PlayerSpectateVehicle(playerid, INVALID_VEHICLE_ID);

        SetSpawnInfo(playerid, 0, pData[playerid][pSkin], pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pPosA], 0, 0, 0, 0, 0, 0);
        TogglePlayerSpectating(playerid, false);
		pData[playerid][pSpec] = -1;

        return Servers(playerid, "You are no longer in spectator mode.");
    }
	new otherid;
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/spectate [playerid/PartOfName] - Type '/spec off' to stop spectating.");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	if(otherid == playerid)
		return ErrorMsg(playerid, "You can't spectate yourself bro..");

    if(pData[playerid][pAdmin] < pData[otherid][pAdmin])
        return ErrorMsg(playerid, "You can't spectate admin higher than you.");
		
	if(pData[otherid][pSpawned] == 0)
	{
	    Error(playerid, "%s(%i) isn't spawned!", pData[otherid][pName], otherid);
	    return true;
	}

    if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
    {
        GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
        GetPlayerFacingAngle(playerid, pData[playerid][pPosA]);

        pData[playerid][pInt] = GetPlayerInterior(playerid);
        pData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);
    }
    SetPlayerInterior(playerid, GetPlayerInterior(otherid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(otherid));

    TogglePlayerSpectating(playerid, 1);

    if(IsPlayerInAnyVehicle(otherid))
	{
		new vID = GetPlayerVehicleID(otherid);
        PlayerSpectateVehicle(playerid, GetPlayerVehicleID(otherid));
		if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER)
	    {
	    	new str[500];
			format(str,sizeof(str),"You are now spectating %s(%i) who is driving a %s(%d).", pData[otherid][pName], otherid, GetVehicleModelName(GetVehicleModel(vID)), vID);
			SuccesMsg(playerid, str);
		}
		else
		{
		    Servers(playerid, "You are now spectating %s(%i) who is a passenger in %s(%d).", pData[otherid][pName], otherid, GetVehicleModelName(GetVehicleModel(vID)), vID);
		}
	}
    else
	{
        PlayerSpectatePlayer(playerid, otherid);
	}
	pData[otherid][playerSpectated]++;
    SendStaffMessage(COLOR_WHITE, "{7fffd4}%s now spectating %s (ID: %d).", pData[playerid][pAdminname], pData[otherid][pName], otherid);
    pData[playerid][pSpec] = otherid;
    return 1;
}

CMD:slap(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
		if(pData[playerid][pHelper] == 0)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	new Float:POS[3], otherid;
	if(sscanf(params, "u", otherid))
	{
	    SyntaxMsg(playerid, "/slap <ID>");
	    return true;
	}

	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	GetPlayerPos(otherid, POS[0], POS[1], POS[2]);
	SetPlayerPos(otherid, POS[0], POS[1], POS[2] + 9.0);
	if(IsPlayerInAnyVehicle(otherid)) 
	{
		RemovePlayerFromVehicle(otherid);
		//OnPlayerExitVehicle(otherid, GetPlayerVehicleID(otherid));
	}
	SendStaffMessage(COLOR_RED, "Admin %s telah men-slap player %s", pData[playerid][pAdminname], pData[otherid][pName]);

	PlayerPlaySound(otherid, 1130, 0.0, 0.0, 0.0);
	return 1;
}

CMD:caps(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
		if(pData[playerid][pHelper] == 0)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	new otherid;
 	if(sscanf(params, "u", otherid))
	{
	    SyntaxMsg(playerid, "/caps <ID>");
	    Info(playerid, "Function: Will disable caps for the player, type again to enable caps.");
	    return 1;
	}
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	if(!GetPVarType(otherid, "Caps"))
	{
	    // Disable Caps
	    SetPVarInt(otherid, "Caps", 1);
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah menon-aktifkan anti caps kepada player %s", pData[playerid][pAdminname], pData[playerid][pName]);
	}
	else
	{
	    // Enable Caps
		DeletePVar(otherid, "Caps");
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah meng-aktifkan anti caps kepada player %s", pData[playerid][pAdminname], pData[playerid][pName]);
	}
	return 1;
}

CMD:peject(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
		if(pData[playerid][pHelper] < 2)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    SyntaxMsg(playerid, "/peject <ID>");
	    return 1;
	}

	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	if(!IsPlayerInAnyVehicle(otherid))
	{
		ErrorMsg(playerid, "Player tersebut tidak berada dalam kendaraan!");
		return 1;
	}

	new vv = GetVehicleModel(GetPlayerVehicleID(otherid));
	Servers(playerid, "You have successfully ejected %s(%i) from their %s.", pData[otherid][pName], otherid, GetVehicleModelName(vv - 400));
	Servers(otherid, "%s(%i) has ejected you from your %s.", pData[playerid][pName], playerid, GetVehicleModelName(vv));
	RemovePlayerFromVehicle(otherid);
	return 1;
}

CMD:aitems(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
		if(pData[playerid][pHelper] < 2)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/aitems [playerid/PartOfName]");
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	if(pData[otherid][IsLoggedIn] == false)
        return ErrorMsg(playerid, "That player is not logged in yet.");
		
	DisplayItems(playerid, otherid);
	return 1;
}

CMD:astats(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
		if(pData[playerid][pHelper] < 2)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/check [playerid/PartOfName]");
		
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	if(pData[otherid][IsLoggedIn] == false)
        return ErrorMsg(playerid, "That player is not logged in yet.");

	DisplayStats(playerid, otherid);
	return 1;
}

CMD:adelays(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
		if(pData[playerid][pHelper] < 2)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/check [playerid/PartOfName]");
		
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	if(pData[otherid][IsLoggedIn] == false)
        return ErrorMsg(playerid, "That player is not logged in yet.");

	DelaysPlayer(playerid, otherid);
	return 1;
}

CMD:ostats(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
		if(pData[playerid][pHelper] < 2)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	new name[24], PlayerName[24];
	if(sscanf(params, "s[24]", name))
	{
	    SyntaxMsg(playerid, "/ostats <player name>");
 		return 1;
 	}

 	foreach(new ii : Player)
	{
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

		if(!strcmp(PlayerName, name, true))
		{
			ErrorMsg(playerid, "Player is online, you can use /stats on them.");
	  		return 1;
	  	}
	}

	// Load User Data
    new cVar[500];
    new cQuery[600];

	strcat(cVar, "email,admin,helper,level,levelup,vip,vip_time,gold,reg_date,last_login,money,bmoney,brek,hours,minutes,seconds,");
	strcat(cVar, "gender,age,faction,family,warn,job,job2,interior,world,ucp,reg_id,phone,phonestatus, twittername");

	mysql_format(g_SQL, cQuery, sizeof(cQuery), "SELECT %s FROM players WHERE username='%e' LIMIT 1", cVar, name);
	mysql_tquery(g_SQL, cQuery, "LoadStats", "is", playerid, name);
	return true;
}

CMD:acuff(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
   		if(pData[playerid][pHelper] == 0)
     		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	new otherid, mstr[128];		
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/acuff [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    //if(otherid == playerid)
        //return ErrorMsg(playerid, "You cannot handcuff yourself.");

    if(!NearPlayer(playerid, otherid, 5.0))
        return ErrorMsg(playerid, "You must be near this player.");

    if(GetPlayerState(otherid) != PLAYER_STATE_ONFOOT)
        return ErrorMsg(playerid, "The player must be onfoot before you can cuff them.");

    if(pData[otherid][pCuffed])
        return ErrorMsg(playerid, "The player is already cuffed at the moment.");

    pData[otherid][pCuffed] = 1;
	SetPlayerSpecialAction(otherid, SPECIAL_ACTION_CUFFED);

    format(mstr, sizeof(mstr), "You've been ~r~cuffed~w~ by %s.", pData[playerid][pName]);
    InfoTD_MSG(otherid, 3500, mstr);

    Servers(playerid, "Player %s telah berhasil di cuffed.", pData[otherid][pName]);
    Servers(otherid, "Admin %s telah mengcuffed anda.", pData[playerid][pName]);
    return 1;
}

CMD:auncuff(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
   		if(pData[playerid][pHelper] == 0)
     		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	new otherid;		
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/auncuff [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    //if(otherid == playerid)
        //return ErrorMsg(playerid, "You cannot uncuff yourself.");

    if(!NearPlayer(playerid, otherid, 5.0))
        return ErrorMsg(playerid, "You must be near this player.");

    if(!pData[otherid][pCuffed])
        return ErrorMsg(playerid, "The player is not cuffed at the moment.");

    static
        string[64];

    pData[otherid][pCuffed] = 0;
    SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);

    format(string, sizeof(string), "You've been ~y~uncuffed~w~ by %s.", pData[playerid][pName]);
    InfoTD_MSG(otherid, 3500, string);
	Servers(playerid, "Player %s telah berhasil uncuffed.", pData[otherid][pName]);
    Servers(otherid, "Admin %s telah uncuffed tangan anda.", pData[playerid][pName]);
    return 1;
}

CMD:jetpack(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
   		if(pData[playerid][pHelper] < 2)
     		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	new otherid;		
    if(sscanf(params, "u", otherid))
    {
        pData[playerid][pJetpack] = 1;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
    }
    else
    {
        pData[playerid][pJetpack] = 1;
        SetPlayerSpecialAction(otherid, SPECIAL_ACTION_USEJETPACK);
        Servers(playerid, "You have spawned a jetpack for %s.", pData[otherid][pName]);
    }
    return 1;
}

CMD:getip(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
     	return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	new otherid, PlayerIP[16], giveplayer[24];
	if(sscanf(params, "u", otherid))
 	{
  		SyntaxMsg(playerid, "/getip <ID>");
		return 1;
	}
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	if(pData[otherid][pAdmin] == 5)
 	{
  		ErrorMsg(playerid, "You can't get the server owners ip!");
  		Servers(otherid, "%s(%i) tried to get your IP!", pData[playerid][pName], playerid);
  		return 1;
    }
	GetPlayerName(otherid, giveplayer, sizeof(giveplayer));
	GetPlayerIp(otherid, PlayerIP, sizeof(PlayerIP));

	Servers(playerid, "%s(%i)'s IP: %s", giveplayer, otherid, PlayerIP);
	return 1;
}

CMD:aka(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
     	return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	new otherid, PlayerIP[16], query[128];
	if(sscanf(params, "u", otherid))
	{
	    SyntaxMsg(playerid, "/aka <ID/Name>");
	    return true;
	}
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	if(pData[otherid][pAdmin] == 5)
 	{
  		ErrorMsg(playerid, "You can't AKA the server owner!");
  		Servers(otherid, "%s(%i) tried to AKA you!", pData[playerid][pName], playerid);
  		return 1;
    }
	GetPlayerIp(otherid, PlayerIP, sizeof(PlayerIP));
	mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE IP='%s'", PlayerIP);
	mysql_tquery(g_SQL, query, "CheckPlayerIP", "is", playerid, PlayerIP);
	return true;
}

CMD:akaip(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
     	return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	new query[128];
	if(isnull(params))
	{
	    SyntaxMsg(playerid, "/akaip <IP>");
		return true;
	}

	mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE IP='%s'", params);
	mysql_tquery(g_SQL, query, "CheckPlayerIP2", "is", playerid, params);
	return true;
}

CMD:vmodels(playerid, params[])
{
    new string[3500];

    if(pData[playerid][pAdmin] < 1)
     	return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

    for (new i = 0; i < sizeof(g_arrVehicleNames); i ++)
    {
        format(string,sizeof(string), "%s%d - %s\n", string, i+400, g_arrVehicleNames[i]);
    }
    ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_LIST, "Vehicle Models", string, "Close", "");
    return 1;
}

CMD:vehname(playerid, params[]) {

	if(pData[playerid][pAdmin] >= 1) 
	{
		SendClientMessageEx(playerid, COLOR_YELLOW, "--------------------------------------------------------------------------------------------------------------------------------");
		SendClientMessageEx(playerid, COLOR_WHITE, "Vehicle Search:");

		new
			string[128];

		if(isnull(params)) return ErrorMsg(playerid, "No keyword specified.");
		if(!params[2]) return ErrorMsg(playerid, "Search keyword too short.");

		for(new v; v < sizeof(g_arrVehicleNames); v++) 
		{
			if(strfind(g_arrVehicleNames[v], params, true) != -1) {

				if(isnull(string)) format(string, sizeof(string), "%s (ID %d)", g_arrVehicleNames[v], v+400);
				else format(string, sizeof(string), "%s | %s (ID %d)", string, g_arrVehicleNames[v], v+400);
			}
		}

		if(!string[0]) ErrorMsg(playerid, "No results found.");
		else if(string[127]) ErrorMsg(playerid, "Too many results found.");
		else SendClientMessageEx(playerid, COLOR_WHITE, string);

		SendClientMessageEx(playerid, COLOR_YELLOW, "--------------------------------------------------------------------------------------------------------------------------------");
	}
	else
	{
		ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	}
	return 1;
}

CMD:owarn(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
	    return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new player[24], tmp[50], PlayerName[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]s[50]", player, tmp))
		return SyntaxMsg(playerid, "/owarn <name> <reason>");

	if(strlen(tmp) > 50) return ErrorMsg(playerid, "Reason must be shorter than 50 characters.");

	foreach(new ii : Player)
	{
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

	    if(strfind(PlayerName, player, true) != -1)
		{
			ErrorMsg(playerid, "Player is online, you can use /warn on him.");
	  		return 1;
	  	}
	}
	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "SELECT reg_id,warn FROM players WHERE username='%e'", player);
	mysql_tquery(g_SQL, query, "OWarnPlayer", "iss", playerid, player, tmp);
	return 1;
}

function OWarnPlayer(adminid, NameToWarn[], warnReason[])
{
	if(cache_num_rows() < 1)
	{
		return Error(adminid, "Account {ffff00}'%s' "WHITE_E"does not exist.", NameToWarn);
	}
	else
	{
	    new RegID, warn;
		cache_get_value_index_int(0, 0, RegID);
		cache_get_value_index_int(0, 1, warn);
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah memberi warning(offline) player %s. [Reason: %s]", pData[adminid][pAdminname], NameToWarn, warnReason);
		new str[150];
		format(str,sizeof(str),"Admin: %s memberi %s warn(offline). Alasan: %s!", GetRPName(adminid), NameToWarn, warnReason);
		LogServer("Admin", str);
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET warn=%d WHERE reg_id=%d", warn+1, RegID);
		mysql_tquery(g_SQL, query);
	}
	return 1;
}

CMD:ojail(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
	    return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new player[24], datez, tmp[50], PlayerName[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]ds[50]", player, datez, tmp))
		return SyntaxMsg(playerid, "/ojail <name> <time in minutes)> <reason>");

	if(strlen(tmp) > 50) return ErrorMsg(playerid, "Reason must be shorter than 50 characters.");
	if(datez < 1 || datez > 60)
	{
 		if(pData[playerid][pAdmin] < 5)
   		{
			ErrorMsg(playerid, "Jail time must remain between 1 and 60 minutes");
  			return 1;
   		}
	}
	foreach(new ii : Player)
	{
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

	    if(strfind(PlayerName, player, true) != -1)
		{
			ErrorMsg(playerid, "Player is online, you can use /jail on him.");
	  		return 1;
	  	}
	}
	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "SELECT reg_id FROM players WHERE username='%e'", player);
	mysql_tquery(g_SQL, query, "OJailPlayer", "issi", playerid, player, tmp, datez);
	return 1;
}

function OJailPlayer(adminid, NameToJail[], jailReason[], jailTime)
{
	if(cache_num_rows() < 1)
	{
		return Error(adminid, "Account {ffff00}'%s' "WHITE_E"does not exist.", NameToJail);
	}
	else
	{
	    new RegID, JailMinutes = jailTime * 60;
		cache_get_value_index_int(0, 0, RegID);

		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah menjail(offline) player %s selama %d menit. [Reason: %s]", pData[adminid][pAdminname], NameToJail, jailTime, jailReason);
		new str[150];
		format(str,sizeof(str),"Admin: %s memberi %s jail(offline) selama %d menit. Alasan: %s!", GetRPName(adminid), NameToJail, jailTime, jailReason);
		LogServer("Admin", str);
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET jail=%d WHERE reg_id=%d", JailMinutes, RegID);
		mysql_tquery(g_SQL, query);
	}
	return 1;
}

CMD:jail(playerid, params[])
{
   	if(pData[playerid][pAdmin] < 2)
   		if(pData[playerid][pHelper] < 2)
     		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new reason[60], timeSec, otherid;
	if(sscanf(params, "uD(15)S(*)[60]", otherid, timeSec, reason))
	{
	    SyntaxMsg(playerid, "/jail <ID/Name> <time in minutes> <reason>)");
	    return true;
	}

	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	if(pData[otherid][pJail] > 0)
	{
	    Servers(playerid, "%s(%i) is already jailed (gets out in %d minutes)", pData[otherid][pName], otherid, pData[otherid][pJailTime]);
	    Info(playerid, "/unjail <ID/Name> to unjail.");
	    return true;
	}
	if(pData[otherid][pSpawned] == 0)
	{
	    Error(playerid, "%s(%i) isn't spawned!", pData[otherid][pName], otherid);
	    return true;
	}
	if(reason[0] != '*' && strlen(reason) > 60)
	{
	 	ErrorMsg(playerid, "Reason too long! Must be smaller than 60 characters!");
	   	return true;
	}
	if(timeSec < 1 || timeSec > 60)
	{
	    if(pData[playerid][pAdmin] < 5)
	 	{
			ErrorMsg(playerid, "Jail time must remain between 1 and 60 minutes");
	    	return 1;
	  	}
	}
	pData[otherid][pJail] = 1;
	pData[otherid][pJailTime] = timeSec * 60;
	JailPlayer(otherid);
	if(reason[0] == '*')
	{
		SendClientMessageToAllEx(COLOR_PINK2, "ADMINISTRATOR | %s {ffffff}telah mempenjara pemain %s selama %d bulan.", pData[playerid][pAdminname], pData[otherid][pName], timeSec);
		new str[150];
		format(str,sizeof(str),"Admin: %s memberi %s jail selama %d menit!", GetRPName(playerid), GetRPName(otherid), timeSec);
		LogServer("Admin", str);
	}
	else
	{
		SendClientMessageToAllEx(COLOR_PINK2, "ADMINISTRATOR | %s telah mempenjara pemain %s selama %d bulan Alasan -> %s", pData[playerid][pAdminname], pData[otherid][pName], timeSec, reason);
		new str[150];
		format(str,sizeof(str),"Admin: %s memberi %s jail selama %d menit. Alasan: %s!", GetRPName(playerid), GetRPName(otherid), timeSec, reason);
		LogServer("Admin", str);
	}
	return 1;
}


CMD:unjail(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
   		if(pData[playerid][pHelper] < 2)
     		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    SyntaxMsg(playerid, "/unjail <ID/Name>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	if(pData[otherid][pJail] == 0)
	    return ErrorMsg(playerid, "The player isn't in jail!");

	pData[otherid][pJail] = 0;
	pData[otherid][pJailTime] = 0;
	SetPlayerInterior(otherid, 0);
	SetPlayerVirtualWorld(otherid, 0);
	SetPlayerPos(otherid, 1316.1792,-1366.5283,15.4769);
	SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);

	SendClientMessageToAllEx(COLOR_PINK2, "ADMINISTRATOR | %s {ffffff}telah membebaskan pemain %s dari penjara", pData[playerid][pAdminname], pData[otherid][pName]);
	new str[150];
	format(str,sizeof(str),"Admin: %s merilis %s dari penjara", GetRPName(playerid), GetRPName(otherid));
	LogServer("Admin", str);
	return true;
}

CMD:kick(playerid, params[])
{
    static
        reason[128];

	if(pData[playerid][pAdmin] < 2)
		if(pData[playerid][pHelper] == 0)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	new otherid;
    if(sscanf(params, "us[128]", otherid, reason))
        return SyntaxMsg(playerid, "/kick [playerid/PartOfName] [reason]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    if(pData[otherid][pAdmin] > pData[playerid][pAdmin])
        return ErrorMsg(playerid, "The specified player has higher authority.");

	SendClientMessageToAllEx(COLOR_PINK2, "ADMINISTRATOR | %s {FFFFFF}telah menendang %s dari kota alasan: %s.", GetName(otherid), PlayerData[playerid][pUCP], reason);
	KickEx(otherid);
    return 1;
}

CMD:ban(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new ban_time, datez, tmp[60], otherid;
	if(sscanf(params, "uds[60]", otherid, datez, tmp))
	{
	    SyntaxMsg(playerid, "/ban <ID/Name> <time (in days) 0 for permanent> <reason> ");
	    return true;
	}
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	
 	if(datez < 0) ErrorMsg(playerid, "Please input a valid ban time.");
	if(pData[playerid][pAdmin] < 2)
	{
		if(datez > 10 || datez <= 0) return ErrorMsg(playerid, "Anda hanya dapat membanned selama 1-10 hari!");
	}
	/*if(otherid == playerid)
	    return ErrorMsg(playerid, "You are not able to ban yourself!");*/
	if(pData[otherid][pAdmin] > pData[playerid][pAdmin])
	{
		Servers(otherid, "** %s(%i) has just tried to ban you!", pData[playerid][pName], playerid);
 		ErrorMsg(playerid, "You are not able to ban a admin with a higher level than you!");
 		return true;
   	}
	new PlayerIP[16], giveplayer[24];
	
   	//SetPlayerPosition(otherid, 405.1100,2474.0784,35.7369,360.0000);
	GetPlayerName(otherid, giveplayer, sizeof(giveplayer));
	GetPlayerIp(otherid, PlayerIP, sizeof(PlayerIP));

	if(!strcmp(tmp, "ab", true)) tmp = "Airbreak";
	else if(!strcmp(tmp, "ad", true)) tmp = "Advertising";
	else if(!strcmp(tmp, "ads", true)) tmp = "Advertising";
	else if(!strcmp(tmp, "hh", true)) tmp = "Health Hacks";
	else if(!strcmp(tmp, "wh", true)) tmp = "Weapon Hacks";
	else if(!strcmp(tmp, "sh", true)) tmp = "Speed Hacks";
	else if(!strcmp(tmp, "mh", true)) tmp = "Money Hacks";
	else if(!strcmp(tmp, "rh", true)) tmp = "Ram Hacks";
	else if(!strcmp(tmp, "ah", true)) tmp = "Ammo Hacks";

	new temptime = gettime();
	new date[6];

	TimestampToDate(temptime, date[2], date[1], date[0], date[3], date[4], date[5]);

	new zstr[325];
	format(zstr, sizeof(zstr),"{FFFFFF}UCP Anda diblokir dari Executive Roleplay\n\nBerdasarkan Informasi:\nNama UCP: {ffffff}%s\nIP Address: {FFFFFF}%s\nAdmin On Duty: {ffffff}%s\nTanggal Diblokir: {FFFFFF}%i/%02d/%02d %02d:%02d\nReason: {FFFFFF}%s\nDurasi Blokir: {ffffff}%s\n\n"YELLOW_E"INGAT: {FFFFFF}Jika anda ingin bermain lagi dan bertobat, masuk ke discord: "YELLOW_E"bit.ly/Executive {ffffff}kemudian pilih chanel #request � unbanned Executiveta", pData[playerid][pUCP], PlayerIP, PlayerData[playerid][pAdminname], date[2], date[0], date[1], date[3], date[4], tmp);
	ShowPlayerDialog(otherid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{FFFFFF}Executive - UCP Blocked", zstr, "Tutup", "");

	new query[248];
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', '%s', '%s', %i, %d)", giveplayer, PlayerIP, pData[playerid][pAdminname], tmp, gettime(), ban_time);
	mysql_tquery(g_SQL, query);
	KickEx(otherid);
	return true;
}

CMD:banucp(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new ban_time, datez, tmp[60], otherid;
	if(sscanf(params, "uds[60]", otherid, datez, tmp))
	{
	    SyntaxMsg(playerid, "/banucp <ID/UCPName> <time (in days) 0 for permanent> <reason> ");
	    return true;
	}
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	
 	if(datez < 0) ErrorMsg(playerid, "Please input a valid ban time.");
	if(pData[playerid][pAdmin] < 2)
	{
		if(datez > 10 || datez <= 0) return ErrorMsg(playerid, "Anda hanya dapat membanned selama 1-10 hari!");
	}
	/*if(otherid == playerid)
	    return ErrorMsg(playerid, "You are not able to ban yourself!");*/
	if(pData[otherid][pAdmin] > pData[playerid][pAdmin])
	{
		Servers(otherid, "** %s(%i) has just tried to ban you!", pData[playerid][pName], playerid);
 		ErrorMsg(playerid, "You are not able to ban a admin with a higher level than you!");
 		return true;
   	}
	new PlayerIP[16];
	
   	//SetPlayerPosition(otherid, 405.1100,2474.0784,35.7369,360.0000);
	GetPlayerIp(otherid, PlayerIP, sizeof(PlayerIP));

	if(!strcmp(tmp, "ab", true)) tmp = "Airbreak";
	else if(!strcmp(tmp, "ad", true)) tmp = "Advertising";
	else if(!strcmp(tmp, "ads", true)) tmp = "Advertising";
	else if(!strcmp(tmp, "hh", true)) tmp = "Health Hacks";
	else if(!strcmp(tmp, "wh", true)) tmp = "Weapon Hacks";
	else if(!strcmp(tmp, "sh", true)) tmp = "Speed Hacks";
	else if(!strcmp(tmp, "mh", true)) tmp = "Money Hacks";
	else if(!strcmp(tmp, "rh", true)) tmp = "Ram Hacks";
	else if(!strcmp(tmp, "ah", true)) tmp = "Ammo Hacks";
	if(datez != 0)
	{
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah membanned player %s selama %d hari. {ffff00}[Reason: %s]", pData[playerid][pAdminname], pData[otherid][pUCP], datez, tmp);
		new str[150];
		format(str,sizeof(str),"Admin: %s banned ucp %s selama %d hari Alasan: %s!", GetRPName(playerid), pData[otherid][pUCP], datez, tmp);
		LogServer("Admin", str);
	}
	else
	{
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah membanned permanent player %s. {ffff00}[Reason: %s]", pData[playerid][pAdminname], pData[otherid][pUCP], tmp);
		new str[150];
		format(str,sizeof(str),"Admin: %s banned ucp permanen %s Alasan: %s!", GetRPName(playerid), pData[otherid][pUCP], tmp);
		LogServer("Admin", str);
	}
	//SetPlayerPosition(otherid, 227.46, 110.0, 999.02, 360.0000, 10);
	BanPlayerMSG(otherid, playerid, tmp);
 	if(datez != 0)
    {
		Servers(otherid, "This is a "RED_E"TEMP-BAN {ffff00}that will last for %d days.", datez);
		ban_time = gettime() + (datez * 86400);
	}
	else
	{
		Servers(otherid, "This is a "RED_E"Permanent Banned {ffff00}please contack admin for unbanned!.", datez);
		ban_time = datez;
	}
	new query[248];
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', '%s', '%s', %i, %d)", pData[otherid][pUCP], PlayerIP, pData[playerid][pAdminname], tmp, gettime(), ban_time);
	mysql_tquery(g_SQL, query);
	KickEx(otherid);
	return true;
}

CMD:unban(playerid, params[])
{
   	if(pData[playerid][pAdmin] < 2)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new tmp[24];
	if(sscanf(params, "s[24]", tmp))
	{
	    SyntaxMsg(playerid, "/unban <ban name>");
	    return true;
	}
	new query[128];
	mysql_format(g_SQL, query, sizeof(query), "SELECT name,ip FROM banneds WHERE name = '%e'", tmp);
	mysql_tquery(g_SQL, query, "OnUnbanQueryData", "is", playerid, tmp);
	return 1;
}

function OnUnbanQueryData(adminid, BannedName[])
{
	if(cache_num_rows() > 0)
	{
		new banIP[16], query[128];
		cache_get_value_name(0, "ip", banIP);
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM banneds WHERE ip = '%s'", banIP);
		mysql_tquery(g_SQL, query);

		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}%s(%i) has unbanned %s from the server.", pData[adminid][pAdminname], adminid, BannedName);
		new str[150];
		format(str,sizeof(str),"Admin: %s unban %s dari server!", GetRPName(adminid), BannedName);
		LogServer("Admin", str);
	}
	else
	{
		Error(adminid, "No player named '%s' found on the ban list.", BannedName);
	}
	return 1;
}

CMD:unbanucp(playerid, params[])
{
   	if(pData[playerid][pAdmin] < 2)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new tmp[24];
	if(sscanf(params, "s[24]", tmp))
	{
	    SyntaxMsg(playerid, "/unbanucp <ucp name>");
	    return true;
	}
	new query[128];
	mysql_format(g_SQL, query, sizeof(query), "SELECT name FROM banneds WHERE name = '%e'", tmp);
	mysql_tquery(g_SQL, query, "UnbanUCP", "is", playerid, tmp);
	return 1;
}

function UnbanUCP(adminid, BannedName[])
{
	if(cache_num_rows() > 0)
	{
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM banneds WHERE name = '%s'", BannedName);
		mysql_tquery(g_SQL, query);

		SendStaffMessage(COLOR_RED, "Server: {ffff00}%s(%i) has unbanned %s from the server.", pData[adminid][pAdminname], adminid, BannedName);
		new str[150];
		format(str,sizeof(str),"Admin: %s unban ucp %s dari server!", GetRPName(adminid), BannedName);
		LogServer("Admin", str);
	}
	else
	{
		Error(adminid, "No player named '%s' found on the ban list.", BannedName);
	}
	return 1;
}

CMD:warn(playerid, params[])
{
    static
        reason[32];

    if(pData[playerid][pAdmin] < 2)
        if(pData[playerid][pHelper] < 3)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	new otherid;
    if(sscanf(params, "us[32]", otherid, reason))
        return SyntaxMsg(playerid, "/warn [playerid/PartOfName] [reason]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    if(pData[otherid][pAdmin] > pData[playerid][pAdmin])
        return ErrorMsg(playerid, "The specified player has higher authority.");

	pData[otherid][pWarn]++;
	SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah memberikan warning kepada player %s. [Reason: %s] [Total Warning: %d/20]", pData[playerid][pAdminname], pData[otherid][pName], reason, pData[otherid][pWarn]);
    return 1;
}

CMD:unwarn(playerid, params[])
{
    if(pData[playerid][pAdmin] < 2)
		if(pData[playerid][pHelper] < 3)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	new otherid;
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/unwarn [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    pData[otherid][pWarn] -= 1;
    Servers(playerid, "You have unwarned 1 point %s's warnings.", pData[otherid][pName]);
	Servers(otherid, "%s has unwarned 1 point your warnings.", pData[playerid][pAdminname]);
    SendStaffMessage(COLOR_RED, "Admin %s has unwarned 1 point to %s's warnings.", pData[playerid][pAdminname], pData[otherid][pName]);
    new str[150];
	format(str,sizeof(str),"Admin: %s unwarn %s!", GetRPName(playerid), GetRPName(otherid));
	LogServer("Admin", str);
	return 1;
}

CMD:respawnsapd(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	for(new x;x<sizeof(SAPDVehicles);x++)
	{
		if(IsVehicleEmpty(SAPDVehicles[x]))
		{
			SetVehicleToRespawn(SAPDVehicles[x]);
			SetValidVehicleHealth(SAPDVehicles[x], 2000);
			SetVehicleFuel(SAPDVehicles[x], 1000);
			SwitchVehicleDoors(SAPDVehicles[x], false);
		}
	}
	SendStaffMessage(COLOR_RED, "%s has respawned SAPD vehicles.", pData[playerid][pAdminname]);
	return 1;
}

CMD:respawnsags(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	for(new x;x<sizeof(SAGSVehicles);x++)
	{
		if(IsVehicleEmpty(SAGSVehicles[x]))
		{
			SetVehicleToRespawn(SAGSVehicles[x]);
			SetValidVehicleHealth(SAGSVehicles[x], 2000);
			SetVehicleFuel(SAGSVehicles[x], 1000);
			SwitchVehicleDoors(SAGSVehicles[x], false);
		}
	}
	SendStaffMessage(COLOR_RED, "%s has respawned SAGS vehicles.", pData[playerid][pAdminname]);
	return 1;
}

CMD:respawnsamd(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	for(new x;x<sizeof(SAMDVehicles);x++)
	{
		if(IsVehicleEmpty(SAMDVehicles[x]))
		{
			SetVehicleToRespawn(SAMDVehicles[x]);
			SetValidVehicleHealth(SAMDVehicles[x], 2000);
			SetVehicleFuel(SAMDVehicles[x], 1000);
			SwitchVehicleDoors(SAMDVehicles[x], false);
		}
	}
	SendStaffMessage(COLOR_RED, "%s has respawned SAMD vehicles.", pData[playerid][pAdminname]);
	return 1;
}

CMD:respawnsana(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	for(new x;x<sizeof(SANAVehicles);x++)
	{
		if(IsVehicleEmpty(SANAVehicles[x]))
		{
			SetVehicleToRespawn(SANAVehicles[x]);
			SetValidVehicleHealth(SANAVehicles[x], 2000);
			SetVehicleFuel(SANAVehicles[x], 1000);
			SwitchVehicleDoors(SANAVehicles[x], false);
		}
	}
	SendStaffMessage(COLOR_RED, "Admin %s has respawned SANA vehicles.", pData[playerid][pAdminname]);
	return 1;
}


RespawnNearbyVehicles(playerid, Float:radi)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    for(new i=1; i<MAX_VEHICLES; i++)
    {
        if(GetVehicleModel(i))
        {
            new Float:posx, Float:posy, Float:posz;
            new Float:tempposx, Float:tempposy, Float:tempposz;
            GetVehiclePos(i, posx, posy, posz);
            tempposx = (posx - x);
            tempposy = (posy - y);
            tempposz = (posz - z);
            if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
            {
				if(IsVehicleEmpty(i))
				{
					//SetVehicleToRespawn(i);
					SetTimerEx("RespawnPV", 3000, false, "d", i);
					SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s telah merespawn kendaraan disekitar dengan radius %d.", pData[playerid][pAdminname], radi);
					SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Jika kendaraan lumber pribadi anda terkena respawn admin gunakan /v park untuk meload kembali lumber anda!");
				}
			}
        }
    }
}

CMD:respawnrad(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	new rad;
	if(sscanf(params, "d", rad)) return SyntaxMsg(playerid, "/respawnrad [radius] | respawn vehicle nearest");
	
	if(rad > 50) return ErrorMsg(playerid, "Maximal 50 radius");
	RespawnNearbyVehicles(playerid, rad);
	return 1;
}

//----------------------------[ Admin Level 2 ]-----------------------
CMD:sethp(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return SyntaxMsg(playerid, "/sethp [playerid id/name] <jumlah>");
	if(jumlah > 100)
		return ErrorMsg(playerid, "Max 100 Hp!");
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	SetPlayerHealthEx(otherid, jumlah);
	SendStaffMessage(COLOR_RED, "%s telah men set jumlah hp player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set hp anda", pData[playerid][pAdminname]);
	new str[150];
	format(str,sizeof(str),"Admin: %s menyetel hp %s!", GetRPName(playerid), GetRPName(otherid));
	LogServer("Admin", str);
	return 1;
}

CMD:setbone(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return SyntaxMsg(playerid, "/setbone [playerid id/name] <jumlah>");
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	pData[otherid][pHead] = jumlah;
	pData[otherid][pPerut] = jumlah;
	pData[otherid][pLFoot] = jumlah;
	pData[otherid][pRFoot] = jumlah;
	pData[otherid][pLHand] = jumlah;
	pData[otherid][pRHand] = jumlah;
	SendStaffMessage(COLOR_RED, "%s telah men set jumlah Kondisi tulang player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set Kondisi tulang anda", pData[playerid][pAdminname]);
	return 1;
}

CMD:setam(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return SyntaxMsg(playerid, "/setam [playerid id/name] <jumlah>");
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
	
	if(jumlah > 95)
	{
		SetPlayerArmourEx(otherid, 98);
	}
	else
	{
		SetPlayerArmourEx(otherid, jumlah);
	}
	SendStaffMessage(COLOR_RED, "%s telah men set jumlah armor player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set armor anda", pData[playerid][pAdminname]);
	new str[150];
	format(str,sizeof(str),"Admin: %s menyetel armor %s!", GetRPName(playerid), GetRPName(otherid));
	LogServer("Admin", str);
	return 1;
}

CMD:afuel(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
     		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	if(IsPlayerInAnyVehicle(playerid)) 
	{
		SetVehicleFuel(GetPlayerVehicleID(playerid), 1000);
		Servers(playerid, "Vehicle Fueled!");
	}
	else
	{
		ErrorMsg(playerid, "Kamu tidak berada didalam kendaraan apapun!");
	}
	return 1;
}

CMD:afix(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
     		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
    if(IsPlayerInAnyVehicle(playerid)) 
	{
        SetValidVehicleHealth(GetPlayerVehicleID(playerid), 1000);
		ValidRepairVehicle(GetPlayerVehicleID(playerid));
        Servers(playerid, "Vehicle Fixed!");
    }
	else
	{
		ErrorMsg(playerid, "Kamu tidak berada didalam kendaraan apapun!");
	}
	return 1;
}

CMD:setskin(playerid, params[])
{
    new
        skinid,
		otherid;

    if(pData[playerid][pAdmin] < 6)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

    if(sscanf(params, "ud", otherid, skinid))
        return SyntaxMsg(playerid, "/skin [playerid/PartOfName] [skin id]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    if(skinid < 0 || skinid > 299)
        return ErrorMsg(playerid, "Invalid skin ID. Skins range from 0 to 299.");

    SetPlayerSkin(otherid, skinid);
	pData[otherid][pSkin] = skinid;

    Servers(playerid, "You have set %s's skin to ID: %d.", ReturnName(otherid), skinid);
    Servers(otherid, "%s has set your skin to ID: %d.", ReturnName(playerid), skinid);
    return 1;
}

CMD:akill(playerid, params[])
{
    if(pData[playerid][pAdmin] < 3)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	new reason[60], otherid;
	if(sscanf(params, "uS(*)[60]", otherid, reason))
	{
	    SyntaxMsg(playerid, "/akill <ID/Name> <optional: reason>");
	    return 1;
	}

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

	SetPlayerHealth(otherid, 0.0);

	if(reason[0] != '*')
	{
		SendClientMessageToAllEx(COLOR_RED, "Servers: {ffff00}Admin %s has killed %s. "GREY_E"[Reason: %s]", pData[playerid][pAdminname], pData[otherid][pName], reason);
	}
	else
	{
		SendClientMessageToAllEx(COLOR_RED, "Servers: {ffff00}Admin %s has killed %s.", pData[playerid][pAdminname], pData[otherid][pName]);
	}
	return 1;
}

CMD:ann(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

 	if(isnull(params))
    {
	    SyntaxMsg(playerid, "/announce <msg>");
	    return 1;
	}
	// Check for special trouble-making input
   	if(strfind(params, "~x~", true) != -1)
		return ErrorMsg(playerid, "~x~ is not allowed in announce.");
	if(strfind(params, "#k~", true) != -1)
		return ErrorMsg(playerid, "The constant key is not allowed in announce.");
	if(strfind(params, "/q", true) != -1)
		return ErrorMsg(playerid, "You are not allowed to type /q in announcement!");

	// Count tildes (uneven number = faulty input)
	new iTemp = 0;
	for(new i = (strlen(params)-1); i != -1; i--)
	{
		if(params[i] == '~')
			iTemp ++;
	}
	if(iTemp % 2 == 1)
		return ErrorMsg(playerid, "You either have an extra ~ or one is missing in the announcement!");
	
	new str[512];
	format(str, sizeof(str), "~w~%s", params);
	GameTextForAll(str, 6500, 3);
	return true;
}

CMD:settime(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new time;
	if(sscanf(params, "d", time))
	{
		SyntaxMsg(playerid, "/time <time ID>");
		return true;
	}

	SetWorldTime(time);
	WorldTime = time;
	JamFivEm = time;
	foreach(new ii : Player)
	{
		SetPlayerTime(ii, time, 0);
	}
	return 1;
}

CMD:setweather(playerid, params[])
{
    new weatherid;

    if(pData[playerid][pAdmin] < 4)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

    if(sscanf(params, "d", weatherid))
        return SyntaxMsg(playerid, "/setweather [weather ID]");

    SetWeather(weatherid);
	WorldWeather = weatherid;
	foreach(new ii : Player)
	{
		SetPlayerWeather(ii, weatherid);
	}
    SetGVarInt("g_Weather", weatherid);
    SuccesMsg(playerid, "Anda telah mengubah cuaca di kota Executive.");
    return 1;
}

CMD:gotoco(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	new Float: pos[3], int;
	if(sscanf(params, "fffd", pos[0], pos[1], pos[2], int)) return SyntaxMsg(playerid, "/gotoco [x coordinate] [y coordinate] [z coordinate] [interior]");

	Servers(playerid, "Anda telah terteleportasi ke kordinat tersebut.");
	SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	SetPlayerInterior(playerid, int);
	return 1;
}

CMD:cd(playerid)
{
	if(pData[playerid][pAdmin] < 3)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	if(Count != -1) return ErrorMsg(playerid, "There is already a countdown in progress, wait for it to end!");

	Count = 6;
	countTimer = SetTimer("pCountDown", 1000, 1);

	foreach(new ii : Player)
	{
		showCD[ii] = 1;
	}
	SendClientMessageToAllEx(COLOR_RED, "[SERVER] "LB_E"Admin %s has started a global countdown!", pData[playerid][pAdminname]);
	return 1;
}

//---------------[ Admin Level 3 ]------------
CMD:oban(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
	    return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new player[24], datez, reason[50];
	if(sscanf(params, "s[24]D(0)s[50]", player, datez, reason))
	{
	    SyntaxMsg(playerid, "/oban <ban name> <time in days (0 for permanent ban)> <reason>");
	    Info(playerid, "Will ban a player while he is offline. If time isn't specified it will be a perm ban.");
	    return true;
	}
	if(strlen(reason) > 50) return ErrorMsg(playerid, "Reason must be shorter than 50 characters.");

	foreach(new ii : Player)
	{
		new PlayerName[24];
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

	    if(strfind(PlayerName, player, true) != -1)
		{
			ErrorMsg(playerid, "Player is online, you can use /ban on him.");
	  		return true;
	  	}
	}

	new query[128];

	mysql_format(g_SQL, query, sizeof(query), "SELECT ip FROM players WHERE username='%e'", player);
	mysql_tquery(g_SQL, query, "OnOBanQueryData", "issi", playerid, player, reason, datez);
	return true;
}

CMD:banip(playerid, params[])
{
    if(pData[playerid][pAdmin] < 2)
     	return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	if(isnull(params))
	{
	    SyntaxMsg(playerid, "/banip <IP Address>");
		return true;
	}
	if(strfind(params, "*", true) != -1 && pData[playerid][pAdmin] != 5)
	{
		ErrorMsg(playerid, "You are not authorized to ban ranges.");
  		return true;
  	}

	SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s(%d) IP banned address %s.", pData[playerid][pAdminname], playerid, params);
	new str[150];
	format(str,sizeof(str),"Admin: %s banned IP %s!", GetRPName(playerid), params);
	LogServer("Admin", str);

	new tstr[128];
	format(tstr, sizeof(tstr), "banip %s", params);
	SendRconCommand(tstr);
	return 1;
}

CMD:unbanip(playerid, params[])
{
    if(pData[playerid][pAdmin] < 2)
     	return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	if(isnull(params))
	{
	    SyntaxMsg(playerid, "/unbanip <IP Address>");
		return true;
	}
	new mstr[128];
	format(mstr, sizeof(mstr), "unbanip %s", params);
	SendRconCommand(mstr);
	format(mstr, sizeof(mstr), "reloadbans");
	SendRconCommand(mstr);
	Servers(playerid, "You have unbanned IP address %s.", params);
	new str[150];
	format(str,sizeof(str),"Admin: %s unbanned IP %s!", GetRPName(playerid), params);
	LogServer("Admin", str);
	return 1;
}

CMD:reloadweap(playerid, params[])
{
    if(pData[playerid][pAdmin] < 3)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	new otherid;
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/reloadweps [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    SetWeapons(otherid);
    Servers(playerid, "You have reload %s's weapons.", pData[otherid][pName]);
    Servers(otherid, "Admin %s have reload your weapons.", pData[playerid][pAdminname]);
    return 1;
}

CMD:resetpassword(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new name[MAX_PLAYER_NAME], password[24];
	if(sscanf(params, "ss[24]", name, password)) return SyntaxMsg(playerid, "/resetpassword [name] [new password]");

	new query[256];
	mysql_format(g_SQL, query, sizeof query, "SELECT * FROM playerucp WHERE ucp = '%s'", name);
	mysql_tquery(g_SQL, query, "CheckPlayerUserPw", "dss", playerid, name, password);
	return 1;
}

function CheckPlayerUserPw(playerid, target, password[])
{
	new query[254], pw[65], salt[16], extrachar;
	if(cache_num_rows() < 1)
	{
		return ErrorMsg(playerid, "Akun yang anda input tidak di temukan di dalam database!");
	}
	else
	{

		for (new i = 0; i < 16; i++) salt[i] = random(94) + 33;
		SHA256_PassHash(password, salt, pw, 65);

		extrachar = 0;
		mysql_format(g_SQL, query, sizeof query, "UPDATE playerucp SET password = '%s', salt = '%e', extrac = '%d' WHERE ucp = '%s'", pw, salt, extrachar, target);

		Info(playerid, "Anda Sukses Reset Password Dengan Nama UCP %s, Password %s", target, password);
	}
	return 1;
}

CMD:resetweap(playerid, params[])
{
    if(pData[playerid][pAdmin] < 3)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	new otherid;
    if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/resetweps [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");

    ResetPlayerWeaponsEx(otherid);
    Servers(playerid, "You have reset %s's weapons.", pData[otherid][pName]);
    Servers(otherid, "Admin %s have reset your weapons.", pData[playerid][pAdminname]);
    return 1;
}

CMD:setlevel(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return SyntaxMsg(playerid, "/setlevel [playerid id/name] <jumlah>");
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	pData[otherid][pLevel] = jumlah;
	SetPlayerScore(otherid, jumlah);
	SendStaffMessage(COLOR_RED, "%s telah men set jumlah level player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set level anda", pData[playerid][pAdminname]);
	new str[150];
	format(str,sizeof(str),"Admin: %s menyetel level %s ke level %d!", GetRPName(playerid), GetRPName(otherid), jumlah);
	LogServer("Admin", str);
	return 1;
}

CMD:sethbe(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return SyntaxMsg(playerid, "/sethbe [playerid id/name] <jumlah>");
	
	if(!IsPlayerConnected(otherid))
        return ErrorMsg(playerid, "Player belum masuk!");
		
	pData[otherid][pHunger] = jumlah;
	pData[otherid][pEnergy] = jumlah;
	pData[otherid][pBladder] = jumlah;
	pData[otherid][pKencing] = jumlah;
	
	pData[otherid][pSick] = 0;
	SetPlayerDrunkLevel(playerid, 0);
	SendStaffMessage(COLOR_RED, "%s telah men set jumlah hbe player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set HBE anda", pData[playerid][pAdminname]);
	return 1;
}

//----------------------------[ Admin Level 4 ]---------------
CMD:setname(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	new otherid, tmp[20];
	if(sscanf(params, "is[20]", otherid, tmp))
	{
	   	SyntaxMsg(playerid, "/setname <ID/Name> <newname>");
	    return 1;
	}
	if(!IsPlayerConnected(otherid)) return ErrorMsg(playerid, "Player belum masuk!");
	if(pData[otherid][IsLoggedIn] == false)	return ErrorMsg(playerid, "That player is not logged in.");
	
	if(strlen(tmp) < 4) return ErrorMsg(playerid, "New name can't be shorter than 4 characters!");
	if(strlen(tmp) > 20) return ErrorMsg(playerid, "New name can't be longer than 20 characters!");

	if(!IsValidName(tmp)) return ErrorMsg(playerid, "Name contains invalid characters, please doublecheck!");
	new query[248];
	mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE username='%s'", tmp);
	mysql_tquery(g_SQL, query, "SetName", "iis", otherid, playerid, tmp);
	return 1;
}


// SetName Callback
function SetName(otherplayer, playerid, nname[])
{
	if(!cache_num_rows())
	{
		new oldname[24], newname[24], query[248], id;
		GetPlayerName(otherplayer, oldname, sizeof(oldname));
		
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET username='%s' WHERE reg_id=%d", nname, pData[otherplayer][pID]);
		mysql_tquery(g_SQL, query);
		
		Servers(otherplayer, "Admin %s telah mengganti nickname anda menjadi (%s)", pData[playerid][pAdminname], nname);
		Info(otherplayer, "Pastikan anda mengingat dan mengganti nickname anda pada saat login kembali!");
		SendStaffMessage(COLOR_RED, "Admin %s telah mengganti nickname player %s(%d) menjadi %s", pData[playerid][pAdminname], oldname, otherplayer, nname);
		new str[150];
		format(str,sizeof(str),"Admin: %s mengganti nama %s menjadi %s!", GetRPName(playerid), GetRPName(otherplayer), nname);
		LogServer("Admin", str);
		
		SetPlayerName(otherplayer, nname);
		GetPlayerName(otherplayer, newname, sizeof(newname));
		pData[otherplayer][pName] = newname;
		pData[otherplayer][pID] = id;
		// House
		foreach(new h : Houses)
		{
			if(!strcmp(hData[h][hOwner], oldname, true))
   			{
   			    // Has House
   			    format(hData[h][hOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET owner='%s', ownerid='%d' WHERE ID=%d", newname, id, h);
				mysql_tquery(g_SQL, query);
				House_Refresh(h);
			}
		}
		// Bisnis
		foreach(new b : Bisnis)
		{
			if(!strcmp(bData[b][bOwner], oldname, true))
   			{
   			    // Has Business
   			    format(bData[b][bOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET owner='%s', ownerid='%d' WHERE ID=%d", newname, id, b);
				mysql_tquery(g_SQL, query);
				Bisnis_Refresh(b);
			}
		}
		foreach(new w : Workshop)
		{
			if(!strcmp(wsData[w][wOwner], oldname, true))
			{
				format(wsData[w][wOwner], 24, "%s", newname);
				mysql_format(g_SQL, query, sizeof(query), "UPDATE workshop SET owner='%s', ownerid='%d' WHERE ID=%d", newname, id, w);
				mysql_tquery(g_SQL, query);
				Workshop_Refresh(w);
			}
		}
		foreach(new v : Vendings)
		{
			if(!strcmp(VendingData[v][vendingOwner], oldname, true))
			{
				format(VendingData[v][vendingOwner], 24, "%s", newname);
				mysql_format(g_SQL, query, sizeof(query), "UPDATE vending SET owner='%s', ownerid='%d' WHERE ID=%d", newname, id, v);
				mysql_tquery(g_SQL, query);
				Vending_RefreshObject(v);
				Vending_RefreshText(v);	
			}
		}	
		if(pData[playerid][PurchasedToy] == true)
		{
			mysql_format(g_SQL, query, sizeof(query), "UPDATE toys SET Owner='%s' WHERE Owner='%s'", newname, oldname);
			mysql_tquery(g_SQL, query);
		}
		/*// Update Family
		if(pGroupRank[otherplayer] == 6)
		{
			format(query, sizeof(query), "UPDATE groups SET gFounder='%s' WHERE gFounder='%s'", newname, oldname);
			MySQL_updateQuery(query);
		}*/
	}
	else
	{
	    // Name Exists
		Error(playerid, "The name "DARK_E"'%s' "WHITE_E"already exists in the database, please use a different name!", nname);
	}
    return 1;
}

function ChangeName(playerid, nname[])
{
	if(!cache_num_rows())
	{
		if(pData[playerid][pGold] < 500) return Error(playerid, "Not enough gold!");
		pData[playerid][pGold] -= 500;
		
		new oldname[24], newname[24], query[248], id;
		GetPlayerName(playerid, oldname, sizeof(oldname));
		
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET username='%s' WHERE reg_id=%d", nname, pData[playerid][pID]);
		mysql_tquery(g_SQL, query);
		
		Servers(playerid, "Anda telah mengganti nickname anda menjadi (%s)", nname);
		Info(playerid, "Pastikan anda mengingat dan mengganti nickname anda pada saat login kembali!");
		SendStaffMessage(COLOR_RED, "Player %s(%d) telah mengganti nickname menjadi %s(%d)", oldname, playerid, nname, playerid);
		
		SetPlayerName(playerid, nname);
		GetPlayerName(playerid, newname, sizeof(newname));
		pData[playerid][pName] = newname;
		pData[playerid][pID] = id;
		
		// House
		foreach(new h : Houses)
		{
			if(!strcmp(hData[h][hOwner], oldname, true))
   			{
   			    // Has House
   			    format(hData[h][hOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET owner='%s', ownerid='%d' WHERE ID=%d", newname, id, h);
				mysql_tquery(g_SQL, query);
				House_Refresh(h);
			}
		}
		// Bisnis
		foreach(new b : Bisnis)
		{
			if(!strcmp(bData[b][bOwner], oldname, true))
   			{
   			    // Has Business
   			    format(bData[b][bOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET owner='%s', ownerid='%d' WHERE ID=%d", newname, id, b);
				mysql_tquery(g_SQL, query);
				Bisnis_Refresh(b);
			}
		}
		foreach(new w : Workshop)
		{
			if(!strcmp(wsData[w][wOwner], oldname, true))
			{
				format(wsData[w][wOwner], 24, "%s", newname);
				mysql_format(g_SQL, query, sizeof(query), "UPDATE workshop SET owner='%s', ownerid='%d' WHERE ID=%d", newname, id, w);
				mysql_tquery(g_SQL, query);
				Workshop_Refresh(w);
			}
		}
		foreach(new v : Vendings)
		{
			if(!strcmp(VendingData[v][vendingOwner], oldname, true))
			{
				format(VendingData[v][vendingOwner], 24, "%s", newname);
				mysql_format(g_SQL, query, sizeof(query), "UPDATE vending SET owner='%s', ownerid='%d' WHERE ID=%d", newname, id, v);
				mysql_tquery(g_SQL, query);
				Vending_RefreshObject(v);
				Vending_RefreshText(v);	
			}
		}	
		if(pData[playerid][PurchasedToy] == true)
		{
			mysql_format(g_SQL, query, sizeof(query), "UPDATE toys SET Owner='%s' WHERE Owner='%s'", newname, oldname);
			mysql_tquery(g_SQL, query);
		}
		/*// Update Family
		if(pGroupRank[otherplayer] == 6)
		{
			format(query, sizeof(query), "UPDATE groups SET gFounder='%s' WHERE gFounder='%s'", newname, oldname);
			MySQL_updateQuery(query);
		}*/
	}
	else
	{
	    // Name Exists
		Error(playerid, "The name "DARK_E"'%s' "WHITE_E"already exists in the database, please use a different name!", nname);
		return 1;
	}
    return 1;
}

function NonRPName(playerid, nname[])
{
	if(!cache_num_rows())
	{		
		new oldname[24], newname[24], query[248], id;
		GetPlayerName(playerid, oldname, sizeof(oldname));
		
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET username='%s' WHERE reg_id=%d", nname, pData[playerid][pID]);
		mysql_tquery(g_SQL, query);
		
		Servers(playerid, "Anda telah mengganti nickname anda menjadi (%s)", nname);
		SendStaffMessage(COLOR_RED, "Player %s(%d) telah mengganti nickname menjadi %s(%d), Reason: Non RP Name", oldname, playerid, nname, playerid);
		
		SetPlayerName(playerid, nname);
		GetPlayerName(playerid, newname, sizeof(newname));
		pData[playerid][pName] = newname;
		pData[playerid][pID] = id;
		
		// House
		foreach(new h : Houses)
		{
			if(!strcmp(hData[h][hOwner], oldname, true))
   			{
   			    // Has House
   			    format(hData[h][hOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET owner='%s', ownerid='%d' WHERE ID=%d", newname, id, h);
				mysql_tquery(g_SQL, query);
				House_Refresh(h);
			}
		}
		// Bisnis
		foreach(new b : Bisnis)
		{
			if(!strcmp(bData[b][bOwner], oldname, true))
   			{
   			    // Has Business
   			    format(bData[b][bOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET owner='%s', ownerid='%d' WHERE ID=%d", newname, id, b);
				mysql_tquery(g_SQL, query);
				Bisnis_Refresh(b);
			}
		}
		foreach(new w : Workshop)
		{
			if(!strcmp(wsData[w][wOwner], oldname, true))
			{
				format(wsData[w][wOwner], 24, "%s", newname);
				mysql_format(g_SQL, query, sizeof(query), "UPDATE workshop SET owner='%s', ownerid='%d' WHERE ID=%d", newname, id, w);
				mysql_tquery(g_SQL, query);
				Workshop_Refresh(w);
			}
		}
		foreach(new v : Vendings)
		{
			if(!strcmp(VendingData[v][vendingOwner], oldname, true))
			{
				format(VendingData[v][vendingOwner], 24, "%s", newname);
				mysql_format(g_SQL, query, sizeof(query), "UPDATE vending SET owner='%s', ownerid='%d' WHERE ID=%d", newname, id, v);
				mysql_tquery(g_SQL, query);
				Vending_RefreshObject(v);
				Vending_RefreshText(v);	
			}
		}	
		if(pData[playerid][PurchasedToy] == true)
		{
			mysql_format(g_SQL, query, sizeof(query), "UPDATE toys SET Owner='%s' WHERE Owner='%s'", newname, oldname);
			mysql_tquery(g_SQL, query);
		}
		/*// Update Family
		if(pGroupRank[otherplayer] == 6)
		{
			format(query, sizeof(query), "UPDATE groups SET gFounder='%s' WHERE gFounder='%s'", newname, oldname);
			MySQL_updateQuery(query);
		}*/
	}
	else
	{
	    // Name Exists
		Error(playerid, "The name "DARK_E"'%s' "WHITE_E"already exists in the database, please use a different name!", nname);
		return 1;
	}
    return 1;
}

CMD:setbooster(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new dayz, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, dayz))
	{
	    SyntaxMsg(playerid, "/setbooster <ID/Name> <time (in days) 0 for permanent>");
	    return true;
	}
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	if(dayz < 0)
		return Error(playerid, "Time can't be lower than 0!");

	if(pData[otherid][IsLoggedIn] == false)
	{
		Error(playerid, "Player %s(%i) isn't logged in!", pData[otherid][pName], otherid);
		return true;
	}

	if(pData[playerid][pAdmin] < 5 && dayz > 7)
		return Error(playerid, "Anda hanya bisa menset 1 - 7 hari!");

	pData[otherid][pBooster] = 1;
	if(dayz == 0)
	{
		pData[otherid][pBoostTime] = 0;
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s(%d) telah menset Roleplay Booster kepada %s(%d) ke level permanent time!", pData[playerid][pAdminname], playerid, pData[otherid][pName], otherid);
	}
	else
	{
		pData[otherid][pBoostTime] = gettime() + (dayz * 86400);
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s(%d) telah menset Roleplay Booster kepada %s(%d) selama %d hari!", pData[playerid][pAdminname], playerid, pData[otherid][pName], otherid, dayz);
	}

	format(tmp, sizeof(tmp), "(%d days)", dayz);
	StaffCommandLog("SETBOOSTER", playerid, otherid, tmp);
	return 1;
}


CMD:setvip(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new alevel, dayz, otherid, tmp[64];
	if(sscanf(params, "udd", otherid, alevel, dayz))
	{
	    SyntaxMsg(playerid, "/setvip <ID/Name> <level 0 - 3> <time (in days) 0 for permanent>");
	    return true;
	}
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	if(alevel > 3)
		return Error(playerid, "Level can't be higher than 3!");
	if(alevel < 0)
		return Error(playerid, "Level can't be lower than 0!");
	if(dayz < 0)
		return Error(playerid, "Time can't be lower than 0!");
		
	if(pData[otherid][IsLoggedIn] == false)
	{
		Error(playerid, "Player %s(%i) isn't logged in!", pData[otherid][pName], otherid);
		return true;
	}
	
	if(pData[playerid][pAdmin] < 5 && dayz > 7)
		return Error(playerid, "Anda hanya bisa menset 1 - 7 hari!");
	
	pData[otherid][pVip] = alevel;
	if(dayz == 0)
	{
		pData[otherid][pVipTime] = 0;
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s(%d) telah menset VIP kepada %s(%d) ke level %s permanent time!", pData[playerid][pAdminname], playerid, pData[otherid][pName], otherid, GetVipRank(otherid));
		new str[150];
		format(str,sizeof(str),"Admin: %s menyetel VIP ke %s, permanen jenis %s!", GetRPName(playerid), GetRPName(otherid), GetVipRank(otherid));
		LogServer("Admin", str);
	}
	else
	{
		pData[otherid][pVipTime] = gettime() + (dayz * 86400);
		SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s(%d) telah menset VIP kepada %s(%d) selama %d hari ke level %s!", pData[playerid][pAdminname], playerid, pData[otherid][pName], otherid, dayz, GetVipRank(otherid));
		new str[150];
		format(str,sizeof(str),"Admin: %s menyetel VIP ke %s selama %d hari jenis %s!", GetRPName(playerid), GetRPName(otherid), dayz, GetVipRank(otherid));
		LogServer("Admin", str);
	}
	
	format(tmp, sizeof(tmp), "%d(%d days)", alevel, dayz);
	StaffCommandLog("SETVIP", playerid, otherid, tmp);
	return 1;
}

CMD:giveweap(playerid, params[])
{
    static
        weaponid,
        ammo;
		
	new otherid;
    if(pData[playerid][pAdmin] < 4)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

    if(sscanf(params, "udI(250)", otherid, weaponid, ammo))
        return SyntaxMsg(playerid, "/givewep [playerid/PartOfName] [weaponid] [ammo]");

   // if(otherid == INVALID_PLAYER_ID)
     //   return Error(playerid, "You cannot give weapons to disconnected players.");


    if(weaponid <= 0 || weaponid > 46 || (weaponid >= 19 && weaponid <= 21))
        return Error(playerid, "You have specified an invalid weapon.");

    if(ammo < 1 || ammo > 500)
        return Error(playerid, "You have specified an invalid weapon ammo, 1 - 500");
    GivePlayerWeapon(otherid, weaponid, ammo);
	new str[150];
	format(str,sizeof(str),"You have give ~p~%s ~w~a %s with %d ammo.", pData[otherid][pName], ReturnWeaponName(weaponid), ammo);
	SuccesMsg(playerid, str);
    return 1;
}

CMD:setfaction(playerid, params[])
{
	new fid, rank, otherid, tmp[64];
    if(pData[playerid][pAdmin] < 4)
    	if(pData[playerid][pFactionModerator] < 1)	
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

    if(sscanf(params, "udd", otherid, fid, rank))
        return SyntaxMsg(playerid, "/setfaction [playerid/PartOfName] [1.SAPD, 2.SAGS, 3.SAMD, 4.SANEW 5.PEDAGANG 6.GOJEK 7.BENGKEL]  [rank 1-13]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	if(pData[otherid][pFamily] != -1)
		return Error(playerid, "Player tersebut sudah bergabung family");

    if(fid < 0 || fid > 7)
        return Error(playerid, "You have specified an invalid faction ID 0 - 7.");
		
	if(rank < 1 || rank > 13)
        return Error(playerid, "You have specified an invalid rank 1 - 12.");

	if(fid == 0)
	{
		pData[otherid][pFaction] = 0;
		pData[otherid][pFactionRank] = 0;
		Servers(playerid, "You have removed %s's from faction.", pData[otherid][pName]);
		Servers(otherid, "%s has removed your faction.", pData[playerid][pName]);
		new str[150];
		format(str,sizeof(str),"Admin: %s mengeluarkan %s dari fraksi!", GetRPName(playerid), GetRPName(otherid));
		LogServer("Admin", str);
	}
	else
	{
		pData[otherid][pFaction] = fid;
		pData[otherid][pFactionRank] = rank;
		Servers(playerid, "You have set %s's faction ID %d with rank %d.", pData[otherid][pName], fid, rank);
		Servers(otherid, "%s has set your faction ID to %d with rank %d.", pData[playerid][pName], fid, rank);
		new str[150];
		format(str,sizeof(str),"Admin: %s menyetel faction id %d & rank %d ke %s!", GetRPName(playerid), fid, rank, GetRPName(otherid));
		LogServer("Admin", str);
	}
	
	format(tmp, sizeof(tmp), "%d(%d rank)", fid, rank);
	StaffCommandLog("SETFACTION", playerid, otherid, tmp);
    return 1;
}

CMD:setleader(playerid, params[])
{
	new fid, otherid, tmp[64];
    if(pData[playerid][pAdmin] < 6)
		if(pData[playerid][pFactionModerator] < 1)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

    if(sscanf(params, "ud", otherid, fid))
        return SyntaxMsg(playerid, "/setleader [playerid/PartOfName] [0.None, 1.SAPD, 2.SAGS, 3.SAMD, 4.SANEW, 5.PEDAGANG 6.GOJEK 7.BENGKEL]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	if(pData[otherid][pFamily] != -1)
		return Error(playerid, "Player tersebut sudah bergabung family");

    if(fid < 0 || fid > 7)
        return Error(playerid, "You have specified an invalid faction ID 0 - 7.");

	if(fid == 0)
	{
		pData[otherid][pFaction] = 0;
		pData[otherid][pFactionLead] = 0;
		pData[otherid][pFactionRank] = 0;
		Servers(playerid, "You have removed %s's from faction leader.", pData[otherid][pName]);
		Servers(otherid, "%s has removed your faction leader.", pData[playerid][pName]);
		new str[150];
		format(str,sizeof(str),"Admin: %s mengeluarkan %s dari ketu fraksi!", GetRPName(playerid), GetRPName(otherid));
		LogServer("Admin", str);
	}
	else
	{
		pData[otherid][pFaction] = fid;
		pData[otherid][pFactionLead] = fid;
		pData[otherid][pFactionRank] = 13;
		Servers(playerid, "You have set %s's faction ID %d with leader.", pData[otherid][pName], fid);
		Servers(otherid, "%s has set your faction ID to %d with leader.", pData[playerid][pName], fid);
		new str[150];
		format(str,sizeof(str),"Admin: %s menyetel ketua faction id %d ke %s!", GetRPName(playerid), fid, GetRPName(otherid));
		LogServer("Admin", str);
	}
	
	format(tmp, sizeof(tmp), "%d", fid);
	StaffCommandLog("SETLEADER", playerid, otherid, tmp);
    return 1;
}

CMD:takemoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	new money, otherid;
	if(sscanf(params, "ud", otherid, money))
	{
	    SyntaxMsg(playerid, "/takemoney <ID/Name> <amount>");
	    return true;
	}

	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

 	if(money > pData[otherid][pMoney])
		return Error(playerid, "Player doesn't have enough money to deduct from!");

	GivePlayerMoneyEx(otherid, -money);
	SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s(%i) has taken away money "RED_E"%s {ffff00}from %s", pData[playerid][pAdminname], FormatMoney(money), pData[otherid][pName]);
	new str[150];
	format(str,sizeof(str),"Admin: %s mengambil %s dari %s !", GetRPName(playerid), FormatMoney(money), GetRPName(otherid));
	LogServer("Admin", str);
	return true;
}

CMD:takegold(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	new gold, otherid;
	if(sscanf(params, "ud", otherid, gold))
	{
	    SyntaxMsg(playerid, "/takegold <ID/Name> <amount>");
	    return true;
	}

	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

 	if(gold > pData[otherid][pGold])
		return Error(playerid, "Player doesn't have enough gold to deduct from!");

	pData[otherid][pGold] -= gold;
	SendClientMessageToAllEx(COLOR_RED, "Server: {ffff00}Admin %s(%i) has taken away gold "RED_E"%d {ffff00}from %s", pData[playerid][pAdminname], gold, pData[otherid][pName]);
	new str[150];
	format(str,sizeof(str),"Admin: %s mengambil %d Gold dari %s !", GetRPName(playerid), gold, GetRPName(otherid));
	LogServer("Admin", str);
	return 1;
}

CMD:veh(playerid, params[])
{
    static
        model[32],
        color1,
        color2;

    if(pData[playerid][pAdmin] < 2)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

    if(sscanf(params, "s[32]I(0)I(0)", model, color1, color2))
        return SyntaxMsg(playerid, "/veh [model id/name] <color 1> <color 2>");

    if((model[0] = GetVehicleModelByName(model)) == 0)
        return Error(playerid, "Invalid model ID.");

    static
        Float:x,
        Float:y,
        Float:z,
        Float:a,
        vehicleid;

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    vehicleid = CreateVehicle(model[0], x, y, z, a, color1, color2, 600);
	AdminVehicle{vehicleid} = true;

    if(GetPlayerInterior(playerid) != 0)
        LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

    if(GetPlayerVirtualWorld(playerid) != 0)
        SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));

    if(IsABoat(vehicleid) || IsAPlane(vehicleid) || IsAHelicopter(vehicleid))
        PutPlayerInVehicle(playerid, vehicleid, 0);

    SetVehicleNumberPlate(vehicleid, "STATIC");
    Servers(playerid, "Anda memunculkan %s (%d, %d).", GetVehicleModelName(model[0]), color1, color2);
    return 1;
}

CMD:destroyveh(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if(pData[playerid][pAdmin] < 2)
	{
	    return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	}
	if(AdminVehicle{vehicleid})
	{
	    DestroyVehicle(vehicleid);
	    AdminVehicle{vehicleid} = false;
	    return Servers(playerid, "Kendaraan admin dihancurkan.");
	}

	for(new i = 1; i < MAX_VEHICLES; i ++)
	{
	    if(AdminVehicle{i})
	    {
	        DestroyVehicle(i);
	        AdminVehicle{i} = false;
		}
	}

	SendStaffMessage(COLOR_RED, "%s menghancurkan semua kendaraan yang dispawn admin.", pData[playerid][pAdminname]);
	return 1;
}

CMD:agl(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new otherid;
	if(sscanf(params, "u", otherid))
        return SyntaxMsg(playerid, "/agl [playerid id/name]");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
		
	SendStaffMessage(COLOR_RED, "%s telah memberi sim kepada player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah memberi sim anda", pData[playerid][pAdminname]);
	return 1;
}
//-----------------------------[ Admin Level 5 ]------------------
CMD:sethelperlevel(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new alevel, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, alevel))
	{
	    SyntaxMsg(playerid, "/sethelperlevel <ID/Name> <level 0 - 3>");
	    return true;
	}
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	if(alevel > 3)
		return Error(playerid, "Level can't be higher than 3!");
	if(alevel < 0)
		return Error(playerid, "Level can't be lower than 0!");
	
	if(pData[otherid][IsLoggedIn] == false)
	{
		Error(playerid, "Player %s(%i) isn't logged in!", pData[otherid][pName], otherid);
		return true;
	}
	pData[otherid][pHelper] = alevel;
	Servers(playerid, "You has set helper level %s(%d) to level %d", pData[otherid][pName], otherid, alevel);
	Servers(otherid, "%s(%d) has set your helper level to %d", pData[otherid][pName], playerid, alevel);
	SendStaffMessage(COLOR_RED, "Admin %s telah menset %s(%d) sebagai staff helper level %s(%d)",  pData[playerid][pAdminname], pData[otherid][pName], otherid, GetStaffRank(playerid), alevel);
	new str[150];
	format(str,sizeof(str),"Admin: %s menyetel level helper %d ke %s!", GetRPName(playerid), alevel, GetRPName(otherid));
	LogServer("Admin", str);
	
	format(tmp, sizeof(tmp), "%d", alevel);
	StaffCommandLog("SETHELPERLEVEL", playerid, otherid, tmp);
	return 1;
}

CMD:settwittername(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new aname[128], otherid, query[128], string[63];
	if(sscanf(params, "us[128]", otherid, aname))
	{
	    SyntaxMsg(playerid, "/settwittername <ID/Name> <Twitter name>");
	    return true;
	}
	
	format(string, sizeof(string), "%s", aname);
	pData[otherid][pRegTwitter] = 1;
	mysql_format(g_SQL, query, sizeof(query), "SELECT twittername FROM players WHERE twittername='%s'", aname);
	mysql_tquery(g_SQL, query, "a_ChangeTwitterName", "iis", otherid, playerid, aname);
	return 1;
}

CMD:setadminname(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new aname[128], otherid, query[128];
	if(sscanf(params, "us[128]", otherid, aname))
	{
	    SyntaxMsg(playerid, "/setadminname <ID/Name> <admin name>");
	    return true;
	}
	
	mysql_format(g_SQL, query, sizeof(query), "SELECT adminname FROM players WHERE adminname='%s'", aname);
	mysql_tquery(g_SQL, query, "a_ChangeAdminName", "iis", otherid, playerid, aname);
	return 1;
}

CMD:resetmoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	foreach(new z : Player) pData[z][pMoney] = 1500;
	
	return 1;
}

CMD:setmoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    SyntaxMsg(playerid, "/setmoney <ID/Name> <money>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	ResetPlayerMoneyEx(otherid);
	GivePlayerMoneyEx(otherid, money);
	
	Servers(playerid, "Kamu telah mengset uang %s(%d) menjadi %s!", pData[otherid][pName], otherid, FormatMoney(money));
	Servers(otherid, "Admin %s telah mengset uang anda menjadi %s!",pData[playerid][pAdminname], FormatMoney(money));
	new str[150];
	format(str,sizeof(str),"Admin: %s menyetel uang %s ke %s!", GetRPName(playerid), FormatMoney(money), GetRPName(otherid));
	LogServer("Admin", str);
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("SETMONEY", playerid, otherid, tmp);
	return 1;
}

CMD:givemoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    SyntaxMsg(playerid, "/givemoney <ID/Name> <money>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	GivePlayerMoneyEx(otherid, money);
	
	Servers(playerid, "Kamu telah memberikan uang %s(%d) dengan jumlah %s!", pData[otherid][pName], otherid, FormatMoney(money));
	new str[150];
	format(str,sizeof(str),"~p~Admin %s ~w~telah memberikan uang kepada anda dengan jumlah ~y~%s!", pData[playerid][pAdminname], FormatMoney(money));
	InfoMsg(otherid, str);
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("GIVEMONEY", playerid, otherid, tmp);
	
	new duet[500];
	format(duet, sizeof(duet), "Received_%sx", FormatMoney(money));
	ShowItemBox(playerid, "Uang", duet, 1212, 4);

	new dc[128];
    format(dc, sizeof(dc),  "```\nAdmin: %s memberikan uang %s ke %s!\n```", GetRPName(playerid), FormatMoney(money), GetRPName(otherid));
	SendDiscordMessage(10, dc);
	return 1;
}

CMD:givemoneyall(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	new money;
	if(sscanf(params, "d", money))
	{
	    SyntaxMsg(playerid, "/givemoneyall <money>");
	    return true;
	}

	foreach(new pid : Player)
	{
		GivePlayerMoneyEx(pid, money);
		new str[500];
		format(str, sizeof(str), "Admin %s telah memberikan %s kepada semua player online", pData[playerid][pAdminname], FormatMoney(money));
		InfoMsg(pid, str);
		format(str,sizeof(str),"Admin: %s memberikan uang kesemua player sejumlah %s", GetRPName(playerid), FormatMoney(money));
		LogServer("Admin", str);
		new duet[500];
		format(duet, sizeof(duet), "Received_%sx", FormatMoney(money));
		ShowItemBox(pid, "Uang", duet, 1212, 4);
	}
	
	new dc[128];
	format(dc, sizeof(dc),  "```\nAdmin: %s memberikan uang kesemua player sejumlah %s\n```", GetRPName(playerid), FormatMoney(money));
	SendDiscordMessage(10, dc);
	return 1;
}
CMD:sethpall(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	new lstr[1024];
	format(lstr, sizeof(lstr), "ADMINISTRATOR | %s: {ffffff}Telah menyembuhkan semua player yang ada di kota", pData[playerid][pAdminname]);
    SendClientMessageToAll(COLOR_PINK2, lstr);
	foreach(new pid : Player)
	{
	    SetPlayerHealth(pid, 100);
	}
	return 1;
}
CMD:setstressall(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
    new lstr[1024];
	format(lstr, sizeof(lstr), "ADMINISTRATOR | %s: {ffffff}Telah mereset stress semua player yang ada di kota", pData[playerid][pAdminname]);
	SendClientMessageToAll(COLOR_PINK2, lstr);
	foreach(new pid : Player)
	{
	    pData[pid][pBladder] = 0;
	}
	return 1;
}
CMD:setbankmoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    SyntaxMsg(playerid, "/setbankmoney <ID/Name> <money>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	pData[playerid][pBankMoney] = money;
	
	Servers(playerid, "Kamu telah mengset uang rekening banki %s(%d) menjadi %s!", pData[otherid][pName], otherid, FormatMoney(money));
	Servers(otherid, "Admin %s telah mengset uang rekening bank anda menjadi %s!",pData[playerid][pAdminname], FormatMoney(money));
	new str[150];
	format(str,sizeof(str),"Admin: %s menyetel uang bank %s ke %s!", GetRPName(playerid), FormatMoney(money), GetRPName(otherid));
	LogServer("Admin", str);
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("SETBANKMONEY", playerid, otherid, tmp);
	return 1;
}

CMD:givebankmoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    SyntaxMsg(playerid, "/givebankmoney <ID/Name> <money>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	pData[playerid][pBankMoney] += money;
	
	Servers(playerid, "Kamu telah memberikan uang rekening bank %s(%d) dengan jumlah %s!", pData[otherid][pName], otherid, FormatMoney(money));
	Servers(otherid, "Admin %s telah memberikan uang rekening bank kepada anda dengan jumlah %s!", pData[playerid][pAdminname], FormatMoney(money));
	new str[150];
	format(str,sizeof(str),"Admin: %s memberikan uang bank %s ke %s!", GetRPName(playerid), FormatMoney(money), GetRPName(otherid));
	LogServer("Admin", str);
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("GIVEBANKMONEY", playerid, otherid, tmp);
	return 1;
}

CMD:setvw(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return SyntaxMsg(playerid, "/setvw [playerid id/name] <virtual world>");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
		
	SetPlayerVirtualWorld(otherid, jumlah);
	Servers(otherid, "Admin %s telah men set Virtual World anda", pData[playerid][pAdminname]);
	return 1;
}

CMD:setint(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return SyntaxMsg(playerid, "/setint [playerid id/name] <interior>");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
		
	SetPlayerInterior(otherid, jumlah);
	Servers(otherid, "Admin %s telah men set Interior anda", pData[playerid][pAdminname]);
	return 1;
}

CMD:explode(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	new Float:POS[3], otherid, giveplayer[24];
	if(sscanf(params, "u", otherid))
	{
		SyntaxMsg(playerid, "/explode <ID/Name>");
		return true;
	}

	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

	GetPlayerName(otherid, giveplayer, sizeof(giveplayer));

	Servers(playerid, "You have exploded %s(%i).", giveplayer, otherid);
	GetPlayerPos(otherid, POS[0], POS[1], POS[2]);
	CreateExplosion(POS[0], POS[1], POS[2], 12, 5.0);
	return true;
}

//--------------------------[ Admin Level 6 ]-------------------
CMD:setadminlevel(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new alevel, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, alevel))
	{
	    SyntaxMsg(playerid, "/setadminlevel <ID/Name> <level 0 - 5>");
	    return true;
	}
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	if(alevel > 6)
		return Error(playerid, "Level can't be higher than 6!");
	if(alevel < 0)
		return Error(playerid, "Level can't be lower than 0!");
	
	if(pData[otherid][IsLoggedIn] == false)
	{
		Error(playerid, "Player %s(%i) isn't logged in!", pData[otherid][pName], otherid);
		return true;
	}
	pData[otherid][pAdmin] = alevel;
	Servers(playerid, "You has set admin level %s(%d) to level %d", pData[otherid][pName], otherid, alevel);
	Servers(otherid, "%s(%d) has set your admin level to %d", pData[otherid][pName], playerid, alevel);
	new str[150];
	format(str,sizeof(str),"Admin: %s menyetel level admin %d ke %s!", GetRPName(playerid), alevel, GetRPName(otherid));
	LogServer("Admin", str);
	
	format(tmp, sizeof(tmp), "%d", alevel);
	StaffCommandLog("SETADMINLEVEL", playerid, otherid, tmp);
	return 1;
}

CMD:setgold(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	new gold, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, gold))
	{
	    SyntaxMsg(playerid, "/setgold <ID/Name> <gold>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	pData[otherid][pGold] = gold;
	
	Servers(playerid, "Kamu telah menset gold %s(%d) dengan jumlah %d!", pData[otherid][pName], otherid, gold);
	Servers(otherid, "Admin %s telah menset gold kepada anda dengan jumlah %d!", pData[playerid][pAdminname], gold);
	new str[150];
	format(str,sizeof(str),"Admin: %s menyetel %d Gold ke %s!", GetRPName(playerid), gold, GetRPName(otherid));
	LogServer("Admin", str);
	
	format(tmp, sizeof(tmp), "%d", gold);
	StaffCommandLog("SETGOLD", playerid, otherid, tmp);
	return 1;
}

CMD:givegold(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	new gold, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, gold))
	{
	    SyntaxMsg(playerid, "/givegold <ID/Name> <gold>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	pData[otherid][pGold] += gold;
	
	Servers(playerid, "Kamu telah memberikan gold %s(%d) dengan jumlah %d!", pData[otherid][pName], otherid, gold);
	Servers(otherid, "Admin %s telah memberikan gold kepada anda dengan jumlah %d!", pData[playerid][pAdminname], gold);
	new str[150];
	format(str,sizeof(str),"Admin: %s memberikan %d Gold ke %s!", GetRPName(playerid), gold, GetRPName(otherid));
	LogServer("Admin", str);

	format(tmp, sizeof(tmp), "%d", gold);
	StaffCommandLog("GIVEGOLD", playerid, otherid, tmp);
	return 1;
}

CMD:agive(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	if(IsPlayerConnected(playerid)) 
	{
		new name[24], ammount, otherid;
        if(sscanf(params, "us[24]d", otherid, name, ammount))
		{
			SyntaxMsg(playerid, "/agive [playerid] [name] [ammount]");
			Info(playerid, "Names: bandage, medicine, snack, sprunk, material, component, marijuana, obat, gps");
			return 1;
		}
			
		if(strcmp(name,"bandage",true) == 0) 
		{
			if(pData[playerid][pBandage] < ammount)
				return Error(playerid, "Item anda tidak cukup.");
			
			pData[otherid][pBandage] += ammount;
			Info(playerid, "Anda telah berhasil memberikan perban kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan perban kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"medicine",true) == 0) 
		{
			pData[otherid][pMedicine] += ammount;
			Info(playerid, "Anda telah berhasil memberikan medicine kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan medicine kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"snack",true) == 0) 
		{
			pData[otherid][pSnack] += ammount;
			Info(playerid, "Anda telah berhasil memberikan snack kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan snack kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"sprunk",true) == 0) 
		{
			pData[otherid][pSprunk] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Sprunk kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Sprunk kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"material",true) == 0) 
		{
			
			if(ammount > 500)
				return Error(playerid, "Invalid ammount 1 - 500");
			
			new maxmat = pData[otherid][pMaterial] + ammount;
			
			if(maxmat > 500)
				return Error(playerid, "That player already have maximum material!");
			
			pData[otherid][pMaterial] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Material kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Material kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"component",true) == 0) 
		{
			
			if(ammount > 500)
				return Error(playerid, "Invalid ammount 1 - 500");
			
			new maxcomp = pData[otherid][pComponent] + ammount;
			
			if(maxcomp > 500)
				return Error(playerid, "That player already have maximum component!");
			
			pData[otherid][pComponent] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Component kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Component kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"marijuana",true) == 0) 
		{
			pData[otherid][pMarijuana] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Marijuana kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Marijuana kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"obat",true) == 0) 
		{	
			pData[otherid][pObat] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Obat kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan Obat kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(name,"gps",true) == 0) 
		{
			pData[otherid][pGPS] += ammount;
			Info(playerid, "Anda telah berhasil memberikan GPS kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "Admin %s telah berhasil memberikan GPS kepada anda sejumlah %d.", pData[playerid][pAdminname], ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
		}
	}
	return 1;
}

CMD:setprice(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	new name[64], string[128];
	if(sscanf(params, "s[64]S()[128]", name, string))
    {
        SyntaxMsg(playerid, "/setprice [name] [price]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} [MaterialPrice], [LumberPrice], [ComponentPrice], [MetalPrice], [GasOilPrice], [CoalPrice], [ProductPrice]");
		SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} [FoodPrice], [FishPrice], [GsPrice], [ObatPrice], [ayamfilletprice] ");
        return 1;
    }
	if(!strcmp(name, "materialprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [materialprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        MaterialPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set material price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "lumberprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [lumberprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        LumberPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set lumber price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "ayamfilletprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [ayamfilletprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        AyamFillPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set ayamfillet price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "componentprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [componentprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        ComponentPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set component price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "metalprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [metalprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        MetalPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set metal price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "gasoilprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [gasoilprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        GasOilPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set gasoil price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "coalprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [coalprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        CoalPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set coal price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "productprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [productprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        ProductPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set product price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "medicineprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [medicineprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        MedicinePrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set medicine price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "medkitprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [medkitprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        MedkitPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set medkit price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "foodprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [foodprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        FoodPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set food price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "fishprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [fishprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        FishPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set fish price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "gsprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [gsprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        GStationPrice = price;
		foreach(new gsid : GStation)
		{
			if(Iter_Contains(GStation, gsid))
			{
				GStation_Save(gsid);
				GStation_Refresh(gsid);
			}
		}
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set gs price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "obatprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/setprice [obatprice] [price]");

        if(price < 0 || price > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        ObatPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set obat price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	return 1;
}

CMD:setstock(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	new name[64], string[128];
	if(sscanf(params, "s[64]S()[128]", name, string))
    {
        SyntaxMsg(playerid, "/setstock [name] [stock]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} [material], [component], [product], [gasoil] [food] [obat] [ayamfillet]");
        return 1;
    }
	if(!strcmp(name, "material", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/setstok [material] [stok]");

        if(stok < 0 || stok > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        Material = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set material to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "component", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/setstok [component] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 50000.");

        Component = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set component to %d.", pData[playerid][pAdminname], stok);
    }
    else if(!strcmp(name, "ayamfillet", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/setstok [ayamfillet] [stok]");

        if(stok < 0 || stok > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        AyamFill = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set ayamfillet to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "product", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/setstok [product] [stok]");

        if(stok < 0 || stok > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        Product = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set product to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "gasoil", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/setstok [gasoil] [stok]");

        if(stok < 0 || stok > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        GasOil = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set gasoil to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "apotek", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/setstok [apotek] [stok]");

        if(stok < 0 || stok > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        Apotek = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set apotek stok to %d.", pData[playerid][pAdminname], stok);
    }
    else if(!strcmp(name, "pedagang", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/setstok [pedagang] [stok]");

        if(stok < 0 || stok > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        Pedagang = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set pedagang stok to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "food", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/setstok [food] [stok]");

        if(stok < 0 || stok > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        Food = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set food stok to %d.", pData[playerid][pAdminname], stok);
    }
    else if(!strcmp(name, "obat", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return SyntaxMsg(playerid, "/setstok [obat] [stok]");

        if(stok < 0 || stok > 5000)
            return Error(playerid, "Kamu harus menspesifi setidaknya dari 0 sampai 5000.");

        ObatMyr = stok;
		Server_Save();
        SendAdminMessage(COLOR_RED, "%s set obat stok to %d.", pData[playerid][pAdminname], stok);
    }
	new str[150];
	format(str,sizeof(str),"Admin: %s menyetel %s jumlah %d!", GetRPName(playerid), name, string);
	LogServer("Admin", str);
	return 1;
}

CMD:kickall(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	foreach(new pid : Player)
	{
		if(pid != playerid)
		{
			UpdateWeapons(playerid);
			UpdatePlayerData(playerid);
			Servers(pid, "Sorry, server will be maintenance and your data have been saved.");
			KickEx(pid);
		}
	}
	return 1;
}

CMD:setpassword(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new cname[21], query[128], pass[65], tmp[64];
	if(sscanf(params, "s[21]s[20]", cname, pass))
	{
	    SyntaxMsg(playerid, "/setpassword <name> <new password>");
	    Info(playerid, "Make sure you enter the players name and not ID!");
	   	return 1;
	}

	mysql_format(g_SQL, query, sizeof(query), "SELECT password FROM playerucp WHERE ucp='%s'", cname);
	mysql_tquery(g_SQL, query, "ChangePlayerPassword", "iss", playerid, cname, pass);
	
	format(tmp, sizeof(tmp), "%s", pass);
	StaffCommandLog("SETPASSWORD", playerid, INVALID_PLAYER_ID, tmp);
	return 1;
}

// SetPassword Callback
function ChangePlayerPassword(admin, cPlayer[], newpass[])
{
	if(cache_num_rows() > 0)
	{
		new query[512], pass[65], salt[16];
		Servers(admin, "Password for %s has been set to \"%s\"", cPlayer, newpass);
		
		for (new i = 0; i < 16; i++) salt[i] = random(94) + 33;
		SHA256_PassHash(newpass, salt, pass, 65);

		mysql_format(g_SQL, query, sizeof(query), "UPDATE playerucp SET password='%s', salt='%e' WHERE ucp='%s'", pass, salt, cPlayer);
		mysql_tquery(g_SQL, query);
	}
	else
	{
	    // Name Exists
		Error(admin, "The name"DARK_E"'%s' "WHITE_E"doesn't exist in the database!", cPlayer);
	}
    return 1;
}


CMD:playsong(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new songname[128], tmp[512], Float:x, Float:y, Float:z;
	if (sscanf(params, "s[128]", songname))
	{
		SyntaxMsg(playerid, "/playsong <link>");
		return 1;
	}
	
	GetPlayerPos(playerid, x, y, z);
	format(tmp, sizeof(tmp), "%s", songname);
	foreach(new ii : Player)
	{
		if(IsPlayerInRangeOfPoint(ii, 35.0, x, y, z))
		{
			PlayAudioStreamForPlayer(ii, tmp);
			Servers(ii, "/stopsong, /togsong");
		}
	}
	return 1;
}

CMD:playnearsong(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new songname[128], tmp[512], Float:x, Float:y, Float:z;
	if (sscanf(params, "s[128]", songname))
	{
		SyntaxMsg(playerid, "/playnearsong <link>");
		return 1;
	}
	
	GetPlayerPos(playerid, x, y, z);
	format(tmp, sizeof(tmp), "%s", songname);
	foreach(new ii : Player)
	{
		if(IsPlayerInRangeOfPoint(ii, 35.0, x, y, z))
		{
			PlayAudioStreamForPlayer(ii, tmp, x, y, z, 35.0, 1);
			Servers(ii, "/stopsong, /togsong");
		}
	}
	return 1;
}

CMD:stopsong(playerid)
{
	StopAudioStreamForPlayer(playerid);
	Servers(playerid, "Song stop!");
	return 1;
}

CMD:anticheat(playerid, params[])
{
	new status;

	if(pData[playerid][pAdmin] < 5)
	{
	    return Error(playerid, "Kamu tidak diizinkan untuk menggunakan command ini.");
	}
	if(sscanf(params, "i", status) || !(0 <= status <= 1))
	{
	    return SyntaxMsg(playerid, "/anticheat [0/1]");
	}

	if(status) {
		SendAdminMessage(COLOR_RED, "[ANTICHEAT]:"WHITE_E" %s telah mengaktifkan anticheat server .", ReturnName(playerid));
	} else {
		SendAdminMessage(COLOR_RED, "[ANTICHEAT]:"WHITE_E" %s telah menonaktifkan anticheat server .", ReturnName(playerid));
	}

	AntiCheatKontol = status;
	return 1;
}

CMD:setstat(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	if(IsPlayerConnected(playerid)) 
	{
		new name[24], query[248], param[32], ammount, otherid;
        if(sscanf(params, "us[24]S()[32]", otherid, name, param))
		{
			SyntaxMsg(playerid, "/setstat [playerid] [names]");
			Info(playerid, "Names: Level, LevelUp, Gold, Money, Bank, Health, Armour, Hunger, Energy, lockpick");
			Info(playerid, "Names: PhoneCredit, Job1, Job2, Fish, Worm, Sprunk, Snack, Seed, Food, Potato");
			Info(playerid, "Names: Wheat, Orange, Bandage, Medkit, Medicine, Marijuana, Component, Material");
			Info(playerid, "Names: Borax, paketborax, Kecubug, paketkecubung, uangmerah");
			return 1;
		}
			
		if(!strcmp(name, "level", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [level] [ammount]");
			}

			pData[otherid][pLevel] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Level {FFFF00}%s {ffffff}ke level %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Level{ffffff} kamu ke %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET level = %i WHERE reg_id = %i", pData[otherid][pLevel], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "levelup", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [levelup] [ammount]");
			}

			pData[otherid][pLevelUp] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Poin Level {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Poin Level{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET levelup = %i WHERE reg_id = %i", pData[otherid][pLevelUp], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "gold", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [gold] [ammount]");
			}

			pData[otherid][pGold] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Gold {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Gold{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET gold = %i WHERE reg_id = %i", pData[otherid][pGold], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "money", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [money] [ammount]");
			}

			pData[otherid][pMoney] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Money {FFFF00}%s {ffffff}menjadi %s.", pData[playerid][pAdminname], ReturnName(otherid), FormatMoney(ammount));
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Money{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET money = %i WHERE reg_id = %i", pData[otherid][pMoney], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "bank", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [bank] [ammount]");
			}

			pData[otherid][pBankMoney] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Bank Money {FFFF00}%s {ffffff}menjadi %s.", pData[playerid][pAdminname], ReturnName(otherid), FormatMoney(ammount));
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Bank Money{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney = %i WHERE reg_id = %i", pData[otherid][pBankMoney], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "phonecredit", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [phonecredit] [ammount]");
			}

			pData[otherid][pPhoneCredit] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Phone Credit {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Phone Credit{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET phonecredit = %i WHERE reg_id = %i", pData[otherid][pPhoneCredit], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "health", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [health] [ammount]");
			}

			pData[otherid][pHealth] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Health {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Health{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET health = %i WHERE reg_id = %i", pData[otherid][pHealth], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "armour", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [armour] [ammount]");
			}

			pData[otherid][pArmour] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Armour {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Armour{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET armour = %i WHERE reg_id = %i", pData[otherid][pArmour], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "hunger", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [hunger] [ammount]");
			}

			pData[otherid][pHunger] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Hunger {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Hunger{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET hunger = %i WHERE reg_id = %i", pData[otherid][pHunger], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "energy", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [energy] [ammount]");
			}

			pData[otherid][pEnergy] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Energy {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Energy{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET energy = %i WHERE reg_id = %i", pData[otherid][pEnergy], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "job1", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				SyntaxMsg(playerid, "/setstat [playerid] [job1] [ammount]");
				Info(playerid, "Names: <1> Taxi, <2> Mechanic, <3> LumberJack, <4> Trucker, <5> Miner");
				Info(playerid, "Names: <6> Production, <7> Farmer, <8> Kurir, <9> Smuggler, <10> Baggage");
				Info(playerid, "Names: <11> Pemotong Ayam, <12> Sparepart");
				return 1;
			}
			if(!(0 <= ammount <= 12))
			{
				return Error(playerid, "Invalid job.");
			}

			pData[otherid][pJob] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Job {FFFF00}%s {ffffff}menjadi %s.", pData[playerid][pAdminname], ReturnName(otherid), GetJobName(ammount));
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Job{ffffff} kamu menjadi %s.", pData[playerid][pAdminname], GetJobName(ammount));

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET job = %i WHERE reg_id = %i", pData[otherid][pJob], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "job2", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				SyntaxMsg(playerid, "/setstat [playerid] [job2] [ammount]");
				Info(playerid, "Names: <1> Taxi, <2> Mechanic, <3> LumberJack, <4> Trucker, <5> Miner");
				Info(playerid, "Names: <6> Production, <7> Farmer, <8> Kurir, <9> Smuggler, <10> Baggage");
				Info(playerid, "Names: <11> Pemotong Ayam, <12> Sparepart");
				return 1;
			}
			if(!(0 <= ammount <= 12))
			{
				return Error(playerid, "Invalid job.");
			}

			pData[otherid][pJob2] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Second Job {FFFF00}%s {ffffff}menjadi %s.", pData[playerid][pAdminname], ReturnName(otherid), GetJobName(ammount));
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Second Job{ffffff} kamu menjadi %s.", pData[playerid][pAdminname], GetJobName(ammount));

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET job2 = %i WHERE reg_id = %i", pData[otherid][pJob2], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "medicine", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [medicine] [ammount]");
			}

			pData[otherid][pMedicine] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Medicine {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Medicine{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET medicine = %i WHERE reg_id = %i", pData[otherid][pMedicine], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "medkit", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [medkit] [ammount]");
			}

			pData[otherid][pMedkit] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Medkit {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Medicine{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET Medkit = %i WHERE reg_id = %i", pData[otherid][pMedkit], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "snack", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [snack] [ammount]");
			}

			pData[otherid][pSnack] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Snack {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Snack{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET snack = %i WHERE reg_id = %i", pData[otherid][pSnack], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "sprunk", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [sprunk] [ammount]");
			}

			pData[otherid][pSprunk] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Sprunk {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Sprunk{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET sprunk = %i WHERE reg_id = %i", pData[otherid][pSprunk], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "bandage", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [bandage] [ammount]");
			}

			pData[otherid][pBandage] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Bandage {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Bandage{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bandage = %i WHERE reg_id = %i", pData[otherid][pBandage], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "material", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [material] [ammount]");
			}

			pData[otherid][pMaterial] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Material {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Material{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET material = %i WHERE reg_id = %i", pData[otherid][pMaterial], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "component", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [component] [ammount]");
			}

			pData[otherid][pComponent] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Component {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Component{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET component = %i WHERE reg_id = %i", pData[otherid][pComponent], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "food", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [food] [ammount]");
			}

			pData[otherid][pFood] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Food {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Food{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET food = %i WHERE reg_id = %i", pData[otherid][pFood], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "seed", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [seed] [ammount]");
			}

			pData[otherid][pSeed] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Seed {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Seed{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET seed = %i WHERE reg_id = %i", pData[otherid][pSeed], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "potato", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [potato] [ammount]");
			}

			pData[otherid][pPotato] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Potato {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Potato{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET potato = %i WHERE reg_id = %i", pData[otherid][pPotato], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "orange", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [orange] [ammount]");
			}

			pData[otherid][pOrange] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Orange {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Orange{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET orange = %i WHERE reg_id = %i", pData[otherid][pOrange], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "wheat", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [wheat] [ammount]");
			}

			pData[otherid][pWheat] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Wheat {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Wheat{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET wheat = %i WHERE reg_id = %i", pData[otherid][pWheat], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "marijuana", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [marijuana] [ammount]");
			}

			pData[otherid][pMarijuana] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Marijuana {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Marijuana{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET marijuana = %i WHERE reg_id = %i", pData[otherid][pMarijuana], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "fish", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [fish] [ammount]");
			}

			pData[otherid][pFish] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Fish {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Fish{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET fish = %i WHERE reg_id = %i", pData[otherid][pFish], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "worm", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [worm] [ammount]");
			}

			pData[otherid][pWorm] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Worm {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Worm{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET worm = %i WHERE reg_id = %i", pData[otherid][pWorm], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "fam", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [fam] [ammount]");
			}

			pData[otherid][pFamily] = ammount;
			pData[otherid][pFamilyRank] = 1;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Family {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Family{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET family = %i, familyrank = %i WHERE reg_id = %i", pData[otherid][pFamily], pData[otherid][pFamilyRank], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "lockpick", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [lockpick] [ammount]");
			}

			pData[otherid][pLockPick] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Lockpick {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Lockpick{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET lockpick = %i WHERE reg_id = %i", pData[otherid][pLockPick], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "borax", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [borax] [ammount]");
			}

			pData[otherid][pBorax] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Borax {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Borax{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET borax = %i WHERE reg_id = %i", pData[otherid][pBorax], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "kecubung", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [kecubung] [ammount]");
			}

			pData[otherid][pKecubung] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Kecubung {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Kecubung{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET kecubung = %i WHERE reg_id = %i", pData[otherid][pKecubung], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "paketkecubung", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [paketkecubung] [ammount]");
			}

			pData[otherid][pPaketkecubung] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Paket Kecubung {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Paket Kecubung{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET paketkecubung = %i WHERE reg_id = %i", pData[otherid][pPaketkecubung], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "paketborax", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [paketborax] [ammount]");
			}

			pData[otherid][pPaketborax] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Paket Borax {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Paket Borax{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET paketborax = %i WHERE reg_id = %i", pData[otherid][pPaketborax], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else if(!strcmp(name, "uangmerah", true)) 
		{			
			if(sscanf(param, "i", ammount))
			{
				return SyntaxMsg(playerid, "/setstat [playerid] [uangmerah] [ammount]");
			}

			pData[otherid][pRedMoney] = ammount;
			AdminCMD(playerid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Uang Merah {FFFF00}%s {ffffff}menjadi %d.", pData[playerid][pAdminname], ReturnName(otherid), ammount);
			AdminCMD(otherid, "{FFFF00}%s {ffffff}telah menyetel {15D4ED}Uang Merah{ffffff} kamu menjadi %d.", pData[playerid][pAdminname], ammount);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET redmoney = %i WHERE reg_id = %i", pData[otherid][pRedMoney], pData[otherid][pID]);
	    	mysql_tquery(g_SQL, query);
		}
		else 
		{
			return 1;
		}
	}	
	return 1;
}

CMD:clearallchat(playerid)
{
    if(pData[playerid][pAdmin] < 4)
	    return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	foreach(new i : Player)
	{
	    ClearAllChat(i);
	}
	SendAdminMessage(COLOR_RED, "%s {FFFFFF}telah membersihkan chat box.", pData[playerid][pAdminname]);
	return 1;
}

CMD:checkucp(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
			
	new name[24];
	if(sscanf(params, "s[24]", name))
	{
	    SyntaxMsg(playerid, "/checkucp <ucpname>");
 		return 1;
 	}

    new cQuery[600];

	mysql_format(g_SQL, cQuery, sizeof(cQuery), "SELECT username FROM players WHERE ucp='%e'", name);
	mysql_tquery(g_SQL, cQuery, "CheckUCP", "is", playerid, name);
	return true;
}

CMD:setadminmoderator(playerid, params[])
{
	new otherid, option[16], status;
	if(pData[playerid][pAdmin] < 6)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	if(sscanf(params, "us[16]i", otherid, option, status) || !(0 <= status <= 1))
	{
	    SyntaxMsg(playerid, "/setadminmod [playerid] [type] [status (0/1)]");
		Info(playerid, "Type: [1]ServerMod, [2]EventMod, [3]FactionMod, [4]FamilyMod");
		return 1;
	}
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");
	
	if(pData[otherid][IsLoggedIn] == false)
	{
		Error(playerid, "Player %s(%i) isn't logged in!", pData[otherid][pName], otherid);
		return true;
	}
	if(pData[otherid][pAdmin] < 1)
		return Error(playerid, "Player tersebut bukan team pengurus, set terlebih dahulu!");

	if(!strcmp(option, "1", true))
	{
	    pData[otherid][pServerModerator] = status;

	    if(status)
	    {
	        SendAdminMessage(COLOR_RED, "%s menyetel %s menjadi Moderator Server", GetRPName(playerid), GetRPName(otherid));
		    Servers(otherid, "%s menyetel kamu menjadi Moderator Server", GetRPName(playerid));
			new str[150];
			format(str,sizeof(str),"Admin: %s menyetel %s menjadi Moderator Server!", GetRPName(playerid), GetRPName(otherid));
			LogServer("Admin", str);
		}
		else
	    {
	        SendAdminMessage(COLOR_RED, "%s menyetel %s keluar dari Moderator Server", GetRPName(playerid), GetRPName(otherid));
		    Servers(otherid, "%s menyetel kamu keluar dari Moderator Server", GetRPName(playerid));
			new str[150];
			format(str,sizeof(str),"Admin: %s menyetel %s keluar dari Moderator Server!", GetRPName(playerid), GetRPName(otherid));
			LogServer("Admin", str);
		}
	}
	else if(!strcmp(option, "2", true))
	{
	    pData[otherid][pEventModerator] = status;

	    if(status)
	    {
	        SendAdminMessage(COLOR_RED, "%s menyetel %s menjadi Moderator Event", GetRPName(playerid), GetRPName(otherid));
		    Servers(otherid, "%s menyetel kamu menjadi Moderator Event", GetRPName(playerid));
			new str[150];
			format(str,sizeof(str),"Admin: %s menyetel %s menjadi Moderator Event!", GetRPName(playerid), GetRPName(otherid));
			LogServer("Admin", str);
		}
		else
	    {
	        SendAdminMessage(COLOR_RED, "%s menyetel %s keluar dari Moderator Event", GetRPName(playerid), GetRPName(otherid));
		    Servers(otherid, "%s menyetel kamu keluar dari Moderator Event", GetRPName(playerid));
			new str[150];
			format(str,sizeof(str),"Admin: %s menyetel %s keluar dari Moderator Event!", GetRPName(playerid), GetRPName(otherid));
			LogServer("Admin", str);
		}
	}
	else if(!strcmp(option, "3", true))
	{
	    pData[otherid][pFactionModerator] = status;

	    if(status)
	    {
	        SendAdminMessage(COLOR_RED, "%s menyetel %s menjadi Moderator Faction", GetRPName(playerid), GetRPName(otherid));
		    Servers(otherid, "%s menyetel kamu menjadi Moderator Faction", GetRPName(playerid));
			new str[150];
			format(str,sizeof(str),"Admin: %s menyetel %s menjadi Moderator Faction!", GetRPName(playerid), GetRPName(otherid));
			LogServer("Admin", str);
		}
		else
	    {
	        SendAdminMessage(COLOR_RED, "%s menyetel %s keluar dari Moderator Faction", GetRPName(playerid), GetRPName(otherid));
		    Servers(otherid, "%s menyetel kamu keluar dari Moderator Faction", GetRPName(playerid));
			new str[150];
			format(str,sizeof(str),"Admin: %s menyetel %s keluar dari Moderator Faction!", GetRPName(playerid), GetRPName(otherid));
			LogServer("Admin", str);
		}
	}
	else if(!strcmp(option, "4", true))
	{
	    pData[otherid][pFamilyModerator] = status;

	    if(status)
	    {
	        SendAdminMessage(COLOR_RED, "%s menyetel %s menjadi Moderator Family", GetRPName(playerid), GetRPName(otherid));
		    Servers(otherid, "%s menyetel kamu menjadi Moderator Family", GetRPName(playerid));
			new str[150];
			format(str,sizeof(str),"Admin: %s menyetel %s menjadi Moderator Family!", GetRPName(playerid), GetRPName(otherid));
			LogServer("Admin", str);
		}
		else
	    {
	        SendAdminMessage(COLOR_RED, "%s menyetel %s keluar dari Moderator Family", GetRPName(playerid), GetRPName(otherid));
		    Servers(otherid, "%s menyetel kamu keluar dari Moderator Family", GetRPName(playerid));
			new str[150];
			format(str,sizeof(str),"Admin: %s menyetel %s keluar dari Moderator Family!", GetRPName(playerid), GetRPName(otherid));
			LogServer("Admin", str);
		}
	}
	return 1;
}		

CMD:moderatorhelp(playerid, params[])
{
    new string[2000];
	if(pData[playerid][pAdmin] < 1)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	if(pData[playerid][pServerModerator])
	{
	    strcat(string, "{ffffff}==========> {ff0000}Server Moderator.\n\n");
		strcat(string, "{87CEFA}[ACTOR]: {ffffff}/createactor, /editactor, /deleteactor, /gotoactor\n");
		strcat(string, "{87CEFA}[ATM]: {ffffff}/createatm, /editatm, /removeatm, /gotoatm\n");
		strcat(string, "{87CEFA}[BUSINESS]: {ffffff}/createbiz, /editbiz, /gotobiz\n");
		strcat(string, "{87CEFA}[DOOR]: {ffffff}/createdoor, /editdoor, /gotodoor\n");
		strcat(string, "{87CEFA}[GARKOT]: {ffffff}/createpark, /setparkpos, /removepark, /gotopark\n");
		strcat(string, "{87CEFA}[GAS STATION]: {ffffff}/creategs, /editgs, /gotogs\n");
		strcat(string, "{87CEFA}[GATE]: {ffffff}/creategate, /gedit, /gotogate\n");
		strcat(string, "{87CEFA}[HOUSE]: {ffffff}/createhouse, /edithouse, /gotohouse\n");
		strcat(string, "{87CEFA}[SPEEDCAM]: {ffffff}/createsc, deletesc, /gotosc, /editsc - Note: Jangan diset dulu\n");
		strcat(string, "{87CEFA}[WORKSHOP]: {ffffff}/createws, /editws, /gotows\n\n");
	}
	if(pData[playerid][pEventModerator])
	{
	    strcat(string, "{ffffff}==========> {ff0000}Event Moderator.\n\n");
	    strcat(string, "{87CEFA}[EVENT]: {ffffff}/tdmhelp, /createtdm, /settdminfo /tdmpos /endtdm /starttdm /locktdm /announceevent\n\n");
	}
	if(pData[playerid][pFactionModerator])
	{
	    strcat(string, "{ffffff}==========> {ff0000}Faction Moderator.\n\n");
	    strcat(string, "{87CEFA}[LOCKER]: {ffffff}/createlocker, /editlocker, /gotolocker, /setleader\n\n");
	}
	if(pData[playerid][pFamilyModerator])
	{	
		strcat(string, "{ffffff}==========> {ff0000}Family Moderator.\n\n");
	    strcat(string, "{87CEFA}[FAMILY]: {ffffff}/fcreate, /fedit, /fdelete, /flist, /famint\n\n");
	}
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "{FF0000}Moderator Commands | Great Roleplay", string, "Close","");
	return 1;
}

CMD:aclaimpv(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
		
	new found = 0, otherid;

	if(sscanf(params, "d", otherid)) 
		return SyntaxMsg(playerid, "/aclaimpv [playerid]");
	if(otherid == INVALID_PLAYER_ID)
		return Error(playerid, "Invalid id");

	foreach(new i : PVehicles)
	{
		if(pvData[i][cClaim] > 0 && pvData[i][cClaimTime] > 0)
		{
			if(pvData[i][cOwner] == pData[otherid][pID])
			{
				pvData[i][cClaim] = 0;
				pvData[i][cClaimTime] = 0;
				
				OnPlayerVehicleRespawn(i);
				pvData[i][cPosX] = 1290.7111;
				pvData[i][cPosY] = -1243.8767;
				pvData[i][cPosZ] = 13.3901;
				pvData[i][cPosA] = 2.5077;
				SetValidVehicleHealth(pvData[i][cVeh], 1500);
				SetVehiclePos(pvData[i][cVeh], 1290.7111, -1243.8767, 13.3901);
				SetVehicleZAngle(pvData[i][cVeh], 2.5077);
				SetVehicleFuel(pvData[i][cVeh], 1000);
				ValidRepairVehicle(pvData[i][cVeh]);
				found++;
				Info(playerid, "Kamu telah mengclaim kendaraan player %s dengan model %s", ReturnName(otherid), GetVehicleModelName(pvData[i][cModel]));
				Info(otherid, "Kamu telah mengclaim kendaraan dengan model %s di bantu oleh admin %s", GetVehicleModelName(pvData[i][cModel]), pData[playerid][pAdminname]);
			}
			//else return Error(playerid, "ID kendaraan ini bukan punya mu! gunakan /mypv untuk mencari ID.");
		}
	}
	if(found == 0)
	{
		Info(playerid, "Sekarang belum saatnya anda mengclaim kendaraan anda!");
	}
	else
	{
		Info(playerid, "Kamu berhasil mengclaim %d kendaraan %s!", found, ReturnName(otherid));
		Info(otherid, "Kamu berhasil mengclaim %d kendaraan anda di bantu oleh admin %s!", found, pData[playerid][pAdminname]);
	}
	return 1;
}

CMD:cleardelays(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	pData[playerid][pJobTime] = 0;
	pData[playerid][pSideJobTime] = 0;
	return 1;
}

CMD:god(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	SetPlayerHealthEx(playerid, 100);
	SetPlayerArmourEx(playerid, 99999999);
	SuccesMsg(playerid, "Anda memakai mode tuhan");
	return 1;
}

CMD:loncat(playerid)
{
	SetPlayerPos(playerid, 2944.55396, -1803.82056, 1179.12158);
	SetPlayerFacingAngle(playerid, 0.0);
	SetPlayerVirtualWorld(playerid, 0);
	return 1;
}
CMD:nonrpname(playerid, params[])
{
	new otherid, string[256];
	if(pData[playerid][pAdmin] < 1)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	if(sscanf(params, "u", otherid))
	{
		SyntaxMsg(playerid, "/nonrpname <ID/ Name>");
		return true;
	}
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "No player online or name is not found!");

	format(string, sizeof (string), "{ff0000}Nama kamu non rp name!\n{ffffff}Contoh Nama RP: {3BBD44}James_Petterson, Antonio_Whitford, Javier_Valdes.{ffffff}\n\n{ffff00}Silahkan isi nama kamu baru dibawah ini!");
	ShowPlayerDialog(otherid, DIALOG_NONRPNAME, DIALOG_STYLE_INPUT, "{ffff00}Non Roleplay Name", string, "Change", "Cancel");
	return 1; 
}
