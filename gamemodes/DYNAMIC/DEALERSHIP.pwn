#include <YSI_Coding\y_hooks>

#define MAX_DEALERSHIP 16

enum DealerVariabel
{
	dealerOwner[MAX_PLAYER_NAME],
	dealerName[128],
	dealerPrice,
	dealerType,
	dealerLocked,
	dealerMoney,
	Float:dealerPosX,
	Float:dealerPosY,
	Float:dealerPosZ,
	Float:dealerPosA,
	Float:dealerPointX,
	Float:dealerPointY,
	Float:dealerPointZ,
	Float:dealerPointA,
	dealerStock,
	dealerRestock,

	// Hooked by DealerRefresh
	dealerPickup,
	dealerPickupPoint,
	dealerMap,
	Text3D:dealerLabel,
	Text3D:dealerPointLabel,
};

new DealerData[MAX_DEALERSHIP][DealerVariabel];
new Iterator:Dealer<MAX_DEALERSHIP>;

ReturnDealerID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_DEALERSHIP) return -1;
	foreach(new id : Dealer)
	{
        tmpcount++;
        if(tmpcount == slot)
        {
            return id;
        }
	}
	return -1;
}

CMD:editdealer(playerid, params[])
{
    static
        did,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 6)
        return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

    if(sscanf(params, "ds[24]S()[128]", did, type, string))
    {
        SyntaxMsg(playerid, "/editdealer [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, point, price, type, stock, restock, reset");
        return 1;
    }
    if((did < 0 || did > MAX_DEALERSHIP))
        return ErrorMsg(playerid, "You have specified an invalid ID.");

	if(!Iter_Contains(Dealer, did)) return ErrorMsg(playerid, "The dealership you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, DealerData[did][dealerPosX], DealerData[did][dealerPosY], DealerData[did][dealerPosZ]);
		GetPlayerFacingAngle(playerid, DealerData[did][dealerPosA]);
        DealerSave(did);
		DealerRefresh(did);

        SendAdminMessage(COLOR_RED, "%s Changes Location Dealer ID: %d.", pData[playerid][pAdminname], did);
    }
    else if(!strcmp(type, "price", true))
    {
        new price;

        if(sscanf(string, "d", price))
            return SyntaxMsg(playerid, "/editdealer [id] [Price] [Amount]");

        DealerData[did][dealerPrice] = price;

        DealerSave(did);
		DealerRefresh(did);
        SendAdminMessage(COLOR_RED, "%s Changes Price Of The Dealer ID: %d to %d.", pData[playerid][pAdminname], did, price);
    }
	else if(!strcmp(type, "type", true))
    {
        new dtype;

        if(sscanf(string, "d", dtype))
            return SyntaxMsg(playerid, "/editbisnis [id] [Type] [1.Motorcycle 2.Cars 3.Unique Cars 4.Job Cars 5.Truck]");

        DealerData[did][dealerType] = dtype;
        DealerSave(did);
		DealerRefresh(did);
        SendAdminMessage(COLOR_RED, "%s Changes Type Of The Dealer ID: %d to %d.", pData[playerid][pAdminname], did, dtype);
    }
    else if(!strcmp(type, "stock", true))
    {
        new dStock;
        if(sscanf(string, "d", dStock))
            return SyntaxMsg(playerid, "/editdealer [id] [stock]");

        DealerData[did][dealerStock] = dStock;
        DealerSave(did);
		DealerRefresh(did);
        SendAdminMessage(COLOR_RED, "%s Set Stock Of The Dealer ID: %d with stock %d.", pData[playerid][pAdminname], did, dStock);
    }
    else if(!strcmp(type, "reset", true))
    {
        DealerReset(did);
		DealerSave(did);
		DealerRefresh(did);
        SendAdminMessage(COLOR_RED, "%s has reset dealer ID: %d.", pData[playerid][pAdminname], did);
    }
	else if(!strcmp(type, "point", true))
    {
		new Float:x, Float:y, Float:z, Float:a;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, Float:a);
		DealerData[did][dealerPointX] = x;
		DealerData[did][dealerPointY] = y;
		DealerData[did][dealerPointZ] = z;
		DealerSave(did);
		DealerPointRefresh(did);
        SendAdminMessage(COLOR_RED, "%s Change Point Of The Dealer ID: %d.", pData[playerid][pAdminname], did);
    }
    return 1;
}


CMD:buydealer(playerid, params[])
{
	foreach(new bid : Dealer)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, DealerData[bid][dealerPosX], DealerData[bid][dealerPosY], DealerData[bid][dealerPosZ]))
		{
			if(DealerData[bid][dealerPrice] > pData[playerid][pMoney])
				return ErrorMsg(playerid, "Not enough elektronik money, you can't afford this dealership.");

			if(strcmp(DealerData[bid][dealerOwner], "-")) 
				return ErrorMsg(playerid, "Someone already owns this dealership.");

			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_DealerCount(playerid) + 1 > 1) return ErrorMsg(playerid, "You can't buy any more dealership.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_DealerCount(playerid) + 1 > 1) return ErrorMsg(playerid, "You can't buy any more dealership.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_DealerCount(playerid) + 1 > 1) return ErrorMsg(playerid, "You can't buy any more dealership.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_DealerCount(playerid) + 1 > 1) return ErrorMsg(playerid, "You can't buy any more dealership.");
				#endif
			}

			pData[playerid][pMoney] -= -DealerData[bid][dealerPrice];
			Server_AddMoney(DealerData[bid][dealerPrice]);
			GetPlayerName(playerid, DealerData[bid][dealerOwner], MAX_PLAYER_NAME);
			
			DealerRefresh(bid);
			DealerSave(bid);
		}
	}
	return 1;
}

