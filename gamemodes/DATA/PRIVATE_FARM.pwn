#define MAX_FARM 5
enum e_farm
{
	farmName[50],
	farmLeader[MAX_PLAYER_NAME],
	farmMotd[100],
	Float:FarmSposX,
	Float:FarmSposY,
	Float:FarmSposZ,
	Float:FarmSposA,
	Float:FarmRepX,
	Float:FarmRepY,
	Float:FarmRepZ,
	farmMoney,
	farmSeeds,
	farmPotato,
	farmWheat,
	farmOrange,
	//Not Save
	Text3D:farmLabelSafe,
	farmPickSafe
};

new farmData[MAX_FARM][e_farm],
	Iterator:FARM<MAX_FARM>;

SaveFarm(fid)
{
	new dquery[2048];
	format(dquery, sizeof(dquery), "UPDATE farm SET name='%s', leader='%s', motd='%s'",
	farmData[fid][farmName],
	farmData[fid][farmLeader],
	farmData[fid][farmMotd]);
	
	format(dquery, sizeof(dquery), "%s, safex='%f', safey='%f', safez='%f', plantx='%f', planty='%f', plantz='%f', money='%d', potato='%d', wheat='%d', orange='%d' WHERE ID='%d'",
	dquery,
	farmData[fid][FarmSposX],
	farmData[fid][FarmSposY],
	farmData[fid][FarmSposZ],
	farmData[fid][FarmRepX],
	farmData[fid][FarmRepY],
	farmData[fid][FarmRepZ],
	farmData[fid][farmMoney],
	farmData[fid][farmPotato],
	farmData[fid][farmWheat],
	farmData[fid][farmOrange],
	fid);
	return mysql_tquery(g_SQL, dquery);
}


RefreshFarm(id)
{
	if(id != -1)
	{			
		if(IsValidDynamic3DTextLabel(farmData[id][farmLabelSafe]))
            DestroyDynamic3DTextLabel(farmData[id][farmLabelSafe]);

        if(IsValidDynamicPickup(farmData[id][farmPickSafe]))
            DestroyDynamicPickup(farmData[id][farmPickSafe]);
		
		new tstr[128];

		if(strcmp(farmData[id][farmLeader], "-"))
		{
			format(tstr, sizeof(tstr), "[ID: %d]\n"WHITE_E"Name: {FFFF00}%s\n"WHITE_E"Owned\n[{FF4040}STORAGE{ffffff}]", id, farmData[id][farmName]);
			farmData[id][farmLabelSafe] = CreateDynamic3DTextLabel(tstr, COLOR_GREEN, farmData[id][FarmSposX], farmData[id][FarmSposY], farmData[id][FarmSposZ], 5.0);
            farmData[id][farmPickSafe] = CreateDynamicPickup(1239, 23, farmData[id][FarmSposX], farmData[id][FarmSposY], farmData[id][FarmSposZ], id, 0, -1, 7);
		}
		else
		{
			format(tstr, sizeof(tstr), "[ID: %d]\n"WHITE_E"Name: {FFFF00}%s\n[{FF4040}This Farm For Sell{ffffff}]", id, farmData[id][farmName]);
			farmData[id][farmLabelSafe] = CreateDynamic3DTextLabel(tstr, COLOR_GREEN, farmData[id][FarmSposX], farmData[id][FarmSposY], farmData[id][FarmSposZ], 5.0);
            farmData[id][farmPickSafe] = CreateDynamicPickup(1239, 23, farmData[id][FarmSposX], farmData[id][FarmSposY], farmData[id][FarmSposZ], id, 0, -1, 7);
		}
	}
}

function OnFarmCreated(id)
{
	SaveFarm(id);
	RefreshFarm(id);
	return 1;
}

