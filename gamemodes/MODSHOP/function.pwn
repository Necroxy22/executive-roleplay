forward Vehicle_ObjectDB(vehicleid, slot);
public Vehicle_ObjectDB(vehicleid, slot)
{
	if(VehicleObjects[vehicleid][slot][vehObjectExists] == false)
		return 0;

	VehicleObjects[vehicleid][slot][vehObjectID] = cache_insert_id();


	Vehicle_ObjectSave(vehicleid, slot);
	return 1;
}


forward Vehicle_ObjectLoaded(vehicleid, playerid);
public Vehicle_ObjectLoaded(vehicleid, playerid)
{
	if(cache_num_rows())
	{
		for(new slot = 0; slot != cache_num_rows(); slot++)
        { 
            if(!VehicleObjects[vehicleid][slot][vehObjectExists])
            {
                // Load semua data yang ada di Mysql dan di simpan ke dalam variabel, untuk di tampung
                VehicleObjects[vehicleid][slot][vehObjectExists] = true;

                cache_get_value_name(slot, "text", VehicleObjects[vehicleid][slot][vehObjectText], 32);
                cache_get_value_name(slot, "font", VehicleObjects[vehicleid][slot][vehObjectFont], 32);			

                cache_get_value_name_int(slot, "id", VehicleObjects[vehicleid][slot][vehObjectID]);
                cache_get_value_name_int(slot, "vehicle", VehicleObjects[vehicleid][slot][vehObjectVehicleIndex]);
                cache_get_value_name_int(slot, "type", VehicleObjects[vehicleid][slot][vehObjectType]);
                cache_get_value_name_int(slot, "model", VehicleObjects[vehicleid][slot][vehObjectModel]);
				cache_get_value_name_int(slot, "color", VehicleObjects[vehicleid][slot][vehObjectColor]);

                cache_get_value_name_int(slot, "fontcolor", VehicleObjects[vehicleid][slot][vehObjectFontColor]);
                cache_get_value_name_int(slot, "fontsize", VehicleObjects[vehicleid][slot][vehObjectFontSize]);

                cache_get_value_name_float(slot, "x", VehicleObjects[vehicleid][slot][vehObjectPosX]);
                cache_get_value_name_float(slot, "y", VehicleObjects[vehicleid][slot][vehObjectPosY]);
                cache_get_value_name_float(slot, "z", VehicleObjects[vehicleid][slot][vehObjectPosZ]);

                cache_get_value_name_float(slot, "rx", VehicleObjects[vehicleid][slot][vehObjectPosRX]);
                cache_get_value_name_float(slot, "ry", VehicleObjects[vehicleid][slot][vehObjectPosRY]);
                cache_get_value_name_float(slot, "rz", VehicleObjects[vehicleid][slot][vehObjectPosRZ]);

                // Ketika sudah terload, maka object yang sudah di tampung ke dalam variabel akan di attach berdasarkan slotnya!
                Vehicle_AttachObject(vehicleid, slot);
            }
        }
	}
	return 1;
}

// Function untuk ngesave object ke dalam database dari variabel penampung!
Vehicle_ObjectSave(vehicleid, slot)
{
	if(VehicleObjects[vehicleid][slot][vehObjectExists])
    {
        new query[1024];

        format(query, sizeof(query), "UPDATE `vehicle_object` SET `model`='%d', `color`='%d',`type`='%d', `x`='%f',`y`='%f',`z`='%f', `rx`='%f',`ry`='%f',`rz`='%f'",
            VehicleObjects[vehicleid][slot][vehObjectModel],
            VehicleObjects[vehicleid][slot][vehObjectColor],
            VehicleObjects[vehicleid][slot][vehObjectType],
            VehicleObjects[vehicleid][slot][vehObjectPosX], 
            VehicleObjects[vehicleid][slot][vehObjectPosY], 
            VehicleObjects[vehicleid][slot][vehObjectPosZ], 
            VehicleObjects[vehicleid][slot][vehObjectPosRX],
            VehicleObjects[vehicleid][slot][vehObjectPosRY], 
            VehicleObjects[vehicleid][slot][vehObjectPosRZ]
        );

        format(query, sizeof(query), "%s, `text`='%s',`font`='%s', `fontsize`='%d',`fontcolor`='%d' WHERE `id`='%d' AND `vehicle` = '%d'",
            query, 
            VehicleObjects[vehicleid][slot][vehObjectText], 
            VehicleObjects[vehicleid][slot][vehObjectFont], 
            VehicleObjects[vehicleid][slot][vehObjectFontSize], 
            VehicleObjects[vehicleid][slot][vehObjectFontColor], 
            VehicleObjects[vehicleid][slot][vehObjectID],
			VehicleObjects[vehicleid][slot][vehObjectVehicleIndex]
        );
        mysql_tquery(g_SQL, query);
    }
	return 1;
}