CMD:createdealer(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");
	
	new query[512];
	new dealerid = Iter_Free(Dealer), address[128];

	new price, type;
	if(sscanf(params, "dd", price, type))
		return SyntaxMsg(playerid, "/createdealer [price] [type 1.Motorcycle 2.Cars 3.Unique Cars 4. Jobs Vehicle 5. Truck]");

	if(dealerid == -1) 
		return ErrorMsg(playerid, "You cant create more dealership");

	if((dealerid < 0 || dealerid >= MAX_DEALERSHIP))
        return ErrorMsg(playerid, "You have already input 15 dealership in this server.");

	if(type > 5 || type < 0)
		return ErrorMsg(playerid, "Invalid dealership Type");

	format(DealerData[dealerid][dealerOwner], 128, "-");
	GetPlayerPos(playerid, DealerData[dealerid][dealerPosX], DealerData[dealerid][dealerPosY], DealerData[dealerid][dealerPosZ]);
	GetPlayerFacingAngle(playerid, DealerData[dealerid][dealerPosA]);

	DealerData[dealerid][dealerPrice] = price;
	DealerData[dealerid][dealerType] = type;

	address = GetLocation(DealerData[dealerid][dealerPosX], DealerData[dealerid][dealerPosY], DealerData[dealerid][dealerPosZ]);
	format(DealerData[dealerid][dealerName], 128, address);

	DealerData[dealerid][dealerLocked] = 1;
	DealerData[dealerid][dealerMoney] = 0;
	DealerData[dealerid][dealerStock] = 0;
	DealerData[dealerid][dealerRestock] = 0;

	Iter_Add(Dealer, dealerid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO dealership SET ID='%d', owner='%s', price='%d', type='%d', posx='%f', posy='%f', posz='%f', posa='%f', name='%s'", dealerid, DealerData[dealerid][dealerOwner], DealerData[dealerid][dealerPrice], DealerData[dealerid][dealerType], DealerData[dealerid][dealerPosX], DealerData[dealerid][dealerPosY], DealerData[dealerid][dealerPosZ], DealerData[dealerid][dealerPosA], DealerData[dealerid][dealerName]);
	mysql_tquery(g_SQL, query, "OnDealerCreated", "i", dealerid);
	return 1;
}

CMD:deletedealer(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new bid;

	if(sscanf(params, "d", bid))
		return SyntaxMsg(playerid, "/deletedealer [id]");

	if(bid < 0 || bid >= MAX_DEALERSHIP)
        return ErrorMsg(playerid, "You have specified an invalid ID.");

	if(!Iter_Contains(Dealer, bid)) 
		return ErrorMsg(playerid, "The dealership you specified ID of doesn't exist.");

	DealerReset(bid);
		
	DestroyDynamic3DTextLabel(DealerData[bid][dealerLabel]);
	DestroyDynamic3DTextLabel(DealerData[bid][dealerPointLabel]);

    DestroyDynamicPickup(DealerData[bid][dealerPickup]);
    DestroyDynamicPickup(DealerData[bid][dealerPickupPoint]);
		
	DealerData[bid][dealerPosX] = 0;
	DealerData[bid][dealerPosY] = 0;
	DealerData[bid][dealerPosZ] = 0;
	DealerData[bid][dealerPosA] = 0;
	DealerData[bid][dealerPointX] = 0;
	DealerData[bid][dealerPointY] = 0;
	DealerData[bid][dealerPointZ] = 0;
	DealerData[bid][dealerPrice] = 0;
	DealerData[bid][dealerLabel] = Text3D:INVALID_3DTEXT_ID;
	DealerData[bid][dealerPointLabel] = Text3D:INVALID_3DTEXT_ID;
	DealerData[bid][dealerPickup] = -1;
	DealerData[bid][dealerPickupPoint] = -1;
		
	Iter_Remove(Dealer, bid);
	new query[128];
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM dealership WHERE ID=%d", bid);
	mysql_tquery(g_SQL, query);
    SendAdminMessage(COLOR_RED, "%s has delete dealership ID: %d.", pData[playerid][pAdminname], bid);
    return 1;
}

CMD:gotodealer(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new bid;

	if(sscanf(params, "d", bid))
		return SyntaxMsg(playerid, "/gotodealer [id]");

	if(bid < 0 || bid >= MAX_DEALERSHIP)
        return ErrorMsg(playerid, "You have specified an invalid ID.");

	if(!Iter_Contains(Dealer, bid)) 
		return ErrorMsg(playerid, "The dealership you specified ID of doesn't exist.");

	SetPlayerPos(playerid, DealerData[bid][dealerPosX], DealerData[bid][dealerPosY], DealerData[bid][dealerPosZ]);
	SetPlayerFacingAngle(playerid, DealerData[bid][dealerPosA]);
		
    SendClientMessageEx(playerid, COLOR_WHITE, "You has teleport to dealership id %d", bid);
    return 1;
}

CMD:gotodealerpoint(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return ErrorMsg(playerid, "Anda tidak bisa akses perintah ini!");

	new bid;

	if(sscanf(params, "d", bid))
		return SyntaxMsg(playerid, "/gotodealerpoint [id]");

	if(bid < 0 || bid >= MAX_DEALERSHIP)
        return ErrorMsg(playerid, "You have specified an invalid ID.");

	if(!Iter_Contains(Dealer, bid)) 
		return ErrorMsg(playerid, "The dealership you specified ID of doesn't exist.");

	if(DealerData[bid][dealerPointX] == 0.0 && DealerData[bid][dealerPointY] == 0.0 && DealerData[bid][dealerPointZ] == 0.0)
		return ErrorMsg(playerid, "That point is exists but doesnt have any position");

	SetPlayerPos(playerid, DealerData[bid][dealerPointX], DealerData[bid][dealerPointY], DealerData[bid][dealerPointZ]);
		
    SendClientMessageEx(playerid, COLOR_WHITE, "You has teleport to dealership id %d", bid);
    return 1;
}

CMD:buypv(playerid, params[])
{
	foreach(new dealerid : Dealer)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.8, DealerData[dealerid][dealerPosX], DealerData[dealerid][dealerPosY], DealerData[dealerid][dealerPosZ]) && strcmp(DealerData[dealerid][dealerOwner], "-") && DealerData[dealerid][dealerPointX] != 0.0 && DealerData[dealerid][dealerPointY] != 0.0 && DealerData[dealerid][dealerPointZ] != 0.0)
		{
			DealerBuyVehicle(playerid, dealerid);
		}
	}
	return 1;
}

CMD:dealermenu(playerid, params[])
{
	foreach(new dealerid : Dealer)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, DealerData[dealerid][dealerPosX], DealerData[dealerid][dealerPosY], DealerData[dealerid][dealerPosZ]))
		{
			if(!PlayerOwnsDealership(playerid, dealerid)) return ErrorMsg(playerid, "Dealership ini bukan milik anda!");
			ShowPlayerDialog(playerid, DIALOG_DEALER_MANAGE, DIALOG_STYLE_LIST, "Dealer Menu", "Dealer Information\nDealer Change Name\nDealer Vault\nDealer RequestStock", "Select", "Cancel");
		}
	}
	return 1;
}

/* ============ [ Stock goes here ] ============ */

