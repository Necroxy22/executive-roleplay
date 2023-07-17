//Enums
#define MAX_REPORTS (50)

enum reportData {
    bool:rExists,
    rType,
    rPlayer,
    rText[128 char]
};
new ReportData[MAX_REPORTS][reportData];


Report_GetCount(playerid)
{
    new count;

    for (new i = 0; i != MAX_REPORTS; i ++)
    {
        if(ReportData[i][rExists] && ReportData[i][rPlayer] == playerid)
        {
			count++;
        }
    }
    return count;
}

Report_Clear(playerid)
{
    for (new i = 0; i != MAX_REPORTS; i ++)
    {
        if(ReportData[i][rExists] && ReportData[i][rPlayer] == playerid)
        {
            Report_Remove(i);
        }
    }
}

Report_Add(playerid, const text[], type = 1)
{
    for (new i = 0; i != MAX_REPORTS; i ++)
    {
        if(!ReportData[i][rExists])
        {
            ReportData[i][rExists] = true;
            ReportData[i][rType] = type;
            ReportData[i][rPlayer] = playerid;

            strpack(ReportData[i][rText], text, 128 char);
            return i;
        }
    }
    return -1;
}

Report_Remove(reportid)
{
    if(reportid != -1 && ReportData[reportid][rExists] == true)
    {
        ReportData[reportid][rExists] = false;
        ReportData[reportid][rPlayer] = INVALID_PLAYER_ID;
    }
    return 1;
}

CMD:report(playerid, params[])
{
    new reportid = -1;
	new lstr[500];
	format(lstr,sizeof(lstr), "Kamu harus menunggu ~y~%d detik ~w~untuk melakukan laporan.", pData[playerid][pReportTime] - gettime());
    if(isnull(params))
    {
        InfoMsg(playerid, "/report [alasan]");
        InfoMsg(playerid, "~y~Harap gunakan ini untuk melapor dalam IC/OOC.");
        return 1;
    }
    if(Report_GetCount(playerid) > 3)
        return ErrorMsg(playerid, "Kamu telah memiliki 3 Laporan aktif!");

    if(pData[playerid][pReportTime] >= gettime())
        return ErrorMsg(playerid, lstr);

    if((reportid = Report_Add(playerid, params)) != -1)
    {
        new str[500];
        format(str, sizeof(str), "~y~[Laporan Anda]: ~w~%s", params);
        SuccesMsg(playerid, str);
        SendStaffMessage(COLOR_ARWIN, "[Report: #%d] "WHITE_E"%s (ID: %d) reported: %s", reportid, pData[playerid][pName], playerid, params);
        pData[playerid][pReportTime] = gettime() + 180;
    }
    else ErrorMsg(playerid, "Laporan penuh, harap tunggu.");
    return 1;
}

CMD:ar(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);

    if(isnull(params))
        return InfoMsg(playerid, "/ar [report id] (/reports for a list)");

    new
        reportid = strval(params);
        
    if((reportid < 0 || reportid >= MAX_REPORTS) || !ReportData[reportid][rExists])
        return Error(playerid, "Invalid report ID. Reports list from 0 to %d.", MAX_REPORTS);

    SendStaffMessage(COLOR_RED, "%s has accepted %s(%d) report.", pData[playerid][pAdminname], pData[ReportData[reportid][rPlayer]][pName], ReportData[reportid][rPlayer]);
    Servers(ReportData[reportid][rPlayer], "ACCEPT REPORT: {FF0000}%s {FFFFFF}accept your report.", pData[playerid][pAdminname]);
    Report_Remove(reportid);
    return 1;
}

CMD:dr(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return Error(playerid, "Kamu tidak memiliki izin!");

    new reportid, msg[32];
    if(sscanf(params,"ds[32]", reportid, msg))
        return Usage(playerid, "/dr [report id] [reason] (/reports for a list)");

    if((reportid < 0 || reportid >= MAX_REPORTS) || !ReportData[reportid][rExists])
        return Error(playerid, "ID Report tidak valid, listitem 0 sampai %d.", MAX_REPORTS);

    SendStaffMessage(COLOR_RED, "%s has denied %s(%d) report.", pData[playerid][pAdminname], pData[ReportData[reportid][rPlayer]][pName], ReportData[reportid][rPlayer]);
    Servers(ReportData[reportid][rPlayer], "DENY REPORT: {FF0000}%s {FFFFFF}denied your report: %s.", pData[playerid][pAdminname], msg);

    Report_Remove(reportid);
    return 1;
}

CMD:reports(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
	new gstr[1024], mstr[128], lstr[512];
    strcat(gstr,"#ID\tDetail Pemain\tLaporan\n",sizeof(gstr));

    for (new i = 0; i != MAX_REPORTS; i ++)
    {
        if(ReportData[i][rExists])
        {
            strunpack(mstr, ReportData[i][rText]);

            if(strlen(mstr) > 32)
            {
                format(lstr,sizeof(lstr), "#%d\t%s [%s] (%d)\t%.32s ...\n", i, pData[ReportData[i][rPlayer]][pName], pData[ReportData[i][rPlayer]][pUCP], ReportData[i][rPlayer], mstr);
            }
            else
            {
                format(lstr,sizeof(lstr), "#%d\t%s [%s] (%d)\t%s\n", i, pData[ReportData[i][rPlayer]][pName], pData[ReportData[i][rPlayer]][pUCP], ReportData[i][rPlayer], mstr);
            }
            strcat(gstr,lstr,sizeof(gstr));
            ShowPlayerDialog(playerid, DIALOG_REPORTS, DIALOG_STYLE_TABLIST_HEADERS,"Kota Executive - Daftar Laporan",gstr,"Pilih","Tutup");
        }
        else
        {
            return ErrorMsg(playerid, "Tidak ada Pertanyaan yang aktif.");
        }     
    }
    return 1;
}

CMD:clearreports(playerid, params[])
{
    if(pData[playerid][pAdmin] < 3)
            return PermissionError(playerid);
    new
        count;

    for (new i = 0; i != MAX_REPORTS; i ++)
    {
        if(ReportData[i][rExists]) {
            Report_Remove(i);
            count++;
        }
    }
    if(!count)
        return Error(playerid, "There are no active reports to display.");
            
    SendStaffMessage(COLOR_RED, "%s has removed all reports on the server.", pData[playerid][pAdminname]);
    return 1;
}
