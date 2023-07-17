#define MAX_STORAGE 100

#define MAX_STORAGE_INT 10000

enum E_STORAGE
{
    sID,
    sName[24],
    sOwner[MAX_PLAYER_NAME + 1],
    sComp,
    sMat,
    sMoney,
    Text3D:sText,
    sPickup,
    Float:sgX,
    Float:sgY,
    Float:sgZ,
    sPrice
};
new sData[MAX_STORAGE][E_STORAGE],
    Iterator:Storage<MAX_STORAGE>;

Storage_Refresh(id)
{
    if(id > -1)
    {
        if(IsValidDynamic3DTextLabel(sData[id][sText]))
            DestroyDynamic3DTextLabel(sData[id][sText]), sData[id][sText] = Text3D: INVALID_3DTEXT_ID;

        if(IsValidDynamicPickup(sData[id][sPickup]))
            DestroyDynamicPickup(sData[id][sPickup]), sData[id][sPickup] = -1;
		new str[316];
        format(str, sizeof str,"[Storage ID:%d]\n{ffffff}Storage Price: {7fff00}%s{ffffff}\n{ffffff}Type '/buy' to buy this Storage", id, FormatMoney(sData[id][sPrice]));

        if(strcmp(sData[id][sOwner], "-", true))
            format(str, sizeof str,"[Storage ID:%d]\n{ffffff}Storage Name: %s\n{ffffff}Storage Owner: %s", id, sData[id][sName], sData[id][sOwner]);

        sData[id][sText] = CreateDynamic3DTextLabel(str, ARWIN, sData[id][sgX], sData[id][sgY], sData[id][sgZ]+0.5, 8.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1, -1, 8.0);
        sData[id][sPickup] = CreateDynamicPickup(1239, 23, sData[id][sgX], sData[id][sgY], sData[id][sgZ]+0.2, -1);
    }
}

Storage_Save(id)
{
    new query[2248];
    format(query, sizeof query,"UPDATE storage SET owner='%s', name='%s', component=%d, material=%d, money=%d, posx='%f', posy='%f', posz='%f', price=%d",
        sData[id][sOwner],
        sData[id][sName],
        sData[id][sComp],
        sData[id][sMat],
        sData[id][sMoney],
        sData[id][sgX],
        sData[id][sgY],
        sData[id][sgZ],
        sData[id][sPrice]);
    format(query, sizeof query,"%s WHERE id = %d", query, id);
    return mysql_tquery(g_SQL, query);
}

Storage_Reset(id)
{
    format(sData[id][sOwner], MAX_PLAYER_NAME, "-");
    sData[id][sComp] = 0;
    sData[id][sMat] = 0;
    sData[id][sMoney] = 0;
    Workshop_Refresh(id);
}



IsStorageOwner(playerid, id)
{
    if(!strcmp(sData[id][sOwner], pData[playerid][pName], true))
        return 1;

    return 0;
}

function LoadStorage()
{
    static sid;
	
	new rows = cache_num_rows(), owner[128], name[128];
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", sid);
			cache_get_value_name(i, "owner", owner);
			format(sData[sid][sOwner], 128, owner);
			cache_get_value_name(i, "name", name);
			format(sData[sid][sName], 128, name);
			cache_get_value_name_int(i, "price", sData[sid][sPrice]);
			cache_get_value_name_float(i, "posx", sData[sid][sgX]);
			cache_get_value_name_float(i, "posy", sData[sid][sgY]);
			cache_get_value_name_float(i, "posz", sData[sid][sgZ]);
			cache_get_value_name_int(i, "component", sData[sid][sComp]);
			cache_get_value_name_int(i, "material", sData[sid][sMat]);
            cache_get_value_name_int(i, "money", sData[sid][sMoney]);
			Storage_Refresh(sid);
			Iter_Add(Storage, sid);
		}
		printf("[STORAGE] Number of Loaded: %d.", rows);
	}
}

GetOwnedStorage(playerid)
{
	new tmpcount;
	foreach(new sid : Storage)
	{
	    if(!strcmp(sData[sid][sOwner], pData[playerid][pName], true))
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}

ReturnPlayerStorageID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;
	foreach(new sid : Storage)
	{
	    if(!strcmp(pData[playerid][pName], sData[sid][sOwner], true))
	    {
     		tmpcount++;
       		if(tmpcount == hslot)
       		{
        		return sid;
  			}
	    }
	}
	return -1;
}

