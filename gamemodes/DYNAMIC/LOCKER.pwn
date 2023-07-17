//----------[ Dynamic Locker System ]-----------

#define MAX_LOCKERS	10

enum lockerinfo
{
	lType,
	Float:lPosX,
	Float:lPosY,
	Float:lPosZ,
	lInt,
	Text3D:lLabel,
	lPickup
};

new lData[MAX_LOCKERS][lockerinfo],
	Iterator: Lockers<MAX_LOCKERS>;
	
Locker_Refresh(lid)
{
    if(lid != -1)
    {
        if(IsValidDynamic3DTextLabel(lData[lid][lLabel]))
            DestroyDynamic3DTextLabel(lData[lid][lLabel]);

        if(IsValidDynamicObject(lData[lid][lPickup]))
            DestroyDynamicObject(lData[lid][lPickup]);

        static
        string[255];

		format(string, sizeof(string), "Tekan "LG_E"ALT {FFFFFF}untuk mengakses locker");
		lData[lid][lPickup] = CreateDynamicObject(1316, lData[lid][lPosX], lData[lid][lPosY], lData[lid][lPosZ] - 1.0, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
		SetDynamicObjectMaterial(lData[lid][lPickup], 0, 18871, "matcolours", "red", 0xFFFF0000);
		lData[lid][lLabel] = CreateDynamic3DTextLabel(string, COLOR_WHITE, lData[lid][lPosX], lData[lid][lPosY], lData[lid][lPosZ]+0.5, 5.0);
	}
    return 1;
}

function LoadLockers()
{
    static lid;
	
	new rows = cache_num_rows();
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", lid);
			cache_get_value_name_int(i, "type", lData[lid][lType]);
			cache_get_value_name_float(i, "posx", lData[lid][lPosX]);
			cache_get_value_name_float(i, "posy", lData[lid][lPosY]);
			cache_get_value_name_float(i, "posz", lData[lid][lPosZ]);
			cache_get_value_name_int(i, "interior", lData[lid][lInt]);
			Locker_Refresh(lid);
			Iter_Add(Lockers, lid);
		}
		printf("[Lockers]: %d Loaded.", rows);
	}
}
	
Locker_Save(lid)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE lockers SET type='%d', posx='%f', posy='%f', posz='%f', interior='%d' WHERE id='%d'",
	lData[lid][lType],
	lData[lid][lPosX],
	lData[lid][lPosY],
	lData[lid][lPosZ],
	lData[lid][lInt],
	lid
	);
	return mysql_tquery(g_SQL, cQuery);
}


//Dynamic Locker System
CMD:createlocker(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return ErrorMsg(playerid, "Anda tidak dapet akses perintah ini!");
	
	new lid = Iter_Free(Lockers), query[128];
	if(lid == -1) return Error(playerid, "You cant create more locker!");
	new type;
	if(sscanf(params, "d", type)) return SendClientMessageEx(playerid, COLOR_WHITE, "[ ! ]: /createlocker [type, 1.POLISI 2.PEMERINTAH 3.MEDIS 4.PEMBAWA BERITA 5.PEDAGANG 6.GOJEK 7.VIP 8.FAMILY");
	
	if(type < 1 || type > 8) return Error(playerid, "Invalid type.");
	
	GetPlayerPos(playerid, lData[lid][lPosX], lData[lid][lPosY], lData[lid][lPosZ]);
	lData[lid][lInt] = GetPlayerInterior(playerid);
	lData[lid][lType] = type;
    Locker_Refresh(lid);
	Iter_Add(Lockers, lid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO lockers SET id='%d', type='%d', posx='%f', posy='%f', posz='%f'", lid, lData[lid][lType], lData[lid][lPosX], lData[lid][lPosY], lData[lid][lPosZ]);
	mysql_tquery(g_SQL, query, "OnLockerCreated", "ii", playerid, lid);
	return 1;
}

function OnLockerCreated(playerid, lid)
{
	Locker_Save(lid);
	SuccesMsg(playerid, "Locker berhasil di buat!");
	return 1;
}

CMD:gotolocker(playerid, params[])
{
	new lid;
	if(pData[playerid][pAdmin] < 6)
		return ErrorMsg(playerid, "Anda tidak dapet akses perintah ini!");
		
	if(sscanf(params, "d", lid))
		return SendClientMessageEx(playerid, COLOR_WHITE, "[! ]: /gotolocker [id]");
	if(!Iter_Contains(Lockers, lid)) return Error(playerid, "The locker you specified ID of doesn't exist.");
	SetPlayerPosition(playerid, lData[lid][lPosX], lData[lid][lPosY], lData[lid][lPosZ], 2.0);
    SetPlayerInterior(playerid, lData[lid][lInt]);
    SetPlayerVirtualWorld(playerid, 0);
	Servers(playerid, "You has teleport to locker id %d", lid);
	return 1;
}

CMD:editlocker(playerid, params[])
{
    static
        lid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 4)
		return ErrorMsg(playerid, "Anda tidak dapet akses perintah ini!");

    if(sscanf(params, "ds[24]S()[128]", lid, type, string))
    {
        SendClientMessageEx(playerid, COLOR_WHITE, "[USAGE]: /editlocker [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, type, delete");
        return 1;
    }
    if((lid < 0 || lid >= MAX_LOCKERS))
        return Error(playerid, "You have specified an invalid ID.");
	if(!Iter_Contains(Lockers, lid)) return Error(playerid, "The doors you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, lData[lid][lPosX], lData[lid][lPosY], lData[lid][lPosZ]);
		lData[lid][lInt] = GetPlayerInterior(playerid);
        Locker_Save(lid);
		Locker_Refresh(lid);

        SendAdminMessage(COLOR_RED, "%s has adjusted the location of locker ID: %d.", pData[playerid][pAdminname], lid);
    }
    else if(!strcmp(type, "type", true))
    {
        new tipe;

        if(sscanf(string, "d", tipe))
            return SendClientMessageEx(playerid, COLOR_WHITE, "[USAGE]: /editlocker [id] [type] [type, 1.SAPD 2.SAGS 3.SAMD 4.SANA 5.BURGERSHOT 6.VIP 7. FAMILY Locker]");

        if(tipe < 1 || tipe > 7)
            return Error(playerid, "You must specify at least 1 - 7.");

        lData[lid][lType] = tipe;
        Locker_Save(lid);
		Locker_Refresh(lid);

        SendAdminMessage(COLOR_RED, "%s has set locker ID: %d to type id faction %d.", pData[playerid][pAdminname], lid, tipe);
    }
    else if(!strcmp(type, "delete", true))
    {
		new query[128];
		DestroyDynamic3DTextLabel(lData[lid][lLabel]);
		DestroyDynamicObject(lData[lid][lPickup]);
		lData[lid][lPosX] = 0;
		lData[lid][lPosY] = 0;
		lData[lid][lPosZ] = 0;
		lData[lid][lInt] = 0;
		lData[lid][lLabel] = Text3D: INVALID_3DTEXT_ID;
		lData[lid][lPickup] = -1;
		Iter_Remove(Lockers, lid);
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM lockers WHERE id=%d", lid);
		mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_RED, "%s has delete locker ID: %d.", pData[playerid][pAdminname], lid);
    }
    return 1;
}