// Function untuk menambahkan object untuk vehicle id tersebut
// Model = Object modelnya || Type = 1 / 2, 1 Itu Object, 2 Itu Text
Vehicle_ObjectAddObjects(playerid, vehicleid, model, type)
{
    if(Iter_Contains(PVehicles, vehicleid)) // Jika vehicle id nya tidak sama dengan yang ada di iterator PVehicles, dia akan return 0
	{
        new query_string[255];
        for(new slot = 0; slot < MAX_VEHICLE_OBJECT; slot++)
        { 
            if(VehicleObjects[vehicleid][slot][vehObjectExists] == false)
            {
                VehicleObjects[vehicleid][slot][vehObjectExists] = true;

                VehicleObjects[vehicleid][slot][vehObjectType] = type;
                VehicleObjects[vehicleid][slot][vehObjectVehicleIndex] = pvData[vehicleid][cID];
                VehicleObjects[vehicleid][slot][vehObjectModel] = model;		

                VehicleObjects[vehicleid][slot][vehObjectColor] = 0;

                VehicleObjects[vehicleid][slot][vehObjectPosX] = 0.0;
                VehicleObjects[vehicleid][slot][vehObjectPosY] = 0.0;
                VehicleObjects[vehicleid][slot][vehObjectPosZ] = 0.0;

                VehicleObjects[vehicleid][slot][vehObjectPosRX] = 0.0;
                VehicleObjects[vehicleid][slot][vehObjectPosRY] = 0.0;
                VehicleObjects[vehicleid][slot][vehObjectPosRZ] = 0.0;

                if(VehicleObjects[vehicleid][slot][vehObjectType] == OBJECT_TYPE_TEXT) //
                {
                    format(VehicleObjects[vehicleid][slot][vehObjectText], 32, "TEXT");
                    format(VehicleObjects[vehicleid][slot][vehObjectFont], 24, "Arial");
                    VehicleObjects[vehicleid][slot][vehObjectFontColor] = 1;
                    VehicleObjects[vehicleid][slot][vehObjectFontSize] = 24; 
                }

                Dialog_Show(playerid, DIALOG_MODSHOPMOVE, DIALOG_STYLE_LIST, "Modshop", "Position\nPosition (Manual)", "Select", "Close");
                GivePlayerMoneyEx(playerid, -5000);
                SendClientMessageEx(playerid, COLOR_ARWIN, "MODSHOP: {ffffff}You've purchased {ffff00}%s {ffffff}for {00ff00}$50.00", GetVehObjectNameByModel(VehicleObjects[vehicleid][slot][vehObjectModel]));
                format(query_string, sizeof(query_string), "INSERT INTO `vehicle_object` (`vehicle`) VALUES ('%d')", pvData[vehicleid][cID]);
                mysql_tquery(g_SQL, query_string, "Vehicle_ObjectDB", "dd", vehicleid, slot);
                return 1;
            }
        }
	}
	return 0;
}

