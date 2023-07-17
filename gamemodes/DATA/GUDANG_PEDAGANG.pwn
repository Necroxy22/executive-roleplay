#define MAX_PEDAGANG 2
#define MAX_PDG_INT 10000

enum pedaganginfo
{
    pdgType,
    Float:pdgPosX,
    Float:pdgPosY,
    Float:pdgPosZ,
    pdgInt,
    pdgKentang,
    pdgAyamfilet,
    pdgMineral,
    pdgSnack,
    pdgChicken,
    pdgCocacola,
    pdgJeruk,
    pdgBurger,
    pdgPizza,
    Text3D:pdgLabel,
    pdgPickup
};

new pdgDATA[MAX_PEDAGANG][pedaganginfo],
    Iterator: Pedagang<MAX_PEDAGANG>;

Pedagang_Refresh(pid)
{
    if(pid != -1)
    {
        if(IsValidDynamic3DTextLabel(pdgDATA[pid][pdgLabel]))
            DestroyDynamic3DTextLabel(pdgDATA[pid][pdgLabel]);

        if(IsValidDynamicPickup(pdgDATA[pid][pdgPickup]))
            DestroyDynamicPickup(pdgDATA[pid][pdgPickup]);

        static
        string[255];
        
        new type[128];
        if(pdgDATA[pid][pdgType] == 1)
        {
            type= "GUDANG PEDAGANG";
        }
        if(pdgDATA[pid][pdgType] == 2)
        {
            type= "GUDANG PEDAGANG";
        }
        else
        {
            type= "Unknown";
        }

        format(string, sizeof(string), "Klik ALT"WHITE_E"' to open", pid, type);
        pdgDATA[pid][pdgPickup] = CreateDynamicPickup(1239, 23, pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], pdgDATA[pid][pdgPosZ]+0.2, 0, pdgDATA[pid][pdgInt], _, 4);
        pdgDATA[pid][pdgLabel] = CreateDynamic3DTextLabel(string, COLOR_BLUE, pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], pdgDATA[pid][pdgPosZ]+0.5, 2.5);
    }
    return 1;
}

function LoadPedagang()
{
    static pid;
    
    new rows = cache_num_rows();
    if(rows)
    {
        for(new i; i < rows; i++)
        {
            cache_get_value_name_int(i, "id", pid);
            cache_get_value_name_int(i, "type", pdgDATA[pid][pdgType]);
            cache_get_value_name_float(i, "posx", pdgDATA[pid][pdgPosX]);
            cache_get_value_name_float(i, "posy", pdgDATA[pid][pdgPosY]);
            cache_get_value_name_float(i, "posz", pdgDATA[pid][pdgPosZ]);
            cache_get_value_name_int(i, "interior", pdgDATA[pid][pdgInt]);
            cache_get_value_name_int(i, "kentang", pdgDATA[pid][pdgKentang]);
            cache_get_value_name_int(i, "mineral", pdgDATA[pid][pdgMineral]);
            cache_get_value_name_int(i, "snack", pdgDATA[pid][pdgSnack]);
            cache_get_value_name_int(i, "chiken", pdgDATA[pid][pdgChicken]);
            cache_get_value_name_int(i, "cocacola", pdgDATA[pid][pdgCocacola]);
            cache_get_value_name_int(i, "jeruk", pdgDATA[pid][pdgJeruk]);
            cache_get_value_name_int(i, "burger", pdgDATA[pid][pdgBurger]);
            cache_get_value_name_int(i, "pizza", pdgDATA[pid][pdgPizza]);
            cache_get_value_name_int(i, "ayamfilet", pdgDATA[pid][pdgAyamfilet]);
            Pedagang_Refresh(pid);
            Iter_Add(Pedagang, pid);
        }
        printf("[Dynamic Locker Faction] Number of Loaded: %d.", rows);
    }
}

Pedagang_Save(pid)
{
    new cQuery[512];
    format(cQuery, sizeof(cQuery), "UPDATE pedagang SET type='%d', posx='%f', posy='%f', posz='%f', interior='%d', kentang='%d', mineral='%d', snack='%d', chiken='%d', cocacola='%d', jeruk='%d', burger='%d', pizza='%d', ayamfilet='%d' WHERE id='%d'",
    pdgDATA[pid][pdgType],
    pdgDATA[pid][pdgPosX],
    pdgDATA[pid][pdgPosY],
    pdgDATA[pid][pdgPosZ],
    pdgDATA[pid][pdgInt],
    pdgDATA[pid][pdgKentang],
    pdgDATA[pid][pdgMineral],
    pdgDATA[pid][pdgSnack],
    pdgDATA[pid][pdgChicken],
    pdgDATA[pid][pdgCocacola],
    pdgDATA[pid][pdgJeruk],
    pdgDATA[pid][pdgBurger],
    pdgDATA[pid][pdgPizza],
    pdgDATA[pid][pdgAyamfilet],
    pid
    );
    return mysql_tquery(g_SQL, cQuery);
}


