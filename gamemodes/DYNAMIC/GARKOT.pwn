
#include <YSI_Coding\y_hooks>

#define MAX_GARKOT 500

enum E_GARKOT
{
	Float:gkX,
	Float:gkY,
	Float:gkZ,
	Float:gkA,
	Float:sgkX,
	Float:sgkY,
	Float:sgkZ,
	Float:sgkA,
	garkotmap,
	gkInt,
	gkVW,
	//temp
	gkPickup,
	sgkPickup,
	STREAMER_TAG_AREA:gkArea,
	STREAMER_TAG_OBJECT:gkObject,
	Text3D:gkText,
	STREAMER_TAG_AREA:sgkArea,
	STREAMER_TAG_OBJECT:sgkObject,
}

new gkData[MAX_GARKOT][E_GARKOT],
Iterator:Garkot<MAX_GARKOT>;

Garkot_Save(id)
{
	new cQuery[2248];
	format(cQuery, sizeof(cQuery), "UPDATE parks SET posx='%f', posy='%f', posz='%f', posa='%f', spawnx='%f', spawny='%f', spawnz='%f', spawna='%f', interior='%d', world='%d' WHERE id='%d'",
	gkData[id][gkX],
	gkData[id][gkY],
	gkData[id][gkZ],
	gkData[id][gkA],
	gkData[id][sgkX],
	gkData[id][sgkY],
	gkData[id][sgkZ],
	gkData[id][sgkA],
	gkData[id][gkInt],
	gkData[id][gkVW],
	id);

	return mysql_tquery(g_SQL, cQuery);
}

Garkot_Refresh(id)
{
	if(id != -1)
	{
		if(IsValidDynamic3DTextLabel(gkData[id][gkText]))
			DestroyDynamic3DTextLabel(gkData[id][gkText]);

		if(IsValidDynamicPickup(gkData[id][gkPickup]))
			DestroyDynamicPickup(gkData[id][gkPickup]);

		if(IsValidDynamicArea(gkData[id][gkArea]))
			DestroyDynamicArea(gkData[id][gkArea]);

		if(IsValidDynamicObject(gkData[id][gkObject]))
			DestroyDynamicObject(gkData[id][gkObject]);

		if(IsValidDynamicPickup(gkData[id][sgkPickup]))
			DestroyDynamicPickup(gkData[id][sgkPickup]);

		if(IsValidDynamicArea(gkData[id][sgkArea]))
			DestroyDynamicArea(gkData[id][sgkArea]);

		if(IsValidDynamicObject(gkData[id][sgkObject]))
			DestroyDynamicObject(gkData[id][sgkObject]);

        if(IsValidDynamicMapIcon(gkData[id][garkotmap]))
			DestroyDynamicMapIcon(gkData[id][garkotmap]);
		
		gkData[id][gkObject] = CreateDynamicObject(1316, gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ]-0.5, 0.0, 0.0, 0.0, gkData[id][gkVW], gkData[id][gkInt], -1, 50.00, 50.00);
		SetDynamicObjectMaterial(gkData[id][gkObject], 0, 18646, "matcolours", "white", 0xFF66FF99);
		gkData[id][gkArea] = CreateDynamicCircle(gkData[id][gkX], gkData[id][gkY], 2.0, gkData[id][gkVW], gkData[id][gkInt], -1);
		gkData[id][garkotmap] = CreateDynamicMapIcon(gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ], 55, 0, -1, -1, -1, 500.0, MAPICON_GLOBAL);

		gkData[id][sgkObject] = CreateDynamicObject(1316, gkData[id][sgkX], gkData[id][sgkY], gkData[id][sgkZ]-0.5, 0.0, 0.0, 0.0, gkData[id][gkVW], gkData[id][gkInt], -1, 50.00, 50.00);
		SetDynamicObjectMaterial(gkData[id][sgkObject], 0, 18646, "matcolours", "white", 0xFFCC3333);
		gkData[id][sgkArea] = CreateDynamicCircle(gkData[id][sgkX], gkData[id][sgkY], 2.0, gkData[id][gkVW], gkData[id][gkInt], -1);
	}
	return 1;
}