Vehicle_TextAdd(playerid, vehicleid, model, type)
{
    if(Iter_Contains(PVehicles, vehicleid)) // Jika vehicle id nya tidak sama dengan yang ada di iterator PVehicles, dia akan return 0
	{
        new query_string[255];
        for(new slot = 0; slot < MAX_VEHICLE_OBJECT; slot++)
        { 
            if(VehicleObjects[vehicleid][slot][vehObjectExists] == false)
            {
                VehicleObjects[vehicleid][slot][vehObjectExists] = true;

                VehicleObjects[vehicleid][slot][vehObjectType] = type;
                VehicleObjects[vehicleid][slot][vehObjectVehicleIndex] = pvData[vehicleid][cID];
                VehicleObjects[vehicleid][slot][vehObjectModel] = model;		

                VehicleObjects[vehicleid][slot][vehObjectColor] = 0;

                VehicleObjects[vehicleid][slot][vehObjectPosX] = 0.0;
                VehicleObjects[vehicleid][slot][vehObjectPosY] = 0.0;
                VehicleObjects[vehicleid][slot][vehObjectPosZ] = 0.0;

                VehicleObjects[vehicleid][slot][vehObjectPosRX] = 0.0;
                VehicleObjects[vehicleid][slot][vehObjectPosRY] = 0.0;
                VehicleObjects[vehicleid][slot][vehObjectPosRZ] = 0.0;

                if(VehicleObjects[vehicleid][slot][vehObjectType] == OBJECT_TYPE_TEXT) //
                {
                    format(VehicleObjects[vehicleid][slot][vehObjectText], 32, "TEXT");
                    format(VehicleObjects[vehicleid][slot][vehObjectFont], 24, "Arial");
                    VehicleObjects[vehicleid][slot][vehObjectFontColor] = 1;
                    VehicleObjects[vehicleid][slot][vehObjectFontSize] = 24; 
                }

                Dialog_Show(playerid, VACCSE1, DIALOG_STYLE_LIST, "Edit Component", "Position\nPosition (Manual)\nText Name\nText Size\nText Font\nText Color\nRemove Modification", "Select", "Back");
                GivePlayerMoneyEx(playerid, -5000);
                SendClientMessageEx(playerid, COLOR_ARWIN, "MODSHOP: {ffffff}You've purchased {ffff00}Sticker {ffffff}for {00ff00}$50.00");
                format(query_string, sizeof(query_string), "INSERT INTO `vehicle_object` (`vehicle`) VALUES ('%d')", pvData[vehicleid][cID]);
                mysql_tquery(g_SQL, query_string, "Vehicle_ObjectDB", "dd", vehicleid, slot);
                return 1;
            }
        }
	}
	return 0;
}

Vehicle_SpotLightAdd(playerid, vehicleid, model, type)
{
    if(Iter_Contains(PVehicles, vehicleid)) // Jika vehicle id nya tidak sama dengan yang ada di iterator PVehicles, dia akan return 0
	{
        new query_string[255];
        for(new slot = 0; slot < MAX_VEHICLE_OBJECT; slot++)
        { 
            if(VehicleObjects[vehicleid][slot][vehObjectExists] == false)
            {
                if(GetPlayerMoney(playerid) < 5000)
	  			    return Error(playerid, "Untuk membeli vehicle toys kamu harus mempunyai uang $50.00");
                VehicleObjects[vehicleid][slot][vehObjectExists] = true;

                VehicleObjects[vehicleid][slot][vehObjectType] = type;
                VehicleObjects[vehicleid][slot][vehObjectVehicleIndex] = pvData[vehicleid][cID];
                VehicleObjects[vehicleid][slot][vehObjectModel] = model;		

                VehicleObjects[vehicleid][slot][vehObjectColor] = 0;

                VehicleObjects[vehicleid][slot][vehObjectPosX] = 0.0;
                VehicleObjects[vehicleid][slot][vehObjectPosY] = 0.0;
                VehicleObjects[vehicleid][slot][vehObjectPosZ] = 0.0;

                VehicleObjects[vehicleid][slot][vehObjectPosRX] = 0.0;
                VehicleObjects[vehicleid][slot][vehObjectPosRY] = 0.0;
                VehicleObjects[vehicleid][slot][vehObjectPosRZ] = 0.0;

                Dialog_Show(playerid, DIALOG_SPOTLIGHT, DIALOG_STYLE_LIST, "Modshop", "Position\nPosition (Manual)\nLight Color", "Select", "Close");
                GivePlayerMoneyEx(playerid, -5000);
                SendClientMessageEx(playerid, COLOR_ARWIN, "MODSHOP: {ffffff}You've purchased {ffff00}SpotLight {ffffff}for {00ff00}$50.00");
                format(query_string, sizeof(query_string), "INSERT INTO `vehicle_object` (`vehicle`) VALUES ('%d')", pvData[vehicleid][cID]);
                mysql_tquery(g_SQL, query_string, "Vehicle_ObjectDB", "dd", vehicleid, slot);
                return 1;
            }
        }
	}
	return 0;
}

