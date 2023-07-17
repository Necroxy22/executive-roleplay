//Enums
#define MAX_ASKS (50)

enum askData {
    bool:askExists,
    askType,
    askPlayer,
    askText[128 char]
};
new AskData[MAX_ASKS][askData];


Ask_GetCount(playerid)
{
    new count;

    for (new i = 0; i != MAX_ASKS; i ++)
    {
        if(AskData[i][askExists] && AskData[i][askPlayer] == playerid)
        {
			count++;
        }
    }
    return count;
}

Ask_Clear(playerid)
{
    for (new i = 0; i != MAX_ASKS; i ++)
    {
        if(AskData[i][askExists] && AskData[i][askPlayer] == playerid)
        {
            Ask_Remove(i);
        }
    }
}

Ask_Add(playerid, const text[], type = 1)
{
    for (new i = 0; i != MAX_ASKS; i ++)
    {
        if(!AskData[i][askExists])
        {
            AskData[i][askExists] = true;
            AskData[i][askType] = type;
            AskData[i][askPlayer] = playerid;

            strpack(AskData[i][askText], text, 128 char);
            return i;
        }
    }
    return -1;
}

Ask_Remove(reportid)
{
    if(reportid != -1 && AskData[reportid][askExists] == true)
    {
        AskData[reportid][askExists] = false;
        AskData[reportid][askPlayer] = INVALID_PLAYER_ID;
    }
    return 1;
}

CMD:ask(playerid, params[])
{
    new reportid = -1;

    if(isnull(params))
    {
        InfoMsg(playerid, "/ask [pertanyaan]");
        InfoMsg(playerid, "~y~Command ini khusus untuk pertanyaan.");
        return 1;
    }
    if(Ask_GetCount(playerid) > 1)
        return ErrorMsg(playerid, "Kamu sudah memiliki 1 Pertanyaan!");

	new lstr[500];
	format(lstr,sizeof(lstr), "Mohon tunggu ~y~%d detik ~w~untuk mengajukan pertanyaan.", pData[playerid][pAskTime] - gettime());
    if(pData[playerid][pAskTime] >= gettime())
        return ErrorMsg(playerid, lstr);

    if((reportid = Ask_Add(playerid, params)) != -1)
    {
        new str[500];
        format(str, sizeof(str), "~y~[Pertanyaan Anda]: ~w~%s", params);
        SuccesMsg(playerid, str);
        SendStaffMessage(COLOR_RED, "{7fff00}[PERTANYAAN: #%d] "WHITE_E"%s (ID: %d) QUESTION: %s", reportid, pData[playerid][pName], playerid, params);
        pData[playerid][pReportTime] = gettime() + 180;
    }
    else ErrorMsg(playerid, "Pertanyaan sedang penuh!");
    return 1;
}

CMD:ans(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return ErrorMsg(playerid, "Kamu tidak memiliki hak untuk menggunakan ini!");

    new reportid, msg[32];
    if(sscanf(params,"ds[32]", reportid, msg))
        return InfoMsg(playerid, "/ans [ask id] [jawaban] (/asks for a list)");

    if((reportid < 0 || reportid >= MAX_ASKS) || !AskData[reportid][askExists])
        return Error(playerid, "ID Ask tidak valid, Listitem dari 0 sampai %d.", MAX_ASKS);

    SendStaffMessage(COLOR_RED, "%s telah menjawab pertanyaan %s(%d).", pData[playerid][pAdminname], pData[AskData[reportid][askPlayer]][pName], AskData[reportid][askPlayer]);
    Servers(AskData[reportid][askPlayer], "ANSWER: {FF0000}%s {FFFFFF}: %s.", pData[playerid][pAdminname], msg);

    Ask_Remove(reportid);
    return 1;
}

CMD:asks(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
	new gstr[1024], mstr[128], lstr[512];
    strcat(gstr,"#ID\tDetail Pemain\tPertanyaan \n",sizeof(gstr));

    for (new i = 0; i != MAX_ASKS; i ++)
    {
        if(!AskData[i][askExists])
           return Error(playerid, "Tidak ada Pertanyaan yang aktif.");
       
        strunpack(mstr, AskData[i][askText]);

        if(strlen(mstr) > 32)
            format(lstr,sizeof(lstr), "#%d\t%s [%s] (%d)\t%.32s ...\n", i, pData[AskData[i][askPlayer]][pName], pData[AskData[i][askPlayer]][pUCP], AskData[i][askPlayer], mstr);
        else
            format(lstr,sizeof(lstr), "#%d\t%s [%s] (%d)\t%s\n", i, pData[AskData[i][askPlayer]][pName], pData[AskData[i][askPlayer]][pUCP], AskData[i][askPlayer], mstr);

        strcat(gstr,lstr,sizeof(gstr));
        ShowPlayerDialog(playerid, DIALOG_ASKS, DIALOG_STYLE_TABLIST_HEADERS,"Kota Executive - Daftar Pertanyaan",gstr,"Pilih","Tutup");
    }
    return 1;
}

CMD:clearask(playerid, params[])
{
    if(pData[playerid][pAdmin] < 3)
            return PermissionError(playerid);
    new
        count;

    for (new i = 0; i != MAX_ASKS; i ++)
    {
        if(AskData[i][askExists]) {
            Ask_Remove(i);
            count++;
        }
    }
    if(!count)
        return Error(playerid, "Tidak ada Pertanyaan yang aktif.");
            
    SendStaffMessage(COLOR_RED, "%s has removed all asks on the server.", pData[playerid][pAdminname]);
    return 1;
}