function LoadFarm()
{
    new rows = cache_num_rows();
 	if(rows)
  	{
   		new fid, name[50], leader[MAX_PLAYER_NAME], motd[100];
		for(new i; i < rows; i++)
		{
  			cache_get_value_name_int(i, "ID", fid);
	    	cache_get_value_name(i, "name", name);
			format(farmData[fid][farmName], 50, name);
		    cache_get_value_name(i, "leader", leader);
			format(farmData[fid][farmLeader], MAX_PLAYER_NAME, leader);
			cache_get_value_name(i, "motd", motd);
			format(farmData[fid][farmMotd], 100, motd);
		    cache_get_value_name_float(i, "plantx", farmData[fid][FarmRepX]);
		    cache_get_value_name_float(i, "planty", farmData[fid][FarmRepY]);
		    cache_get_value_name_float(i, "plantz", farmData[fid][FarmRepZ]);
			cache_get_value_name_float(i, "safex", farmData[fid][FarmSposX]);
			cache_get_value_name_float(i, "safey", farmData[fid][FarmSposY]);
			cache_get_value_name_float(i, "safez", farmData[fid][FarmSposZ]);
			cache_get_value_name_int(i, "money", farmData[fid][farmMoney]);
			cache_get_value_name_int(i, "potato", farmData[fid][farmPotato]);
			cache_get_value_name_int(i, "wheat", farmData[fid][farmWheat]);
			cache_get_value_name_int(i, "orange", farmData[fid][farmOrange]);
			
			Iter_Add(FARM, fid);
			RefreshFarm(fid);
	    }
	    printf("[FARM] Number of Farms loaded: %d.", rows);
	}
}

//----------[ Commands ]-----------

CMD:createfarm(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
		
	new fid = Iter_Free(FARM);
	if(fid == -1) return Error(playerid, "You cant create more farm slot empty!");
	new name[50], otherid, query[128];
	if(sscanf(params, "s[50]u", name, otherid)) return Usage(playerid, "/createfarm [name] [playerid]");
	if(otherid == INVALID_PLAYER_ID)
		return Error(playerid, "invalid playerid.");
	
	if(pData[otherid][pFarm] != -1)
		return Error(playerid, "Player tersebut sudah bergabung farm");
		
	pData[otherid][pFarm] = fid;
	pData[otherid][pFarmRank] = 6;
		
	format(farmData[fid][farmName], 50, name);
	format(farmData[fid][farmLeader], 50, pData[otherid][pName]);
	format(farmData[fid][farmMotd], 50, "None");
	farmData[fid][FarmRepX] = 0;
	farmData[fid][FarmRepY] = 0;
	farmData[fid][FarmRepZ] = 0;
	
	farmData[fid][farmMoney] = 0;
	farmData[fid][farmPotato] = 0;
	farmData[fid][farmWheat] = 0;
	farmData[fid][farmOrange] = 0;
	farmData[fid][FarmSposX] = 0;
	farmData[fid][FarmSposY] = 0;
	farmData[fid][FarmSposZ] = 0;

	Iter_Add(FARM, fid);

	Servers(playerid, "Anda telah berhasil membuat farm ID: %d dengan leader: %s", fid, pData[otherid][pName]);
	Servers(otherid, "Admin %s telah menset anda sebagai leader dari farm ID: %d", pData[playerid][pAdminname], fid);
	SendStaffMessage(COLOR_RED, "Admin %s telah membuat farm ID: %d dengan leader: %s", pData[playerid][pAdminname], fid, pData[otherid][pName]);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO farm SET ID=%d, name='%s', leader='%s'", fid, name, pData[otherid][pName]);	
	mysql_tquery(g_SQL, query, "OnFarmCreated", "i", fid);
	return 1;
}

