//Gps System By Shaheen//.........


#define     MAX_LIMITOBJ 25 //do not change

new GpsObject[MAX_PLAYERS][MAX_LIMITOBJ];
new GpsUpdateTimer[MAX_PLAYERS];
new MapNode:Nodess[MAX_PLAYERS][MAX_LIMITOBJ];
new bool:IsinGps[MAX_PLAYERS];
new MapNode:ChangeNode[MAX_PLAYERS][7];

//----------------------//
forward destroyGpsObjects(playerid,size);
forward FindPathGpsUpdate(playerid,Float:TarX,Float:TarY,Float:TarZ,size);
forward FindPathGps(playerid,Float:TarX,Float:TarY,Float:TarZ);


public FindPathGps(playerid,Float:TarX,Float:TarY,Float:TarZ)
{
    new Float:x, Float:y, Float:z, MapNode:start,MapNode:target,Path:pathid;
    GetPlayerPos(playerid, x, y, z);
    GetClosestMapNodeToPoint(x, y, z, start);
    GetClosestMapNodeToPoint(TarX,TarY,TarZ, target);
    FindPath(start, target, pathid);
    new MapNode:nodeid, Float:xxx, Float:yyy, Float:zzz , Float:ANGLE;
    for (new index; index < 25; index++) 
	{
        GetPathNode(pathid, index, nodeid);
        if(index != 0)
        {
           GetMapNodePos(ChangeNode[playerid][6], xxx, yyy, zzz);
           GetMapNodeAngleFromPoint(nodeid,xxx, yyy, ANGLE);
        }
        GpsObject[playerid][index] = CreatePlayerObject(playerid, 1318, xxx, yyy, zzz+0.7,0,120, ANGLE);
		if(index == 20)
		{
            ChangeNode[playerid][4] = nodeid;
		}
		if(index == 19)
		{
            ChangeNode[playerid][5] = nodeid;
		}
		if(index == 21)
		{
            ChangeNode[playerid][0] = nodeid;
		}
		if(index == 22)
		{
            ChangeNode[playerid][1] = nodeid;
		}
		if(index == 23)
		{
            ChangeNode[playerid][2] = nodeid;
		}
		if(index == 24)
		{
            ChangeNode[playerid][3] = nodeid;
		}
		Nodess[playerid][index] = nodeid;
		ChangeNode[playerid][6] = nodeid;
    }
    GpsUpdateTimer[playerid] = SetTimerEx("FindPathGpsUpdate", 1500, true, "dfffd", playerid,TarX, TarY, TarZ,25);
    IsinGps[playerid] = true;
    return 1;
}

public FindPathGpsUpdate(playerid,Float:TarX,Float:TarY,Float:TarZ,size)
{
	if(IsinGps[playerid])
	{
	    new Float:x,Float:y,Float:z,MapNode:Source,MapNode:Target;
	    GetPlayerPos(playerid,x,y,z);
	    GetClosestMapNodeToPoint(x, y, z, Source);
	    GetClosestMapNodeToPoint(TarX, TarY, TarZ, Target);
	    if (Source == Target)
	    {
	       KillTimer(GpsUpdateTimer[playerid]);
		   destroyGpsObjects(playerid,25);
		   SendClientMessage(playerid,-1,"Reached Destination");
		   IsinGps[playerid] = false;
		   return 1;
	    }
	    new bool:found=false;
	    for(new i=0; i < 25; i++)
		{
			if (Source == ChangeNode[playerid][5] || Source == ChangeNode[playerid][3] || Source == ChangeNode[playerid][4] || Source == ChangeNode[playerid][0] ||Source == ChangeNode[playerid][1] || Source == ChangeNode[playerid][2] )
			{
                found = true;
                break;
			}
			else if(Nodess[playerid][i] == Source)
			{
				return 1;
			}
			else
			{
				found = true;
			}
		}
		if(found)
		{
		   KillTimer(GpsUpdateTimer[playerid]);
		   destroyGpsObjects(playerid,25);
		   FindPathGps(playerid,TarX, TarY, TarZ);
		   return 1;
		}
	}
	return 1;
}


public destroyGpsObjects(playerid,size)
{
	for(new i=0; i< 25; i++)
	{
      if(IsValidPlayerObject(playerid, GpsObject[playerid][i])) //only destroy if its valid
	  {
          DestroyPlayerObject(playerid, GpsObject[playerid][i]);
      }
	}
	return 1;
}


CMD:gpsoff(playerid)
{
    destroyGpsObjects(playerid,MAX_LIMITOBJ);
    KillTimer(GpsUpdateTimer[playerid]);
    IsinGps[playerid] = false;
    SendClientMessage(playerid,-1,"Gps has been Turned Off");
	return 1;
}


CMD:findpath(playerid, params[])
{
	new Float:x, Float:y, Float:z;
	if(sscanf(params, "p<,>fff", x, y, z))
	{
		SendClientMessage(playerid,-1,"Usage: /findpath <x,y,z>");
	}
	else
	{
		FindPathGps(playerid, x, y, z);
		SendClientMessage(playerid,-1,"Gps has been Turned On");
	}
	return 1;
}