DealerSave(id)
{
	new cQuery[2248];
	format(cQuery, sizeof(cQuery), "UPDATE dealership SET owner='%s', name='%s', price='%d', type='%d', locked='%d', money='%d', stock='%d', posx='%f', posy='%f', posz='%f', posa='%f', pointx='%f', pointy='%f', pointz='%f', restock='%d' WHERE ID='%d'",
	DealerData[id][dealerOwner],
	DealerData[id][dealerName],
	DealerData[id][dealerPrice],
	DealerData[id][dealerType],
	DealerData[id][dealerLocked],
	DealerData[id][dealerMoney],
	DealerData[id][dealerStock],
	DealerData[id][dealerPosX],
	DealerData[id][dealerPosY],
	DealerData[id][dealerPosZ],
	DealerData[id][dealerPosA],
	DealerData[id][dealerPointX],
	DealerData[id][dealerPointY],
	DealerData[id][dealerPointZ],
	DealerData[id][dealerRestock],
	id
	);
	return mysql_tquery(g_SQL, cQuery);
}

ReturnAnyDealer(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_DEALERSHIP) return -1;
	foreach(new id : Dealer)
	{
		tmpcount++;
		if(tmpcount == slot)
		{
			return id;
		}
	}
	return -1;
}

GetAnyDealer()
{
	new tmpcount;
	foreach(new id : Dealer)
	{
		tmpcount++;
	}
	return tmpcount;
}
DealerPointRefresh(id)
{
	if(id != -1)
	{
		if(IsValidDynamic3DTextLabel(DealerData[id][dealerPointLabel]))
        DestroyDynamic3DTextLabel(DealerData[id][dealerPointLabel]);

    	if(IsValidDynamicPickup(DealerData[id][dealerPickupPoint]))
        	DestroyDynamicPickup(DealerData[id][dealerPickupPoint]);

		new tstr[218];
		if(DealerData[id][dealerPointX] != 0 && DealerData[id][dealerPointY] != 0 && DealerData[id][dealerPointZ] != 0)
		{
			format(tstr, sizeof(tstr), "Dealership Point ID: %d\n"WHITE_E"%s", id, DealerData[id][dealerName]);
			DealerData[id][dealerPointLabel] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, DealerData[id][dealerPointX], DealerData[id][dealerPointY], DealerData[id][dealerPointZ], 5.0);
        	DealerData[id][dealerPickupPoint] = CreateDynamicPickup(1239, 23, DealerData[id][dealerPointX], DealerData[id][dealerPointY], DealerData[id][dealerPointZ]);
		}
		else if(DealerData[id][dealerPointX], DealerData[id][dealerPointY], DealerData[id][dealerPointZ] != 0)
		{
			format(tstr, sizeof(tstr), "Dealership Point ID: %d\n"WHITE_E"%s", id, DealerData[id][dealerName]);
			DealerData[id][dealerPointLabel] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, DealerData[id][dealerPointX], DealerData[id][dealerPointY], DealerData[id][dealerPointZ], 5.0);
        	DealerData[id][dealerPickupPoint] = CreateDynamicPickup(1239, 23, DealerData[id][dealerPointX], DealerData[id][dealerPointY], DealerData[id][dealerPointZ]);
    	}
	}
}

DealerRefresh(id)
{
	if(id != -1)
	{		
		if(IsValidDynamic3DTextLabel(DealerData[id][dealerLabel]))
            DestroyDynamic3DTextLabel(DealerData[id][dealerLabel]);

        if(IsValidDynamicPickup(DealerData[id][dealerPickup]))
            DestroyDynamicPickup(DealerData[id][dealerPickup]);
            
        DestroyDynamicMapIcon(bData[id][bMap]);

        new type[128];
		if(DealerData[id][dealerType] == 1)
		{
			type= "Motorcycle";
		}
		else if(DealerData[id][dealerType] == 2)
		{
			type= "Cars";
		}
		else if(DealerData[id][dealerType] == 3)
		{
			type= "Unique Cars";
		}
		else if(DealerData[id][dealerType] == 4)
		{
			type= "Jobs Cars";
		}
		else if(DealerData[id][dealerType] == 5)
		{
			type= "Truck";
		}
		else
		{
			type= "Unknown";
		}
		
		new tstr[558];
		if(DealerData[id][dealerPosX] != 0 && DealerData[id][dealerPosY] != 0 && DealerData[id][dealerPosZ] != 0 && strcmp(DealerData[id][dealerOwner], "-"))
		{
			format(tstr, sizeof(tstr), "{FFFFFF}ID: %d\n{FFFF00}%s\n{ffffff}Owner: {FFFF00}%s\n{FFFFFF}Type: "YELLOW_E"%s\n{00ffff}`/buypv`", id, DealerData[id][dealerName], DealerData[id][dealerOwner], type);
			DealerData[id][dealerLabel] = CreateDynamic3DTextLabel(tstr, COLOR_LBLUE, DealerData[id][dealerPosX], DealerData[id][dealerPosY], DealerData[id][dealerPosZ], 5.0);
            DealerData[id][dealerPickup] = CreateDynamicPickup(1274, 23, DealerData[id][dealerPosX], DealerData[id][dealerPosY], DealerData[id][dealerPosZ]);
		}
		else if(DealerData[id][dealerPosX] != 0 && DealerData[id][dealerPosY] != 0 && DealerData[id][dealerPosZ] != 0)
		{
			format(tstr, sizeof(tstr), "{FFFFFF}ID: %d\n{FFFFFF}Location: {FFFF00}%s\n{FFFFFF}Price: {00FF00}%s\n"WHITE_E"Type: "YELLOW_E"%s\n{00ffff}/buydealer", id, GetLocation(DealerData[id][dealerPosX], DealerData[id][dealerPosY], DealerData[id][dealerPosZ]), FormatMoney(DealerData[id][dealerPrice]), type);
			DealerData[id][dealerLabel] = CreateDynamic3DTextLabel(tstr, COLOR_LBLUE, DealerData[id][dealerPosX], DealerData[id][dealerPosY], DealerData[id][dealerPosZ], 5.0);
            DealerData[id][dealerPickup] = CreateDynamicPickup(1274, 23, DealerData[id][dealerPosX], DealerData[id][dealerPosY], DealerData[id][dealerPosZ]);
   		}
   		
        if(DealerData[id][dealerType] == 1)
		{
			DealerData[id][dealerMap] = CreateDynamicMapIcon(DealerData[id][dealerPosX], DealerData[id][dealerPosY], DealerData[id][dealerPosZ], 55, -1, -1, -1, -1, 70.0);
		}
		else if(DealerData[id][dealerType] == 2)
		{
			DealerData[id][dealerMap] = CreateDynamicMapIcon(DealerData[id][dealerPosX], DealerData[id][dealerPosY], DealerData[id][dealerPosZ], 55, -1, -1, -1, -1, 70.0);
		}
		else if(DealerData[id][dealerType] == 3)
		{
			DealerData[id][dealerMap] = CreateDynamicMapIcon(DealerData[id][dealerPosX], DealerData[id][dealerPosY], DealerData[id][dealerPosZ], 55, -1, -1, -1, -1, 70.0);
		}
		else if(DealerData[id][dealerType] == 4)
		{
			DealerData[id][dealerMap] = CreateDynamicMapIcon(DealerData[id][dealerPosX], DealerData[id][dealerPosX], DealerData[id][dealerPosZ], 55, -1, -1, -1, -1, 70.0);
		}
		else if(DealerData[id][dealerType] == 5)
		{
			DealerData[id][dealerMap] = CreateDynamicMapIcon(DealerData[id][dealerPosX], DealerData[id][dealerPosX], DealerData[id][dealerPosZ], 55, -1, -1, -1, -1, 70.0);
		}
		else
		{
			DestroyDynamicMapIcon(DealerData[id][dealerMap]);
		}
	}
}