CMD:deletefarm(playerid, params[])
{
 	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);

    new fid, query[128];
	if(sscanf(params, "i", fid)) return Usage(playerid, "/deletefarm [farmid]");
	if(!Iter_Contains(FARM, fid)) return Error(playerid, "The you specified ID of doesn't exist.");
	
    format(farmData[fid][farmName], 50, "None");
	format(farmData[fid][farmLeader], 50, "None");
	format(farmData[fid][farmMotd], 50, "None");
	farmData[fid][FarmRepX] = 0;
	farmData[fid][FarmRepY] = 0;
	farmData[fid][FarmRepZ] = 0;
	
	farmData[fid][farmMoney] = 0;
	farmData[fid][farmPotato] = 0;
	farmData[fid][farmWheat] = 0;
	farmData[fid][farmOrange] = 0;
	farmData[fid][FarmSposX] = 0;
	farmData[fid][FarmSposY] = 0;
	farmData[fid][FarmSposZ] = 0;
	
	DestroyDynamic3DTextLabel(farmData[fid][farmLabelSafe]);
	DestroyDynamicPickup(farmData[fid][farmPickSafe]);
	Iter_Remove(FARM, fid);

	mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET farm=-1,farmrank=0 WHERE farm=%d", fid);
	mysql_tquery(g_SQL, query);
	
	foreach(new ii : Player)
	{
 		if(pData[ii][pFarm] == fid)
   		{
			pData[ii][pFarm]= -1;
			pData[ii][pFarmRank] = 0;
		}
	}

	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM farm WHERE ID=%d", fid);
	mysql_tquery(g_SQL, query);
    SendStaffMessage(COLOR_RED, "Admin %s telah menghapus farm ID: %d.", pData[playerid][pAdminname], fid);
	return 1;
}

CMD:editfarm(playerid, params[])
{
    static
        fid,
        type[24],
        string[128],
		otherid;

    if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", fid, type, string))
    {
        Usage(playerid, "/editfarm [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} plantpos, name, leader, safe, money, potato");
        return 1;
    }
    if((fid < 0 || fid >= MAX_FARM))
        return Error(playerid, "You have specified an invalid ID.");
	if(!Iter_Contains(FARM, fid)) return Error(playerid, "The you specified ID of doesn't exist.");

    if(!strcmp(type, "plantpos", true))
    {
		GetPlayerPos(playerid, farmData[fid][FarmRepX], farmData[fid][FarmRepY], farmData[fid][FarmRepZ]);

        SaveFarm(fid);
		RefreshFarm(fid);

        SendStaffMessage(COLOR_RED, "%s has adjusted the plantpos of farm ID: %d.", pData[playerid][pAdminname], fid);
    }
    else if(!strcmp(type, "name", true))
    {
        new name[50];

        if(sscanf(string, "s[50]", name))
            return Usage(playerid, "/fedit [id] [name] [farmName]");

        format(farmData[fid][farmName], 50, name);
		SaveFarm(fid);
		RefreshFarm(fid);

        SendStaffMessage(COLOR_LRED, "Admin %s has changed the farm name ID: %d to: %s.", pData[playerid][pAdminname], fid, name);
    }
    else if(!strcmp(type, "leader", true))
    {
        if(sscanf(string, "d", otherid))
            return Usage(playerid, "/fedit [id] [leader] [playerid]");
		
		if(otherid == INVALID_PLAYER_ID)
			return Error(playerid, "invalid player id");

        format(farmData[fid][farmLeader], 50, pData[otherid][pName]);
		SaveFarm(fid);
		RefreshFarm(fid);

        SendStaffMessage(COLOR_LRED, "Admin %s has changed the farm leader ID: %d to: %s.", pData[playerid][pAdminname], fid, pData[otherid][pName]);
    }
    else if(!strcmp(type, "storage", true))
    {
        GetPlayerPos(playerid, farmData[fid][FarmSposX], farmData[fid][FarmSposY], farmData[fid][FarmSposZ]);

        SaveFarm(fid);
		RefreshFarm(fid);
		
		SendStaffMessage(COLOR_LRED, "Admin %s has changed the farm safepos ID: %d.", pData[playerid][pAdminname], fid);
    }
    else if(!strcmp(type, "money", true))
    {
        new money;

        if(sscanf(string, "d", money))
            return Usage(playerid, "/fedit [id] [money] [ammount]");

        farmData[fid][farmMoney] = money;
		
        SaveFarm(fid);
		RefreshFarm(fid);
		
		SendStaffMessage(COLOR_LRED, "Admin %s has changed the farm money ID: %d to %s.", pData[playerid][pAdminname], fid, FormatMoney(money));
    }
    else if(!strcmp(type, "potato", true))
    {
        new potato;

        if(sscanf(string, "d", potato))
            return Usage(playerid, "/fedit [id] [potato] [ammount]");

        farmData[fid][farmPotato] = potato;
		
        SaveFarm(fid);
		RefreshFarm(fid);
		
		SendStaffMessage(COLOR_LRED, "Admin %s has changed the farm potato ID: %d to %s.", pData[playerid][pAdminname], fid, potato);
    }
	else if(!strcmp(type, "wheat", true))
    {
        new comp;

        if(sscanf(string, "d", comp))
            return Usage(playerid, "/fedit [id] [wheat] [ammount]");

        farmData[fid][farmWheat] = comp;
		
        SaveFarm(fid);
		RefreshFarm(fid);
		
		SendStaffMessage(COLOR_LRED, "Admin %s has changed the farm wheat ID: %d to %s.", pData[playerid][pAdminname], fid, comp);
    }
	else if(!strcmp(type, "orange", true))
    {
        new mat;

        if(sscanf(string, "d", mat))
            return Usage(playerid, "/fedit [id] [orange] [ammount]");

        farmData[fid][farmPotato] = mat;
		
        SaveFarm(fid);
		RefreshFarm(fid);
		
		SendStaffMessage(COLOR_LRED, "Admin %s has changed the farm orange ID: %d to %s.", pData[playerid][pAdminname], fid, mat);
    }
    return 1;
}

