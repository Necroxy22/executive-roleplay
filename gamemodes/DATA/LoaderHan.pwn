//loader han
new Float:data_object[][6] = 
{
	{2192.35, -2232.43, 13.00, 0.00, 0.00, 0.00},
	{2192.29, -2233.19, 13.00, 0.00, 0.00, 0.00},
	{2192.30, -2232.81, 13.70, 0.00, 0.00, 4.00},
	{2195.37, -2229.70, 13.00, 0.00, 0.00, 0.00},
	{2197.57, -2231.32, 13.00, 0.00, 0.00, -47.00},
	{2198.15, -2231.94, 13.00, 0.00, 0.00, -47.00},
	{2197.89, -2231.61, 13.70, 0.00, 0.00, -47.00},
	{2190.90, -2237.97, 13.00, 0.00, 0.00, 0.00},
	{2197.26, -2226.35, 13.00, 0.00, 0.00, -47.00},
	{2197.18, -2226.25, 13.70, 0.00, 0.00, -47.00}
}

enum e_PLAYER_ACTION 
{
	BOX_INDEX, 
	bool:AREA_STATUS, 
	TARGET_OBJ_ID
}

new
	job_loader[MAX_PLAYERS][e_PLAYER_ACTION],
	STREAMER_TAG_OBJECT:object_box[sizeof data_object],
	PlayerText:TextDraw_job[MAX_PLAYERS],
	loader_timer[MAX_PLAYERS],
	area_warehouse,
	area_work_bound,
	global_count_box;


setLoaderInfo(playerid, e_name, value)
	job_loader[playerid][e_PLAYER_ACTION:e_name] = value;

getLoaderInfo(playerid, e_name)
	return job_loader[playerid][e_PLAYER_ACTION:e_name];

const TAKE_BOX = 1,
	PUT_BOX = 2;

public OnGameModeInit()
{
	area_work_bound = CreateDynamicPolygon(Float:{2198.0,-2180.0,2113.0,-2270.0,2137.0,-2314.0,2172.0,-2340.0,2192.0,-2347.0,2276.0,-2260.0,2198.0,-2180.0});
	area_warehouse = CreateDynamicCircle(2175.0332,-2250.4292, 6.7, -1, -1, -1);
 	CreateBox();
 return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid) 
{
	if(areaid == area_warehouse) 
	{
		PlayerTextDrawSetString(playerid, TextDraw_job[playerid], "Press F Untuk mengambil BOX");
		PlayerTextDrawShow(playerid, TextDraw_job[playerid]);
		setLoaderInfo(playerid, AREA_STATUS, true);
	}
	if(areaid == area_work_bound) 
	{
		loader_timer[playerid] = SetTimerEx("CameraTargetBox", 500, false, "i", playerid);
	}
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid) 
{
	if(areaid == area_warehouse) 
	{
		PlayerTextDrawHide(playerid, TextDraw_job[playerid]);
		setLoaderInfo(playerid, AREA_STATUS, false);
	}
	if(areaid == area_work_bound) 
	{
		KillTimer(loader_timer[playerid]);
	}
 	return 1;
}

forward CameraTargetBox(playerid);
public CameraTargetBox(playerid)
{
	KillTimer(loader_timer[playerid]);
	new
	objectid = GetPlayerCameraTargetDynObject(playerid);

	if(objectid == getLoaderInfo(playerid, TARGET_OBJ_ID) || getLoaderInfo(playerid, AREA_STATUS))
		return loader_timer[playerid] = SetTimerEx("CameraTargetBox", 500, false, "i", playerid);
	if(IsPlayerAttachedObjectSlotUsed(playerid, 9))
		return loader_timer[playerid] = SetTimerEx("CameraTargetBox", 500, false, "i", playerid);

	if(getLoaderInfo(playerid, TARGET_OBJ_ID) != INVALID_STREAMER_ID && objectid != getLoaderInfo(playerid, TARGET_OBJ_ID)) 
	{
		SetDynamicObjectMaterial(STREAMER_TAG_OBJECT:object_box[getLoaderInfo(playerid, BOX_INDEX)], 0, 1271,"null", "null", 0xFFFFFFFF);
		setLoaderInfo(playerid, TARGET_OBJ_ID, INVALID_STREAMER_ID);
		PlayerTextDrawSetString(playerid, TextDraw_job[playerid], "--");
		PlayerTextDrawHide(playerid, TextDraw_job[playerid]);
	}
	for(new u, Float:x, Float:y, Float:z; u < sizeof object_box; u++) 
	{
		if (objectid == object_box[u]) 
		{
			GetDynamicObjectPos(object_box[u],x, y, z);
			if(IsPlayerInRangeOfPoint(playerid, 1.5, x, y, z)) 
			{
				PlayerTextDrawSetString(playerid, TextDraw_job[playerid], "Click F Untuk Menaruh BOX Ke Lantai");
				PlayerTextDrawShow(playerid, TextDraw_job[playerid]);
				setLoaderInfo(playerid, TARGET_OBJ_ID, objectid);
				setLoaderInfo(playerid, BOX_INDEX, u);
				SetDynamicObjectMaterial(STREAMER_TAG_OBJECT:object_box[u], 0, 1271, "null", "null", 0x958cb900);
			}
		}
	}
	loader_timer[playerid] = SetTimerEx("CameraTargetBox", 500, false, "i", playerid);
	return 1;
}

