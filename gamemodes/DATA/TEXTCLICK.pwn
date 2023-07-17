public OnPlayerClickDynamicTextdraw(playerid, PlayerText:playertextid)
{
	//KONTAK DI HP
	if(playertextid == DAFTARKONTAK[playerid])
	{
	    ShowContacts(playerid);
	}
	if(playertextid == TWEET[playerid])
	{
		new string[555];
		format(string, sizeof(string), "Post Twitter\nUbah Twitter({0099ff}%s{ffffff})", pData[playerid][pTwittername]);
		ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Executive - Twitter", string, "Pilih", "Tutup");
		SimpanHp(playerid);
	}
	//ATM SYSTEM
	if(playertextid == AtmTD[playerid][7])
	{
	    for(new i = 0; i < 76; i++)
		{
			PlayerTextDrawHide(playerid, AtmTD[playerid][i]);
		}
		CancelSelectTextDraw(playerid);
		pData[playerid][pInputMoney] = 0;
	}
	if(playertextid == AtmTD[playerid][43])//input tf
	{
	    ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, "Executive - Transfer", "Mohon masukan jumlah uang yang ingin di transfer:", "Input", "Batal");
	}
	if(playertextid == AtmTD[playerid][53])//tombol input withdepo
	{
	    ShowPlayerDialog(playerid, DIALOG_WITHDEPO, DIALOG_STYLE_INPUT, "Executive - FLEECA", "Mohon masukan jumlah uang yang ingin di input:", "Input", "Batal");
	}
	if(playertextid == AtmTD[playerid][58])//withdraw
	{
	    if(pData[playerid][pInputMoney] == 0) return ErrorMsg(playerid, "Anda belum menginput jumlah yang akan ditarik");
	    if(pData[playerid][pInputMoney] > pData[playerid][pBankMoney]) return ErrorMsg(playerid, "Anda tidak memiliki uang sebanyak itu di bank.");
		if(pData[playerid][pInputMoney] < 1) return ErrorMsg(playerid, "Angka yang anda masukan tidak valid!");
	    new query[128], lstr[512];
		pData[playerid][pBankMoney] = (pData[playerid][pBankMoney] - pData[playerid][pInputMoney]);
		GivePlayerMoneyEx(playerid, pData[playerid][pInputMoney]);
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=%d,money=%d WHERE reg_id=%d", pData[playerid][pBankMoney], pData[playerid][pMoney], pData[playerid][pID]);
		mysql_tquery(g_SQL, query);
		format(lstr, sizeof(lstr), "Anda berhasil menarik uang sejumlah %s dari rekening anda.", FormatMoney(pData[playerid][pInputMoney]));
		SuccesMsg(playerid, lstr);
		new AtmInfo[500];
		format(AtmInfo,1000,"%s", FormatMoney(pData[playerid][pBankMoney]));
	 	PlayerTextDrawSetString(playerid, AtmTD[playerid][32], AtmInfo);
   		format(AtmInfo,1000,"%s", FormatMoney(pData[playerid][pMoney]));
   		PlayerTextDrawSetString(playerid, AtmTD[playerid][31], AtmInfo);
	}
	if(playertextid == AtmTD[playerid][62])//deposit
	{
	    if(pData[playerid][pInputMoney] == 0) return ErrorMsg(playerid, "Anda belum menginput jumlah yang akan disimpan");
	    if(pData[playerid][pInputMoney] > pData[playerid][pMoney]) return ErrorMsg(playerid, "Anda tidak memiliki uang sebanyak itu di dompet.");
		if(pData[playerid][pInputMoney] < 1) return ErrorMsg(playerid, "Angka yang anda masukan tidak valid!");
	    new query[128], lstr[512];
		pData[playerid][pBankMoney] = (pData[playerid][pBankMoney] + pData[playerid][pInputMoney]);
		GivePlayerMoneyEx(playerid, -pData[playerid][pInputMoney]);
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=%d,money=%d WHERE reg_id=%d", pData[playerid][pBankMoney], pData[playerid][pMoney], pData[playerid][pID]);
		mysql_tquery(g_SQL, query);
		format(lstr, sizeof(lstr), "Anda berhasil menyimpan uang sejumlah %s kedalam rekening anda.", FormatMoney(pData[playerid][pInputMoney]));
		SuccesMsg(playerid, lstr);
		new AtmInfo[500];
		format(AtmInfo,1000,"%s", FormatMoney(pData[playerid][pBankMoney]));
	 	PlayerTextDrawSetString(playerid, AtmTD[playerid][32], AtmInfo);
   		format(AtmInfo,1000,"%s", FormatMoney(pData[playerid][pMoney]));
   		PlayerTextDrawSetString(playerid, AtmTD[playerid][31], AtmInfo);
	}
	//PHONE SYSTEM
	if(playertextid == TRANSFER[playerid])
	{
		ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, "Executive - Transfer", "Mohon masukan jumlah uang yang ingin di transfer:", "Transfer", "Batal");
	}
	if(playertextid == GPAY[playerid])
	{
		ShowPlayerDialog(playerid, DIALOG_GOPAY, DIALOG_STYLE_INPUT, "GoJek App - GoPay", "Masukan jumlah uang yang ingin anda bayar", "Input", "Kembali");
	}
	if(playertextid == GTOPUP[playerid])
	{
	    ShowPlayerDialog(playerid, DIALOG_GOTOPUP, DIALOG_STYLE_INPUT, "GoJek App - TopUp", "Masukan jumlah gopay yang ingin anda topup", "Input", "Kembali");
	}
	if(playertextid == GRIDE[playerid])
	{
	    ShowPlayerDialog(playerid, DIALOG_GOJEK, DIALOG_STYLE_INPUT, "GoJek App - Pesan GoJek", "Hai, kamu akan memesan GoJek. Mau kemana hari ini?", "Pesan", "Kembali");
	}
	if(playertextid == GCAR[playerid])
	{
	    ShowPlayerDialog(playerid, DIALOG_GOCAR, DIALOG_STYLE_INPUT, "GoJek App - Pesan GoCar", "Hai, kamu akan memesan GoCar. Mau kemana hari ini?", "Pesan", "Kembali");
	}
	if(playertextid == GFOOD[playerid])
	{
	    ShowPlayerDialog(playerid, DIALOG_GOFOOD, DIALOG_STYLE_INPUT, "GoJek App - Pesan GoFood", "Hai, kamu akan memesan GoFood. Mau makan apa hari ini?", "Pesan", "Kembali");
	}
	if(playertextid == PLAYSTOREAPP[playerid][15])
	{
	    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
	    if(PlayerInfo[playerid][pInstallMap] == 1) return ErrorMsg(playerid,"Lu udah punya google map blok!");
		ShowProgressbar(playerid, "Menginstall Spotify..", 10);
		SetTimerEx("DownloadSpotify", 10000, false, "d", playerid);
	}
	if(playertextid == PLAYSTOREAPP[playerid][16])
	{
	    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
	    if(PlayerInfo[playerid][pInstallTweet] == 1) return ErrorMsg(playerid,"Lu udah punya twitter blok!");
		ShowProgressbar(playerid, "Menginstall Twitter..", 10);
		SetTimerEx("DownloadTweet", 10000, false, "d", playerid);
	}
	if(playertextid == PLAYSTOREAPP[playerid][17])
	{
	    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
	    if(PlayerInfo[playerid][pInstallBank] == 1) return ErrorMsg(playerid,"Lu udah punya mbanking blok!");
		ShowProgressbar(playerid, "Menginstall Mbanking..", 10);
		SetTimerEx("DownloadBank", 10000, false, "d", playerid);
	}
	if(playertextid == PLAYSTOREAPP[playerid][18])
	{
	    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
	    if(PlayerInfo[playerid][pInstallDweb] == 1) return ErrorMsg(playerid,"Lu udah punya darkweb blok!");
		ShowProgressbar(playerid, "Menginstall DarkWeb..", 10);
		SetTimerEx("DownloadDarkWeb", 10000, false, "d", playerid);
	}
	if(playertextid == PLAYSTOREAPP[playerid][19])
	{
	    if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
	    if(PlayerInfo[playerid][pInstallGojek] == 1) return ErrorMsg(playerid,"Lu udah punya Gojek blok!");
		ShowProgressbar(playerid, "Menginstall Gojek..", 10);
		SetTimerEx("DownloadGojek", 10000, false, "d", playerid);
	}
	//REGISTER
    if(playertextid == BuatKarakter[playerid][12])
	{
	    if(pData[playerid][pMasukinNama] == 0) return ErrorMsg(playerid, "Anda belum memasukkan nama karakter");
	    if(pData[playerid][pAge] == 0) return ErrorMsg(playerid, "Anda belum memasukkan tanggal lahir");
	    if(pData[playerid][pTinggi] == 0) return ErrorMsg(playerid, "Anda belum memasukkan tinggi badan");
	    if(pData[playerid][pBerat] == 0) return ErrorMsg(playerid, "Anda belum memasukkan berat badan");
	    if(pData[playerid][pGender] < 1) return ErrorMsg(playerid, "Anda belum memilih jenis kelamin");
	    if(pData[playerid][pAge] == 0) return ErrorMsg(playerid, "Anda belum memasukkan tanggal lahir");
	    {
		    SuccesMsg(playerid,"Registrasi Berhasil! Terima kasih telah bergabung dengan Executive ><!");
		    for(new i = 0; i < 32; i++)
			{
				PlayerTextDrawHide(playerid, BuatKarakter[playerid][i]);
			}
			CancelSelectTextDraw(playerid);
		    if(pData[playerid][pGender] == 1)
		    {
		        pData[playerid][pSkin] = 17;
				SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1750.5931,-2515.8118,13.5969, 0, 0, 0, 0, 0, 0);
				SpawnPlayer(playerid);
			}
			else
			{
			    pData[playerid][pSkin] = 93;
				SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1750.5931,-2515.8118,13.5969, 0, 0, 0, 0, 0, 0);
				SpawnPlayer(playerid);
			}
		}
	}
	if(playertextid == BuatKarakter[playerid][20])
	{
	    PlayerTextDrawHide(playerid, BuatKarakter[playerid][20]);
	    PlayerTextDrawColor(playerid, BuatKarakter[playerid][20], COLOR_BLUE);
	    PlayerTextDrawShow(playerid, BuatKarakter[playerid][20]);
	    PlayerTextDrawHide(playerid, BuatKarakter[playerid][22]);
	    PlayerTextDrawColor(playerid, BuatKarakter[playerid][22], -1);
	    PlayerTextDrawShow(playerid, BuatKarakter[playerid][22]);
	    pData[playerid][pGender] = 1;
	}
	if(playertextid == BuatKarakter[playerid][22])
	{
	    PlayerTextDrawHide(playerid, BuatKarakter[playerid][20]);
	    PlayerTextDrawColor(playerid, BuatKarakter[playerid][20], -1);
	    PlayerTextDrawShow(playerid, BuatKarakter[playerid][20]);
	    PlayerTextDrawHide(playerid, BuatKarakter[playerid][22]);
	    PlayerTextDrawColor(playerid, BuatKarakter[playerid][22], COLOR_BLUE);
	    PlayerTextDrawShow(playerid, BuatKarakter[playerid][22]);
	    pData[playerid][pGender] = 2;
	}
	if(playertextid == BuatKarakter[playerid][24])
	{
	    ShowPlayerDialog(playerid, DIALOG_MAKE_CHAR, DIALOG_STYLE_INPUT, "Executive - {ffffff}Pembuatan Karakter", "Masukan nama baru untuk karakter anda\n\nContoh: Atsuko_Tadashi, Javier_Cooper.", "Oke", "Keluar");
	}
	if(playertextid == BuatKarakter[playerid][25])
	{
	    ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Executive - {ffffff}Tanggal Lahir", "Masukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Oke", "Batal");
	}
	if(playertextid == BuatKarakter[playerid][26])
	{
	    ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "Executive - {ffffff}Tinggi Badan", "Masukan tinggi badan minimal 110 cm dan maksimal 200 cm", "Oke", "Batal");
	}
	if(playertextid == BuatKarakter[playerid][27])
	{
        ShowPlayerDialog(playerid, DIALOG_BERAT, DIALOG_STYLE_INPUT, "Executive - {ffffff}Berat Badan", "Masukan berat badan minimal 40 kg dan maksimal 150 kg", "Oke", "Batal");
	}
	//PilihKarakter
	if(playertextid == RegisterTD[playerid][2])
	{
	    KickEx(playerid);
	}
	if(playertextid == RegisterTD[playerid][5])
	{
	    if(pData[playerid][pilihkarakter] == 0) return ErrorMsg(playerid, "Anda belum memilih karakter yang akan dimainkan");
		new cQuery[256];
		mysql_format(g_SQL, cQuery, sizeof(cQuery), "SELECT * FROM `players` WHERE `username` = '%s' LIMIT 1;", PlayerChar[playerid][pData[playerid][pChar]]);
		mysql_tquery(g_SQL, cQuery, "AssignPlayerData", "d", playerid);
   	 	for(new idx; idx < 35; idx++) PlayerTextDrawHide(playerid, RegisterTD[playerid][idx]);
   	 	CancelSelectTextDraw(playerid);
   	 	pData[playerid][pilihkarakter] = 0;
	}
	if(playertextid == RegisterTD[playerid][28])
	{
        CheckPlayerChar(playerid);
	}
	//Taruh di OnPlayerClickTextDraw
	for(new i = 0; i < MAX_INVENTORY; i++)
	{
		if(playertextid == MODELTD[playerid][i])
		{
			if(InventoryData[playerid][i][invExists])
			{
			    MenuStore_UnselectRow(playerid);
				MenuStore_SelectRow(playerid, i);
			    new name[48];
            	strunpack(name, InventoryData[playerid][pData[playerid][pSelectItem]][invItem]);
			}
		}
	}
	if(playertextid == INVINFO[playerid][2])
	{
		new id = pData[playerid][pSelectItem];

		if(id == -1)
		{
		    ErrorMsg(playerid,"[Inventory] Tidak Ada Barang Di Slot Tersebut");
		}
		else
		{
		    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
			new string[64];
		    strunpack(string, InventoryData[playerid][id][invItem]);

		    if(!PlayerHasItem(playerid, string))
		    {
		   		ErrorMsg(playerid,"[Inventory] Kamu Tidak Memiliki Barang Tersebut");
                Inventory_Show(playerid);
			}
			else
			{
				CallLocalFunction("OnPlayerUseItem", "dds", playerid, id, string);
			}
		}
	}
	else if(playertextid == INVINFO[playerid][5])
	{
		Inventory_Close(playerid);
	}
	else if(playertextid == INVINFO[playerid][4])
	{
		InfoMsg(playerid, "Fitur ini sedang dalam pengembangan");
	}
	else if(playertextid == INVINFO[playerid][3])
	{
		new id = pData[playerid][pSelectItem], str[500], count = 0;
		if(id == -1)
		{
			ErrorMsg(playerid,"[Inventory] Pilih Barang Terlebih Dahulu");
		}
		else
		{
		    if (pData[playerid][pGiveAmount] < 1)
				return ErrorMsg(playerid,"[Inventory] Masukan Jumlah Terlebih Dahulu");

            foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 5) && i != playerid)
			{
				format(str, sizeof(str), "Kantong - %s (%d)\n", pData[i][pName], i);
				SetPlayerListitemValue(playerid, count++, i);
			}
			if(!count) ErrorMsg(playerid, "Tidak ada player lain didekat mu!");
			else ShowPlayerDialog(playerid, DIALOG_GIVE, DIALOG_STYLE_LIST, "Executive - Inventory", str, "Pilih", "Tutup");
		}
	}
	else if(playertextid == INVINFO[playerid][1])
	{
		ShowPlayerDialog(playerid, DIALOG_AMOUNT, DIALOG_STYLE_INPUT, "Inventory - Jumlah", "Masukan Jumlah:", "Berikan", "Batal");
	}
    if(playertextid == IDCard[playerid][25])
    {
        for(new txd; txd < 26; txd++)
        {
            PlayerTextDrawHide(playerid, IDCard[playerid][txd]);
            CancelSelectTextDraw(playerid);
        }           
    }
    if(playertextid == LICCard[playerid][11])
    {
        for(new txd; txd < 26; txd++)
        {
            PlayerTextDrawHide(playerid, LICCard[playerid][txd]);
            CancelSelectTextDraw(playerid);
        }           
    }
    //===============================================================//
    return 1;
}

