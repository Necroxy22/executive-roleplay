#define MAX_COBJECT 100
#define MAX_MT      100

new EditingObject[MAX_PLAYERS];
new EditingMatext[MAX_PLAYERS];

enum mtData
{
	mtID,
	mtExists,
	Float:mtPos[6],
	mtText[128],
	mtCreate,
	mtInterior,
	mtVW,
	mtSize,
	mtColor,
	mtBold
	
};
new MatextData[MAX_MT][mtData];

enum objData
{
	objID,
	objModel,
	objExists,
	Float:objPos[6],
	objVW,
	objInterior,
	objCreate
}
new ObjectData[MAX_COBJECT][objData];

stock Matext_Create(playerid, text[])
{
    new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_MT; i ++) if (!MatextData[i][mtExists])
		{
		    MatextData[i][mtExists] = true;

		    x += 1.0 * floatsin(-angle, degrees);
			y += 1.0 * floatcos(-angle, degrees);

            format(MatextData[i][mtText], 128, "%s", text);
            
            MatextData[i][mtPos][0] = x;
            MatextData[i][mtPos][1] = y;
            MatextData[i][mtPos][2] = z;
			MatextData[i][mtPos][3] = 0.0;
			MatextData[i][mtPos][4] = 0.0;
            MatextData[i][mtPos][5] = angle;
            MatextData[i][mtSize] = 30; //Default Size adalah 30
            MatextData[i][mtColor] = 1;
            MatextData[i][mtBold] = 0;

            MatextData[i][mtInterior] = GetPlayerInterior(playerid);
            MatextData[i][mtVW] = GetPlayerVirtualWorld(playerid);

			Matext_Refresh(i);
			mysql_tquery(g_SQL, "INSERT INTO `matext` (`mtInterior`) VALUES(0)", "OnMatextCreated", "d", i);

			return i;
		}
	}
	return -1;
}

stock Object_Create(playerid, modelid)
{
    new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_COBJECT; i ++) if (!ObjectData[i][objExists])
		{
		    ObjectData[i][objExists] = true;

		    x += 1.0 * floatsin(-angle, degrees);
			y += 1.0 * floatcos(-angle, degrees);

            ObjectData[i][objPos][0] = x;
            ObjectData[i][objPos][1] = y;
            ObjectData[i][objPos][2] = z;
			ObjectData[i][objPos][3] = 0.0;
			ObjectData[i][objPos][4] = 0.0;
            ObjectData[i][objPos][5] = angle;
            ObjectData[i][objModel] = modelid;

            ObjectData[i][objInterior] = GetPlayerInterior(playerid);
            ObjectData[i][objVW] = GetPlayerVirtualWorld(playerid);

			Object_Refresh(i);
			mysql_tquery(g_SQL, "INSERT INTO `object` (`objectInterior`) VALUES(0)", "OnObjectCreated", "d", i);

			return i;
		}
	}
	return -1;
}

stock Object_Save(objid)
{
	new
	    query[512];

	format(query, sizeof(query), "UPDATE `object` SET `objectModel` = '%d', `objectX` = '%.4f', `objectY` = '%.4f', `objectZ` = '%.4f', `objectRX` = '%.4f', `objectRY` = '%.4f', `objectRZ` = '%.4f', `objectInterior` = '%d', `objectWorld` = '%d' WHERE `objid` = '%d'",
		ObjectData[objid][objModel],
		ObjectData[objid][objPos][0],
	    ObjectData[objid][objPos][1],
	    ObjectData[objid][objPos][2],
	    ObjectData[objid][objPos][3],
	    ObjectData[objid][objPos][4],
	    ObjectData[objid][objPos][5],
	    ObjectData[objid][objInterior],
	    ObjectData[objid][objVW],
	    ObjectData[objid][objID]
	);
	return mysql_tquery(g_SQL, query);
}

stock Matext_Save(mtid)
{
	new
	    query[512];

	format(query, sizeof(query), "UPDATE `matext` SET `mtText` = '%s', `mtX` = '%.4f', `mtY` = '%.4f', `mtZ` = '%.4f', `mtRX` = '%.4f', `mtRY` = '%.4f', `mtRZ` = '%.4f', `mtInterior` = '%d', `mtWorld` = '%d', `mtBold` = '%d', `mtColor` = '%d', `mtSize` = '%d' WHERE `mtID` = '%d'",
		MatextData[mtid][mtText],
		MatextData[mtid][mtPos][0],
	    MatextData[mtid][mtPos][1],
	    MatextData[mtid][mtPos][2],
	    MatextData[mtid][mtPos][3],
	    MatextData[mtid][mtPos][4],
	    MatextData[mtid][mtPos][5],
	    MatextData[mtid][mtInterior],
	    MatextData[mtid][mtVW],
	    MatextData[mtid][mtBold],
	    MatextData[mtid][mtColor],
	    MatextData[mtid][mtSize],
	    MatextData[mtid][mtID]
	);
	return mysql_tquery(g_SQL, query);
}

stock Object_Refresh(objid)
{
	if (objid != -1 && ObjectData[objid][objExists])
	{
	    if (IsValidDynamicObject(ObjectData[objid][objCreate]))
	        DestroyDynamicObject(ObjectData[objid][objCreate]);

	 	ObjectData[objid][objCreate] = CreateDynamicObject(ObjectData[objid][objModel], ObjectData[objid][objPos][0], ObjectData[objid][objPos][1], ObjectData[objid][objPos][2] - 0.0, ObjectData[objid][objPos][3], ObjectData[objid][objPos][4],ObjectData[objid][objPos][5], ObjectData[objid][objVW], ObjectData[objid][objInterior]);
		return 1;
	}
	return 0;
}

