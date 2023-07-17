#define MAX_BILLS 4500

enum billing
{
    bilType,
    bilName[230],
    bilTarget,
    bilammount,
    bilWaktu
}

new bilData[MAX_BILLS][billing],
    Iterator:tagihan<MAX_BILLS>;

Billing_Save(id)
{
    new bQuery[3400];
    mysql_format(g_SQL, bQuery, sizeof(bQuery), "UPDATE `bill` SET `type`='%d', `name`='%s', `target`='%d', `ammount`='%d', `waktu`='%d' WHERE `bid`='%d'", 
    bilData[id][bilType], 
    bilData[id][bilName],
    bilData[id][bilTarget],
    bilData[id][bilammount],
    bilData[id][bilWaktu],
    id);
    return mysql_tquery(g_SQL, bQuery);
}
//callback
function LoadBill()
{
    new rows = cache_num_rows();
    if(rows)
    {
        new tagid;
        for(new i; i < rows; i++)
        {
            cache_get_value_name_int(i, "bid", tagid);
            cache_get_value_name_int(i, "type", bilData[tagid][bilType]);
            cache_get_value_name(i, "name", bilData[tagid][bilName], 230);
            cache_get_value_name_int(i, "target", bilData[tagid][bilTarget]);
            cache_get_value_name_int(i, "ammount", bilData[tagid][bilammount]);
            cache_get_value_name_int(i, "waktu", bilData[tagid][bilWaktu]);

            Iter_Add(tagihan, tagid);
        }
        printf("[BILL] Number of billing loaded: %d", rows);
    }
    if(!rows)
    {
        print("Nothing billing Loaded");
    }
}
//cmd
CMD:givebill(playerid, params[])
{
    if(pData[playerid][pFaction] == 1 || pData[playerid][pFaction] == 2 || pData[playerid][pFaction] == 3 || pData[playerid][pFaction] == 5 || pData[playerid][pFaction] == 6)
    {
        new biid = Iter_Free(tagihan);
        new waktu;
        new id, ammount, namebil[128];
        if(biid == -1) return ErrorMsg(playerid, "Kamu tidak bisa memberi tagihan lagi");
        if(sscanf(params, "ddds[128]", id, ammount, waktu, namebil)) return Usage(playerid, "/givebill [playerid][jumlah][bataswaktu(hari)][keterangan]");
        if(ammount < 1 || ammount > 500000) return ErrorMsg(playerid, "Ammount is only can $1-$500000");
        if(waktu > 10) return ErrorMsg(playerid, "Tidak boleh lebih dari 10 hari");
        if(1 > strlen(namebil) < 128) return ErrorMsg(playerid, "Tidak bisa kuarng dari 1 dan lebih dari 128 karakter");

        new bill[3400];
        bilData[biid][bilType] = pData[playerid][pFaction];
        bilData[biid][bilWaktu] = gettime() + (waktu * 86400);
        format(bilData[biid][bilName], 128, namebil);
        bilData[biid][bilTarget] = pData[id][pID];
        bilData[biid][bilammount] = ammount;
        Iter_Add(tagihan, biid);
        mysql_format(g_SQL, bill, sizeof(bill), "INSERT INTO `bill` (`bid`,`type`,`name`,`target`,`ammount`,`waktu`) VALUES ('%d','%d','%s','%d','%d','%d')",
        biid,
        bilData[biid][bilType],
        bilData[biid][bilName],
        bilData[biid][bilTarget],
        bilData[biid][bilammount],
        bilData[biid][bilWaktu]);
        mysql_tquery(g_SQL, bill);
        InfoMsg(id, "Kamu menerima invoice");
    }
    return 1;
}
CMD:blacklistbill(playerid)
{
    new header[256], frak[256], count = 0;
    new bool:status = false;
    format(header, sizeof(header), "Nama\n");
    foreach(new p : Player)
    {
        if(pData[p][BlacklistBill] > 0)
        {
            if(pData[p][BlacklistBill] == pData[playerid][pFaction])
            {
                format(header, sizeof(header), "%s%s\n", header, pData[p][pName]);
                ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "List Blacklist Bill", header, "Tutup", "");
            }
            else
            {
                ErrorMsg(playerid, "Tidak ada yang di blacklist dari fraksi mu");
            }
        }
        else
        {
            ErrorMsg(playerid, "Tidak ada yang di blacklist dari fraksi mu");
        }
    }
    return 1;
}
CMD:mybillanjaykontol(playerid)
{
    new header[256], frak[256], count = 0;
    new bool:status = false;
    format(header, sizeof(header), "Nama Bill\tJumlah\tFraksi\tWaktu Jatuh Tempo\n");
    foreach(new i: tagihan)
    {
        if(i != -1)
        {
            if(bilData[i][bilTarget] == pData[playerid][pID])
            {
                if(bilData[i][bilType] == 1)
                {
                    frak = "Kepolisian Executive";
                }
                else if(bilData[i][bilType] == 2)
                {
                    frak = "Pemerintahan Executive";
                }
                else if(bilData[i][bilType] == 3)
                {
                    frak = "Petugas Medis Executive";
                }
                else if(bilData[i][bilType] == 5)
                {
                    frak = "Pedagang Executive";
                }
                else if(bilData[i][bilType] == 6)
                {
                    frak = "Gojek";
                }
                format(header, sizeof(header), "%s%s\t{00ff00}%s\t%s\t%s\n", header, bilData[i][bilName], FormatMoney(bilData[i][bilammount]), frak, ReturnTimelapse(gettime(), bilData[i][bilWaktu]));
                count++;
                status = true;
            }
        }
    }
    if(status)
    {
        ShowPlayerDialog(playerid, DIALOG_PAYBILL, DIALOG_STYLE_TABLIST_HEADERS, "My invoice", header, "Bayar", "G dlu");
    }
    else
    {
        Error(playerid, "Kamu tidak punya tagihan");
    }

    return 1;
}
/*CMD:paybill(playerid, params[])
{
    new bilid;
    if(sscanf(params, "d", bilid)) return Usage(playerid, "/paybill <Id Billing> | Check /mybill");
    mysql_format(g_SQL, bt, sizeof(bt), "SELECT * FROM `bill` WHERE `bid`='%d'", bilid);
    mysql_tquery(g_SQL, bilid, "CheckBill1", "dd", playerid, bilid);
    GivePlayerMoneyEx(playerid, -bilData[bilid][bilammount]);
    SendClientMessageEx(playerid, -1, "{800080}[SUCCESS] {ffffff}You paid bill %s for %s", bilData[bilid][bilName], FormatMoney(bilData[bilid][bilammount]));
    new billdel[256];
    mysql_format(g_SQL, billdel, sizeof(billdel), "DELETE FROM `bill` WHERE `bid`='%d'", bilData[bilid][bilID]);
    mysql_tquery(g_SQL, billdel);
    return 1;
}*/

task BilUpdate[1000]()
{
    foreach(new i : tagihan)
    {
        if(i != -1)
        {
            if(bilData[i][bilWaktu] > 0)
            {
                bilData[i][bilWaktu] --;
                Billing_Save(i);
            }
            else if (bilData[i][bilWaktu] == 0)
            {
                new player = bilData[i][bilTarget];
                if(IsPlayerConnected(player))
                {
                    pData[player][BlacklistBill] = bilData[i][bilType];
                    SendFactionMessage(bilData[i][bilType], -1, "Seseorang telah jatuh tempo dan di blacklist cek /billblacklist");
                }
                else
                {
                    new query[256];
                    new bt[256];
                    mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET blacklistbill='%d' WHERE req_id='%d'", bilData[i][bilType], player);
                    mysql_tquery(g_SQL, query);
                    Iter_Remove(tagihan, i);
                    mysql_format(g_SQL, bt, sizeof(bt), "DELETE FROM `bill` WHERE `bid`='%d'", i);
                    mysql_tquery(g_SQL, bt);
                    SendFactionMessage(bilData[i][bilType], -1, "Seseorang telah jatuh tempo dan di blacklist cek /blacklistbill");
                }
            }
        }
    }
}