GetAnyStorage()
{
	new tmpcount;
	foreach(new id : Storage)
	{
     	tmpcount++;
	}
	return tmpcount;
}

ReturnStorageID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_STORAGE) return -1;
	foreach(new id : Storage)
	{
        tmpcount++;
        if(tmpcount == slot)
        {
            return id;
        }
	}
	return -1;
}

CMD:smenu(playerid, params[])
{
    foreach(new id : Storage)
	{
        if(IsPlayerInRangeOfPoint(playerid, 2.0, sData[id][sgX], sData[id][sgY], sData[id][sgZ]))
        {
	        if(!IsStorageOwner(playerid, id))
	                return Error(playerid, "You're not the Owner this Storage");
	        ShowStorageMenu(playerid, id);
        }
    }
    return 1;
}

ShowStorageMenu(playerid, id)
{
    pData[playerid][pMenuTypeStorage] = 0;
    pData[playerid][pIns] = id;

    new str[256], vstr[64];
    format(vstr, sizeof vstr,"Executive - Storage (%s)", sData[id][sName]);
    format(str, sizeof str,"Set Storage Name\nComponent\t(%d/%d)\nMaterial\t(%d/%d)\nMoney\t({7fff00}%s{ffffff})",
    sData[id][sComp],
    MAX_STORAGE_INT,
    sData[id][sMat],
    MAX_STORAGE_INT,
    FormatMoney(sData[id][sMoney]));
	{
    ShowPlayerDialog(playerid, DIALOG_SG_MENU, DIALOG_STYLE_LIST, vstr, str, "Pilih", "Cancel");
 	}
    return 1;
}