// Function untuk attach vehicle object ke kendaraan yang sudah ada di server!
Vehicle_AttachObject(vehicleid, slot)
{
    if(Iter_Contains(PVehicles, vehicleid))
	{
        new
            model       = VehicleObjects[vehicleid][slot][vehObjectModel],
            Float:x     = VehicleObjects[vehicleid][slot][vehObjectPosX],
            Float:y     = VehicleObjects[vehicleid][slot][vehObjectPosY],
            Float:z     = VehicleObjects[vehicleid][slot][vehObjectPosZ],
            Float:rx    = VehicleObjects[vehicleid][slot][vehObjectPosRX],
            Float:ry    = VehicleObjects[vehicleid][slot][vehObjectPosRY],
            Float:rz    = VehicleObjects[vehicleid][slot][vehObjectPosRZ],
            Float:vposx,
            Float:vposy,
            Float:vposz
        ;

        if(IsValidDynamicObject(VehicleObjects[vehicleid][slot][vehObject]))
            DestroyDynamicObject(VehicleObjects[vehicleid][slot][vehObject]);

        VehicleObjects[vehicleid][slot][vehObject] = INVALID_OBJECT_ID;

        GetVehiclePos(pvData[vehicleid][cVeh], vposx, vposy, vposz);

        VehicleObjects[vehicleid][slot][vehObject] = CreateDynamicObject(model, vposx, vposy, vposz, rx, ry, rz);

        Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleObjects[vehicleid][slot][vehObject], E_STREAMER_DRAW_DISTANCE, 25);
        Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleObjects[vehicleid][slot][vehObject], E_STREAMER_STREAM_DISTANCE, 25);

        if(VehicleObjects[vehicleid][slot][vehObjectType] == OBJECT_TYPE_BODY)
        {
            Vehicle_ObjectColorSync(vehicleid, slot);
        }
        else if(VehicleObjects[vehicleid][slot][vehObjectType] == OBJECT_TYPE_TEXT)
        {
            Vehicle_ObjectTextSync(vehicleid, slot);
        }
        else if(VehicleObjects[vehicleid][slot][vehObjectType] == OBJECT_TYPE_LIGHT)
        {
            Vehicle_SpotLightDelete(vehicleid, slot);
        }
        AttachDynamicObjectToVehicle(VehicleObjects[vehicleid][slot][vehObject], pvData[vehicleid][cVeh], x, y, z, rx, ry, rz);
        Vehicle_ObjectUpdate(vehicleid, slot);
        return 1;
    }
    return 0;
}

// Function Untuk sync object color yang ada di kendaraan, ketika mengubah warna object!
Vehicle_SpotLightDelete(vehicleid, slot)
{
    if(Iter_Contains(PVehicles, vehicleid))
	{
        switch(GetLightStatus(vehicleid))
		{
			case false:
			{
                if(IsValidDynamicObject(VehicleObjects[vehicleid][slot][vehObject]))
                    DestroyDynamicObject(VehicleObjects[vehicleid][slot][vehObject]);
			}
			case true:
			{
                new
                    model       = VehicleObjects[vehicleid][slot][vehObjectModel],
                    Float:x     = VehicleObjects[vehicleid][slot][vehObjectPosX],
                    Float:y     = VehicleObjects[vehicleid][slot][vehObjectPosY],
                    Float:z     = VehicleObjects[vehicleid][slot][vehObjectPosZ],
                    Float:rx    = VehicleObjects[vehicleid][slot][vehObjectPosRX],
                    Float:ry    = VehicleObjects[vehicleid][slot][vehObjectPosRY],
                    Float:rz    = VehicleObjects[vehicleid][slot][vehObjectPosRZ],
                    Float:vposx,
                    Float:vposy,
                    Float:vposz
                ;
                if(VehicleObjects[vehicleid][slot][vehObjectType] == OBJECT_TYPE_LIGHT)
                {
                    if(IsValidDynamicObject(VehicleObjects[vehicleid][slot][vehObject]))
                    DestroyDynamicObject(VehicleObjects[vehicleid][slot][vehObject]);

                    VehicleObjects[vehicleid][slot][vehObject] = INVALID_OBJECT_ID;

                    GetVehiclePos(pvData[vehicleid][cVeh], vposx, vposy, vposz);

                    VehicleObjects[vehicleid][slot][vehObject] = CreateDynamicObject(model, vposx, vposy, vposz, rx, ry, rz);

                    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleObjects[vehicleid][slot][vehObject], E_STREAMER_DRAW_DISTANCE, 25);
                    Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleObjects[vehicleid][slot][vehObject], E_STREAMER_STREAM_DISTANCE, 25);

                    AttachDynamicObjectToVehicle(VehicleObjects[vehicleid][slot][vehObject], pvData[vehicleid][cVeh], x, y, z, rx, ry, rz);
                    Vehicle_ObjectUpdate(vehicleid, slot);
                }
			}
		}
        return 1;
    }
    return 0;
}