function LoadGarkot()
{
    static gkid;
	
	new rows = cache_num_rows();
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", gkid);
			cache_get_value_name_float(i, "posx", gkData[gkid][gkX]);
			cache_get_value_name_float(i, "posy", gkData[gkid][gkY]);
			cache_get_value_name_float(i, "posz", gkData[gkid][gkZ]);
			cache_get_value_name_float(i, "posa", gkData[gkid][gkA]);
			cache_get_value_name_float(i, "spawnx", gkData[gkid][sgkX]);
			cache_get_value_name_float(i, "spawny", gkData[gkid][sgkY]);
			cache_get_value_name_float(i, "spawnz", gkData[gkid][sgkZ]);
			cache_get_value_name_float(i, "spawna", gkData[gkid][sgkA]);
			cache_get_value_name_int(i, "interior", gkData[gkid][gkInt]);
			cache_get_value_name_int(i, "world", gkData[gkid][gkVW]);

			Garkot_Refresh(gkid);
			Iter_Add(Garkot, gkid);
		}
		printf("[Garasi Kota] Number of Loaded: %d.", rows);
	}
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		foreach(new id : Garkot)
		{
			if(IsPlayerInDynamicArea(playerid, gkData[id][gkArea]))
			{
				if(areaid == gkData[id][gkArea])
				{
					Jembut(playerid, "Mengambil Kendaraan", 5);
				}
			}
		}
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		foreach(new id : Garkot)
		{
			if(IsPlayerInDynamicArea(playerid, gkData[id][sgkArea]))
			{
				if(areaid == gkData[id][sgkArea])
				{
					if(IsPlayerAndroid(playerid))
					{
						InfoMsg(playerid, "Tekan Klakson Untuk memasukan kendaraan");
					}
					else
					{
						InfoMsg(playerid, "Tekan H Untuk memasukan kendaraan");
					}
				}
			}
		}
	}
	return 1;
}


hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_WALK) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		foreach(new id : Garkot)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.5, gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ]))
			{
				return callcmd::pickveh(playerid, "");
			}	
		}
	}
	if(PRESSED(KEY_CROUCH) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		foreach(new id : Garkot)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.5, gkData[id][sgkX], gkData[id][sgkY], gkData[id][sgkZ]))
			{
				return callcmd::parkveh(playerid, "");
			}	
		}
	}
	return 1;
}