stock Matext_Refresh(mtid)
{
	static
	    color;
	    
	if (mtid != -1 && MatextData[mtid][mtExists])
	{
	    if (IsValidDynamicObject(MatextData[mtid][mtCreate]))
	        DestroyDynamicObject(MatextData[mtid][mtCreate]);

		switch (MatextData[mtid][mtColor])
		{
		    case 1: color = 0xFFFFFFFF;//Putih
		    case 2: color = 0xFF6347FF;//Biru
		    case 3: color = 0xFFFF6347;//Merah
		    case 4: color = 0xFFFFFF00;//Kuning
		}
	 	MatextData[mtid][mtCreate] = CreateDynamicObject(19482, MatextData[mtid][mtPos][0], MatextData[mtid][mtPos][1], MatextData[mtid][mtPos][2] - 0.0, MatextData[mtid][mtPos][3], MatextData[mtid][mtPos][4],MatextData[mtid][mtPos][5], MatextData[mtid][mtVW], MatextData[mtid][mtInterior]);
		SetDynamicObjectMaterial(MatextData[mtid][mtCreate], 0, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
        SetDynamicObjectMaterialText(MatextData[mtid][mtCreate], 0, MatextData[mtid][mtText], 130, "Arial", MatextData[mtid][mtSize], MatextData[mtid][mtBold], color, 0x00000000, 0);
		return 1;
	}
	return 0;
}

//	SetDynamicObjectMaterialText(MatextData[mtid][mtCreate], 0, MatextData[mtid][mtText], 130, "Ariel", 40, 0, 0xFF6347FF, 0x00000000, 1);

forward OnMatextCreated(mtid);
public OnMatextCreated(mtid)
{
    if (mtid == -1 || !MatextData[mtid][mtExists])
		return 0;

	MatextData[mtid][mtID] = cache_insert_id();
 	Matext_Save(mtid);

	return 1;
}

forward OnObjectCreated(objid);
public OnObjectCreated(objid)
{
    if (objid == -1 || !ObjectData[objid][objExists])
		return 0;

	ObjectData[objid][objID] = cache_insert_id();
 	Object_Save(objid);

	return 1;
}

forward Object_Load();
public Object_Load()
{
	new rows = cache_num_rows();
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
		    ObjectData[i][objExists] = true;
		    cache_get_value_name_int(i, "objid", ObjectData[i][objID]);
		    cache_get_value_name_int(i, "objectModel", ObjectData[i][objModel]);
		    cache_get_value_name_float(i, "objectX", ObjectData[i][objPos][0]);
		    cache_get_value_name_float(i, "objectY", ObjectData[i][objPos][1]);
		    cache_get_value_name_float(i, "objectZ", ObjectData[i][objPos][2]);
		    cache_get_value_name_float(i, "objectRX", ObjectData[i][objPos][3]);
		    cache_get_value_name_float(i, "objectRY", ObjectData[i][objPos][4]);
		    cache_get_value_name_float(i, "objectRZ", ObjectData[i][objPos][5]);
            cache_get_value_name_int(i, "objectInterior", ObjectData[i][objInterior]);
            cache_get_value_name_int(i, "objectWorld", ObjectData[i][objVW]);

			Object_Refresh(i);
		}
	}
	return 1;
}

forward Matext_Load();
public Matext_Load()
{
	new rows = cache_num_rows();
	new mt[128];
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
		    MatextData[i][mtExists] = true;
		    
            cache_get_value_name(i, "mtText", mt);
            format(MatextData[i][mtText], 128, mt);
            
            cache_get_value_name_int(i, "mtID", MatextData[i][mtID]);
		    cache_get_value_name_float(i, "mtX", MatextData[i][mtPos][0]);
		    cache_get_value_name_float(i, "mtY", MatextData[i][mtPos][1]);
		    cache_get_value_name_float(i, "mtZ", MatextData[i][mtPos][2]);
		    
		    cache_get_value_name_float(i, "mtRX", MatextData[i][mtPos][3]);
		    cache_get_value_name_float(i, "mtRY", MatextData[i][mtPos][4]);
		    cache_get_value_name_float(i, "mtRZ", MatextData[i][mtPos][5]);

            cache_get_value_name_int(i, "mtInterior", MatextData[i][mtInterior]);
            cache_get_value_name_int(i, "mtWorld", MatextData[i][mtVW]);
            cache_get_value_name_int(i, "mtBold", MatextData[i][mtBold]);
            cache_get_value_name_int(i, "mtColor", MatextData[i][mtColor]);
            cache_get_value_name_int(i, "mtSize", MatextData[i][mtSize]);

			Matext_Refresh(i);
		}
	}
	return 1;
}


stock Matext_Delete(mtid)
{
	if (mtid != -1 && MatextData[mtid][mtExists])
	{
	    new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `matext` WHERE `mtID` = '%d'", MatextData[mtid][mtID]);
		mysql_tquery(g_SQL, string);

        if (IsValidDynamicObject(MatextData[mtid][mtCreate]))
	        DestroyDynamicObject(MatextData[mtid][mtCreate]);

	    MatextData[mtid][mtExists] = false;
	   	MatextData[mtid][mtID] = 0;
	}
	return 1;
}

stock Object_Delete(objid)
{
	if (objid != -1 && ObjectData[objid][objExists])
	{
	    new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `object` WHERE `objid` = '%d'", ObjectData[objid][objID]);
		mysql_tquery(g_SQL, string);

        if (IsValidDynamicObject(ObjectData[objid][objCreate]))
	        DestroyDynamicObject(ObjectData[objid][objCreate]);

	    ObjectData[objid][objExists] = false;
	   	ObjectData[objid][objID] = 0;
	}
	return 1;
}