CMD:createstorage(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
	
	new query[512];
	new sid = Iter_Free(Storage);
	if(sid == -1) return Error(playerid, "You cant create more Storage!");
	new price;
	if(sscanf(params, "d", price)) return Usage(playerid, "/createstorage [price]");
	new totalcash[25];
	format(totalcash, sizeof totalcash,"%d00",price);
	price = strval(totalcash);
	format(sData[sid][sOwner], MAX_PLAYER_NAME, "-");
    format(sData[sid][sName], 24, "-");
	GetPlayerPos(playerid, sData[sid][sgX], sData[sid][sgY], sData[sid][sgZ]);
	sData[sid][sPrice] = price;

    Storage_Refresh(sid);
	Iter_Add(Storage, sid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO storage SET id=%d, owner='%s', price=%d, posx='%f', posy='%f', posz='%f', name='%s'", sid, sData[sid][sOwner], sData[sid][sPrice], sData[sid][sgX], sData[sid][sgY], sData[sid][sgZ], sData[sid][sName]);
	mysql_tquery(g_SQL, query, "OnStorageCreated", "i", sid);
    Info(playerid, "Created Storage ID:%d", sid);
	return 1;
}

function OnStorageCreated(sid)
{
	Storage_Save(sid);
    Storage_Refresh(sid);
	return 1;
}

CMD:gotostorage(playerid, params[])
{
	new sid;
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
		
	if(sscanf(params, "d", sid))
		return Usage(playerid, "/gotostorage [id]");
	if(!Iter_Contains(Storage, sid)) return Error(playerid, "The Storage you specified ID of doesn't exist.");
	SetPlayerPos(playerid, sData[sid][sgX], sData[sid][sgY], sData[sid][sgZ]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
	Info(playerid, "You has teleport to Storage id %d", sid);
	return 1;
}

CMD:editstorage(playerid, params[])
{
    static
        sid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", sid, type, string))
    {
        Usage(playerid, "/editstorage [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location,  owner, price, money, comp, mat");
        return 1;
    }
    if((sid < 0 || sid >= MAX_STORAGE))
        return Error(playerid, "You have specified an invalid ID.");
	if(!Iter_Contains(Storage, sid)) return Error(playerid, "The Storage you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, sData[sid][sgX], sData[sid][sgY], sData[sid][sgZ]);
        Storage_Save(sid);
		Storage_Refresh(sid);

        SendAdminMessage(COLOR_RED, "%s has adjusted the location of Storage ID: %d.", pData[playerid][pAdminname], sid);
    }
 
    else if(!strcmp(type, "price", true))
    {
        new price;

        if(sscanf(string, "d", price))
            return Usage(playerid, "/editstorage [id] [Price] [Amount]");

        sData[sid][sPrice] = price;

        Storage_Save(sid);
		Storage_Refresh(sid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the price of Storage ID: %d to %d.", pData[playerid][pAdminname], sid, price);
    }
	else if(!strcmp(type, "money", true))
    {
        new money;

        if(sscanf(string, "d", money))
            return Usage(playerid, "/editstorage [id] [money] [Ammount]");

        sData[sid][sMoney] = money;
        Storage_Save(sid);
		Storage_Refresh(sid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the money of Workshop ID: %d to %s.", pData[playerid][pAdminname], sid, FormatMoney(money));
    }
	else if(!strcmp(type, "comp", true))
    {
        new amount;

        if(sscanf(string, "d", amount))
            return Usage(playerid, "/editstorage [id] [Comp] [Ammount]");

        sData[sid][sComp] = amount;
        Storage_Save(sid);
		Storage_Refresh(sid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the component of Workshop ID: %d to %d.", pData[playerid][pAdminname], sid, amount);
    }
    else if(!strcmp(type, "mat", true))
    {
        new amount;

        if(sscanf(string, "d", amount))
            return Usage(playerid, "/editWorkshop [id] [mat] [Ammount]");

        sData[sid][sMat] = amount;
        Storage_Save(sid);
		Storage_Refresh(sid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the material of Workshop ID: %d to %d.", pData[playerid][pAdminname], sid, amount);
    }
    else if(!strcmp(type, "owner", true))
    {
        new owners[MAX_PLAYER_NAME];

        if(sscanf(string, "s[24]", owners))
            return Usage(playerid, "/editWorkshop [id] [owner] [player name] (use '-' to no owner)");

        format(sData[sid][sOwner], MAX_PLAYER_NAME, owners);
  
        Storage_Save(sid);
		Storage_Refresh(sid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the owner of Workshop ID: %d to %s", pData[playerid][pAdminname], sid, owners);
    }
    else if(!strcmp(type, "reset", true))
    {
        Storage_Reset(sid);
		Storage_Save(sid);
		Storage_Refresh(sid);
        SendAdminMessage(COLOR_RED, "%s has reset Workshop ID: %d.", pData[playerid][pAdminname], sid);
    }
	else if(!strcmp(type, "delete", true))
    {
		Storage_Reset(sid);
		
		DestroyDynamic3DTextLabel(sData[sid][sText]);
        DestroyDynamicPickup(sData[sid][sPickup]);
		
		sData[sid][sgX] = 0;
		sData[sid][sgY] = 0;
		sData[sid][sgZ] = 0;
		sData[sid][sPrice] = 0;
		sData[sid][sText] = Text3D: INVALID_3DTEXT_ID;
		sData[sid][sPickup] = -1;
		
		Iter_Remove(Storage, sid);
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM Storage WHERE ID=%d", sid);
		mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_RED, "%s has delete Storage ID: %d.", pData[playerid][pAdminname], sid);
	}
    return 1;
}


CMD:mystorage(playerid)
{
	if(!GetOwnedStorage(playerid)) return Error(playerid, "You don't have any Storage.");
	new sid, _tmpstring[128], count = GetOwnedStorage(playerid), CMDSString[512];
	CMDSString = "";
	new lock[128];
	strcat(CMDSString,"No\tName(Status)\tLocation\n",sizeof(CMDSString));
	Loop(itt, (count + 1), 1)
	{
	    sid = ReturnPlayerStorageID(playerid, itt);
		{
		    format(_tmpstring, sizeof(_tmpstring), "%d\t%s{ffffff}(%s)\t%s{ffffff}\n", itt, sData[sid][sName], lock, GetLocation(sData[sid][sgX], sData[sid][sgY], sData[sid][sgZ]));
		}
		// format(_tmpstring, sizeof(_tmpstring), "%d\t%s{ffffff}(%s)\t%s{ffffff}\n", itt, sData[sid][sName], lock, GetLocation(sData[sid][sgX], sData[sid][sgY], sData[sid][sgZ]));
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_MY_SG, DIALOG_STYLE_TABLIST_HEADERS, "My Storage", CMDSString, "Track", "Cancel");
	return 1;
}