// Function Untuk sync object color yang ada di kendaraan, ketika mengubah warna object!
Vehicle_ObjectColorSync(vehicleid, slot)
{
    if(Iter_Contains(PVehicles, vehicleid))
	{
        SetDynamicObjectMaterial(VehicleObjects[vehicleid][slot][vehObject], 0, VehicleObjects[vehicleid][slot][vehObjectModel], "none", "none", RGBAToARGB(ColorList[VehicleObjects[vehicleid][slot][vehObjectColor]]));
        return 1;
    }
    return 0;
}

// Function Untuk sync object color yang ada di kendaraan, ketika mengubah warna object!
Vehicle_LightColorSync(vehicleid, slot, id, playerid)
{
    if(Iter_Contains(PVehicles, vehicleid))
	{
        new
            Float:x     = VehicleObjects[vehicleid][slot][vehObjectPosX],
            Float:y     = VehicleObjects[vehicleid][slot][vehObjectPosY],
            Float:z     = VehicleObjects[vehicleid][slot][vehObjectPosZ],
            Float:rx    = VehicleObjects[vehicleid][slot][vehObjectPosRX],
            Float:ry    = VehicleObjects[vehicleid][slot][vehObjectPosRY],
            Float:rz    = VehicleObjects[vehicleid][slot][vehObjectPosRZ],
            Float:vposx,
            Float:vposy,
            Float:vposz
        ;
        VehicleObjects[vehicleid][slot][vehObjectModel] = id;
        if(IsValidDynamicObject(VehicleObjects[vehicleid][slot][vehObject]))
            DestroyDynamicObject(VehicleObjects[vehicleid][slot][vehObject]);


        GetVehiclePos(pvData[vehicleid][cVeh], vposx, vposy, vposz);
        VehicleObjects[vehicleid][slot][vehObject] = INVALID_OBJECT_ID;
        VehicleObjects[vehicleid][slot][vehObject] = CreateDynamicObject(VehicleObjects[vehicleid][slot][vehObjectModel], vposx+x, vposy+y, vposz+z, rx, ry, rz);   
        
        Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleObjects[vehicleid][slot][vehObject], E_STREAMER_DRAW_DISTANCE, 15);
        Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleObjects[vehicleid][slot][vehObject], E_STREAMER_STREAM_DISTANCE, 15);
        //Vehicle_ObjectSave(vehicleid, slot); // Setelah warna di ubah pastikan selalu di save!
        Dialog_Show(playerid, DIALOG_SPOTLIGHT, DIALOG_STYLE_LIST, "Modshop", "Position\nPosition (Manual)\nLight Color\nSave", "Select", "Close");
	    return 1;
    }
    return 0;
}