CMD:fstorage(playerid)
{
	if(pData[playerid][pFarm] == -1)
		return Error(playerid, "Anda bukan anggota farm");
		
	new fid = pData[playerid][pFarm];
	if(IsPlayerInRangeOfPoint(playerid, 3.0, farmData[fid][FarmSposX], farmData[fid][FarmSposY], farmData[fid][FarmSposZ]))
    {
     	ShowPlayerDialog(playerid, FARM_STORAGE, DIALOG_STYLE_LIST, "Farm Storage", "Potato\nWheat\nOrange\nMoney", "Select", "Cancel");
    }
 	else
   	{
     	Error(playerid, "You aren't in range in area farm safe.");
    }
	return 1;
}

CMD:farminvite(playerid, params[])
{
	if(pData[playerid][pFarm] == -1)
		return Error(playerid, "You are not in farm!");
		
	if(pData[playerid][pFarmRank] < 5)
		return Error(playerid, "You must farm rank 5 - 6!");
	
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/invite [playerid/PartOfarmName]");
		
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");
		
	if(!NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "You must be near this player.");
	
	if(pData[otherid][pFarm] != -1)
		return Error(playerid, "Player tersebut sudah bergabung farm!");
	
	if(pData[otherid][pFaction] != 0)
		return Error(playerid, "Player tersebut sudah bergabung faction!");
		
	pData[otherid][pFarmInvite] = pData[playerid][pFarm];
	pData[otherid][pFarmOffer] = playerid;
	Servers(playerid, "Anda telah menginvite %s untuk menjadi anggota farm.", pData[otherid][pName]);
	Servers(otherid, "%s telah menginvite anda untuk menjadi anggota farm. Type: /accept farm or /deny farm!", pData[playerid][pName]);
	return 1;
}

CMD:farmuninvite(playerid, params[])
{
	if(pData[playerid][pFarm] == -1)
		return Error(playerid, "You are not in farm!");
		
	if(pData[playerid][pFarmRank] < 5)
		return Error(playerid, "You must farm level 5 - 6!");
	
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/uninvite [playerid/PartOfarmName]");
		
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");
	
	if(pData[otherid][pFarmRank] > pData[playerid][pFarmRank])
		return Error(playerid, "You cant kick him.");
		
	pData[otherid][pFarmRank] = 0;
	pData[otherid][pFarm] = -1;
	Servers(playerid, "Anda telah mengeluarkan %s dari anggota farm.", pData[otherid][pName]);
	Servers(otherid, "%s telah mengeluarkan anda dari anggota farm.", pData[playerid][pName]);
	return 1;
}

