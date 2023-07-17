//=============== [ robbery SYSTEM ] ===============//
#define MAX_ROBBERY 	  50

enum robbery
{
	robberyID,
	Text3D: robberyText,
	robberySkin,
	robberyAnim,
	Float:robberyX,
	Float:robberyY,
	Float:robberyZ,
	Float:robberyR,
	robberyName[80],
	robberyWorld,
	robberyInt
}

new RobberyData[MAX_ROBBERY][robbery],
    Iterator:robberys<MAX_ROBBERY>;

GetNearbyRobbery(playerid)
{
	for(new i = 0; i < MAX_ROBBERY; i ++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, RobberyData[i][robberyX], RobberyData[i][robberyY], RobberyData[i][robberyZ]))
		{
			return i;
		}
	}
	return -1;
}

function Loadrobbery()
{
	new aid;

	new rows = cache_num_rows(), name[128];
	if(rows)
	{
	    for(new i; i < rows; i++)
	    {
	        cache_get_value_name_int(i, "ID", aid);
            cache_get_value_name(i, "name", name);
			format(RobberyData[aid][robberyName], 128, name);
	        cache_get_value_name_int(i, "skin", RobberyData[aid][robberySkin]);
	        cache_get_value_name_int(i, "anim", RobberyData[aid][robberyAnim]);
            cache_get_value_name_float(i, "posx", RobberyData[aid][robberyX]);
            cache_get_value_name_float(i, "posy", RobberyData[aid][robberyY]);
            cache_get_value_name_float(i, "posz", RobberyData[aid][robberyZ]);
            cache_get_value_name_float(i, "posr", RobberyData[aid][robberyR]);
            cache_get_value_name_int(i, "interior", RobberyData[aid][robberyInt]);
            cache_get_value_name_int(i, "world", RobberyData[aid][robberyWorld]);

	        new label[200];
	        format(label, sizeof label, "[Robbery ID: %d]\n{BABABA}%s", aid, RobberyData[aid][robberyName]);
	        RobberyData[aid][robberyID] = CreateActor(RobberyData[aid][robberySkin], RobberyData[aid][robberyX], RobberyData[aid][robberyY], RobberyData[aid][robberyZ], RobberyData[aid][robberyR]);
	        RobberyData[aid][robberyText] = CreateDynamic3DTextLabel(label, COLOR_ARWIN, RobberyData[aid][robberyX], RobberyData[aid][robberyY], RobberyData[aid][robberyZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, RobberyData[aid][robberyWorld], RobberyData[aid][robberyInt], -1);
			RobberyData[aid][robberyWorld] = SetActorVirtualWorld(RobberyData[aid][robberyID], RobberyData[aid][robberyWorld]);
            Iter_Add(robberys, aid);
		}
		printf("[robbery]: %d Loaded.", rows);
	}
}

robbery_Save(aid)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE `robbery` SET `name` = '%s', `skin` = '%d', `anim` = '%d', `posx` = '%f', `posy` = '%f', `posz` = '%f', `posr` = '%f', `interior` = '%d', `world` = '%d' WHERE `ID` = '%d'",
	RobberyData[aid][robberyName],
	RobberyData[aid][robberySkin],
	RobberyData[aid][robberyAnim],
	RobberyData[aid][robberyX],
	RobberyData[aid][robberyY],
    RobberyData[aid][robberyZ],
    RobberyData[aid][robberyR],
    RobberyData[aid][robberyInt],
    RobberyData[aid][robberyWorld],
	aid
	);
	return mysql_tquery(g_SQL, cQuery);
}

function OnCreaterobbery(playerid, tid)
{
	robbery_Save(tid);
	Servers(playerid, "robbery [%d] berhasil di buat!", tid);
	new str[150];
	format(str,sizeof(str),"[robbery]: %s membuat robbery id %d!", GetRPName(playerid), tid);
	LogServer("Admin", str);
}

//=============== [ COMMAND robbery ] ===============//