// Function untuk sync text yang ada di kendaraan ketika mengubah text!
Vehicle_ObjectTextSync(vehicleid, slot)
{
    if(Iter_Contains(PVehicles, vehicleid))
	{
        SetDynamicObjectMaterialText(VehicleObjects[vehicleid][slot][vehObject], 0, VehicleObjects[vehicleid][slot][vehObjectText], 130, VehicleObjects[vehicleid][slot][vehObjectFont], VehicleObjects[vehicleid][slot][vehObjectFontSize], 1, RGBAToARGB(ColorList[VehicleObjects[vehicleid][slot][vehObjectFontColor]]), 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
        return 1;
    }
    return 0;
}

// Function ini berguna untuk update posisi object ke dalam variabel setelah di edit menggunakan
// ..- Callback OnPlayerEditDynamicObject!
Vehicle_ObjectUpdate(vehicleid, slot)
{   
	if(Iter_Contains(PVehicles, vehicleid))
	{
        new
            Float:x     = VehicleObjects[vehicleid][slot][vehObjectPosX],
            Float:y     = VehicleObjects[vehicleid][slot][vehObjectPosY],
            Float:z     = VehicleObjects[vehicleid][slot][vehObjectPosZ],
            Float:rx    = VehicleObjects[vehicleid][slot][vehObjectPosRX],
            Float:ry    = VehicleObjects[vehicleid][slot][vehObjectPosRY],
            Float:rz    = VehicleObjects[vehicleid][slot][vehObjectPosRZ]
        ;

        // Streamer SetFloatData ini berguna untuk memanipulasi data object float yang ada di object streamer dari variabel yang tersimpan
        Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleObjects[vehicleid][slot][vehObject], E_STREAMER_X, x);
        Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleObjects[vehicleid][slot][vehObject], E_STREAMER_Y, y);
        Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleObjects[vehicleid][slot][vehObject], E_STREAMER_Z, z);
        Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleObjects[vehicleid][slot][vehObject], E_STREAMER_R_X, rx);
        Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleObjects[vehicleid][slot][vehObject], E_STREAMER_R_Y, ry);
        Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleObjects[vehicleid][slot][vehObject], E_STREAMER_R_Z, rz);
        Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleObjects[vehicleid][slot][vehObject], E_STREAMER_DRAW_DISTANCE, 25);
        Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleObjects[vehicleid][slot][vehObject], E_STREAMER_STREAM_DISTANCE, 25);
        return 1;
    }
    return 0;
}

// Function ini berguna untuk menghapus object pada kendaraan, berdasarkan slot!
Vehicle_ObjectDelete(vehicleid, slot)
{
    if(Iter_Contains(PVehicles, vehicleid))
	{
        new query_string[255];
        if(IsValidDynamicObject(VehicleObjects[vehicleid][slot][vehObject]))
            DestroyDynamicObject(VehicleObjects[vehicleid][slot][vehObject]);

        VehicleObjects[vehicleid][slot ][vehObject] = INVALID_OBJECT_ID;

        VehicleObjects[vehicleid][slot][vehObjectModel] = 0;
        VehicleObjects[vehicleid][slot][vehObjectExists] = false;

        VehicleObjects[vehicleid][slot][vehObjectColor] = 0;


        VehicleObjects[vehicleid][slot][vehObjectPosX] = VehicleObjects[vehicleid][slot][vehObjectPosY] = VehicleObjects[vehicleid][slot][vehObjectPosZ] = 0.0;
        VehicleObjects[vehicleid][slot][vehObjectPosRX] = VehicleObjects[vehicleid][slot][vehObjectPosRY] = VehicleObjects[vehicleid][slot][vehObjectPosRZ] = 0.0;
        format(query_string, sizeof(query_string), "DELETE FROM `vehicle_object` WHERE `id` = '%d'", VehicleObjects[vehicleid][slot][vehObjectID]);
        mysql_tquery(g_SQL, query_string);
        return 1;
    }
    return 0;
}