CMD:creategarkot(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new gkid = Iter_Free(Garkot), query[512];

	if(gkid == -1)
		return ErrorMsg(playerid, "You cant create more garkot point!");

	GetPlayerPos(playerid, gkData[gkid][gkX], gkData[gkid][gkY],gkData[gkid][gkZ]);
	GetPlayerFacingAngle(playerid, gkData[gkid][gkA]);
	gkData[gkid][gkInt] = GetPlayerInterior(playerid);
	gkData[gkid][gkVW] = GetPlayerVirtualWorld(playerid);

	Garkot_Refresh(gkid);
	Iter_Add(Garkot, gkid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO parks SET id='%d'", gkid);
	mysql_tquery(g_SQL, query, "OnParkCreated", "i", gkid);
	return 1;
}

function OnParkCreated(gkid)
{
	Garkot_Save(gkid);
	return 1;
}

CMD:editposisi(playerid, params[])
{
    static
        gkid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 5)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

    if(sscanf(params, "ds[24]S()[128]", gkid, type, string))
    {
        SyntaxMsg(playerid, "/editposisi [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, spawn");
        return 1;
    }

    if(gkid < 0 || gkid >= MAX_GARKOT)
        return ErrorMsg(playerid, "You have specified an invalid ID.");

	if(!Iter_Contains(Garkot, gkid))
		return ErrorMsg(playerid, "The garkot you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		if(!IsPlayerInRangeOfPoint(playerid, 5.0, gkData[gkid][gkX], gkData[gkid][gkY],gkData[gkid][gkZ])) return ErrorMsg(playerid, "Kamu tidak berada di dekat garasi kota itu.");
		pData[playerid][EditingGarkot] = gkid;
		EditDynamicObject(playerid, gkData[gkid][gkObject]);
        Garkot_Save(gkid);
		Garkot_Refresh(gkid);
    }
    else if(!strcmp(type, "spawn", true))
    {
		if(!IsPlayerInRangeOfPoint(playerid, 5.0, gkData[gkid][sgkX], gkData[gkid][sgkY],gkData[gkid][sgkZ])) return ErrorMsg(playerid, "Kamu tidak berada di dekat garasi kota itu.");
		pData[playerid][EditingGarkot] = gkid;
		EditDynamicObject(playerid, gkData[gkid][sgkObject]);
        Garkot_Save(gkid);
		Garkot_Refresh(gkid);
    }
	return 1;
}
CMD:editgarkot(playerid, params[])
{
    static
        gkid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 5)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

    if(sscanf(params, "ds[24]S()[128]", gkid, type, string))
    {
        SyntaxMsg(playerid, "/editgarkot [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, delete, spawn");
        return 1;
    }

    if(gkid < 0 || gkid >= MAX_GARKOT)
        return ErrorMsg(playerid, "You have specified an invalid ID.");

	if(!Iter_Contains(Garkot, gkid))
		return ErrorMsg(playerid, "The garkot you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, gkData[gkid][gkX], gkData[gkid][gkY],gkData[gkid][gkZ]);
		GetPlayerFacingAngle(playerid, gkData[gkid][gkA]);
		gkData[gkid][gkInt] = GetPlayerInterior(playerid);
		gkData[gkid][gkVW] = GetPlayerVirtualWorld(playerid);
        Garkot_Save(gkid);
		Garkot_Refresh(gkid);

        SendAdminMessage(COLOR_RED, "%s has adjusted the location of garkot ID: %d.", pData[playerid][pAdminname], gkid);
    }
    else if(!strcmp(type, "delete",true))
    {
    	if(IsValidDynamicObject(gkData[gkid][gkObject]))
			DestroyDynamicObject(gkData[gkid][gkObject]);

		if(IsValidDynamicArea(gkData[gkid][sgkArea]))
			DestroyDynamicArea(gkData[gkid][sgkArea]);

		if(IsValidDynamicObject(gkData[gkid][sgkObject]))
			DestroyDynamicObject(gkData[gkid][sgkObject]);

        if(IsValidDynamicMapIcon(gkData[gkid][garkotmap]))
			DestroyDynamicMapIcon(gkData[gkid][garkotmap]);
		gkData[gkid][gkX] = 0;
		gkData[gkid][gkY] = 0;
		gkData[gkid][gkZ] = 0;
		gkData[gkid][gkA] = 0;
		gkData[gkid][gkInt] = 0;
		gkData[gkid][gkVW] = 0;

		gkData[gkid][gkPickup] = -1;
		
		Iter_Remove(Garkot, gkid);

		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM parks WHERE id=%d", gkid);
		mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_RED, "%s has delete garkot ID: %d.", pData[playerid][pAdminname], gkid);
    }
    else if(!strcmp(type, "spawn", true))
    {
		GetPlayerPos(playerid, gkData[gkid][sgkX], gkData[gkid][sgkY],gkData[gkid][sgkZ]);
		GetPlayerFacingAngle(playerid, gkData[gkid][sgkA]);
        Garkot_Save(gkid);
		Garkot_Refresh(gkid);

        SendAdminMessage(COLOR_RED, "%s has adjusted the spawn vehicle point of garkot ID: %d.", pData[playerid][pAdminname], gkid);
    }
	return 1;
}

CMD:parkveh(playerid, params[])
{
	new vehid = GetPlayerVehicleID(playerid), count = 0;

	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return ErrorMsg(playerid, "Kamu harus mengendarai kendaraan");

	foreach(new gkid : Garkot)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.5, gkData[gkid][sgkX], gkData[gkid][sgkY],gkData[gkid][sgkZ]))
		{
			count++;
			foreach(new ii : PVehicles)
			{
				if(vehid == pvData[ii][cVeh])
				{
					if(pvData[ii][cOwner] == pData[playerid][pID])
					{
						if(!IsValidVehicle(pvData[ii][cVeh]))
							return ErrorMsg(playerid, "Your vehicle is not spanwed!");
						
						Vehicle_GetStatus(ii);
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("TimerUntogglePlayer", 8000, 0, "i", playerid);
						if(IsValidVehicle(pvData[ii][cVeh]))
							DestroyVehicle(pvData[ii][cVeh]);

						pvData[ii][cPark] = gkid;
						pvData[ii][cVeh] = 0;

						SuccesMsg(playerid, "Kendaraan milikmu telah di parkirkan pada garasi kota.");
					}
					else return ErrorMsg(playerid, "Kendaraan ini bukan milikmu");
				}
			}
		}
	}

	if(count < 1)
		return ErrorMsg(playerid, "Kamu harus berada didekat point public garage");

	return 1;
}