DealerReset(id)
{
	format(DealerData[id][dealerOwner], MAX_PLAYER_NAME, "-");
	DestroyDynamicPickup(DealerData[id][dealerPickup]);
	DestroyDynamicPickup(DealerData[id][dealerPickupPoint]);
	DealerData[id][dealerLocked] = 1;
    DealerData[id][dealerMoney] = 0;
	DealerData[id][dealerStock] = 0;
	DealerData[id][dealerRestock] = 0;
	DealerRefresh(id);
}

PlayerOwnsDealership(playerid, id)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(id == -1) return 0;
	if(!strcmp(DealerData[id][dealerOwner], pData[playerid][pName], true)) return 1;
	return 0;
}

Player_DealerCount(playerid)
{
	#if LIMIT_PER_PLAYER != 0
    new count;
	foreach(new i : Dealer)
	{
		if(PlayerOwnsDealership(playerid, i)) count++;
	}
	return count;
	#else
		return 0;
	#endif
}

DealerBuyVehicle(playerid, dealerid)
{
	if(dealerid <= -1 )
        return 0;

    switch(DealerData[dealerid][dealerType])
    {
        case 1:
        {
            new str[1024];
			format(str, sizeof(str), ""WHITE_E"%s\t\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n",
			GetVehicleModelName(481), FormatMoney(GetDealerVehicleCost(481)),
			GetVehicleModelName(509), FormatMoney(GetDealerVehicleCost(509)),
			GetVehicleModelName(510), FormatMoney(GetDealerVehicleCost(510)),
			GetVehicleModelName(462), FormatMoney(GetDealerVehicleCost(462)),
			GetVehicleModelName(586), FormatMoney(GetDealerVehicleCost(586)),
			GetVehicleModelName(581), FormatMoney(GetDealerVehicleCost(581)),
			GetVehicleModelName(461), FormatMoney(GetDealerVehicleCost(461)),
			GetVehicleModelName(521), FormatMoney(GetDealerVehicleCost(521)),
			GetVehicleModelName(463), FormatMoney(GetDealerVehicleCost(463)),
			GetVehicleModelName(468), FormatMoney(GetDealerVehicleCost(468))
			);

			ShowPlayerDialog(playerid, DIALOG_BUYMOTORCYCLEVEHICLE, DIALOG_STYLE_LIST, "Dealer Motor", str, "Beli", "Tutup");
		}
        case 2:
        {
            new str[1024];
			format(str, sizeof(str), ""WHITE_E"%s\t\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n",
			GetVehicleModelName(400), FormatMoney(GetDealerVehicleCost(400)),
			GetVehicleModelName(412), FormatMoney(GetDealerVehicleCost(412)),
			GetVehicleModelName(419), FormatMoney(GetDealerVehicleCost(419)),
			GetVehicleModelName(426), FormatMoney(GetDealerVehicleCost(426)),
			GetVehicleModelName(436), FormatMoney(GetDealerVehicleCost(436)),
			GetVehicleModelName(466), FormatMoney(GetDealerVehicleCost(466)),
			GetVehicleModelName(467), FormatMoney(GetDealerVehicleCost(467)),
			GetVehicleModelName(474), FormatMoney(GetDealerVehicleCost(474)),
			GetVehicleModelName(475), FormatMoney(GetDealerVehicleCost(475)),
			GetVehicleModelName(480), FormatMoney(GetDealerVehicleCost(480)),
			GetVehicleModelName(603), FormatMoney(GetDealerVehicleCost(603)),
			GetVehicleModelName(421), FormatMoney(GetDealerVehicleCost(421)),
			GetVehicleModelName(602), FormatMoney(GetDealerVehicleCost(602)),
			GetVehicleModelName(492), FormatMoney(GetDealerVehicleCost(492)),
			GetVehicleModelName(545), FormatMoney(GetDealerVehicleCost(545)),
			GetVehicleModelName(489), FormatMoney(GetDealerVehicleCost(489)),
			GetVehicleModelName(405), FormatMoney(GetDealerVehicleCost(405)),
			GetVehicleModelName(445), FormatMoney(GetDealerVehicleCost(445)),
			GetVehicleModelName(579), FormatMoney(GetDealerVehicleCost(579)),
			GetVehicleModelName(507), FormatMoney(GetDealerVehicleCost(507))
			);

			ShowPlayerDialog(playerid, DIALOG_BUYCARSVEHICLE, DIALOG_STYLE_LIST, "Cars Dealership", str, "Buy", "Close");
		}
        case 3:
        {
            new str[1024];
			format(str, sizeof(str), ""WHITE_E"%s\t\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n",
			GetVehicleModelName(483), FormatMoney(GetDealerVehicleCost(483)),
			GetVehicleModelName(534), FormatMoney(GetDealerVehicleCost(534)),
			GetVehicleModelName(535), FormatMoney(GetDealerVehicleCost(535)),
			GetVehicleModelName(536), FormatMoney(GetDealerVehicleCost(536)),
			GetVehicleModelName(558), FormatMoney(GetDealerVehicleCost(558)),
			GetVehicleModelName(559), FormatMoney(GetDealerVehicleCost(559)),
			GetVehicleModelName(560), FormatMoney(GetDealerVehicleCost(560)),
			GetVehicleModelName(561), FormatMoney(GetDealerVehicleCost(561)),
			GetVehicleModelName(562), FormatMoney(GetDealerVehicleCost(562)),
			GetVehicleModelName(565), FormatMoney(GetDealerVehicleCost(565)),
			GetVehicleModelName(567), FormatMoney(GetDealerVehicleCost(567)),
			GetVehicleModelName(575), FormatMoney(GetDealerVehicleCost(575)),
			GetVehicleModelName(576), FormatMoney(GetDealerVehicleCost(576))
			);

			ShowPlayerDialog(playerid, DIALOG_BUYUCARSVEHICLE, DIALOG_STYLE_LIST, "Unique Cars Dealership", str, "Buy", "Close");
		}
        case 4:
		{
			//Job Cars
			new str[1024];
			format(str, sizeof(str), ""WHITE_E"%s\t\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n",
			GetVehicleModelName(438), FormatMoney(GetDealerVehicleCost(438)),
			GetVehicleModelName(403), FormatMoney(GetDealerVehicleCost(403)),
			GetVehicleModelName(413), FormatMoney(GetDealerVehicleCost(413)),
			GetVehicleModelName(414), FormatMoney(GetDealerVehicleCost(414)),
			GetVehicleModelName(422), FormatMoney(GetDealerVehicleCost(422)),
			GetVehicleModelName(440), FormatMoney(GetDealerVehicleCost(440)),
			GetVehicleModelName(455), FormatMoney(GetDealerVehicleCost(455)),
			GetVehicleModelName(456), FormatMoney(GetDealerVehicleCost(456)),
			GetVehicleModelName(478), FormatMoney(GetDealerVehicleCost(478)),
			GetVehicleModelName(482), FormatMoney(GetDealerVehicleCost(482)),
			GetVehicleModelName(498), FormatMoney(GetDealerVehicleCost(498)),
			GetVehicleModelName(499), FormatMoney(GetDealerVehicleCost(499)),
			GetVehicleModelName(423), FormatMoney(GetDealerVehicleCost(423)),
			GetVehicleModelName(588), FormatMoney(GetDealerVehicleCost(588)),
			GetVehicleModelName(524), FormatMoney(GetDealerVehicleCost(524)),
			GetVehicleModelName(525), FormatMoney(GetDealerVehicleCost(525)),
			GetVehicleModelName(543), FormatMoney(GetDealerVehicleCost(543)),
			GetVehicleModelName(552), FormatMoney(GetDealerVehicleCost(552)),
			GetVehicleModelName(554), FormatMoney(GetDealerVehicleCost(554)),
			GetVehicleModelName(578), FormatMoney(GetDealerVehicleCost(578))
			//GetVehicleModelName(609), FormatMoney(GetDealerVehicleCost(609))
			//GetVehicleModelName(530), FormatMoney(GetDealerVehicleCost(530)) //fortklift
			);

			ShowPlayerDialog(playerid, DIALOG_BUYJOBCARSVEHICLE, DIALOG_STYLE_LIST, "Job Cars", str, "Buy", "Close");
		}
        case 5:
        {
            new str[1024];
			format(str, sizeof(str), ""WHITE_E"%s\t\t{3498DB}%s\n%s\t\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n%s\t{3498DB}%s\n",
			GetVehicleModelName(414), FormatMoney(GetDealerVehicleCost(414)),
			GetVehicleModelName(499), FormatMoney(GetDealerVehicleCost(499)),
			GetVehicleModelName(498), FormatMoney(GetDealerVehicleCost(498)),
			GetVehicleModelName(455), FormatMoney(GetDealerVehicleCost(455)),
			GetVehicleModelName(524), FormatMoney(GetDealerVehicleCost(524)),
			GetVehicleModelName(578), FormatMoney(GetDealerVehicleCost(578)),
			GetVehicleModelName(403), FormatMoney(GetDealerVehicleCost(403)),
			GetVehicleModelName(514), FormatMoney(GetDealerVehicleCost(514)),
			GetVehicleModelName(515), FormatMoney(GetDealerVehicleCost(515))
			);

			ShowPlayerDialog(playerid, DIALOG_BUYTRUCKVEHICLE, DIALOG_STYLE_LIST, "Truck Dealership", str, "Buy", "Close");
		}
    }
    return 1;
}