//Dynamic Locker System
CMD:pedagangcreate(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);
    
    new pid = Iter_Free(Pedagang), query[128];
    if(pid == -1) return Error(playerid, "You cant create more locker!");
    new type;
    if(sscanf(params, "d", type)) return Usage(playerid, "/pedagangcreate [type, 1.SAPEDAGANG]");
    
    if(type < 1 || type > 1) return Error(playerid, "Invapid type.");
    
    GetPlayerPos(playerid, pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], pdgDATA[pid][pdgPosZ]);
    pdgDATA[pid][pdgInt] = GetPlayerInterior(playerid);
    pdgDATA[pid][pdgType] = type;
    Pedagang_Refresh(pid);
    Iter_Add(Pedagang, pid);

    mysql_format(g_SQL, query, sizeof(query), "INSERT INTO pedagang SET id='%d', type='%d', posx='%f', posy='%f', posz='%f'", pid, pdgDATA[pid][pdgType], pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], pdgDATA[pid][pdgPosZ]);
    mysql_tquery(g_SQL, query, "OnLockerCreated", "i", pid);
    return 1;
}

function OnPedagangCreated(pid)
{
    Pedagang_Save(pid);
    return 1;
}

CMD:gotopedagang(playerid, params[])
{
    new pid;
    if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
        
    if(sscanf(params, "d", pid))
        return Usage(playerid, "/gotogudang [id]");
    if(!Iter_Contains(Pedagang, pid)) return Error(playerid, "The locker you specified ID of doesn't exist.");
    SetPlayerPosition(playerid, pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], pdgDATA[pid][pdgPosZ], 2.0);
    SetPlayerInterior(playerid, pdgDATA[pid][pdgInt]);
    SetPlayerVirtualWorld(playerid, 0);
    Servers(playerid, "You has teleport to locker id %d", pid);
    return 1;
}

CMD:editpedagang(playerid, params[])
{
    static
        pid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", pid, type, string))
    {
        Usage(playerid, "/editpedagang [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, type, delete");
        return 1;
    }
    if((pid < 0 || pid >= MAX_PEDAGANG))
        return Error(playerid, "You have specified an invapid ID.");
    if(!Iter_Contains(Pedagang, pid)) return Error(playerid, "The doors you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
        GetPlayerPos(playerid, pdgDATA[pid][pdgPosX], pdgDATA[pid][pdgPosY], pdgDATA[pid][pdgPosZ]);
        pdgDATA[pid][pdgInt] = GetPlayerInterior(playerid);
        Locker_Save(pid);
        Pedagang_Refresh(pid);

        SendAdminMessage(COLOR_RED, "%s has adjusted the location of locker ID: %d.", pData[playerid][pAdminname], pid);
    }
    else if(!strcmp(type, "type", true))
    {
        new tipe;

        if(sscanf(string, "d", tipe))
            return Usage(playerid, "/editlocker [id] [type] [type, 1.SAPEDAGANG]");

        if(tipe < 1 || tipe > 1)
            return Error(playerid, "You must specify at least 1 - 5.");

        pdgDATA[pid][pdgType] = tipe;
        Locker_Save(pid);
        Pedagang_Refresh(pid);

        SendAdminMessage(COLOR_RED, "%s has set locker ID: %d to type id faction %d.", pData[playerid][pAdminname], pid, tipe);
    }
    else if(!strcmp(type, "delete", true))
    {
        new query[128];
        DestroyDynamic3DTextLabel(pdgDATA[pid][pdgLabel]);
        DestroyDynamicPickup(pdgDATA[pid][pdgPickup]);
        pdgDATA[pid][pdgPosX] = 0;
        pdgDATA[pid][pdgPosY] = 0;
        pdgDATA[pid][pdgPosZ] = 0;
        pdgDATA[pid][pdgInt] = 0;
        pdgDATA[pid][pdgLabel] = Text3D: INVALID_3DTEXT_ID;
        pdgDATA[pid][pdgPickup] = -1;
        Iter_Remove(Pedagang, pid);
        mysql_format(g_SQL, query, sizeof(query), "DELETE FROM pedagang WHERE id=%d", pid);
        mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_RED, "%s has delete locker ID: %d.", pData[playerid][pAdminname], pid);
    }
    return 1;
}
