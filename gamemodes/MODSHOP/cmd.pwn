CMD:myov(playerid, params[])
{
    new 
		vehid,
        string[1024],
        count
	;
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return Error(playerid, "You're not driving any vehicle!");

	vehid = Vehicle_Nearest(playerid);

    if(vehid == -1)
        return Error(playerid, "Invalid vehicle id!");

    for(new mid = 1; mid < sizeof(ModsPoint); mid++)
    if(IsPlayerInRangeOfPoint(playerid, 5.0, ModsPoint[mid][ModsPos][0], ModsPoint[mid][ModsPos][1], ModsPoint[mid][ModsPos][2]))
    {
        if(Vehicle_IsOwner(playerid, vehid))
        {
            format(string,sizeof(string),"Slot\tMod Type\tModel\n");
            if(pData[playerid][pVip] > 1)
            {
                for (new i = 0; i < MAX_VEHICLE_OBJECT; i++)
                {
                    if(VehicleObjects[vehid][i][vehObjectExists])
                    {
                        if(VehicleObjects[vehid][i][vehObjectType] == OBJECT_TYPE_BODY)
                        {
                            format(string,sizeof(string),"%s%d\t"GREEN_E"Mod\t%s\n", string, i, GetVehObjectNameByModel(VehicleObjects[vehid][i][vehObjectModel]));
                        }
                        else if(VehicleObjects[vehid][i][vehObjectType] == OBJECT_TYPE_TEXT)
                        {
                            format(string,sizeof(string),"%s%d\t"GREEN_E"Sticker\t%s\n", string, i, VehicleObjects[vehid][i][vehObjectText]);
                        }
                        else if(VehicleObjects[vehid][i][vehObjectType] == OBJECT_TYPE_LIGHT)
                        {
                            format(string,sizeof(string),"%s%d\t"GREEN_E"SpotLight\t%s\n", string, i, VehicleObjects[vehid][i][vehObjectText]);
                        }
                    }
                    else
                    {
                        format(string, sizeof(string), "%sNew\tMod\n", string);
                    }
                    if (count < 10)
                    {
                        ListedVehObject[playerid][count] = i;
                        count = count + 1;
                    }
                }
            }
            else
            {
                for (new i = 0; i < 3; i ++)
                {
                    if(VehicleObjects[vehid][i][vehObjectExists])
                    {
                        if(VehicleObjects[vehid][i][vehObjectType] == OBJECT_TYPE_BODY)
                        {
                            format(string,sizeof(string),"%s%d\t"GREEN_E"Mod\t%s\n", string, i, GetVehObjectNameByModel(VehicleObjects[vehid][i][vehObjectModel]));
                        }
                        else if(VehicleObjects[vehid][i][vehObjectType] == OBJECT_TYPE_TEXT)
                        {
                            format(string,sizeof(string),"%s%d\t"GREEN_E"Sticker\t%s\n", string, i, VehicleObjects[vehid][i][vehObjectText]);
                        }
                        else if(VehicleObjects[vehid][i][vehObjectType] == OBJECT_TYPE_LIGHT)
                        {
                            format(string,sizeof(string),"%s%d\t"GREEN_E"SpotLight\t%s\n", string, i, VehicleObjects[vehid][i][vehObjectText]);
                        }
                    }
                    else
                    {
                        format(string, sizeof(string), "%sNew\tMod\n", string);
                    }
                    if (count < 10)
                    {
                        ListedVehObject[playerid][count] = i;
                        count = count + 1;
                    }
                }
            }

            if(!count) 
            {
                Error(playerid, "You don't have vehicle toys installed!");
            }
            else 
            {
                Player_EditVehicleObject[playerid] = vehid;
                Dialog_Show(playerid, EditingVehObject, DIALOG_STYLE_TABLIST_HEADERS, "Modshop: List", string, "Select","Exit");
            }
        }
    }
    return 1;
}