CMD:createrobbery(playerid, params[])
{
	new skin, name[80];
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return ErrorMsg(playerid, "Anda tidak dapet akses perintah ini!");

	if (sscanf(params, "is[80]", skin, name))
		return SyntaxMsg(playerid, "/createrobbery [skin] [name]");

	if (skin < 0 || skin > 299)
	    return ErrorMsg(playerid, "Invalid skin ID. Skins range from 0 to 299.");

	new tid = Iter_Free(robberys), query[512];
	if(tid == -1) return ErrorMsg(playerid, "robbery Has Reached The Max Number");
	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	RobberyData[tid][robberyX] = x;
	RobberyData[tid][robberyY] = y;
	RobberyData[tid][robberyZ] = z;
	RobberyData[tid][robberyR] = a;
	RobberyData[tid][robberySkin] = skin;
	format(RobberyData[tid][robberyName], 80, "%s", name);
	RobberyData[tid][robberyID] = tid;
    RobberyData[tid][robberyInt] = GetPlayerInterior(playerid);
    RobberyData[tid][robberyWorld] = GetPlayerInterior(playerid);

    SetPlayerPos(playerid, x + 5, y, z);

	new label[100];
	format(label, sizeof label, "[Robbery ID: %d]\n{BABABA}%s", tid, RobberyData[tid][robberyName]);
	RobberyData[tid][robberyID] = CreateActor(RobberyData[tid][robberySkin], RobberyData[tid][robberyX], RobberyData[tid][robberyY], RobberyData[tid][robberyZ], RobberyData[tid][robberyR]);
	RobberyData[tid][robberyText] = CreateDynamic3DTextLabel(label, -1, RobberyData[tid][robberyX], RobberyData[tid][robberyY], RobberyData[tid][robberyZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, RobberyData[tid][robberyWorld], RobberyData[tid][robberyInt], -1);
	RobberyData[tid][robberyWorld] = SetActorVirtualWorld(RobberyData[tid][robberyID], GetPlayerVirtualWorld(playerid));
	Iter_Add(robberys, tid);
	mysql_format(g_SQL, query, sizeof query, "INSERT INTO robbery SET ID = '%d', skin = '%d', name = '%s', anim = '%d', posx = '%f', posy = '%f', posz = '%f', posr = '%f', interior = '%d', world = '%d'", RobberyData[tid][robberyID], RobberyData[tid][robberySkin], RobberyData[tid][robberyName], RobberyData[tid][robberyAnim], RobberyData[tid][robberyX], RobberyData[tid][robberyY], RobberyData[tid][robberyZ], RobberyData[tid][robberyR], RobberyData[tid][robberyInt], RobberyData[tid][robberyWorld]);
	mysql_tquery(g_SQL, query, "OnCreaterobbery", "di", playerid, tid);
	return 1;

}
CMD:deleterobbery(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return ErrorMsg(playerid, "Anda tidak dapet akses perintah ini!");

	new id, query[512];
	if(sscanf(params, "i", id)) return SyntaxMsg(playerid, "/deleterobbery [id]");
	if(!Iter_Contains(robberys, id)) return ErrorMsg(playerid, "Invalid ID.");

	DestroyActor(RobberyData[id][robberyID]);
	DestroyDynamic3DTextLabel(RobberyData[id][robberyText]);

    RobberyData[id][robberyX] = 0;
	RobberyData[id][robberyY] = 0;
	RobberyData[id][robberyZ] = 0;
    RobberyData[id][robberyR] = 0;
    format(RobberyData[id][robberyName], 80, "");
	RobberyData[id][robberyText] = Text3D: -1;
	Iter_Remove(robberys, id);

	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM robbery WHERE ID = %d", id);
	mysql_tquery(g_SQL, query);
	Servers(playerid, "Menghapus ID robbery %d.", id);
	new str[150];
	format(str,sizeof(str),"[robbery]: %s menghapus robbery id!", GetRPName(playerid), id);
	LogServer("Admin", str);
	return 1;
}

CMD:gotorobbery(playerid, params[])
{
	new id;
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return ErrorMsg(playerid, "Anda tidak dapet akses perintah ini!");

	if(sscanf(params, "d", id))
		return SyntaxMsg(playerid, "/gotorobbery [id]");
	if(!Iter_Contains(robberys, id)) return ErrorMsg(playerid, "robbery ID tidak ada.");

	SetPlayerPos(playerid, RobberyData[id][robberyX] + 1, RobberyData[id][robberyY], RobberyData[id][robberyZ]);
    SetPlayerInterior(playerid, RobberyData[id][robberyInt]);
	SetPlayerVirtualWorld(playerid, RobberyData[id][robberyWorld]);
	SetCameraBehindPlayer(playerid);
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInBiz] = -1;
	pData[playerid][pInFamily] = -1;
	Servers(playerid, "Teleport ke robbery ID: %d", id);
	return 1;
}