CMD:farmsetrank(playerid, params[])
{
	new rank, otherid;
	if(pData[playerid][pFarmRank] < 6)
		return Error(playerid, "You must farm leader!");
		
	if(sscanf(params, "ud", otherid, rank))
        return Usage(playerid, "/farmsetrank [playerid/PartOfarmName] [rank 1-6]");
	
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");
	
	if(pData[otherid][pFarm] != pData[playerid][pFarm])
		return Error(playerid, "This player is not in your farm!");
	
	if(rank < 1 || rank > 6)
		return Error(playerid, "rank must 1 - 6 only");
	
	pData[otherid][pFarmRank] = rank;
	Servers(playerid, "You has set %s farm rank to level %d", pData[otherid][pName], rank);
	Servers(otherid, "%s has set your farm rank to level %d", pData[playerid][pName], rank);
	return 1;
}

CMD:farminfo(playerid, params[])
{
	if(pData[playerid][pFarm] == -1)
        return Error(playerid, "You must in farm member to use this command!");
	
	ShowPlayerDialog(playerid, FARM_INFO, DIALOG_STYLE_LIST, "Farm Info", "Farm Info\nEmplooye Online\nEmplooye Member", "Select", "Cancel");
	return 1;
}

function ShowFarmInfo(playerid)
{
	new rows = cache_num_rows();
 	if(rows)
  	{
 		new frname[50],
 			frleader[50],
			frpotato,
			frwheat,
			frorange,
			frmoney,
			string[512];
			
		cache_get_value_index(0, 0, frname);
		cache_get_value_index(0, 1, frleader);
		cache_get_value_index_int(0, 2, frpotato);
		cache_get_value_index_int(0, 3, frwheat);
		cache_get_value_index_int(0, 4, frorange);
		cache_get_value_index_int(0, 5, frmoney);

		format(string, sizeof(string), "Farm ID: %d\nFarm Name: %s\nFarm Leader: %s\nFarm Potato: %d\nFarm Wheat: %d\nFarm Orange: %d\nFarm Money: %s",
		pData[playerid][pFarm], frname, frleader, frpotato, frwheat, frorange, FormatMoney(frmoney));
		
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Farm Info", string, "Okay", "");
	}
}

function ShowFarmMember(playerid)
{
	new rows = cache_num_rows(), pid, username[50], frank, query[1048];
 	if(rows)
  	{
		for(new i = 0; i != rows; i++)
		{
			cache_get_value_index(i, 0, username);
			pid = GetID(username);
			
			format(query, sizeof(query), "%s"WHITE_E"%d. %s ", query, (i+1), username);
			
			if(IsPlayerConnected(pid))
				strcat(query, ""GREEN_E"(ONLINE) ");
			else
				strcat(query, ""RED_E"(OFFLINE) ");
			
			cache_get_value_index_int(i, 1, frank);
			if(frank == 1)
			{
				strcat(query, ""FAMILY_E"Emplooye(1)");
			}
			else if(frank == 2)
			{
				strcat(query, ""FAMILY_E"Senior Emplooye(2)");
			}
			else if(frank == 3)
			{
				strcat(query, ""FAMILY_E"Co Ordinator(3)");
			}
			else if(frank == 4)
			{
				strcat(query, ""FAMILY_E"Ordinator(4)");
			}
			else if(frank == 5)
			{
				strcat(query, ""FAMILY_E"UnderBoss(5)");
			}
			else if(frank == 6)
			{
				strcat(query, ""FAMILY_E"Boss(6)");
			}
			else
			{
				strcat(query, ""FAMILY_E"None(0)");
			}
			strcat(query, "\n{FFFFFF}");
		}
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Farm Emplooye", query, "Okay", "");
	}
}