ReturnPVehParkID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > MAX_PRIVATE_VEHICLE) return -1;
	foreach(new vehid : PVehicles)
	{
		if(pvData[vehid][cOwner] == pData[playerid][pID])
		{
			if(pvData[vehid][cPark] == pData[playerid][pGetPARKID] && pvData[vehid][cClaim] == 0)
			{
	     		tmpcount++;
	       		if(tmpcount == hslot)
	       		{
	        		return vehid;
		  		}
	  		}
	    }
	}
	return -1;
}  

GetPVehINPARK(playerid)
{
	new tmpcount;
	foreach(new vehid : PVehicles)
	{
		if(pvData[vehid][cOwner] == pData[playerid][pID])
		{
			if(pvData[vehid][cPark] == pData[playerid][pGetPARKID] && pvData[vehid][cClaim] == 0)
			{
     			tmpcount++;
     		}
	    }
	}
	return tmpcount;
}

CMD:pickveh(playerid, params[])
{
	new msg2[512], count = 0;
	format(msg2, sizeof(msg2), "No\tModel Kendaraan\tNomor Plate\n");
	foreach(new gkid : Garkot)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.5, gkData[gkid][gkX], gkData[gkid][gkY],gkData[gkid][gkZ]))
		{
			count++;
			foreach(new i : PVehicles)
			{
				if(pvData[i][cOwner] == pData[playerid][pID])
				{
					if(gkData[gkid][gkX] == 0) return ErrorMsg(playerid, "garkot point ini belum ada spawn point!");
					pData[playerid][pGetPARKID] = gkid;
					
					if(GetPVehINPARK(playerid) <= 0)
						return ErrorMsg(playerid, "Tidak ada kendaraanmu yang terparkir disini");

					if(pvData[i][cPark] == gkid && pvData[i][cClaim] == 0)
					{
						format(msg2, sizeof(msg2), "%s%d\t%s\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]));
					}
					new string[1024];
					format(string, sizeof(string), "Garasi Kota - Ambil Kendaraan");
					ShowPlayerDialog(playerid, DIALOG_PICKUPVEH, DIALOG_STYLE_TABLIST_HEADERS, string, msg2, "Pilih", "Batal");
				}
			}
		}
	}

	if(count < 1)
		return ErrorMsg(playerid, "Kamu harus berada didekat point public garage");

	return 1;
}

CMD:gotogarkot(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new gkid;
	if(sscanf(params, "d", gkid))
		return SyntaxMsg(playerid, "/gotogarkot [garkot id]");

	if(!Iter_Contains(Garkot, gkid))
		return ErrorMsg(playerid, "Invalid garkot ID!");
	
	SetPlayerPos(playerid, gkData[gkid][gkX], gkData[gkid][gkY],gkData[gkid][gkZ] + 3.0);
	SetPlayerFacingAngle(playerid, gkData[gkid][gkA]);
	Info(playerid, "Anda telah diteleport menuju garkot id %d", gkid);
	return 1;
}

ReturnGarkotNearestID(playerid, slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_GARKOT) return -1;
	foreach(new id : Garkot)
	{
	    if(GetPlayerDistanceFromPoint(playerid, gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ]) < 1000)
	    {
     		tmpcount++;
       		if(tmpcount == slot)
       		{
        		return id;
  			}
		}
	}
	return -1;
}

GetGarkotNearest(playerid)
{
	new tmpcount;
	foreach(new id : Garkot)
	{
		if(GetPlayerDistanceFromPoint(playerid, gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ]) < 1000)
	    {
     		tmpcount++;
     	}
	}
	return tmpcount;
}
GetAnyGarkot()
{
	new tmpcount;
	foreach(new id : Garkot)
	{
     	tmpcount++;
	}
	return tmpcount;
}
ReturnGarkotID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_GARKOT) return -1;
	foreach(new id : Garkot)
	{
        tmpcount++;
        if(tmpcount == slot)
        {
            return id;
        }
	}
	return -1;
}