public OnPlayerConnect(playerid)
{
	EnablePlayerCameraTarget(playerid, 1);
	setLoaderInfo(playerid, TARGET_OBJ_ID, INVALID_STREAMER_ID);
	TextDraw_job[playerid] = CreatePlayerTextDraw(playerid, 361.6667, 216.9629, "+345$");
	PlayerTextDrawLetterSize(playerid, TextDraw_job[playerid], 0.2813, 1.1561);
	PlayerTextDrawAlignment(playerid, TextDraw_job[playerid], 1);
	PlayerTextDrawColor(playerid, TextDraw_job[playerid], 0x8cb900AA);
	PlayerTextDrawSetOutline(playerid, TextDraw_job[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, TextDraw_job[playerid], 255);
	PlayerTextDrawFont(playerid, TextDraw_job[playerid], 3);
	PlayerTextDrawSetProportional(playerid, TextDraw_job[playerid], 1);
	PlayerTextDrawSetShadow(playerid, TextDraw_job[playerid], 0);
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_SECONDARY_ATTACK && !IsPlayerAttachedObjectSlotUsed(playerid, 9) && getLoaderInfo(playerid, TARGET_OBJ_ID) != INVALID_STREAMER_ID) 
	{
		ApplyAnimation(playerid, "CARRY", "LIFTUP", 1.1, false, false, false, false, 0, false); // SAVE
		SetTimerEx("@__ActionBox", 600, 0, "ii", playerid, TAKE_BOX);
		return 1;
	}
	if(newkeys & KEY_SECONDARY_ATTACK && IsPlayerAttachedObjectSlotUsed(playerid, 9)) 
	{
		SetTimerEx("@__ActionBox", 400, 0, "ii", playerid, PUT_BOX);
		ApplyAnimation(playerid, "CARRY", "PUTDWN", 1.1, false, false, false, false, 0, false); // SAVE
		new Float:x, Float:y, Float:z, Float: fA;
		GetPlayerPos(playerid, x, y, z);
		GetXYInFrontOfPlayer(playerid, x, y, 1.3);
		GetPlayerFacingAngle(playerid, fA);
		//
		object_box[getLoaderInfo(playerid, BOX_INDEX)] = CreateDynamicObject(1271, x, y, z-0.6, 0.0,0.0, fA);
		if(getLoaderInfo(playerid, AREA_STATUS))
		{
			PlayerTextDrawSetString(playerid, TextDraw_job[playerid], "+100$");
			GivePlayerMoney(playerid, 100);
			PlayerTextDrawShow(playerid, TextDraw_job[playerid]);
			SetTimerEx("@__hideMoneyTD", 1000, 0, #i, playerid);
			if(++global_count_box == sizeof object_box) 
			{
				SetTimer("@__RefreshBoxes", 5_000, false);
			}
		}
		return 1;
	}
 return 1;
}

CreateBox() 
{
	for(new u; u < sizeof data_object; u++) 
	{
		object_box[u] = CreateDynamicObject(1271, data_object[u][0], data_object[u][1], data_object[u][2],data_object[u][3],data_object[u][4],data_object[u][5]);
	}
	global_count_box = 0;
}

@__RefreshBoxes();
@__RefreshBoxes() 
{
	for(new u; u < sizeof object_box; u++)
	DestroyDynamicObject(STREAMER_TAG_OBJECT:object_box[u]);
	CreateBox();
}

@__hideMoneyTD(playerid);
@__hideMoneyTD(playerid) 
{
	PlayerTextDrawHide(playerid, TextDraw_job[playerid]);
}

@__ActionBox(playerid, value);
@__ActionBox(playerid, value) 
{
	switch(value) 
	{
		case TAKE_BOX: 
		{
			DestroyDynamicObject(STREAMER_TAG_OBJECT:object_box[getLoaderInfo(playerid, BOX_INDEX)]);
			object_box[getLoaderInfo(playerid, BOX_INDEX)] = -1;
			PlayerTextDrawHide(playerid, TextDraw_job[playerid]);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			SetPlayerAttachedObject(playerid, 9, 2912, 3, 0.1609, -0.4390, -0.3370, -14.8000, 3.4999, 10.6000, 0.5519, 0.5649, 0.6639, 0, 0);
		}
		case PUT_BOX: 
		{
			PlayerTextDrawHide(playerid, TextDraw_job[playerid]);
			setLoaderInfo(playerid, BOX_INDEX, -1);
			RemovePlayerAttachedObject(playerid, 9);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			setLoaderInfo(playerid, TARGET_OBJ_ID, INVALID_STREAMER_ID);
		}
	}
	return PlayerPlaySound(playerid, 1138, 0.0, 0.0, 0.0);
}