GetDealerVehicleCost(carid)
{
    //Category Kendaraan Non Dealer
	if(carid == 434) return 1000000; //Hotknife
	if(carid == 502) return 1000000; //Hotring Racer
	if(carid == 495) return 1000000; //Sandking
	if(carid == 451) return 1000000; //Turismo
	if(carid == 470) return 500000; //Patriot
	if(carid == 424) return 500000; //BF Injection
	if(carid == 522) return 800000; //Nrg
	if(carid == 411) return 1500000; //Infernus
	if(carid == 541) return 1400000; //Bullet
	if(carid == 504) return 1500000; //Bloodring Banger
	if(carid == 603) return 800000; //Phoenix
	if(carid == 415) return 1000000; //Cheetah
	if(carid == 402) return 500000; //Buffalo
	if(carid == 508) return 500000; //Journey
	if(carid == 457) return 500000; //Caddy
	if(carid == 471) return 500000; //Quad
	
	//Category Kendaraan Bikes/Motor
	if(carid == 481) return 200;  //Bmx
	if(carid == 509) return 150; //Bike
	if(carid == 510) return 200; //Mt bike
	if(carid == 463) return 2800; //Freeway harley
	if(carid == 521) return 3500; //Fcr 900
	if(carid == 461) return 2500; //Pcj 600
	if(carid == 581) return 2000; //Bf
	if(carid == 468) return 1000; //Sancehz
	if(carid == 586) return 3000; //Wayfare
	if(carid == 462) return 700; //Faggio
    	//Category Kendaraan Cars
	if(carid == 445) return 2300; //Admiral
	if(carid == 496) return 15000; //Blista Compact
	if(carid == 401) return 12500; //Bravura
	if(carid == 518) return 13500; //Buccaneer
	if(carid == 527) return 13300; //Cadrona
	if(carid == 483) return 14000; //Camper
	if(carid == 542) return 18500; //Clover
	if(carid == 589) return 18300; //Club
	if(carid == 507) return 10000; //Elegant
	if(carid == 540) return 7950; //Vincent
	if(carid == 585) return 8200; //Emperor
	if(carid == 419) return 8100; //Esperanto
	if(carid == 526) return 7000; //Fortune
	if(carid == 466) return 1250; //Glendale
	if(carid == 492) return 1260; //Greenwood
	if(carid == 474) return 8800; //Hermes
	if(carid == 546) return 8800; //Intruder
	if(carid == 517) return 9900; //Majestic
	if(carid == 410) return 7200; //Manana
	if(carid == 551) return 7400; //Merit
	if(carid == 516) return 8300; //Nebula
	if(carid == 467) return 8800; //Oceanic
	if(carid == 404) return 9500; //Perenniel
	if(carid == 600) return 9000; //Picador
	if(carid == 426) return 8200; //Premier
	if(carid == 436) return 12300; //Previon
	if(carid == 547) return 10800; //Primo
	if(carid == 405) return 11700; //Sentinel
	if(carid == 458) return 8000; //Solair
	if(carid == 439) return 12800; //Stallion
	if(carid == 550) return 13300; //Sunrise
	if(carid == 566) return 7000; //Tahoma
	if(carid == 549) return 9500; //Tampa
	if(carid == 491) return 9600; //Virgo
	if(carid == 412) return 9300; //Voodoo
	if(carid == 421) return 8600; //Washington
	if(carid == 529) return 8100; //Willard
	if(carid == 555) return 18000; //Windsor
	if(carid == 580) return 12000; //Stafford
	if(carid == 475) return 12800; //Sabre
	if(carid == 545) return 13800; //Hustler

	//Category Kendaraan Lowriders
	if(carid == 536) return 13000; //Blade
	if(carid == 575) return 12800; //Broadway
	if(carid == 533) return 13300; //Feltzer
	if(carid == 534) return 12800; //Remington
	if(carid == 567) return 13500; //Savanna
	if(carid == 535) return 13800; //Slamvan
	if(carid == 576) return 13200; //Tornado
	if(carid == 566) return 13400; //Tahoma
	if(carid == 412) return 13600; //Voodoo

	//Category Kendaraan SUVS Cars
	if(carid == 579) return 18700; //Huntley
	if(carid == 400) return 13800; //Landstalker
	if(carid == 500) return 17500; //Mesa
	if(carid == 489) return 22000; //Rancher
	if(carid == 479) return 22200; //Regina
	if(carid == 482) return 1200; //Burrito
	if(carid == 418) return 15800; //Moonbeam
	if(carid == 413) return 1500; //Pony
	
	//Category Kendaraan Sports
	if(carid == 602) return 30000; //Alpha
	if(carid == 429) return 32000; //Banshee
	if(carid == 562) return 88000; //Elegy
	if(carid == 587) return 44000; //Euros
	if(carid == 565) return 35000; //Flash
	if(carid == 559) return 53000; //Jester
	if(carid == 561) return 39000; //Stratum
	if(carid == 560) return 65000; //Sultan
	if(carid == 506) return 120000; //Super GT
	if(carid == 558) return 60000; //Uranus
	if(carid == 477) return 87000; //Zr-350
	if(carid == 480) return 3000; //Comet
	if(carid == 420) return 300; //Taxi
	if(carid == 438) return 400; //Cabbie
	if(carid == 403) return 800; //Linerunner
	if(carid == 414) return 400; //Mule
	if(carid == 422) return 340; //Bobcat
	if(carid == 440) return 400; //Rumpo
	if(carid == 455) return 300; //Flatbead
	if(carid == 456) return 400; //Yankee
	if(carid == 478) return 300; //Walton
	if(carid == 498) return 500; //Boxville
	if(carid == 499) return 350; //Benson
	if(carid == 514) return 5000; //Tanker
	if(carid == 515) return 6000; //Roadtrain
	if(carid == 524) return 400; //Cement Truck
	if(carid == 525) return 450; //Towtruck
	if(carid == 543) return 400; //Sadler
	if(carid == 552) return 500; //Utility Van
	if(carid == 554) return 500; //Yosemite
	if(carid == 578) return 400; //DFT-30
	if(carid == 609) return 400; //Boxville
	if(carid == 423) return 400; //Mr Whoopee/Ice cream
	if(carid == 588) return 400; //Hotdog
 	return -1;
}

