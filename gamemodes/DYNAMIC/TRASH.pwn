#define MAX_Trash 300

enum    E_Trash
{
	// loaded from db
	Float: TrashX,
	Float: TrashY,
	Float: TrashZ,
	Float: TrashA,
	TrashInt,
	TrashWorld,
	Sampah,
	// temp
	TrashPickup,
	Text3D: TrashLabel,
	TrashMap
}

new TrashData[MAX_Trash][E_Trash],
	Iterator:Trashs<MAX_Trash>;

function LoadTrash()
{
	new rows;
	cache_get_row_count(rows);
	if(rows)
  	{
 		new id, i = 0, str[528];
		while(i < rows)
		{
		    cache_get_value_name_int(i, "id", id);
			cache_get_value_name_float(i, "posx", TrashData[id][TrashX]);
			cache_get_value_name_float(i, "posy", TrashData[id][TrashY]);
			cache_get_value_name_float(i, "posz", TrashData[id][TrashZ]);
			cache_get_value_name_float(i, "posa", TrashData[id][TrashA]);
			cache_get_value_name_int(i, "interior", TrashData[id][TrashInt]);
			cache_get_value_name_int(i, "world", TrashData[id][TrashWorld]);
			cache_get_value_name_int(i, "sampah", TrashData[id][Sampah]);
			format(str, sizeof(str), "Tekan [ ALT ] Untuk Membuang Sampah\nGunakan /bin untuk memungut sampah");
			TrashData[id][TrashPickup] = CreateDynamicObject(1300, TrashData[id][TrashX], TrashData[id][TrashY], TrashData[id][TrashZ] - 0.5, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
			TrashData[id][TrashLabel] = CreateDynamic3DTextLabel(str, ARWIN, TrashData[id][TrashX], TrashData[id][TrashY], TrashData[id][TrashZ]+1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, TrashData[id][TrashWorld], TrashData[id][TrashInt], -1, 10.0);
			Iter_Add(Trashs, id);
	    	i++;
		}
		printf("[Trash]: %d Loaded.", i);
	}
}

Trash_Save(id)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE trash SET posx='%f', posy='%f', posz='%f', posa='%f', interior=%d, world=%d, sampah=%d WHERE id=%d",
	TrashData[id][TrashX],
	TrashData[id][TrashY],
	TrashData[id][TrashZ],
	TrashData[id][TrashA],
	TrashData[id][TrashInt],
	TrashData[id][TrashWorld],
	TrashData[id][Sampah],
	id
	);
	return mysql_tquery(g_SQL, cQuery);
}

GetNearbyTrash(playerid)
{
	for(new i = 0; i < MAX_Trash; i ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 3.0, TrashData[i][TrashX], TrashData[i][TrashY], TrashData[i][TrashZ]))
	    {
	        return i;
	    }
	}
	return -1;
}
CMD:edittrash(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
		if(pData[playerid][pServerModerator] < 1)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new id;
	if(sscanf(params, "i", id)) return SyntaxMsg(playerid, "/editatm [id]");
	if(!Iter_Contains(Trashs, id)) return ErrorMsg(playerid, "Invalid ID.");
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, TrashData[id][TrashX], TrashData[id][TrashY], TrashData[id][TrashZ])) return ErrorMsg(playerid, "Kamu tidak berada di dekat tempat sampah.");
	pData[playerid][EditingTrash] = id;
	EditDynamicObject(playerid, TrashData[id][TrashPickup]);
	return 1;
}
CMD:createtrash(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new id = Iter_Free(Trashs), query[512];
	if(id == -1) return ErrorMsg(playerid, "Can't add any more Trash Point.");
 	new Float: x, Float: y, Float: z, Float: a;
 	GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
	TrashData[id][TrashX] = x;
	TrashData[id][TrashY] = y;
	TrashData[id][TrashZ] = z;
	TrashData[id][TrashA] = a;
	TrashData[id][TrashInt] = GetPlayerInterior(playerid);
	TrashData[id][TrashWorld] = GetPlayerVirtualWorld(playerid);
	TrashData[id][Sampah] = 0;

	new str[128];
	format(str, sizeof(str), "Tekan [ ALT ] Untuk Membuang Sampah\nGunakan /bin untuk memungut sampah");
	TrashData[id][TrashPickup] = CreateDynamicObject(1300, TrashData[id][TrashX], TrashData[id][TrashY], TrashData[id][TrashZ] - 0.5, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	TrashData[id][TrashLabel] = CreateDynamic3DTextLabel(str, ARWIN, TrashData[id][TrashX], TrashData[id][TrashY], TrashData[id][TrashZ] + 1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, TrashData[id][TrashWorld], TrashData[id][TrashInt], -1, 10.0);
	Iter_Add(Trashs, id);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO trash SET id=%d, posx='%f', posy='%f', posz='%f', interior=%d, world=%d, sampah=%d", id, TrashData[id][TrashX], TrashData[id][TrashY], TrashData[id][TrashZ], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), TrashData[id][Sampah]);
	mysql_tquery(g_SQL, query, "OnTrashCreated", "ii", playerid, id);
	return 1;
}

function OnTrashCreated(playerid, id)
{
	Trash_Save(id);
	Servers(playerid, "You has created Trash Kota id: %d.", id);
	new str[150];
	format(str,sizeof(str),"[Trash]: %s membuat Trash kota id %d!", GetRPName(playerid), id);
	LogServer("Admin", str);
	return 1;
}

CMD:removetrash(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new id, query[512];
	if(sscanf(params, "i", id)) return SyntaxMsg(playerid, "/removetrash [id]");
	if(!Iter_Contains(Trashs, id)) return ErrorMsg(playerid, "Invalid ID.");

	DestroyDynamic3DTextLabel(TrashData[id][TrashLabel]);
	DestroyDynamicObject(TrashData[id][TrashPickup]);
	DestroyDynamicMapIcon(TrashData[id][TrashMap]);

	TrashData[id][TrashX] = TrashData[id][TrashY] = TrashData[id][TrashZ] = 0.0;
	TrashData[id][TrashInt] = TrashData[id][TrashWorld] = 0;
	TrashData[id][TrashPickup] = -1;
	TrashData[id][TrashLabel] = Text3D: -1;
	Iter_Remove(Trashs, id);

	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM trash WHERE id=%d", id);
	mysql_tquery(g_SQL, query);
	Servers(playerid, "Menghapus ID Trash Point %d.", id);
	new str[150];
	format(str,sizeof(str),"[Garkot]: %s menghapus garkot id %d!", GetRPName(playerid), id);
	LogServer("Admin", str);
	return 1;
}

CMD:gototrash(playerid, params[])
{
	new id;
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	if(sscanf(params, "d", id))
		return SyntaxMsg(playerid, "/gototrash [id]");
	if(!Iter_Contains(Trashs, id)) return ErrorMsg(playerid, "Trash Point ID tidak ada.");

	SetPlayerPosition(playerid, TrashData[id][TrashX], TrashData[id][TrashY], TrashData[id][TrashZ], 2.0);
    SetPlayerInterior(playerid, TrashData[id][TrashInt]);
    SetPlayerVirtualWorld(playerid, TrashData[id][TrashWorld]);
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInBiz] = -1;
	pData[playerid][pInFamily] = -1;
	Servers(playerid, "Teleport ke ID Trash Point %d", id);
	return 1;
}