// Function ini berguna untuk menghapus object pada kendaraan secara keseluruhan!
Vehicle_ObjectDestroy(vehicleid)
{
    if(Iter_Contains(PVehicles, vehicleid))
	{
        for(new slot = 0; slot < MAX_VEHICLE_OBJECT; slot++)
        {
            //Jika objectnya valid, maka object akan di hapus!
            if(IsValidDynamicObject(VehicleObjects[vehicleid][slot][vehObject]))
                DestroyDynamicObject(VehicleObjects[vehicleid][slot][vehObject]);

            VehicleObjects[vehicleid][slot][vehObject] = INVALID_OBJECT_ID;

            VehicleObjects[vehicleid][slot][vehObjectModel] = 0;
            VehicleObjects[vehicleid][slot][vehObjectExists] = false;

            VehicleObjects[vehicleid][slot][vehObjectColor] = 1;

            VehicleObjects[vehicleid][slot][vehObjectPosX] = VehicleObjects[vehicleid][slot][vehObjectPosY] = VehicleObjects[vehicleid][slot][vehObjectPosZ] = 0.0;
            VehicleObjects[vehicleid][slot][vehObjectPosRX] = VehicleObjects[vehicleid][slot][vehObjectPosRY] = VehicleObjects[vehicleid][slot][vehObjectPosRZ] = 0.0;
        }
        return 1;
    }
    return 0;
}

// Function ini berguna dan akan terpanggil ketika kita "ingin" meng-edit kordinat dari object kita ke kendaraan.
Vehicle_ObjectEdit(playerid, vehicleid, slot, bool:text = false)
{
	if(Iter_Contains(PVehicles, vehicleid))
	{
        new
            Float:x     = VehicleObjects[vehicleid][slot][vehObjectPosX],
            Float:y     = VehicleObjects[vehicleid][slot][vehObjectPosY],
            Float:z     = VehicleObjects[vehicleid][slot][vehObjectPosZ],
            Float:rx    = VehicleObjects[vehicleid][slot][vehObjectPosRX],
            Float:ry    = VehicleObjects[vehicleid][slot][vehObjectPosRY],
            Float:rz    = VehicleObjects[vehicleid][slot][vehObjectPosRZ],
            Float:vposx,
            Float:vposy,
            Float:vposz
        ;
        if(IsValidDynamicObject(VehicleObjects[vehicleid][slot][vehObject]))
            DestroyDynamicObject(VehicleObjects[vehicleid][slot][vehObject]);

        GetVehiclePos(pvData[vehicleid][cVeh], vposx, vposy, vposz);
        VehicleObjects[vehicleid][slot][vehObject] = INVALID_OBJECT_ID;
        VehicleObjects[vehicleid][slot][vehObject] = CreateDynamicObject(VehicleObjects[vehicleid][slot][vehObjectModel], vposx+x, vposy+y, vposz+z, rx, ry, rz);   

        Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleObjects[vehicleid][slot][vehObject], E_STREAMER_DRAW_DISTANCE, 15);
        Streamer_SetFloatData(STREAMER_TYPE_OBJECT, VehicleObjects[vehicleid][slot][vehObject], E_STREAMER_STREAM_DISTANCE, 15);
        Player_EditVehicleObject[playerid] = vehicleid;
        Player_EditVehicleObjectSlot[playerid] = slot;
        Player_EditingObject[playerid] = 1;
        if(text) 
        {
            Vehicle_ObjectTextSync(vehicleid, slot);
        }
        EditDynamicObject(playerid, VehicleObjects[vehicleid][slot][vehObject]);
        return 1;
    }
    return 0;
}

// Function ini akan terpanggil ketika cancel editing object
ResetEditing(playerid)
{
    if(Player_EditingObject[playerid])
    {
        if(Player_EditVehicleObject[playerid] != -1 && Player_EditVehicleObjectSlot[playerid] != -1){
            Vehicle_AttachObject(Player_EditVehicleObject[playerid], Player_EditVehicleObjectSlot[playerid]);
            Vehicle_ObjectUpdate(Player_EditVehicleObject[playerid], Player_EditVehicleObjectSlot[playerid]);
            
            Player_EditVehicleObject[playerid] = -1;
            Player_EditVehicleObjectSlot[playerid] = -1;
        }
    }
    Player_EditingObject[playerid] = 0;
    return 1;
}

GetVehObjectNameByModel(model)
{
    new
        name[32];

    for (new i = 0; i < sizeof(VehObject); i ++) 
    if(VehObject[i][Model] == model) 
    {
        strcat(name, VehObject[i][Name]);
        break;
    }
    return name;
}