/* ============ [ Hook, Function goes here ] ============ */

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_BUYMOTORCYCLEVEHICLE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 481;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM_M, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 1:
				{
					new modelid = 509;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM_M, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 2:
				{
					new modelid = 510;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM_M, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 3:
				{
					new modelid = 462;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM_M, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 4:
				{
					new modelid = 586;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM_M, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 5:
				{
					new modelid = 581;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM_M, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 6:
				{
					new modelid = 461;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM_M, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 7:
				{
					new modelid = 521;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM_M, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 8:
				{
					new modelid = 463;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM_M, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 9:
				{
					new modelid = 468;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM_M, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
			}
		}
	}
    if(dialogid == DIALOG_BUYCARSVEHICLE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 400;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 1:
				{
					new modelid = 412;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 2:
				{
					new modelid = 419;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 3:
				{
					new modelid = 426;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 4:
				{
					new modelid = 436;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 5:
				{
					new modelid = 466;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 6:
				{
					new modelid = 467;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 7:
				{
					new modelid = 474;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 8:
				{
					new modelid = 475;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 9:
				{
					new modelid = 480;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 10:
				{
					new modelid = 603;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 11:
				{
					new modelid = 421;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 12:
				{
					new modelid = 602;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 13:
				{
					new modelid = 492;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 14:
				{
					new modelid = 545;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 15:
				{
					new modelid = 489;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 16:
				{
					new modelid = 405;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 17:
				{
					new modelid = 445;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 18:
				{
					new modelid = 579;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 19:
				{
					new modelid = 507;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYUCARSVEHICLE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 483;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 1:
				{
					new modelid = 534;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 2:
				{
					new modelid = 535;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 3:
				{
					new modelid = 536;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 4:
				{
					new modelid = 558;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 5:
				{
					new modelid = 559;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 6:
				{
					new modelid = 560;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 7:
				{
					new modelid = 561;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 8:
				{
					new modelid = 562;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 9:
				{
					new modelid = 565;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 10:
				{
					new modelid = 567;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 11:
				{
					new modelid = 575;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 12:
				{
					new modelid = 576;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYJOBCARSVEHICLE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 438;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 1:
				{
					new modelid = 403;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 2:
				{
					new modelid = 413;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 3:
				{
					new modelid = 414;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 4:
				{
					new modelid = 422;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 5:
				{
					new modelid = 440;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 6:
				{
					new modelid = 455;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 7:
				{
					new modelid = 456;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 8:
				{
					new modelid = 478;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 9:
				{
					new modelid = 482;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 10:
				{
					new modelid = 498;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 11:
				{
					new modelid = 499;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 12:
				{
					new modelid = 423;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 13:
				{
					new modelid = 588;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 14:
				{
					new modelid = 524;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 15:
				{
					new modelid = 525;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 16:
				{
					new modelid = 543;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 17:
				{
					new modelid = 552;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 18:
				{
					new modelid = 554;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 19:
				{
					new modelid = 578;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 20:
				{
					new modelid = 609;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
			}
		}
	}
    if(dialogid == DIALOG_BUYTRUCKVEHICLE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 414;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 1:
				{
					new modelid = 499;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 2:
				{
					new modelid = 498;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
                case 3:
				{
					new modelid = 455;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 4:
				{
					new modelid = 524;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 5:
				{
					new modelid = 578;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 6:
				{
					new modelid = 403;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 7:
				{
					new modelid = 514;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
				case 8:
				{
					new modelid = 515;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYDEALERCARS_CONFIRM, DIALOG_STYLE_MSGBOX, "Pembelian Kendaraan Pribadi", tstr, "Beli", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYDEALERCARS_CONFIRM_M)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			new dealerid = pData[playerid][pInDealer];

			if(DealerData[dealerid][dealerStock] < 0)
				return ErrorMsg(playerid, "This dealer is out of stock product.");

			if(modelid <= 0) return ErrorMsg(playerid, "Invalid model id.");
			new cost = GetDealerVehicleCost(modelid);
			if(pData[playerid][pMoney] < cost)
			{
				ErrorMsg(playerid, "Uang anda tidak mencukupi.!");
				return 1;
			}
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				ErrorMsg(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			GivePlayerMoneyEx(playerid, -cost);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s Purchase a vehicle at a dealership %s ", ReturnName(playerid), DealerData[dealerid][dealerName]);
			color1 = 1;
			color2 = 1;
			model = modelid;
			x = DealerData[dealerid][dealerPointX];
			y = DealerData[dealerid][dealerPointY];
			z = DealerData[dealerid][dealerPointZ];

			DealerData[dealerid][dealerMoney] += cost;
			DealerData[dealerid][dealerStock]--;
			DealerSave(dealerid);
			DealerRefresh(dealerid);

			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehDealer", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_BUYDEALERCARS_CONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			new dealerid = pData[playerid][pInDealer];
			
			if(DealerData[dealerid][dealerStock] < 0)
				return ErrorMsg(playerid, "This dealer is out of stock product.");
				
			if(modelid <= 0) return ErrorMsg(playerid, "Invalid model id.");
			new cost = GetDealerVehicleCost(modelid);
			if(pData[playerid][pMoney] < cost)
			{
				ErrorMsg(playerid, "Uang Elektronik anda tidak mencukupi.!");
				return 1;
			}
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				ErrorMsg(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			//GivePlayerMoneyEx(playerid, -cost);
			pData[playerid][pMoney] -= cost;
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s Purchase a vehicle at a dealership %s ", ReturnName(playerid), DealerData[dealerid][dealerName]);
			color1 = 1;
			color2 = 1;
			model = modelid;
			x = DealerData[dealerid][dealerPointX];
			y = DealerData[dealerid][dealerPointY];
			z = DealerData[dealerid][dealerPointZ];

			DealerData[dealerid][dealerMoney] += cost;
			DealerData[dealerid][dealerStock]--;
			DealerSave(dealerid);
			DealerRefresh(dealerid);
		
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehDealer", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
    if(dialogid == DIALOG_DEALER_MANAGE)
	{
		new dealerid = pData[playerid][pInDealer];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new string[258];
					format(string, sizeof(string), "Dealer ID: %d\nDealer Name : %s\nDealer Location: %s\nDealership Vault: %s\nDealership Stock: %d",
					dealerid, DealerData[dealerid][dealerName], GetLocation(DealerData[dealerid][dealerPosX], DealerData[dealerid][dealerPosY], DealerData[dealerid][dealerPosZ]), FormatMoney(DealerData[dealerid][dealerMoney]), DealerData[dealerid][dealerStock]);

					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_LIST, "Dealerhip Information", string, "Cancel", "");
				}
				case 1:
				{
					new string[218];
					format(string, sizeof(string), "Tulis Nama Dealer baru yang anda inginkan : ( Nama Dealer Lama %s )", DealerData[dealerid][dealerName]);
					ShowPlayerDialog(playerid, DIALOG_DEALER_NAME, DIALOG_STYLE_INPUT, "Dealership Change Name", string, "Select", "Cancel");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_DEALER_VAULT, DIALOG_STYLE_LIST,"Dealership Vault","Dealership Deposit\nDealership Withdraw","Select","Cancel");
				}
				case 3:
				{
					if(DealerData[dealerid][dealerStock] > 100)
						return ErrorMsg(playerid, "Dealership ini masih memiliki cukup produck.");
					if(DealerData[dealerid][dealerMoney] < 500000)
						return ErrorMsg(playerid, "Setidaknya anda mempunyai uang dalam dealer anda senilai $5,000.00 untuk merestock product.");
					DealerData[dealerid][dealerRestock] = 1;
					Info(playerid, "Anda berhasil request untuk mengisi stock kendaraan kepada trucker, harap tunggu sampai pekerja trucker melayani.");
				}
			}
		}
		return 1;
	}
    if(dialogid == DIALOG_DEALER_NAME)
	{
		if(response)
		{
			new bid = pData[playerid][pInDealer];

			if(!PlayerOwnsDealership(playerid, pData[playerid][pInDealer])) return ErrorMsg(playerid, "You don't own this Dealership.");

			if (isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Dealership tidak di perbolehkan kosong!\n\n"WHITE_E"Nama Dealership sebelumnya: %s\n\nMasukkan nama Dealer yang kamu inginkan\nMaksimal 32 karakter untuk nama Dealer", DealerData[bid][dealerName]);
				ShowPlayerDialog(playerid, DIALOG_DEALER_NAME, DIALOG_STYLE_INPUT,"Dealership Change Name", mstr,"Done","Back");
				return 1;
			}
			if(strlen(inputtext) > 32 || strlen(inputtext) < 5)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Dealership harus 5 sampai 32 kata.\n\n"WHITE_E"Nama Dealership sebelumnya: %s\n\nMasukkan nama Dealer yang kamu inginkan\nMaksimal 32 karakter untuk nama Dealer", DealerData[bid][dealerName]);
				ShowPlayerDialog(playerid, DIALOG_DEALER_NAME, DIALOG_STYLE_INPUT,"Dealership Change Name", mstr,"Done","Back");
				return 1;
			}
			format(DealerData[bid][dealerName], 32, ColouredText(inputtext));

			DealerRefresh(bid);
			DealerSave(bid);

			SendClientMessageEx(playerid, COLOR_LBLUE,"Dealer name set to: \"%s\".", DealerData[bid][dealerName]);
		}
		else return callcmd::dealermenu(playerid, "\0");
		return 1;
	}
    if(dialogid == DIALOG_DEALER_VAULT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Uang kamu: %s.\n\nMasukkan berapa banyak uang yang akan kamu simpan di dalam Dealership ini", FormatMoney(GetPlayerMoney(playerid)));
					ShowPlayerDialog(playerid, DIALOG_DEALER_DEPOSIT, DIALOG_STYLE_INPUT, "Dealer Deposit Input", mstr, "Deposit", "Cancel");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Dealer Vault: %s\n\nMasukkan berapa banyak uang yang akan kamu ambil di dalam Dealer ini", FormatMoney(DealerData[pData[playerid][pInDealer]][dealerMoney]));
					ShowPlayerDialog(playerid, DIALOG_DEALER_WITHDRAW, DIALOG_STYLE_INPUT,"Dealer Withdraw Input", mstr, "Withdraw","Cancel");
				}
			}
		}
	}
    if(dialogid == DIALOG_DEALER_WITHDRAW)
	{
		if(response)
		{
			new bid = pData[playerid][pInDealer];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > DealerData[bid][dealerMoney])
				return ErrorMsg(playerid, "Invalid amount specified!");

			DealerData[bid][dealerMoney] -= amount;
			DealerSave(bid);

			GivePlayerMoneyEx(playerid, amount);

			Info(playerid, "You have withdrawn %s from the Dealership vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, DIALOG_DEALER_VAULT, DIALOG_STYLE_LIST,"Dealer Vault","Dealership Deposit\nDealership Withdraw","Next","Back");
		return 1;
	}
    if(dialogid == DIALOG_DEALER_DEPOSIT)
	{
		if(response)
		{
			new bid = pData[playerid][pInDealer];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > GetPlayerMoney(playerid))
				return ErrorMsg(playerid, "Invalid amount specified!");

			DealerData[bid][dealerMoney] += amount;
			DealerSave(bid);

			GivePlayerMoneyEx(playerid, -amount);

			Info(playerid, "You have deposit %s into the Dealership vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, DIALOG_DEALER_VAULT, DIALOG_STYLE_LIST,"Dealership Vault","Dealership Deposit\nDealership Withdraw","Next","Back");
		return 1;
	}
	return 1;
}

function OnVehDealer(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a)
{
	new i = Iter_Free(PVehicles);
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cPrice] = cost;
	pvData[i][cHealth] = 1000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "NoHave");
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cMetal] = 0;
	pvData[i][cCoal] = 0;
	pvData[i][cProduct] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cPark] = -1;
	pvData[i][cSperpart] = 0;
	for(new j = 0; j < 17; j++)
		pvData[i][cMod][j] = 0;
	Iter_Add(PVehicles, i);
	OnVehicleDealerRespawn(i);
	Servers(playerid, "Anda telah membeli kendaraan %s dengan harga %s", GetVehicleModelName(model), FormatMoney(GetDealerVehicleCost(model)));
	pData[playerid][pBuyPvModel] = 0;
	SetPlayerVirtualWorld(playerid, 0);
	return 1;
}

function OnVehicleDealerRespawn(i)
{
	pvData[i][cVeh] = CreateVehicle(pvData[i][cModel], pvData[i][cPosX], pvData[i][cPosY], pvData[i][cPosZ], pvData[i][cPosA], pvData[i][cColor1], pvData[i][cColor2], 60000);
	SetVehicleNumberPlate(pvData[i][cVeh], pvData[i][cPlate]);
	SetVehicleVirtualWorld(pvData[i][cVeh], pvData[i][cVw]);
	LinkVehicleToInterior(pvData[i][cVeh], pvData[i][cInt]);
	SetVehicleFuel(pvData[i][cVeh], pvData[i][cFuel]);
	if(pvData[i][cHealth] < 350.0)
	{
		SetValidVehicleHealth(pvData[i][cVeh], 350.0);
	}
	else
	{
		SetValidVehicleHealth(pvData[i][cVeh], pvData[i][cHealth]);
	}
	UpdateVehicleDamageStatus(pvData[i][cVeh], pvData[i][cDamage0], pvData[i][cDamage1], pvData[i][cDamage2], pvData[i][cDamage3]);
	if(pvData[i][cVeh] != INVALID_VEHICLE_ID)
    {
        if(pvData[i][cPaintJob] != -1)
        {
            ChangeVehiclePaintjob(pvData[i][cVeh], pvData[i][cPaintJob]);
        }
		for(new z = 0; z < 17; z++)
		{
			if(pvData[i][cMod][z]) AddVehicleComponent(pvData[i][cVeh], pvData[i][cMod][z]);
		}
		if(pvData[i][cLocked] == 1)
		{
			SwitchVehicleDoors(pvData[i][cVeh], true);
		}
		else
		{
			SwitchVehicleDoors(pvData[i][cVeh], false);
		}
	}
	return 1;
}

function OnDealerCreated(dealerid)
{
	DealerRefresh(dealerid);
	DealerSave(dealerid);
	return 1;
}

function LoadDealership()
{
    static bid;
	
	new rows = cache_num_rows(), owner[128], name[128];
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "ID", bid);
			cache_get_value_name(i, "owner", owner);
			format(DealerData[bid][dealerOwner], 128, owner);
			cache_get_value_name(i, "name", name);
			format(DealerData[bid][dealerName], 128, name);
			cache_get_value_name_int(i, "type", DealerData[bid][dealerType]);
			cache_get_value_name_int(i, "price", DealerData[bid][dealerPrice]);
			cache_get_value_name_float(i, "posx", DealerData[bid][dealerPosX]);
			cache_get_value_name_float(i, "posy", DealerData[bid][dealerPosY]);
			cache_get_value_name_float(i, "posz", DealerData[bid][dealerPosZ]);
			cache_get_value_name_float(i, "posa", DealerData[bid][dealerPosA]);
			cache_get_value_name_int(i, "money", DealerData[bid][dealerMoney]);
			cache_get_value_name_int(i, "locked", DealerData[bid][dealerLocked]);
			cache_get_value_name_int(i, "stock", DealerData[bid][dealerStock]);
			cache_get_value_name_float(i, "pointx", DealerData[bid][dealerPointX]);
			cache_get_value_name_float(i, "pointy", DealerData[bid][dealerPointY]);
			cache_get_value_name_float(i, "pointz", DealerData[bid][dealerPointZ]);
			cache_get_value_name_int(i, "restock", DealerData[bid][dealerRestock]);
			DealerRefresh(bid);
			DealerPointRefresh(bid);
			Iter_Add(Dealer, bid);
		}
		printf("[Dynamic Dealership] Number of Loaded: %d.", rows);
	}
}


ptask PlayerDealerUpdate[1000](playerid)
{
	foreach(new vid : Dealer)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, DealerData[vid][dealerPosX], DealerData[vid][dealerPosY], DealerData[vid][dealerPosZ]))
		{
			pData[playerid][pInDealer] = vid;
			/*Info(playerid, "DEBUG MESSAGE: Kamu berada di dekat Dealer ID %d", vid);*/
		}
	}
	return 1;
}
