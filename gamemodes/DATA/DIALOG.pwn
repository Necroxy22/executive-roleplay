//----------[ Dialog Login Register]----------
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	printf("[OnDialogResponse]: %s(%d) has used dialog id: %d Listitem: %d", pData[playerid][pUCP], playerid, dialogid, listitem);
	if(dialogid == DIALOG_LOGIN)
    {
        if(!response) return Kick(playerid);

		new hashed_pass[65];
		SHA256_PassHash(inputtext, pData[playerid][pSalt], hashed_pass, 65);

		if (strcmp(hashed_pass, pData[playerid][pPassword]) == 0)
		{
			new query1[256];
			//mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `players` WHERE `username` = '%e' LIMIT 1", pData[playerid][pName]);
			//mysql_pquery(g_SQL, query, "AssignPlayerData", "d", playerid);
			for(new idx; idx < 35; idx++) PlayerTextDrawShow(playerid, RegisterTD[playerid][idx]);
			SelectTextDraw(playerid, COLOR_BLUE);
			new AtmInfo[500];
			format(AtmInfo,1000,"%s", pData[playerid][pUCP]);
	    	PlayerTextDrawSetString(playerid, RegisterTD[playerid][23], AtmInfo);
			printf("[LOGIN] %s(%d) berhasil login dengan password(%s)", pData[playerid][pUCP], playerid, inputtext);
			SuccesMsg(playerid, "Silahkan pilih karakter yang akan anda mainkan");

			mysql_format(g_SQL, query1, sizeof(query1), "INSERT INTO loglogin (username,reg_id,password,time) VALUES('%s','%d','%s',CURRENT_TIMESTAMP())", pData[playerid][pUCP], pData[playerid][pID], inputtext);
			mysql_tquery(g_SQL, query1);

		}
		else
		{
			pData[playerid][LoginAttempts]++;

			if (pData[playerid][LoginAttempts] >= 3)
			{
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "UCP - Login", "Kamu Telah Salah Memasukkan Password Sebanyak (3 kali).", "Okay", "");
				KickEx(playerid);
			}
			else 
			{
				new lstring[512];
				format(lstring, sizeof lstring, "Selamat datang kembali di server Executive Roleplay\n\nUsername: %s\nVersion: Executive v1.0b\n{FFFF00}(Silahkan Masukkan Kata Sandi Anda Di Bawah Ini:)", pData[playerid][pUCP]);
				ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login - Executive", lstring, "Masuk", "Keluar");
				ErrorMsg(playerid, "Password yang anda masukan salah!");
			}
		}
        return 1;
    }
	if(dialogid == DIALOG_REGISTER)
    {
		if (!response) return Kick(playerid);
	
		if (strlen(inputtext) <= 5) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration Executive", "Kata sandi minimal 5 Karakter!\nMohon isi Password dibawah ini:", "Register", "Tolak");
		
		if(!IsValidPassword(inputtext))
		{
			Error(playerid, "Sandi valid : A-Z, a-z, 0-9, _, [ ], ( )");
			ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration Executive", "Kata sandi yang anda gunakan mengandung karakter yang valid!\nMohon isi Password dibawah ini:", "Register", "Tolak");
			return 1;
		}
		
		for (new i = 0; i < 16; i++) pData[playerid][pSalt][i] = random(94) + 33;
		SHA256_PassHash(inputtext, pData[playerid][pSalt], pData[playerid][pPassword], 65);

		new query[842], PlayerIP[16];
		GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
		pData[playerid][pExtraChar] = 0;
		mysql_format(g_SQL, query, sizeof query, "UPDATE playerucp SET password = '%s', salt = '%e', extrac = '%d' WHERE ucp = '%e'", pData[playerid][pPassword], pData[playerid][pSalt], pData[playerid][pExtraChar], pData[playerid][pUCP]);
		mysql_tquery(g_SQL, query, "CheckPlayerChar", "i", playerid);//rung bar
		return 1;
	}
	if(dialogid == DIALOG_CHARLIST)
    {
		if(response)
		{
			if(PlayerChar[playerid][listitem][0] == EOS)
				return Register(playerid);
			pData[playerid][pChar] = listitem;
			SetPlayerName(playerid, PlayerChar[playerid][listitem]);
			new AtmInfo[560];
	    	format(AtmInfo,1000,"%s", PlayerChar[playerid][listitem]);
	    	PlayerTextDrawSetString(playerid, RegisterTD[playerid][29], AtmInfo);
	    	pData[playerid][pilihkarakter] = 1;
		}
	}
	if(dialogid == DIALOG_MAKE_CHAR)
	{
	    if(response)
	    {
		    if(strlen(inputtext) < 1 || strlen(inputtext) > 24)
				return ShowPlayerDialog(playerid, DIALOG_MAKE_CHAR, DIALOG_STYLE_INPUT, "Executive - {ffffff}Pembuatan Karakter", "Masukan nama baru untuk karakter anda\n\nContoh: Atsuko_Tadashi, Javier_Cooper.", "Oke", "Keluar");
			if(!IsValidRoleplayName(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_MAKE_CHAR, DIALOG_STYLE_INPUT, "Executive - {ffffff}Pembuatan Karakter", "Masukan nama baru untuk karakter anda\n\nContoh: Atsuko_Tadashi, Javier_Cooper.", "Oke", "Keluar");
			//if()	
			new characterQuery[178];
			mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `players` WHERE `username` = '%s'", inputtext);
			mysql_tquery(g_SQL, characterQuery, "CekNamaDobelJing", "ds", playerid, inputtext);
		    format(pData[playerid][pUCP], 22, GetName(playerid));
		}
	}
	if(dialogid == DIALOG_AGE)
    {
		if(!response) return 1;
		if(response)
		{
			new
				iDay,
				iMonth,
				iYear,
				day,
				month,
				year;
				
			getdate(year, month, day);

			static const
					arrMonthDays[] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

			if(sscanf(inputtext, "p</>ddd", iDay, iMonth, iYear)) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Executive - {ffffff}Tanggal Lahir", "Kesalahan! Tidak sah\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Oke", "Batal");
			}
			else if(iYear < 1900 || iYear > year) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Executive - {ffffff}Tanggal Lahir", "Kesalahan! Tidak sah\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Oke", "Batal");
			}
			else if(iMonth < 1 || iMonth > 12) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Executive - {ffffff}Bulan Lahir", "Kesalahan! Tidak sah\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Oke", "Batal");
			}
			else if(iDay < 1 || iDay > arrMonthDays[iMonth - 1]) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Executive - {ffffff}Tanggal Lahir", "Kesalahan! Tidak sah\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Oke", "Batal");
			}
			else 
			{
				format(pData[playerid][pAge], 50, inputtext);
				new AtmInfo[560];
		    	format(AtmInfo,1000,"%s", inputtext);
		    	PlayerTextDrawSetString(playerid, BuatKarakter[playerid][29], AtmInfo);
			}
		}
		else ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Executive - {ffffff}Tanggal Lahir", "Masukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
		return 1;
	}
	if(dialogid == DIALOG_TINGGI)
    {
		if(!response) return 1;
		if(response)
		{
			new tinggi;
			
			if(sscanf(inputtext, "p</>d", tinggi)) {
				ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "Executive - {ffffff}Tinggi Badan", "Kesalahan! Tidak sah\nMasukan tinggi badan minimal 110 cm dan maksimal 200 cm", "Oke", "Batal");
			}
			else if(tinggi < 110 || tinggi > 200) {
				ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "Executive - {ffffff}Tinggi Badan", "Kesalahan! Tidak sah\nMasukan tinggi badan minimal 110 cm dan maksimal 200 cm", "Oke", "Batal");
			}
			else
			{
				format(pData[playerid][pTinggi], 50, inputtext);
				new AtmInfo[560];
		    	format(AtmInfo,1000,"%s Cm", inputtext);
		    	PlayerTextDrawSetString(playerid, BuatKarakter[playerid][30], AtmInfo);
			}
		}
		else ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT,  "Executive - {ffffff}Tinggi Badan", "Kesalahan! Tidak sah\nMasukan tinggi badan minimal 110 cm dan maksimal 200 cm", "Oke", "Batal");
		return 1;
	}
	if(dialogid == DIALOG_BERAT)
    {
		if(!response) return 1;
		if(response)
		{
			new berat;

			if(sscanf(inputtext, "p</>d", berat)) {
				ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "Executive - {ffffff}Berat Badan", "Kesalahan! Tidak sah\nMasukan berat badan minimal 40 kg dan maksimal 150 kg", "Oke", "Batal");
			}
			else if(berat < 40 || berat > 150) {
				ShowPlayerDialog(playerid, DIALOG_TINGGI, DIALOG_STYLE_INPUT, "Executive - {ffffff}Berat Badan", "Kesalahan! Tidak sah\nMasukan berat badan minimal 40 kg dan maksimal 150 kg", "Oke", "Batal");
			}
			else
			{
			    new AtmInfo[560];
		    	format(AtmInfo,1000,"%s Kg", inputtext);
		    	PlayerTextDrawSetString(playerid, BuatKarakter[playerid][31], AtmInfo);
				format(pData[playerid][pBerat], 50, inputtext);
			}
		}
		else ShowPlayerDialog(playerid, DIALOG_BERAT, DIALOG_STYLE_INPUT,  "Executive - {ffffff}Berat Badan", "Kesalahan! Tidak sah\nMasukan berat badan minimal 40 kg dan maksimal 150 kg", "Oke", "Batal");
		return 1;
	}
	if(dialogid == DIALOG_GENDER)
    {
		if(!response) return ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "Kelamin", "1. Laki-Laki\n2. Perempuan", "Oke", "Batal");
		if(response)
		{
			pData[playerid][pGender] = listitem + 1;
			switch (listitem)
			{
				case 0:
				{
					SuccesMsg(playerid,"Registrasi Berhasil! Terima kasih telah bergabung dengan Executive ><!");
					pData[playerid][pSpawnList] = 1;
					switch (pData[playerid][pGender])
					{ //tahap skin
						case 1:
						{
					 		pData[playerid][pSkin] = 17;
					 		SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1750.5931,-2515.8118,13.5969, 0, 0, 0, 0, 0, 0);
							SpawnPlayer(playerid);
						}
						case 2:
						{
					 		pData[playerid][pSkin] = 93;
					 		SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1750.5931,-2515.8118,13.5969, 0, 0, 0, 0, 0, 0);
							SpawnPlayer(playerid);
						}
					}
		//			ShowPlayerDialog(playerid, DIALOG_SPAWN_1, DIALOG_STYLE_LIST, "Select Your Location", "» Unity Station\n» Palomino\n» Airport Los Santos", "Select", "Batal");

				}
				case 1:
				{
					SuccesMsg(playerid,"Registrasi Berhasil! Terima kasih telah bergabung dengan Executive ><!");
					pData[playerid][pSpawnList] = 1;
					switch (pData[playerid][pGender])
					{ //tahap skin
						case 1:
						{
					 		pData[playerid][pSkin] = 17;
					 		SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1750.5931,-2515.8118,13.5969, 0, 0, 0, 0, 0, 0);
							SpawnPlayer(playerid);
						}
						case 2:
						{
					 		pData[playerid][pSkin] = 93;
					 		SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1750.5931,-2515.8118,13.5969, 0, 0, 0, 0, 0, 0);
							SpawnPlayer(playerid);
						}
					}
				//	ShowPlayerDialog(playerid, DIALOG_SPAWN_1, DIALOG_STYLE_LIST, "Select Your Location", "» Unity Station\n» Palomino\n» Airport Los Santos", "Select", "Batal");
				}
				//pData[playerid][pSkin] = (listitem) ? (233) : (98);
			}
		}
		else ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "Kelamin", "1. Laki-Laki\n2. Perempuan", "Pilih", "Batal");
		return 1;
	}
	if(dialogid == DIALOG_EMAIL)
	{
		if(response)
		{
			if(isnull(inputtext))
			{
				ErrorMsg(playerid, "This field cannot be left empty!");
				callcmd::email(playerid);
				return 1;
			}
			if(!(2 < strlen(inputtext) < 40))
			{
				ErrorMsg(playerid, "Please insert a valid email! Must be between 3-40 characters.");
				callcmd::email(playerid);
				return 1;
			}
			if(!IsValidPassword(inputtext))
			{
				Error(playerid, "Email can contain only A-Z, a-z, 0-9, _, [ ], ( )  and @");
				callcmd::email(playerid);
				return 1;
			}
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET email='%e' WHERE reg_id='%d'", inputtext, pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			Servers(playerid, "Your e-mail has been set to "YELLOW_E"%s!"WHITE_E"(relogin for /stats update)", inputtext);
			return 1;
		}
	}
	if(dialogid == DIALOG_PASSWORD)
	{
		if(response)
		{
			if(!(3 < strlen(inputtext) < 20))
			{
				ErrorMsg(playerid, "Please insert a valid password! Must be between 4-20 characters.");
				callcmd::changepass(playerid);
				return 1;
			}
			if(!IsValidPassword(inputtext))
			{
				Error(playerid, "Password can contain only A-Z, a-z, 0-9, _, [ ], ( )");
				callcmd::changepass(playerid);
				return 1;
			}
			new query[512];
			for (new i = 0; i < 16; i++) pData[playerid][pSalt][i] = random(94) + 33;
			SHA256_PassHash(inputtext, pData[playerid][pSalt], pData[playerid][pPassword], 65);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE playerucp SET password='%s', salt='%e' WHERE ucp='%e'", pData[playerid][pPassword], pData[playerid][pSalt], pData[playerid][pUCP]);
			mysql_tquery(g_SQL, query);
			Servers(playerid, "Your password has been updated to "YELLOW_E"'%s'", inputtext);
		}
	}
	if(dialogid == DIALOG_STATS)
	{
		if(response)
		{
			return callcmd::settings(playerid);
		}
	}
	if(dialogid == DIALOG_SETTINGS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{	
					ShowPlayerDialog(playerid, DIALOG_HBEMODE, DIALOG_STYLE_LIST, "Executive - HBE Mode", ""LG_E"Modern Ajah\n"LG_E"Modern Banget", "Pilih", "Tutup");
				}
			}
		}
	}
	if(dialogid == DIALOG_MY_SG)
	{
		if(!response) return true;
		new id = ReturnPlayerStorageID(playerid, (listitem + 1));
		SetPlayerRaceCheckpoint(playerid,1, sData[id][sgX], sData[id][sgY], sData[id][sgZ], 0.0, 0.0, 0.0, 3.5);
		Info(playerid, "Ikuti checkpoint untuk menemukan Business anda!");
		return 1;
	}

	if(dialogid == DIALOG_SG_MENU)
	{
		if(response)
		{
			new id = pData[playerid][pIns];
			switch(listitem)
			{
				case 0:
				{
					if(!IsStorageOwner(playerid, id))
						return ErrorMsg(playerid, "Only Storage Owner who can use this");

					new str[256];
					format(str, sizeof str,"Current Storage Name:\n%s\n\nInput new name to Change Workshop Name", sData[id][sName]);
					ShowPlayerDialog(playerid, DIALOG_SETNAME, DIALOG_STYLE_INPUT, "Change Storage Name", str,"Change","Batal");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_COM, DIALOG_STYLE_LIST, "Storage Component", "Withdraw\nDeposit", "Pilih","Batal");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_MAT, DIALOG_STYLE_LIST, "Storage Material", "Withdraw\nDeposit", "Pilih","Batal");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_UANG, DIALOG_STYLE_LIST, "Storage Money", "Withdraw\nDeposit", "Pilih","Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_SETNAME)
	{
		if(response)
		{
			new id = pData[playerid][pIns];

			if(!IsStorageOwner(playerid, id))
				return ErrorMsg(playerid, "Only Storage Owner who can use this");

			if(strlen(inputtext) > 24)
				return ErrorMsg(playerid, "Maximal 24 Character");

			if(strfind(inputtext, "'", true) != -1)
				return ErrorMsg(playerid, "You can't put ' in Storage Name");

			SendClientMessageEx(playerid, ARWIN, "STORAGE: {ffffff}You've successfully set Storage Name from {ffff00}%s{ffffff} to {7fffd4}%s", sData[id][sName], inputtext);
			format(sData[id][sName], 24, inputtext);
			Storage_Save(id);
			Storage_Refresh(id);
		}
	}
	if(dialogid == DIALOG_COM)
	{
		if(response)
		{
			new str[256], id = pData[playerid][pIns];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMenuTypeStorage] = 1;
					format(str, sizeof str,"Current Component: %d\n\nPlease Input amount to Withdraw", sData[id][sComp]);
				}
				case 1:
				{
					pData[playerid][pMenuTypeStorage] = 2;
					format(str, sizeof str,"Current Component: %d\n\nPlease Input amount to Deposit", sData[id][sComp]);
				}
			}
			ShowPlayerDialog(playerid, DIALOG_COM2, DIALOG_STYLE_INPUT, "Component Menu", str, "Input","Batal");
		}
	}
	if(dialogid == DIALOG_COM2)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pIns];
			if(pData[playerid][pMenuTypeStorage] == 1)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Minimum amount is 1");

				if(sData[id][sComp] < amount) return ErrorMsg(playerid, "Not Enough Storage Component");

				if((pData[playerid][pComponent] + amount) >= 500)
					return ErrorMsg(playerid, "You've reached maximum of Component");

				pData[playerid][pComponent] += amount;
				sData[id][sComp] -= amount;
				Storage_Save(id);
				Info(playerid, "You've successfully withdraw %d Component from Storage", amount);
			}
			else if(pData[playerid][pMenuTypeStorage] == 2)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Minimum amount is 1");

				if(pData[playerid][pComponent] < amount) return ErrorMsg(playerid, "Not Enough Component");

				if((sData[id][sComp] + amount) >= MAX_STORAGE_INT)
					return ErrorMsg(playerid, "You've reached maximum of Component");

				pData[playerid][pComponent] -= amount;
				sData[id][sComp] += amount;
				Storage_Save(id);
				Info(playerid, "You've successfully deposit %d Component to Storage", amount);
			}
		}
	}
	if(dialogid == DIALOG_MAT)
	{
		if(response)
		{
			new str[256], id = pData[playerid][pIns];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMenuTypeStorage] = 1;
					format(str, sizeof str,"Current Material: %d\n\nPlease Input amount to Withdraw", sData[id][sMat]);
				}
				case 1:
				{
					pData[playerid][pMenuTypeStorage] = 2;
					format(str, sizeof str,"Current Material: %d\n\nPlease Input amount to Deposit", sData[id][sMat]);
				}
			}
			ShowPlayerDialog(playerid, DIALOG_MAT2, DIALOG_STYLE_INPUT, "Material Menu", str, "Input","Batal");
		}
	}
	if(dialogid == DIALOG_MAT2)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pInWs];
			if(pData[playerid][pMenuTypeStorage] == 1)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Minimum amount is 1");

				if(sData[id][sMat] < amount) return ErrorMsg(playerid, "Not Enough Storage Material");

				if((pData[playerid][pMaterial] + amount) >= 500)
					return ErrorMsg(playerid, "You've reached maximum of Material");

				pData[playerid][pMaterial] += amount;
				sData[id][sMat] -= amount;
				Storage_Save(id);
				Info(playerid, "You've successfully withdraw %d Material from storage", amount);
			}
			else if(pData[playerid][pMenuTypeStorage] == 2)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Minimum amount is 1");

				if(pData[playerid][pMaterial] < amount) return ErrorMsg(playerid, "Not Enough Material");

				if((sData[id][sMat] + amount) >= MAX_STORAGE_INT)
					return ErrorMsg(playerid, "You've reached maximum of Material");

				pData[playerid][pMaterial] -= amount;
				sData[id][sMat] += amount;
				Storage_Save(id);
				Info(playerid, "You've successfully deposit %d Material to Storage", amount);
			}
		}
	}
	if(dialogid == DIALOG_UANG)
	{
		if(response)
		{
			new str[264], id = pData[playerid][pIns];
			switch(listitem)
			{
				case 0:
				{
					if(!IsStorageOwner(playerid, id))
						return ErrorMsg(playerid, "Only Storage Owner who can use this");

					format(str, sizeof str, "Current Money:\n{7fff00}%s\n\n{ffffff}Input Amount to Withdraw", FormatMoney(sData[id][sMoney]));
					ShowPlayerDialog(playerid, DIALOG_AMBILUANG, DIALOG_STYLE_INPUT, "Withdraw Storage Money",str,"Withdraw","Batal");
				}
				case 1:
				{
					format(str, sizeof str, "Current Money:\n{7fff00}%s\n\n{ffffff}Input Amount to Deposit", FormatMoney(sData[id][sMoney]));
					ShowPlayerDialog(playerid, DIALOG_DEPOUANG, DIALOG_STYLE_INPUT, "Deposit Storage Money",str,"Deposit","Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_AMBILUANG)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pIns];

			if(amount < 1)
				return ErrorMsg(playerid, "Minimum amount is $1");

			if(sData[id][sMoney] < amount)
				return ErrorMsg(playerid, "Not Enough Storage Money");

			GivePlayerMoneyEx(playerid, amount);
			sData[id][sMoney] -= amount;
			Storage_Save(id);
		}
	}
	if(dialogid == DIALOG_DEPOUANG)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pIns];

			if(amount < 1)
				return ErrorMsg(playerid, "Minimum amount is $1");

			if(pData[playerid][pMoney] < amount)
				return ErrorMsg(playerid, "Not Enough Money");

			GivePlayerMoneyEx(playerid, -amount);
			sData[id][sMoney] += amount;
			Storage_Save(id);
		}
	}
	if(dialogid == DIALOG_CHANGEAGE)
    {
		if(response)
		{
			new
				iDay,
				iMonth,
				iYear,
				day,
				month,
				year;
				
			getdate(year, month, day);

			static const
					arrMonthDays[] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

			if(sscanf(inputtext, "p</>ddd", iDay, iMonth, iYear)) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iYear < 1900 || iYear > year) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Tahun Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iMonth < 1 || iMonth > 12) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Bulan Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iDay < 1 || iDay > arrMonthDays[iMonth - 1]) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else 
			{
				format(pData[playerid][pAge], 50, inputtext);
				Info(playerid, "New Age for your character is "YELLOW_E"%s.", pData[playerid][pAge]);
				GivePlayerMoneyEx(playerid, -300);
				Server_AddMoney(300);
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GOLDSHOP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pGold] < 800) return ErrorMsg(playerid, "Kamu tidak memiliki koin Executive!");
					ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, "Ganti Nama", "Masukkan Nama:\nContoh: Faruq_Jumantara\n", "Ganti", "Batal");
				}
				case 1:
				{
					if(pData[playerid][pGold] < 1000) return ErrorMsg(playerid, "Kamu tidak memiliki koin Executive!");
					pData[playerid][pGold] -= 1000;
					pData[playerid][pWarn] = 0;
					Info(playerid, "Peringatan telah direset untuk 1000 Coin. Total Warning: 0");
				}
				case 2:
				{
					if(pData[playerid][pGold] < 100) return ErrorMsg(playerid, "Kamu tidak memiliki koin Executive!");
					pData[playerid][pGold] -= 100;
					pData[playerid][pVip] = 1;
					pData[playerid][pVipTime] = gettime() + (7 * 86400);
					Info(playerid, "Anda telah membeli VIP level 1 seharga 150 coin(7 hari).");
				}
				case 3:
				{
					if(pData[playerid][pGold] < 150) return ErrorMsg(playerid, "Kamu tidak memiliki koin Executive!");
					pData[playerid][pGold] -= 150;
					pData[playerid][pVip] = 2;
					pData[playerid][pVipTime] = gettime() + (7 * 86400);
					Info(playerid, "Anda telah membeli VIP level 1 seharga 150 coin(7 hari).");
				}
				case 4:
				{
					if(pData[playerid][pGold] < 200) return ErrorMsg(playerid, "Kamu tidak memiliki koin Executive!");
					pData[playerid][pGold] -= 200;
					pData[playerid][pVip] = 3;
					pData[playerid][pVipTime] = gettime() + (7 * 86400);
					Info(playerid, "Anda telah membeli VIP level 1 seharga 200 coin(7 hari).");
				}
				case 5:
				{
					if(pData[playerid][pGold] < 200) return ErrorMsg(playerid, "Kamu tidak memiliki koin Executive!");
					pData[playerid][pGold] -= 200;
					GivePlayerMoneyEx(playerid, 10000);
					Info(playerid, "Anda telah membeli uang IC sebesar 10,000 menggunakan 200 gold");
				}
				case 6:
				{
					if(pData[playerid][pGold] < 150) return ErrorMsg(playerid, "Kamu tidak memiliki koin Executive!");
					pData[playerid][pGold] -= 150;
					pData[playerid][pSnack] += 100;
					Info(playerid, "Anda telah membeli makanan sejumlah 100 menggunakan 150 coin.");
				}
				case 7:
				{
					if(pData[playerid][pGold] < 150) return ErrorMsg(playerid, "Kamu tidak memiliki koin Executive!");
					pData[playerid][pGold] -= 150;
					pData[playerid][pSprunk] += 100;
					Info(playerid, "Anda telah membeli minuman sejumlah 100 menggunakan 150 coin.");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GOLDNAME)
	{
		if(response)
		{
			if(strlen(inputtext) < 4) return ErrorMsg(playerid, "Nama baru tidak boleh lebih pendek dari 4 karakter!"),  ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, ""WHITE_E"Change Name", "Enter your new name:", "Enter", "Exit");
			if(strlen(inputtext) > 20) return ErrorMsg(playerid, "Nama baru tidak boleh lebih dari 20 karakter!"),  ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, ""WHITE_E"Change Name", "Enter your new name:", "Enter", "Exit");
			if(!IsValidRoleplayName(inputtext))
			{
				ErrorMsg(playerid, "Nama berisi karakter yang tidak valid, periksa kembali!");
				ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, ""WHITE_E"Ganti nama", "Masukkan nama baru Anda:", "pilih", "Exit");
				return 1;
			}
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE username='%s'", inputtext);
			mysql_tquery(g_SQL, query, "ChangeName", "is", playerid, inputtext);
		}
		return 1;
	}
	//-----------[ Bisnis Dialog ]------------
	if(dialogid == DIALOG_SELL_BISNISS)
	{
		if(!response) return 1;
		new str[248];
		SetPVarInt(playerid, "SellingBisnis", ReturnPlayerBisnisID(playerid, (listitem + 1)));
		format(str, sizeof(str), "Are you sure you will sell bisnis id: %d", GetPVarInt(playerid, "SellingBisnis"));
				
		ShowPlayerDialog(playerid, DIALOG_SELL_BISNIS, DIALOG_STYLE_MSGBOX, "Sell Bisnis", str, "Sell", "Batal");
	}
	if(dialogid == DIALOG_SELL_BISNIS)
	{
		if(response)
		{
			new bid = GetPVarInt(playerid, "SellingBisnis"), price;
			price = bData[bid][bPrice] / 2;
			GivePlayerMoneyEx(playerid, price);
			Info(playerid, "Anda berhasil menjual bisnis id (%d) dengan setengah harga("LG_E"%s"WHITE_E") pada saat anda membelinya.", bid, FormatMoney(price));
			new str[150];
			format(str,sizeof(str),"[BIZ]: %s menjual business id %d seharga %s!", GetRPName(playerid), bid, FormatMoney(price));
			LogServer("Property", str);
			Bisnis_Reset(bid);
			Bisnis_Save(bid);
			Bisnis_Refresh(bid);
		}
		DeletePVar(playerid, "SellingBisnis");
		return 1;
	}
	if(dialogid == DIALOG_MY_BISNIS)
	{
		if(!response) return true;
		SetPVarInt(playerid, "ClickedBisnis", ReturnPlayerBisnisID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, BISNIS_INFO, DIALOG_STYLE_LIST, "{0000FF}My Business", "Show Information\nTrack Bisnis", "Pilih", "Batal");
		return 1;
	}
	if(dialogid == BISNIS_INFO)
	{
		if(!response) return true;
		new bid = GetPVarInt(playerid, "ClickedBisnis");
		switch(listitem)
		{
			case 0:
			{
				new line9[900];
				new lock[128], type[128];
				if(bData[bid][bLocked] == 1)
				{
					lock = "{FF0000}Locked";
			
				}
				else
				{
					lock = "{00FF00}Unlocked";
				}
				if(bData[bid][bType] == 1)
				{
					type = "Fast Food";
			
				}
				else if(bData[bid][bType] == 2)
				{
					type = "Market";
				}
				else if(bData[bid][bType] == 3)
				{
					type = "Clothes";
				}
				else if(bData[bid][bType] == 4)
				{
					type = "Equipment";
				}
				else
				{
					type = "Unknow";
				}
				format(line9, sizeof(line9), "Bisnis ID: %d\nBisnis Owner: %s\nBisnis Name: %s\nBisnis Price: %s\nBisnis Type: %s\nBisnis Status: %s\nBisnis Product: %d",
				bid, bData[bid][bOwner], bData[bid][bName], FormatMoney(bData[bid][bPrice]), type, lock, bData[bid][bProd]);

				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Bisnis Info", line9, "Tutup","");
			}
			case 1:
			{
				pData[playerid][pTrackBisnis] = 1;
				SetPlayerRaceCheckpoint(playerid,1, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ], 0.0, 0.0, 0.0, 3.5);
				//SetPlayerCheckpoint(playerid, bData[bid][bExtpos][0], bData[bid][bExtpos][1], bData[bid][bExtpos][2], 4.0);
				Info(playerid, "Ikuti checkpoint untuk menemukan bisnis anda!");
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_MENU)
	{
		new bid = pData[playerid][pInBiz];
		new lock[128];
		if(bData[bid][bLocked] == 1)
		{
			lock = "Locked";
		}
		else
		{
			lock = "Unlocked";
		}
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{	
					new mstr[248], lstr[512];
					format(mstr,sizeof(mstr),"Bisnis ID %d", bid);
					format(lstr,sizeof(lstr),"Bisnis Name:\t%s\nBisnis Locked:\t%s\nBisnis Product:\t%d\nBisnis Vault:\t%s", bData[bid][bName], lock, bData[bid][bProd], FormatMoney(bData[bid][bMoney]));
					ShowPlayerDialog(playerid, BISNIS_INFO, DIALOG_STYLE_TABLIST, mstr, lstr,"Kembali","Tutup");
				}
				case 1:
				{
					new mstr[248];
					format(mstr,sizeof(mstr),"Nama sebelumnya: %s\n\nMasukkan nama bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama bisnis", bData[bid][bName]);
					ShowPlayerDialog(playerid, BISNIS_NAME, DIALOG_STYLE_INPUT,"Bisnis Name", mstr,"Done","Kembali");
				}
				case 2: ShowPlayerDialog(playerid, BISNIS_VAULT, DIALOG_STYLE_LIST,"Bisnis Vault","Deposit\nWithdraw","Next","Kembali");
				case 3:
				{
					Bisnis_ProductMenu(playerid, bid);
				}
				case 4:
				{
					if(bData[bid][bProd] > 100)
						return ErrorMsg(playerid, "Bisnis ini masih memiliki cukup produck.");
					if(bData[bid][bMoney] < 1000)
						return ErrorMsg(playerid, "Setidaknya anda mempunyai uang dalam bisnis anda senilai $1.000 untuk merestock product.");
					bData[bid][bRestock] = 1;
					Info(playerid, "Anda berhasil request untuk mengisi stock product kepada trucker, harap tunggu sampai pekerja trucker melayani.");
				}
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_INFO)
	{
		if(response)
		{
			return callcmd::bm(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == BISNIS_NAME)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];

			if(!Player_OwnsBisnis(playerid, pData[playerid][pInBiz])) return ErrorMsg(playerid, "You don't own this bisnis.");
			
			if (isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Bisnis tidak di perbolehkan kosong!\n\n"WHITE_E"Nama sebelumnya: %s\n\nMasukkan nama Bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", bData[bid][bName]);
				ShowPlayerDialog(playerid, BISNIS_NAME, DIALOG_STYLE_INPUT,"Bisnis Name", mstr,"Done","Kembali");
				return 1;
			}
			if(strlen(inputtext) > 32 || strlen(inputtext) < 5)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Bisnis harus 5 sampai 32 karakter.\n\n"WHITE_E"Nama sebelumnya: %s\n\nMasukkan nama Bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", bData[bid][bName]);
				ShowPlayerDialog(playerid, BISNIS_NAME, DIALOG_STYLE_INPUT,"Bisnis Name", mstr,"Done","Kembali");
				return 1;
			}
			format(bData[bid][bName], 32, ColouredText(inputtext));

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET name='%s' WHERE ID='%d'", bData[bid][bName], bid);
			mysql_tquery(g_SQL, query);

			Bisnis_Refresh(bid);

			Servers(playerid, "Bisnis name set to: \"%s\".", bData[bid][bName]);
		}
		else return callcmd::bm(playerid, "\0");
		return 1;
	}
	if(dialogid == BISNIS_VAULT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Uang kamu: %s.\n\nMasukkan berapa banyak uang yang akan kamu simpan di dalam bisnis ini", FormatMoney(GetPlayerMoney(playerid)));
					ShowPlayerDialog(playerid, BISNIS_DEPOSIT, DIALOG_STYLE_INPUT, "Deposit", mstr, "Deposit", "Kembali");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Business Vault: %s\n\nMasukkan berapa banyak uang yang akan kamu ambil di dalam bisnis ini", FormatMoney(bData[pData[playerid][pInBiz]][bMoney]));
					ShowPlayerDialog(playerid, BISNIS_WITHDRAW, DIALOG_STYLE_INPUT,"Withdraw", mstr,"Withdraw","Kembali");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_RADIAL)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					DisplayDokumen(playerid);
				}
				case 1:
				{
				    if(pData[playerid][pPhone] == 0) return ErrorMsg(playerid, "Anda tidak memiliki ponsel");
                    for(new i = 0; i < 21; i++)
				    {
						 TextDrawShowForPlayer(playerid, PhoneTD[i]);
			 		}
			 		TextDrawShowForPlayer(playerid, FINGERPRINT);
					TextDrawShowForPlayer(playerid, TANGGAL);
					TextDrawShowForPlayer(playerid, JAMLOCKSCREEN);
					new day, month, year;
				    getdate(year,month,day);
				    new string[256];
					format(string, sizeof string, "%02d %s %02d", day, GetMonthName(month), year);
				   	TextDrawSetString(TANGGAL, string);
					SelectTextDraw(playerid, COLOR_BLUE);
					PlayerPlaySound(playerid, 3600, 0,0,0);
				}
				case 2:
				{
					callcmd::i(playerid, "");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_WT, DIALOG_STYLE_LIST, "Radial Menu | {7fffd4}Kota Executive", "Nyalakan Walkie Talkie\nMatikan Walkie Talkie", "Pilih", "Kembali");
				}
				case 4:
				{
					callcmd::factionhelp(playerid);
				}
				case 5:
				{
					ShowPlayerDialog(playerid, DIALOG_VOICE, DIALOG_STYLE_LIST, "Radial Menu | {7fffd4}Kota Executive", "Berbisik\nNormal\nTeriak", "Pilih", "Kembali");
				}
				case 6:
				{
					callcmd::vrm(playerid, "");
				}
				case 7:
				{
					callcmd::toys(playerid);
				}
				case 8:
				{
					ShowPlayerDialog(playerid, DIALOG_RADIO, DIALOG_STYLE_LIST, "Radial Menu | {7fffd4}Kota Executive", "Nyalakan Radio\nMatikan Radio", "Pilih", "Kembali");
				}
				case 9:
				{
					callcmd::frisk(playerid, "");
				}
				case 10:
				{
					callcmd::mybillanjaykontol(playerid);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_KARGO)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
				    KargoBarang(playerid);
				    SwitchVehicleEngine(pData[playerid][pKendaraanKerja], true);
				}
				case 1:
				{
					KargoMinyak(playerid);
					SwitchVehicleEngine(pData[playerid][pKendaraanKerja], true);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_VRM)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					callcmd::lock(playerid, "");
				}
				case 1:
				{
				    callcmd::light(playerid, "");
				}
				case 2:
				{
				    callcmd::vstorage(playerid, "");
				}
				case 3:
				{
				    callcmd::hood(playerid, "");
				}
				case 4:
				{
				    callcmd::trunk(playerid, "");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GARASIMD)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
				    pData[playerid][pKendaraanFraksi] = CreateVehicle(416, 717.724060,-1418.360717,13.785820,1.208041,0,0,120000,0);
					PutPlayerInVehicle(playerid, pData[playerid][pKendaraanFraksi], 0);
			    	SetVehicleNumberPlate(pData[playerid][pKendaraanFraksi], "SAMD VEHICLE");
				}
				case 1:
				{
				    pData[playerid][pKendaraanFraksi] = CreateVehicle(468, 717.724060,-1418.360717,13.785820,1.208041,0,0,120000,0);
					PutPlayerInVehicle(playerid, pData[playerid][pKendaraanFraksi], 0);
			    	SetVehicleNumberPlate(pData[playerid][pKendaraanFraksi], "SAMD VEHICLE");
				}
			}
		}
		return 1;
	}
	
	if(dialogid == DIALOG_GARASIGOJEK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
				    pData[playerid][pKendaraanFraksi] = CreateVehicle(586, 1376.1536,-1759.9680,13.1059,1.8526,16,0,120000,0);
					PutPlayerInVehicle(playerid, pData[playerid][pKendaraanFraksi], 0);
			    	SetVehicleNumberPlate(pData[playerid][pKendaraanFraksi], "Motor gojek");
				}
				case 1:
				{
				    pData[playerid][pKendaraanFraksi] = CreateVehicle(426, 1375.1448,-1758.1543,13.3092,0.6447,16,0,120000,0);
					PutPlayerInVehicle(playerid, pData[playerid][pKendaraanFraksi], 0);
			    	SetVehicleNumberPlate(pData[playerid][pKendaraanFraksi], "Mobil Gojek");
				}
				case 2:
				{
				    pData[playerid][pKendaraanFraksi] = CreateVehicle(448, 1374.8295,-1760.0057,13.1842,357.7223,16,0,120000,0);
					PutPlayerInVehicle(playerid, pData[playerid][pKendaraanFraksi], 0);
			    	SetVehicleNumberPlate(pData[playerid][pKendaraanFraksi], "Motor pesan makan");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GARASISAGS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
				    pData[playerid][pKendaraanFraksi] = CreateVehicle(409, 1247.0775,-2055.6189,59.5875,269.4459,0,0,120000,0);
					PutPlayerInVehicle(playerid, pData[playerid][pKendaraanFraksi], 0);
			    	SetVehicleNumberPlate(pData[playerid][pKendaraanFraksi], "Pemerintah Veh");
				}
				case 1:
				{
				    pData[playerid][pKendaraanFraksi] = CreateVehicle(405, 1248.1970,-2054.9346,59.6123,0,0,120000,0);
					PutPlayerInVehicle(playerid, pData[playerid][pKendaraanFraksi], 0);
			    	SetVehicleNumberPlate(pData[playerid][pKendaraanFraksi], "Pemerintah Veh");
				}
				case 2:
				{
				    pData[playerid][pKendaraanFraksi] = CreateVehicle(521, 1249.0819,-2055.5479,59.2996,0,0,120000,0);
					PutPlayerInVehicle(playerid, pData[playerid][pKendaraanFraksi], 0);
			    	SetVehicleNumberPlate(pData[playerid][pKendaraanFraksi], "Pemerintah Veh");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GARASIPEDAGANG)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
				    new tmpobjid;
				    pData[playerid][pKendaraanFraksi] = CreateVehicle(423, 1493.067138,-666.322204,94.769989,173.523635,0,0,120000,0);
					PutPlayerInVehicle(playerid, pData[playerid][pKendaraanFraksi], 0);
			    	SetVehicleNumberPlate(pData[playerid][pKendaraanFraksi], "PEDAGANG VEHICLE");
			    	tmpobjid = CreateDynamicObject(2660,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 10310, "boigas_sfe", "burgershotmenu256", 0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], 1.090, -0.200, -0.279, 0.000, 0.000, 90.000);
				    tmpobjid = CreateDynamicObject(2660,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 10310, "boigas_sfe", "burgershotmenu256", 0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], -1.090, -0.200, -0.279, 0.000, 0.000, -90.000);
				    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 2420, "cj_ff_acc1", "CJ_BS_MENU4s", 0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], -0.360, -2.221, -0.079, 0.000, 0.000, 0.000);
				    tmpobjid = CreateDynamicObject(2721,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 2430, "cj_burg_sign", "CJ_BS_MENU2", 0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], -1.090, -1.620, 0.250, 0.000, 0.000, -90.000);
				    tmpobjid = CreateDynamicObject(2721,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 2430, "cj_burg_sign", "CJ_BS_MENU2", 0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], 1.111, -1.620, 0.250, 0.000, 0.000, 90.000);
				    tmpobjid = CreateDynamicObject(2865,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 2430, "cj_burg_sign", "CJ_BS_MENU2", 0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], -0.766, -0.685, 0.230, 0.000, 0.000, 113.899);
				    tmpobjid = CreateDynamicObject(2157,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], -0.780, -0.500, -0.830, 0.000, 0.000, 90.000);
				    tmpobjid = CreateDynamicObject(2157,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], -0.780, -1.651, -0.830, 0.000, 0.000, 90.000);
				    tmpobjid = CreateDynamicObject(2157,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], 0.770, -0.031, -0.830, 0.000, 0.000, -90.000);
				    tmpobjid = CreateDynamicObject(2157,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], 0.770, -1.031, -0.830, 0.000, 0.000, -90.000);
				    tmpobjid = CreateDynamicObject(19094,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], 0.642, -0.577, 0.242, -5.800, -91.599, -76.699);
				    tmpobjid = CreateDynamicObject(19830,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], -0.700, -1.420, 0.200, 0.000, 0.000, 90.000);
				}
				case 1:
				{
				    pData[playerid][pKendaraanFraksi] = CreateVehicle(448, 1493.067138,-666.322204,94.769989,173.523635,0,0,120000,0);
					PutPlayerInVehicle(playerid, pData[playerid][pKendaraanFraksi], 0);
			    	SetVehicleNumberPlate(pData[playerid][pKendaraanFraksi], "PEDAGANG VEHICLE");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GARASIPD)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pKendaraanFraksi] = CreateVehicle(541, 1303.972045,-1338.869506,13.722788,265.453094,0,0,120000,0);
					PutPlayerInVehicle(playerid, pData[playerid][pKendaraanFraksi], 0);
			    	SetVehicleNumberPlate(pData[playerid][pKendaraanFraksi], "KEPOLISIAN");
			    	AddVehicleComponent(pData[playerid][pKendaraanFraksi], 1082);
				 	AddVehicleComponent(pData[playerid][pKendaraanFraksi], 1010);
				 	new tmpobjid;
				 	tmpobjid = CreateDynamicObject(1003,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], 0.000, -2.199, 0.280, 0.000, 0.000, 0.000);
				    tmpobjid = CreateDynamicObject(19620,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], 0.000, -0.100, 0.659, 0.000, 0.000, 0.000);
				}
				case 1:
				{
				    pData[playerid][pKendaraanFraksi] = CreateVehicle(560, 1303.972045,-1338.869506,13.722788,265.453094,0,0,120000,0);
					PutPlayerInVehicle(playerid, pData[playerid][pKendaraanFraksi], 0);
			    	SetVehicleNumberPlate(pData[playerid][pKendaraanFraksi], "KEPOLISIAN");
				 	new tmpobjid;
				 	tmpobjid = CreateDynamicObject(19620,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], 0.000, 0.000, 0.910, 0.000, 0.000, 0.000);
				    tmpobjid = CreateDynamicObject(2733,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "None", 10, "Ariel", 20, 0, 0, -1, 0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], 0.000, -0.200, 0.820, 270.000, 90.000, 0.000);
				    tmpobjid = CreateDynamicObject(2655,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "None", 10, "Ariel", 20, 0, 0, -1, 2);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], -1.080, -0.100, 0.100, 180.000, 90.000, 90.000);
				    tmpobjid = CreateDynamicObject(2655,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "None", 10, "Ariel", 20, 0, 0, -1, 2);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], 1.080, -0.100, 0.100, 180.000, -90.000, -90.000);
				    tmpobjid = CreateDynamicObject(2655,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "None", 10, "Ariel", 20, 0, 0, -1, 2);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], -1.080, -0.060, -0.200, -180.000, -90.000, 90.000);
				    tmpobjid = CreateDynamicObject(2655,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "None", 10, "Ariel", 20, 0, 0, -1, 2);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], 1.080, -0.060, -0.200, -180.000, 90.000, -90.000);
				    tmpobjid = CreateDynamicObject(19482,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "POLICE", 130, "Ariel", 30, 0, -1, 0, 0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], -2.299, 3.450, -0.210, 0.000, 290.000, 91.000);
				    tmpobjid = CreateDynamicObject(19482,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "POLICE", 130, "Ariel", 20, 0, -1, 0, 0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], 2.460, -2.640, -0.970, 0.000, 350.000, -91.000);
				    tmpobjid = CreateDynamicObject(1956,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], 1.059, -0.100, -0.019, 0.000, 90.000, 0.000);
				    tmpobjid = CreateDynamicObject(1956,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], -1.059, -0.100, -0.019, 0.000, -90.000, 0.000);
				    tmpobjid = CreateDynamicObject(19482,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "POLICE", 120, "courier", 9, 1, -1, 0, 0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], 1.099, 2.539, -1.250, 0.000, 0.000, 0.000);
				    tmpobjid = CreateDynamicObject(19482,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "POLICE", 120, "courier", 9, 1, -1, 0, 0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], -0.990, -2.739, -1.259, 360.000, 360.000, 542.000);
				    tmpobjid = CreateDynamicObject(19482,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "LS        PD", 130, "Fixedsys", 25, 0, -16777216, 0, 0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], 1.099, 2.129, -1.079, 0.000, 0.000, 0.000);
				    tmpobjid = CreateDynamicObject(19482,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "LS        PD", 130, "Fixedsys", 25, 0, -16777216, 0, 0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], -1.099, -2.310, -1.079, 0.000, 0.000, 180.000);
				    tmpobjid = CreateDynamicObject(1182,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "ab_wood01", 0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], -0.920, 2.650, -0.159, 0.000, 0.000, 0.000);
				    tmpobjid = CreateDynamicObject(367,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				    AttachDynamicObjectToVehicle(tmpobjid, pData[playerid][pKendaraanFraksi], 0.070, 0.299, 0.610, 0.000, 0.000, 90.000);
				}
				case 2:
				{
				    pData[playerid][pKendaraanFraksi] = CreateVehicle(596, 1303.972045,-1338.869506,13.722788,265.453094,0,0,120000,0);
					PutPlayerInVehicle(playerid, pData[playerid][pKendaraanFraksi], 0);
			    	SetVehicleNumberPlate(pData[playerid][pKendaraanFraksi], "KEPOLISIAN");
				}
				case 3:
				{
				    pData[playerid][pKendaraanFraksi] = CreateVehicle(468, 1303.972045,-1338.869506,13.722788,265.453094,0,0,120000,0);
					PutPlayerInVehicle(playerid, pData[playerid][pKendaraanFraksi], 0);
			    	SetVehicleNumberPlate(pData[playerid][pKendaraanFraksi], "KEPOLISIAN");
				}
				case 4:
				{
				    pData[playerid][pKendaraanFraksi] = CreateVehicle(523, 1303.972045,-1338.869506,13.722788,265.453094,0,0,120000,0);
					PutPlayerInVehicle(playerid, pData[playerid][pKendaraanFraksi], 0);
			    	SetVehicleNumberPlate(pData[playerid][pKendaraanFraksi], "KEPOLISIAN");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_VOICE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
				    if(pData[playerid][pHBEMode] == 1 && pData[playerid][IsLoggedIn] == true)
					{
	                    if ((lstream[playerid] = SvCreateDLStreamAtPlayer(5.0, SV_INFINITY, playerid, 0xff0000ff, "Berbisik")))
		             	SuccesMsg(playerid, "anda telah mengubah suara menjadi berbisik.");
						PlayerTextDrawHide(playerid, PlayerTD[playerid][8]);
						PlayerTextDrawSetString(playerid, PlayerTD[playerid][8], "Berbisik");
						PlayerTextDrawShow(playerid, PlayerTD[playerid][8]);
					}
				}
				case 1:
				{
	                if(pData[playerid][pHBEMode] == 1 && pData[playerid][IsLoggedIn] == true)
					{
		             	if ((lstream[playerid] = SvCreateDLStreamAtPlayer(15.0, SV_INFINITY, playerid, 0xff0000ff, "Normal")))
		                SuccesMsg(playerid, "anda telah mengubah suara menjadi normal.");
						PlayerTextDrawHide(playerid, PlayerTD[playerid][8]);
						PlayerTextDrawSetString(playerid, PlayerTD[playerid][8], "Normal");
						PlayerTextDrawShow(playerid, PlayerTD[playerid][8]);
					}
				}
				case 2:
				{
	  	            if(pData[playerid][pHBEMode] == 1 && pData[playerid][IsLoggedIn] == true)
					{
		             	if ((lstream[playerid] = SvCreateDLStreamAtPlayer(40.0, SV_INFINITY, playerid, 0xff0000ff, "Teriak")))
	  	            	SuccesMsg(playerid, "anda telah mengubah suara menjadi teriak.");
						PlayerTextDrawHide(playerid, PlayerTD[playerid][8]);
						PlayerTextDrawSetString(playerid, PlayerTD[playerid][8], "Teriak");
						PlayerTextDrawShow(playerid, PlayerTD[playerid][8]);
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_DISNAKER)
	{
		if(response)
		{
			switch(listitem)
			{
			    //================[ CASE 0 ]=============
				case 0:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~y~Supir Bus");
					pData[playerid][pJob] = 1;
					Sopirbus++;
					RefreshJobBus(playerid);
				}
				//================[ CASE 1 ]=============
				case 1:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~y~Tukang Ayam");
					pData[playerid][pJob] = 2;
					tukangayam++;
					RefreshJobPemotong(playerid);
				}
				//================[ CASE 2 ]=============
				case 2:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~y~Penebang Kayu");
					pData[playerid][pJob] = 3;
					tukangtebang++;
					RefreshJobTebang(playerid);
				}
				//================[ CASE 3 ]=============
				case 3:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~y~Petani");
					pData[playerid][pJob] = 7;
					petani++;
					RefreshJobTani(playerid);
				}
				//================[ CASE 4 ]=============
				case 4:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~y~Penambang Minyak");
					pData[playerid][pJob] = 4;
					penambangminyak++;
					RefreshJobTambangMinyak(playerid);
				}
				//================[ CASE 5 ]=============
				case 5:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~y~Pemerah Susu");
					pData[playerid][pJob] = 5;
					pemerah++;
					pData[playerid][pJobmilkduty] = false;
					RefreshMapJobSapi(playerid);
				}
				//================[ CASE 6 ]=============
				case 6:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~y~Penambang");
					pData[playerid][pJob] = 6;
					RefreshJobTambang(playerid);
					penambang++;
				}
				//================[ CASE 7 ]=============
				case 7:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~y~Kargo");
					pData[playerid][pJob] = 8;
					Trucker++;
					RefreshJobKargo(playerid);
				}
				case 8:
				{
				    if(pData[playerid][pJob] > 0) return ErrorMsg(playerid, "Anda sudah memiliki pekerjaan.");
					SuccesMsg(playerid, "Anda Memilih Pekerjaan Sebagai ~y~Penjahit");
					pData[playerid][pJob] = 10;
					penjahit++;
				}
				//================[ KELUAR PEKERJAAN ]=============
				case 9:
				{
				    if(pData[playerid][pJob] == 0) return ErrorMsg(playerid, "Anda seorang pengangguran.");
				    if(pData[playerid][pJob] == 1)
					{
					    Sopirbus--;
					    pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~y~sopir bus");
						DeleteBusCP(playerid);
					}
					else if(pData[playerid][pJob] == 2)
					{
				    	tukangayam--;
						pData[playerid][pJob] = 0;
						DeletePemotongCP(playerid);
						SuccesMsg(playerid, "Anda resign menjadi ~y~tukang ayam");
					}
					else if(pData[playerid][pJob] == 3)
					{
				    	tukangtebang--;
						DeletePenebangCP(playerid);
				    	pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~y~tukang tebang");
					}
					else if(pData[playerid][pJob] == 4)
					{
				    	penambangminyak--;
				    	pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~y~penambang minyak.");
						DeleteMinyakCP(playerid);
					}
					else if(pData[playerid][pJob] == 5)
					{
					    DeleteJobPemerahMap(playerid);
				    	pemerah--;
				    	pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~y~pemerah");
					}
					else if(pData[playerid][pJob] == 6)
					{
				    	penambang--;
				    	DeletePenambangCP(playerid);
				    	pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~y~penambang");
					}
					else if(pData[playerid][pJob] == 7)
					{
				    	petani--;
				    	pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~y~Kargo");
						DeletePetaniCP(playerid);
					}
					else if(pData[playerid][pJob] == 8)
					{
				    	Trucker--;
				    	pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~y~trucker");
						DeleteKargoCP(playerid);
					}
					else if(pData[playerid][pJob] == 10)
					{
				    	penjahit--;
				    	pData[playerid][pJob] = 0;
						SuccesMsg(playerid, "Anda resign menjadi ~y~penjahit");
					}
				}
			}
		}
		return 1;
	}

	if(dialogid == DIALOG_TAMBANG)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
				    callcmd::jualminyakaufa(playerid, "");
				}
				case 1:
				{
				    callcmd::jualemasAufa(playerid, "");
				}
				case 2:
				{
				    callcmd::jualbesiAufa(playerid, "");
				}
				case 3:
				{
				    callcmd::jualtembagaAufa(playerid, "");
				}
			}
		}
		return 1;
	}

	if(dialogid == DIALOG_JUALIKAN)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
				    callcmd::jualpenyuAufa(playerid, "");
				}
				case 1:
				{
				    callcmd::jualmarakelAufa(playerid, "");
				}
				case 2:
				{
				    callcmd::jualnemoAufa(playerid, "");
				}
				case 3:
				{
				    callcmd::jualbluefishAufa(playerid, "");
				}
			}
		}
		return 1;
	}

	if(dialogid == DIALOG_JUALPETANI)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
				    callcmd::jualayam(playerid, "");
				}
				case 1:
				{
				    callcmd::jualsusuaufa(playerid, "");
				}
				case 2:
				{
				    callcmd::jualberasAufa(playerid, "");
				}
				case 3:
				{
				    callcmd::jualsambalAufa(playerid, "");
				}
				case 4:
				{
				    callcmd::jualtepungAufa(playerid, "");
				}
				case 5:
				{
				    callcmd::jualgulaAufa(playerid, "");
				}
			}
		}
		return 1;
	}

	if(dialogid == DIALOG_JUALKAYU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
				    callcmd::jualpapan(playerid, "");
				}
			}
		}
		return 1;
	}

	/*if(dialogid == DIALOG_HOLIMARKET)
	{
		if(response)
		{
			switch(listitem)
			{
			    //================[ CASE 0 ]=============
				case 0:
				{
				    callcmd::jualayam(playerid, "");
				}
				//================[ CASE 1 ]=============
				case 1:
				{
				    callcmd::jualsusuaufa(playerid, "");
				}
				//================[ CASE 2 ]=============
				case 2:
				{
				    callcmd::jualminyakaufa(playerid, "");
				}
				//================[ CASE 3 ]=============
				case 3:
				{
				    callcmd::jualemasAufa(playerid, "");
				}
				//================[ CASE 4 ]=============
				case 4:
				{
				    callcmd::jualberasAufa(playerid, "");
				}
				//================[ CASE 5 ]=============
				case 5:
				{
				    callcmd::jualsambalAufa(playerid, "");
				}
				//================[ CASE 6 ]=============
				case 6:
				{
				    callcmd::jualtepungAufa(playerid, "");
				}
				//================[ CASE 7 ]=============
				case 7:
				{
				    callcmd::jualgulaAufa(playerid, "");
				}
				//================[ CASE 8 ]=============
				case 8:
				{
				    callcmd::jualpenyuAufa(playerid, "");
				}
				//================[ CASE 9 ]=============
				case 9:
				{
				    callcmd::jualmarakelAufa(playerid, "");
				}
				//================[ CASE 10 ]=============
				case 10:
				{
				    callcmd::jualnemoAufa(playerid, "");
				}
				//================[ CASE 11 ]=============
				case 11:
				{
				    callcmd::jualbluefishAufa(playerid, "");
				}
				//================[ CASE 12 ]=============
				case 12:
				{
				    callcmd::jualbesiAufa(playerid, "");
				}
				//================[ CASE 13 ]=============
				case 13:
				{
				    callcmd::jualtembagaAufa(playerid, "");
				}
				case 14:
				{
				new total = pData[playerid][pPapan];
				if(pData[playerid][pDutyJob] != 3) return 1;
				if(PlayerInfo[playerid][pProgress] == 1) return ErrorMsg(playerid,"Anda masih ada progress");
				if(pData[playerid][pPapan] < 1) return ErrorMsg(playerid, "Anda Tidak Memiliki Papan");
				ShowProgressbar(playerid, "Menjual Papan..", total);
				ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
				new pay = pData[playerid][pPapan] * 80;
				GivePlayerMoneyEx(playerid, pay);
				pData[playerid][pPapan] -= total;
				new str[500];
				format(str, sizeof(str), "ADD_%dx", pay);
				ShowItemBox(playerid, "Uang", str, 1212, total);
				format(str, sizeof(str), "REMOVED_%dx", total);
				ShowItemBox(playerid, "Papan", str, 19366, total);
				Inventory_Update(playerid);
				}
			}
		}
		return 1;
	}*/
	if(dialogid == DIALOG_LOCKERAYAM)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Seragam Kerja");
					if(pData[playerid][pGender] == 1) SetPlayerSkin(playerid, 168);
					else SetPlayerSkin(playerid, 205);// wanita
					RefreshJobPemotong(playerid);
				}
				case 1:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Baju Warga");
					SetPlayerSkin(playerid, pData[playerid][pSkin]);
					RefreshJobPemotong(playerid);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_PROSESTANI)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
				    if(pData[playerid][pPadiOlahan] < 5) return ErrorMsg(playerid, "Anda tidak memiliki 5 padi");
					pData[playerid][pPadiOlahan] -= 5;
					ShowProgressbar(playerid, "Memproses Padi..", 10);
					ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
					ShowItemBox(playerid, "Padi", "Removed_5x", 2901, 2);
					SetTimerEx("ProsesPadi", 10000, false, "d", playerid);
				}
				case 1:
				{
				    if(pData[playerid][pCabaiOlahan] < 5) return ErrorMsg(playerid, "Anda tidak memiliki 5 cabai");
					pData[playerid][pCabaiOlahan] -= 5;
					ShowProgressbar(playerid, "Proses Cabai..", 5);
					ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
					ShowItemBox(playerid, "Cabai", "Removed_5x", 2901, 2);
					SetTimerEx("ProsesCabai", 5000, false, "d", playerid);
				}
				case 2:
				{
				    if(pData[playerid][pJagungOlahan] < 5) return ErrorMsg(playerid, "Anda tidak memiliki 5 jagung");
					pData[playerid][pJagungOlahan] -= 5;
                    ShowProgressbar(playerid, "Proses Jagung..", 8);
                    ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
                    ShowItemBox(playerid, "Jagung", "Removed_5x", 2901, 2);
                    SetTimerEx("ProsesJagung", 8000, false, "d", playerid);
				}
				case 3:
				{
				    if(pData[playerid][pTebuOlahan] < 5) return ErrorMsg(playerid, "Anda tidak memiliki 5 tebu");
					pData[playerid][pTebuOlahan] -= 5;
					ShowProgressbar(playerid, "Proses Tebu..", 6);
					ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
					ShowItemBox(playerid, "Tebu", "Removed_5x", 2901, 2);
					SetTimerEx("ProsesTebu", 6000, false, "d", playerid);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_NANAMBIBIT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
				    if(pData[playerid][pPadi] < 5) return ErrorMsg(playerid, "Anda tidak memiliki 5 bibit padi");
					pData[playerid][pPadi] -= 5;
					ShowProgressbar(playerid, "Menanam Padi..", 10);
					ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
					ShowItemBox(playerid, "Bibit_Padi", "Removed_5x", 862, 2);
					SetTimerEx("NanamPadi", 10000, false, "d", playerid);
				}
				case 1:
				{
				    if(pData[playerid][pCabai] < 5) return ErrorMsg(playerid, "Anda tidak memiliki 5 bibit cabai");
					pData[playerid][pCabai] -= 5;
					ShowProgressbar(playerid, "Menanam Cabai..", 5);
					ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
					ShowItemBox(playerid, "Bibit_Cabai", "Removed_5x", 862, 2);
					SetTimerEx("NanamCabai", 5000, false, "d", playerid);
				}
				case 2:
				{
				    if(pData[playerid][pJagung] < 5) return ErrorMsg(playerid, "Anda tidak memiliki 5 bibit jagung");
					pData[playerid][pJagung] -= 5;
                    ShowProgressbar(playerid, "Menanam Jagung..", 8);
                    ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
                    ShowItemBox(playerid, "Bibit_Jagung", "Removed_5x", 862, 2);
                    SetTimerEx("NanamJagung", 8000, false, "d", playerid);
				}
				case 3:
				{
				    if(pData[playerid][pTebu] < 5) return ErrorMsg(playerid, "Anda tidak memiliki 5 bibit tebu");
					pData[playerid][pTebu] -= 5;
					ShowProgressbar(playerid, "Menanam Tebu..", 6);
					ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1); // Place Bomb
					ShowItemBox(playerid, "Bibit_Tebu", "Removed_5x", 862, 2);
					SetTimerEx("NanamTebu", 6000, false, "d", playerid);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_BELIBIBIT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pPadi] += 2;
					GivePlayerMoneyEx(playerid, -4);
					ShowItemBox(playerid, "Uang", "Removed_$4", 1212, 2);
					ShowItemBox(playerid, "Bibit_Padi", "Received_2x", 862, 2);
				}
				case 1:
				{
					pData[playerid][pCabai] += 2;
					GivePlayerMoneyEx(playerid, -1);
					ShowItemBox(playerid, "Uang", "Removed_$1", 1212, 2);
					ShowItemBox(playerid, "Bibit_Cabai", "Received_2x", 862, 2);
				}
				case 2:
				{
					pData[playerid][pJagung] += 2;
					GivePlayerMoneyEx(playerid, -3);
					ShowItemBox(playerid, "Uang", "Removed_$3", 1212, 2);
					ShowItemBox(playerid, "Bibit_Jagung", "Received_2x", 862, 2);
				}
				case 3:
				{
					pData[playerid][pTebu] += 2;
					GivePlayerMoneyEx(playerid, -2);
					ShowItemBox(playerid, "Uang", "Removed_$2", 1212, 2);
					ShowItemBox(playerid, "Bibit_Tebu", "Received_2x", 862, 2);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERPENAMBANG)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Seragam Kerja");
					if(pData[playerid][pGender] == 1) SetPlayerSkin(playerid, 27);
					else SetPlayerSkin(playerid, 31);// wanita
					pData[playerid][pDutyJob] = 2;
					pData[playerid][DutyPenambang] = true;
                    RefreshJobTambang(playerid);
				}
				case 1:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Baju Warga");
					SetPlayerSkin(playerid, pData[playerid][pSkin]);
					pData[playerid][pDutyJob] = 0;
					pData[playerid][DutyPenambang] = false;
					RefreshJobTambang(playerid);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERPENJAHIT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Seragam Kerja");
					if(pData[playerid][pGender] == 1) SetPlayerSkin(playerid,240);
					else SetPlayerSkin(playerid,194);// wanita
					pData[playerid][pDutyJob] = 4;
				}
				case 1:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Baju Warga");
					SetPlayerSkin(playerid, pData[playerid][pSkin]);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERTUKANGKAYU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Seragam Kerja");
					if(pData[playerid][pGender] == 1) SetPlayerSkin(playerid,159);
					else SetPlayerSkin(playerid,157);// wanita
					pData[playerid][pDutyJob] = 3;
					pData[playerid][DutyPenebang] = false;
					RefreshJobTebang(playerid);
				}
				case 1:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Baju Warga");
					SetPlayerSkin(playerid, pData[playerid][pSkin]);
					RefreshJobTebang(playerid);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERPEMERAH)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Seragam Kerja");
					if(pData[playerid][pGender] == 1) SetPlayerSkin(playerid,158);
					else SetPlayerSkin(playerid,157);// wanita
					pData[playerid][pJobmilkduty] = true;
					RefreshMapJobSapi(playerid);
					//InfoMsg(playerid, "Silahkan pergi untuk memeras susu,tekan ALT untuk memeras");
				}
				case 1:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Baju Warga");
					SetPlayerSkin(playerid, pData[playerid][pSkin]);
					pData[playerid][pJobmilkduty] = false;
					RefreshMapJobSapi(playerid);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERMINYAK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Seragam Kerja");
					if(pData[playerid][pGender] == 1) SetPlayerSkin(playerid,50);
					else SetPlayerSkin(playerid,54);// wanita
					pData[playerid][pDutyJob] = 1;
					RefreshJobTambangMinyak(playerid);
				}
				case 1:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Baju Warga");
					SetPlayerSkin(playerid, pData[playerid][pSkin]);
					RefreshJobTambangMinyak(playerid);
				}
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_WITHDRAW)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > bData[bid][bMoney])
				return ErrorMsg(playerid, "Invalid amount specified!");

			bData[bid][bMoney] -= amount;
			
			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET money='%d' WHERE ID='%d'", bData[bid][bMoney], bid);
			mysql_tquery(g_SQL, query);

			GivePlayerMoneyEx(playerid, amount);

			SendClientMessageEx(playerid, COLOR_LBLUE,"BUSINESS: "WHITE_E"You have withdrawn "GREEN_E"%s "WHITE_E"from the business vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, BISNIS_VAULT, DIALOG_STYLE_LIST,"Business Vault","Deposit\nWithdraw","Next","Kembali");
		return 1;
	}
	if(dialogid == BISNIS_DEPOSIT)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > GetPlayerMoney(playerid))
				return ErrorMsg(playerid, "Invalid amount specified!");

			bData[bid][bMoney] += amount;

			new query[128];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET money='%d' WHERE ID='%d'", bData[bid][bMoney], bid);
			mysql_tquery(g_SQL, query);

			GivePlayerMoneyEx(playerid, -amount);
			
			SendClientMessageEx(playerid, COLOR_LBLUE,"BUSINESS: "WHITE_E"You have deposit "GREEN_E"%s "WHITE_E"into the business vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, BISNIS_VAULT, DIALOG_STYLE_LIST,"Business Vault","Deposit\nWithdraw","Next","Kembali");
		return 1;
	}
	if(dialogid == BISNIS_BUYPROD)
	{
		static
        bizid = -1,
        price;

		if((bizid = pData[playerid][pInBiz]) != -1 && response)
		{
			price = bData[bizid][bP][listitem];

			if(GetPlayerMoney(playerid) < price)
				return ErrorMsg(playerid, "Not enough money!");

			if(bData[bizid][bProd] < 1)
				return ErrorMsg(playerid, "This business is out of stock product.");
				
			new Float:health;
			GetPlayerHealth(playerid,health);
			if(bData[bizid][bType] == 1)
			{
				switch(listitem)
				{
					case 0:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

						GivePlayerMoneyEx(playerid, -price);
						SetPlayerHealthEx(playerid, health+30);
						pData[playerid][pHunger] += 35;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli makanan seharga %s dan langsung memakannya.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 1:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						SetPlayerHealthEx(playerid, health+45);
						pData[playerid][pHunger] += 50;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli makanan seharga %s dan langsung memakannya.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);

						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 2:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						SetPlayerHealthEx(playerid, health+70);
						pData[playerid][pHunger] += 75;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli makanan seharga %s dan langsung memakannya.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 3:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);

						pData[playerid][pEnergy] += 60;
						//SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_SPRUNK);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli minuman seharga %s.", ReturnName(playerid), FormatMoney(price));
						//SetPVarInt(playerid, "UsingSprunk", 1);
					}
				}
			}
			else if(bData[bizid][bType] == 2)
			{
				switch(listitem)
				{
					case 0:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pSnack]++;
						ShowItemBox(playerid, "Nasi_Padang", "Received_1x", 2663, 3);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli nasi padang seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 1:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pSprunk]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Sprunk seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 2:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pGas]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Gas Fuel seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 3:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pBandage]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Perban seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 4:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pMineral]++;
						ShowItemBox(playerid, "Air_Mineral", "Received_1x", 1484, 3);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Air Mineral seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);

						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 5:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");

						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pCig]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Cigarette seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);

						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
				}
			}
			else if(bData[bizid][bType] == 3)
			{
				switch(listitem)
				{
					case 0:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						switch(pData[playerid][pGender])
						{
							case 1: ShowModelSelectionMenu(playerid, MaleSkins, "Choose your skin");
							case 2: ShowModelSelectionMenu(playerid, FemaleSkins, "Choose your skin");
						}
					}
					case 1:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						new string[248];
						if(pToys[playerid][0][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 1\n");
						}
						else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

						if(pToys[playerid][1][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 2\n");
						}
						else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

						if(pToys[playerid][2][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 3\n");
						}
						else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

						if(pToys[playerid][3][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 4\n");
						}
						else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");
						ShowPlayerDialog(playerid, DIALOG_TOYBUY, DIALOG_STYLE_LIST, "Executive - Aksesoris", string, "Pilih", "Batal");
					}
					case 2:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pMask] = 1;
						pData[playerid][pMaskID] = random(90000) + 10000;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli mask seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 3:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pHelmet] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Helmet seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
				}
			}
			else if(bData[bizid][bType] == 4)
			{
				switch(listitem)
				{
					case 0:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 1, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Brass Knuckles seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 1:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
			
						if(pData[playerid][pJob] == 7 || pData[playerid][pJob2] == 7 || pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, 4, 1);
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Knife seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += Server_Percent(price);
							Server_AddPercent(price);
						
							new query[128];
							mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
							mysql_tquery(g_SQL, query);
						}
						else return ErrorMsg(playerid, "Job farmer & Ayam only!");
					}
					case 2:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 5, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Baseball Bat seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 3:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, 6, 1);
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Shovel seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += Server_Percent(price);
							Server_AddPercent(price);
						
							new query[128];
							mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
							mysql_tquery(g_SQL, query);
						}
						else return ErrorMsg(playerid, "Job miner only!");
					}
					case 4:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						if(pData[playerid][pJob] == 3 || pData[playerid][pJob2] == 3)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, 9, 1);
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Chainsaw seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += Server_Percent(price);
							Server_AddPercent(price);
						
							new query[128];
							mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
							mysql_tquery(g_SQL, query);
						}
						else return ErrorMsg(playerid, "Job lumber jack only!");
					}
					case 5:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 15, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Cane seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 6:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						if(pData[playerid][pFishTool] > 2) return ErrorMsg(playerid, "You only can get 3 fish tool!");
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pFishTool]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli pancingan seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 7:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pWorm] += 2;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli 2 umpan cacing seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
				}
			}
			else if(bData[bizid][bType] == 5)
			{
				switch(listitem)
				{
					case 0:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pGPS] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli GPS seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 1:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						new query[128], rand = RandomEx(1111, 9888);
						new phone = rand+pData[playerid][pID];
						mysql_format(g_SQL, query, sizeof(query), "SELECT phone FROM players WHERE phone='%d'", phone);
						mysql_tquery(g_SQL, query, "PhoneNumber", "id", playerid, phone);
						//pData[playerid][pPhone] = ;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli nomor HP seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new queryy[128];
						mysql_format(g_SQL, queryy, sizeof(queryy), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, queryy);
					}
					case 2:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pPhoneCredit] += 20;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli 20 phone credit seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 3:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pPhoneBook] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli sebuah phone book seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 4:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pWT] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli sebuah walkie talkie seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 5:
					{
						if(price == 0)
							return ErrorMsg(playerid, "Harga produk belum di setel oleh pemilik bisnis");
							
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pKuota] += 10000000;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli sebuah kuota 10gb seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
					case 6:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pBoombox] += 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli sebuah boombox seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += Server_Percent(price);
						Server_AddPercent(price);
						
						new query[128];
						mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
						mysql_tquery(g_SQL, query);
					}
				}
			}	
		}
		return 1;
	}
	if(dialogid == BISNIS_EDITPROD)
	{
		if(Player_OwnsBisnis(playerid, pData[playerid][pInBiz]))
		{
			if(response)
			{
				static
					item[40],
					str[128];

				strmid(item, inputtext, 0, strfind(inputtext, "-") - 1);
				strpack(pData[playerid][pEditingItem], item, 40 char);

				pData[playerid][pProductModify] = listitem;
				format(str,sizeof(str), "Please enter the new product price for %s:", item);
				ShowPlayerDialog(playerid, BISNIS_PRICESET, DIALOG_STYLE_INPUT, "Business: Set Price", str, "Modify", "Kembali");
			}
			else
				return callcmd::bm(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == BISNIS_PRICESET)
	{
		static
        item[40];
		new bizid = pData[playerid][pInBiz];
		if(Player_OwnsBisnis(playerid, pData[playerid][pInBiz]))
		{
			if(response)
			{
				strunpack(item, pData[playerid][pEditingItem]);

				if(isnull(inputtext))
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s:", item);
					ShowPlayerDialog(playerid, BISNIS_PRICESET, DIALOG_STYLE_INPUT, "Business: Set Price", str, "Modify", "Kembali");
					return 1;
				}
				if(strval(inputtext) < 1 || strval(inputtext) > 5000)
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s ($1 to $5,000):", item);
					ShowPlayerDialog(playerid, BISNIS_PRICESET, DIALOG_STYLE_INPUT, "Business: Set Price", str, "Modify", "Kembali");
					return 1;
				}
				bData[bizid][bP][pData[playerid][pProductModify]] = strval(inputtext);
				Bisnis_Save(bizid);

				Servers(playerid, "You have adjusted the price of %s to: %s!", item, FormatMoney(strval(inputtext)));
				Bisnis_ProductMenu(playerid, bizid);
			}
			else
			{
				Bisnis_ProductMenu(playerid, bizid);
			}
		}
		return 1;
	}
	//-----------[ House Dialog ]------------------
	if(dialogid == DIALOG_SELL_HOUSES)
	{
		if(!response) return 1;
		new str[248];
		SetPVarInt(playerid, "SellingHouse", ReturnPlayerHousesID(playerid, (listitem + 1)));
		format(str, sizeof(str), "Are you sure you will sell house id: %d", GetPVarInt(playerid, "SellingHouse"));
				
		ShowPlayerDialog(playerid, DIALOG_SELL_HOUSE, DIALOG_STYLE_MSGBOX, "Sell House", str, "Sell", "Batal");
	}
	if(dialogid == DIALOG_SELL_HOUSE)
	{
		if(response)
		{
			new hid = GetPVarInt(playerid, "SellingHouse"), price;
			price = hData[hid][hPrice] / 2;
			GivePlayerMoneyEx(playerid, price);
			Info(playerid, "Anda berhasil menjual rumah id (%d) dengan setengah harga("LG_E"%s"WHITE_E") pada saat anda membelinya.", hid, FormatMoney(price));
			new str[150];
			format(str,sizeof(str),"[HOUSE]: %s menjual house id %d seharga %s!", GetRPName(playerid), hid, FormatMoney(price));
			LogServer("Property", str);
			HouseReset(hid);
			House_Save(hid);
			House_Refresh(hid);
		}
		DeletePVar(playerid, "SellingHouse");
		return 1;
	}
	if(dialogid == DIALOG_MY_HOUSES)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedHouse", ReturnPlayerHousesID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, HOUSE_INFO, DIALOG_STYLE_LIST, "{0000FF}My Houses", "Show Information\nTrack House", "Pilih", "Batal");
		return 1;
	}
	if(dialogid == HOUSE_INFO)
	{
		if(!response) return 1;
		new hid = GetPVarInt(playerid, "ClickedHouse");
		switch(listitem)
		{
			case 0:
			{
				new line9[900];
				new lock[128], type[128];
				if(hData[hid][hLocked] == 1)
				{
					lock = "{FF0000}Locked";
			
				}
				else
				{
					lock = "{00FF00}Unlocked";
				}
				if(hData[hid][hType] == 1)
				{
					type = "Small";
			
				}
				else if(hData[hid][hType] == 2)
				{
					type = "Medium";
				}
				else if(hData[hid][hType] == 3)
				{
					type = "Big";
				}
				else
				{
					type = "Unknow";
				}
				format(line9, sizeof(line9), "House ID: %d\nHouse Owner: %s\nHouse Address: %s\nHouse Price: %s\nHouse Type: %s\nHouse Status: %s",
				hid, hData[hid][hOwner], hData[hid][hAddress], FormatMoney(hData[hid][hPrice]), type, lock);

				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "House Info", line9, "Tutup","");
			}
			case 1:
			{
				pData[playerid][pTrackHouse] = 1;
				SetPlayerRaceCheckpoint(playerid,1, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ], 0.0, 0.0, 0.0, 3.5);
				//SetPlayerCheckpoint(playerid, hData[hid][hExtpos][0], hData[hid][hExtpos][1], hData[hid][hExtpos][2], 4.0);
				Info(playerid, "Ikuti checkpoint untuk menemukan rumah anda!");
			}
		}
		return 1;
	}
	if(dialogid == HOUSE_STORAGE)
	{
		new hid = pData[playerid][pInHouse];
		new string[200];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) 
			if(pData[playerid][pFaction] != 1)
				return ErrorMsg(playerid, "You don't own this house.");
		if(response)
		{
			if(listitem == 0) 
			{
				House_WeaponStorage(playerid, hid);
			}
			else if(listitem == 1) 
			{
				format(string, sizeof(string), "Money\t{3BBD44}%s{ffffff}\n{FF0000}RedMoney\t%s{ffffff}", FormatMoney(hData[hid][hMoney]), FormatMoney(hData[hid][hRedMoney]));
				ShowPlayerDialog(playerid, HOUSE_MONEY, DIALOG_STYLE_TABLIST, "Money Safe", string, "Pilih", "Kembali");
			}
			else if(listitem == 2)
			{
				format(string, sizeof(string), "Food\t({3BBD44}%d{ffffff}/%d)\nDrink\t({3BBD44}%d{ffffff}/%d)", hData[hid][hSnack], GetHouseStorage(hid, LIMIT_SNACK), hData[hid][hSprunk], GetHouseStorage(hid, LIMIT_SPRUNK));
				ShowPlayerDialog(playerid, HOUSE_FOODDRINK, DIALOG_STYLE_TABLIST, "Food & Drink", string, "Pilih", "Kembali");
			} 
			else if(listitem == 3)
			{
				format(string, sizeof(string), "Medicine\t({3BBD44}%d{ffffff}/%d)\nMedkit\t({3BBD44}%d{ffffff}/%d)\nBandage\t({3BBD44}%d{ffffff}/%d)", hData[hid][hMedicine], GetHouseStorage(hid, LIMIT_MEDICINE), hData[hid][hMedkit], GetHouseStorage(hid, LIMIT_MEDKIT), hData[hid][hBandage], GetHouseStorage(hid, LIMIT_BANDAGE));
				ShowPlayerDialog(playerid, HOUSE_DRUGS, DIALOG_STYLE_TABLIST, "Drugs Storage", string, "Pilih", "Kembali");
			} 
			else if(listitem == 4)
			{
				format(string, sizeof(string), "Seeds\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", hData[hid][hSeed], GetHouseStorage(hid, LIMIT_SEED), hData[hid][hMaterial], GetHouseStorage(hid, LIMIT_MATERIAL),  hData[hid][hComponent], GetHouseStorage(hid, LIMIT_COMPONENT), hData[hid][hMarijuana], GetHouseStorage(hid, LIMIT_MARIJUANA));
				ShowPlayerDialog(playerid, HOUSE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Pilih", "Kembali");
			} 
		}
		return 1;
	}
	if(dialogid == HOUSE_WEAPONS)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) 
			if(pData[playerid][pFaction] != 1)
				return ErrorMsg(playerid, "You don't own this house.");
				
		if(response)
		{
			if(hData[houseid][hWeapon][listitem] != 0)
			{
				GivePlayerWeaponEx(playerid, hData[houseid][hWeapon][listitem], hData[houseid][hAmmo][listitem]);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(hData[houseid][hWeapon][listitem]));

				hData[houseid][hWeapon][listitem] = 0;
				hData[houseid][hAmmo][listitem] = 0;

				House_Save(houseid);
				House_WeaponStorage(playerid, houseid);
			}
			else
			{
				new
					weaponid = GetPlayerWeaponEx(playerid),
					ammo = GetPlayerAmmoEx(playerid);

				if(!weaponid)
					return ErrorMsg(playerid, "You are not holding any weapon!");

				/*if(weaponid == 23 && pData[playerid][pTazer])
					return ErrorMsg(playerid, "You can't store a tazer into your safe.");

				if(weaponid == 25 && pData[playerid][pBeanBag])
					return ErrorMsg(playerid, "You can't store a beanbag shotgun into your safe.");*/

				ResetWeapon(playerid, weaponid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their weapon storage.", ReturnName(playerid), ReturnWeaponName(weaponid));

				hData[houseid][hWeapon][listitem] = weaponid;
				hData[houseid][hAmmo][listitem] = ammo;

				House_Save(houseid);
				House_WeaponStorage(playerid, houseid);
			}
		}
		else
		{
			House_OpenStorage(playerid, houseid);
		}
		return 1;
	}
	if(dialogid == HOUSE_MONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, houseid)) return ErrorMsg(playerid, "You don't own this house.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					ShowPlayerDialog(playerid, HOUSE_REALMONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Pilih", "Kembali");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, HOUSE_REDMONEY, DIALOG_STYLE_LIST, "RedMoney Safe", "Withdraw from safe\nDeposit into safe", "Pilih", "Kembali");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}			
	if(dialogid == HOUSE_REALMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "You don't own this house.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hMoney]));
					ShowPlayerDialog(playerid, HOUSE_WITHDRAW_REALMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hMoney]));
					ShowPlayerDialog(playerid, HOUSE_DEPOSIT_REALMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}
	if(dialogid == HOUSE_WITHDRAW_REALMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "You don't own this house.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_WITHDRAW_REALMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_WITHDRAW_REALMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			hData[houseid][hMoney] -= amount;
			GivePlayerMoneyEx(playerid, amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s from their house safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, HOUSE_REALMONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_DEPOSIT_REALMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "You don't own this house.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_DEPOSIT_REALMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > GetPlayerMoney(playerid))
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_DEPOSIT_REALMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			hData[houseid][hMoney] += amount;
			GivePlayerMoneyEx(playerid, -amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s into their house safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, HOUSE_REALMONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Pilih", "Kembali");
		return 1;
	}
	//////////////////////////////////////////////////////
	if(dialogid == HOUSE_REDMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "You don't own this house.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hRedMoney]));
					ShowPlayerDialog(playerid, HOUSE_WITHDRAW_REDMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hRedMoney]));
					ShowPlayerDialog(playerid, HOUSE_DEPOSIT_REDMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}
	if(dialogid == HOUSE_WITHDRAW_REDMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "You don't own this house.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hRedMoney]));
				ShowPlayerDialog(playerid, HOUSE_WITHDRAW_REDMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hRedMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hRedMoney]));
				ShowPlayerDialog(playerid, HOUSE_WITHDRAW_REDMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			hData[houseid][hRedMoney] -= amount;
			pData[playerid][pRedMoney] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s from their house safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, HOUSE_REDMONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_DEPOSIT_REDMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "You don't own this house.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hRedMoney]));
				ShowPlayerDialog(playerid, HOUSE_DEPOSIT_REDMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pRedMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hRedMoney]));
				ShowPlayerDialog(playerid, HOUSE_DEPOSIT_REDMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			hData[houseid][hRedMoney] += amount;
			pData[playerid][pRedMoney] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s into their house safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, HOUSE_REDMONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Pilih", "Kembali");
		return 1;
	}
	//======================================================[ FOOD HOME STORAGE ]=============================================================//
	if(dialogid == HOUSE_FOODDRINK)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, houseid)) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					ShowPlayerDialog(playerid, HOUSE_FOOD, DIALOG_STYLE_LIST, "Snack Storage", "Ambil Snack dari penyimpanan\nSimpan Snack ke penyimpanan", "Pilih", "Kembali");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, HOUSE_DRINK, DIALOG_STYLE_LIST, "Sprunk Storage", "Ambil Sprunk dari penyimpanan\nSimpan Sprunk dari penyimpanan", "Pilih", "Kembali");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}	
	if(dialogid == HOUSE_FOOD)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Snack yang tersedia: %d\n\nSilakan masukkan berapa banyak Snack yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSnack]);
					ShowPlayerDialog(playerid, HOUSE_FOOD_WITHDRAW, DIALOG_STYLE_INPUT, "Snack Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Snack yang anda bawa: %d\n\nSilakan masukkan berapa banyak Snack yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pSnack]);
					ShowPlayerDialog(playerid, HOUSE_FOOD_DEPOSIT, DIALOG_STYLE_INPUT, "Snack Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Food\t({3BBD44}%d{ffffff}/%d)\nDrink\t({3BBD44}%d{ffffff}/%d)", hData[houseid][hSnack], GetHouseStorage(houseid, LIMIT_SNACK), hData[houseid][hSprunk], GetHouseStorage(houseid, LIMIT_SPRUNK));
			ShowPlayerDialog(playerid, HOUSE_FOODDRINK, DIALOG_STYLE_TABLIST, "Food & Drink", string, "Pilih", "Kembali");
		}
		return 1;
	}
	if(dialogid == HOUSE_FOOD_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Snack yang tersedia: %d\n\nSilakan masukkan berapa banyak Snack yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSnack]);
				ShowPlayerDialog(playerid, HOUSE_FOOD_WITHDRAW, DIALOG_STYLE_INPUT, "Snack Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hSnack])
			{
				new str[128];
				format(str, sizeof(str), "Error: Snack tidak mencukupi!.\n\nSnack yang tersedia: %d\n\nSilakan masukkan berapa banyak Snack yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSnack]);
				ShowPlayerDialog(playerid, HOUSE_FOOD_WITHDRAW, DIALOG_STYLE_INPUT, "Snack Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hSnack] -= amount;
			pData[playerid][pSnack] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d snack dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_FOOD, DIALOG_STYLE_LIST, "Snack Storage", "Ambil Snack dari penyimpanan\nSimpan Snack ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_FOOD_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Snack yang anda bawa: %d\n\nSilakan masukkan berapa banyak Snack yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pSnack]);
				ShowPlayerDialog(playerid, HOUSE_FOOD_DEPOSIT, DIALOG_STYLE_INPUT, "Snack Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pSnack])
			{
				new str[128];
				format(str, sizeof(str), "Error: Snack tidak mencukupi!.\n\nSnack yang anda bawa: %d\n\nSilakan masukkan berapa banyak Snack yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pSnack]);
				ShowPlayerDialog(playerid, HOUSE_FOOD_DEPOSIT, DIALOG_STYLE_INPUT, "Snack Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_SNACK) < hData[houseid][hSnack] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Snack!.\n\nSnack yang anda bawa: %d\n\nSilakan masukkan berapa banyak Snack yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_SNACK), pData[playerid][pSnack]);
				ShowPlayerDialog(playerid, HOUSE_FOOD_DEPOSIT, DIALOG_STYLE_INPUT, "Snack Storage", str, "Simpan", "Kembali");
				return 1;
			}

			hData[houseid][hSnack] += amount;
			pData[playerid][pSnack] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d snack ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_FOOD, DIALOG_STYLE_LIST, "Snack Storage", "Ambil Snack dari penyimpanan\nSimpan Snack ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//======================================================[ SPRUNK HOME STORAGE ]==============================================//
	if(dialogid == HOUSE_DRINK)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Sprunk yang tersedia: %d\n\nSilakan masukkan berapa banyak Sprunk yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSprunk]);
					ShowPlayerDialog(playerid, HOUSE_DRINK_WITHDRAW, DIALOG_STYLE_INPUT, "Sprunk Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Sprunk yang anda bawa: %d\n\nSilakan masukkan berapa banyak Sprunk yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pSprunk]);
					ShowPlayerDialog(playerid, HOUSE_DRINK_DEPOSIT, DIALOG_STYLE_INPUT, "Sprunk Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Food\t({3BBD44}%d{ffffff}/%d)\nDrink\t({3BBD44}%d{ffffff}/%d)", hData[houseid][hSnack], GetHouseStorage(houseid, LIMIT_SNACK), hData[houseid][hSprunk], GetHouseStorage(houseid, LIMIT_SPRUNK));
			ShowPlayerDialog(playerid, HOUSE_FOODDRINK, DIALOG_STYLE_TABLIST, "Food & Drink", string, "Pilih", "Kembali");
		}
		return 1;
	}
	if(dialogid == HOUSE_DRINK_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Sprunk yang tersedia: %d\n\nSilakan masukkan berapa banyak Sprunk yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSprunk]);
				ShowPlayerDialog(playerid, HOUSE_DRINK_WITHDRAW, DIALOG_STYLE_INPUT, "Sprunk Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hSprunk])
			{
				new str[128];
				format(str, sizeof(str), "Error: Sprunk tidak mencukupi!.\n\nSprunk yang tersedia: %d\n\nSilakan masukkan berapa banyak Sprunk yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSprunk]);
				ShowPlayerDialog(playerid, HOUSE_DRINK_WITHDRAW, DIALOG_STYLE_INPUT, "Sprunk Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hSprunk] -= amount;
			pData[playerid][pSprunk] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d sprunk dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_DRINK, DIALOG_STYLE_LIST, "Sprunk Storage", "Ambil Sprunk dari penyimpanan\nSimpan Sprunk ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_DRINK_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Sprunk yang anda bawa: %d\n\nSilakan masukkan berapa banyak Sprunk yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pSprunk]);
				ShowPlayerDialog(playerid, HOUSE_DRINK_DEPOSIT, DIALOG_STYLE_INPUT, "Sprunk Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pSprunk])
			{
				new str[128];
				format(str, sizeof(str), "Error: Sprunk tidak mencukupi!.\n\nSprunk yang anda bawa: %d\n\nSilakan masukkan berapa banyak Sprunk yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pSprunk]);
				ShowPlayerDialog(playerid, HOUSE_DRINK_DEPOSIT, DIALOG_STYLE_INPUT, "Sprunk Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_SPRUNK) < hData[houseid][hSprunk] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Sprunk!.\n\nSprunk yang anda bawa: %d\n\nSilakan masukkan berapa banyak Sprunk yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_SPRUNK), pData[playerid][pSprunk]);
				ShowPlayerDialog(playerid, HOUSE_DRINK_DEPOSIT, DIALOG_STYLE_INPUT, "Sprunk Storage", str, "Simpan", "Kembali");
				return 1;
			}
			hData[houseid][hSprunk] += amount;
			pData[playerid][pSprunk] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d sprunk ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_DRINK, DIALOG_STYLE_LIST, "Sprunk Storage", "Ambil Sprunk dari penyimpanan\nSimpan Sprunk ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//=====================================================[ DRUGS HOME STORAGE ]=================================================//
	if(dialogid == HOUSE_DRUGS)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, houseid)) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					ShowPlayerDialog(playerid, HOUSE_MEDICINE, DIALOG_STYLE_LIST, "Medicine Storage", "Ambil Medicine dari penyimpanan\nSimpan Medicine ke penyimpanan", "Pilih", "Kembali");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, HOUSE_MEDKIT, DIALOG_STYLE_LIST, "Medkit Storage", "Ambil Medkit dari penyimpanan\nSimpan Medkit dari penyimpanan", "Pilih", "Kembali");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, HOUSE_BANDAGE, DIALOG_STYLE_LIST, "Bandage Storage", "Ambil Bandage dari penyimpanan\nSimpan Bandage dari penyimpanan", "Pilih", "Kembali");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}	
	//=======================================================[ MEDICINE HOME STORAGE]===============================================//
	if(dialogid == HOUSE_MEDICINE)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Medicine yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMedicine]);
					ShowPlayerDialog(playerid, HOUSE_MEDICINE_WITHDRAW, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Medicine yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pMedicine]);
					ShowPlayerDialog(playerid, HOUSE_MEDICINE_DEPOSIT, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Medicine\t({3BBD44}%d{ffffff}/%d)\nMedkit\t({3BBD44}%d{ffffff}/%d)\nBandage\t({3BBD44}%d{ffffff}/%d)", hData[houseid][hMedicine], GetHouseStorage(houseid, LIMIT_MEDICINE), hData[houseid][hMedkit], GetHouseStorage(houseid, LIMIT_MEDKIT), hData[houseid][hBandage], GetHouseStorage(houseid, LIMIT_BANDAGE));
			ShowPlayerDialog(playerid, HOUSE_DRUGS, DIALOG_STYLE_TABLIST, "Drugs Storage", string, "Pilih", "Kembali");
		}
		return 1;
	}
	if(dialogid == HOUSE_MEDICINE_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Medicine yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMedicine]);
				ShowPlayerDialog(playerid, HOUSE_MEDICINE_WITHDRAW, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hMedicine])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Medicine tidak mencukupi!{ffffff}.\n\nMedicine yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMedicine]);
				ShowPlayerDialog(playerid, HOUSE_MEDICINE_WITHDRAW, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hMedicine] -= amount;
			pData[playerid][pMedicine] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d medicine dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MEDICINE, DIALOG_STYLE_LIST, "Medicine Storage", "Ambil Medicine dari penyimpanan\nSimpan Medicine ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_MEDICINE_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Medicine yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMedicine]);
				ShowPlayerDialog(playerid, HOUSE_MEDICINE_DEPOSIT, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMedicine])
			{
				new str[200];
				format(str, sizeof(str), "Error: {ff0000}Medicine anda tidak mencukupi!{ffffff}.\n\nMedicine yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMedicine]);
				ShowPlayerDialog(playerid, HOUSE_MEDICINE_DEPOSIT, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_MEDICINE) < hData[houseid][hMedicine] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Medicine!.\n\nMedicine yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_MEDICINE), pData[playerid][pMedicine]);
				ShowPlayerDialog(playerid, HOUSE_MEDICINE_DEPOSIT, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Simpan", "Kembali");
				return 1;
			}

			hData[houseid][hMedicine] += amount;
			pData[playerid][pMedicine] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d medicine ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MEDICINE, DIALOG_STYLE_LIST, "Medicine Storage", "Ambil Medicine dari penyimpanan\nSimpan Medicine ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//=======================================================[ MEDKIT HOME STORAGE]===============================================//
	if(dialogid == HOUSE_MEDKIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Medkit yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMedkit]);
					ShowPlayerDialog(playerid, HOUSE_MEDKIT_WITHDRAW, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Medkit yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pMedkit]);
					ShowPlayerDialog(playerid, HOUSE_MEDKIT_DEPOSIT, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Medicine\t({3BBD44}%d{ffffff}/%d)\nMedkit\t({3BBD44}%d{ffffff}/%d)\nBandage\t({3BBD44}%d{ffffff}/%d)", hData[houseid][hMedicine], GetHouseStorage(houseid, LIMIT_MEDICINE), hData[houseid][hMedkit], GetHouseStorage(houseid, LIMIT_MEDKIT), hData[houseid][hBandage], GetHouseStorage(houseid, LIMIT_BANDAGE));
			ShowPlayerDialog(playerid, HOUSE_DRUGS, DIALOG_STYLE_TABLIST, "Drugs Storage", string, "Pilih", "Kembali");
		}
		return 1;
	}
	if(dialogid == HOUSE_MEDKIT_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Medkit yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMedkit]);
				ShowPlayerDialog(playerid, HOUSE_MEDKIT_WITHDRAW, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hMedkit])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Medkit tidak mencukupi!{ffffff}.\n\nMedkit yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMedkit]);
				ShowPlayerDialog(playerid, HOUSE_MEDKIT_WITHDRAW, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hMedkit] -= amount;
			pData[playerid][pMedkit] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d medkit dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MEDKIT, DIALOG_STYLE_LIST, "Medkit Storage", "Ambil Medkit dari penyimpanan\nSimpan Medkit ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_MEDKIT_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Medkit yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMedkit]);
				ShowPlayerDialog(playerid, HOUSE_MEDKIT_DEPOSIT, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMedkit])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Medkit anda tidak mencukupi!{ffffff}.\n\nMedkit yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMedkit]);
				ShowPlayerDialog(playerid, HOUSE_MEDKIT_DEPOSIT, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_MEDKIT) < hData[houseid][hMedkit] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Medkit!.\n\nMedkit yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_MEDKIT), pData[playerid][pMedkit]);
				ShowPlayerDialog(playerid, HOUSE_MEDKIT_DEPOSIT, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Simpan", "Kembali");
				return 1;
			}

			hData[houseid][hMedkit] += amount;
			pData[playerid][pMedkit] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d medkit ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MEDKIT, DIALOG_STYLE_LIST, "Medkit Storage", "Ambil Medkit dari penyimpanan\nSimpan Medkit ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//=======================================================[ BANDAGE HOME STORAGE]===============================================//
	if(dialogid == HOUSE_BANDAGE)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Bandage yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda ambil dari penyimpanan:", hData[houseid][hBandage]);
					ShowPlayerDialog(playerid, HOUSE_BANDAGE_WITHDRAW, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Bandage yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pBandage]);
					ShowPlayerDialog(playerid, HOUSE_BANDAGE_DEPOSIT, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Medicine\t({3BBD44}%d{ffffff}/%d)\nMedkit\t({3BBD44}%d{ffffff}/%d)\nBandage\t({3BBD44}%d{ffffff}/%d)", hData[houseid][hMedicine], GetHouseStorage(houseid, LIMIT_MEDICINE), hData[houseid][hMedkit], GetHouseStorage(houseid, LIMIT_MEDKIT), hData[houseid][hBandage], GetHouseStorage(houseid, LIMIT_BANDAGE));
			ShowPlayerDialog(playerid, HOUSE_DRUGS, DIALOG_STYLE_TABLIST, "Drugs Storage", string, "Pilih", "Kembali");
		}
		return 1;
	}
	if(dialogid == HOUSE_BANDAGE_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Bandage yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda ambil dari penyimpanan:", hData[houseid][hBandage]);
				ShowPlayerDialog(playerid, HOUSE_BANDAGE_WITHDRAW, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hBandage])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Bandage tidak mencukupi!{ffffff}.\n\nBandage yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda ambil dari penyimpanan:", hData[houseid][hBandage]);
				ShowPlayerDialog(playerid, HOUSE_BANDAGE_WITHDRAW, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hBandage] -= amount;
			pData[playerid][pBandage] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d bandage dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_BANDAGE, DIALOG_STYLE_LIST, "Bandage Storage", "Ambil Bandage dari penyimpanan\nSimpan Bandage ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_BANDAGE_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Bandage yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pBandage]);
				ShowPlayerDialog(playerid, HOUSE_BANDAGE_DEPOSIT, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pBandage])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Bandage anda tidak mencukupi!{ffffff}.\n\nBandage yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pBandage]);
				ShowPlayerDialog(playerid, HOUSE_BANDAGE_DEPOSIT, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_BANDAGE) < hData[houseid][hBandage] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Bandage!.\n\nBandage yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_BANDAGE), pData[playerid][pBandage]);
				ShowPlayerDialog(playerid, HOUSE_BANDAGE_DEPOSIT, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Simpan", "Kembali");
				return 1;
			}

			hData[houseid][hBandage] += amount;
			pData[playerid][pBandage] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d bandage ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_BANDAGE, DIALOG_STYLE_LIST, "Bandage Storage", "Ambil Bandage dari penyimpanan\nSimpan Bandage ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//=====================================================[ OTHER HOME STORAGE ]=================================================//
	if(dialogid == HOUSE_OTHER)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, houseid)) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					ShowPlayerDialog(playerid, HOUSE_SEED, DIALOG_STYLE_LIST, "Seed Storage", "Ambil Seed dari penyimpanan\nSimpan Seed ke penyimpanan", "Pilih", "Kembali");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, HOUSE_MATERIAL, DIALOG_STYLE_LIST, "Material Storage", "Ambil Material dari penyimpanan\nSimpan Material dari penyimpanan", "Pilih", "Kembali");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, HOUSE_COMPONENT, DIALOG_STYLE_LIST, "Component Storage", "Ambil Component dari penyimpanan\nSimpan Component dari penyimpanan", "Pilih", "Kembali");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, HOUSE_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana Storage", "Ambil Marijuana dari penyimpanan\nSimpan Marijuana dari penyimpanan", "Pilih", "Kembali");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}	
	//=======================================================[ SEED HOME STORAGE]===============================================//
	if(dialogid == HOUSE_SEED)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Seed yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSeed]);
					ShowPlayerDialog(playerid, HOUSE_SEED_WITHDRAW, DIALOG_STYLE_INPUT, "Seed Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Seed yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pSeed]);
					ShowPlayerDialog(playerid, HOUSE_SEED_DEPOSIT, DIALOG_STYLE_INPUT, "Seed Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Seeds\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", hData[houseid][hSeed], GetHouseStorage(houseid, LIMIT_SEED), hData[houseid][hMaterial], GetHouseStorage(houseid, LIMIT_MATERIAL),  hData[houseid][hComponent], GetHouseStorage(houseid, LIMIT_COMPONENT), hData[houseid][hMarijuana], GetHouseStorage(houseid, LIMIT_MARIJUANA));
			ShowPlayerDialog(playerid, HOUSE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Pilih", "Kembali");
		}
		return 1;
	}
	if(dialogid == HOUSE_SEED_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Seed yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSeed]);
				ShowPlayerDialog(playerid, HOUSE_SEED_WITHDRAW, DIALOG_STYLE_INPUT, "Seed Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hSeed])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Seed tidak mencukupi!{ffffff}.\n\nSeed yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda ambil dari penyimpanan:", hData[houseid][hSeed]);
				ShowPlayerDialog(playerid, HOUSE_SEED_WITHDRAW, DIALOG_STYLE_INPUT, "Seed Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hSeed] -= amount;
			pData[playerid][pSeed] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d seed dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_SEED, DIALOG_STYLE_LIST, "Seed Storage", "Ambil Seed dari penyimpanan\nSimpan Seed ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_SEED_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Seed yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pSeed]);
				ShowPlayerDialog(playerid, HOUSE_SEED_DEPOSIT, DIALOG_STYLE_INPUT, "Seed Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pSeed])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Seed anda tidak mencukupi!{ffffff}.\n\nSeed yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pSeed]);
				ShowPlayerDialog(playerid, HOUSE_SEED_DEPOSIT, DIALOG_STYLE_INPUT, "Seed Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_SEED) < hData[houseid][hSeed] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Seed!.\n\nSeed yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_SEED), pData[playerid][pSeed]);
				ShowPlayerDialog(playerid, HOUSE_SEED_DEPOSIT, DIALOG_STYLE_INPUT, "Seed Storage", str, "Simpan", "Kembali");
				return 1;
			}

			hData[houseid][hSeed] += amount;
			pData[playerid][pSeed] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d seed ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_SEED, DIALOG_STYLE_LIST, "Seed Storage", "Ambil Seed dari penyimpanan\nSimpan Seed ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//=======================================================[ MATERIAL HOME STORAGE]===============================================//
	if(dialogid == HOUSE_MATERIAL)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Material yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMaterial]);
					ShowPlayerDialog(playerid, HOUSE_MATERIAL_WITHDRAW, DIALOG_STYLE_INPUT, "Material Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Material yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pMaterial]);
					ShowPlayerDialog(playerid, HOUSE_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, "Material Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Seeds\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", hData[houseid][hSeed], GetHouseStorage(houseid, LIMIT_SEED), hData[houseid][hMaterial], GetHouseStorage(houseid, LIMIT_MATERIAL),  hData[houseid][hComponent], GetHouseStorage(houseid, LIMIT_COMPONENT), hData[houseid][hMarijuana], GetHouseStorage(houseid, LIMIT_MARIJUANA));
			ShowPlayerDialog(playerid, HOUSE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Pilih", "Kembali");
		}
		return 1;
	}
	if(dialogid == HOUSE_MATERIAL_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Material yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMaterial]);
				ShowPlayerDialog(playerid, HOUSE_MATERIAL_WITHDRAW, DIALOG_STYLE_INPUT, "Material Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hMaterial])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Material tidak mencukupi!{ffffff}.\n\nMaterial yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMaterial]);
				ShowPlayerDialog(playerid, HOUSE_MATERIAL_WITHDRAW, DIALOG_STYLE_INPUT, "Material Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hMaterial] -= amount;
			pData[playerid][pMaterial] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d material dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MATERIAL, DIALOG_STYLE_LIST, "Material Storage", "Ambil Material dari penyimpanan\nSimpan Material ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_MATERIAL_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Material yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMaterial]);
				ShowPlayerDialog(playerid, HOUSE_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, "Material Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMaterial])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Material anda tidak mencukupi!{ffffff}.\n\nMaterial yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMaterial]);
				ShowPlayerDialog(playerid, HOUSE_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, "Material Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_MATERIAL) < hData[houseid][hMaterial] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Material!.\n\nMaterial yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_MATERIAL), pData[playerid][pMaterial]);
				ShowPlayerDialog(playerid, HOUSE_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, "Material Storage", str, "Simpan", "Kembali");
				return 1;
			}

			hData[houseid][hMaterial] += amount;
			pData[playerid][pMaterial] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d material ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MATERIAL, DIALOG_STYLE_LIST, "Material Storage", "Ambil Material dari penyimpanan\nSimpan Material ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//=======================================================[ COMPONENT HOME STORAGE]===============================================//
	if(dialogid == HOUSE_COMPONENT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Component yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda ambil dari penyimpanan:", hData[houseid][hComponent]);
					ShowPlayerDialog(playerid, HOUSE_COMPONENT_WITHDRAW, DIALOG_STYLE_INPUT, "Component Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Component yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pComponent]);
					ShowPlayerDialog(playerid, HOUSE_COMPONENT_DEPOSIT, DIALOG_STYLE_INPUT, "Component Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Seeds\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", hData[houseid][hSeed], GetHouseStorage(houseid, LIMIT_SEED), hData[houseid][hMaterial], GetHouseStorage(houseid, LIMIT_MATERIAL),  hData[houseid][hComponent], GetHouseStorage(houseid, LIMIT_COMPONENT), hData[houseid][hMarijuana], GetHouseStorage(houseid, LIMIT_MARIJUANA));
			ShowPlayerDialog(playerid, HOUSE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Pilih", "Kembali");
		}
		return 1;
	}
	if(dialogid == HOUSE_COMPONENT_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Component yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda ambil dari penyimpanan:", hData[houseid][hComponent]);
				ShowPlayerDialog(playerid, HOUSE_COMPONENT_WITHDRAW, DIALOG_STYLE_INPUT, "Component Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hComponent])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Component tidak mencukupi!{ffffff}.\n\nComponent yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda ambil dari penyimpanan:", hData[houseid][hComponent]);
				ShowPlayerDialog(playerid, HOUSE_COMPONENT_WITHDRAW, DIALOG_STYLE_INPUT, "Component Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hComponent] -= amount;
			pData[playerid][pComponent] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d component dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_COMPONENT, DIALOG_STYLE_LIST, "Component Storage", "Ambil Component dari penyimpanan\nSimpan Component ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_COMPONENT_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Component yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pComponent]);
				ShowPlayerDialog(playerid, HOUSE_COMPONENT_DEPOSIT, DIALOG_STYLE_INPUT, "Component Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pComponent])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Component anda tidak mencukupi!{ffffff}.\n\nComponent yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pComponent]);
				ShowPlayerDialog(playerid, HOUSE_COMPONENT_DEPOSIT, DIALOG_STYLE_INPUT, "Component Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_COMPONENT) < hData[houseid][hComponent] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Component!.\n\nComponent yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_COMPONENT), pData[playerid][pComponent]);
				ShowPlayerDialog(playerid, HOUSE_COMPONENT_DEPOSIT, DIALOG_STYLE_INPUT, "Component Storage", str, "Simpan", "Kembali");
				return 1;
			}

			hData[houseid][hComponent] += amount;
			pData[playerid][pComponent] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d component ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_COMPONENT, DIALOG_STYLE_LIST, "Component Storage", "Ambil Component dari penyimpanan\nSimpan Component ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//=======================================================[ MARIJUANA HOME STORAGE]===============================================//
	if(dialogid == HOUSE_MARIJUANA)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			switch (listitem)
			{
				case 0: 
				{
					new str[128];
					format(str, sizeof(str), "Marijuana yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMarijuana]);
					ShowPlayerDialog(playerid, HOUSE_MARIJUANA_WITHDRAW, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Ambil", "Kembali");
				}
				case 1: 
				{
					new str[128];
					format(str, sizeof(str), "Marijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan rumah:", pData[playerid][pMarijuana]);
					ShowPlayerDialog(playerid, HOUSE_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Simpan", "Kembali");
				}
			}
		}
		else 
		{
			new string[200];
			format(string, sizeof(string), "Seeds\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", hData[houseid][hSeed], GetHouseStorage(houseid, LIMIT_SEED), hData[houseid][hMaterial], GetHouseStorage(houseid, LIMIT_MATERIAL),  hData[houseid][hComponent], GetHouseStorage(houseid, LIMIT_COMPONENT), hData[houseid][hMarijuana], GetHouseStorage(houseid, LIMIT_MARIJUANA));
			ShowPlayerDialog(playerid, HOUSE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Pilih", "Kembali");
		}
		return 1;
	}
	if(dialogid == HOUSE_MARIJUANA_WITHDRAW)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Marijuana yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMarijuana]);
				ShowPlayerDialog(playerid, HOUSE_MARIJUANA_WITHDRAW, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Ambil", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hMarijuana])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Marijuana tidak mencukupi!{ffffff}.\n\nMarijuana yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda ambil dari penyimpanan:", hData[houseid][hMarijuana]);
				ShowPlayerDialog(playerid, HOUSE_MARIJUANA_WITHDRAW, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Ambil", "Kembali");
				return 1;
			}
			hData[houseid][hMarijuana] -= amount;
			pData[playerid][pMarijuana] += amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d marijuana dari penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana Storage", "Ambil Marijuana dari penyimpanan\nSimpan Marijuana ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	if(dialogid == HOUSE_MARIJUANA_DEPOSIT)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return ErrorMsg(playerid, "Ini bukan rumah anda!.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Marijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMarijuana]);
				ShowPlayerDialog(playerid, HOUSE_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMarijuana])
			{
				new str[128];
				format(str, sizeof(str), "Error: {ff0000}Marijuana anda tidak mencukupi!{ffffff}.\n\nMarijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMarijuana]);
				ShowPlayerDialog(playerid, HOUSE_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Simpan", "Kembali");
				return 1;
			}
			if(GetHouseStorage(houseid, LIMIT_MARIJUANA) < hData[houseid][hMarijuana] + amount)
			{
				new str[200];
				format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Marijuana!.\n\nMarijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan:", GetHouseStorage(houseid, LIMIT_MARIJUANA), pData[playerid][pMarijuana]);
				ShowPlayerDialog(playerid, HOUSE_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Simpan", "Kembali");
				return 1;
			}

			hData[houseid][hMarijuana] += amount;
			pData[playerid][pMarijuana] -= amount;

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d marijuana ke penyimpanan rumah.", ReturnName(playerid), amount);
		}
		else ShowPlayerDialog(playerid, HOUSE_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana Storage", "Ambil Marijuana dari penyimpanan\nSimpan Marijuana ke penyimpanan", "Pilih", "Kembali");
		return 1;
	}
	//------------[ Private Player Vehicle Dialog ]--------
	/*if(dialogid == DIALOG_FINDVEH)
	{
		if(response) 
		{
			foreach(new i : PVehicles)
			{
				if(pvData[i][cOwner] == pData[playerid][pID])
				{
					if(pvData[i][cPark] != -1)
					{
						ShowPlayerDialog(playerid, DIALOG_TRACKPARKEDVEH, DIALOG_STYLE_LIST, "Find Parked Vehicle", "Track Vehicle\nInfo Vehicle:", "Pilih", "Tutup");
					}
					else 
					{
						ShowPlayerDialog(playerid, DIALOG_TRACKVEH, DIALOG_STYLE_INPUT, "Find Veh", "Enter your own vehicle id:", "Find", "Tutup");
					}	
				}		
			}	
		}
		return 1;
	}*/
	if(dialogid == DIALOG_FINDVEH)
	{
		if(response)
		{
			ShowPlayerDialog(playerid, DIALOG_TRACKVEH, DIALOG_STYLE_LIST, "Vehicle", "Track Vehicle\nInfo Vehicle:", "Pilih", "Tutup");
		}
	}
	if(dialogid == DIALOG_TRACKVEH)
	{
		if(response) 
		{	
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_TRACKVEH, DIALOG_STYLE_INPUT, "Find Veh", "Enter your own vehicle id:", "Find", "Tutup");
				}	
				case 1:
				{
					Info(playerid, "Masih Proses Suhu");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TRACKVEH2)
	{
		if(response)
		{
			new Float:posisiX, Float:posisiY, Float:posisiZ,
			carid = strval(inputtext);
					
			foreach(new veh : PVehicles)
			{
				if(pvData[veh][cVeh] == carid)
				{
					if(IsValidVehicle(pvData[veh][cVeh]))
					{
						if(pvData[veh][cOwner] == pData[playerid][pID])
						{
							GetVehiclePos(carid, posisiX, posisiY, posisiZ);
							pData[playerid][pTrackCar] = 1;
							//SetPlayerCheckpoint(playerid, posisi[0], posisi[1], posisi[2], 4.0);
							SetPlayerRaceCheckpoint(playerid,1, posisiX, posisiY, posisiZ, 0.0, 0.0, 0.0, 3.5);
							Info(playerid, "Your car waypoint was set to \"%s\" (marked on radar).", GetLocation(posisiX, posisiY, posisiZ));
						}
						else return ErrorMsg(playerid, "Id kendaraan ini bukan milik anda!");
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_TRACKPARKEDVEH)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					Info(playerid, "Oke Bro");
				}
				case 1:
				{
					Info(playerid, "Oke Bro2");
				}
			}
		}
	}
	if(dialogid == DIALOG_CONTAINER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0://Ocean Dock 1
				{
					if(pData[playerid][pJobTime] > 0)
					{
					    new str[500];
					    format(str,sizeof(str),"Anda masih mempunyai delays job untuk %d Detik", pData[playerid][pJobTime]);
						ErrorMsg(playerid, str);
						return 1;
					}

				    if(DialogHauling[0] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[0] = true; // Dialog 0 telah di pilih
					    DialogSaya[playerid][0] = true;
						SendClientMessage(playerid, COLOR_ARWIN,"CONTAINER: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -591.8328, -550.5755, 25.5296, 0.0, 0.0, 0.0, 10.0);
						pData[playerid][pSedangContainer] = 1;
					}
					else
					    ErrorMsg(playerid, "Container Missions already taken by Someone");
				}
				case 1://Ocean Dock 1
				{
					if(pData[playerid][pJobTime] > 0)
					{
						new str[500];
					    format(str,sizeof(str),"Anda masih mempunyai delays job untuk %d Detik", pData[playerid][pJobTime]);
						ErrorMsg(playerid, str);
						return 1;
					}

				    if(DialogHauling[1] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[1] = true; // Dialog 0 telah di pilih
					    DialogSaya[playerid][1] = true;
						SendClientMessage(playerid, COLOR_ARWIN,"CONTAINER: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -591.8328, -550.5755, 25.5296, 0.0, 0.0, 0.0, 10.0);
						pData[playerid][pSedangContainer] = 3;
					}
					else
					    ErrorMsg(playerid, "Container Missions already taken by Someone");
				}
				case 2://Ocean Dock 1
				{
					if(pData[playerid][pJobTime] > 0)
					{
						new str[500];
					    format(str,sizeof(str),"Anda masih mempunyai delays job untuk %d Detik", pData[playerid][pJobTime]);
						ErrorMsg(playerid, str);
						return 1;
					}

				    if(DialogHauling[2] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[2] = true; // Dialog 0 telah di pilih
					    DialogSaya[playerid][2] = true;
						SendClientMessage(playerid, COLOR_ARWIN,"CONTAINER: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -591.8328, -550.5755, 25.5296, 0.0, 0.0, 0.0, 10.0);
						pData[playerid][pSedangContainer] = 5;
					}
					else
					    ErrorMsg(playerid, "Container Missions already taken by Someone");
				}
				case 3://Ocean Dock 1
				{
					if(pData[playerid][pJobTime] > 0)
					{
						new str[500];
					    format(str,sizeof(str),"Anda masih mempunyai delays job untuk %d Detik", pData[playerid][pJobTime]);
						ErrorMsg(playerid, str);
						return 1;
					}

				    if(DialogHauling[3] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[3] = true; // Dialog 0 telah di pilih
					    DialogSaya[playerid][3] = true;
						SendClientMessage(playerid, COLOR_ARWIN,"CONTAINER: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -591.8328, -550.5755, 25.5296, 0.0, 0.0, 0.0, 10.0);
						pData[playerid][pSedangContainer] = 7;
					}
					else
					    ErrorMsg(playerid, "Container Missions already taken by Someone");
				}
				case 4://Ocean Dock 1
				{
					if(pData[playerid][pJobTime] > 0)
					{
						new str[500];
					    format(str,sizeof(str),"Anda masih mempunyai delays job untuk %d Detik", pData[playerid][pJobTime]);
						ErrorMsg(playerid, str);
						return 1;
					}

				    if(DialogHauling[4] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[4] = true; // Dialog 0 telah di pilih
					    DialogSaya[playerid][4] = true;
						SendClientMessage(playerid, COLOR_ARWIN,"CONTAINER: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -591.8328, -550.5755, 25.5296, 0.0, 0.0, 0.0, 10.0);
						pData[playerid][pSedangContainer] = 9;
					}
					else
					    ErrorMsg(playerid, "Container Missions already taken by Someone");
				}
				case 5://Ocean Dock 1
				{
					if(pData[playerid][pJobTime] > 0)
					{
                        new str[500];
					    format(str,sizeof(str),"Anda masih mempunyai delays job untuk %d Detik", pData[playerid][pJobTime]);
						ErrorMsg(playerid, str);
						return 1;
					}

				    if(DialogHauling[5] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[5] = true; // Dialog 0 telah di pilih
					    DialogSaya[playerid][5] = true;
						SendClientMessage(playerid, COLOR_ARWIN,"CONTAINER: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -591.8328, -550.5755, 25.5296, 0.0, 0.0, 0.0, 10.0);
						pData[playerid][pSedangContainer] = 11;
					}
					else
					    ErrorMsg(playerid, "Container Missions already taken by Someone");
				}
				case 6://Ocean Dock 1
				{
					if(pData[playerid][pJobTime] > 0)
					{
						new str[500];
					    format(str,sizeof(str),"Anda masih mempunyai delays job untuk %d Detik", pData[playerid][pJobTime]);
						ErrorMsg(playerid, str);
						return 1;
					}

				    if(DialogHauling[6] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[6] = true; // Dialog 0 telah di pilih
					    DialogSaya[playerid][6] = true;
						SendClientMessage(playerid, COLOR_ARWIN,"CONTAINER: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -591.8328, -550.5755, 25.5296, 0.0, 0.0, 0.0, 10.0);
						pData[playerid][pSedangContainer] = 13;
					}
					else
					    ErrorMsg(playerid, "Container Missions already taken by Someone");
				}
			}
		}
	}
	if(dialogid == DIALOG_GOTOVEH)
	{
		if(response) 
		{
			new Float:posisiX, Float:posisiY, Float:posisiZ,
				carid = strval(inputtext);
			
			GetVehiclePos(carid, posisiX, posisiY, posisiZ);
			Servers(playerid, "Your teleport to %s (vehicle id: %d).", GetLocation(posisiX, posisiY, posisiZ), carid);
			SetPlayerPosition(playerid, posisiX, posisiY, posisiZ+3.0, 4.0, 0);
		}
		return 1;
	}
	if(dialogid == DIALOG_GETVEH)
	{
		if(response) 
		{
			new Float:posisiX, Float:posisiY, Float:posisiZ,
				carid = strval(inputtext);
			
			GetPlayerPos(playerid, posisiX, posisiY, posisiZ);
			Servers(playerid, "Your get spawn vehicle to %s (vehicle id: %d).", GetLocation(posisiX, posisiY, posisiZ), carid);
			SetVehiclePos(carid, posisiX, posisiY, posisiZ+0.5);
		}
		return 1;
	}
	if(dialogid == DIALOG_DELETEVEH)
	{
		if(response) 
		{
			new carid = strval(inputtext);
			
			//for(new i = 0; i != MAX_PRIVATE_VEHICLE; i++) if(Iter_Contains(PVehicles, i))
			foreach(new i : PVehicles)			
			{
				if(carid == pvData[i][cVeh])
				{
					new query[128];
					mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[i][cID]);
					mysql_tquery(g_SQL, query);
					DestroyVehicle(pvData[i][cVeh]);
					pvData[i][cVeh] = INVALID_VEHICLE_ID;
					Iter_SafeRemove(PVehicles, i, i);
					Servers(playerid, "Your deleted private vehicle id %d (database id: %d).", pvData[i][cVeh], pvData[i][cID]);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_BUYPLATE)
	{
		if(response) 
		{
			new carid = strval(inputtext);
			
			//for(new i = 0; i != MAX_PRIVATE_VEHICLE; i++) if(Iter_Contains(PVehicles, i))
			foreach(new i : PVehicles)
			{
				if(carid == pvData[i][cVeh])
				{
					if(GetPlayerMoney(playerid) < 500) return ErrorMsg(playerid, "Anda butuh $500 untuk membeli Plate baru.");
					GivePlayerMoneyEx(playerid, -500);
					new rand = RandomEx(1111, 9999);
					format(pvData[i][cPlate], 32, "NRP-%d", rand);
					SetVehicleNumberPlate(pvData[i][cVeh], pvData[i][cPlate]);
					pvData[i][cPlateTime] = gettime() + (15 * 86400);
					Info(playerid, "Model: %s || New plate: %s || Plate Time: %s || Plate Price: $500", GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cPlateTime]));
				}
			}
		}
		return 1;
	}
	//--------------[ Player Toy Dialog ]-------------
	if(dialogid == DIALOG_GOJEK)
    {
		if(response)
		{
		    new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
            SendFactionMessage(6, COLOR_GREEN, "[GoJek] "WHITE_E"Orderan masuk atas nama %s", ReturnName(playerid));
	    	SendFactionMessage(6, COLOR_WHITE, "[Details] No.HP: %d // Lokasi: %s - Tujuan: %s", pData[playerid][pPhone], GetLocation(x, y, z), inputtext);
			Info(playerid, "Orderan telah di kirim ke driver yang sedang on duty");
		}
	}
	if(dialogid == DIALOG_GOCAR)
    {
		if(response)
		{
		    new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
            SendFactionMessage(6, COLOR_GREEN, "[GoCar] "WHITE_E"Orderan masuk atas nama %s", ReturnName(playerid));
			SendFactionMessage(6, COLOR_WHITE, "[Details] No.HP: %d // Lokasi: %s - Tujuan: %s", pData[playerid][pPhone], GetLocation(x, y, z), inputtext);
			Info(playerid, "Orderan telah di kirim ke driver yang sedang on duty");
		}
	}
	if(dialogid == DIALOG_GOFOOD)
    {
		if(response)
		{
		    new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
            SendFactionMessage(6, COLOR_GREEN, "[GoFood] "WHITE_E"Orderan masuk atas nama %s", ReturnName(playerid));
	    	SendFactionMessage(6, COLOR_WHITE, "[Pesanan] %s", inputtext);
	    	SendFactionMessage(6, COLOR_WHITE, "[Details] No.HP: %d // Tujuan: %s", pData[playerid][pPhone], GetLocation(x, y, z));
			Info(playerid, "Orderan telah di kirim ke driver yang sedang on duty");
		}
	}
    if(dialogid == DIALOG_TOY)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					new status[20];
					if(pToys[playerid][0][toy_status] != 1)
					{
						status = "{ff0000}Hide";
					}
					else
					{
						status = "{3BBD44}Show";
					}

					pData[playerid][toySelected] = 0;
					if(pToys[playerid][0][toy_model] == 0)
					{
						//ShowPlayerSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Edit Toy Coordinat(Android)\n"dot"Change Bone\n"dot"%s {ffffff}Toys\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", status);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					new status[20];
					if(pToys[playerid][1][toy_status] != 1)
					{
						status = "{ff0000}Hide";
					}
					else
					{
						status = "{3BBD44}Show";
					}

					pData[playerid][toySelected] = 1;
					if(pToys[playerid][1][toy_model] == 0)
					{
						//ShowPlayerSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Edit Toy Coordinat(Android)\n"dot"Change Bone\n"dot"%s {ffffff}Toys\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", status);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					new status[20];
					if(pToys[playerid][2][toy_status] == 1)
					{
						status = "{ff0000}Hide";
					}
					else
					{
						status = "{3BBD44}Show";
					}

					pData[playerid][toySelected] = 2;
					if(pToys[playerid][2][toy_model] == 0)
					{
						//ShowPlayerSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Edit Toy Coordinat(Android)\n"dot"Change Bone\n"dot"%s {ffffff}Toys\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", status);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					new status[20];
					if(pToys[playerid][3][toy_status] == 1)
					{
						status = "{ff0000}Hide";
					}
					else
					{
						status = "{3BBD44}Show";
					}

					pData[playerid][toySelected] = 3;
					if(pToys[playerid][3][toy_model] == 0)
					{
						//ShowPlayerSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Edit Toy Coordinat(Android)\n"dot"Change Bone\n"dot"%s {ffffff}Toys\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", status);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}
				case 4:
				{
					if(pData[playerid][PurchasedToy] == true)
					{
						for(new i = 0; i < 4; i++)
						{
							pToys[playerid][i][toy_model] = 0;
							pToys[playerid][i][toy_bone] = 1;
							pToys[playerid][i][toy_status] = 1;
							pToys[playerid][i][toy_x] = 0.0;
							pToys[playerid][i][toy_y] = 0.0;
							pToys[playerid][i][toy_z] = 0.0;
							pToys[playerid][i][toy_rx] = 0.0;
							pToys[playerid][i][toy_ry] = 0.0;
							pToys[playerid][i][toy_rz] = 0.0;
							pToys[playerid][i][toy_sx] = 1.0;
							pToys[playerid][i][toy_sy] = 1.0;
							pToys[playerid][i][toy_sz] = 1.0;

							if(IsPlayerAttachedObjectSlotUsed(playerid, i))
							{
								RemovePlayerAttachedObject(playerid, i);
							}
						}
						new string[128];
						mysql_format(g_SQL, string, sizeof(string), "DELETE FROM toys WHERE Owner = '%s'", pData[playerid][pName]);
						mysql_tquery(g_SQL, string);
						pData[playerid][PurchasedToy] = false;
						GameTextForPlayer(playerid, "~r~~h~All Toy Rested!~y~!", 3000, 4);
					}
				}
				/*case 4: //slot 5
				{
					pData[playerid][toySelected] = 4;
					if(pToys[playerid][4][toy_model] == 0)
					{
						//ShowPlayerSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}
				case 5: //slot 6
				{
					pData[playerid][toySelected] = 5;
					if(pToys[playerid][5][toy_model] == 0)
					{
						//ShowPlayerSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
						//ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos", "Select", "Cancel");
					}
				}*/
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYEDIT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // edit
				{
					//if(IsPlayerAndroid(playerid))
					//	return Error(playerid, "You're connected from android. This feature only for PC users!");

					EditAttachedObject(playerid, pData[playerid][toySelected]);
					InfoTD_MSG(playerid, 4000, "~b~~h~You are now editing your toy.");
				}
				case 1:
				{
					new string[750];
					format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
					pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
					pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
					pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
					ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
				}
				case 2: // change bone
				{
					new finstring[750];

					strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
					strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");

					ShowPlayerDialog(playerid, DIALOG_TOYPOSISI, DIALOG_STYLE_LIST, ""RED_E"ZARP RP: "WHITE_E"Player Toys", finstring, "Select", "Cancel");
				}
				case 3:
				{
					if(pToys[playerid][pData[playerid][toySelected]][toy_status] == 1)
					{
						if(IsPlayerAttachedObjectSlotUsed(playerid, pData[playerid][toySelected]))
						{
							RemovePlayerAttachedObject(playerid, pData[playerid][toySelected]);
						}
						pToys[playerid][pData[playerid][toySelected]][toy_status] = 0;
						InfoTD_MSG(playerid, 4000, "Toys ~r~hiden.");
					}
					else
					{
						SetPlayerAttachedObject(playerid,
							pData[playerid][toySelected],
							pToys[playerid][pData[playerid][toySelected]][toy_model],
							pToys[playerid][pData[playerid][toySelected]][toy_bone],
							pToys[playerid][pData[playerid][toySelected]][toy_x],
							pToys[playerid][pData[playerid][toySelected]][toy_y],
							pToys[playerid][pData[playerid][toySelected]][toy_z],
							pToys[playerid][pData[playerid][toySelected]][toy_rx],
							pToys[playerid][pData[playerid][toySelected]][toy_ry],
							pToys[playerid][pData[playerid][toySelected]][toy_rz],
							pToys[playerid][pData[playerid][toySelected]][toy_sx],
							pToys[playerid][pData[playerid][toySelected]][toy_sy],
							pToys[playerid][pData[playerid][toySelected]][toy_sz]);

						SetPVarInt(playerid, "UpdatedToy", 1);
						pToys[playerid][pData[playerid][toySelected]][toy_status] = 1;
						InfoTD_MSG(playerid, 4000, "Toys ~g~showed.");
					}
				}
				case 4: // remove toy
				{
					if(IsPlayerAttachedObjectSlotUsed(playerid, pData[playerid][toySelected]))
					{
						RemovePlayerAttachedObject(playerid, pData[playerid][toySelected]);
					}
					pToys[playerid][pData[playerid][toySelected]][toy_model] = 0;
					GameTextForPlayer(playerid, "~r~~h~Toy Removed~y~!", 3000, 4);
					SetPVarInt(playerid, "UpdatedToy", 1);
					TogglePlayerControllable(playerid, true);
				}
				case 5:	//share toy pos
				{
					SendNearbyMessage(playerid, 10.0, COLOR_GREEN, "[TOY BY %s] "WHITE_E"PosX: %.3f | PosY: %.3f | PosZ: %.3f | PosRX: %.3f | PosRY: %.3f | PosRZ: %.3f",
					ReturnName(playerid), pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
					pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
				}
			}
		}
		else
		{
			new string[350];
			if(pToys[playerid][0][toy_model] == 0)
			{
				strcat(string, ""dot"Slot 1\n");
			}
			else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

			if(pToys[playerid][1][toy_model] == 0)
			{
				strcat(string, ""dot"Slot 2\n");
			}
			else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

			if(pToys[playerid][2][toy_model] == 0)
			{
				strcat(string, ""dot"Slot 3\n");
			}
			else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

			if(pToys[playerid][3][toy_model] == 0)
			{
				strcat(string, ""dot"Slot 4\n");
			}
			else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");

			strcat(string, ""dot""RED_E"Reset Toys");

			ShowPlayerDialog(playerid, DIALOG_TOY, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYEDIT_ANDROID)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //Pos X
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosX: %f\nInput new Toy PosX:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_x]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSX, DIALOG_STYLE_INPUT, "Toy PosX", mstr, "Edit", "Cancel");
				}
				case 1: //Pos Y
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosY: %f\nInput new Toy PosY:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_y]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSY, DIALOG_STYLE_INPUT, "Toy PosY", mstr, "Edit", "Cancel");
				}
				case 2: //Pos Z
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosZ: %f\nInput new Toy PosZ:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_z]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSZ, DIALOG_STYLE_INPUT, "Toy PosZ", mstr, "Edit", "Cancel");
				}
				case 3: //Pos RX
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRX: %f\nInput new Toy PosRX:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_rx]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSRX, DIALOG_STYLE_INPUT, "Toy PosRX", mstr, "Edit", "Cancel");
				}
				case 4: //Pos RY
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRY: %f\nInput new Toy PosRY:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_ry]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSRY, DIALOG_STYLE_INPUT, "Toy PosRY", mstr, "Edit", "Cancel");
				}
				case 5: //Pos RZ
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRZ: %f\nInput new Toy PosRZ:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_rz]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSRZ, DIALOG_STYLE_INPUT, "Toy PosRZ", mstr, "Edit", "Cancel");
				}
				case 6: //Pos ScaleX
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy ScaleX: %f\nInput new Toy ScaleX:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_sx]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSSX, DIALOG_STYLE_INPUT, "Toy ScaleX", mstr, "Edit", "Cancel");
				}
				case 7: //Pos ScaleY
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy ScaleY: %f\nInput new Toy ScaleY:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_sy]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSSY, DIALOG_STYLE_INPUT, "Toy ScaleY", mstr, "Edit", "Cancel");
				}
				case 8: //Pos ScaleZ
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy ScaleZ: %f\nInput new Toy ScaleZ:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_sz]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSSZ, DIALOG_STYLE_INPUT, "Toy ScaleZ", mstr, "Edit", "Cancel");
				}
			}
		}
		else
		{
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Edit Toy Coordinat(Android)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos");
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSISI)
	{
		if(response)
		{
			listitem++;
			pToys[playerid][pData[playerid][toySelected]][toy_bone] = listitem;
			if(IsPlayerAttachedObjectSlotUsed(playerid, pData[playerid][toySelected]))
			{
				RemovePlayerAttachedObject(playerid, pData[playerid][toySelected]);
			}
			listitem = pData[playerid][toySelected];
			SetPlayerAttachedObject(playerid,
					listitem,
					pToys[playerid][listitem][toy_model],
					pToys[playerid][listitem][toy_bone],
					pToys[playerid][listitem][toy_x],
					pToys[playerid][listitem][toy_y],
					pToys[playerid][listitem][toy_z],
					pToys[playerid][listitem][toy_rx],
					pToys[playerid][listitem][toy_ry],
					pToys[playerid][listitem][toy_rz],
					pToys[playerid][listitem][toy_sx],
					pToys[playerid][listitem][toy_sy],
					pToys[playerid][listitem][toy_sz]);
			GameTextForPlayer(playerid, "~g~~h~Bone Changed~y~!", 3000, 4);
			SetPVarInt(playerid, "UpdatedToy", 1);
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYPOSISIBUY)
	{
		if(response)
		{
			listitem++;
			pToys[playerid][pData[playerid][toySelected]][toy_bone] = listitem;
			SetPlayerAttachedObject(playerid, pData[playerid][toySelected], pToys[playerid][pData[playerid][toySelected]][toy_model], listitem);
			//EditAttachedObject(playerid, pData[playerid][toySelected]);
			InfoTD_MSG(playerid, 5000, "~g~~h~Object Attached!~n~~w~Adjust the position than click on the save icon!");
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYBUY)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					pData[playerid][toySelected] = 0;
					if(pToys[playerid][0][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					pData[playerid][toySelected] = 1;
					if(pToys[playerid][1][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					pData[playerid][toySelected] = 2;
					if(pToys[playerid][2][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					pData[playerid][toySelected] = 3;
					if(pToys[playerid][3][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 4: //slot 5
				{
					pData[playerid][toySelected] = 4;
					if(pToys[playerid][4][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 5: //slot 6
				{
					pData[playerid][toySelected] = 5;
					if(pToys[playerid][5][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYVIP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					pData[playerid][toySelected] = 0;
					if(pToys[playerid][0][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					pData[playerid][toySelected] = 1;
					if(pToys[playerid][1][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					pData[playerid][toySelected] = 2;
					if(pToys[playerid][2][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					pData[playerid][toySelected] = 3;
					if(pToys[playerid][3][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 4: //slot 5
				{
					pData[playerid][toySelected] = 4;
					if(pToys[playerid][4][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 5: //slot 6
				{
					pData[playerid][toySelected] = 5;
					if(pToys[playerid][5][toy_model] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYPOSX)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);

			pToys[playerid][pData[playerid][toySelected]][toy_x] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);

			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSY)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);

			pToys[playerid][pData[playerid][toySelected]][toy_y] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);

			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSZ)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);

			pToys[playerid][pData[playerid][toySelected]][toy_z] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);

			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSRX)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);

			pToys[playerid][pData[playerid][toySelected]][toy_rx] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);

			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSRY)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);

			pToys[playerid][pData[playerid][toySelected]][toy_ry] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);

			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSRZ)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);

			pToys[playerid][pData[playerid][toySelected]][toy_rz] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);

			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}

	}
	if(dialogid == DIALOG_TOYPOSSX)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);

			pToys[playerid][pData[playerid][toySelected]][toy_sx] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);

			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSSY)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);

			pToys[playerid][pData[playerid][toySelected]][toy_sy] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);

			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSSZ)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				posisi);

			pToys[playerid][pData[playerid][toySelected]][toy_sz] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);

			new string[750];
			format(string, sizeof(string), "PosX: %f\nPosY: %f\nPosZ: %f\nRotX: %f\nRotY: %f\nRotZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT_ANDROID, DIALOG_STYLE_LIST, ""WHITE_E"Setting Coordinat Toys", string, "Select", "Cancel");
		}
	}
	//-----------[ Player Commands Dialog ]----------
	if(dialogid == DIALOG_HELP)
    {
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				new str[3500];
				strcat(str, "Keys\tPenjelasan\nAlt\t-> Sebagai tombol aksi\nN\t-> Sebagai tombol menyalakan mesin kendaraan\nH (klakson di android saat di dalam mobil)\t-> Untuk membuka radial menu Executive");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Hotkeys", str, "Tutup", "");
			}
			case 1:
			{
				new str[3500];
				strcat(str, "Tipe\tPenyelesaian\nLapar\t-> Memakan makanan seperti snack,kebab,dan lain lain\nHaus\t-> Meminum Water,starling,milxmax\nStress\t-> Pergi ke pantai");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Hbe System", str, "Tutup", "");
			}
			case 2:
			{
				new str[3500];
				strcat(str, "Perintah\tPenjelasan\n/h\t-> Untuk membuka ponsel\n/hbemode\t-> Untuk mengganti hbe\n/stats\t-> tUntuk melihat statistik karakter anda\n/i\t-> Untuk membuka inventory\n/b\t-> Mengirim local yang bersifat OOC\n/report\t-> Melaporkan bug/player kepada Administrator\n/ask\t-> mengirim pertanyaan kepada administrator\n/stopanim\t-> Menghentikan animasi");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Perintah Dasar", str, "Tutup", "");
			}
			case 3:
			{
				new line3[500];
				strcat(line3, "Perintah\tPenjelasan\n/myv\t-> Untuk melihat list kendaraan yang anda miliki\n/vrm\t-> Untuk membuka vehicle radial menu\n/lights\t-> Untuk menyalakan lampu kendaraan\n/engine atau N\t-> Untuk menyalakan mesin\n/Hood\t-> Untuk membuka hood\n/Trunk\t-> Untuk membuka bagasi kendaraan\n/lock\t-> Untuk mengunci pintu kendaraan");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Perintah Kendaraan", line3, "Tutup", "");
				return 1;
			}
			case 4:
			{
				return callcmd::factionhelp(playerid);
			}
			case 5:
			{
				new str[3500];
				strcat(str, "Perintah\tPenjelasan\n/buy\t-> Untuk membeli rumah\n/sellhouse\t-> Untuk menjual rumah kepada pemerintah\n/lockhouse\t-> Untuk mengunci rumah anda\n/unlockhouse\t-> Untuk membuka pintu rumah\n/myhouse\t-> Untuk melihat rumah yang anda miliki\n/givehouse\t-> Untuk memberikan rumah kepada pemain lain\n/hm\t-> Untuk membuka lemari");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Perintah Rumah", str, "Tutup", "");
			}
			case 6:
			{
				new str[3500];
				strcat(str, "Perintah\tPenjelasan\n/buy\t-> Untuk membeli barang di bisnis\n/bm\t-> Untuk melihat menu bisnis\n/lockbisnis\t-> Untuk mengunci bisnis\n/unlockbisnis\t-> Untuk membuka bisnis\n/mybis\t-> Untuk melihat bisnis yang anda miliki");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Perintah Bisnis", str, "Tutup", "");
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_JOB)
    {
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Unity Station\n\n{7fffd4}CMDS: /taxiduty /fare\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Taxi Job", str, "Tutup", "");
			}
			case 1:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Idlewood\n\n{7fffd4}CMDS: /mechduty /service\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Mechanic Job", str, "Tutup", "");
			}
			case 2:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini khusus untuk Lumber Profesional\n\n{7fffd4}CMDS: /(lum)ber\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Lumber Job", str, "Tutup", "");
			}
			case 3:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Flint Country\n\n{7fffd4}CMDS: /mission /storeproduct /storegas /storestock /gps\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Trucker Job", str, "Tutup", "");
			}
			case 4:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Las Venturas\n\n{7fffd4}CMDS: /ore\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Miner Job", str, "Tutup", "");
			}
			case 5:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Flint Country arah Angel Pine\n\n{7fffd4}CMDS: /createproduct /sellproduct\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Production Job", str, "Tutup", "");
			}
			case 6:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Flint Country\n\n{7fffd4}CMDS: /plant /price /offer\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Farmer Job", str, "Tutup", "");
			}
			case 7:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Market\n\n{7fffd4}CMDS: /startkurir /stopkurir /angkatbox\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Courier Job", str, "Tutup", "");
			}
			case 8:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Bandara Los Santos\n\n{7fffd4}CMDS: /startbg\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Baggage Job", str, "Tutup", "");
			}
			case 9:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Market Los Santos\n\n{7fffd4}CMDS: /aboutayam\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Pemotong Job", str, "Tutup", "");
			}
			case 10:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di Dilimore\n\n{7fffd4}CMDS: /createpart /sellpart\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Sparepart Job", str, "Tutup", "");
			}
		}
	}			
	if(dialogid == DIALOG_GPS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pJob] == 0)
					{
					    ErrorMsg(playerid, "Anda seorang pengangguran");
					}
					else if(pData[playerid][pJob] == 1)
					{
					    ShowPlayerDialog(playerid, DIALOG_GPS_BUS, DIALOG_STYLE_LIST, "Executive {ffffff}- Sopir Bus", "Bus Bandara - Pelabuhan\nTerminal Bus", "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 2)
					{
					    ShowPlayerDialog(playerid, DIALOG_GPS_AYAM, DIALOG_STYLE_LIST, "Executive {ffffff}- Tukang Ayam", "Pengambilan Ayam\nPemotongan Ayam", "Pilih", "Kembali"); //Pemotong Ayam
					}
					else if(pData[playerid][pJob] == 3)
					{
					    ShowPlayerDialog(playerid, DIALOG_GPS_TUKANGKAYU, DIALOG_STYLE_LIST, "Executive {ffffff}- Tukang Kayu", "Locker Tukang Kayu\nTempat pemotongan kayu\nTempat Memproses papan", "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 4)
					{
					    ShowPlayerDialog(playerid, DIALOG_GPS_MINYAK, DIALOG_STYLE_LIST, "Executive {ffffff}- Penambang Minyak", "Locker Penambang Minyak\nPengambilan Minyak\nPengolahan Minyak", "Pilih", "Kembali"); //Penambang minyak
					}
					else if(pData[playerid][pJob] == 5)
					{
					    ShowPlayerDialog(playerid, DIALOG_GPS_PEMERASSUSU, DIALOG_STYLE_LIST, "Executive {ffffff}- Pemeras Susu", "Locker Pemeras susu\nPengolahan susu", "Pilih", "Kembali"); //Penambang minyak
					}
					else if(pData[playerid][pJob] == 6)
					{
					    ShowPlayerDialog(playerid, DIALOG_GPS_PENAMBANG, DIALOG_STYLE_LIST, "Executive {ffffff}- Penambang", "Locker Penambang\nTempat Penambangan\nTempat Mencuci Batu\nTempat Peleburan", "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 7)
					{
					    ShowPlayerDialog(playerid, DIALOG_GPS_PETANI, DIALOG_STYLE_LIST, "Executive {ffffff}- Petani", "Tempat Pembelian Bibit\nTempat Menanam Bibit\nTempat Proses", "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 8)
					{
					    ShowPlayerDialog(playerid, DIALOG_GPS_KARGO, DIALOG_STYLE_LIST, "Executive {ffffff}- Kargo", "Tempat Pengambilan Tugas Kargo", "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 9)
					{
					    ShowPlayerDialog(playerid, DIALOG_GPSSPAREPART, DIALOG_STYLE_LIST, "Executive {ffffff}- Sparepart", "Pembelian Material\nTempat Pembuatan Sparepart\nTempat Penjualan Sparepart", "Pilih", "Kembali");
					}
					else if(pData[playerid][pJob] == 10)
					{
					    ShowPlayerDialog(playerid, DIALOG_GPSPENJAHIT, DIALOG_STYLE_LIST, "Executive {ffffff}- Penjahit", "Locker Penjahit\nTempat Pengambilan Wool\nTempat Pembuatan Kain\nTempat Pembuatan Pakaian\nTempat Penjualan Pakaian", "Pilih", "Kembali");
					}
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_GENERAL, DIALOG_STYLE_LIST, "Executive {ffffff}- Lokasi Umum", "Bank Executive\nKantor Pemerintahan\nKantor Kepolisian\nRumah Sakit\nKantor Berita\nPedagang\nKantor Gojek\nKantor Ansuransi\nExecutive Market\nPembelian Component\nDealer Executive\nSpot Mancing\nTempat Healing\npembelian material", "Pilih", "Batal");
				}
				case 2:
				{
                    if(GetAnyBusiness() <= 0) return ErrorMsg(playerid, "Tidak ada Business di kota.");
					new id, count = GetAnyBusiness(), location[4096], lstr[596];
					strcat(location,"No\tNama Bisnis\tTipe Bisnis\tJarak\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnBusinessID(itt);

						new type[128];
						if(bData[id][bType] == 1)
						{
							type= "Fast Food";
						}
						else if(bData[id][bType] == 2)
						{
							type= "MiniMarket";
						}
						else if(bData[id][bType] == 3)
						{
							type= "Toko Baju";
						}
						else if(bData[id][bType] == 4)
						{
							type= "Perlengkapan";
						}
						else if(bData[id][bType] == 5)
						{
							type= "Elektronik";
						}
						else
						{
							type= "N/A";
						}

						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%0.2fm\n", itt, bData[id][bName], type, GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%0.2fm\n", itt, bData[id][bName], type, GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_TRACKBUSINESS, DIALOG_STYLE_TABLIST_HEADERS,"List Bisnis",location,"Tandai","Batal");
				}
				case 3:
				{
				    if(GetAnyGarkot() <= 0) return ErrorMsg(playerid, "Tidak ada Garasi Kota.");
					new id, count = GetAnyGarkot(), location[4096], lstr[596];
					strcat(location,"No\tDistance\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnGarkotID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%0.2fm\n", itt, GetPlayerDistanceFromPoint(playerid, gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%0.2fm\n", itt, GetPlayerDistanceFromPoint(playerid, gkData[id][gkX], gkData[id][gkY], gkData[id][gkZ]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_TRACKPARK, DIALOG_STYLE_TABLIST_HEADERS,"Garasi Kota",location,"Pilih","Batal");
				}
				case 4:
				{
					if(pData[playerid][pCP] > 1 || pData[playerid][pSideJob] > 1)
						return ErrorMsg(playerid, "Harap selesaikan Pekerjaan mu terlebih dahulu");

					DisablePlayerCheckpoint(playerid);
					DisablePlayerRaceCheckpoint(playerid);
				}
			}
		}
	}
	if(dialogid == DIALOG_FIND_DEALER)
	{
		if(response)
		{
			new id = ReturnDealerID((listitem + 1));

			pData[playerid][pTrackDealer] = 1;
			SetPlayerRaceCheckpoint(playerid, 1, DealerData[id][dealerPosX], DealerData[id][dealerPosY], DealerData[id][dealerPosZ], 0.0, 0.0, 0.0, 3.5);
			Gps(playerid, "The Dealer checkpoint targeted! (%s)", GetLocation(DealerData[id][dealerPosX], DealerData[id][dealerPosY], DealerData[id][dealerPosZ]));
		}
	}
	if(dialogid == DIALOG_GPS_BUS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1245.016601,-2020.109741,59.889400, 0.0, 0.0, 0.0, 3.5);
					SuccesMsg(playerid, "Tempat Bus Bandara - Pelabuhan ditandai!");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, -609.8121,-507.1617,25.7228, 0.0, 0.0, 0.0, 3.5);
					SuccesMsg(playerid, "Terminal bus ditandai!");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "Executive - {FFFFFF}GPS", "Lokasi Pekerjaan\nLokasi Umum\nToko Di Kota\n"RED_E"(Hapus Checkpoint GPS)", "Pilih", "Batal");
		}
	}
	if(dialogid == DIALOG_GPS_TUKANGKAYU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, -1992.8358,-2387.3059,30.6250, 0.0, 0.0, 0.0, 3.5);
					SuccesMsg(playerid, "Locker Tukang Kayu di tandai!");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, -1997.1274,-2420.9097,30.6250, 0.0, 0.0, 0.0, 3.5);
					SuccesMsg(playerid, "Tempat Memotong kayu di tandai!");
				}
				case 2:
				{
					SetPlayerRaceCheckpoint(playerid,1, -2036.8142,-2376.5964,30.6250, 0.0, 0.0, 0.0, 3.5);
					SuccesMsg(playerid, "Tempat Proses kayu di tandai!");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "Executive - {FFFFFF}GPS", "Lokasi Pekerjaan\nLokasi Umum\nToko Di Kota\n"RED_E"(Hapus Checkpoint GPS)", "Pilih", "Batal");
		}
	}
	if(dialogid == DIALOG_GPS_KARGO)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, -999.998291,-683.041320,32.007812, 0.0, 0.0, 0.0, 3.5);
					SuccesMsg(playerid, "Tempat pengambilan tugas kargo ditandai!");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "Executive - {FFFFFF}GPS", "Lokasi Pekerjaan\nLokasi Umum\nToko Di Kota\n"RED_E"(Hapus Checkpoint GPS)", "Pilih", "Batal");
		}
	}
	if(dialogid == DIALOG_GPS_AYAM)
	{
		if(response)
		{
			switch(listitem)
			{
			    case 0:
			    {
			        SetPlayerRaceCheckpoint(playerid,1, -1422.421142,-967.581909,200.775970, 0.0, 0.0, 0.0, 3.5); //Tempat Pemotongan
					SuccesMsg(playerid, "Tempat pengambilan ayam ditandai!");
			    }
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, -1105.8398,-1650.9512,76.3883, 0.0, 0.0, 0.0, 3.5); //Tempat Pemotongan
					SuccesMsg(playerid, "Tempat pemotongan ayam ditandai!");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "Executive - {FFFFFF}GPS", "Lokasi Pekerjaan\nLokasi Umum\nToko Di Kota\n"RED_E"(Hapus Checkpoint GPS)", "Pilih", "Batal");
		}
	}
	if(dialogid == DIALOG_GPSPENJAHIT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2318.562744,-2070.840576,17.644752, 0.0, 0.0, 0.0, 3.5); //Tempat Pemotongan
					SuccesMsg(playerid, "Tempat locker penjahit ditandai!");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1925.521972,170.046707,37.281250, 0.0, 0.0, 0.0, 3.5); //Jual Ayam
					SuccesMsg(playerid, "Tempat pengambilan wool ditandai!");
				}
				case 2:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2319.653320,-2084.508544,17.652679, 0.0, 0.0, 0.0, 3.5); //Onduty Job Ayam
					SuccesMsg(playerid, "Tempat pembuatan kain ditandai!");
				}
				case 3:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2313.817382,-2075.185546,17.644004, 0.0, 0.0, 0.0, 3.5); //Onduty Job Ayam
					SuccesMsg(playerid, "Tempat pembuatan pakaian ditandai!");
				}
				case 4:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1276.9907,-1424.0293,13.7541, 0.0, 0.0, 0.0, 3.5); //Onduty Job Ayam
					SuccesMsg(playerid, "Tempat penjualan pakaian ditandai!");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "Executive - {FFFFFF}GPS", "Lokasi Pekerjaan\nLokasi Umum\nToko Di Kota\n"RED_E"(Hapus Checkpoint GPS)", "Pilih", "Batal");
		}
	}
	if(dialogid == DIALOG_GPSSPAREPART)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, -258.54, -2189.92, 28.97, 0.0, 0.0, 0.0, 3.5); //Locker
					SuccesMsg(playerid, "Tempat pembelian material ditandai!");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1085.45, 2118.80, 15.35, 0.0, 0.0, 0.0, 3.5); //Pembuatan
					SuccesMsg(playerid, "Tempat pembuatan sparepart ditandai!");
				}
				case 2:
				{
					SetPlayerRaceCheckpoint(playerid,1, 801.12, -613.77, 16.33, 0.0, 0.0, 0.0, 3.5); //PEnjualan
					SuccesMsg(playerid, "Tempat penjualan sparepart ditandai!");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "Executive - {FFFFFF}GPS", "Lokasi Pekerjaan\nLokasi Umum\nToko Di Kota\n"RED_E"(Hapus Checkpoint GPS)", "Pilih", "Batal");
		}
	}
	if(dialogid == DIALOG_GPS_PENAMBANG)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 110.3333,1105.5592,13.6094, 0.0, 0.0, 0.0, 3.5); //locker
					SuccesMsg(playerid, "Tempat Locker penambang ditandai!");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, -396.575592,1249.352050,6.749223, 0.0, 0.0, 0.0, 3.5); //Penambangan
					SuccesMsg(playerid, "Tempat penambangan ditandai!");
				}
				case 2:
				{
					SetPlayerRaceCheckpoint(playerid,1, -795.673522,-1928.231567,5.612922, 0.0, 0.0, 0.0, 3.5); //Pencucian
					SuccesMsg(playerid, "Tempat pencucian batu ditandai!");
				}
				case 3:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2152.539062,-2263.646972,13.300081, 0.0, 0.0, 0.0, 3.5); //Peleburan
					SuccesMsg(playerid, "Tempat peleburan batu ditandai!");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "Executive - {FFFFFF}GPS", "Lokasi Pekerjaan\nLokasi Umum\nToko Di Kota\n"RED_E"(Hapus Checkpoint GPS)", "Pilih", "Batal");
		}
	}
	if(dialogid == DIALOG_GPS_PETANI)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, -1060.852172,-1195.437011,129.664138, 0.0, 0.0, 0.0, 3.5); //Penambangan
					SuccesMsg(playerid, "Tempat pembelian bibit ditandai!");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, -1138.143554,-1084.205688,129.218750, 0.0, 0.0, 0.0, 3.5); //Pencucian
					SuccesMsg(playerid, "Tempat penanaman bibit ditandai!");
				}
				case 2:
				{
					SetPlayerRaceCheckpoint(playerid,1, -1431.233398,-1460.474975,101.693000, 0.0, 0.0, 0.0, 3.5); //Peleburan
					SuccesMsg(playerid, "Tempat proses ditandai!");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "Executive - {FFFFFF}GPS", "Lokasi Pekerjaan\nLokasi Umum\nToko Di Kota\n"RED_E"(Hapus Checkpoint GPS)", "Pilih", "Batal");
		}
	}
	if(dialogid == DIALOG_GPS_MINYAK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 117.4530,1108.9342,13.6094, 0.0, 0.0, 0.0, 3.5); //locker
					SuccesMsg(playerid, "Locker penambang minyak ditandai");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, 435.119323,1264.405517,9.370626, 0.0, 0.0, 0.0, 3.5); //Pengolahan
					SuccesMsg(playerid, "Tempat  pengambilan  minyak ditandai");
				}
				case 2:
				{
					SetPlayerRaceCheckpoint(playerid,1, 570.088989,1219.789794,11.711267, 0.0, 0.0, 0.0, 3.5); //Pengambilan
					SuccesMsg(playerid, "Tempat penyaringan minyak ditandai");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "Executive - {FFFFFF}GPS", "Lokasi Pekerjaan\nLokasi Umum\nToko Di Kota\n"RED_E"(Hapus Checkpoint GPS)", "Pilih", "Batal");
		}
	}
	if(dialogid == DIALOG_GPS_PEMERASSUSU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 300.2857,1141.2467,9.1375, 0.0, 0.0, 0.0, 3.5); //Tempat locker pemeras susu
					SuccesMsg(playerid, "Locker Pemeras Susu ditandai!");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, 315.1492,1154.7682,8.5859, 0.0, 0.0, 0.0, 3.5); //Tempat jual pemeras susu
					SuccesMsg(playerid, "Tempat Olah Susu Sapi Di tandai!");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "{B0C4DE}IndoSean - {FFFFFF}GPS", "Lokasi Pekerjaan\nLokasi Umum\nToko Di Kota\n"RED_E"(Hapus Checkpoint GPS)", "Pilih", "Batal");
		}
	}

	if(dialogid == DIALOG_GPS_PROPERTIES)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					return callcmd::myhouse(playerid);
				}
				case 1:
				{
					return callcmd::mybis(playerid);
				}
				case 2:
				{
					return callcmd::myvending(playerid);
				}
				case 3:
				{
					return callcmd::myv(playerid, "");
				}
			}
		}
		else 
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nGeneral Location\nPublic Location\nJobs\nMy Proprties\nMy Mission", "Pilih", "Tutup");
		}
	}
	if(dialogid == DIALOG_GPS_MISSION)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pMission] == -1) return ErrorMsg(playerid, "You dont have mission.");
					new bid = pData[playerid][pMission];
					Gps(playerid, "Follow the mission checkpoint to find your bisnis mission location.");
					//SetPlayerCheckpoint(playerid, bData[bid][bExtpos][0], bData[bid][bExtpos][1], bData[bid][bExtpos][2], 3.5);
					SetPlayerRaceCheckpoint(playerid,1, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ], 0.0, 0.0, 0.0, 3.5);
				}
				case 1:
				{
					if(pData[playerid][pHauling] == -1) return ErrorMsg(playerid, "You dont have hauling.");
					new id = pData[playerid][pHauling];
					Gps(playerid, "Follow the hauling checkpoint to find your gas station location.");
					//SetPlayerCheckpoint(playerid, bData[bid][bExtpos][0], bData[bid][bExtpos][1], bData[bid][bExtpos][2], 3.5);
					SetPlayerRaceCheckpoint(playerid,1, gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ], 0.0, 0.0, 0.0, 3.5);
				}
			}
		}
		else 
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nGeneral Location\nPublic Location\nJobs\nMy Proprties\nMy Mission", "Pilih", "Tutup");
		}
	}
	if(dialogid == DIALOG_GPS_GENERAL)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1469.8358,-1153.6711,23.9999, 0.0, 0.0, 0.0, 3);//bank
					SuccesMsg(playerid, "Bank kota Executive ditandai");
				}
				case 1:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1140.088378,-2037.671630,69.034301, 0.0, 0.0, 0.0, 3);//city hall
					SuccesMsg(playerid, "Kantor pemerintah Executive ditandai");
				}
				case 2:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1335.1455,-1369.5229,13.7228, 0.0, 0.0, 0.0, 3);//sapd
					SuccesMsg(playerid, "Kepolisian Executive ditandai");
				}
				case 3:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 737.2437,-1411.6875,13.5299, 0.0, 0.0, 0.0, 3);//asgh
					SuccesMsg(playerid, "Rumah Sakit Kota Executive ditandai");
				}
				case 4:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 645.6101, -1360.7520, 13.5887, 0.0, 0.0, 0.0, 3);//sanews
					SuccesMsg(playerid, "Kantor berita Executive ditandai");
				}
				case 5:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1317.1228,-902.1373,39.4292, 0.0, 0.0, 0.0, 3);//burgershot
					SuccesMsg(playerid, "Pedagang kota Executive ditandai");
				}
				case 6:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1350.7031,-1745.8009,13.3782, 0.0, 0.0, 0.0, 3);//Dealership
					SuccesMsg(playerid, "Kantor Gojek di tandai");
				}
				case 7:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1517.0311,-2191.3694,13.3750, 0.0, 0.0, 0.0, 3);//insuran
					SuccesMsg(playerid, "Ansuransi kota Executive ditandai");
				}
				case 8:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 2817.4790,-1577.3334,10.9289, 0.0, 0.0, 0.0, 3);//NoMarket
					SuccesMsg(playerid, "Executive Market ditandai");
				}
				case 9:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 854.5555, -605.2056, 18.4219, 0.0, 0.0, 0.0, 3);//Component
					SuccesMsg(playerid, "Pembelian Component ditandai");
				}
				case 10:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1080.413208,-1666.189453,13.611383, 0.0, 0.0, 0.0, 3);//Dealership
					SuccesMsg(playerid, "Dealership kota Executive ditandai");
				}
				case 11:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 166.4035,-1912.5907,1.1988, 0.0, 0.0, 0.0, 3);//Dealership
					SuccesMsg(playerid, "Spot Mancing ditandai");
				}
				case 12:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 122.2106,-1751.3656,8.5911, 0.0, 0.0, 0.0, 3);//Dealership
					SuccesMsg(playerid, "Tempat Healing ditandai");
				}
				case 13:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, -258.54, -2189.92, 28.97, 0.0, 0.0, 0.0, 3);//Dealership
					SuccesMsg(playerid, "Tempat pembelian material ditandai");
				}

			}
		}
		else 
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "Executive - {FFFFFF}GPS", "Lokasi Pekerjaan\nLokasi Umum\nToko Di Kota\n"RED_E"(Hapus Checkpoint GPS)", "Pilih", "Batal");
		}
	}		
	if(dialogid == DIALOG_GPS_PUBLIC)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetAnyBusiness() <= 0) return ErrorMsg(playerid, "Tidak ada Business di kota.");
					new id, count = GetAnyBusiness(), location[4096], lstr[596];
					strcat(location,"No\tNama Bisnis\tTipe Bisnis\tJarak\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnBusinessID(itt);

						new type[128];
						if(bData[id][bType] == 1)
						{
							type= "Fast Food";
						}
						else if(bData[id][bType] == 2)
						{
							type= "MiniMarket";
						}
						else if(bData[id][bType] == 3)
						{
							type= "Toko Baju";
						}
						else if(bData[id][bType] == 4)
						{
							type= "Perlengkapan";
						}
						else if(bData[id][bType] == 5)
						{
							type= "Elektronik";
						}
						else
						{
							type= "N/A";
						}

						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%0.2fm\n", itt, bData[id][bName], type, GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%0.2fm\n", itt, bData[id][bName], type, GetPlayerDistanceFromPoint(playerid, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_TRACKBUSINESS, DIALOG_STYLE_TABLIST_HEADERS,"List Bisnis",location,"Tandai","Batal");
				}
				case 1:
				{
					if(GetAnyWorkshop() <= 0) return ErrorMsg(playerid, "Tidak ada Workshop.");
					new id, count = GetAnyWorkshop(), location[4096], lstr[596], lock[64];
					strcat(location,"No\tName(Status)\tDistance\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnWorkshopID(itt);
						if(wsData[id][wStatus] == 1)
						{
							lock = "{00FF00}Open{ffffff}";
						}
						else
						{
							lock = "{FF0000}Closed{ffffff}";
						}
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s{ffffff}(%s)\t%0.2fm\n", itt, wsData[id][wName], lock, GetPlayerDistanceFromPoint(playerid, wsData[id][wX], wsData[id][wY], wsData[id][wZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s{ffffff}(%s)\t%0.2fm\n", itt, wsData[id][wName], lock, GetPlayerDistanceFromPoint(playerid, wsData[id][wX], wsData[id][wY], wsData[id][wZ]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_TRACKWS, DIALOG_STYLE_TABLIST_HEADERS,"Track Workshop",location,"Track","Batal");
				}
				case 2:
				{
					if(GetAnyAtm() <= 0) return ErrorMsg(playerid, "Tidak ada ATM di kota.");
					new id, count = GetAnyAtm(), location[4096], lstr[596];
					strcat(location,"No\tLocation\tDistance\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnAtmID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%0.2fm\n", itt, GetLocation(AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]), GetPlayerDistanceFromPoint(playerid, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%0.2fm\n", itt, GetLocation(AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]), GetPlayerDistanceFromPoint(playerid, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_TRACKATM, DIALOG_STYLE_TABLIST_HEADERS,"Track ATM",location,"Track","Batal");
				}

				case 4:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1321.33, -885.54, 39.66, 0.0, 0.0, 0.0, 3);//Dealership
					Gps(playerid, "Active!");
				}
				case 5:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 2062.9805, -1899.6351, 13.5538, 0.0, 0.0, 0.0, 3);//DMV
					Gps(playerid, "Active!");
				}
				case 6:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1335.0966, -1266.0402, 13.5469, 0.0, 0.0, 0.0, 3);//Insurance
					Gps(playerid, "Active!");
				}
				case 7:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 2856.9448, -1981.2794, 10.9372, 0.0, 0.0, 0.0, 3);//Mechanic
					Gps(playerid, "Active!");
				}
				
				case 8:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 854.5555, -605.2056, 18.4219, 0.0, 0.0, 0.0, 3);//Component Shop
					Gps(playerid, "Active!");
				}
				
				case 9:
				{
					pData[playerid][pGpsActive] = 1;
					SetPlayerRaceCheckpoint(playerid, 1, 1310.26, -1367.20, 13.52, 0.0, 0.0, 0.0, 3);//Component Shop
					Gps(playerid, "Active!");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nGeneral Location\nPublic Location\nJobs\nMy Proprties\nMy Mission", "Pilih", "Tutup");
		}
	}		
	if(dialogid == DIALOG_TRACKWS)
	{
		if(response)
		{
			new wid = ReturnWorkshopID((listitem + 1));

			pData[playerid][pGpsActive] = 1;
			SetPlayerRaceCheckpoint(playerid,1, wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ], 0.0, 0.0, 0.0, 3.5);
			Gps(playerid, "Workshop Checkpoint targeted! (%s)", GetLocation(wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ]));
		}
	}
	if(dialogid == DIALOG_TRACKBUSINESS)
	{
		if(response)
		{
			new id = ReturnBusinessID((listitem + 1));

			pData[playerid][pTrackBisnis] = 1;
			SetPlayerRaceCheckpoint(playerid, 1, bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ], 0.0, 0.0, 0.0, 3.5);
			Gps(playerid, "Business checkpoint targeted! (%s)", GetLocation(bData[id][bExtposX], bData[id][bExtposY], bData[id][bExtposZ]));
		}
	}
	if(dialogid == DIALOG_TRACKATM)
	{
		if(response)
		{
			new id = ReturnAtmID((listitem + 1));

			pData[playerid][pGpsActive] = 1;
			SetPlayerRaceCheckpoint(playerid,1, AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ], 0.0, 0.0, 0.0, 3.5);
			Gps(playerid, "Atm checkpoint targeted! (%s)", GetLocation(AtmData[id][atmX], AtmData[id][atmY], AtmData[id][atmZ]));
		}
	}
	if(dialogid == DIALOG_PAYBILL)
	{
		if(!response) return 1;
		new step = 0,
			idtag;
		new bt[128];
		foreach(new ib: tagihan)
		{
			if(ib != -1)
			{
				if(bilData[ib][bilTarget] == pData[playerid][pID])
				{
					if(step == listitem)
					{
						idtag = ib;
					}
					step++;
				}
			}
		}

		if(pData[playerid][pBankMoney] < bilData[idtag][bilammount]) ErrorMsg(playerid, "Jumlah uang direkening kamu tidak cukup");
		pData[playerid][pBankMoney] -= bilData[idtag][bilammount];
		Info(playerid, "You paid bill %s for %s'", bilData[idtag][bilName], FormatMoney(bilData[idtag][bilammount]));
		SendFactionMessage(bilData[idtag][bilType], -1, "{800080}INFO: {ffffff}%s Membayar invoice %s sebesar {00ff00}%s", pData[playerid][pName], bilData[idtag][bilName], FormatMoney(bilData[idtag][bilammount]));
		Iter_Remove(tagihan, idtag);
		mysql_format(g_SQL, bt, sizeof(bt), "DELETE FROM `bill` WHERE `bid`='%d'", idtag);
		mysql_tquery(g_SQL, bt);
	}
	if(dialogid == DIALOG_PAY)
	{
		if(response)
		{
			new mstr[128];
			new otherid = GetPVarInt(playerid, "gcPlayer");
			new money = GetPVarInt(playerid, "gcAmount");

			if(otherid == INVALID_PLAYER_ID)
				return ErrorMsg(playerid, "Player not connected!");
			GivePlayerMoneyEx(otherid, money);
			GivePlayerMoneyEx(playerid, -money);

			format(mstr, sizeof(mstr), "Server: "YELLOW_E"You have sent %s(%i) "GREEN_E"%s", ReturnName(otherid), otherid, FormatMoney(money));
			SendClientMessage(playerid, COLOR_GREY, mstr);
			format(mstr, sizeof(mstr), "Server: "YELLOW_E"%s(%i) has sent you "GREEN_E"%s", ReturnName(playerid), playerid, FormatMoney(money));
			SendClientMessage(otherid, COLOR_GREY, mstr);

			InfoTD_MSG(playerid, 3500, "~g~~h~Money Sent!");
			InfoTD_MSG(otherid, 3500, "~g~~h~Money received!");
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s memberikan uang kepada %s sebesar %s", ReturnName(playerid), ReturnName(otherid), FormatMoney(money));
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "%s menerima uang dari %s sebesar %s", ReturnName(otherid), ReturnName(playerid), FormatMoney(money));
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "INSERT INTO logpay (player,playerid,toplayer,toplayerid,ammount,time) VALUES('%s','%d','%s','%d','%d',UNIX_TIMESTAMP())", pData[playerid][pName], pData[playerid][pID], pData[otherid][pName], pData[otherid][pID], money);
			mysql_tquery(g_SQL, query);
		}
		return 1;
	}
	//-------------[ Player Weapons Atth ]-----------
	if(dialogid == DIALOG_EDITBONE)
	{
		if(response)
		{
			new weaponid = EditingWeapon[playerid], weaponname[18], string[150];
	 
			GetWeaponName(weaponid, weaponname, sizeof(weaponname));
		   
			WeaponSettings[playerid][weaponid - 22][Bone] = listitem + 1;

			Servers(playerid, "You have successfully changed the bone of your %s.", weaponname);
		   
			mysql_format(g_SQL, string, sizeof(string), "INSERT INTO weaponsettings (Owner, WeaponID, Bone) VALUES ('%d', %d, %d) ON DUPLICATE KEY UPDATE Bone = VALUES(Bone)", pData[playerid][pID], weaponid, listitem + 1);
			mysql_tquery(g_SQL, string);
		}
		EditingWeapon[playerid] = 0;
	}
	//------------[ Family Dialog ]------------
	if(dialogid == FAMILY_SAFE)
	{
		if(!response) return 1;
		new fid = pData[playerid][pFamily];
		switch(listitem) 
		{
			case 0: Family_OpenStorage(playerid, fid);
			case 1:
			{
				//Marijuana
				ShowPlayerDialog(playerid, FAMILY_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana", "Withdraw from safe\nDeposit into safe", "Pilih", "Kembali");
			}
			case 2:
			{
				//Component
				ShowPlayerDialog(playerid, FAMILY_COMPONENT, DIALOG_STYLE_LIST, "Component", "Withdraw from safe\nDeposit into safe", "Pilih", "Kembali");
			}
			case 3:
			{
				//Material
				ShowPlayerDialog(playerid, FAMILY_MATERIAL, DIALOG_STYLE_LIST, "Material", "Withdraw from safe\nDeposit into safe", "Pilih", "Kembali");
			}
			case 4:
			{
				//Money
				ShowPlayerDialog(playerid, FAMILY_MONEY, DIALOG_STYLE_LIST, "Money", "Withdraw from safe\nDeposit into safe", "Pilih", "Kembali");
			}
		}
		return 1;
	}
	if(dialogid == FAMILY_STORAGE)
	{
		new fid = pData[playerid][pFamily];
		if(response)
		{
			if(listitem == 0) 
			{
				Family_WeaponStorage(playerid, fid);
			}
		}
		return 1;
	}
	if(dialogid == FAMILY_WEAPONS)
	{
		new fid = pData[playerid][pFamily];
		if(response)
		{
			if(fData[fid][fGun][listitem] != 0)
			{
				if(pData[playerid][pFamilyRank] < 5)
					return ErrorMsg(playerid, "Only boss can taken the weapon!");
					
				GivePlayerWeaponEx(playerid, fData[fid][fGun][listitem], fData[fid][fAmmo][listitem]);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(fData[fid][fGun][listitem]));

				fData[fid][fGun][listitem] = 0;
				fData[fid][fAmmo][listitem] = 0;

				Family_Save(fid);
				Family_WeaponStorage(playerid, fid);
			}
			else
			{
				new
					weaponid = GetPlayerWeaponEx(playerid),
					ammo = GetPlayerAmmoEx(playerid);

				if(!weaponid)
					return ErrorMsg(playerid, "You are not holding any weapon!");

				/*if(weaponid == 23 && pData[playerid][pTazer])
					return ErrorMsg(playerid, "You can't store a tazer into your safe.");

				if(weaponid == 25 && pData[playerid][pBeanBag])
					return ErrorMsg(playerid, "You can't store a beanbag shotgun into your safe.");*/

				ResetWeapon(playerid, weaponid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their weapon storage.", ReturnName(playerid), ReturnWeaponName(weaponid));

				fData[fid][fGun][listitem] = weaponid;
				fData[fid][fAmmo][listitem] = ammo;

				Family_Save(fid);
				Family_WeaponStorage(playerid, fid);
			}
		}
		else
		{
			Family_OpenStorage(playerid, fid);
		}
		return 1;
	}
	if(dialogid == FAMILY_MARIJUANA)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pFamilyRank] < 5)
							return ErrorMsg(playerid, "Only boss can withdraw marijuana!");
							
						new str[128];
						format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to withdraw from the safe:", fData[fid][fMarijuana]);
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to deposit into the safe:", fData[fid][fMarijuana]);
						ShowPlayerDialog(playerid, FAMILY_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWMARIJUANA)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to withdraw from the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fMarijuana])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMarijuana Balance: %d\n\nPlease enter how much marijuana you wish to withdraw from the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			fData[fid][fMarijuana] -= amount;
			pData[playerid][pMarijuana] += amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d marijuana from their family safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITMARIJUANA)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to deposit into the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMarijuana])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMarijuana Balance: %d\n\nPlease enter how much marijuana you wish to deposit into the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			fData[fid][fMarijuana] += amount;
			pData[playerid][pMarijuana] -= amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d marijuana into their family safe.", ReturnName(playerid), amount);
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_COMPONENT)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pFamilyRank] < 5)
							return ErrorMsg(playerid, "Only boss can withdraw component!");
							
						new str[128];
						format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", fData[fid][fComponent]);
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", fData[fid][fComponent]);
						ShowPlayerDialog(playerid, FAMILY_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWCOMPONENT)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fComponent])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nComponent Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			fData[fid][fComponent] -= amount;
			pData[playerid][pComponent] += amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d component from their family safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITCOMPONENT)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pComponent])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nComponent Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			fData[fid][fComponent] += amount;
			pData[playerid][pComponent] -= amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d component into their family safe.", ReturnName(playerid), amount);
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_MATERIAL)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pFamilyRank] < 5)
							return ErrorMsg(playerid, "Only boss can withdraw material!");
							
						new str[128];
						format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", fData[fid][fMaterial]);
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", fData[fid][fMaterial]);
						ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWMATERIAL)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fMaterial])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMaterial Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			fData[fid][fMaterial] -= amount;
			pData[playerid][pMaterial] += amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d material from their family safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITMATERIAL)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMaterial])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMaterial Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			fData[fid][fMaterial] += amount;
			pData[playerid][pMaterial] -= amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d material into their family safe.", ReturnName(playerid), amount);
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_MONEY)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0: 
					{
						if(pData[playerid][pFamilyRank] < 5)
							return ErrorMsg(playerid, "Only boss can withdraw money!");
							
						new str[128];
						format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(fData[fid][fMoney]));
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
					}
					case 1: 
					{
						new str[128];
						format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(fData[fid][fMoney]));
						ShowPlayerDialog(playerid, FAMILY_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWMONEY)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
		
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMoney Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			fData[fid][fMoney] -= amount;
			GivePlayerMoneyEx(playerid, amount);

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s money from their family safe.", ReturnName(playerid), FormatMoney(amount));
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITMONEY)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return ErrorMsg(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > GetPlayerMoney(playerid))
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMoney Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			fData[fid][fMoney] += amount;
			GivePlayerMoneyEx(playerid, -amount);

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s money into their family safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_INFO)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pFamily] == -1)
						return ErrorMsg(playerid, "You dont have family!");
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT name,leader,marijuana,component,material,money FROM familys WHERE ID = %d", pData[playerid][pFamily]);
					mysql_tquery(g_SQL, query, "ShowFamilyInfo", "i", playerid);
				}
				case 1:
				{
					if(pData[playerid][pFamily] == -1)
						return ErrorMsg(playerid, "You dont have family!");
						
					new lstr[1024];
					format(lstr, sizeof(lstr), "Rank\tName\n");
					foreach(new i: Player)
					{
						if(pData[i][pFamily] == pData[playerid][pFamily])
						{
							format(lstr, sizeof(lstr), "%s%s\t%s(%d)", lstr, GetFamilyRank(i), pData[i][pName], i);
							format(lstr, sizeof(lstr), "%s\n", lstr);
						}
					}
					format(lstr, sizeof(lstr), "%s\n", lstr);
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Family Online", lstr, "Tutup", "");
					
				}
				case 2:
				{
					if(pData[playerid][pFamily] == -1)
						return ErrorMsg(playerid, "You dont have family!");
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT username,familyrank FROM players WHERE family = %d", pData[playerid][pFamily]);
					mysql_tquery(g_SQL, query, "ShowFamilyMember", "i", playerid);
				}
			}
		}
		return 1;
	}
	//------------[ VIP Locker Dialog ]----------
	if(dialogid == DIALOG_LOCKERVIP)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					SetPlayerHealthEx(playerid, 100);
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 1, 1);
					GivePlayerWeaponEx(playerid, 7, 1);
					GivePlayerWeaponEx(playerid, 15, 1);
				}
				case 2:
				{
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, VIPMaleSkins, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, VIPFemaleSkins, "Choose your skin");
					}
				}
				case 3:
				{
					new string[248];
					if(pToys[playerid][0][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 1\n");
					}
					else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

					if(pToys[playerid][1][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 2\n");
					}
					else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

					if(pToys[playerid][2][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 3\n");
					}
					else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

					if(pToys[playerid][3][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 4\n");
					}
					else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");

					/*if(pToys[playerid][4][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 5\n");
					}
					else strcat(string, ""dot"Slot 5 "RED_E"(Used)\n");

					if(pToys[playerid][5][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 6\n");
					}
					else strcat(string, ""dot"Slot 6 "RED_E"(Used)\n");*/

					ShowPlayerDialog(playerid, DIALOG_TOYVIP, DIALOG_STYLE_LIST, ""WHITE_E"VIP Toys", string, "Pilih", "Batal");
				}
			}
		}
	}
	//-------------[ Faction Commands Dialog ]-----------
	if(dialogid == DIALOG_LOCKERSAPD)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
						ResetWeapon(playerid, 25);
						ResetWeapon(playerid, 27);
						ResetWeapon(playerid, 29);
						ResetWeapon(playerid, 31);
						ResetWeapon(playerid, 33);
						ResetWeapon(playerid, 34);
						KillTimer(DutyTimer);
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 280);
							pData[playerid][pFacSkin] = 280;
						}
						else
						{
							SetPlayerSkin(playerid, 306);
							pData[playerid][pFacSkin] = 306;
						}
						DutyTimer = SetTimerEx("DutyHour", 1000, true, "i", playerid);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1:
				{
				    ShowProgressbar(playerid, "Mengambil pelindung tubuh..", 2);
				    ShowItemBox(playerid, "Vest", "Received_1x", 1242, 2);
				    pData[playerid][pVest] += 1;
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil pelindung tubuh dari locker", ReturnName(playerid));
				}
				case 2:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return ErrorMsg(playerid, "Kamu harus On duty untuk mengambil barang!");
						
					ShowPlayerDialog(playerid, DIALOG_WEAPONSAPD, DIALOG_STYLE_LIST, "Executive - Senjata Kepolisian", "DEAGLE\nSHOTGUN\nMP5\nM4\nSNIPER", "Pilih", "Batal");
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return ErrorMsg(playerid, "Kamu harus On duty untuk mengambil barang!");
					
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SAPDMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SAPDFemale, "Choose your skin");
					}
				}
				case 4:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return ErrorMsg(playerid, "Kamu harus On duty untuk mengambil barang!");
					if(pData[playerid][pFactionRank] < 3)
						return ErrorMsg(playerid, "You are not allowed!");
					
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SAPDWar, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SAPDFemale, "Choose your skin");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONSAPD)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					if(pData[playerid][pFactionRank] < 2)
						return ErrorMsg(playerid, "You are not allowed!");
						
					GivePlayerWeaponEx(playerid, 24, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(24));
				}	
				case 1:
				{
					if(pData[playerid][pFactionRank] < 3)
						return ErrorMsg(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 25, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(25));
				}
				case 2:
				{
					if(pData[playerid][pFactionRank] < 3)
						return ErrorMsg(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 29, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(29));
				}
				case 3:
				{
					if(pData[playerid][pFactionRank] < 4)
						return ErrorMsg(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 31, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(31));
				}
				case 4:
				{
					if(pData[playerid][pFactionRank] < 4)
						return ErrorMsg(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 33, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(33));
				}
				case 5:
				{
					if(pData[playerid][pFactionRank] < 4)
						return ErrorMsg(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 34, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(34));
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERSAGS)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 295);
							pData[playerid][pFacSkin] = 295;
						}
						else
						{
							SetPlayerSkin(playerid, 141);
							pData[playerid][pFacSkin] = 141;
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1:
				{
					SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil armour pelindung dari locker", ReturnName(playerid));
				}
				case 2:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return ErrorMsg(playerid, "Kamu harus On duty untuk mengambil barang!");
						
					ShowPlayerDialog(playerid, DIALOG_WEAPONSAGS, DIALOG_STYLE_LIST, "Executive - Senjata Pemerintah", "DEAGLE\nMP5", "Pilih", "Batal");
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return ErrorMsg(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SAGSMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SAGSFemale, "Choose your skin");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERGOJEK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Seragam Kerja");
					if(pData[playerid][pGender] == 1) SetPlayerSkin(playerid, 188);
					else SetPlayerSkin(playerid, 188);// wanita
				}
				case 1:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Baju biasa");
					SetPlayerSkin(playerid, pData[playerid][pSkin]);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONSAGS)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					if(pData[playerid][pFactionRank] < 3)
						return ErrorMsg(playerid, "You are not allowed!");
						
					GivePlayerWeaponEx(playerid, 24, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(24));
				}	
				case 1:
				{
					if(pData[playerid][pFactionRank] < 4)
						return ErrorMsg(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 29, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(29));
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERSAMD)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 276);
							pData[playerid][pFacSkin] = 276;
						}
						else
						{
							SetPlayerSkin(playerid, 308);
							pData[playerid][pFacSkin] = 308;
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_DRUGSSAMD, DIALOG_STYLE_LIST, "Executive - Obat Medis", "Perban\nObat Stress", "Pilih", "Batal");
				}
				case 2:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return ErrorMsg(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SAMDMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SAMDFemale, "Choose your skin");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_DRUGSSAMD)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pPerban] += 5;
					ShowItemBox(playerid, "Perban", "Received_5x", 11736, 4);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil 5 perban dari locker.", ReturnName(playerid));
				}
				case 1:
				{
					pData[playerid][pObatStress] += 5;
					ShowItemBox(playerid, "Obat_Stress", "Received_5x", 1241, 4);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s mengambil 5 obat stress dari locker.", ReturnName(playerid));
				}
			}
		}
	}
	if(dialogid == DIALOG_LOCKERSANEW)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0: 
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 59);
							pData[playerid][pFacSkin] = 59;
						}
						else
						{
							SetPlayerSkin(playerid, 150); //194
							pData[playerid][pFacSkin] = 150; //194
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return ErrorMsg(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SANEWMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SANEWFemale, "Choose your skin");
					}
				}
			}
		}
		return 1;
	}
	//--------[ DIALOG JOB ]--------
	if(dialogid == DIALOG_SERVICE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						new Float:health, comp;
						GetVehicleHealth(pData[playerid][pMechVeh], health);
						if(health > 1000.0) health = 1000.0;
						if(health > 0.0) health *= -1;
						comp = floatround(health, floatround_round) / 10 + 100;
						
						if(pData[playerid][pComponent] < comp) return ErrorMsg(playerid, "Component anda kurang!");
						if(comp <= 0) return ErrorMsg(playerid, "This vehicle can't be fixing.");
						pData[playerid][pComponent] -= comp;
						Info(playerid, "Anda memperbaiki mesin kendaraan dengan "RED_E"%d component.", comp);
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("EngineFix", 7000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Memperbaiki Mesin..", 7);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 1);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						new panels, doors, light, tires, comp;
						
						GetVehicleDamageStatus(pData[playerid][pMechVeh], panels, doors, light, tires);
						new cpanels = panels / 1000000;
						new lights = light / 2;
						new pintu;
						if(doors != 0) pintu = 5;
						if(doors == 0) pintu = 0;
						comp = cpanels + lights + pintu + 20;
						
						if(pData[playerid][pComponent] < comp) return ErrorMsg(playerid, "Component anda kurang!");
						if(comp <= 0) return ErrorMsg(playerid, "This vehicle can't be fixing.");
						pData[playerid][pComponent] -= comp;
						Info(playerid, "Anda memperbaiki body kendaraan dengan "RED_E"%d component.", comp);
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("BodyFix", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Memperbaiki Body..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					if(IsAtMech(playerid))
					{
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 40) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR, DIALOG_STYLE_INPUT, "Color ID 1", "Enter the color id 1:(0 - 255)", "Next", "Tutup");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechanicStatus] = 0;

							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return ErrorMsg(playerid, "Anda harus berada di area mekanik!");
				}
				case 3:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_PAINTJOB, DIALOG_STYLE_INPUT, "Paintjob", "Enter the vehicle paintjob id:(0 - 2 | 3 - Remove paintJob)", "Paintjob", "Tutup");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
				case 4:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 85) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar", "Confirm", "Kembali");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
				case 5:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_SPOILER,DIALOG_STYLE_LIST,"Choose below","Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n","Choose","Kembali");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
				case 6:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n", "Confirm", "Kembali");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
				case 7:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n", "Confirm", "Kembali");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
				case 8:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 50) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n", "Confirm", "Kembali");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
				case 9:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust", "Confirm", "Kembali");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
				case 10:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_FRONT_BUMPERS, DIALOG_STYLE_LIST, "Front bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper", "Confirm", "Kembali");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
				case 11:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_REAR_BUMPERS, DIALOG_STYLE_LIST, "Rear bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper", "Confirm", "Kembali");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
				case 12:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop", "Confirm", "Kembali");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
				case 13:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_SIDE_SKIRTS, DIALOG_STYLE_LIST, "Side skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt", "Confirm", "Kembali");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
				case 14:
				{
					if(IsAtMech(playerid))
					{
					
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 50) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_BULLBARS, DIALOG_STYLE_LIST, "Bull bars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar", "Confirm", "Kembali");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
				case 15:
				{
					if(IsAtMech(playerid))
					{
					
						pData[playerid][pMechColor1] = 1086;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 150) return ErrorMsg(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 150;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"150 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modif Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
							TogglePlayerControllable(playerid, 0);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
				case 16:
				{
					if(IsAtMech(playerid))
					{
					
						pData[playerid][pMechColor1] = 1087;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 150) return ErrorMsg(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 150;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"150 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
                            ShowProgressbar(playerid, "Modif Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
							TogglePlayerControllable(playerid, 0);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
				case 17:
				{
					if(IsAtMech(playerid))
					{
						pData[playerid][pMechColor1] = 1009;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 250) return ErrorMsg(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 250;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"250 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modif Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
							TogglePlayerControllable(playerid, 0);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
				case 18:
				{
					if(IsAtMech(playerid))
					{
					
						pData[playerid][pMechColor1] = 1008;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 375) return ErrorMsg(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 375;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"375 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modif Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
							TogglePlayerControllable(playerid, 0);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
				case 19:
				{
					if(IsAtMech(playerid))
					{
						pData[playerid][pMechColor1] = 1010;
						pData[playerid][pMechColor2] = 0;
				
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{	
							if(pData[playerid][pComponent] < 500) return ErrorMsg(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 500;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"500 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modif Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
							TogglePlayerControllable(playerid, 0);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
				case 20:
				{
					if(IsAtMech(playerid))
					{
						if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 450) return ErrorMsg(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_NEON,DIALOG_STYLE_LIST,"Neon","RED\nBLUE\nGREEN\nYELLOW\nPINK\nWHITE\nREMOVE","Choose","Kembali");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechanicStatus] = 0;
							pData[playerid][pActivityTime] = 0;
							TogglePlayerControllable(playerid, 1);
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_SERVICE_COLOR)
	{
		if(response)
		{
			pData[playerid][pMechColor1] = floatround(strval(inputtext));
			
			if(pData[playerid][pMechColor1] < 0 || pData[playerid][pMechColor1] > 255)
				return ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR, DIALOG_STYLE_INPUT, "Color ID 1", "Enter the color id 1:(0 - 255)", "Next", "Tutup");
			
			ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR2, DIALOG_STYLE_INPUT, "Color ID 2", "Enter the color id 2:(0 - 255)", "Next", "Tutup");
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_COLOR2)
	{
		if(response)
		{
			pData[playerid][pMechColor2] = floatround(strval(inputtext));
			
			if(pData[playerid][pMechColor2] < 0 || pData[playerid][pMechColor2] > 255)
				return ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR2, DIALOG_STYLE_INPUT, "Color ID 2", "Enter the color id 2:(0 - 255)", "Next", "Tutup");
			
			if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
			if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
			{	
				if(pData[playerid][pComponent] < 40) return ErrorMsg(playerid, "Component anda kurang!");
				pData[playerid][pComponent] -= 40;
				Info(playerid, "Anda mengganti warna kendaraan dengan "RED_E"30 component.");
				pData[playerid][pMechanicStatus] = 1;
				pData[playerid][pMechanic] = SetTimerEx("SprayCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
				ShowProgressbar(playerid, "Mengecat Kendaraan..", 6);
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				TogglePlayerControllable(playerid, 0);
			}
			else
			{
				KillTimer(pData[playerid][pMechanic]);
				pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
				pData[playerid][pMechanicStatus] = 0;
				pData[playerid][pMechColor1] = 0;
				pData[playerid][pMechColor2] = 0;
				pData[playerid][pActivityTime] = 0;
				TogglePlayerControllable(playerid, 1);
				Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
				return 1;
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_PAINTJOB)
	{
		if(response)
		{
			pData[playerid][pMechColor1] = floatround(strval(inputtext));
			
			if(pData[playerid][pMechColor1] < 0 || pData[playerid][pMechColor1] > 3)
				return ShowPlayerDialog(playerid, DIALOG_SERVICE_PAINTJOB, DIALOG_STYLE_INPUT, "Paintjob", "Enter the vehicle paintjob id:(0 - 2 | 3 - Remove paintJob)", "Paintjob", "Tutup");
			
			if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
			if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
			{	
				if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
				pData[playerid][pComponent] -= 100;
				Info(playerid, "Anda mengganti paintjob kendaraan dengan "RED_E"50 component.");
				pData[playerid][pMechanicStatus] = 1;
				pData[playerid][pMechanic] = SetTimerEx("PaintjobCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
				ShowProgressbar(playerid, "Painting Kendaraan..", 6);
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				TogglePlayerControllable(playerid, 0);
			}
			else
			{
				KillTimer(pData[playerid][pMechanic]);
				pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
				pData[playerid][pMechanicStatus] = 0;
				pData[playerid][pMechColor1] = 0;
				pData[playerid][pMechColor2] = 0;
				pData[playerid][pActivityTime] = 0;
				TogglePlayerControllable(playerid, 1);
				Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
				return 1;
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_WHEELS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMechColor1] = 1025;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 85) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 85;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					pData[playerid][pMechColor1] = 1074;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					pData[playerid][pMechColor1] = 1076;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					pData[playerid][pMechColor1] = 1078;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					pData[playerid][pMechColor1] = 1081;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					pData[playerid][pMechColor1] = 1082;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
                        pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					pData[playerid][pMechColor1] = 1085;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					pData[playerid][pMechColor1] = 1096;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 8:
				{
					pData[playerid][pMechColor1] = 1097;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 9:
				{
					pData[playerid][pMechColor1] = 1098;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 10:
				{
					pData[playerid][pMechColor1] = 1084;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 11:
				{
					pData[playerid][pMechColor1] = 1073;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 12:
				{
					pData[playerid][pMechColor1] = 1075;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 13:
				{
					pData[playerid][pMechColor1] = 1077;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 14:
				{
					pData[playerid][pMechColor1] = 1079;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 15:
				{
					pData[playerid][pMechColor1] = 1080;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
					    pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 16:
				{
					pData[playerid][pMechColor1] = 1083;
					pData[playerid][pMechColor2] = 0;
			
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{	
						if(pData[playerid][pComponent] < 60) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						TogglePlayerControllable(playerid, 0);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						TogglePlayerControllable(playerid, 1);
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_SPOILER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1147;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1049;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1162;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1058;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1164;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1138;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1146;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1050;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1158;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1060;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1163;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1139;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 527 ||
						VehicleModel == 415 ||
						VehicleModel == 546 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 405 ||
						VehicleModel == 477 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1001;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 405 ||
						VehicleModel == 477 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1023;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 401 ||
						VehicleModel == 517 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 477 ||
						VehicleModel == 547 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1003;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
						    pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 589 ||
						VehicleModel == 492 ||
						VehicleModel == 547 ||
						VehicleModel == 405)
						{
				
							pData[playerid][pMechColor1] = 1000;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 527 ||
						VehicleModel == 542 ||
						VehicleModel == 405)
						{
				
							pData[playerid][pMechColor1] = 1014;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 527 ||
						VehicleModel == 542)
						{
				
							pData[playerid][pMechColor1] = 1015;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 8:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 546 ||
						VehicleModel == 517)
						{
				
							pData[playerid][pMechColor1] = 1002;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_SERVICE_HOODS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 492 ||
						VehicleModel == 426 ||
						VehicleModel == 550)
						{
				
							pData[playerid][pMechColor1] = 1005;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
						    pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 402 ||
						VehicleModel == 546 ||
						VehicleModel == 426 ||
						VehicleModel == 550)
						{
				
							pData[playerid][pMechColor1] = 1004;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 401)
						{
				
							pData[playerid][pMechColor1] = 1011;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1012;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_VENTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 547 ||
						VehicleModel == 439 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1142;
							pData[playerid][pMechColor2] = 1143;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 439 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{
				
							pData[playerid][pMechColor1] = 1144;
							pData[playerid][pMechColor2] = 1145;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
                            pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_SERVICE_LIGHTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 400 ||
						VehicleModel == 436 ||
						VehicleModel == 439)
						{
				
							pData[playerid][pMechColor1] = 1013;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 589 ||
						VehicleModel == 603 ||
						VehicleModel == 400)
						{
				
							pData[playerid][pMechColor1] = 1024;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_EXHAUSTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 558 ||
						VehicleModel == 561 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1034;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1046;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1065;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1064;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1028;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1089;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 558 ||
						VehicleModel == 561 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1037;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1045;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1066;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1059;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1029;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1092;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1044;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1126;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1129;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1104;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1113;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1136;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1043;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1127;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1132;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1105;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1135;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1114;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 527 ||
						VehicleModel == 542 ||
						VehicleModel == 589 ||
						VehicleModel == 400 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{
							
							pData[playerid][pMechColor1] = 1020;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(
						VehicleModel == 527 ||
						VehicleModel == 542 ||
						VehicleModel == 400 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 477)
						{
							
							pData[playerid][pMechColor1] = 1021;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 436)
						{
							
							pData[playerid][pMechColor1] = 1022;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(
						VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 542 ||
						VehicleModel == 546 ||
						VehicleModel == 400 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 550 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{
							
							pData[playerid][pMechColor1] = 1019;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 8:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return ErrorMsg(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 542 ||
						VehicleModel == 546 ||
						VehicleModel == 400 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 415 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 550 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{
							
							pData[playerid][pMechColor1] = 1018;
							pData[playerid][pMechColor2] = 0;
								
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_FRONT_BUMPERS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1171;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1153;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1160;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1155;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1166;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1169;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1172;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1152;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1173;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1157;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1165;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1170;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1174;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1179;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1189;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1182;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1191;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1115;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1175;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1185;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1188;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1181;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1190;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1116;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_REAR_BUMPERS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1149;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1150;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1159;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1154;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1168;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1141;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1148;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1151;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1161;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1156;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1167;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1140;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1176;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1180;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1187;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1184;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1192;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1109;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1177;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1178;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1186;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1183;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1193;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1110;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_ROOFS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1038;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1054;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1067;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1055;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1088;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1032;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1038;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1053;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1068;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1061;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1091;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1033;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 567 ||
						VehicleModel == 536)
						{
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1130;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1128;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 567 ||
						VehicleModel == 536)
						{
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1131;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1103;
								pData[playerid][pMechColor2] = 0;
							}
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return ErrorMsg(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 492 ||
						VehicleModel == 546 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 477)
						{

							pData[playerid][pMechColor1] = 1006;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_SIDE_SKIRTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1036;
								pData[playerid][pMechColor2] = 1040;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1047;
								pData[playerid][pMechColor2] = 1051;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1069;
								pData[playerid][pMechColor2] = 1071;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1056;
								pData[playerid][pMechColor2] = 1062;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1090;
								pData[playerid][pMechColor2] = 1094;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1026;
								pData[playerid][pMechColor2] = 1027;
							}
							
							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1039;
								pData[playerid][pMechColor2] = 1041;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1048;
								pData[playerid][pMechColor2] = 1052;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1070;
								pData[playerid][pMechColor2] = 1072;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1057;
								pData[playerid][pMechColor2] = 1063;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1093;
								pData[playerid][pMechColor2] = 1095;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1031;
								pData[playerid][pMechColor2] = 1030;
							}
							
							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 567)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1042;
								pData[playerid][pMechColor2] = 1099;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1108;
								pData[playerid][pMechColor2] = 1107;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1134;
								pData[playerid][pMechColor2] = 1137;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1102;
								pData[playerid][pMechColor2] = 1133;
							}
							
							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1102;
							pData[playerid][pMechColor2] = 1101;
							
							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1106;
							pData[playerid][pMechColor2] = 1124;
							
							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 535)
						{
				
							pData[playerid][pMechColor1] = 1118;
							pData[playerid][pMechColor2] = 1120;
							
							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 535)
						{
				
							pData[playerid][pMechColor1] = 1119;
							pData[playerid][pMechColor2] = 1121;
							
							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return ErrorMsg(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 527 ||
						VehicleModel == 415 ||
						VehicleModel == 589 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 436 ||
						VehicleModel == 439 ||
						VehicleModel == 580 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{
				
							pData[playerid][pMechColor1] = 1007;
							pData[playerid][pMechColor2] = 1017;
							
							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_BULLBARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 50) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1100;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 50;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"50 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 50) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1123;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 50;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"50 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 50) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1125;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 50;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"50 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);
					
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 50) return ErrorMsg(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{
				
							pData[playerid][pMechColor1] = 1117;
							pData[playerid][pMechColor2] = 0;
							
							pData[playerid][pComponent] -= 50;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"50 component.");
							pData[playerid][pMechanicStatus] = 1;
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
							ShowProgressbar(playerid, "Modifikasi Kendaraan..", 6);
							ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						}
						else return ErrorMsg(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_NEON)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMechColor1] = RED_NEON;

					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Memasang Neon Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					pData[playerid][pMechColor1] = BLUE_NEON;

					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Memasang Neon Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					pData[playerid][pMechColor1] = GREEN_NEON;

					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Memasang Neon Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					pData[playerid][pMechColor1] = YELLOW_NEON;

					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Memasang Neon Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					pData[playerid][pMechColor1] = PINK_NEON;

					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Memasang Neon Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					pData[playerid][pMechColor1] = WHITE_NEON;

					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Memasang Neon Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					pData[playerid][pMechColor1] = 0;

					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return ErrorMsg(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanicStatus] = 1;
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 6000, false, "id", playerid, pData[playerid][pMechVeh]);
						ShowProgressbar(playerid, "Memasang Neon Kendaraan..", 6);
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechanicStatus] = 0;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	//ARMS Dealer
	if(dialogid == DIALOG_ARMS_GUN)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slc pistol
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 320) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 320).");
					
					pData[playerid][pMaterial] -= 320;
					
					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 320 material!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealerStatus] = 1;
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_SILENCED, 70);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 1: //colt45 9mm
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 250) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 250).");
					
					pData[playerid][pMaterial] -= 250;
					
					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 250 material!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealerStatus] = 1;
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_COLT45, 70);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 2: //deagle
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 350) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 350).");
					
					pData[playerid][pMaterial] -= 350;
					
					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 350 material!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealerStatus] = 1;
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_DEAGLE, 70);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 3: //shotgun
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 300) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 300).");
					
					pData[playerid][pMaterial] -= 300;
					
					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 300 material!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealerStatus] = 1;
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_SHOTGUN, 50);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
				case 4: //ak-47
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 500) return ErrorMsg(playerid, "Material tidak cukup!(Butuh: 500).");
					
					pData[playerid][pMaterial] -= 500;
					
					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 500 material!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealerStatus] = 1;
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_AK47, 100);
					PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Creating...");
					PlayerTextDrawShow(playerid, ActiveTD[playerid]);
					ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_HAULING)
	{
		if(response)
		{
			new id = ReturnRestockGStationID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid);

			if(IsValidVehicle(pData[playerid][pTrailer]))
			{
				DestroyVehicle(pData[playerid][pTrailer]);
				pData[playerid][pTrailer] = INVALID_VEHICLE_ID;
			}
			
			if(pData[playerid][pHauling] > -1 || pData[playerid][pMission] > -1)
				return ErrorMsg(playerid, "Anda sudah sedang melakukan Mission/hauling!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ErrorMsg(playerid, "Anda harus mengendarai truck.");
			if(!IsAHaulTruck(vehicleid)) return ErrorMsg(playerid, "You're not in Hauling Truck ( Attachable Truck )");

			pData[playerid][pHauling] = id;
			
			new line9[900];

			format(line9, sizeof(line9), "Silahkan anda mengambil trailer gas oil di gudang miner!\n\nGas Station ID: %d\nLocation: %s\n\nSetelah itu ikuti checkpoint dan antarkan ke Gas Station tujuan hauling anda!",
				id, GetLocation(gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]));
			SetPlayerRaceCheckpoint(playerid, 1, 335.66, 861.02, 21.01, 0, 0, 0, 5.5);
			pData[playerid][pTrailer] = CreateVehicle(584, 326.57, 857.31, 20.40, 290.67, -1, -1, -1, 0);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Hauling Info", line9, "Tutup","");
		}
		return 1;
	}
	if(dialogid == DIALOG_RESTOCK)
	{
		if(response)
		{
			new id = ReturnRestockBisnisID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid);
			if(bData[id][bMoney] < 1000)
				return ErrorMsg(playerid, "Maaf, Bisnis ini kehabisan uang product.");
			
			if(pData[playerid][pMission] > -1 || pData[playerid][pHauling] > -1)
				return ErrorMsg(playerid, "Anda sudah sedang melakukan mission/hauling!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return ErrorMsg(playerid, "Anda harus mengendarai truck.");
				
			pData[playerid][pMission] = id;
			bData[id][bRestock] = 0;
			
			new line9[900];
			new type[128];
			if(bData[id][bType] == 1)
			{
				type = "Fast Food";

			}
			else if(bData[id][bType] == 2)
			{
				type = "Market";
			}
			else if(bData[id][bType] == 3)
			{
				type = "Clothes";
			}
			else if(bData[id][bType] == 4)
			{
				type = "Equipment";
			}
			else
			{
				type = "Unknow";
			}
			format(line9, sizeof(line9), "Silahkan anda membeli stock product di gudang!\n\nBisnis ID: %d\nBisnis Owner: %s\nBisnis Name: %s\nBisnis Type: %s\n\nSetelah itu ikuti checkpoint dan antarkan ke bisnis mission anda!",
			id, bData[id][bOwner], bData[id][bName], type);
			SetPlayerRaceCheckpoint(playerid,1, -279.67, -2148.42, 28.54, 0.0, 0.0, 0.0, 3.5);
			//SetPlayerCheckpoint(playerid, -279.67, -2148.42, 28.54, 3.5);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Mission Info", line9, "Tutup","");
		}
	}
	if(dialogid == DIALOG_PRODUCT)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new value = amount * ProductPrice;
			new vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			new total = VehProduct[vehicleid] + amount;
			if(amount < 0 || amount > 150) return ErrorMsg(playerid, "amount maximal 0 - 150.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(Product < amount) return ErrorMsg(playerid, "Product stock tidak mencukupi.");
			if(total > 150) return ErrorMsg(playerid, "Product Maximal 150 in your vehicle tank!");
			GivePlayerMoneyEx(playerid, -value);
			VehProduct[vehicleid] += amount;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cProduct] += amount;
			}
			
			Product -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"product seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_GASOIL)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new value = amount * GasOilPrice;
			new vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			new total = VehGasOil[vehicleid] + amount;
			
			if(amount < 0 || amount > 1000) return ErrorMsg(playerid, "amount maximal 0 - 1000.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(GasOil < amount) return ErrorMsg(playerid, "GasOil stock tidak mencukupi.");
			if(total > 1000) return ErrorMsg(playerid, "Gas Oil Maximal 1000 liter in your vehicle tank!");
			GivePlayerMoneyEx(playerid, -value);
			VehGasOil[vehicleid] += amount;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cGasOil] += amount;
			}
			
			GasOil -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"liter gas oil seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_MATERIAL)
	{
		new totalall;
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pMaterial] + amount;
			new value = amount * MaterialPrice;
			if(amount < 0 || amount > 500) return ErrorMsg(playerid, "amount maximal 0 - 500.");
			if(total > 500) return ErrorMsg(playerid, "Material terlalu penuh di Inventory! Maximal 500.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(Material < amount) return ErrorMsg(playerid, "Material stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pMaterial] += amount;
			Material -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"material seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_OBAT)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pObat] + amount;
			new value = amount * ObatPrice;
			if(amount < 0 || amount > 5) return ErrorMsg(playerid, "amount maximal 0 - 5.");
			if(total > 5) return ErrorMsg(playerid, "Obat terlalu penuh di Inventory! Maximal 5.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(ObatMyr < amount) return ErrorMsg(playerid, "Obat stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pObat] += amount;
			ObatMyr -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"obat seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_COMPONENT)
	{
		if(response)
		{
			for(new i = 0; i < MAX_INVENTORY; i++)
			{
				new amount = floatround(strval(inputtext));
				new total = pData[playerid][pComponent] + amount;
				new value = amount * ComponentPrice;
				if(amount < 0 || amount > 1500) return ErrorMsg(playerid, "amount maximal 0 - 1500.");
				if(total > 1500) return ErrorMsg(playerid, "Component terlalu penuh di Inventory! Maximal 1500.");
				if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
				if(Component < amount) return ErrorMsg(playerid, "Component stock tidak mencukupi.");
				if(InventoryData[playerid][i][invTotalQuantity] > 850) return ErrorMsg(playerid, "Inventory Anda full");
				GivePlayerMoneyEx(playerid, -value);
				pData[playerid][pComponent] += amount;
				new duet[500];
				format(duet, sizeof(duet), "Received_%dx", amount);
				ShowItemBox(playerid, "Component", duet, 3096, 4);
				format(duet, sizeof(duet), "Removed_%sx", FormatMoney(value));
				ShowItemBox(playerid, "Uang", duet, 1212, 4);
				Component -= amount;
				Server_AddMoney(value);
			}
		}
	}
	if(dialogid == DIALOG_DRUGS)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pMarijuana] + amount;
			new value = amount * MarijuanaPrice;
			if(amount < 0 || amount > 100) return ErrorMsg(playerid, "amount maximal 0 - 100.");
			if(total > 100) return ErrorMsg(playerid, "Marijuana full in your inventory! max: 100 kg.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(Marijuana < amount) return ErrorMsg(playerid, "Marijuana stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pMarijuana] += amount;
			Marijuana -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Marijuana seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_AYAMFILL)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][AyamFillet] + amount;
			new value = amount * AyamFillPrice;
			if(amount < 0 || amount > 100) return ErrorMsg(playerid, "amount maximal 0 - 100.");
			if(total > 100) return ErrorMsg(playerid, "Ayam full in your inventory! max: 100kg.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(AyamFill < amount) return ErrorMsg(playerid, "ayam stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][AyamFillet] += amount;
			AyamFill -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"ayam seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_FOOD)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					//buy food
					if(pData[playerid][pFood] > 500) return ErrorMsg(playerid, "Anda sudah membawa 500 Food!");
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah Food:\nFood Stock: "GREEN_E"%d\n"WHITE_E"Food Price"GREEN_E"%s /item", Food, FormatMoney(FoodPrice));
					ShowPlayerDialog(playerid, DIALOG_FOOD_BUY, DIALOG_STYLE_INPUT, "Buy Food", mstr, "Beli", "Batal");
				}
				case 1:
				{
					//buy seed
					if(pData[playerid][pSeed] > 100) return ErrorMsg(playerid, "Anda sudah membawa 100 Seed!");
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah Seed:\nFood Stock: "GREEN_E"%d\n"WHITE_E"Seed Price"GREEN_E"%s /item", Food, FormatMoney(SeedPrice));
					ShowPlayerDialog(playerid, DIALOG_SEED_BUY, DIALOG_STYLE_INPUT, "Buy Seed", mstr, "Beli", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_FOOD_BUY)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pFood] + amount;
			new value = amount * FoodPrice;
			if(amount < 0 || amount > 500) return ErrorMsg(playerid, "amount maximal 0 - 500.");
			if(total > 500) return ErrorMsg(playerid, "Food terlalu penuh di Inventory! Maximal 500.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(Food < amount) return ErrorMsg(playerid, "Food stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pFood] += amount;
			Food -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Food seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_SEED_BUY)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pSeed] + amount;
			new value = amount * SeedPrice;
			if(amount < 0 || amount > 100) return ErrorMsg(playerid, "amount maximal 0 - 100.");
			if(total > 100) return ErrorMsg(playerid, "Seed terlalu penuh di Inventory! Maximal 100.");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(Food < amount) return ErrorMsg(playerid, "Food stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pSeed] += amount;
			Food -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Seed seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_AMOUNT)
	{
		if (response)
		{
			new str[125];

			pData[playerid][pGiveAmount] = strval(inputtext);
			format(str, sizeof(str), "%d", strval(inputtext));
			PlayerTextDrawSetString(playerid, INVINFO[playerid][6], str);
		}
	}
 	if(dialogid == DIALOG_GIVE)
	{
		if (response)
		{
  			new p2 = GetPlayerListitemValue(playerid, listitem);
			new itemid = pData[playerid][pSelectItem];
			new value = pData[playerid][pGiveAmount];

			CallLocalFunction("OnPlayerGiveInvItem", "ddds[128]d", playerid, p2, itemid, InventoryData[playerid][itemid][invItem], value);
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Sprunk(1 - 500):\nPrice 1(Sprunk): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice1]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE1, DIALOG_STYLE_INPUT, "Price 1", mstr, "Edit", "Batal");
				}
				case 1:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Snack(1 - 500):\nPrice 2(Snack): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice2]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE2, DIALOG_STYLE_INPUT, "Price 2", mstr, "Edit", "Batal");
				}
				case 2:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Ice Cream Orange(1 - 500):\nPrice 3(Ice Cream Orange): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice3]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE3, DIALOG_STYLE_INPUT, "Price 3", mstr, "Edit", "Batal");
				}
				case 3:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Hotdog(1 - 500):\nPrice 4(Hotdog): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice4]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE4, DIALOG_STYLE_INPUT, "Price 4", mstr, "Edit", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE1)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			
			if(amount < 0 || amount > 500) return ErrorMsg(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice1] = amount;
			Info(playerid, "Anda berhasil mengedit price 1(Sprunk) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE2)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			
			if(amount < 0 || amount > 500) return ErrorMsg(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice2] = amount;
			Info(playerid, "Anda berhasil mengedit price 2(Snack) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE3)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			
			if(amount < 0 || amount > 500) return ErrorMsg(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice3] = amount;
			Info(playerid, "Anda berhasil mengedit price 3(Ice Cream Orange) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE4)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			
			if(amount < 0 || amount > 500) return ErrorMsg(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice4] = amount;
			Info(playerid, "Anda berhasil mengedit price 4(Hotdog) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_OFFER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return ErrorMsg(playerid, "You not near with offer player!");
					
					if(GetPlayerMoney(playerid) < pData[id][pPrice1])
						return ErrorMsg(playerid, "Not enough money!");
						
					if(pData[id][pFood] < 5)
						return ErrorMsg(playerid, "Food stock empty!");
					
					GivePlayerMoneyEx(id, pData[id][pPrice1]);
					pData[id][pFood] -= 5;
					
					GivePlayerMoneyEx(playerid, -pData[id][pPrice1]);
					pData[playerid][pSprunk] += 1;
					
					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli sprunk seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice1]));
				}
				case 1:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return ErrorMsg(playerid, "You not near with offer player!");
					
					if(GetPlayerMoney(playerid) < pData[id][pPrice2])
						return ErrorMsg(playerid, "Not enough money!");
					
					if(pData[id][pFood] < 5)
						return ErrorMsg(playerid, "Food stock empty!");
						
					GivePlayerMoneyEx(id, pData[id][pPrice2]);
					pData[id][pFood] -= 5;
					
					GivePlayerMoneyEx(playerid, -pData[id][pPrice2]);
					pData[playerid][pSnack] += 1;
					
					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli snack seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice2]));	
				}
				case 2:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return ErrorMsg(playerid, "You not near with offer player!");
					
					if(GetPlayerMoney(playerid) < pData[id][pPrice3])
						return ErrorMsg(playerid, "Not enough money!");
					
					if(pData[id][pFood] < 10)
						return ErrorMsg(playerid, "Food stock empty!");
						
					GivePlayerMoneyEx(id, pData[id][pPrice3]);
					pData[id][pFood] -= 10;
					
					GivePlayerMoneyEx(playerid, -pData[id][pPrice3]);
					pData[playerid][pEnergy] += 30;
					
					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli ice cream orange seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice3]));
				}
				case 3:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return ErrorMsg(playerid, "You not near with offer player!");
					
					if(GetPlayerMoney(playerid) < pData[id][pPrice4])
						return ErrorMsg(playerid, "Not enough money!");
						
					if(pData[id][pFood] < 10)
						return ErrorMsg(playerid, "Food stock empty!");
					
					GivePlayerMoneyEx(id, pData[id][pPrice4]);
					pData[id][pFood] -= 10;
					
					GivePlayerMoneyEx(playerid, -pData[id][pPrice4]);
					pData[playerid][pHunger] += 30;
					
					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli hotdog seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice4]));
				}
			}
		}
		pData[playerid][pOffer] = -1;
	}
	if(dialogid == DIALOG_APOTEK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(Apotek < 1) return ErrorMsg(playerid, "Product out of stock!");
					if(GetPlayerMoney(playerid) < MedicinePrice) return ErrorMsg(playerid, "Not enough money.");
					pData[playerid][pMedicine]++;
					Apotek--;
					GivePlayerMoneyEx(playerid, -MedicinePrice);
					Server_AddMoney(MedicinePrice);
					Info(playerid, "Anda membeli medicine seharga "RED_E"%s,"WHITE_E" /use untuk menggunakannya.", FormatMoney(MedicinePrice));
				}
				case 1:
				{
					if(Apotek < 1) return ErrorMsg(playerid, "Product out of stock!");
					if(pData[playerid][pFaction] != 3) return ErrorMsg(playerid, "You are not a medical member.");
					if(GetPlayerMoney(playerid) < MedkitPrice) return ErrorMsg(playerid, "Not enough money.");
					pData[playerid][pMedkit]++;
					Apotek--;
					GivePlayerMoneyEx(playerid, -MedkitPrice);
					Server_AddMoney(MedkitPrice);
					Info(playerid, "Anda membeli medkit seharga "RED_E"%s", FormatMoney(MedkitPrice));
				}
				case 2:
				{
					if(Apotek < 1) return ErrorMsg(playerid, "Product out of stock!");
					if(pData[playerid][pFaction] != 3) return ErrorMsg(playerid, "You are not a medical member.");
					if(GetPlayerMoney(playerid) < 100) return ErrorMsg(playerid, "Not enough money.");
					pData[playerid][pBandage]++;
					Apotek--;
					GivePlayerMoneyEx(playerid, -100);
					Server_AddMoney(100);
					Info(playerid, "Anda membeli bandage seharga "RED_E"$100");
				}
			}
		}
	}
	if(dialogid == DIALOG_MENUMASAK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //ayam goreng
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pTepung] < 1) return ErrorMsg(playerid, "Kamu MembutuhKan  Tepung");
					if(pData[playerid][AyamFillet] < 2) return ErrorMsg(playerid, "Snack tidak cukup!(Butuh: 2).");

					pData[playerid][AyamFillet] -= 2;
					pData[playerid][pTepung] -= 1;

					InfoMsg(playerid, "Anda Memulai memasak!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pChiken] += 1;
					ShowProgressbar(playerid, "Memasak Chiken..", 10);
                 	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
					ShowItemBox(playerid, "Ayam Goreng", "Received_1x", 19847, 4);
					pData[playerid][pEnergy] -= 2;
				}
				case 1: //es teh
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMineral] < 2) return ErrorMsg(playerid, "Kamu MembutuhKan 2 Liter Air mineral.");
					if(pData[playerid][pOrange] < 3) return ErrorMsg(playerid, "Kamu MembutuhKan 3 Orange.");

					pData[playerid][pOrange] -= 2;
					pData[playerid][pMineral] -= 2;

					InfoMsg(playerid, "Anda Memulai membuat esteh!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pCappucino] += 1;
					ShowProgressbar(playerid, "Membuat Es teh..", 10);
                 	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
					ShowItemBox(playerid, "Teh Es", "Received_1x", 19835, 4);
					pData[playerid][pEnergy] -= 2;
				}
				case 2: //chiken
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pTepung] < 1) return ErrorMsg(playerid, "Kamu MembutuhKan Tepung!");
					if(pData[playerid][AyamFillet] < 2) return ErrorMsg(playerid, "Kamu MembutuhKan 2 Ayam Fillet.");


					pData[playerid][AyamFillet] -= 2;
					pData[playerid][pTepung] -= 1;

					InfoMsg(playerid, "Anda Memulai memasak!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pChiken] += 1;
					ShowProgressbar(playerid, "Memasak Chiken..", 10);
                 	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
					ShowItemBox(playerid, "Chiken", "Received_1x", 19847, 4);
					pData[playerid][pEnergy] -= 2;
				}
				case 3: //steak ayam
				{
					if(pData[playerid][pActivityTime] > 5) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][AyamFillet] < 1) return ErrorMsg(playerid, "Kamu MembutuhKan 1 Ayam Fillet.");
					
					pData[playerid][AyamFillet] -= 1;

					InfoMsg(playerid, "Anda Memulai memasak!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pSteak] += 1;
					ShowProgressbar(playerid, "Memasak Steak..", 10);
                 	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
					ShowItemBox(playerid, "Steak", "Received_1x", 2769, 4);
					pData[playerid][pEnergy] -= 2;
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_MENUMINUM)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //WATER
				{
					pData[playerid][pSprunk] += 5;
					ShowItemBox(playerid, "Water", "Received_5x", 2958, 3);
					SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s mengambil water di kulkas.", ReturnName(playerid));
				}
				case 1: //CAPPUCINO
				{
					pData[playerid][pCappucino] += 5;
					ShowItemBox(playerid, "Cappucino", "Received_5x", 19835, 3);
					SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s mengambil cappucino di kulkas.", ReturnName(playerid));
				}
				case 2: //STARLING
				{
					pData[playerid][pStarling] += 5;
					ShowItemBox(playerid, "Starling", "Received_5x", 1455, 3);
					SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s mengambil starling di kulkas.", ReturnName(playerid));
				}
				case 3: //MILK
				{
					pData[playerid][pMilxMax] += 5;
					ShowItemBox(playerid, "Milx_Max", "Received_5x", 19570, 3);
					SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "ACTION: {7348EB}%s mengambil milxmax di kulkas.", ReturnName(playerid));
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERPEDAGANG)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetPlayerColor(playerid, COLOR_GOLD);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 168);
							pData[playerid][pFacSkin] = 168;
						}
						else
						{
							SetPlayerSkin(playerid, 169);
							pData[playerid][pFacSkin] = 169;
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return ErrorMsg(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, PDGSkinMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, PDGSkinFemale, "Choose your skin");
					}
				}
			}
		}
		return 1;
	}

	if(dialogid == DIALOG_LOCKFAMS)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					SetPlayerHealthEx(playerid, 100);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 1:
				{
					new str[1024];
					new fid = pData[playerid][pFamily];
					format(str, sizeof(str), ""WHITE_E"Name\tID\n\
						"LG_E"Kapten\t%d\n\
						"LG_E"Senior\t%d\n\
						"LG_E"Junior1\t%d\n\
						"LG_E"Junior2\t%d\n\
						"LG_E"Junior3\t%d\n",
						fData[fid][fSkin][0],
						fData[fid][fSkin][1],
						fData[fid][fSkin][2],
						fData[fid][fSkin][3],
						fData[fid][fSkin][4]);
					ShowPlayerDialog(playerid, DIALOG_SKINFAM, DIALOG_STYLE_TABLIST_HEADERS, "Skin Fam", str, "Use", "Tutup");
				}
			}
		}
		return 1;
	}

	if(dialogid == DIALOG_SKINFAM)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new fid = pData[playerid][pFamily];
					new modelid = fData[fid][fSkin][0];

					pData[playerid][pFacSkin] = modelid;
					SetPlayerSkin(playerid, modelid);
					Servers(playerid, "Anda telah mengganti Family skin menjadi ID %d", modelid);
					RefreshPSkin(playerid);
				}
				case 1:
				{
					new fid = pData[playerid][pFamily];
					new modelid = fData[fid][fSkin][1];

					pData[playerid][pFacSkin] = modelid;
					SetPlayerSkin(playerid, modelid);
					Servers(playerid, "Anda telah mengganti Family skin menjadi ID %d", modelid);
					RefreshPSkin(playerid);
				}
				case 2:
				{
					new fid = pData[playerid][pFamily];
					new modelid = fData[fid][fSkin][2];

					pData[playerid][pFacSkin] = modelid;
					SetPlayerSkin(playerid, modelid);
					Servers(playerid, "Anda telah mengganti Family skin menjadi ID %d", modelid);
					RefreshPSkin(playerid);
				}
				case 3:
				{
					new fid = pData[playerid][pFamily];
					new modelid = fData[fid][fSkin][3];

					pData[playerid][pFacSkin] = modelid;
					SetPlayerSkin(playerid, modelid);
					Servers(playerid, "Anda telah mengganti Family skin menjadi ID %d", modelid);
					RefreshPSkin(playerid);
				}
				case 4:
				{
					new fid = pData[playerid][pFamily];
					new modelid = fData[fid][fSkin][4];

					pData[playerid][pFacSkin] = modelid;
					SetPlayerSkin(playerid, modelid);
					Servers(playerid, "Anda telah mengganti Family skin menjadi ID %d", modelid);
					RefreshPSkin(playerid);
				}
			}
		}
		return 1;
	}

	if(dialogid == DIALOG_WEAPONPEDAGANG)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					GivePlayerWeaponEx(playerid, 42, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(42));
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 4, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(1));
				}
			}
		}
	}		
	if(dialogid == DIALOG_AYAM)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 921.4352,-1297.6184,14.0938, 0.0,0.0,0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, -2107.4541,-2400.1042,31.4123, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
			}
		}
	}
	if(dialogid == DIALOG_ATM)
	{
		if(!response) return 1;
		switch(listitem)
		{
			case 0: // Check Balance
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "Detail Nasabah:\nNama Lengkap: %s\nNomor Rekening: %d\nSaldo: %s.", pData[playerid][pName], pData[playerid][pBankRek], FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Executive - Cek Saldo", mstr, "Tutup", "");
			}
			case 1: // Deposit
			{
				ShowPlayerDialog(playerid, DIALOG_BANKDEPOSIT, DIALOG_STYLE_INPUT, "Executive - Deposit", "Mohon masukan berapa jumlah yang ingin disimpan:", "Simpan", "Batal");
			}
			case 2: // WithDraw
			{
				ShowPlayerDialog(playerid, DIALOG_BANKWITHDRAW, DIALOG_STYLE_INPUT, "Executive - Withdraw", "Mohon masukan berapa jumlah yang ingin ditarik:", "Tarik", "Batal");
			}
			case 3: //Transfer
			{
				ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, "Executive - Transfer", "Mohon masukan jumlah uang yang ingin di transfer:", "Transfer", "Batal");
			}
		}
	}
	if(dialogid == DIALOG_BANK)
	{
		if(!response) return true;
		switch(listitem)
		{
			case 0: // Deposit
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in bank account.\n\nType in the amount you want to deposit below:", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_BANKDEPOSIT, DIALOG_STYLE_INPUT, ""LB_E"Bank", mstr, "Deposit", "Batal");
			}
			case 1: // Withdraw
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.\n\nType in the amount you want to withdraw below:", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_BANKWITHDRAW, DIALOG_STYLE_INPUT, ""LB_E"Bank", mstr, "Withdraw", "Batal");
			}
			case 2: // Check Balance
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""LB_E"Bank", mstr, "Tutup", "");
			}
			case 3: //Transfer Money
			{
				ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Masukan jumlah uang:", "Transfer", "Batal");
			}
			case 4:
			{
				DisplayPaycheck(playerid);
			}
		}
	}
	if(dialogid == DIALOG_GOTOPUP)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pBankMoney]) return ErrorMsg(playerid, "Anda tidak memiliki uang di bank.");
		if(amount < 50) return ErrorMsg(playerid, "Minimal topup $50!");

		else
		{
			new query[512], lstr[512];
			pData[playerid][pBankMoney] = (pData[playerid][pBankMoney] - amount);
			pData[playerid][pGopay] += amount;
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=%d,money=%d WHERE reg_id=%d", pData[playerid][pBankMoney], pData[playerid][pMoney], pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			format(lstr, sizeof(lstr), "Anda berhasil topup gopay sebanyak %s", FormatMoney(amount));
			SuccesMsg(playerid, lstr);
		}
	}
	if(dialogid == DIALOG_BANKDEPOSIT)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pMoney]) return ErrorMsg(playerid, "Anda tidak memiliki uang segitu.");
		if(amount < 1) return ErrorMsg(playerid, "Angka yang anda masukan tidak valid!");

		else
		{
			new query[512], lstr[512];
			pData[playerid][pBankMoney] = (pData[playerid][pBankMoney] + amount);
			GivePlayerMoneyEx(playerid, -amount);
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=%d,money=%d WHERE reg_id=%d", pData[playerid][pBankMoney], pData[playerid][pMoney], pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			format(lstr, sizeof(lstr), "Anda berhasil deposit sebanyak %s ke dalam akun bank anda", FormatMoney(amount));
			SuccesMsg(playerid, lstr);
		}
	}
	if(dialogid == DIALOG_WITHDEPO)
	{
		if(!response) return true;
		new ph = strval(inputtext);
		pData[playerid][pInputMoney] = ph;
		new AtmInfo[560];
	   	format(AtmInfo,1000,"%s", inputtext);
	   	PlayerTextDrawSetString(playerid, AtmTD[playerid][57], AtmInfo);
	}
	if(dialogid == DIALOG_BANKWITHDRAW)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pBankMoney]) return ErrorMsg(playerid, "Anda tidak memiliki uang sebanyak itu di bank.");
		if(amount < 1) return ErrorMsg(playerid, "Angka yang anda masukan tidak valid!");
		else
		{
			new query[128], lstr[512];
			pData[playerid][pBankMoney] = (pData[playerid][pBankMoney] - amount);
			GivePlayerMoneyEx(playerid, amount);
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=%d,money=%d WHERE reg_id=%d", pData[playerid][pBankMoney], pData[playerid][pMoney], pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			format(lstr, sizeof(lstr), "Anda berhasil menarik uang sejumlah %s dari rekening anda.", FormatMoney(amount));
			SuccesMsg(playerid, lstr);
		}
	}
	if(dialogid == DIALOG_BANKREKENING)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pBankMoney]) return ErrorMsg(playerid, "Uang dalam rekening anda kurang.");
		if(amount < 1) return ErrorMsg(playerid, "You have entered an invalid amount!");

		else
		{
			pData[playerid][pTransfer] = amount;
			ShowPlayerDialog(playerid, DIALOG_BANKTRANSFER, DIALOG_STYLE_INPUT, "Executive - Transfer", "Mohon Masukan nomor rekening tujuan:", "Transfer", "Batal");
		}
	}
	if(dialogid == DIALOG_BANKTRANSFER)
	{
		if(!response) return true;
		new rek = floatround(strval(inputtext)), query[128];
		
		mysql_format(g_SQL, query, sizeof(query), "SELECT brek FROM players WHERE brek='%d'", rek);
		mysql_tquery(g_SQL, query, "SearchRek", "id", playerid, rek);
		return 1;
	}
	if(dialogid == DIALOG_BANKCONFIRM)
	{
		if(response)
		{
			new query[128], mstr[248];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=bmoney+%d WHERE brek=%d", pData[playerid][pTransfer], pData[playerid][pTransferRek]);
			mysql_tquery(g_SQL, query);
			
			foreach(new ii : Player)
			{
				if(pData[ii][pBankRek] == pData[playerid][pTransferRek])
				{
					pData[ii][pBankMoney] += pData[playerid][pTransfer];
				}
			}
			
			pData[playerid][pBankMoney] -= pData[playerid][pTransfer];
			
			format(mstr, sizeof(mstr), ""WHITE_E"No Rek Target: "YELLOW_E"%d\n"WHITE_E"Nama Target: "YELLOW_E"%s\n"WHITE_E"Jumlah: "GREEN_E"%s\n\n"WHITE_E"Anda telah berhasil mentransfer!", pData[playerid][pTransferRek], pData[playerid][pTransferName], FormatMoney(pData[playerid][pTransfer]));
			ShowPlayerDialog(playerid, DIALOG_BANKSUKSES, DIALOG_STYLE_MSGBOX, ""LB_E"Transfer Sukses", mstr, "Sukses", "");
		}
	}
	if(dialogid == DIALOG_BANKSUKSES)
	{
		if(response)
		{
			pData[playerid][pTransfer] = 0;
			pData[playerid][pTransferRek] = 0;
		}
	}
	if(dialogid == DIALOG_ASKS)
	{
		if(response) 
		{
			//new i = strval(inputtext);
			new i = listitem;
			new tstr[64], mstr[128], lstr[512];

			strunpack(mstr, AskData[i][askText]);
			format(tstr, sizeof(tstr), ""GREEN_E"Ask Id: #%d", i);
			format(lstr,sizeof(lstr),""WHITE_E"Asked: "GREEN_E"%s\n"WHITE_E"Question: "RED_E"%s.", pData[AskData[i][askPlayer]][pName], mstr);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX,tstr,lstr,"Tutup","");
		}
	}
	if(dialogid == DIALOG_REPORTS)
	{
		if(response) 
		{
			//new i = strval(inputtext);
			new i = listitem;
			new tstr[64], mstr[128], lstr[512];

			strunpack(mstr, ReportData[i][rText]);
			format(tstr, sizeof(tstr), ""GREEN_E"Report Id: #%d", i);
			format(lstr,sizeof(lstr),""WHITE_E"Reported: "GREEN_E"%s\n"WHITE_E"Reason: "RED_E"%s.", pData[ReportData[i][rPlayer]][pName], mstr);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX,tstr,lstr,"Tutup","");
		}
	}
	/*if(dialogid == DIALOG_REPORTS)
	{
	    new
		id = g_player_listitem[playerid][listitem],
		otherid = ReportData[id][rPlayer];

	    if(response)
	    {
	        if(!IsPlayerConnected(otherid))
		        return ClearReport(id);

			ShowPlayerDialog(playerid, DIALOG_ANSWER_REPORTS, DIALOG_STYLE_INPUT, "Panel Keluhan",
			"Apa yang anda ingin lakukan pada keluhan ini?\n"\
			"Jika anda ingin menolaknya anda bisa mengisi alasan pada box dibawah\n"\
			"Namun, jika anda ingin menerimanya. Anda hanya perlu melakukan klik pada tombol terima", "Terima", "Tolak");

			SetPVarInt(playerid, "TEMP_LISTITEM", id);
		}
    }
	if(dialogid == DIALOG_ANSWER_REPORTS)
	{
	    new id = GetPVarInt(playerid, "TEMP_LISTITEM");
	    new string[144];
	            
	    if(Iter_Contains(Reports, id))
	    {
	        if(response)
			{
				format(string, sizeof(string), "{FF0000}[REPORT] {FFFFFF}Admin {FFFF00}%s {FFFFFF}menerima laporan anda", g_player_name[playerid]);
		        SendClientMessage(ReportData[id][rPlayer], -1, string);

		        format(string, sizeof(string), "{FF0000}[REPORT] {FFFFFF}Anda menerima laporan dari {FFFF00}%s", ReportData[id][rPlayerName]);
		        SendClientMessage(playerid, -1, string);
		    }
		    else
		    {
		        format(string, sizeof(string), "{FF0000}[REPORT] {FFFFFF}Admin {FFFF00}%s {FFFFFF}menolak laporan anda | %s", g_player_name[playerid], inputtext);
		        SendClientMessage(ReportData[id][rPlayer], -1, string);

                format(string, sizeof(string), "{FF0000}[REPORT] {FFFFFF}Anda menerima laporan dari {FFFF00}%s", ReportData[id][rPlayerName]);
                SendClientMessage(playerid, -1, string);
            }
        }
        ClearReport(id);
        DeletePVar(playerid, "TEMP_LISTITEM");
    }*/
	if(dialogid == DIALOG_BUYPV)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(!IsPlayerInAnyVehicle(playerid))
			{
				TogglePlayerControllable(playerid, 1);
				ErrorMsg(playerid,"Anda harus berada di dalam kendaraan untuk membelinya.");
				return 1;
			}
			new cost = GetVehicleCost(GetVehicleModel(vehicleid));
			if(pData[playerid][pMoney] < cost)
			{
				ErrorMsg(playerid, "Uang anda tidak mencukupi.!");
				RemovePlayerFromVehicle(playerid);
				//new Float:slx, Float:sly, Float:slz;
				//GetPlayerPos(playerid, slx, sly, slz);
				//SetPlayerPos(playerid, slx, sly+1.2, slz+1.3);
				//TogglePlayerControllable(playerid, 1);
				//SetVehicleToRespawn(vehicleid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			//if(playerid == INVALID_PLAYER_ID) return ErrorMsg(playerid, "Invalid player ID!");
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				ErrorMsg(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				RemovePlayerFromVehicle(playerid);
				//new Float:slx, Float:sly, Float:slz;
				//GetPlayerPos(playerid, slx, sly, slz);
				//SetPlayerPos(playerid, slx, sly, slz+1.3);
				//TogglePlayerControllable(playerid, 1);
				//SetVehicleToRespawn(vehicleid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			GivePlayerMoneyEx(playerid, -cost);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 0;
			color2 = 0;
			model = GetVehicleModel(GetPlayerVehicleID(playerid));
			x = 1198.13;
			y = -889.93;
			z = 43.16;
			a = 2.22;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyPV", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			/*new cQuery[1024], model = GetVehicleModel(GetPlayerVehicleID(playerid)), color1 = 0, color2 = 0,
			Float:x = 1805.13, Float:y = -1708.09, Float:z = 13.54, Float:a = 179.23, price = GetVehicleCost(GetVehicleModel(GetPlayerVehicleID(playerid)));
			format(cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, price, x, y, z, a);
			MySQL_query(cQuery, false, "OnVehBuyed", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, price, x, y, z, a);
			Servers(playerid, "harusnya bisaa");*/
			return 1;
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			//new Float:slx, Float:sly, Float:slz;
			//GetPlayerPos(playerid, slx, sly, slz);
			//SetPlayerPos(playerid, slx, sly, slz+1.3);
			//TogglePlayerControllable(playerid, 1);
			//SetVehicleToRespawn(vehicleid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			return 1;
		}
	}
	if(dialogid == DIALOG_BUYVIPPV)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(!IsPlayerInAnyVehicle(playerid))
			{
				TogglePlayerControllable(playerid, 1);
				ErrorMsg(playerid,"Anda harus berada di dalam kendaraan untuk membelinya.");
				return 1;
			}
			new gold = GetVipVehicleCost(GetVehicleModel(vehicleid));
			new cost = GetVehicleCost(GetVehicleModel(vehicleid));
			if(pData[playerid][pGold] < gold)
			{
				ErrorMsg(playerid, "gold anda tidak mencukupi!");
				RemovePlayerFromVehicle(playerid);
				//new Float:slx, Float:sly, Float:slz;
				//GetPlayerPos(playerid, slx, sly, slz);
				//SetPlayerPos(playerid, slx, sly, slz+1.3);
				//TogglePlayerControllable(playerid, 1);
				//SetVehicleToRespawn(vehicleid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			//if(playerid == INVALID_PLAYER_ID) return ErrorMsg(playerid, "Invalid player ID!");
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				ErrorMsg(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				RemovePlayerFromVehicle(playerid);
				//new Float:slx, Float:sly, Float:slz;
				//GetPlayerPos(playerid, slx, sly, slz);
				//SetPlayerPos(playerid, slx, sly, slz+1.3);
				//TogglePlayerControllable(playerid, 1);
				//SetVehicleToRespawn(vehicleid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			pData[playerid][pGold] -= gold;
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 0;
			color2 = 0;
			model = GetVehicleModel(GetPlayerVehicleID(playerid));
			x = 1805.93;
			y = -1791.19;
			z = 13.54;
			a = 2.22;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyVIPPV", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			/*new cQuery[1024], model = GetVehicleModel(GetPlayerVehicleID(playerid)), color1 = 0, color2 = 0,
			Float:x = 1805.13, Float:y = -1708.09, Float:z = 13.54, Float:a = 179.23, price = GetVehicleCost(GetVehicleModel(GetPlayerVehicleID(playerid)));
			format(cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, price, x, y, z, a);
			MySQL_query(cQuery, false, "OnVehBuyed", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, price, x, y, z, a);
			Servers(playerid, "harusnya bisaa");*/
			return 1;
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			//new Float:slx, Float:sly, Float:slz;
			//GetPlayerPos(playerid, slx, sly, slz);
			//SetPlayerPos(playerid, slx, sly, slz+1.3);
			//TogglePlayerControllable(playerid, 1);
			//SetVehicleToRespawn(vehicleid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			return 1;
		}
	}
	if(dialogid == DIALOG_BUYPVCP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					//Bikes
					new str[1024];
					
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n", 
					GetVehicleModelName(481), FormatMoney(GetVehicleCost(481)), 
					GetVehicleModelName(509), FormatMoney(GetVehicleCost(509)),
					GetVehicleModelName(510), FormatMoney(GetVehicleCost(510)),
					GetVehicleModelName(462), FormatMoney(GetVehicleCost(462)),
					GetVehicleModelName(586), FormatMoney(GetVehicleCost(586)),
					GetVehicleModelName(581), FormatMoney(GetVehicleCost(581)),
					GetVehicleModelName(461), FormatMoney(GetVehicleCost(461)),
					GetVehicleModelName(521), FormatMoney(GetVehicleCost(521)),
					GetVehicleModelName(463), FormatMoney(GetVehicleCost(463)),
					GetVehicleModelName(468), FormatMoney(GetVehicleCost(468))
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_BIKES, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Sepeda Motor", str, "Beli", "Tutup");
				}
				case 1:
				{
					//Cars
					new str[1024];
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n", 
					GetVehicleModelName(400), FormatMoney(GetVehicleCost(400)), 
					GetVehicleModelName(412), FormatMoney(GetVehicleCost(412)),
					GetVehicleModelName(419), FormatMoney(GetVehicleCost(419)),
					GetVehicleModelName(426), FormatMoney(GetVehicleCost(426)),
					GetVehicleModelName(436), FormatMoney(GetVehicleCost(436)),
					GetVehicleModelName(466), FormatMoney(GetVehicleCost(466)),
					GetVehicleModelName(467), FormatMoney(GetVehicleCost(467)),
					GetVehicleModelName(474), FormatMoney(GetVehicleCost(474)),
					GetVehicleModelName(475), FormatMoney(GetVehicleCost(475)),
					GetVehicleModelName(480), FormatMoney(GetVehicleCost(480)),
					GetVehicleModelName(603), FormatMoney(GetVehicleCost(603)),
					GetVehicleModelName(421), FormatMoney(GetVehicleCost(421)),
					GetVehicleModelName(602), FormatMoney(GetVehicleCost(602)),
					GetVehicleModelName(492), FormatMoney(GetVehicleCost(492)),
					GetVehicleModelName(545), FormatMoney(GetVehicleCost(545)),
					GetVehicleModelName(489), FormatMoney(GetVehicleCost(489)),
					GetVehicleModelName(405), FormatMoney(GetVehicleCost(405)),
					GetVehicleModelName(445), FormatMoney(GetVehicleCost(445)),
					GetVehicleModelName(579), FormatMoney(GetVehicleCost(579)),
					GetVehicleModelName(507), FormatMoney(GetVehicleCost(507))
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CARS, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Mobil", str, "Beli", "Tutup");
				}
				case 2:
				{
					//Unique Cars
					new str[1024];
					format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n",
					GetVehicleModelName(483), FormatMoney(GetVehicleCost(483)), 
					GetVehicleModelName(534), FormatMoney(GetVehicleCost(534)),
					GetVehicleModelName(535), FormatMoney(GetVehicleCost(535)),
					GetVehicleModelName(536), FormatMoney(GetVehicleCost(536)),
					GetVehicleModelName(558), FormatMoney(GetVehicleCost(558)),
					GetVehicleModelName(560), FormatMoney(GetVehicleCost(560)),
					GetVehicleModelName(565), FormatMoney(GetVehicleCost(565)),
					GetVehicleModelName(567), FormatMoney(GetVehicleCost(567)),
					GetVehicleModelName(575), FormatMoney(GetVehicleCost(575)),
					GetVehicleModelName(576), FormatMoney(GetVehicleCost(576))
					);
					
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_UCARS, DIALOG_STYLE_TABLIST_HEADERS, "Executive - Kendaraan Unik", str, "Beli", "Tutup");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_BIKES)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 481;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Motor", tstr, "Beli", "Batal");
				}
				case 1:
				{
					new modelid = 509;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Motor", tstr, "Beli", "Batal");
				}
				case 2:
				{
					new modelid = 510;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Motor", tstr, "Beli", "Batal");
				}
				case 3:
				{
					new modelid = 462;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Motor", tstr, "Beli", "Batal");
				}
				case 4:
				{
					new modelid = 586;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Motor", tstr, "Beli", "Batal");
				}
				case 5:
				{
					new modelid = 581;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Motor", tstr, "Beli", "Batal");
				}
				case 6:
				{
					new modelid = 461;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Motor", tstr, "Beli", "Batal");
				}
				case 7:
				{
					new modelid = 521;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Motor", tstr, "Beli", "Batal");
				}
				case 8:
				{
					new modelid = 463;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Motor", tstr, "Beli", "Batal");
				}
				case 9:
				{
					new modelid = 468;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Motor", tstr, "Beli", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_CARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 400;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 1:
				{
					new modelid = 412;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 2:
				{
					new modelid = 419;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 3:
				{
					new modelid = 426;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 4:
				{
					new modelid = 436;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 5:
				{
					new modelid = 466;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 6:
				{
					new modelid = 467;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 7:
				{
					new modelid = 474;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 8:
				{
					new modelid = 475;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 9:
				{
					new modelid = 480;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 10:
				{
					new modelid = 603;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 11:
				{
					new modelid = 421;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 12:
				{
					new modelid = 602;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 13:
				{
					new modelid = 492;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 14:
				{
					new modelid = 545;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 15:
				{
					new modelid = 489;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 16:
				{
					new modelid = 405;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 17:
				{
					new modelid = 445;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 18:
				{
					new modelid = 579;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 19:
				{
					new modelid = 507;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_UCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 483;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 1:
				{
					new modelid = 534;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 2:
				{
					new modelid = 535;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 3:
				{
					new modelid = 536;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 4:
				{
					new modelid = 558;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				/*ase 5:
				{
					new modelid = 559;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}*/
				case 5:
				{
					new modelid = 560;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				/*case 7:
				{
					new modelid = 561;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}*/
				case 6:
				{
					new modelid = 562;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 7:
				{
					new modelid = 565;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 8:
				{
					new modelid = 567;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 9:
				{
					new modelid = 575;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 10:
				{
					new modelid = 576;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_JOBCARS)
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
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 1:
				{
					new modelid = 403;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 2:
				{
					new modelid = 413;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 3:
				{
					new modelid = 414;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 4:
				{
					new modelid = 422;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 5:
				{
					new modelid = 440;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 6:
				{
					new modelid = 455;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 7:
				{
					new modelid = 456;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 8:
				{
					new modelid = 478;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 9:
				{
					new modelid = 482;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 10:
				{
					new modelid = 498;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 11:
				{
					new modelid = 499;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 12:
				{
					new modelid = 423;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 13:
				{
					new modelid = 588;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 14:
				{
					new modelid = 524;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 15:
				{
					new modelid = 525;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 16:
				{
					new modelid = 543;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 17:
				{
					new modelid = 552;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 18:
				{
					new modelid = 554;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 19:
				{
					new modelid = 578;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 20:
				{
					new modelid = 609;
					new tstr[128], price = GetDealerVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga {3498DB}%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_VIPCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 522;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 1:
				{
					new modelid = 411;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 2:
				{
					new modelid = 451;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 3:
				{
					new modelid = 415;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 4:
				{
					new modelid = 502;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 5:
				{
					new modelid = 541;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 6:
				{
					new modelid = 429;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 7:
				{
					new modelid = 506;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 8:
				{
					new modelid = 494;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 9:
				{
					new modelid = 502;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 10:
				{
					new modelid = 503;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 11:
				{
					new modelid = 409;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
				case 12:
				{
					new modelid = 477;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Pembelian Kendaraan", tstr, "Beli", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_RENT_JOBCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 414;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 1:
				{
					new modelid = 455;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 2:
				{
					new modelid = 456;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 3:
				{
					new modelid = 498;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 4:
				{
					new modelid = 499;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 5:
				{
					new modelid = 609;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 6:
				{
					new modelid = 478;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 7:
				{
					new modelid = 422;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 8:
				{
					new modelid = 543;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 9:
				{
					new modelid = 554;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 10:
				{
					new modelid = 525;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 11:
				{
					new modelid = 438;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 12:
				{
					new modelid = 420;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 13:
				{
					new modelid = 403;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_RENT_JOBCARSCONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return ErrorMsg(playerid, "Invalid model id.");
			new cost = GetVehicleCost(modelid);
			if(pData[playerid][pMoney] < 500)
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
			GivePlayerMoneyEx(playerid, -500);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2, rental;
			color1 = 0;
			color2 = 0;
			model = modelid;
			x = 1314.96;//spawn pv
			y = -856.87;
			z = 39.44;
			a = 272.45;
			rental = gettime() + (1 * 86400);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`, `rental`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f', '%d')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			mysql_tquery(g_SQL, cQuery, "OnVehRentPV", "ddddddffffd", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_RENT_BOAT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 473;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kapal "PINK_E"%s "WHITE_E"dengan harga "LG_E"$750 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_BOATCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Boats", tstr, "Rental", "Batal");
				}
				case 1:
				{
					new modelid = 453;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kapal "PINK_E"%s "WHITE_E"dengan harga "LG_E"$1.250 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_BOATCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Boats", tstr, "Rental", "Batal");
				}
				case 2:
				{
					new modelid = 452;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kapal "PINK_E"%s "WHITE_E"dengan harga "LG_E"$1.500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_BOATCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Boats", tstr, "Rental", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_RENT_BOATCONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return ErrorMsg(playerid, "Invalid model id.");
			new cost = GetVehicleRentalCost(modelid);
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
			new model, color1, color2, rental;
			color1 = 0;
			color2 = 0;
			model = modelid;
			x = 223.3398;
			y = -1992.5416;
			z = -0.4823;
			a = 268.7136;
			rental = gettime() + (1 * 86400);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`, `rental`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f', '%d')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			mysql_tquery(g_SQL, cQuery, "OnVehRentBoat", "ddddddffffd", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_RENT_BIKE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 509;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa sepeda TDR-3000 dengan harga "LG_E"$75");
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Rental Sepeda", tstr, "Oke", "Batal");
				}
				case 1:
				{
					new modelid = 510;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa Sepeda Gunung Aviator 2690 XT Steel dengan harga "LG_E"$150");
					ShowPlayerDialog(playerid, DIALOG_RENT_BIKECONFIRM, DIALOG_STYLE_MSGBOX, "Executive - Rental Sepeda", tstr, "Oke", "Batal");
				}
				case 2:
				{
				    new vehid = GetNearestVehicleToPlayer(playerid, 3.5, false);
				    foreach(new i : PVehicles)
					{
					if(vehid == pvData[i][cVeh])
					{
						if(pvData[i][cOwner] == pData[playerid][pID])
						{
							if(pvData[i][cRent] != 0)
							{
								Info(playerid, "You has unrental the vehicle id %d (database id: %d).", vehid, pvData[i][cID]);
								new str[150];
								format(str,sizeof(str),"[VEH]: %s unrental kendaraan id %d (database id: %d)!", GetRPName(playerid), vehid, pvData[i][cID]);
								LogServer("Property", str);
								new query[128], xuery[128];
								mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[i][cID]);
								mysql_tquery(g_SQL, query);

								mysql_format(g_SQL, xuery, sizeof(xuery), "DELETE FROM vstorage WHERE owner = '%d'", pvData[i][cID]);
								mysql_tquery(g_SQL, xuery);
								if(IsValidVehicle(pvData[i][cVeh])) DestroyVehicle(pvData[i][cVeh]);
								pvData[i][cVeh] = INVALID_VEHICLE_ID;
								Iter_SafeRemove(PVehicles, i, i);
							}
							else return ErrorMsg(playerid, "This is not rental vehicle! use /sellpv for sell owned vehicle.");
						}
						else return ErrorMsg(playerid, "ID kendaraan ini bukan punya mu! gunakan /v my(/mypv) untuk mencari ID.");
						}
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_RENT_BIKECONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return ErrorMsg(playerid, "Invalid model id.");
			new cost = GetVehicleRentalCost(modelid);
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
			GivePlayerMoneyEx(playerid, -50);
			ShowItemBox(playerid, "Uang", "Removed_$50", 1212, 2);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2, rental;
			GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, a);
			color1 = 0;
			color2 = 0;
			model = modelid;
			rental = gettime() + (1 * 3600);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`, `rental`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f', '%d')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			mysql_tquery(g_SQL, cQuery, "OnVehRentBike", "ddddddffffd", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_BUYPVCP_CONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return ErrorMsg(playerid, "Invalid model id.");
			new cost = GetVehicleCost(modelid);
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
			new duet[500];
			format(duet, sizeof(duet), "Removed_%sx", FormatMoney(cost));
			ShowItemBox(playerid, "Uang", duet, 1212, 2);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 0;
			color2 = 0;
			model = modelid;
			x = 1112.277709;
			y = -1680.282104;
			z = 13.565153;
			a = 174.991470;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyPV", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_BUYPVCP_VIPCONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return ErrorMsg(playerid, "Invalid model id.");
			new cost = GetVipVehicleCost(modelid);
			if(pData[playerid][pGold] < cost)
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
			pData[playerid][pGold] -= cost;
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 0;
			color2 = 0;
			model = modelid;
			x = 535.2369;
			y = -1277.7272;
			z = 16.8134;
			a = 222.1837;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyVIPPV", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	/*if(dialogid == DIALOG_SALARY)
	{
		if(!response) 
		{
			ListPage[playerid]--;
			if(ListPage[playerid] < 0)
			{
				ListPage[playerid] = 0;
				return 1;
			}
		}
		else
		{
			ListPage[playerid]++;
		}
		
		DisplaySalary(playerid);
		return 1;
	}*/
	if(dialogid == DIALOG_PAYCHECK)
	{
		if(response)
		{
			if(pData[playerid][pPaycheck] < 3600) return ErrorMsg(playerid, "Sekarang belum waktunya anda mengambil paycheck.");
			
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM salary WHERE owner='%d' ORDER BY id ASC LIMIT 30", pData[playerid][pID]);
			mysql_query(g_SQL, query);
			new rows = cache_num_rows();
			if(rows) 
			{
				new list[2000], date[30], info[16], money, totalduty, gajiduty, totalsal, total, pajak, hasil;
				
				totalduty = pData[playerid][pOnDutyTime];
				for(new i; i < rows; ++i)
				{
					cache_get_value_name(i, "info", info);
					cache_get_value_name(i, "date", date);
					cache_get_value_name_int(i, "money", money);
					totalsal += money;
				}
				
				if(totalduty > 600)
				{
					gajiduty = 600;
				}
				else
				{
					gajiduty = totalduty;
				}
				total = gajiduty + totalsal;
				pajak = total / 100 * 10;
				hasil = total - pajak;
				
				format(list, sizeof(list), "Total gaji yang masuk ke rekening bank anda adalah: "LG_E"%s", FormatMoney(hasil));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Pendapatan", list, "Tutup", "");
				pData[playerid][pBankMoney] += hasil;
				Server_MinMoney(hasil);
				pData[playerid][pPaycheck] = 0;
				pData[playerid][pOnDutyTime] = 0;
				mysql_format(g_SQL, query, sizeof(query), "DELETE FROM salary WHERE owner='%d'", pData[playerid][pID]);
				mysql_query(g_SQL, query);
			}
			else
			{
				new list[2000], totalduty, gajiduty, total, pajak, hasil;
				
				totalduty = pData[playerid][pOnDutyTime];
				
				if(totalduty > 600)
				{
					gajiduty = 600;
				}
				else
				{
					gajiduty = totalduty;
				}
				total = gajiduty;
				pajak = total / 100 * 10;
				hasil = total - pajak;
				
				format(list, sizeof(list), "Total gaji yang masuk ke rekening bank anda adalah: "LG_E"%s", FormatMoney(hasil));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Paycheck", list, "Tutup", "");
				pData[playerid][pBankMoney] += hasil;
				Server_MinMoney(hasil);
				pData[playerid][pPaycheck] = 0;
				pData[playerid][pOnDutyTime] = 0;
			}
		}
	}
	if(dialogid == DIALOG_INFO_BIS)
	{
 		if(response)
		{
			new bid = floatround(strval(inputtext));
			SetPVarInt(playerid, "IDBisnis", bid);
            if(!Iter_Contains(Bisnis, bid)) return ErrorMsg(playerid, "The Bisnis specified Number doesn't exist.");
		 	pData[playerid][pActivity] = SetTimerEx("CheckingBis", 1300, true, "i", playerid);

			PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Loading...");
			PlayerTextDrawShow(playerid, ActiveTD[playerid]);
			ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
		}
		return 1;
	}
	if(dialogid == DIALOG_TRACK)
	{
 		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					return callcmd::tr(playerid, "ph");
				}
				case 1:
				{
					return callcmd::tr(playerid, "bis");
				}
				case 2:
				{
					return callcmd::tr(playerid, "house");
				}
			}
			return 1;
		}
	}
	if(dialogid == DIALOG_INFO_HOUSE)
	{
 		if(response)
		{
			new hid = floatround(strval(inputtext));
			SetPVarInt(playerid, "IDHouse", hid);
            if(!Iter_Contains(Bisnis, hid)) return ErrorMsg(playerid, "The House specified Number doesn't exist.");
		 	pData[playerid][pActivity] = SetTimerEx("CheckingHouse", 1300, true, "i", playerid);

			PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Loading...");
			PlayerTextDrawShow(playerid, ActiveTD[playerid]);
			ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
		}
		return 1;
	}
	if(dialogid == DIALOG_TRACK_PH)
    {
    	if(response)
		{
			new number = floatround(strval(inputtext));

			foreach(new ii : Player)
			{
				if(pData[ii][pPhone] == number)
				{
					if(pData[ii][IsLoggedIn] == false || !IsPlayerConnected(ii)) return ErrorMsg(playerid, "This number is not actived!");
					Info(playerid, "Proses Track Ph Number %d, Please Wait", number);
					SetTimerEx("trackph", random(10000)+1, false, "iid", playerid, ii, number);
					return 1;
				}
			}
		}
	}
	if(dialogid == DIALOG_BUS)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			ShowPlayerDialog(playerid, DIALOG_RUTE_BUS, DIALOG_STYLE_LIST, "Pilih Rute Bus", ">> Route A\n>> Route B", "Pilih", "Batal");
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_RUTE_BUS)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pBusTime] > 0)
					{
						Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pBusTime]);
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
						return 1;
					}
					else
					{
						pData[playerid][pSideJob] = 2;
						pData[playerid][pBus] = 1;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint1, buspoint1, 4.0);
						pData[playerid][pCheckPoint] = CHECKPOINT_BUS;
						InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
					}
						
				}
				case 1:
				{
					if(pData[playerid][pBusTime] > 0)
					{
						Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pBusTime]);
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
						return 1;
					}
					else
					{
						pData[playerid][pSideJob] = 2;
						pData[playerid][pBus] = 28;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus2, cpbus2, 4.0);
						pData[playerid][pCheckPoint] = CHECKPOINT_BUS;
						InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
					}
				}
			}
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		} 
	}
	if(dialogid == DIALOG_ISIKUOTA)
	{
		if(response)
		{
			switch (listitem) 
			{
				case 0:
				{
					new string[512], twitter[64];
					if(pData[playerid][pTwitter] < 1)
					{
						twitter = ""RED_E"Install";
					}
					else
					{
						twitter = ""LG_E"Terinstall";
					}
					download[playerid] = 1;
					format(string, sizeof(string),"Aplikasi\tStatus\n{7fffd4}Twitter ( 38mb )\t%s", twitter);
					ShowPlayerDialog(playerid, DIALOG_DOWNLOAD, DIALOG_STYLE_TABLIST_HEADERS, "App Store",string,"Download","Batal");
				}
				case 1:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), "Kuota\tHarga Pulsa\n{ffffff}Kuota 512MB\t{7fff00}3\n{ffffff}Kuota 1GB\t{7fff00}6\n{ffffff}Kuota 2GB\t{7fff00}12\n");
					ShowPlayerDialog(playerid, DIALOG_KUOTA, DIALOG_STYLE_TABLIST_HEADERS, "Isi Kuota", mstr, "Beli", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_DOWNLOAD)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new sisa = pData[playerid][pKuota]/1000;
					if(pData[playerid][pKuota] <= 38000)
						return Error(playerid, "Kuota yang anda miliki tidak mencukup ( Sisa %dmb )", sisa);

					SetTimerEx("DownloadTwitter", 10000, false, "i", playerid);
					GameTextForPlayer(playerid, "Downloading...", 10000, 4);
				}
			}
		}
		else
		{
			Servers(playerid, "Berhasil membatalkan Download Twitter");
		}
	}
	if(dialogid == DIALOG_KUOTA)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pPhoneCredit] < 3)
						return ErrorMsg(playerid, "Pulsa anda tidak mencukupi");

					pData[playerid][pKuota] += 512000;
					pData[playerid][pPhoneCredit] -= 3;
					Servers(playerid, "Berhasil membeli Kuota 512mb");
				}
				case 1:
				{
					if(pData[playerid][pPhoneCredit] < 6)
						return ErrorMsg(playerid, "Pulsa anda tidak mencukupi");

					pData[playerid][pKuota] += 1000000;
					pData[playerid][pPhoneCredit] -= 6;
					Servers(playerid, "Berhasil membeli Kuota 1gb");
				}
				case 2:
				{
					if(pData[playerid][pPhoneCredit] < 12)
						return ErrorMsg(playerid, "Pulsa anda tidak mencukupi");

					pData[playerid][pKuota] += 2000000;
					pData[playerid][pPhoneCredit] -= 6;
					Servers(playerid, "Berhasil membeli Kuota 2gb");
				}
			}
		}
	}
	if(dialogid ==  DIALOG_STUCK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SendStaffMessage(COLOR_RED, "[STUCK REPORT] "WHITE_E"%s (ID: %d) stuck: Tersangkut di Gedung", pData[playerid][pName], playerid);
				}
				case 1:
				{
					SendStaffMessage(COLOR_RED, "[STUCK REPORT] "WHITE_E"%s (ID: %d) stuck: Tersangkut setelah keluar masuk Interior", pData[playerid][pName], playerid);
				}
				case 2:
				{

					if((Vehicle_Nearest(playerid)) != -1)
					{
						new Float:vX, Float:vY, Float:vZ;
						GetPlayerPos(playerid, vX, vY, vZ);
						SetPlayerPos(playerid, vX, vY, vZ+2);
						SendStaffMessage(COLOR_RED, "[STUCK REPORT] "WHITE_E"%s (ID: %d) stuck: Tersangkut diKendaraan (Non Visual Bug)", pData[playerid][pName], playerid);
					}
					else
					{
						ErrorMsg(playerid, "Anda tidak berada didekat Kendaraan apapun");
						SendStaffMessage(COLOR_RED, "[STUCK REPORT] "WHITE_E"%s (ID: %d) stuck: Tersangkut diKendaraan (Visual Bug)", pData[playerid][pName], playerid);
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_TDM)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetPlayerTeam(playerid) == 1)
						return ErrorMsg(playerid, "Anda sudah bergabung ke Tim ini");

					if(RedTeam >= MaxRedTeam)
						return ErrorMsg(playerid, "Pemain didalam tim ini sudah terlalu penuh");

					SetPlayerTeam(playerid, 1);
					SetPlayerPos(playerid, RedX, RedY, RedZ);
					IsAtEvent[playerid] = 1;
					SetPlayerVirtualWorld(playerid, EventWorld);
					SetPlayerInterior(playerid, EventInt);
					SetPlayerHealthEx(playerid, EventHP);
					SetPlayerArmourEx(playerid, EventArmour);
					ResetPlayerWeapons(playerid);
					GivePlayerWeaponEx(playerid, EventWeapon1, 150);
					GivePlayerWeaponEx(playerid, EventWeapon2, 150);
					GivePlayerWeaponEx(playerid, EventWeapon3, 150);
					GivePlayerWeaponEx(playerid, EventWeapon4, 150);
					GivePlayerWeaponEx(playerid, EventWeapon5, 150);
					TogglePlayerControllable(playerid, 0);
					SetPlayerColor(playerid, COLOR_RED);
					Servers(playerid, "Berhasil bergabung kedalam Tim, Harap tunggu Admin memulai Event");
					RedTeam += 1;
				}
				case 1:
				{
					if(GetPlayerTeam(playerid) == 2)
						return ErrorMsg(playerid, "Anda sudah bergabung ke Tim ini");

					if(BlueTeam >= MaxBlueTeam)
						return ErrorMsg(playerid, "Pemain didalam tim ini sudah terlalu penuh");

					SetPlayerTeam(playerid, 2);
					SetPlayerPos(playerid, BlueX, BlueY, BlueZ);
					IsAtEvent[playerid] = 1;
					SetPlayerVirtualWorld(playerid, EventWorld);
					SetPlayerInterior(playerid, EventInt);
					SetPlayerHealthEx(playerid, EventHP);
					SetPlayerArmourEx(playerid, EventArmour);
					ResetPlayerWeapons(playerid);
					GivePlayerWeaponEx(playerid, EventWeapon1, 150);
					GivePlayerWeaponEx(playerid, EventWeapon2, 150);
					GivePlayerWeaponEx(playerid, EventWeapon3, 150);
					GivePlayerWeaponEx(playerid, EventWeapon4, 150);
					GivePlayerWeaponEx(playerid, EventWeapon5, 150);
					TogglePlayerControllable(playerid, 0);
					SetPlayerColor(playerid, COLOR_BLUE);
					Servers(playerid, "Berhasil bergabung kedalam Tim, Harap tunggu Admin memulai Event");
					BlueTeam += 1;
				}
			}
		}
	}
	if(dialogid == DIALOG_PICKUPVEH)
	{
		if(response)
		{
		    foreach(new gkid : Garkot)
			{
				if(IsPlayerInRangeOfPoint(playerid, 3.5, gkData[gkid][gkX], gkData[gkid][gkY],gkData[gkid][gkZ]))
				{
		 			new i = ReturnPVehParkID(playerid, (listitem + 1));

					pvData[i][cPark] = -1;
					pvData[i][cPosX] = gkData[gkid][sgkX];
					pvData[i][cPosY] = gkData[gkid][sgkY];
					pvData[i][cPosZ] = gkData[gkid][sgkZ];
					pvData[i][cPosA] = gkData[gkid][sgkA];
					SuccesMsg(playerid, "Kendaraan berhasil diambil");
					OnPlayerVehicleRespawn(i);
					SetPlayerArmedWeapon(playerid, 0);
					PutPlayerInVehicle(playerid, pvData[i][cVeh], 0);
					SetVehiclePos(pvData[i][cVeh], gkData[gkid][sgkX], gkData[gkid][sgkY], gkData[gkid][sgkZ]);
				}
			}
		}
	}
	if(dialogid == DIALOG_MY_WS)
	{
		if(!response) return true;
		new id = ReturnPlayerWorkshopID(playerid, (listitem + 1));
		SetPlayerRaceCheckpoint(playerid,1, wsData[id][wX], wsData[id][wY], wsData[id][wZ], 0.0, 0.0, 0.0, 3.5);
		SuccesMsg(playerid, "Ikuti checkpoint untuk menemukan workshop anda!");
		return 1;
	}
	if(dialogid == WS_MENU)
	{
		if(response)
		{
			new id = pData[playerid][pInWs];
			switch(listitem)
			{
				case 0:
				{
					if(!IsWorkshopOwner(playerid, id))
						return ErrorMsg(playerid, "Hanya pemilik workshop yang dapat menggunakan ini!");

					new str[256];
					format(str, sizeof str,"Nama Workshop:\n%s\n\nMasukan nama baru untuk workshop anda", wsData[id][wName]);
					ShowPlayerDialog(playerid, WS_SETNAME, DIALOG_STYLE_INPUT, "Executive - Workshop Name", str,"Ubah","Batal");
				}
				case 1:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Seragam Kerja");
					if(pData[playerid][pGender] == 1) SetPlayerSkin(playerid, 268);
					else SetPlayerSkin(playerid, 268);// wanita
				}
				case 2:
				{
					SuccesMsg(playerid, "Anda Sekarang Menggunakan Baju biasa");
					SetPlayerSkin(playerid, pData[playerid][pSkin]);
				}
				case 3:
				{
					foreach(new wid : Workshop)
					{
						if(IsPlayerInRangeOfPoint(playerid, 3.5, wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ]))
						{
							if(!IsWorkshopOwner(playerid, wid) && !IsWorkshopEmploye(playerid, wid)) return ErrorMsg(playerid, "Kamu bukan pengurus Workshop ini.");
							if(!wsData[wid][wStatus])
							{
								wsData[wid][wStatus] = 1;
								Workshop_Save(wid);
								ShowWorkshopMenu(playerid, wid);

								SuccesMsg(playerid, "Workshop anda berhasil ~g~Dibuka!");
								PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
							}
							else
							{
								wsData[wid][wStatus] = 0;
								Workshop_Save(wid);
								ShowWorkshopMenu(playerid, wid);

								SuccesMsg(playerid,"Workshop anda berhasil ~r~Ditutup");
								PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
							}
							Workshop_Refresh(wid);
						}
					}
					return 1;
				}
				case 4:
				{
					new str[556];
					format(str, sizeof str,"Name\tRank\n(%s)\tOwner\n",wsData[id][wOwner]);
					for(new z = 0; z < MAX_WORKSHOP_EMPLOYEE; z++)
					{
						format(str, sizeof str,"%s(%s)\tEmploye\n", str, wsEmploy[id][z]);
					}
					ShowPlayerDialog(playerid, WS_SETEMPLOYE, DIALOG_STYLE_TABLIST_HEADERS, "Employe Menu", str, "Change","Batal");
				}
				case 5:
				{
					ShowPlayerDialog(playerid, WS_COMPONENT, DIALOG_STYLE_LIST, "Workshop Component", "Withdraw\nDeposit", "Pilih","Batal");
				}
				case 6:
				{
					ShowPlayerDialog(playerid, WS_MATERIAL, DIALOG_STYLE_LIST, "Workshop Material", "Withdraw\nDeposit", "Pilih","Batal");
				}
				case 7:
				{
					ShowPlayerDialog(playerid, WS_MONEY, DIALOG_STYLE_LIST, "Workshop Money", "Withdraw\nDeposit", "Pilih","Batal");
				}
			}
		}
	}
	if(dialogid == WS_SETNAME)
	{
		if(response)
		{
			new id = pData[playerid][pInWs];

			if(!IsWorkshopOwner(playerid, id))
				return ErrorMsg(playerid, "Only Workshop Owner who can use this");

			if(strlen(inputtext) > 24) 
				return ErrorMsg(playerid, "Maximal 24 Character");

			if(strfind(inputtext, "'", true) != -1)
				return ErrorMsg(playerid, "You can't put ' in Workshop Name");
			
			SendClientMessageEx(playerid, ARWIN, "WORKSHOP: {ffffff}You've successfully set Workshop Name from {ffff00}%s{ffffff} to {7fffd4}%s", wsData[id][wName], inputtext);
			format(wsData[id][wName], 24, inputtext);
			Workshop_Save(id);
			Workshop_Refresh(id);
		}
	}
	if(dialogid == WS_SETEMPLOYE)
	{
		if(response)
		{
			new id = pData[playerid][pInWs], str[256];

			if(!IsWorkshopOwner(playerid, id))
				return ErrorMsg(playerid, "Only Workshop Owner who can use this");

			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMenuType] = 0;
					format(str, sizeof str, "Current Owner:\n%s\n\nInput Player ID/Name to Change Ownership", wsData[id][wOwner]);
				}
				case 1:
				{
					pData[playerid][pMenuType] = 1;
					format(str, sizeof str, "Current Employe:\n%s\n\nInput Player ID/Name to Change", wsEmploy[id][0]);
				}
				case 2:
				{
					pData[playerid][pMenuType] = 2;
					format(str, sizeof str, "Current Employe:\n%s\n\nInput Player ID/Name to Change", wsEmploy[id][1]);
				}
				case 3:
				{
					pData[playerid][pMenuType] = 3;
					format(str, sizeof str, "Current Employe:\n%s\n\nInput Player ID/Name to Change", wsEmploy[id][2]);
				}
				case 4:
				{
					pData[playerid][pMenuType] = 4;
					format(str, sizeof str, "Current Employe:\n%s\n\nInput Player ID/Name to Change", wsEmploy[id][3]);
				}
			}
			ShowPlayerDialog(playerid, WS_SETEMPLOYEE, DIALOG_STYLE_INPUT, "Employe Menu", str, "Change", "Batal");
		}
	}
	if(dialogid == WS_SETEMPLOYEE)
	{
		if(response)
		{
			new otherid, id = pData[playerid][pInWs], eid = pData[playerid][pMenuType];
			if(!strcmp(inputtext, "-", true))
			{
				SendClientMessageEx(playerid, ARWIN, "WORKSHOP: {ffffff}You've successfully Removed_ %s from Workshop", wsEmploy[id][(eid - 1)]);
				format(wsEmploy[id][(eid - 1)], MAX_PLAYER_NAME, "-");
				Workshop_Save(id);
				return 1;
			}

			if(sscanf(inputtext,"u", otherid))
				return ErrorMsg(playerid, "You must put Player ID/Name");

			if(!IsWorkshopOwner(playerid, id))
				return ErrorMsg(playerid, "Only Workshop Owner who can use this");

			if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
				return ErrorMsg(playerid, "Player itu Disconnect or not near you.");

			if(otherid == playerid)
				return ErrorMsg(playerid, "You can't set to yourself as owner.");

			if(eid == 0)
			{
				new str[128];
				pData[playerid][pTransferWS] = otherid;
				format(str, sizeof str,"Are you sure want to transfer ownership to %s?", ReturnName(otherid));
				ShowPlayerDialog(playerid, WS_SETOWNERCONFIRM, DIALOG_STYLE_MSGBOX, "Transfer Ownership", str,"Confirm","Batal");
			}
			else if(eid > 0 && eid < 5)
			{
				format(wsEmploy[id][(eid - 1)], MAX_PLAYER_NAME, pData[otherid][pName]);
				SendClientMessageEx(playerid, ARWIN, "WORKSHOP: {ffffff}You've successfully add %s to Workshop", pData[otherid][pName]);
				SendClientMessageEx(otherid, ARWIN, "WORKSHOP: {ffffff}You've been hired in Workshop %s by %s", wsData[id][wName], pData[playerid][pName]);
				Workshop_Save(id);
			}
			Workshop_Save(id);
			Workshop_Refresh(id);
		}
	}
	if(dialogid == WS_SETOWNERCONFIRM)
	{
		if(!response) 
			pData[playerid][pTransferWS] = INVALID_PLAYER_ID;

		new otherid = pData[playerid][pTransferWS], id = pData[playerid][pInWs];
		if(response)
		{
			if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
				return ErrorMsg(playerid, "Player itu Disconnect or not near you.");

			SendClientMessageEx(playerid, ARWIN, "WORKSHOP: {ffffff}You've successfully transfered %s Workshop to %s",wsData[id][wName], pData[otherid][pName]);
			SendClientMessageEx(otherid, ARWIN, "WORKSHOP: {ffffff}You've been transfered to owner in %s Workshop by %s", wsData[id][wName], pData[playerid][pName]);
			format(wsData[id][wOwner], MAX_PLAYER_NAME, pData[otherid][pName]);
			Workshop_Save(id);
			Workshop_Refresh(id);
		}
	}
	if(dialogid == WS_COMPONENT)
	{
		if(response)
		{
			new str[256], id = pData[playerid][pInWs];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMenuType] = 1;
					format(str, sizeof str,"Current Component: %d\n\nPlease Input amount to Withdraw", wsData[id][wComp]);
				}
				case 1:
				{
					pData[playerid][pMenuType] = 2;
					format(str, sizeof str,"Current Component: %d\n\nPlease Input amount to Deposit", wsData[id][wComp]);
				}
			}
			ShowPlayerDialog(playerid, WS_COMPONENT2, DIALOG_STYLE_INPUT, "Component Menu", str, "Input","Batal");
		}
	}
	if(dialogid == WS_COMPONENT2)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pInWs];
			if(pData[playerid][pMenuType] == 1)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Minimum amount is 1");

				if(wsData[id][wComp] < amount) return ErrorMsg(playerid, "Not Enough Workshop Component");

				if((pData[playerid][pComponent] + amount) >= 701)
					return ErrorMsg(playerid, "You've reached maximum of Component");

				pData[playerid][pComponent] += amount;
				wsData[id][wComp] -= amount;
				Workshop_Save(id);
				Info(playerid, "You've successfully withdraw %d Component from Workshop", amount);
			}
			else if(pData[playerid][pMenuType] == 2)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Minimum amount is 1");

				if(pData[playerid][pComponent] < amount) return ErrorMsg(playerid, "Not Enough Component");

				if((wsData[id][wComp] + amount) >= MAX_WORKSHOP_INT)
					return ErrorMsg(playerid, "You've reached maximum of Component");

				pData[playerid][pComponent] -= amount;
				wsData[id][wComp] += amount;
				Workshop_Save(id);
				Info(playerid, "You've successfully deposit %d Component to Workshop", amount);
			}
		}
	}
	if(dialogid == WS_MATERIAL)
	{
		if(response)
		{
			new str[256], id = pData[playerid][pInWs];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMenuType] = 1;
					format(str, sizeof str,"Current Material: %d\n\nPlease Input amount to Withdraw", wsData[id][wMat]);
				}
				case 1:
				{
					pData[playerid][pMenuType] = 2;
					format(str, sizeof str,"Current Material: %d\n\nPlease Input amount to Deposit", wsData[id][wMat]);
				}
			}
			ShowPlayerDialog(playerid, WS_MATERIAL2, DIALOG_STYLE_INPUT, "Material Menu", str, "Input","Batal");
		}
	}
	if(dialogid == WS_MATERIAL2)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pInWs];
			if(pData[playerid][pMenuType] == 1)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Minimum amount is 1");

				if(wsData[id][wMat] < amount) return ErrorMsg(playerid, "Not Enough Workshop Material");

				if((pData[playerid][pMaterial] + amount) >= 500)
					return ErrorMsg(playerid, "You've reached maximum of Material");

				pData[playerid][pMaterial] += amount;
				wsData[id][wMat] -= amount;
				Workshop_Save(id);
				Info(playerid, "You've successfully withdraw %d Material from Workshop", amount);
			}
			else if(pData[playerid][pMenuType] == 2)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Minimum amount is 1");

				if(pData[playerid][pMaterial] < amount) return ErrorMsg(playerid, "Not Enough Material");

				if((wsData[id][wMat] + amount) >= MAX_WORKSHOP_INT)
					return ErrorMsg(playerid, "You've reached maximum of Material");

				pData[playerid][pMaterial] -= amount;
				wsData[id][wMat] += amount;
				Workshop_Save(id);
				Info(playerid, "You've successfully deposit %d Material to Workshop", amount);
			}
		}
	}
	if(dialogid == WS_MONEY)
	{
		if(response)
		{
			new str[264], id = pData[playerid][pInWs];
			switch(listitem)
			{
				case 0:
				{
					if(!IsWorkshopOwner(playerid, id))
						return ErrorMsg(playerid, "Only Workshop Owner who can use this");

					format(str, sizeof str, "Current Money:\n{7fff00}%s\n\n{ffffff}Input Amount to Withdraw", FormatMoney(wsData[id][wMoney]));
					ShowPlayerDialog(playerid, WS_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw Workshop Money",str,"Withdraw","Batal");
				}
				case 1:
				{
					format(str, sizeof str, "Current Money:\n{7fff00}%s\n\n{ffffff}Input Amount to Deposit", FormatMoney(wsData[id][wMoney]));
					ShowPlayerDialog(playerid, WS_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit Workshop Money",str,"Deposit","Batal");
				}
			}
		}
	}
	if(dialogid == WS_WITHDRAWMONEY)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pInWs];

			if(amount < 1)
				return ErrorMsg(playerid, "Minimum amount is $1");

			if(wsData[id][wMoney] < amount)
				return ErrorMsg(playerid, "Not Enough Workshop Money");

			GivePlayerMoneyEx(playerid, amount);
			wsData[id][wMoney] -= amount;
			Workshop_Save(id);
		}
	}
	if(dialogid == WS_DEPOSITMONEY)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pInWs];
			
			if(amount < 1)
				return ErrorMsg(playerid, "Minimum amount is $1");

			if(pData[playerid][pMoney] < amount)
				return ErrorMsg(playerid, "Not Enough Money");

			GivePlayerMoneyEx(playerid, -amount);
			wsData[id][wMoney] += amount;
			Workshop_Save(id);
		}
	}
	//ACTOR SYSTEM
	if(dialogid == DIALOG_ACTORANIM)
	{
	    if(!response) return -1;
        new id = GetPVarInt(playerid, "aPlayAnim");
	    if(response)
	    {
	        if(listitem == 0)
	        {
				ApplyActorAnimation(id, "ROB_BANK","SHP_HandsUp_Scr",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 1;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 1)
	        {
				ApplyActorAnimation(id,"ped","Idlestance_fat",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 2;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 2)
	        {
				ApplyActorAnimation(id,"ped","Idlestance_old",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 3;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 3)
	        {
				ApplyActorAnimation(id,"POOL","POOL_Idle_Stance",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 4;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 4)
	        {
				ApplyActorAnimation(id,"ped","woman_idlestance",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 5;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 5)
	        {
				ApplyActorAnimation(id,"ped","IDLE_stance",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 6;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 6)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Copbrowse_in",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 7;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 7)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Copbrowse_loop",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 8;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 8)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Copbrowse_nod",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 9;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 9)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Copbrowse_out",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 10;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 10)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Copbrowse_shake",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 11;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 11)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Coplook_in",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 12;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 12)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Coplook_loop",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 13;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 13)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Coplook_nod",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 14;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 14)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Coplook_out",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 15;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 15)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Coplook_shake",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 16;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 16)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Coplook_think",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 17;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 17)
	        {
				ApplyActorAnimation(id,"COP_AMBIENT","Coplook_watch",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 18;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 18)
	        {
				ApplyActorAnimation(id,"GANGS","leanIDLE",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 19;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 19)
	        {
				ApplyActorAnimation(id,"MISC","Plyrlean_loop",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 20;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 20)
	        {
				ApplyActorAnimation(id,"KNIFE", "KILL_Knife_Ped_Die",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 21;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 21)
	        {
				ApplyActorAnimation(id,"PED", "KO_shot_face",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 22;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 22)
	        {
				ApplyActorAnimation(id,"PED", "KO_shot_stom",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 23;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 23)
	        {
				ApplyActorAnimation(id,"PED", "BIKE_fallR",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 24;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 24)
	        {
				ApplyActorAnimation(id,"PED", "BIKE_fall_off",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 25;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 25)
	        {
				ApplyActorAnimation(id,"SWAT","gnstwall_injurd",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 26;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
	        if(listitem == 26)
	        {
				ApplyActorAnimation(id,"SWEET","Sweet_injuredloop",4.0,0,0,0,1,0);
				ActorData[id][actorAnim] = 27;
				Actor_Save(id);

				SendClientMessageEx(playerid, -1, "ACTORS: "WHITE_E"You have changed animation");
			}
		}
	}

	//modshop
	if(dialogid == DIALOG_MODSHOP)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{   
					ShowModelSelectionMenu(playerid, TransFender, "Modshop:", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
				}
				case 1:
				{   
					Dialog_Show(playerid, VEH_OBJECT_TEXTNAME, DIALOG_STYLE_INPUT, "Input Text Name", "Input Text name 32 Character : ", "Update", "Close");
			    }
				case 2:
				{   
					ShowModelSelectionMenu(playerid, LoCo, "Modshop:", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
			    }
				case 3:
				{
				    if(pData[playerid][pVip] < 2) return PermissionError(playerid);
				    static 
				        vehicle;
				    
				    vehicle = Vehicle_Nearest(playerid);
				    if(vehicle != INVALID_VEHICLE_ID) 
				    {
				    	Vehicle_TextAdd(playerid, vehicle, 18661, OBJECT_TYPE_TEXT);
				    	return 1;
				    } 
				    else ErrorMsg(playerid, "Invalid vehicle id.");
				    
				}
				case 4:
				{
				    if(pData[playerid][pVip] < 2) return PermissionError(playerid);
				    static 
				        vehicle;
				    
				    vehicle = Vehicle_Nearest(playerid);
				    if(vehicle != INVALID_VEHICLE_ID) 
				    {
				    	Vehicle_SpotLightAdd(playerid, vehicle, 19281, OBJECT_TYPE_LIGHT);
				    	return 1;
				    } 
				    else ErrorMsg(playerid, "Invalid vehicle id.");
				    
				}
			}
		}
		return 1;
	}
	
	//MAPPING INGAME
	if(dialogid == DIALOG_MTEDIT)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
		        case 0:
		        {
		            EditDynamicObject(playerid, MatextData[EditingMatext[playerid]][mtCreate]);
		            SendClientMessageEx(playerid, COLOR_WHITE, "MATEXT: {FFFFFF}You're Editing Material Text ID %d with Move Object", EditingMatext[playerid]);
				}
				case 1:
				{
					new stringg[512];
					format(stringg, sizeof(stringg), "Offset X (%f)\nOffset Y (%f)\nOffset Z (%f)\nRotation X (%f)\nRotation Y (%f)\nRotation Z (%f)",
	   				MatextData[EditingMatext[playerid]][mtPos][0],
				    MatextData[EditingMatext[playerid]][mtPos][1],
				    MatextData[EditingMatext[playerid]][mtPos][2],
	   				MatextData[EditingMatext[playerid]][mtPos][3],
				    MatextData[EditingMatext[playerid]][mtPos][4],
				    MatextData[EditingMatext[playerid]][mtPos][5]
					);
					ShowPlayerDialog(playerid, DIALOG_MTC, DIALOG_STYLE_LIST, "Editing Material Text", stringg, "Pilih", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_EDIT)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
		        case 0:
		        {
		            EditDynamicObject(playerid, ObjectData[EditingObject[playerid]][objCreate]);
		            SendClientMessageEx(playerid, COLOR_WHITE, "OBJECT: {FFFFFF}You're Editing Created object %d with Move Object", EditingObject[playerid]);
				}
				case 1:
				{
					new stringg[512];
					format(stringg, sizeof(stringg), "Offset X (%f)\nOffset Y (%f)\nOffset Z (%f)\nRotation X (%f)\nRotation Y (%f)\nRotation Z (%f)",
	   				ObjectData[EditingObject[playerid]][objPos][0],
				    ObjectData[EditingObject[playerid]][objPos][1],
				    ObjectData[EditingObject[playerid]][objPos][2],
	   				ObjectData[EditingObject[playerid]][objPos][3],
				    ObjectData[EditingObject[playerid]][objPos][4],
				    ObjectData[EditingObject[playerid]][objPos][5]
					);
					ShowPlayerDialog(playerid, DIALOG_COORD, DIALOG_STYLE_LIST, "Editing Object", stringg, "Pilih", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_COORD)
	{
	    if(response)
		{
			switch(listitem)
			{
			    case 0: ShowPlayerDialog(playerid, DIALOG_X, DIALOG_STYLE_INPUT, "Object Edit", "Input an X Offset from -100 to 100", "Confirm", "Batal");
				case 1: ShowPlayerDialog(playerid, DIALOG_Y, DIALOG_STYLE_INPUT, "Object Edit", "Input a Y Offset from -100 to 100", "Confirm", "Batal");
			    case 2: ShowPlayerDialog(playerid, DIALOG_Z, DIALOG_STYLE_INPUT, "Object Edit", "Input a Z Offset from -100 to 100", "Confirm", "Batal");
			    case 3: ShowPlayerDialog(playerid, DIALOG_RX, DIALOG_STYLE_INPUT, "Object Edit", "Input an X Rotation from 0 to 360", "Confirm", "Batal");
				case 4: ShowPlayerDialog(playerid, DIALOG_RY, DIALOG_STYLE_INPUT, "Object Edit", "Input a Y Rotation from 0 to 360", "Confirm", "Batal");
				case 5: ShowPlayerDialog(playerid, DIALOG_RZ, DIALOG_STYLE_INPUT, "Object Edit", "Input a Z Rotation from 0 to 360", "Confirm", "Batal");
			}
		}
	}
	if(dialogid == DIALOG_MTC)
	{
	    if(response)
		{
			switch(listitem)
			{
			    case 0: ShowPlayerDialog(playerid, DIALOG_MTX, DIALOG_STYLE_INPUT, "Material Text Edit", "Input an X Offset from -100 to 100", "Confirm", "Batal");
				case 1: ShowPlayerDialog(playerid, DIALOG_MTY, DIALOG_STYLE_INPUT, "Material Text Edit", "Input a Y Offset from -100 to 100", "Confirm", "Batal");
			    case 2: ShowPlayerDialog(playerid, DIALOG_MTZ, DIALOG_STYLE_INPUT, "Material Text Edit", "Input a Z Offset from -100 to 100", "Confirm", "Batal");
			    case 3: ShowPlayerDialog(playerid, DIALOG_MTRX, DIALOG_STYLE_INPUT, "Material Text Edit", "Input an X Rotation from 0 to 360", "Confirm", "Batal");
				case 4: ShowPlayerDialog(playerid, DIALOG_MTRY, DIALOG_STYLE_INPUT, "Material Text Edit", "Input a Y Rotation from 0 to 360", "Confirm", "Batal");
				case 5: ShowPlayerDialog(playerid, DIALOG_MTRZ, DIALOG_STYLE_INPUT, "Material Text Edit", "Input a Z Rotation from 0 to 360", "Confirm", "Batal");
			}
		}
	}
	if(dialogid == DIALOG_MTX)
	{
	    if(response)
	    {
	        new Float:offset = floatstr(inputtext);
	        new Float:obj = MatextData[EditingMatext[playerid]][mtPos][0];
	        if(offset < -100) offset = 0;
			else if(offset > 100) offset = 100;
	        offset = offset/100;
         	MatextData[EditingMatext[playerid]][mtPos][0] = obj + offset;

	        Matext_Refresh(EditingMatext[playerid]);
	        Matext_Save(EditingMatext[playerid]);

	        EditingMatext[playerid] = -1;
		}
	}
	if(dialogid == DIALOG_MTY)
	{
	    if(response)
	    {
	        new Float:offset = floatstr(inputtext);
	        new Float:obj = MatextData[EditingMatext[playerid]][mtPos][1];
	        if(offset < -100) offset = 0;
			else if(offset > 100) offset = 100;
	        offset = offset/100;
	        MatextData[EditingMatext[playerid]][mtPos][1] = obj + offset;

	        Matext_Refresh(EditingMatext[playerid]);
	        Matext_Save(EditingMatext[playerid]);

	        EditingMatext[playerid] = -1;
		}
	}
	if(dialogid == DIALOG_MTZ)
	{
	    if(response)
	    {
	        new Float:offset = floatstr(inputtext);
	        new Float:obj = MatextData[EditingMatext[playerid]][mtPos][2];
	        if(offset < -100) offset = 0;
			else if(offset > 100) offset = 100;
	        offset = offset/100;
	        MatextData[EditingMatext[playerid]][mtPos][2] = obj + offset;

	        Matext_Refresh(EditingMatext[playerid]);
	        Matext_Save(EditingMatext[playerid]);

	        EditingMatext[playerid] = -1;
		}
	}
	if(dialogid == DIALOG_MTRX)
	{
	    if(response)
	    {
	        new Float:offset = floatstr(inputtext);
	        new Float:obj = MatextData[EditingMatext[playerid]][mtPos][3];
	        if(offset < -100) offset = 0;
			else if(offset > 100) offset = 100;
	        offset = offset/100;
	        MatextData[EditingMatext[playerid]][mtPos][3] = obj + offset;

	        Matext_Refresh(EditingMatext[playerid]);
	        Matext_Save(EditingMatext[playerid]);

	        EditingMatext[playerid] = -1;
		}
	}
	if(dialogid == DIALOG_MTRY)
	{
	    if(response)
	    {
	        new Float:offset = floatstr(inputtext);
	        new Float:obj = MatextData[EditingMatext[playerid]][mtPos][4];
	        if(offset < -100) offset = 0;
			else if(offset > 100) offset = 100;
	        offset = offset/100;
	        MatextData[EditingMatext[playerid]][mtPos][4] = obj + offset;

	        Matext_Refresh(EditingMatext[playerid]);
	        Matext_Save(EditingMatext[playerid]);

	        EditingMatext[playerid] = -1;
		}
	}
	if(dialogid == DIALOG_MTRZ)
	{
	    if(response)
	    {
	        new Float:offset = floatstr(inputtext);
	        new Float:obj = MatextData[EditingMatext[playerid]][mtPos][5];
	        if(offset < -100) offset = 0;
			else if(offset > 100) offset = 100;
	        offset = offset/100;
	        MatextData[EditingMatext[playerid]][mtPos][5] = obj + offset;

	        Matext_Refresh(EditingMatext[playerid]);
	        Matext_Save(EditingMatext[playerid]);

	        EditingMatext[playerid] = -1;
		}
	}
	if(dialogid == DIALOG_X)
	{
	    if(response)
	    {
	        new Float:offset = floatstr(inputtext);
	        new Float:obj = ObjectData[EditingObject[playerid]][objPos][0];
	        if(offset < -100) offset = 0;
			else if(offset > 100) offset = 100;
	        offset = offset/100;
         	ObjectData[EditingObject[playerid]][objPos][0] = obj + offset;

	        Object_Refresh(EditingObject[playerid]);
	        Object_Save(EditingObject[playerid]);

	        EditingObject[playerid] = -1;
		}
	}
	if(dialogid == DIALOG_Y)
	{
	    if(response)
	    {
	        new Float:offset = floatstr(inputtext);
	        new Float:obj = ObjectData[EditingObject[playerid]][objPos][1];
	        if(offset < -100) offset = 0;
			else if(offset > 100) offset = 100;
	        offset = offset/100;
	        ObjectData[EditingObject[playerid]][objPos][1] = obj + offset;

	        Object_Refresh(EditingObject[playerid]);
	        Object_Save(EditingObject[playerid]);

	        EditingObject[playerid] = -1;
		}
	}
	if(dialogid == DIALOG_Z)
	{
	    if(response)
	    {
	        new Float:offset = floatstr(inputtext);
	        new Float:obj = ObjectData[EditingObject[playerid]][objPos][2];
	        if(offset < -100) offset = 0;
			else if(offset > 100) offset = 100;
	        offset = offset/100;
	        ObjectData[EditingObject[playerid]][objPos][2] = obj + offset;

	        Object_Refresh(EditingObject[playerid]);
	        Object_Save(EditingObject[playerid]);

	        EditingObject[playerid] = -1;
		}
	}
	if(dialogid == DIALOG_RX)
	{
	    if(response)
	    {
	        new Float:offset = floatstr(inputtext);
	        new Float:obj = ObjectData[EditingObject[playerid]][objPos][3];
	        if(offset < -100) offset = 0;
			else if(offset > 100) offset = 100;
	        offset = offset/100;
	        ObjectData[EditingObject[playerid]][objPos][3] = obj + offset;

	        Object_Refresh(EditingObject[playerid]);
	        Object_Save(EditingObject[playerid]);

	        EditingObject[playerid] = -1;
		}
	}
	if(dialogid == DIALOG_RY)
	{
	    if(response)
	    {
	        new Float:offset = floatstr(inputtext);
	        new Float:obj = ObjectData[EditingObject[playerid]][objPos][4];
	        if(offset < -100) offset = 0;
			else if(offset > 100) offset = 100;
	        offset = offset/100;
	        ObjectData[EditingObject[playerid]][objPos][4] = obj + offset;

	        Object_Refresh(EditingObject[playerid]);
	        Object_Save(EditingObject[playerid]);

	        EditingObject[playerid] = -1;
		}
	}
	if(dialogid == DIALOG_RZ)
	{
	    if(response)
	    {
	        new Float:offset = floatstr(inputtext);
	        new Float:obj = ObjectData[EditingObject[playerid]][objPos][5];
	        if(offset < -100) offset = 0;
			else if(offset > 100) offset = 100;
	        offset = offset/100;
	        ObjectData[EditingObject[playerid]][objPos][5] = obj + offset;

	        Object_Refresh(EditingObject[playerid]);
	        Object_Save(EditingObject[playerid]);

	        EditingObject[playerid] = -1;
		}
	}
	//Vending System
	if(dialogid == DIALOG_VENDING_BUYPROD)
	{
		static
        vid = -1,
        price;

		if((vid = pData[playerid][pInVending]) != -1 && response)
		{
			price = VendingData[vid][vendingItemPrice][listitem];

			if(GetPlayerMoney(playerid) < price)
				return ErrorMsg(playerid, "Not enough money!");

			if(VendingData[vid][vendingStock] < 1)
				return ErrorMsg(playerid, "This vending is out of stock product.");
				
			
			switch(listitem)
			{
				case 0:
				{
					GivePlayerMoneyEx(playerid, -price);
					/*SetPlayerHealthEx(playerid, health+30);*/
					pData[playerid][pHunger] += 16;
					Vend(playerid, "{FFFFFF}You have purchased PotaBee for %s", FormatMoney(price));
					VendingData[vid][vendingStock]--;
					VendingData[vid][vendingMoney] += price;						
					Vending_Save(vid);
					Vending_RefreshText(vid);
				}
				case 1:
				{
					GivePlayerMoneyEx(playerid, -price);
					pData[playerid][pHunger] += 26;
					Vend(playerid, "{FFFFFF}You have purchased Cheetos for %s", FormatMoney(price));
					VendingData[vid][vendingStock]--;
					VendingData[vid][vendingMoney] += price;			
					Vending_Save(vid);
					Vending_RefreshText(vid);
				}
				case 2:
				{
					GivePlayerMoneyEx(playerid, -price);
					pData[playerid][pHunger] += 38;
				    Vend(playerid, "{FFFFFF}You have purchased Sprunk for %s", FormatMoney(price));
					VendingData[vid][vendingStock]--;
					VendingData[vid][vendingMoney] += price;
					Vending_Save(vid);
					Vending_RefreshText(vid);
				}
                case 3:
				{
					GivePlayerMoneyEx(playerid, -price);
					pData[playerid][pEnergy] += 18;
				    Vend(playerid, "{FFFFFF}You have purchased Cofee for %s", FormatMoney(price));
					VendingData[vid][vendingStock]--;
					VendingData[vid][vendingMoney] += price;
					Vending_Save(vid);
					Vending_RefreshText(vid);
				}
			}		
		}
		return 1;
	}
	if(dialogid == DIALOG_VENDING_MANAGE)
	{
		new vid = pData[playerid][pInVending];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new string[258];
					format(string, sizeof(string), "Vending ID: %d\nVending Name : %s\nVending Location: %s\nVending Vault: %s",
					vid, VendingData[vid][vendingName], GetLocation(VendingData[vid][vendingX], VendingData[vid][vendingY], VendingData[vid][vendingZ]), FormatMoney(VendingData[vid][vendingMoney]));

					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_LIST, "Vending Information", string, "Batal", "");
				}
				case 1:
				{
					new string[218];
					format(string, sizeof(string), "Tulis Nama Vending baru yang anda inginkan : ( Nama Vending Lama %s )", VendingData[vid][vendingName]);
					ShowPlayerDialog(playerid, DIALOG_VENDING_NAME, DIALOG_STYLE_INPUT, "Vending Change Name", string, "Pilih", "Batal");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_VENDING_VAULT, DIALOG_STYLE_LIST,"Vending Vault","Vending Deposit\nVending Withdraw","Pilih","Batal");
				}
				case 3:
				{
					VendingProductMenu(playerid, vid);
				}
				case 4:
				{
					if(VendingData[vid][vendingStock] > 100)
						return ErrorMsg(playerid, "Vending ini masih memiliki cukup produck.");
					if(VendingData[vid][vendingMoney] < 1000)
						return ErrorMsg(playerid, "Setidaknya anda mempunyai uang dalamam vending anda senilai $1000 untuk merestock product.");
					VendingData[vid][vendingRestock] = 1;
					Info(playerid, "Anda berhasil request untuk mengisi stock product kepada trucker, harap tunggu sampai pekerja trucker melayani.");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_VENDING_NAME)
	{
		if(response)
		{
			new bid = pData[playerid][pInVending];

			if(!PlayerOwnVending(playerid, bid)) return ErrorMsg(playerid, "You don't own this Vending Machine.");
			
			if (isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Vending tidak di perbolehkan kosong!\n\n"WHITE_E"Nama Vending sebelumnya: %s\n\nMasukkan nama Vending yang kamu inginkan\nMaksimal 32 karakter untuk nama Vending", VendingData[bid][vendingName]);
				ShowPlayerDialog(playerid, DIALOG_VENDING_NAME, DIALOG_STYLE_INPUT,"Vending Change Name", mstr,"Done","Kembali");
				return 1;
			}
			if(strlen(inputtext) > 32 || strlen(inputtext) < 5)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Vending harus 5 sampai 32 kata.\n\n"WHITE_E"Nama Vending sebelumnya: %s\n\nMasukkan nama Vending yang kamu inginkan\nMaksimal 32 karakter untuk nama Vending", VendingData[bid][vendingName]);
				ShowPlayerDialog(playerid, DIALOG_VENDING_NAME, DIALOG_STYLE_INPUT,"Vending Change Name", mstr,"Done","Kembali");
				return 1;
			}
			format(VendingData[bid][vendingName], 32, ColouredText(inputtext));

			Vending_RefreshText(bid);
			Vending_Save(bid);

			Vend(playerid, "Vending name set to: \"%s\".", VendingData[bid][vendingName]);
		}
		else return callcmd::vendingmanage(playerid, "\0");
		return 1;
	}
	if(dialogid == DIALOG_VENDING_VAULT)
	{
		new vid = pData[playerid][pInVending];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Uang kamu: %s.\n\nMasukkan berapa banyak uang yang akan kamu simpan di dalam Vending ini", FormatMoney(GetPlayerMoney(playerid)));
					ShowPlayerDialog(playerid, DIALOG_VENDING_DEPOSIT, DIALOG_STYLE_INPUT, "Vending Deposit Input", mstr, "Deposit", "Batal");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Vending Vault: %s\n\nMasukkan berapa banyak uang yang akan kamu ambil di dalam Vending ini", FormatMoney(VendingData[vid][vendingMoney]));
					ShowPlayerDialog(playerid, DIALOG_VENDING_WITHDRAW, DIALOG_STYLE_INPUT,"Vending Withdraw Input", mstr, "Withdraw","Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_VENDING_WITHDRAW)
	{
		if(response)
		{
			new bid = pData[playerid][pInVending];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > VendingData[bid][vendingMoney])
				return ErrorMsg(playerid, "Invalid amount specified!");

			VendingData[bid][vendingMoney] -= amount;
			Vending_Save(bid);

			GivePlayerMoneyEx(playerid, amount);

			Info(playerid, "You have withdrawn %s from the Vending vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, DIALOG_VENDING_VAULT, DIALOG_STYLE_LIST,"Vending Vault","Vending Deposit\nVending Withdraw","Next","Kembali");
		return 1;
	}
	if(dialogid == DIALOG_VENDING_DEPOSIT)
	{
		if(response)
		{
			new bid = pData[playerid][pInVending];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > GetPlayerMoney(playerid))
				return ErrorMsg(playerid, "Invalid amount specified!");

			VendingData[bid][vendingMoney] += amount;
			Vending_Save(bid);

			GivePlayerMoneyEx(playerid, -amount);
			
			Info(playerid, "You have deposit %s into the Vending vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, DIALOG_VENDING_VAULT, DIALOG_STYLE_LIST,"Vending Vault","Vending Deposit\nVending Withdraw","Next","Kembali");
		return 1;
	}
	if(dialogid == DIALOG_VENDING_EDITPROD)
	{
		new vid = pData[playerid][pInVending];
		if(PlayerOwnVending(playerid, vid))
		{
			if(response)
			{
				static
					item[40],
					str[128];

				strmid(item, inputtext, 0, strfind(inputtext, "-") - 1);
				strpack(pData[playerid][pEditingVendingItem], item, 40 char);

				pData[playerid][pVendingProductModify] = listitem;
				format(str,sizeof(str), "Please enter the new product price for %s:", item);
				ShowPlayerDialog(playerid, DIALOG_VENDING_PRICESET, DIALOG_STYLE_INPUT, "Vending: Set Price", str, "Modify", "Kembali");
			}
			else
				return callcmd::vendingmanage(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == DIALOG_VENDING_PRICESET)
	{
		static
        item[40];
		new vid = pData[playerid][pInVending];
		if(PlayerOwnVending(playerid, vid))
		{
			if(response)
			{
				strunpack(item, pData[playerid][pEditingVendingItem]);

				if(isnull(inputtext))
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s:", item);
					ShowPlayerDialog(playerid, DIALOG_VENDING_PRICESET, DIALOG_STYLE_INPUT, "Vending: Set Price", str, "Modify", "Kembali");
					return 1;
				}
				if(strval(inputtext) < 1 || strval(inputtext) > 5000)
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s ($1 to $5,000):", item);
					ShowPlayerDialog(playerid, DIALOG_VENDING_PRICESET, DIALOG_STYLE_INPUT, "Vending: Set Price", str, "Modify", "Kembali");
					return 1;
				}
				VendingData[vid][vendingItemPrice][pData[playerid][pVendingProductModify]] = strval(inputtext);
				Vending_Save(vid);

				Vend(playerid, "You have adjusted the price of %s to: %s!", item, FormatMoney(strval(inputtext)));
				VendingProductMenu(playerid, vid);
			}
			else
			{
				VendingProductMenu(playerid, vid);
			}
		}
	}
	if(dialogid == DIALOG_MY_VENDING)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedVending", ReturnPlayerVendingID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, DIALOG_VENDING_INFO, DIALOG_STYLE_LIST, "{0000FF}My Vending", "Show Information\nTrack Vending", "Pilih", "Batal");
		return 1;
	}
	if(dialogid == DIALOG_VENDING_INFO)
	{
		if(!response) return 1;
		new ved = GetPVarInt(playerid, "ClickedVending");
		switch(listitem)
		{
			case 0:
			{
				new line9[900];
				new type[128];
				type = "Food & Drink";
				format(line9, sizeof(line9), "Vending ID: %d\nVending Owner: %s\nVending Address: %s\nVending Price: %s\nVending Type: %s",
				ved, VendingData[ved][vendingOwner], GetLocation(VendingData[ved][vendingX], VendingData[ved][vendingY], VendingData[ved][vendingZ]), FormatMoney(VendingData[ved][vendingPrice]), type);
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vending Info", line9, "Tutup","");
			}
			case 1:
			{
				pData[playerid][pTrackVending] = 1;
				SetPlayerRaceCheckpoint(playerid,1, VendingData[ved][vendingX], VendingData[ved][vendingY], VendingData[ved][vendingZ], 0.0, 0.0, 0.0, 3.5);
				//SetPlayerCheckpoint(playerid, hData[hid][hExtpos][0], hData[hid][hExtpos][1], hData[hid][hExtpos][2], 4.0);
				Info(playerid, "Ikuti checkpoint untuk menemukan mesin vending anda!");
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_MENU_TRUCKER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetRestockBisnis() <= 0) return ErrorMsg(playerid, "Mission sedang kosong.");
					new id, count = GetRestockBisnis(), mission[400], type[32], lstr[512];
					
					strcat(mission,"No\tBusID\tBusType\tBusName\n",sizeof(mission));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockBisnisID(itt);
						if(bData[id][bType] == 1)
						{
							type= "Fast Food";
						}
						else if(bData[id][bType] == 2)
						{
							type= "Market";
						}
						else if(bData[id][bType] == 3)
						{
							type= "Clothes";
						}
						else if(bData[id][bType] == 4)
						{
							type= "Ammunation";
						}
						else
						{
							type= "Unknow";
						}
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%d\t%s\t%s\n", itt, id, type, bData[id][bName]);	
						}
						else format(lstr,sizeof(lstr), "%d\t%d\t%s\t%s\n", itt, id, type, bData[id][bName]);
						strcat(mission,lstr,sizeof(mission));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK, DIALOG_STYLE_TABLIST_HEADERS,"Trucker - Mission",mission,"Pilih","Batal");
				}
				case 1:
				{
					if(GetRestockGStation() <= 0) return ErrorMsg(playerid, "Hauling sedang kosong.");
					new id, count = GetRestockGStation(), hauling[400], lstr[512];
					
					strcat(hauling,"No\tGas Station ID\tLocation\n",sizeof(hauling));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockGStationID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%d\t%s\n", itt, id, GetLocation(gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]));	
						}
						else format(lstr,sizeof(lstr), "%d\t%d\t%s\n", itt, id, GetLocation(gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]));
						strcat(hauling,lstr,sizeof(hauling));
					}
					ShowPlayerDialog(playerid, DIALOG_HAULING, DIALOG_STYLE_TABLIST_HEADERS,"Trucker - Hauling",hauling,"Pilih","Batal");
				}
				case 2:
				{
					if(GetRestockVending() <= 0) return ErrorMsg(playerid, "Misi Restock sedang kosong.");
					new id, count = GetRestockVending(), vending[400], lstr[512];
					
					strcat(vending,"No\tName Vending (ID)\tLocation\n",sizeof(vending));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnRestockVendingID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s (%d)\t%s\n", itt, VendingData[id][vendingName], id, GetLocation(VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]));	
						}
						else format(lstr,sizeof(lstr), "%d\t%s (%d)\t%s\n", itt, VendingData[id][vendingName], id, GetLocation(VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]));
						strcat(vending,lstr,sizeof(vending));
					}
					ShowPlayerDialog(playerid, DIALOG_RESTOCK_VENDING, DIALOG_STYLE_TABLIST_HEADERS, "Vending", vending, "Start", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_SHIPMENTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{

				}
				case 1:
				{
					if(GetAnyVendings() <= 0) return ErrorMsg(playerid, "Tidak ada Vendings di kota.");
					new id, count = GetAnyVendings(), location[4096], lstr[596];
					strcat(location,"No\tLocation\tDistance\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnVendingsID(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%0.2fm\n", itt, GetLocation(VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]), GetPlayerDistanceFromPoint(playerid, VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%0.2fm\n", itt, GetLocation(VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]), GetPlayerDistanceFromPoint(playerid, VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_SHIPMENTS_VENDING, DIALOG_STYLE_TABLIST_HEADERS,"Vendings List",location,"Pilih","Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_SHIPMENTS_VENDING)
	{
		if(response)
		{
			new id = ReturnVendingsID((listitem + 1));

			pData[playerid][pGpsActive] = 1;
			SetPlayerRaceCheckpoint(playerid,1, VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ], 0.0, 0.0, 0.0, 3.5);
			Gps(playerid, "Vendings checkpoint targeted! (%s)", GetLocation(VendingData[id][vendingX], VendingData[id][vendingY], VendingData[id][vendingZ]));
		}
	}
	if(dialogid == DIALOG_RESTOCK_VENDING)
	{
		if(response)
		{
			new id = ReturnRestockVendingID((listitem + 1));
			if(VendingData[id][vendingMoney] < 1000)
				return ErrorMsg(playerid, "Maaf, Vending ini kehabisan uang product.");
			
			if(pData[playerid][pVendingRestock] == 1)
				return ErrorMsg(playerid, "Anda sudah sedang melakukan restock!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetVehicleModel(GetPlayerVehicleID(playerid)) != 586) return ErrorMsg(playerid, "Kamu harus mengendarai wayfarer.");
				
			pData[playerid][pVendingRestock] = id;
			VendingData[id][vendingRestock] = 0;
			
			new line9[900];
			
			format(line9, sizeof(line9), "Silahkan anda membeli stock Vending di gudang!\n\nVending ID: %d\nVending Owner: %s\nVending Name: %s\n\nSetelah itu ikuti checkpoint dan antarkan ke vending mission anda!",
			id, VendingData[id][vendingOwner], VendingData[id][vendingName]);
			SetPlayerRaceCheckpoint(playerid, 1, -56.39, -223.73, 5.42, 0.0, 0.0, 0.0, 3.5);
			//SetPlayerCheckpoint(playerid, -279.67, -2148.42, 28.54, 3.5);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Restock Info", line9, "Tutup","");
		}	
	}
	//Spawn 4 Titik FiveM
	if(dialogid == DIALOG_SPAWN_1)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerSkin(playerid, 2);
					pData[playerid][pSkin] = 2;
					SetPlayerPos(playerid, 1743.0264, -1863.7509, 13.5747);
					SetPlayerFacingAngle(playerid, 357.0346);
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, 0);
					ClearAnimations(playerid);
					Info(playerid, "Kamu spawn di KOTA.");
				}/*
				case 1:
				{
					pData[playerid][pSpawnList] = 2;
					switch (pData[playerid][pGender])
					{
						case 1: ShowPlayerSelectionMenu(playerid, SPAWN_SKIN_MALE, "Choose Your Skin", SpawnSkinMale, sizeof(SpawnSkinMale));
						case 2: ShowPlayerSelectionMenu(playerid, SPAWN_SKIN_FEMALE, "Choose Your Skin", SpawnSkinFemale, sizeof(SpawnSkinFemale));
					}					
				}
				case 2:
				{
					pData[playerid][pSpawnList] = 3;
					switch (pData[playerid][pGender])
					{
						case 1: ShowPlayerSelectionMenu(playerid, SPAWN_SKIN_MALE, "Choose Your Skin", SpawnSkinMale, sizeof(SpawnSkinMale));
						case 2: ShowPlayerSelectionMenu(playerid, SPAWN_SKIN_FEMALE, "Choose Your Skin", SpawnSkinFemale, sizeof(SpawnSkinFemale));
					}					
				}*/
			}
		}
	}
	//Verify Code Discord New System UCP
	if(dialogid == DIALOG_VERIFYCODE)
	{
		if(response)
		{
			new str[200];
			if(isnull(inputtext))
			{
				format(str, sizeof(str), "UCP: {15D4ED}%s\n{ffffff}Silahkan masukkan PIN yang sudah di kirimkan oleh BOT", pData[playerid][pUCP]);
				return ShowPlayerDialog(playerid, DIALOG_VERIFYCODE, DIALOG_STYLE_INPUT, "Verify Account", str, "Input", "Batal");
			}
			if(!IsNumeric(inputtext))
			{
				format(str, sizeof(str), "UCP: {15D4ED}%s\n{ffffff}Silahkan masukkan PIN yang sudah di kirimkan oleh BOT\n\n{FF0000}PIN hanya berisi 6 Digit angka bukan huruf", pData[playerid][pUCP]);
				return ShowPlayerDialog(playerid, DIALOG_VERIFYCODE, DIALOG_STYLE_INPUT, "Verify Account", str, "Input", "Batal");
			}
			if(strval(inputtext) == pData[playerid][pVerifyCode])
			{
				new lstring[512];
				format(lstring, sizeof lstring, "{ffffff}Welcome to {15D4ED}"SERVER_NAME"\n{ffffff}UCP: {15D4ED}%s\n{ffffff}Password: \nSilahkan buat password baru kamu!:", pData[playerid][pUCP]);
				ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration Executive", lstring, "Register", "Quit");
				return 1;
			}

			format(str, sizeof(str), "UCP: {15D4ED}%s\n{ffffff}Silahkan masukkan PIN yang sudah di kirimkan oleh BOT\n\n{FF0000}PIN salah!", pData[playerid][pUCP]);
			return ShowPlayerDialog(playerid, DIALOG_VERIFYCODE, DIALOG_STYLE_INPUT, "Verify Account", str, "Input", "Batal");
		}
		else 
		{
			Kick(playerid);
		}
	}
	//Last Phone System
	if(dialogid == DIALOG_TWITTER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pTwitterStatus] > 0)
					{
						ErrorMsg(playerid, "Notifikasi twitter anda belum kamu hidupkan");
						new notif[20];
						if(pData[playerid][pTwitterStatus] == 1)
						{
							notif = "{ff0000}OFF";
						}
						else
						{
							notif = "{3BBD44}ON";
						}

						new string[100];
						format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
						ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Pilih", "Tutup");
					}
					else
					{
						new str[200];
						format(str, sizeof (str), "Name Twitter: %s\nApa yang ingin kamu post?", pData[playerid][pTwittername]);
						ShowPlayerDialog(playerid, DIALOG_TWITTERPOST, DIALOG_STYLE_INPUT, "Twitter Post", str, "Post", "Kembali");
					}
				}
				case 1:
				{
					if(pData[playerid][pTwitterStatus] > 0)
					{
						ErrorMsg(playerid, "Notifikasi twitter anda belum kamu hidupkan");
						new notif[20];
						if(pData[playerid][pTwitterStatus] == 1)
						{
							notif = "{ff0000}OFF";
						}
						else
						{
							notif = "{3BBD44}ON";
						}

						new string[100];
						format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
						ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Pilih", "Tutup");
					}
					else
					{
						new str[200];
						format(str, sizeof (str), "Current Name: %s\nIsi kotak di bawah ini untuk menganti nama Twittermu.", pData[playerid][pTwittername]);
						ShowPlayerDialog(playerid, DIALOG_TWITTERNAME, DIALOG_STYLE_INPUT, "Twitter Post", str, "Change", "Kembali");
					}
				}
				case 2:
				{
					if(pData[playerid][pTwitterStatus] == 1)
					{
						pData[playerid][pTwitterStatus] = 0;
						new notif[20];
						if(pData[playerid][pTwitterStatus] == 1)
						{
							notif = "{ff0000}OFF";
						}
						else
						{
							notif = "{3BBD44}ON";
						}

						new string[100];
						format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
						ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Pilih", "Tutup");
					}
					else
					{
						pData[playerid][pTwitterStatus] = 1;
						new notif[20];
						if(pData[playerid][pTwitterStatus] == 1)
						{
							notif = "{ff0000}OFF";
						}
						else
						{
							notif = "{3BBD44}ON";
						}

						new string[100];
						format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
						ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Pilih", "Tutup");
					}
				}

			}
		}
	}
	if(dialogid == DIALOG_TWITTERPOST)
	{
		if(response)
		{
			if(pData[playerid][pTwitterPostCooldown] > 0)
			{
				Error(playerid, "Twitter masih cooldown %d detik", pData[playerid][pTwitterPostCooldown]);

				new notif[20];
				if(pData[playerid][pTwitterStatus] == 1)
				{
					notif = "{ff0000}OFF";
				}
				else
				{
					notif = "{3BBD44}ON";
				}

				new string[100];
				format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
				ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Pilih", "Tutup");
			}
			else
			{
				// Decide about multi-line msgs
				strcpy(tweet, inputtext);
				new i = -1;
				new line[512];
				new payout = strlen(tweet) * 7;
				new kuotamb = pData[playerid][pKuota]/1000;
				if(pData[playerid][pKuota] < payout)
					return Error(playerid, "Kuota anda sisa %dmb untuk mengirim %d Character", kuotamb, strlen(tweet));

				if(strlen(tweet) > 70)
				{
					i = strfind(tweet, " ", false, 60);
					if(i > 80 || i == -1) i = 70;

					// store the second line text
					line = " ";
					strcat(line, tweet[i]);

					// delete the rest from msg
					tweet[i] = EOS;
				}


				foreach(new ii : Player)
				{
					if(pData[ii][pTwitterStatus] == 0)
					{
						pData[playerid][pTwitterPostCooldown] = 40;
						SendClientMessageEx(ii, COLOR_YELLOW, "{1e90ff}[TWITTER] {7fffd4}@%s:{ffffff} %s", pData[playerid][pTwittername], tweet);
					}
				}

				new dc[128];
				format(dc, sizeof(dc),  "```\n[TWITTER] @%s: %s```", pData[playerid][pTwittername], tweet);
				SendDiscordMessage(4, dc);
				return 1;
			}
		}
		else
		{
			new notif[20];
			if(pData[playerid][pTwitterStatus] == 1)
			{
				notif = "{ff0000}OFF";
			}
			else
			{
				notif = "{3BBD44}ON";
			}

			new string[100];
			format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
			ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Pilih", "Tutup");
		}
	}
	if(dialogid == DIALOG_TWITTERNAME)
	{
		if(response)
		{
			if(pData[playerid][pTwitterNameCooldown] > 0)
			{
				Error(playerid, "Twitter changename masih cooldown %d detik", pData[playerid][pTwitterNameCooldown]);
				new notif[20];
				if(pData[playerid][pTwitterStatus] == 1)
				{
					notif = "{ff0000}OFF";
				}
				else
				{
					notif = "{3BBD44}ON";
				}

				new string[100];
				format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
				ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Pilih", "Tutup");
			}
			else
			{
				new query[512];
				format(pData[playerid][pTwittername], 64, inputtext);
				Info(playerid, "Kamu telah mengubah nama Twitter kamu menjadi {0099ff}%s", inputtext);
				pData[playerid][pTwitterNameCooldown] = 600;

				mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET twittername = '%s' WHERE reg_id = %i", inputtext, pData[playerid][pID]);
				mysql_tquery(g_SQL, query);

				new notif[20];
				if(pData[playerid][pTwitterStatus] == 1)
				{
					notif = "{ff0000}OFF";
				}
				else
				{
					notif = "{3BBD44}ON";
				}

				new string[100];
				format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
				ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Pilih", "Tutup");
			}
		}
		else
		{
			new notif[20];
			if(pData[playerid][pTwitterStatus] == 1)
			{
				notif = "{ff0000}OFF";
			}
			else
			{
				notif = "{3BBD44}ON";
			}

			new string[100];
			format(string, sizeof(string), "Tweet\nChangename Twitter({0099ff}%s{ffffff})\nNotification: %s", pData[playerid][pTwittername], notif);
			ShowPlayerDialog(playerid, DIALOG_TWITTER, DIALOG_STYLE_LIST, "Twitter", string, "Pilih", "Tutup");
		}
	}
	if(dialogid == DIALOG_TOGGLEPHONE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[500];
					format(mstr, sizeof(mstr), "Saturnus IL24 Milik %s\nNomor telepon: %d\nNama model: Saturnus Il24\nNomor serial: AS6R8127V1JKW\nIMEI (slot1):7829172392\nIMEI (slot2):8176291022", pData[playerid][pName], pData[playerid][pPhone]);
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Executive - Tentang Ponsel", mstr, "Tutup", "");
					return 0;
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_WALLPAPER, DIALOG_STYLE_LIST, "HandPhone - Wallpaper", "Hitam\nMerah\nKuning\nPink", "Pilih", "Kembali");
					return 0;
				}
			}
		}
	}
	if(dialogid == DIALOG_IBANK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new str[200];
					format(str, sizeof(str), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.", FormatMoney(pData[playerid][pBankMoney]));
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""LB_E"I-Bank", str, "Tutup", "");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, ""LB_E"I-Bank", "Masukan jumlah uang:", "Transfer", "Batal");
				}
				case 2:
				{
					DisplayPaycheck(playerid);
				}
			}
		}
	}
	//New Phone System
	if(dialogid == DIALOG_PHONE_CONTACT)
	{
		if (response)
		{
		    if (!listitem) 
			{
		        ShowPlayerDialog(playerid, DIALOG_PHONE_NEWCONTACT, DIALOG_STYLE_INPUT, "{BABABA}Executive - Kontak Baru", "Mohon masukan nama kontak yang ingin disimpan:", "Input", "Kembali");
		    }
		    else 
			{
		    	pData[playerid][pContact] = ListedContacts[playerid][listitem - 1];
		        ShowPlayerDialog(playerid, DIALOG_PHONE_INFOCONTACT, DIALOG_STYLE_LIST, "{BABAB}Executive - Kontak Info", "Telepon Kontak\nHapus Kontak", "Pilih", "Kembali");
		    }
		}
		else 
		{
			//callcmd::phone(playerid);
		}
		for (new i = 0; i != MAX_CONTACTS; i ++) 
		{
		    ListedContacts[playerid][i] = -1;
		}
		return 1;
	}
	if(dialogid == DIALOG_PHONE_ADDCONTACT)
	{
		if (response)
		{
		    static
		        name[32],
		        str[128],
				string[128];

			strunpack(name, pData[playerid][pEditingItem]);
			format(str, sizeof(str), "Nama Kontak: %s\n\nMohon masukan nomor telepon kontak tersebut:", name);
		    if (isnull(inputtext) || !IsNumeric(inputtext))
		    	return ShowPlayerDialog(playerid, DIALOG_PHONE_ADDCONTACT, DIALOG_STYLE_INPUT, "{BABABA}Executive - Kontak Baru", str, "Input", "Kembali");

			for (new i = 0; i != MAX_CONTACTS; i ++)
			{
				if (!ContactData[playerid][i][contactExists])
				{
	            	ContactData[playerid][i][contactExists] = true;
	            	ContactData[playerid][i][contactNumber] = strval(inputtext);

					format(ContactData[playerid][i][contactName], 32, name);

					mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `contacts` (`ID`, `contactName`, `contactNumber`) VALUES('%d', '%s', '%d')", pData[playerid][pID], name, ContactData[playerid][i][contactNumber]);
					mysql_tquery(g_SQL, string, "OnContactAdd", "dd", playerid, i);
					new meme[500];
					format(meme,sizeof(meme),"Anda menambahkan ~y~%s ~w~kedalam kontak", name);
					SuccesMsg(playerid, meme);
	                return 1;
				}
		    }
		    ErrorMsg(playerid, "There is no room left for anymore contacts.");
		}
		else {
			ShowContacts(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_PHONE_NEWCONTACT)
	{
		if (response)
		{
			new str[128];

		    if (isnull(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_PHONE_NEWCONTACT, DIALOG_STYLE_INPUT, "{BABABA}Executive - Kontak Baru", "Error: Please enter a contact name.\n\nPlease enter the name of the contact below:", "Submit", "Kembali");

		    if (strlen(inputtext) > 32)
		        return ShowPlayerDialog(playerid, DIALOG_PHONE_NEWCONTACT, DIALOG_STYLE_INPUT, "{BABABA}Executive - Kontak Baru", "Error: The contact name can't exceed 32 characters.\n\nPlease enter the name of the contact below:", "Submit", "Kembali");

			strpack(pData[playerid][pEditingItem], inputtext, 32);
			format(str, sizeof(str), "Nama Kontak: %s\n\nMohon masukan nomor kontak yang akan disimpan:", inputtext);
		    ShowPlayerDialog(playerid, DIALOG_PHONE_ADDCONTACT, DIALOG_STYLE_INPUT, "{BABABA}Executive - Kontak Baru", str, "Input", "Kembali");
		}
		else 
		{
			ShowContacts(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_PHONE_INFOCONTACT)
	{
		if (response)
		{
		    new
				id = pData[playerid][pContact],
				string[72];

			switch (listitem)
			{
			    case 0:
			    {
			    	format(string, 16, "%d", ContactData[playerid][id][contactNumber]);
			    	callcmd::callAufa(playerid, string);
			    }
			    case 1:
			    {
			        mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `contacts` WHERE `ID` = '%d' AND `contactID` = '%d'", pData[playerid][pID], ContactData[playerid][id][contactID]);
			        mysql_tquery(g_SQL, string);

			        Info(playerid, "You have deleted \"%s\" from your contacts.", ContactData[playerid][id][contactName]);

			        ContactData[playerid][id][contactExists] = false;
			        ContactData[playerid][id][contactNumber] = 0;
			        ContactData[playerid][id][contactID] = 0;

			        ShowContacts(playerid);
			    }
			}
		}
		else {
		    ShowContacts(playerid);
		}
		return 1;
	}
	//
	if(dialogid == DIALOG_PHONE_SENDSMS)
	{
		if (response)
		{
		    new ph = strval(inputtext);

		    if (isnull(inputtext) || !IsNumeric(inputtext))
		        return ShowPlayerDialog(playerid, DIALOG_PHONE_SENDSMS, DIALOG_STYLE_INPUT, "Send Text Message", "Please enter the number that you wish to send a text message to:", "Dial", "Kembali");

		    foreach(new ii : Player)
			{
				if(pData[ii][pPhone] == ph)
				{
		        	if(ii == INVALID_PLAYER_ID || !IsPlayerConnected(ii))
		            	return ShowPlayerDialog(playerid, DIALOG_PHONE_SENDSMS, DIALOG_STYLE_INPUT, "Send Text Message", "Error: That number is not online right now.\n\nPlease enter the number that you wish to send a text message to:", "Dial", "Kembali");

		            ShowPlayerDialog(playerid, DIALOG_PHONE_TEXTSMS, DIALOG_STYLE_INPUT, "Text Message", "Please enter the message to send", "Send", "Kembali");
		        	pData[playerid][pContact] = ph;
		        }
		    }
		}
		else 
		{
			//callcmd::phone(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_PHONE_TEXTSMS)
	{
		if (response)
		{
			if (isnull(inputtext))
				return ShowPlayerDialog(playerid, DIALOG_PHONE_TEXTSMS, DIALOG_STYLE_INPUT, "Text Message", "Error: Please enter a message to send.", "Send", "Kembali");

			new targetid = pData[playerid][pContact];
			foreach(new ii : Player)
			{
				if(pData[ii][pPhone] == targetid)
				{
					SendClientMessageEx(playerid, COLOR_YELLOW, "[SMS to %d]"WHITE_E" %s", targetid, inputtext);
					SendClientMessageEx(ii, COLOR_YELLOW, "[SMS from %d]"WHITE_E" %s", pData[playerid][pPhone], inputtext);
					Info(ii, "Gunakan "LB_E"'@<text>' "WHITE_E"untuk membalas SMS!");
					PlayerPlaySound(ii, 6003, 0,0,0);
					pData[ii][pSMS] = pData[playerid][pPhone];

					pData[playerid][pPhoneCredit] -= 1;
				}
			}
		}
		else {
	        ShowPlayerDialog(playerid, DIALOG_PHONE_SENDSMS, DIALOG_STYLE_INPUT, "Send Text Message", "Please enter the number that you wish to send a text message to:", "Submit", "Kembali");
		}
		return 1;
	}
	if(dialogid == DIALOG_PHONE_DIALUMBER)
	{
		if (response)
		{
		    new
		        string[16];

		    if (isnull(inputtext) || !IsNumeric(inputtext))
		        return ShowPlayerDialog(playerid, DIALOG_PHONE_DIALUMBER, DIALOG_STYLE_INPUT, "Dial Number", "Please enter the number that you wish to dial below:", "Dial", "Kembali");

	        format(string, 16, "%d", strval(inputtext));
			callcmd::callAufa(playerid, string);
		}
		else 
		{
			//callcmd::phone(playerid);
		}
		return 1;
	}
	if(dialogid == DIALOG_MYVEH)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedVeh", ReturnPlayerVehID(playerid, (listitem + 1)));
		new vid = GetPVarInt(playerid, "ClickedVeh");
		if(IsValidVehicle(pvData[vid][cVeh]))
		{
			new palid = pvData[vid][cVeh];
			new
  				Float:x,
	    		Float:y,
      			Float:z;

				pData[playerid][pTrackCar] = 1;
				GetVehiclePos(palid, x, y, z);
				SetPlayerRaceCheckpoint(playerid, 1, x, y, z, 0.0, 0.0, 0.0, 3.5);
				InfoMsg(playerid, "Ikuti checkpoint untuk menemukan kendaraan anda!");
		}
		else if(pvData[vid][cPark] > 0)
		{
			SetPlayerRaceCheckpoint(playerid, 1, pvData[vid][cPosX], pvData[vid][cPosY], pvData[vid][cPosZ], 0.0, 0.0, 0.0, 3.5);
			InfoMsg(playerid, "Ikuti checkpoint untuk menemukan kendaraan yang ada di dalam garkot!");
		}
		else if(pvData[vid][cClaim] != 0)
		{
			InfoMsg(playerid, "Kendaraan kamu di kantor insuransi!");
		}
		else if(pvData[vid][cStolen] != 0)
		{
			InfoMsg(playerid, "Kendaraan kamu di rusak kamu bisa memperbaikinya di kantor insuransi!");
		}
		else return ErrorMsg(playerid, "Kendaraanmu belum di spawn!");
		return 1;
	}
	if(dialogid == DIALOG_ASURANSI)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedVeh", ReturnPlayerVehID(playerid, (listitem + 1)));
		new i = GetPVarInt(playerid, "ClickedVeh");
		if(GetPlayerMoney(playerid) < 500) return ErrorMsg(playerid, "Anda butuh $500 untuk mengambil ansuransi.");
		if(pvData[i][cClaim] == 1)
		{
		    pvData[i][cClaim] = 0;
			OnPlayerVehicleRespawn(i);
			pvData[i][cPosX] = 1525.7103;
			pvData[i][cPosY] =-2179.3474;
			pvData[i][cPosZ] = 13.1285;
			pvData[i][cPosA] = 179.2143;
			SetValidVehicleHealth(pvData[i][cVeh], 1500);
			SetVehiclePos(pvData[i][cVeh], 1525.7103,-2179.3474,13.1285);
			SetVehicleZAngle(pvData[i][cVeh], 179.2143);
			SetVehicleFuel(pvData[i][cVeh], 100);
			ValidRepairVehicle(pvData[i][cVeh]);
			GivePlayerMoneyEx(playerid, -500);
			ShowItemBox(playerid, "Uang", "Removed_$500", 1212, 4);
			PutPlayerInVehicle(playerid, pvData[i][cVeh], 0);
		}
		if(pvData[i][cStolen] > 0)
		{
		    pvData[i][cStolen] = 0;
			OnPlayerVehicleRespawn(i);
			pvData[i][cPosX] = 1525.7103;
			pvData[i][cPosY] = -2179.3474;
			pvData[i][cPosZ] = 13.1285;
			pvData[i][cPosA] = 179.2143;
			SetValidVehicleHealth(pvData[i][cVeh], 1500);
			SetVehiclePos(pvData[i][cVeh], 1525.7103,-2179.3474,13.1285);
			SetVehicleZAngle(pvData[i][cVeh], 179.2143);
			SetVehicleFuel(pvData[i][cVeh], 100);
			ValidRepairVehicle(pvData[i][cVeh]);
			GivePlayerMoneyEx(playerid, -500);
			ShowItemBox(playerid, "Uang", "Removed_$500", 1212, 4);
			PutPlayerInVehicle(playerid, pvData[i][cVeh], 0);
		}
		return 1;
	}
	if(dialogid == DIALOG_FAMILY_INTERIOR)
	{
	    if(response)
	    {
	        SetPlayerPosition(playerid, famInteriorArray[listitem][intX], famInteriorArray[listitem][intY], famInteriorArray[listitem][intZ], famInteriorArray[listitem][intA]);
			SetPlayerInterior(playerid, famInteriorArray[listitem][intID]);
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(playerid));
	        InfoTD_MSG(playerid, 4000, "~g~Teleport");
	    }
	}
	if(dialogid == DIALOG_SPAREPART)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new harga = 1000;
					if(pData[playerid][pMoney] < harga)
					{
						return ErrorMsg(playerid, "Uang anda tidak cukup untuk membeli Sparepart baru!");
					}
					
					GivePlayerMoneyEx(playerid, -harga);
					pData[playerid][pSparepart] += 1;
					Info(playerid, "Kamu berhasil membeli Sparepart baru seharga %s", FormatMoney(harga));

				}
				case 1:
				{
					if(!GetVehicleStolen(playerid)) return ErrorMsg(playerid, "You don't have any Vehicle.");
					new vid, _tmpstring[128], count = GetVehicleStolen(playerid), CMDSString[512];
					CMDSString = "";
					strcat(CMDSString,"#\tModel\n",sizeof(CMDSString));
					Loop(itt, (count + 1), 1)
					{
						vid = ReturnPlayerVehStolen(playerid, itt);
						
						if(itt == count)
						{
							format(_tmpstring, sizeof(_tmpstring), "{ffffff}%d.\t%s\n", itt, GetVehicleModelName(pvData[vid][cModel]));
						}
						else format(_tmpstring, sizeof(_tmpstring), "{ffffff}%d.\t%s\n", itt, GetVehicleModelName(pvData[vid][cModel]));
						strcat(CMDSString, _tmpstring);
					}
					ShowPlayerDialog(playerid, DIALOG_BUYPARTS, DIALOG_STYLE_TABLIST_HEADERS, "Shop Sparepart", CMDSString, "Pilih", "Batal");
				}		
			}
		}
	}
	if(dialogid == DIALOG_BUYPARTS)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedVehStolen", ReturnPlayerVehStolen(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, DIALOG_BUYPARTS_DONE, DIALOG_STYLE_LIST, "Shop Sparepart", "Fixing Vehicle", "Pilih", "Batal");
		return 1;
	}
	if(dialogid == DIALOG_BUYPARTS_DONE)
	{
		if(!response) return 1;
		new vehid = GetPVarInt(playerid, "ClickedVehStolen");
		switch(listitem)
		{
			case 0:
			{
				if(pData[playerid][pSparepart] < 1)
				{
					return ErrorMsg(playerid, "Kamu membutuhkan suku cadang kendaraan untuk memperbaiki kendaraan yang rusak ini.");
				}
				
				pData[playerid][pSparepart] -= 1;
				pvData[vehid][cStolen] = 0;

				OnPlayerVehicleRespawn(vehid);
				pvData[vehid][cPosX] = 1290.7111;
				pvData[vehid][cPosY] = -1243.8767;
				pvData[vehid][cPosZ] = 13.3901;
				pvData[vehid][cPosA] = 2.5077;
				SetValidVehicleHealth(pvData[vehid][cVeh], 1500);
				SetVehiclePos(pvData[vehid][cVeh], 1290.7111, -1243.8767, 13.3901);
				SetVehicleZAngle(pvData[vehid][cVeh], 2.5077);
				SetVehicleFuel(pvData[vehid][cVeh], 1000);
				ValidRepairVehicle(pvData[vehid][cVeh]);

				Info(playerid, "Kamu telah menggunakan Sparepart untuk memperbarui kendaraan %s.", GetVehicleModelName(pvData[vehid][cModel]));
			}
		}	
	}
	if(dialogid == VEHICLE_STORAGE)
	{
		new string[200];
        new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                
                if(response)
                {
                    if(listitem == 0) 
                    {
                        Vehicle_ItemStorage(playerid, vehicleid);
                    }
                    else if(listitem == 1) 
                    {
                        format(string, sizeof(string), "Money\t{3BBD44}%s{ffffff}\n{FF0000}RedMoney\t%s{ffffff}", FormatMoney(vsData[vehicleid][vsMoney]), FormatMoney(vsData[vehicleid][vsRedMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_MONEY, DIALOG_STYLE_TABLIST, "Money Safe", string, "Pilih", "Kembali");
                    }
                    else if(listitem == 2)
                    {
                        format(string, sizeof(string), "Medicine\t({3BBD44}%d{ffffff}/%d)\nMedkit\t({3BBD44}%d{ffffff}/%d)\nBandage\t({3BBD44}%d{ffffff}/%d)", vsData[vehicleid][vsMedicine], GetVehicleStorage(vehicleid, LIMIT_MEDICINE), vsData[vehicleid][vsMedkit], GetVehicleStorage(vehicleid, LIMIT_MEDKIT), vsData[vehicleid][vsBandage], GetVehicleStorage(vehicleid, LIMIT_BANDAGE));
                        ShowPlayerDialog(playerid, VEHICLE_DRUGS, DIALOG_STYLE_TABLIST, "Drugs Storage", string, "Pilih", "Kembali");
                    } 
                    else if(listitem == 3)
                    {
                        format(string, sizeof(string), "Seeds\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL),  vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA));
                        ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Pilih", "Kembali");
                    }
                }
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_WEAPON)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    if(vsData[vehicleid][vsWeapon][listitem] != 0)
                    {
                        GivePlayerWeaponEx(playerid, vsData[vehicleid][vsWeapon][listitem], vsData[vehicleid][vsAmmo][listitem]);

                        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(vsData[vehicleid][vsWeapon][listitem]));

                        vsData[vehicleid][vsWeapon][listitem] = 0;
                        vsData[vehicleid][vsAmmo][listitem] = 0;

                        Vehicle_StorageSave(i);
                        Vehicle_ItemStorage(playerid, vehicleid);
                    }
                    else
                    {
                        new
                            weaponid = pData[playerid][pSelectItem],
                            ammo = GetPlayerAmmoEx(playerid);

                        if(weaponid == -1)
                            return ErrorMsg(playerid, "Anda belum memilih item yang akan disimpan!");

                        ResetWeapon(playerid, weaponid);
                        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "ACTION: %s telah menyimpan %s kedalam bagasi.", ReturnName(playerid), ReturnWeaponName(weaponid));

                        vsData[vehicleid][vsWeapon][listitem] = weaponid;
                        vsData[vehicleid][vsAmmo][listitem] = ammo;

                        Vehicle_StorageSave(i);
                        Vehicle_ItemStorage(playerid, vehicleid);
                    }
                }
                else
                {
                     Vehicle_OpenStorage(playerid, vehicleid);
                }
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MONEY)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            ShowPlayerDialog(playerid, VEHICLE_REALMONEY, DIALOG_STYLE_LIST, "Money Storage", "Ambil Money dari penyimpanan\nSimpan Money ke penyimpanan", "Pilih", "Kembali");
                        }
                        case 1:
                        {
                            ShowPlayerDialog(playerid, VEHICLE_REDMONEY, DIALOG_STYLE_LIST, "Redmoney Storage", "Ambil Redmoney dari penyimpanan\nSimpan Redmoney dari penyimpanan", "Pilih", "Kembali");
                        }
                    }
                }
                else Vehicle_OpenStorage(playerid, vehicleid);
            }
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}			
	if(dialogid == VEHICLE_REALMONEY)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                    	{
                            new str[200];
                            format(str, sizeof(str), "Money yang tersedia: %s\n\nSilakan masukkan berapa banyak Money yang ingin Anda ambil dari penyimpanan:", FormatMoney(vsData[vehicleid][vsMoney]));
                            ShowPlayerDialog(playerid, VEHICLE_REALMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "Money Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Money yang anda bawa: %s\n\nSilakan masukkan berapa banyak Money yang ingin Anda simpan ke dalam penyimpanan kendaraan:", FormatMoney(pData[playerid][pMoney]));
                            ShowPlayerDialog(playerid, VEHICLE_REALMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "Money Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else Vehicle_OpenStorage(playerid, vehicleid);
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_REALMONEY_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Money yang tersedia: %s\n\nSilakan masukkan berapa banyak Money yang ingin Anda ambil dari penyimpanan:", FormatMoney(vsData[vehicleid][vsMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_REALMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "Money Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsMoney])
                    {
                        new str[128];
                        format(str, sizeof(str), "Error: Money tidak mencukupi!.\n\nMoney yang tersedia: %s\n\nSilakan masukkan berapa banyak Money yang ingin Anda ambil dari kendaraan:", FormatMoney(vsData[vehicleid][vsMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_REALMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "Money Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMoney] -= amount;
                    GivePlayerMoneyEx(playerid, amount);

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %s dari penyimpanan rumah.", ReturnName(playerid), FormatMoney(amount));
                }
                else ShowPlayerDialog(playerid, VEHICLE_REALMONEY, DIALOG_STYLE_LIST, "Money Storage", "Ambil Money dari penyimpanan\nSimpan Money ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_REALMONEY_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Money yang anda bawa: %s\n\nSilakan masukkan berapa banyak Money yang ingin Anda simpan ke dalam penyimpanan:", FormatMoney(pData[playerid][pMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_REALMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "Money Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > GetPlayerMoney(playerid))
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Money tidak mencukupi!.\n\nMoney yang anda bawa: %s\n\nSilakan masukkan berapa banyak Money yang ingin Anda simpan ke dalam penyimpanan:", FormatMoney(pData[playerid][pMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_REALMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "Money Storage", str, "Simpan", "Kembali");
                        return 1;
					}
                        
                    vsData[vehicleid][vsMoney] += amount;
                    GivePlayerMoneyEx(playerid, -amount);

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %s ke penyimpanan kendaraan.", ReturnName(playerid), FormatMoney(amount));
                }
                else ShowPlayerDialog(playerid, VEHICLE_REALMONEY, DIALOG_STYLE_LIST, "Money Storage", "Ambil Money dari penyimpanan\nSimpan Money ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	//===================================================================================
	if(dialogid == VEHICLE_REDMONEY)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "RedMoney yang tersedia: %s\n\nSilakan masukkan berapa banyak RedMoney yang ingin Anda ambil dari penyimpanan:", FormatMoney(vsData[vehicleid][vsRedMoney]));
                            ShowPlayerDialog(playerid, VEHICLE_REDMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "RedMoney Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "RedMoney yang anda bawa: %s\n\nSilakan masukkan berapa banyak RedMoney yang ingin Anda simpan ke dalam penyimpanan kendaraan:", FormatMoney(pData[playerid][pRedMoney]));
                            ShowPlayerDialog(playerid, VEHICLE_REDMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "RedMoney Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else Vehicle_OpenStorage(playerid, vehicleid);
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_REDMONEY_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "RedMoney yang tersedia: %s\n\nSilakan masukkan berapa banyak RedMoney yang ingin Anda ambil dari penyimpanan:", FormatMoney(vsData[vehicleid][vsRedMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_REDMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "RedMoney Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsRedMoney])
                    {
                        new str[128];
                        format(str, sizeof(str), "Error: RedMoney tidak mencukupi!.\n\nRedMoney yang tersedia: %s\n\nSilakan masukkan berapa banyak RedMoney yang ingin Anda ambil dari kendaraan:", FormatMoney(vsData[vehicleid][vsRedMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_REDMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "RedMoney Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsRedMoney] -= amount;
                    pData[playerid][pRedMoney] += amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %s RedMoney dari penyimpanan kendaraan.", ReturnName(playerid), FormatMoney(amount));
                }
                else ShowPlayerDialog(playerid, VEHICLE_REDMONEY, DIALOG_STYLE_LIST, "RedMoney Storage", "Ambil RedMoney dari penyimpanan\nSimpan RedMoney ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_REDMONEY_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "RedMoney yang anda bawa: %s\n\nSilakan masukkan berapa banyak RedMoney yang ingin Anda simpan ke dalam penyimpanan:", FormatMoney(pData[playerid][pRedMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_REDMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "RedMoney Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pRedMoney])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: RedMoney tidak mencukupi!.\n\nRedMoney yang anda bawa: %s\n\nSilakan masukkan berapa banyak RedMoney yang ingin Anda simpan ke dalam penyimpanan:", FormatMoney(pData[playerid][pRedMoney]));
                        ShowPlayerDialog(playerid, VEHICLE_REDMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "RedMoney Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                        
                    vsData[vehicleid][vsRedMoney] += amount;
                    pData[playerid][pRedMoney] -= amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %s RedMoney ke penyimpanan kendaraan.", ReturnName(playerid), FormatMoney(amount));
                }
                else ShowPlayerDialog(playerid, VEHICLE_REDMONEY, DIALOG_STYLE_LIST, "RedMoney Storage", "Ambil RedMoney dari penyimpanan\nSimpan RedMoney ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	//===================================================================================
	if(dialogid == VEHICLE_DRUGS)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            ShowPlayerDialog(playerid, VEHICLE_MEDICINE, DIALOG_STYLE_LIST, "Medicine Storage", "Ambil Medicine dari penyimpanan\nSimpan Medicine ke penyimpanan", "Pilih", "Kembali");
                        }
                        case 1:
                        {
                            ShowPlayerDialog(playerid, VEHICLE_MEDKIT, DIALOG_STYLE_LIST, "Medkit Storage", "Ambil Medkit dari penyimpanan\nSimpan Medkit dari penyimpanan", "Pilih", "Kembali");
                        }
                        case 2:
                        {
                            ShowPlayerDialog(playerid, VEHICLE_BANDAGE, DIALOG_STYLE_LIST, "Bandage Storage", "Ambil Bandage dari penyimpanan\nSimpan Bandage dari penyimpanan", "Pilih", "Kembali");
                        }
                    }
                }
                else Vehicle_OpenStorage(playerid, vehicleid);
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}			
	if(dialogid == VEHICLE_MEDICINE)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Medicine yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMedicine]);
                            ShowPlayerDialog(playerid, VEHICLE_MEDICINE_WITHDRAW, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Medicine yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][pMedicine]);
                            ShowPlayerDialog(playerid, VEHICLE_MEDICINE_DEPOSIT, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                    new string[200];
                    format(string, sizeof(string), "Medicine\t({3BBD44}%d{ffffff}/%d)\nMedkit\t({3BBD44}%d{ffffff}/%d)\nBandage\t({3BBD44}%d{ffffff}/%d)", vsData[vehicleid][vsMedicine], GetVehicleStorage(vehicleid, LIMIT_MEDICINE), vsData[vehicleid][vsMedkit], GetVehicleStorage(vehicleid, LIMIT_MEDKIT), vsData[vehicleid][vsBandage], GetVehicleStorage(vehicleid, LIMIT_BANDAGE));
                    ShowPlayerDialog(playerid, VEHICLE_DRUGS, DIALOG_STYLE_TABLIST, "Drugs Storage", string, "Pilih", "Kembali");
                }
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MEDICINE_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Medicine yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMedicine]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDICINE_WITHDRAW, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsMedicine])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Medicine tidak mencukupi!{ffffff}.\n\nMedicine yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMedicine]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDICINE_WITHDRAW, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMedicine] -= amount;
                    pData[playerid][pMedicine] += amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d medicine dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MEDICINE, DIALOG_STYLE_LIST, "Medicine Storage", "Ambil Medicine dari penyimpanan\nSimpan Medicine ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MEDICINE_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Medicine yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMedicine]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDICINE_DEPOSIT, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pMedicine])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Medicine anda tidak mencukupi!{ffffff}.\n\nMedicine yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMedicine]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDICINE_DEPOSIT, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_MEDICINE) < vsData[vehicleid][vsMedicine] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Medicine!.\n\nMedicine yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medicine yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_MEDICINE), pData[playerid][pMedicine]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDICINE_DEPOSIT, DIALOG_STYLE_INPUT, "Medicine Storage", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMedicine] += amount;
                    pData[playerid][pMedicine] -= amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d medicine ke penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MEDICINE, DIALOG_STYLE_LIST, "Medicine Storage", "Ambil Medicine dari penyimpanan\nSimpan Medicine ke penyimpanan", "Pilih", "Kembali");
        	}    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	//=========================================================================================
	if(dialogid == VEHICLE_MEDKIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Medkit yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMedkit]);
                            ShowPlayerDialog(playerid, VEHICLE_MEDKIT_WITHDRAW, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Medkit yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][pMedkit]);
                            ShowPlayerDialog(playerid, VEHICLE_MEDKIT_DEPOSIT, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                    new string[200];
                    format(string, sizeof(string), "Medicine\t({3BBD44}%d{ffffff}/%d)\nMedkit\t({3BBD44}%d{ffffff}/%d)\nBandage\t({3BBD44}%d{ffffff}/%d)", vsData[vehicleid][vsMedicine], GetVehicleStorage(vehicleid, LIMIT_MEDICINE), vsData[vehicleid][vsMedkit], GetVehicleStorage(vehicleid, LIMIT_MEDKIT), vsData[vehicleid][vsBandage], GetVehicleStorage(vehicleid, LIMIT_BANDAGE));
                    ShowPlayerDialog(playerid, VEHICLE_DRUGS, DIALOG_STYLE_TABLIST, "Drugs Storage", string, "Pilih", "Kembali");
                }
			}    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MEDKIT_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Medkit yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMedkit]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDKIT_WITHDRAW, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsMedkit])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Medkit tidak mencukupi!{ffffff}.\n\nMedkit yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMedkit]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDKIT_WITHDRAW, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMedkit] -= amount;
                    pData[playerid][pMedkit] += amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d medkit dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MEDKIT, DIALOG_STYLE_LIST, "Medkit Storage", "Ambil Medkit dari penyimpanan\nSimpan Medkit ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MEDKIT_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Medkit yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMedkit]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDKIT_DEPOSIT, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pMedkit])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Medkit anda tidak mencukupi!{ffffff}.\n\nMedkit yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMedkit]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDKIT_DEPOSIT, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_MEDKIT) < vsData[vehicleid][vsMedkit] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Medkit!.\n\nMedkit yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Medkit yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_MEDKIT), pData[playerid][pMedkit]);
                        ShowPlayerDialog(playerid, VEHICLE_MEDKIT_DEPOSIT, DIALOG_STYLE_INPUT, "Medkit Storage", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMedkit] += amount;
                    pData[playerid][pMedkit] -= amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d medkit ke penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MEDKIT, DIALOG_STYLE_LIST, "Medkit Storage", "Ambil Medkit dari penyimpanan\nSimpan Medkit ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	//=========================================================================================
	if(dialogid == VEHICLE_BANDAGE)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Bandage yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsBandage]);
                            ShowPlayerDialog(playerid, VEHICLE_BANDAGE_WITHDRAW, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Bandage yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][pBandage]);
                            ShowPlayerDialog(playerid, VEHICLE_BANDAGE_DEPOSIT, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                    new string[200];
                    format(string, sizeof(string), "Medicine\t({3BBD44}%d{ffffff}/%d)\nMedkit\t({3BBD44}%d{ffffff}/%d)\nBandage\t({3BBD44}%d{ffffff}/%d)", vsData[vehicleid][vsMedicine], GetVehicleStorage(vehicleid, LIMIT_MEDICINE), vsData[vehicleid][vsMedkit], GetVehicleStorage(vehicleid, LIMIT_MEDKIT), vsData[vehicleid][vsBandage], GetVehicleStorage(vehicleid, LIMIT_BANDAGE));
                    ShowPlayerDialog(playerid, VEHICLE_DRUGS, DIALOG_STYLE_TABLIST, "Drugs Storage", string, "Pilih", "Kembali");
                }
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_BANDAGE_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Bandage yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsBandage]);
                        ShowPlayerDialog(playerid, VEHICLE_BANDAGE_WITHDRAW, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsBandage])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Bandage tidak mencukupi!{ffffff}.\n\nBandage yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsBandage]);
                        ShowPlayerDialog(playerid, VEHICLE_BANDAGE_WITHDRAW, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsBandage] -= amount;
                    pData[playerid][pBandage] += amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d bandage dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_BANDAGE, DIALOG_STYLE_LIST, "Bandage Storage", "Ambil Bandage dari penyimpanan\nSimpan Bandage ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_BANDAGE_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Bandage yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pBandage]);
                        ShowPlayerDialog(playerid, VEHICLE_BANDAGE_DEPOSIT, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pBandage])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Bandage anda tidak mencukupi!{ffffff}.\n\nBandage yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pBandage]);
                        ShowPlayerDialog(playerid, VEHICLE_BANDAGE_DEPOSIT, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_BANDAGE) < vsData[vehicleid][vsBandage] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Bandage!.\n\nBandage yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Bandage yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_BANDAGE), pData[playerid][pBandage]);
                        ShowPlayerDialog(playerid, VEHICLE_BANDAGE_DEPOSIT, DIALOG_STYLE_INPUT, "Bandage Storage", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsBandage] += amount;
                    pData[playerid][pBandage] -= amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d bandage ke penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_BANDAGE, DIALOG_STYLE_LIST, "Bandage Storage", "Ambil Bandage dari penyimpanan\nSimpan Bandage ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	//===================================================================================
	if(dialogid == VEHICLE_OTHER)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            ShowPlayerDialog(playerid, VEHICLE_SEED, DIALOG_STYLE_LIST, "Seed Storage", "Ambil Seed dari penyimpanan\nSimpan Seed ke penyimpanan", "Pilih", "Kembali");
                        }
                        case 1:
                        {
                            ShowPlayerDialog(playerid, VEHICLE_MATERIAL, DIALOG_STYLE_LIST, "Material Storage", "Ambil Material dari penyimpanan\nSimpan Material dari penyimpanan", "Pilih", "Kembali");
                        }
                        case 2:
                        {
                            ShowPlayerDialog(playerid, VEHICLE_COMPONENT, DIALOG_STYLE_LIST, "Component Storage", "Ambil Component dari penyimpanan\nSimpan Component dari penyimpanan", "Pilih", "Kembali");
                        }
                        case 3:
                        {
                            ShowPlayerDialog(playerid, VEHICLE_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana Storage", "Ambil Marijuana dari penyimpanan\nSimpan Marijuana dari penyimpanan", "Pilih", "Kembali");
                        }
                    }
                }
                else Vehicle_OpenStorage(playerid, vehicleid);
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}			
	if(dialogid == VEHICLE_SEED)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Seed yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsSeed]);
                            ShowPlayerDialog(playerid, VEHICLE_SEED_WITHDRAW, DIALOG_STYLE_INPUT, "Seed Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Seed yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][pSeed]);
                            ShowPlayerDialog(playerid, VEHICLE_SEED_DEPOSIT, DIALOG_STYLE_INPUT, "Seed Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                    new string[200];
                    format(string, sizeof(string), "Seeds\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL),  vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA));
                    ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Pilih", "Kembali");
                }
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_SEED_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Seed yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsSeed]);
                        ShowPlayerDialog(playerid, VEHICLE_SEED_WITHDRAW, DIALOG_STYLE_INPUT, "Seed Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsSeed])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Seed tidak mencukupi!{ffffff}.\n\nSeed yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsSeed]);
                        ShowPlayerDialog(playerid, VEHICLE_SEED_WITHDRAW, DIALOG_STYLE_INPUT, "Seed Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsSeed] -= amount;
                    pData[playerid][pSeed] += amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d seed dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_SEED, DIALOG_STYLE_LIST, "Seed Storage", "Ambil Seed dari penyimpanan\nSimpan Seed ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_SEED_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Seed yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pSeed]);
                        ShowPlayerDialog(playerid, VEHICLE_SEED_DEPOSIT, DIALOG_STYLE_INPUT, "Seed Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pSeed])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Seed anda tidak mencukupi!{ffffff}.\n\nSeed yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pSeed]);
                        ShowPlayerDialog(playerid, VEHICLE_SEED_DEPOSIT, DIALOG_STYLE_INPUT, "Seed Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_SEED) < vsData[vehicleid][vsSeed] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Seed!.\n\nSeed yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Seed yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_SEED), pData[playerid][pSeed]);
                        ShowPlayerDialog(playerid, VEHICLE_SEED_DEPOSIT, DIALOG_STYLE_INPUT, "Seed Storage", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsSeed] += amount;
                    pData[playerid][pSeed] -= amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d seed ke penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_SEED, DIALOG_STYLE_LIST, "Seed Storage", "Ambil Seed dari penyimpanan\nSimpan Seed ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	if(dialogid == VEHICLE_MATERIAL)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Material yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMaterial]);
                            ShowPlayerDialog(playerid, VEHICLE_MATERIAL_WITHDRAW, DIALOG_STYLE_INPUT, "Material Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Material yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][pMaterial]);
                            ShowPlayerDialog(playerid, VEHICLE_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, "Material Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                    new string[200];
                    format(string, sizeof(string), "Seed\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL),  vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA));
                    ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Pilih", "Kembali");
                }
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MATERIAL_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Material yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMaterial]);
                        ShowPlayerDialog(playerid, VEHICLE_MATERIAL_WITHDRAW, DIALOG_STYLE_INPUT, "Material Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsMaterial])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Material tidak mencukupi!{ffffff}.\n\nMaterial yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMaterial]);
                        ShowPlayerDialog(playerid, VEHICLE_MATERIAL_WITHDRAW, DIALOG_STYLE_INPUT, "Material Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMaterial] -= amount;
                    pData[playerid][pMaterial] += amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d material dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MATERIAL, DIALOG_STYLE_LIST, "Material Storage", "Ambil Material dari penyimpanan\nSimpan Material ke penyimpanan", "Pilih", "Kembali");
            }
        }
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MATERIAL_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Material yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMaterial]);
                        ShowPlayerDialog(playerid, VEHICLE_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, "Material Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pMaterial])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Material anda tidak mencukupi!{ffffff}.\n\nMaterial yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMaterial]);
                        ShowPlayerDialog(playerid, VEHICLE_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, "Material Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_MATERIAL) < vsData[vehicleid][vsMaterial] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Material!.\n\nMaterial yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Material yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_MATERIAL), pData[playerid][pMaterial]);
                        ShowPlayerDialog(playerid, VEHICLE_MATERIAL_DEPOSIT, DIALOG_STYLE_INPUT, "Material Storage", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMaterial] += amount;
                    pData[playerid][pMaterial] -= amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d material ke penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MATERIAL, DIALOG_STYLE_LIST, "Material Storage", "Ambil Material dari penyimpanan\nSimpan Material ke penyimpanan", "Pilih", "Kembali");
            }
        }
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	//==============================================
	if(dialogid == VEHICLE_COMPONENT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Component yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsComponent]);
                            ShowPlayerDialog(playerid, VEHICLE_COMPONENT_WITHDRAW, DIALOG_STYLE_INPUT, "Component Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Component yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][pComponent]);
                            ShowPlayerDialog(playerid, VEHICLE_COMPONENT_DEPOSIT, DIALOG_STYLE_INPUT, "Component Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                    new string[200];
                    format(string, sizeof(string), "Seed\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL),  vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA));
                    ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Pilih", "Kembali");
                }
            }
        }
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_COMPONENT_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Component yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsComponent]);
                        ShowPlayerDialog(playerid, VEHICLE_COMPONENT_WITHDRAW, DIALOG_STYLE_INPUT, "Component Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsComponent])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Component tidak mencukupi!{ffffff}.\n\nComponent yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsComponent]);
                        ShowPlayerDialog(playerid, VEHICLE_COMPONENT_WITHDRAW, DIALOG_STYLE_INPUT, "Component Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsComponent] -= amount;
                    pData[playerid][pComponent] += amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d component dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_COMPONENT, DIALOG_STYLE_LIST, "Component Storage", "Ambil Component dari penyimpanan\nSimpan Component ke penyimpanan", "Pilih", "Kembali");
            }    
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_COMPONENT_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Component yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pComponent]);
                        ShowPlayerDialog(playerid, VEHICLE_COMPONENT_DEPOSIT, DIALOG_STYLE_INPUT, "Component Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pComponent])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Component anda tidak mencukupi!{ffffff}.\n\nComponent yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pComponent]);
                        ShowPlayerDialog(playerid, VEHICLE_COMPONENT_DEPOSIT, DIALOG_STYLE_INPUT, "Component Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_COMPONENT) < vsData[vehicleid][vsComponent] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Component!.\n\nComponent yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Component yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_COMPONENT), pData[playerid][pComponent]);
                        ShowPlayerDialog(playerid, VEHICLE_COMPONENT_DEPOSIT, DIALOG_STYLE_INPUT, "Component Storage", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsComponent] += amount;
                    pData[playerid][pComponent] -= amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d component ke penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_COMPONENT, DIALOG_STYLE_LIST, "Component Storage", "Ambil Component dari penyimpanan\nSimpan Component ke penyimpanan", "Pilih", "Kembali");
            }
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	//=====================================================
	if(dialogid == VEHICLE_MARIJUANA)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    switch (listitem)
                    {
                        case 0: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Marijuana yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMarijuana]);
                            ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_WITHDRAW, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Ambil", "Kembali");
                        }
                        case 1: 
                        {
                            new str[200];
                            format(str, sizeof(str), "Marijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan kendaraan:", pData[playerid][pMarijuana]);
                            ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Simpan", "Kembali");
                        }
                    }
                }
                else
                {
                    new string[200];
                    format(string, sizeof(string), "Seed\t({3BBD44}%d{ffffff}/%d)\nMaterial\t({3BBD44}%d{ffffff}/%d)\nComponent\t({3BBD44}%d{ffffff}/%d)\n{FF0000}Marijuana\t(%d{ffffff}/%d)", vsData[vehicleid][vsSeed], GetVehicleStorage(vehicleid, LIMIT_SEED), vsData[vehicleid][vsMaterial], GetVehicleStorage(vehicleid, LIMIT_MATERIAL),  vsData[vehicleid][vsComponent], GetVehicleStorage(vehicleid, LIMIT_COMPONENT), vsData[vehicleid][vsMarijuana], GetVehicleStorage(vehicleid, LIMIT_MARIJUANA));
                    ShowPlayerDialog(playerid, VEHICLE_OTHER, DIALOG_STYLE_TABLIST, "Other Storage", string, "Pilih", "Kembali");
                } 
			}
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MARIJUANA_WITHDRAW)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                    new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[200];
                        format(str, sizeof(str), "Marijuana yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMarijuana]);
                        ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_WITHDRAW, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Ambil", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > vsData[vehicleid][vsMarijuana])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Marijuana tidak mencukupi!{ffffff}.\n\nMarijuana yang tersedia: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda ambil dari penyimpanan:", vsData[vehicleid][vsMarijuana]);
                        ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_WITHDRAW, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Ambil", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMarijuana] -= amount;
                    pData[playerid][pMarijuana] += amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %d marijuana dari penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana Storage", "Ambil Marijuana dari penyimpanan\nSimpan Marijuana ke penyimpanan", "Pilih", "Kembali");
            }
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;
	}
	if(dialogid == VEHICLE_MARIJUANA_DEPOSIT)
	{
		new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x != INVALID_VEHICLE_ID)
        {
	        foreach(new i: PVehicles)
            if(x == pvData[i][cVeh])
            {
			    new vehicleid = pvData[i][cVeh];
                if(response)
                {
                	new amount = strval(inputtext);

                    if(isnull(inputtext))
                    {
                        new str[128];
                        format(str, sizeof(str), "Marijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMarijuana]);
                        ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(amount < 1 || amount > pData[playerid][pMarijuana])
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: {ff0000}Marijuana anda tidak mencukupi!{ffffff}.\n\nMarijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan:", pData[playerid][pMarijuana]);
                        ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Simpan", "Kembali");
                        return 1;
                    }
                    if(GetVehicleStorage(vehicleid, LIMIT_MARIJUANA) < vsData[vehicleid][vsMarijuana] + amount)
                    {
                        new str[200];
                        format(str, sizeof(str), "Error: Storage tidak bisa menampung lebih dari %d Marijuana!.\n\nMarijuana yang anda bawa: {3BBD44}%d{ffffff}\n\nSilakan masukkan berapa banyak Marijuana yang ingin Anda simpan ke dalam penyimpanan:", GetVehicleStorage(vehicleid, LIMIT_MARIJUANA), pData[playerid][pMarijuana]);
                        ShowPlayerDialog(playerid, VEHICLE_MARIJUANA_DEPOSIT, DIALOG_STYLE_INPUT, "Marijuana Storage", str, "Simpan", "Kembali");
                        return 1;
                    }

                    vsData[vehicleid][vsMarijuana] += amount;
                    pData[playerid][pMarijuana] -= amount;

                    Vehicle_StorageSave(i);
                    Vehicle_OpenStorage(playerid, vehicleid);

                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %d marijuana ke penyimpanan kendaraan.", ReturnName(playerid), amount);
                }
                else ShowPlayerDialog(playerid, VEHICLE_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana Storage", "Ambil Marijuana dari penyimpanan\nSimpan Marijuana ke penyimpanan", "Pilih", "Kembali");
            }
		}
		else ErrorMsg(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
		return 1;	
	}
	if(dialogid == DIALOG_SERVERMONEY)
	{
		if(response)
		{
			ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_STORAGE, DIALOG_STYLE_LIST, "Storage City Money", "Withdraw City Money\nDeposit City Money", "Pilih", "Batal");
			return 1;
		}
	}
	if(dialogid == DIALOG_SERVERMONEY_STORAGE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new str[200];
					format(str, sizeof(str), "City Money: {3BBD44}%s\n\n{FFFFFF}Berapa uang negara yang ingin anda ambil?", FormatMoney(ServerMoney));
					ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "Storage City Money", str, "Withdraw", "Kembali");
					return 1;
				}
				case 1:
				{
					new str[200];
					format(str, sizeof(str), "Your Money: {3BBD44}%s\n\n{FFFFFF}Berapa uang yang mau anda simpan ke uang negara?", FormatMoney(pData[playerid][pMoney]));
					ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "Storage City Money", str, "Deposit", "Kembali");
					return 1;
				}
			}
		}
		else 
		{
			new lstr[300];
			pData[playerid][pUangKorup] = 0;
			format(lstr, sizeof(lstr), "City Money: {3BBD44}%s", FormatMoney(ServerMoney));
			ShowPlayerDialog(playerid, DIALOG_SERVERMONEY, DIALOG_STYLE_MSGBOX, "Executive City Money", lstr, "Manage", "Tutup");
		}
	}
	if(dialogid == DIALOG_SERVERMONEY_WITHDRAW)
	{
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext) || !IsNumeric(inputtext))
			{
				new str[200];
				format(str, sizeof(str), "{ff0000}ERROR: {ffff00}Masukan sebuah angka!!\n{ffffff}City Money: {3BBD44}%s\n\n{FFFFFF}Berapa uang negara yang ingin anda ambil?", FormatMoney(ServerMoney));
				ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "Storage City Money", str, "Withdraw", "Kembali");
			}
			if(amount < 1 || amount > ServerMoney)
			{
				new str[200];
				format(str, sizeof(str), "{ff0000}ERROR: {ffff00}Jumlah tidak mencukupi!!\n{ffffff}City Money: {3BBD44}%s\n\n{FFFFFF}Berapa uang negara yang ingin anda ambil?", FormatMoney(ServerMoney));
				ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_WITHDRAW, DIALOG_STYLE_INPUT, "Storage City Money", str, "Withdraw", "Kembali");
			}

			pData[playerid][pUangKorup] += amount;

			new str[200];
			format(str, sizeof(str), "Masukan alasan kamu mengambil uang");
			ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_REASON, DIALOG_STYLE_INPUT, "Reason", str, "Masukkan", "Kembali");
			return 1;
		}
		else
		{
			pData[playerid][pUangKorup] = 0;
			ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_STORAGE, DIALOG_STYLE_LIST, "Storage City Money", "Withdraw City Money\nDeposit City Money", "Pilih", "Batal");
			return 1;
		}
	}
	if(dialogid == DIALOG_SERVERMONEY_DEPOSIT)
	{
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext) || !IsNumeric(inputtext))
			{
				new str[200];
				format(str, sizeof(str), "Your Money: {3BBD44}%s\n\n{FFFFFF}Berapa uang yang mau anda simpan ke uang negara?", FormatMoney(pData[playerid][pMoney]));
				ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "Storage City Money", str, "Deposit", "Kembali");
			}
			if(amount < 1 || amount > ServerMoney)
			{
				new str[200];
				format(str, sizeof(str), "Your Money: {3BBD44}%s\n\n{FFFFFF}Berapa uang yang mau anda simpan ke uang negara?", FormatMoney(pData[playerid][pMoney]));
				ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_DEPOSIT, DIALOG_STYLE_INPUT, "Storage City Money", str, "Deposit", "Kembali");
			}

			pData[playerid][pMoney] -= amount;
			Server_AddMoney(amount);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah menyimpan %s uang ke penyimpanan uang ngeara.", ReturnName(playerid), FormatMoney(amount));
			new str[200];
			format(str, sizeof(str), "```\nKorup Detect: %s menyimpan uang kota sebesar %s```", ReturnName(playerid), FormatMoney(amount));
			SendDiscordMessage(6, str);
			return 1;
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_STORAGE, DIALOG_STYLE_LIST, "Storage City Money", "Withdraw City Money\nDeposit City Money", "Pilih", "Batal");
			return 1;
		}
	}
	if(dialogid == DIALOG_SERVERMONEY_REASON)
	{
		if(response)
		{
			if(isnull(inputtext))
			{
				new str[200];
				format(str, sizeof(str), "Masukan alasan kamu mengambil uang");
				ShowPlayerDialog(playerid, DIALOG_SERVERMONEY_REASON, DIALOG_STYLE_INPUT, "Reason", str, "Masukkan", "Kembali");
			}

			GivePlayerMoneyEx(playerid, pData[playerid][pUangKorup]);
			Server_MinMoney(pData[playerid][pUangKorup]);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil %s uang dari penyimpanan uang ngeara.", ReturnName(playerid), FormatMoney(pData[playerid][pUangKorup]));
			new str[200];
			format(str, sizeof(str), "```\nKorup Detect: %s mengambil uang kota sebesar %s\nReason: %s```", ReturnName(playerid), FormatMoney(pData[playerid][pUangKorup]), inputtext);
			SendDiscordMessage(6, str);
			pData[playerid][pUangKorup] = 0;
		}
		else
		{
			pData[playerid][pUangKorup] = 0;
		}
	}
	if(dialogid == DIALOG_NONRPNAME)
	{
		if(response)
		{
			if(isnull(inputtext))
			{
				ErrorMsg(playerid, "Masukan namamu!");
				new string[256];
				format(string, sizeof (string), "{ff0000}Nama kamu non rp name!\n{ffffff}Contoh Nama RP: {3BBD44}James_Petterson, Antonio_Whitford, Javier_Valdes.{ffffff}\n\n{ffff00}Silahkan isi nama kamu baru dibawah ini!");
				ShowPlayerDialog(playerid, DIALOG_NONRPNAME, DIALOG_STYLE_INPUT, "{ffff00}Non Roleplay Name", string, "Change", "Batal");
				return 1;
			}
			if(strlen(inputtext) < 4 || strlen(inputtext) > 32)
			{
				ErrorMsg(playerid, "Minimal nama berisi 4 huruf dan Maximal 32 huruf");
				new string[256];
				format(string, sizeof (string), "{ff0000}Nama kamu non rp name!\n{ffffff}Contoh Nama RP: {3BBD44}James_Petterson, Antonio_Whitford, Javier_Valdes.{ffffff}\n\n{ffff00}Silahkan isi nama kamu baru dibawah ini!");
				ShowPlayerDialog(playerid, DIALOG_NONRPNAME, DIALOG_STYLE_INPUT, "{ffff00}Non Roleplay Name", string, "Change", "Batal");
				return 1;
			}
			if(!IsValidRoleplayName(inputtext))
			{
				ErrorMsg(playerid, "Nama karakter tidak valid, silahkan cek 2x");
				new string[256];
				format(string, sizeof (string), "{ff0000}Nama kamu non rp name!\n{ffffff}Contoh Nama RP: {3BBD44}James_Petterson, Antonio_Whitford, Javier_Valdes.{ffffff}\n\n{ffff00}Silahkan isi nama kamu baru dibawah ini!");
				ShowPlayerDialog(playerid, DIALOG_NONRPNAME, DIALOG_STYLE_INPUT, "{ffff00}Non Roleplay Name", string, "Change", "Batal");
				return 1;
			}

			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE username='%s'", inputtext);
			mysql_tquery(g_SQL, query, "NonRPName", "is", playerid, inputtext);
		}
		else
		{
			SendStaffMessage(COLOR_RED, "%s{ffffff} membatalkan pengubahan namanya!", GetRPName(playerid));
		}
	}
	if(dialogid == DIALOG_BOOMBOX)
    {
    	if(!response)
     	{
            SendClientMessage(playerid, COLOR_WHITE, " Kamu Membatalkan Music");
        	return 1;
        }
		switch(listitem)
  		{
			case 1:
			{
			    ShowPlayerDialog(playerid,DIALOG_BOOMBOX1,DIALOG_STYLE_INPUT, "Boombox Input URL", "Please put a Music URL to play the Music", "Play", "Batal");
			}
			case 2:
			{
                if(GetPVarType(playerid, "BBArea"))
			    {
			        new string[128], pNames[MAX_PLAYER_NAME];
			        GetPlayerName(playerid, pNames, MAX_PLAYER_NAME);
					format(string, sizeof(string), "* %s Mematikan Boomboxnya", pNames);
					SendNearbyMessage(playerid, 15, COLOR_PURPLE, string);
			        foreach(new i : Player)
					{
			            if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
			            {
			                StopStream(i);
						}
					}
			        DeletePVar(playerid, "BBStation");
				}
				SendClientMessage(playerid, COLOR_WHITE, "Kamu Telah Mematikan Boomboxnya");
			}
        }
	}
	if(dialogid == DIALOG_BOOMBOX1)//SET URL
	{
		if(response == 1)
		{
		    if(isnull(inputtext))
		    {
		        SendClientMessage(playerid, COLOR_WHITE, "Kamu Tidak Menulis Apapun" );
		        return 1;
		    }
		    if(strlen(inputtext))
		    {
		        if(GetPVarType(playerid, "PlacedBB"))
				{
				    foreach(new i : Player)
					{
						if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
						{
							PlayStream(i, inputtext, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
				  		}
				  	}
			  		SetPVarString(playerid, "BBStation", inputtext);
				}
			}
		}
	}
	if(dialogid == DIALOG_BSHOP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pRedMoney] < 5000) return ErrorMsg(playerid, "Anda tidak memiliki banyak uang merah untuk membeli barang ini");
					pData[playerid][pRedMoney] -= 5000;
					pData[playerid][pPanelHacking] += 1;
					Info(playerid, "Anda berhasil membeli sebuah Panel Hacking seharga $5.000 Uang Merah");
				}
			}
		}
	}
	//PEDAGANG
	if(dialogid == PEDAGANG_MENU)
	{
		if(response)
		{
			switch(listitem)
			{
				
				case 0:
				{
					ShowPlayerDialog(playerid, PDG_KENTANG, DIALOG_STYLE_LIST, "{BABABA}Executive - {FFFFFF}Gudang Pedagang", "Ambil Beras\nSimpan Beras", "Pilih","Batal");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, PDG_MINERAL, DIALOG_STYLE_LIST, "{BABABA}Executive - {FFFFFF}Gudang Pedagang", "Ambil Sambal\nSimpan Sambal", "Pilih","Batal");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, PDG_SNACK, DIALOG_STYLE_LIST, "{BABABA}Executive - {FFFFFF}Gudang Pedagang", "Ambil Tepung\nSimpan Tepung", "Pilih","Batal");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, PDG_CHICKEN, DIALOG_STYLE_LIST, "{BABABA}Executive - {FFFFFF}Gudang Pedagang", "Ambil gula\nSimpan gula", "Pilih","Batal");
				}
				case 4:
				{
					ShowPlayerDialog(playerid, PDG_COCACOLA, DIALOG_STYLE_LIST, "{BABABA}Executive - {FFFFFF}Gudang Pedagang", "Ambil ayam fillet\nSimpan ayam fillet", "Pilih","Batal");
				}
			}
		}
	}
	if(dialogid == PDG_KENTANG) //Kentang
	{
		if(response)
		{
			new str[256], pid = pData[playerid][pInPdg];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pdgMenuType] = 0;
					format(str, sizeof str,"Beras: %d\n\nMohon Masukan jumlah yang ingin diambil", pdgDATA[pid][pdgKentang]);
				}
				case 1:
				{
					pData[playerid][pdgMenuType] = 1;
					format(str, sizeof str,"Beras: %d\n\nMohon Masukan jumlah yang ingin disimpan", pdgDATA[pid][pdgKentang]);
				}
			}
			ShowPlayerDialog(playerid, PDG_KENTANG1, DIALOG_STYLE_INPUT, "{BABABA}Executive - {FFFFFF}Gudang Pedagang", str, "Input","Batal");
		}
	}
	if(dialogid == PDG_KENTANG1)
	{
		if(response)
		{
			new amount = strval(inputtext), pid = pData[playerid][pInPdg];
			if(pData[playerid][pdgMenuType] == 0)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah Minimal 1");

				if(pdgDATA[pid][pdgKentang] < amount) return ErrorMsg(playerid, "Beras yang ingin anda ambil tidak cukup!");

				if((pdgDATA[pid][pdgKentang] + amount) >= 10000)
					return ErrorMsg(playerid, "You've reached maximum of Kentang");

				pData[playerid][pBeras] += amount;
				pdgDATA[pid][pdgKentang] -= amount;
				Pedagang_Save(pid);
				Info(playerid, "Anda mengambil %d beras dari gudang", amount);
			}
			else if(pData[playerid][pdgMenuType] == 1)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah minimal 1");

				if(pData[playerid][pBeras] < amount) return ErrorMsg(playerid, "Anda tidak memiliki beras");

				pData[playerid][pBeras] -= amount;
				pdgDATA[pid][pdgKentang] += amount;
				Pedagang_Save(pid);
				Info(playerid, "Anda menyimpan %d Beras ke dalam gudang", amount);
			}
		}
	}
	if(dialogid == PDG_MINERAL) //MINERAL
	{
		if(response)
		{
			new str[256], pid = pData[playerid][pInPdg];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pdgMenuType] = 0;
					format(str, sizeof str,"Sambal: %d\n\nPlease Input amount to Withdraw", pdgDATA[pid][pdgMineral]);
				}
				case 1:
				{
					pData[playerid][pdgMenuType] = 1;
					format(str, sizeof str,"Sambal: %d\n\nPlease Input amount to Deposit", pdgDATA[pid][pdgMineral]);
				}
			}
			ShowPlayerDialog(playerid, PDG_MINERAL1, DIALOG_STYLE_INPUT, "{BABABA}Executive - {FFFFFF}Gudang Pedagang", str, "Input","Batal");
		}
	}
	if(dialogid == PDG_MINERAL1)
	{
		if(response)
		{
			new amount = strval(inputtext), pid = pData[playerid][pInPdg];
			if(pData[playerid][pdgMenuType] == 0)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah Minimal 1");

				if(pdgDATA[pid][pdgMineral] < amount) return ErrorMsg(playerid, "Not Enough Sambal");

				if((pdgDATA[pid][pdgMineral] + amount) >= 10000)
					return ErrorMsg(playerid, "You've reached maximum of Sambal");

				pData[playerid][pSambal] += amount;
				pdgDATA[pid][pdgMineral] -= amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully withdraw %d Sambal from Gudang", amount);
			}
			else if(pData[playerid][pdgMenuType] == 1)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah minimal 1");

				if(pData[playerid][pSambal] < amount) return ErrorMsg(playerid, "Not Enough Sambal");

				pData[playerid][pSambal] -= amount;
				pdgDATA[pid][pdgMineral] += amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully deposit %d Sambal", amount);
			}
		}
	}
	if(dialogid == PDG_SNACK) //Snack
	{
		if(response)
		{
			new str[256], pid = pData[playerid][pInPdg];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pdgMenuType] = 0;
					format(str, sizeof str,"Tepung: %d\n\nPlease Input amount to Withdraw", pdgDATA[pid][pdgSnack]);
				}
				case 1:
				{
					pData[playerid][pdgMenuType] = 1;
					format(str, sizeof str,"Tepung: %d\n\nPlease Input amount to Deposit", pdgDATA[pid][pdgSnack]);
				}
			}
			ShowPlayerDialog(playerid, PDG_SNACK1, DIALOG_STYLE_INPUT, "{BABABA}Executive - {FFFFFF}Gudang Pedagang", str, "Input","Batal");
		}
	}
	if(dialogid == PDG_SNACK1)
	{
		if(response)
		{
			new amount = strval(inputtext), pid = pData[playerid][pInPdg];
			if(pData[playerid][pdgMenuType] == 0)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah Minimal 1");

				if(pdgDATA[pid][pdgSnack] < amount) return ErrorMsg(playerid, "Not Enough Tepung");

				if((pdgDATA[pid][pdgSnack] + amount) >= 10000)
					return ErrorMsg(playerid, "You've reached maximum of tepung");

				pData[playerid][pTepung] += amount;
				pdgDATA[pid][pdgSnack] -= amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully withdraw %d tepung from Gudang", amount);
			}
			else if(pData[playerid][pdgMenuType] == 1)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah minimal 1");

				if(pData[playerid][pTepung] < amount) return ErrorMsg(playerid, "Not Enough tepung");

				pData[playerid][pTepung] -= amount;
				pdgDATA[pid][pdgSnack] += amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully deposit %d tepung", amount);
			}
		}
	}
	if(dialogid == PDG_CHICKEN) //Frien Chicken
	{
		if(response)
		{
			new str[256], pid = pData[playerid][pInPdg];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pdgMenuType] = 0;
					format(str, sizeof str,"Gula: %d\n\nPlease Input amount to Withdraw", pdgDATA[pid][pdgChicken]);
				}
				case 1:
				{
					pData[playerid][pdgMenuType] = 1;
					format(str, sizeof str,"Gula: %d\n\nPlease Input amount to Deposit", pdgDATA[pid][pdgChicken]);
				}
			}
			ShowPlayerDialog(playerid, PDG_CHICKEN1, DIALOG_STYLE_INPUT, "{BABABA}Executive - {FFFFFF}Gudang Pedagang", str, "Input","Batal");
		}
	}
	if(dialogid == PDG_CHICKEN1)
	{
		if(response)
		{
			new amount = strval(inputtext), pid = pData[playerid][pInPdg];
			if(pData[playerid][pdgMenuType] == 0)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah Minimal 1");

				if(pdgDATA[pid][pdgChicken] < amount) return ErrorMsg(playerid, "Not Enough gula");

				if((pdgDATA[pid][pdgChicken] + amount) >= 10000)
					return ErrorMsg(playerid, "You've reached maximum of gula");

				pData[playerid][pGula] += amount;
				pdgDATA[pid][pdgChicken] -= amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully withdraw %d gula from Gudang", amount);
			}
			else if(pData[playerid][pdgMenuType] == 1)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah minimal 1");

				if(pData[playerid][pGula] < amount) return ErrorMsg(playerid, "Not Enough gula");

				pData[playerid][pGula] -= amount;
				pdgDATA[pid][pdgChicken] += amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully deposit %d gula", amount);
			}
		}
	}
	if(dialogid == PDG_COCACOLA) //Coca Cola
	{
		if(response)
		{
			new str[256], pid = pData[playerid][pInPdg];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pdgMenuType] = 0;
					format(str, sizeof str,"Ayam Fillet: %d\n\nPlease Input amount to Withdraw", pdgDATA[pid][pdgCocacola]);
				}
				case 1:
				{
					pData[playerid][pdgMenuType] = 1;
					format(str, sizeof str,"Ayam Fillet: %d\n\nPlease Input amount to Deposit", pdgDATA[pid][pdgCocacola]);
				}
			}
			ShowPlayerDialog(playerid, PDG_COCACOLA1, DIALOG_STYLE_INPUT, "Executive - Gudang Pedagang", str, "Input","Batal");
		}
	}
	if(dialogid == PDG_COCACOLA1)
	{
		if(response)
		{
			new amount = strval(inputtext), pid = pData[playerid][pInPdg];
			if(pData[playerid][pdgMenuType] == 0)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah Minimal 1");

				if(pdgDATA[pid][pdgCocacola] < amount) return ErrorMsg(playerid, "Not Enough Cocacola");

				if((pdgDATA[pid][pdgCocacola] + amount) >= 10000)
					return ErrorMsg(playerid, "You've reached maximum of Cocacola");

				pData[playerid][AyamFillet] += amount;
				pdgDATA[pid][pdgCocacola] -= amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully withdraw %d ayam fillet from Gudang", amount);
			}
			else if(pData[playerid][pdgMenuType] == 1)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah minimal 1");

				if(pData[playerid][AyamFillet] < amount) return ErrorMsg(playerid, "Not Enough ayam fillet");
				pData[playerid][AyamFillet] -= amount;
				pdgDATA[pid][pdgCocacola] += amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully deposit %d ayam fillet", amount);
			}
		}
	}
	if(dialogid == PDG_JERUK) //Jeruk
	{
		if(response)
		{
			new str[256], pid = pData[playerid][pInPdg];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pdgMenuType] = 0;
					format(str, sizeof str,"Jeruk: %d\n\nPlease Input amount to Withdraw", pdgDATA[pid][pdgJeruk]);
				}
				case 1:
				{
					pData[playerid][pdgMenuType] = 1;
					format(str, sizeof str,"Jeruk: %d\n\nPlease Input amount to Deposit", pdgDATA[pid][pdgJeruk]);
				}
			}
			ShowPlayerDialog(playerid, PDG_JERUK1, DIALOG_STYLE_INPUT, "Jeruk Menu", str, "Input","Batal");
		}
	}
	if(dialogid == PDG_JERUK1)
	{
		if(response)
		{
			new amount = strval(inputtext), pid = pData[playerid][pInPdg];
			if(pData[playerid][pdgMenuType] == 0)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah Minimal 1");

				if(pdgDATA[pid][pdgJeruk] < amount) return ErrorMsg(playerid, "Not Enough Jeruk");

				if((pdgDATA[pid][pdgJeruk] + amount) >= 10000)
					return ErrorMsg(playerid, "You've reached maximum of Jeruk");

				pData[playerid][pOrange] += amount;
				pdgDATA[pid][pdgJeruk] -= amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully withdraw %d Jeruk from Gudang", amount);
			}
			else if(pData[playerid][pdgMenuType] == 1)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah minimal 1");

				if(pData[playerid][pOrange] < amount) return ErrorMsg(playerid, "Not Enough Jeruk");

				pData[playerid][pOrange] -= amount;
				pdgDATA[pid][pdgJeruk] += amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully deposit %d Jeruk", amount);
			}
		}
	}
	if(dialogid == PDG_BURGER) //Burger
	{
		if(response)
		{
			new str[256], pid = pData[playerid][pInPdg];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pdgMenuType] = 0;
					format(str, sizeof str,"Burger: %d\n\nPlease Input amount to Withdraw", pdgDATA[pid][pdgBurger]);
				}
				case 1:
				{
					pData[playerid][pdgMenuType] = 1;
					format(str, sizeof str,"Burger: %d\n\nPlease Input amount to Deposit", pdgDATA[pid][pdgBurger]);
				}
			}
			ShowPlayerDialog(playerid, PDG_BURGER1, DIALOG_STYLE_INPUT, "Burger Menu", str, "Input","Batal");
		}
	}
	if(dialogid == PDG_BURGER1)
	{
		if(response)
		{
			new amount = strval(inputtext), pid = pData[playerid][pInPdg];
			if(pData[playerid][pdgMenuType] == 0)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah Minimal 1");

				if(pdgDATA[pid][pdgBurger] < amount) return ErrorMsg(playerid, "Not Enough Burger");

				if((pdgDATA[pid][pdgBurger] + amount) >= 10000)
					return ErrorMsg(playerid, "You've reached maximum of Burger");

				pData[playerid][pBurger] += amount;
				pdgDATA[pid][pdgBurger] -= amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully withdraw %d Burger from Gudang", amount);
			}
			else if(pData[playerid][pdgMenuType] == 1)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah minimal 1");

				if(pData[playerid][pBurger] < amount) return ErrorMsg(playerid, "Not Enough Burger");

				pData[playerid][pBurger] -= amount;
				pdgDATA[pid][pdgBurger] += amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully deposit %d Burger", amount);
			}
		}
	}
	if(dialogid == PDG_PIZZA) //Pizza
	{
		if(response)
		{
			new str[256], pid = pData[playerid][pInPdg];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pdgMenuType] = 0;
					format(str, sizeof str,"Pizza: %d\n\nPlease Input amount to Withdraw", pdgDATA[pid][pdgPizza]);
				}
				case 1:
				{
					pData[playerid][pdgMenuType] = 1;
					format(str, sizeof str,"Pizza: %d\n\nPlease Input amount to Deposit", pdgDATA[pid][pdgPizza]);
				}
			}
			ShowPlayerDialog(playerid, PDG_PIZZA1, DIALOG_STYLE_INPUT, "Pizza Menu", str, "Input","Batal");
		}
	}
	if(dialogid == PDG_PIZZA1)
	{
		if(response)
		{
			new amount = strval(inputtext), pid = pData[playerid][pInPdg];
			if(pData[playerid][pdgMenuType] == 0)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah Minimal 1");

				if(pdgDATA[pid][pdgPizza] < amount) return ErrorMsg(playerid, "Not Enough Pizza");

				if((pdgDATA[pid][pdgPizza] + amount) >= 10000)
					return ErrorMsg(playerid, "You've reached maximum of Pizza");

				pData[playerid][pPizza] += amount;
				pdgDATA[pid][pdgPizza] -= amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully withdraw %d Pizza from Gudang", amount);
			}
			else if(pData[playerid][pdgMenuType] == 1)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah minimal 1");

				if(pData[playerid][pPizza] < amount) return ErrorMsg(playerid, "Not Enough Pizza");

				pData[playerid][pPizza] -= amount;
				pdgDATA[pid][pdgPizza] += amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully deposit %d Pizza", amount);
			}
		}
	}
	if(dialogid == PDG_AYAM_FILET) //Ayam Filet
	{
		if(response)
		{
			new str[256], pid = pData[playerid][pInPdg];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pdgMenuType] = 0;
					format(str, sizeof str,"Ayam Fillet: %d\n\nPlease Input amount to Withdraw", pdgDATA[pid][pdgAyamfilet]);
				}
				case 1:
				{
					pData[playerid][pdgMenuType] = 1;
					format(str, sizeof str,"Ayam Fillet: %d\n\nPlease Input amount to Deposit", pdgDATA[pid][pdgAyamfilet]);
				}
			}
			ShowPlayerDialog(playerid, PDG_AYAM_FILET1, DIALOG_STYLE_INPUT, "Ayam Fillet Menu", str, "Input","Batal");
		}
	}
	if(dialogid == PDG_AYAM_FILET1)
	{
		if(response)
		{
			new amount = strval(inputtext), pid = pData[playerid][pInPdg];
			if(pData[playerid][pdgMenuType] == 0)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah Minimal 1");

				if(pdgDATA[pid][pdgAyamfilet] < amount) return ErrorMsg(playerid, "Not Enough Ayam Fillet");

				if((pdgDATA[pid][pdgAyamfilet] + amount) >= 10000)
					return ErrorMsg(playerid, "You've reached maximum of Ayam Fillet");

				pData[playerid][AyamFillet] += amount;
				pdgDATA[pid][pdgAyamfilet] -= amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully withdraw %d Ayam Fillet from Gudang", amount);
			}
			else if(pData[playerid][pdgMenuType] == 1)
			{
				if(amount < 1)
					return ErrorMsg(playerid, "Jumlah minimal 1");

				if(pData[playerid][AyamFillet] < amount) return ErrorMsg(playerid, "Not Enough Ayam Fillet");

				pData[playerid][AyamFillet] -= amount;
				pdgDATA[pid][pdgAyamfilet] += amount;
				Pedagang_Save(pid);
				Info(playerid, "You've successfully deposit %d Ayam Fillet", amount);
			}
		}
	}
	//[Farm]
	if(dialogid == FARM_INFO)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pFarm] == -1)
						return ErrorMsg(playerid, "You dont have farm!");
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT name,leader,potato,wheat,orange,money FROM farm WHERE ID = %d", pData[playerid][pFarm]);
					mysql_tquery(g_SQL, query, "ShowFarmInfo", "i", playerid);
				}
				case 1:
				{
					if(pData[playerid][pFarm] == -1)
						return ErrorMsg(playerid, "You dont have farm!");

					new lstr[1024];
					format(lstr, sizeof(lstr), "Rank\tName\n");
					foreach(new i: Player)
					{
						if(pData[i][pFarm] == pData[playerid][pFarm])
						{
							format(lstr, sizeof(lstr), "%s%s\t%s(%d)", lstr, GetFamilyRank(i), pData[i][pName], i);
							format(lstr, sizeof(lstr), "%s\n", lstr);
						}
					}
					format(lstr, sizeof(lstr), "%s\n", lstr);
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Farm Emplooye Online", lstr, "Tutup", "");

				}
				case 2:
				{
					if(pData[playerid][pFarm] == -1)
						return ErrorMsg(playerid, "You dont have farm!");
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT username,familyrank FROM players WHERE farm = %d", pData[playerid][pFarm]);
					mysql_tquery(g_SQL, query, "ShowFarmMember", "i", playerid);
				}
			}
		}
		return 1;
	}
	if(dialogid == FARM_STORAGE)
	{
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				//Potato
				ShowPlayerDialog(playerid, FARM_POTATO, DIALOG_STYLE_LIST, "Potato", "Withdraw from storage\nDeposit into storage", "Pilih", "Kembali");
			}
			case 1:
			{
				//Wheat
				ShowPlayerDialog(playerid, FARM_WHEAT, DIALOG_STYLE_LIST, "Wheat", "Withdraw from storage\nDeposit into storage", "Pilih", "Kembali");
			}
			case 2:
			{
				//Orange
				ShowPlayerDialog(playerid, FARM_ORANGE, DIALOG_STYLE_LIST, "Orange", "Withdraw from storage\nDeposit into storage", "Pilih", "Kembali");
			}
			case 3:
			{
				//Money
				ShowPlayerDialog(playerid, FARM_MONEY, DIALOG_STYLE_LIST, "Money", "Withdraw from storage\nDeposit into storage", "Pilih", "Kembali");
			}
		}
		return 1;
	}
	if(dialogid == FARM_POTATO)
	{
		if(response)
		{
			new fid = pData[playerid][pFarm];
			if(fid == -1) return ErrorMsg(playerid, "You don't have farm.");
			if(response)
			{
				switch (listitem)
				{
					case 0:
					{
						new str[128];
						format(str, sizeof(str), "Potato Balance: %d\n\nPlease enter how much Potato you wish to withdraw from the safe:", farmData[fid][farmPotato]);
						ShowPlayerDialog(playerid, FARM_WITHDRAWPOTATO, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
					}
					case 1:
					{
						new str[128];
						format(str, sizeof(str), "Potato Balance: %d\n\nPlease enter how much Potato you wish to deposit into the safe:", farmData[fid][farmPotato]);
						ShowPlayerDialog(playerid, FARM_DEPOSITPOTATO, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
					}
				}
			}
			else callcmd::fstorage(playerid);
		}
		return 1;
	}
	if(dialogid == FARM_WITHDRAWPOTATO)
	{
		new fid = pData[playerid][pFarm];
		if(fid == -1) return ErrorMsg(playerid, "You don't have farm.");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Potato Balance: %d\n\nPlease enter how much Potato you wish to withdraw from the safe:", farmData[fid][farmPotato]);
				ShowPlayerDialog(playerid, FARM_WITHDRAWPOTATO, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > farmData[fid][farmPotato])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nPotato Balance: %d\n\nPlease enter how much Potato you wish to withdraw from the safe:", farmData[fid][farmPotato]);
				ShowPlayerDialog(playerid, FARM_WITHDRAWPOTATO, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			farmData[fid][farmPotato] -= amount;
			pData[playerid][pPotato] += amount;

			SaveFarm(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d Potato from their farm safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fstorage(playerid);
		return 1;
	}
	if(dialogid == FARM_DEPOSITPOTATO)
	{
		new fid = pData[playerid][pFarm];
		if(fid == -1) return ErrorMsg(playerid, "You don't have farm.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Potato Balance: %d\n\nPlease enter how much Potato you wish to deposit into the safe:", farmData[fid][farmPotato]);
				ShowPlayerDialog(playerid, FARM_DEPOSITPOTATO, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pPotato])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nPotato Balance: %d\n\nPlease enter how much Potato you wish to deposit into the safe:", farmData[fid][farmPotato]);
				ShowPlayerDialog(playerid, FARM_DEPOSITPOTATO, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			farmData[fid][farmPotato] += amount;
			pData[playerid][pPotato] -= amount;

			SaveFarm(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d Potato into their farm safe.", ReturnName(playerid), amount);
		}
		else callcmd::fstorage(playerid);
		return 1;
	}
	if(dialogid == FARM_WHEAT)
	{
		if(response)
		{
			new fid = pData[playerid][pFarm];
			if(fid == -1) return ErrorMsg(playerid, "You don't have farm.");
			if(response)
			{
				switch (listitem)
				{
					case 0:
					{
						new str[128];
						format(str, sizeof(str), "Wheat Balance: %d\n\nPlease enter how much wheat you wish to withdraw from the safe:", farmData[fid][farmWheat]);
						ShowPlayerDialog(playerid, FARM_WITHDRAWWHEAT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
					}
					case 1:
					{
						new str[128];
						format(str, sizeof(str), "Wheat Balance: %d\n\nPlease enter how much wheat you wish to deposit into the safe:", farmData[fid][farmWheat]);
						ShowPlayerDialog(playerid, FARM_DEPOSITWHEAT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
					}
				}
			}
			else callcmd::fstorage(playerid);
		}
		return 1;
	}
	if(dialogid == FARM_WITHDRAWWHEAT)
	{
		new fid = pData[playerid][pFarm];
		if(fid == -1) return ErrorMsg(playerid, "You don't have farm.");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Wheat Balance: %d\n\nPlease enter how much wheat you wish to withdraw from the safe:", farmData[fid][farmWheat]);
				ShowPlayerDialog(playerid, FARM_WITHDRAWWHEAT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > farmData[fid][farmWheat])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nWheat Balance: %d\n\nPlease enter how much wheat you wish to withdraw from the safe:", farmData[fid][farmWheat]);
				ShowPlayerDialog(playerid, FARM_WITHDRAWWHEAT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			farmData[fid][farmWheat] -= amount;
			pData[playerid][pWheat] += amount;

			SaveFarm(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d wheat from their farm safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fstorage(playerid);
		return 1;
	}
	if(dialogid == FARM_DEPOSITWHEAT)
	{
		new fid = pData[playerid][pFarm];
		if(fid == -1) return ErrorMsg(playerid, "You don't have farm.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Wheat Balance: %d\n\nPlease enter how much wheat you wish to deposit into the safe:", farmData[fid][farmWheat]);
				ShowPlayerDialog(playerid, FARM_DEPOSITWHEAT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pWheat])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nWheat Balance: %d\n\nPlease enter how much wheat you wish to deposit into the safe:", farmData[fid][farmWheat]);
				ShowPlayerDialog(playerid, FARM_DEPOSITWHEAT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			farmData[fid][farmWheat] += amount;
			pData[playerid][pWheat] -= amount;

			SaveFarm(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d wheat into their farm safe.", ReturnName(playerid), amount);
		}
		else callcmd::fstorage(playerid);
		return 1;
	}
	if(dialogid == FARM_ORANGE)
	{
		if(response)
		{
			new fid = pData[playerid][pFarm];
			if(fid == -1) return ErrorMsg(playerid, "You don't have farm.");
			if(response)
			{
				switch (listitem)
				{
					case 0:
					{
						if(pData[playerid][pFarmRank] < 5)
							return ErrorMsg(playerid, "Only boss can withdraw orange!");

						new str[128];
						format(str, sizeof(str), "Orange Balance: %d\n\nPlease enter how much orange you wish to withdraw from the safe:", farmData[fid][farmOrange]);
						ShowPlayerDialog(playerid, FARM_WITHDRAWORANGE, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
					}
					case 1:
					{
						new str[128];
						format(str, sizeof(str), "Orange Balance: %d\n\nPlease enter how much orange you wish to deposit into the safe:", farmData[fid][farmOrange]);
						ShowPlayerDialog(playerid, FARM_DEPOSITORANGE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
					}
				}
			}
			else callcmd::fstorage(playerid);
		}
		return 1;
	}
	if(dialogid == FARM_WITHDRAWORANGE)
	{
		new fid = pData[playerid][pFarm];
		if(fid == -1) return ErrorMsg(playerid, "You don't have farm.");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Orange Balance: %d\n\nPlease enter how much orange you wish to withdraw from the safe:", farmData[fid][farmOrange]);
				ShowPlayerDialog(playerid, FARM_WITHDRAWORANGE, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > farmData[fid][farmOrange])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nOrange Balance: %d\n\nPlease enter how much orange you wish to withdraw from the safe:", farmData[fid][farmOrange]);
				ShowPlayerDialog(playerid, FARM_WITHDRAWORANGE, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			farmData[fid][farmOrange] -= amount;
			pData[playerid][pOrange] += amount;

			SaveFarm(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d orange from their farm safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fstorage(playerid);
		return 1;
	}
	if(dialogid == FARM_DEPOSITORANGE)
	{
		new fid = pData[playerid][pFarm];
		if(fid == -1) return ErrorMsg(playerid, "You don't have farm.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Orange Balance: %d\n\nPlease enter how much orange you wish to deposit into the safe:", farmData[fid][farmOrange]);
				ShowPlayerDialog(playerid, FARM_DEPOSITORANGE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pOrange])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nOrange Balance: %d\n\nPlease enter how much orange you wish to deposit into the safe:", farmData[fid][farmOrange]);
				ShowPlayerDialog(playerid, FARM_DEPOSITORANGE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			farmData[fid][farmOrange] += amount;
			pData[playerid][pOrange] -= amount;

			SaveFarm(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d orange into their farm safe.", ReturnName(playerid), amount);
		}
		else callcmd::fstorage(playerid);
		return 1;
	}
	if(dialogid == FARM_MONEY)
	{
		if(response)
		{
			new fid = pData[playerid][pFarm];
			if(fid == -1) return ErrorMsg(playerid, "You don't have farm.");
			if(response)
			{
				switch (listitem)
				{
					case 0:
					{
						if(pData[playerid][pFarmRank] < 5)
							return ErrorMsg(playerid, "Only boss can withdraw money!");

						new str[128];
						format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(farmData[fid][farmMoney]));
						ShowPlayerDialog(playerid, FARM_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
					}
					case 1:
					{
						new str[128];
						format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(farmData[fid][farmMoney]));
						ShowPlayerDialog(playerid, FARM_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
					}
				}
			}
			else callcmd::fstorage(playerid);
		}
		return 1;
	}
	if(dialogid == FARM_WITHDRAWMONEY)
	{
		new fid = pData[playerid][pFarm];
		if(fid == -1) return ErrorMsg(playerid, "You don't have farm.");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(farmData[fid][farmMoney]));
				ShowPlayerDialog(playerid, FARM_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > farmData[fid][farmMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMoney Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(farmData[fid][farmMoney]));
				ShowPlayerDialog(playerid, FARM_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Kembali");
				return 1;
			}
			farmData[fid][farmMoney] -= amount;
			GivePlayerMoneyEx(playerid, amount);

			SaveFarm(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s money from their farm safe.", ReturnName(playerid), FormatMoney(amount));
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fstorage(playerid);
		return 1;
	}
	if(dialogid == FARM_DEPOSITMONEY)
	{
		new fid = pData[playerid][pFarm];
		if(fid == -1) return ErrorMsg(playerid, "Anda tidak memiliki farm.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(farmData[fid][farmMoney]));
				ShowPlayerDialog(playerid, FARM_DEPOSITORANGE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			if(amount < 1 || amount > GetPlayerMoney(playerid))
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMoney Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(farmData[fid][farmMoney]));
				ShowPlayerDialog(playerid, FARM_DEPOSITORANGE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Kembali");
				return 1;
			}
			farmData[fid][farmMoney] += amount;
			GivePlayerMoneyEx(playerid, -amount);

			SaveFarm(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s money into their farm safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else callcmd::fstorage(playerid);
		return 1;
	}
	if(dialogid == DIALOG_MODTOY)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					new x = pData[playerid][VehicleID];
					pvData[x][vtoySelected] = 0;
					if(vtData[x][0][vtoy_modelid] == 0)
					{

					}
					else
					{
						// new string[512];
						// format(string, sizeof(string), "Remove Vehicle Toys\nShow/Hide Vehicle Toys\nShare Position Vehicle Toys\nEdit Pos Vehicle Toys");
						// format(string, sizeof(string), ""dot""GREY_E"Edit Toy Position(Andoid & Pc)\n"dot"Remove Object\n"dot"Show/Hide Object\n"dot"Change Colour\n"dot"Share Position\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						// vtData[x][pvData[x][vtoySelected]][vtoy_x], vtData[x][pvData[x][vtoySelected]][vtoy_y], vtData[x][pvData[x][vtoySelected]][vtoy_z],
						// vtData[x][pvData[x][vtoySelected]][vtoy_rx], vtData[x][pvData[x][vtoySelected]][vtoy_ry], vtData[x][pvData[x][vtoySelected]][vtoy_rz]);
						ShowPlayerDialog(playerid, DIALOG_MODTEDIT, DIALOG_STYLE_LIST, ""RED_E"Executive Roleplay "WHITE_E"Vehicle Toys", "Remove Vehicle Toys\nShow/Hide Vehicle Toys\nShare Position Vehicle Toys\nEdit Pos Vehicle Toys", "Pilih", "Batal");
					}
				}
				case 1: //slot 2
				{
					new x = pData[playerid][VehicleID];
					pvData[x][vtoySelected] = 1;
					if(vtData[x][1][vtoy_modelid] == 0)
					{

					}
					else
					{
						// new string[512];
						// format(string, sizeof(string), ""dot""GREY_E"Edit Toy Position(Andoid & Pc)\n"dot"Remove Object\n"dot"Show/Hide Object\n"dot"Change Colour\n"dot"Share Position\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						// vtData[x][pvData[x][vtoySelected]][vtoy_x], vtData[x][pvData[x][vtoySelected]][vtoy_y], vtData[x][pvData[x][vtoySelected]][vtoy_z],
						// vtData[x][pvData[x][vtoySelected]][vtoy_rx], vtData[x][pvData[x][vtoySelected]][vtoy_ry], vtData[x][pvData[x][vtoySelected]][vtoy_rz]);
						//ShowPlayerDialog(playerid, DIALOG_MODTEDIT, DIALOG_STYLE_LIST, ""RED_E"Executive Roleplay "WHITE_E"Vehicle Toys", string, "Pilih", "Batal");
						ShowPlayerDialog(playerid, DIALOG_MODTEDIT, DIALOG_STYLE_LIST, ""RED_E"Executive Roleplay "WHITE_E"Vehicle Toys", "Remove Vehicle Toys\nShow/Hide Vehicle Toys\nShare Position Vehicle Toys\nEdit Pos Vehicle Toys", "Pilih", "Batal");
					}
				}
				case 2: //slot 3
				{
					new x = pData[playerid][VehicleID];
					pvData[x][vtoySelected] = 2;
					if(vtData[x][2][vtoy_modelid] == 0)
					{

					}
					else
					{
						// new string[512];
						// format(string, sizeof(string), ""dot""GREY_E"Edit Toy Position(Andoid & Pc)\n"dot"Remove Object\n"dot"Show/Hide Object\n"dot"Change Colour\n"dot"Share Position\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						// vtData[x][pvData[x][vtoySelected]][vtoy_x], vtData[x][pvData[x][vtoySelected]][vtoy_y], vtData[x][pvData[x][vtoySelected]][vtoy_z],
						// vtData[x][pvData[x][vtoySelected]][vtoy_rx], vtData[x][pvData[x][vtoySelected]][vtoy_ry], vtData[x][pvData[x][vtoySelected]][vtoy_rz]);
						// ShowPlayerDialog(playerid, DIALOG_MODTEDIT, DIALOG_STYLE_LIST, ""RED_E"Executive Roleplay "WHITE_E"Vehicle Toys", string, "Pilih", "Batal");
						ShowPlayerDialog(playerid, DIALOG_MODTEDIT, DIALOG_STYLE_LIST, ""RED_E"Executive Roleplay "WHITE_E"Vehicle Toys", "Remove Vehicle Toys\nShow/Hide Vehicle Toys\nShare Position Vehicle Toys\nEdit Pos Vehicle Toys", "Pilih", "Batal");
					}
				}
				case 3: //slot 4
				{
					new x = pData[playerid][VehicleID];
					pvData[x][vtoySelected] = 3;
					if(vtData[x][3][vtoy_modelid] == 0)
					{

					}
					else
					{
						// new string[512];
						// format(string, sizeof(string), ""dot""GREY_E"Edit Toy Position(Andoid & Pc)\n"dot"Remove Object\n"dot"Show/Hide Object\n"dot"Change Colour\n"dot"Share Position\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						// vtData[x][pvData[x][vtoySelected]][vtoy_x], vtData[x][pvData[x][vtoySelected]][vtoy_y], vtData[x][pvData[x][vtoySelected]][vtoy_z],
						// vtData[x][pvData[x][vtoySelected]][vtoy_rx], vtData[x][pvData[x][vtoySelected]][vtoy_ry], vtData[x][pvData[x][vtoySelected]][vtoy_rz]);
						// ShowPlayerDialog(playerid, DIALOG_MODTEDIT, DIALOG_STYLE_LIST, ""RED_E"Executive Roleplay "WHITE_E"Vehicle Toys", string, "Pilih", "Batal");
						ShowPlayerDialog(playerid, DIALOG_MODTEDIT, DIALOG_STYLE_LIST, ""RED_E"Executive Roleplay "WHITE_E"Vehicle Toys", "Remove Vehicle Toys\nShow/Hide Vehicle Toys\nShare Position Vehicle Toys\nEdit Pos Vehicle Toys", "Pilih", "Batal");
					}
				}
				case 4:
				{
					new x = pData[playerid][VehicleID];
					if(pvData[x][PurchasedvToy] == true)
					{
						for(new i = 0; i < 4; i++)
						{
							vtData[x][i][vtoy_modelid] = 0;
							vtData[x][i][vtoy_x] = 0.0;
							vtData[x][i][vtoy_y] = 0.0;
							vtData[x][i][vtoy_z] = 0.0;
							vtData[x][i][vtoy_rx] = 0.0;
							vtData[x][i][vtoy_ry] = 0.0;
							vtData[x][i][vtoy_rz] = 0.0;
							DestroyObject(vtData[x][i][vtoy_model]);
						}
						new string[128];
						mysql_format(g_SQL, string, sizeof(string), "DELETE FROM vtoys WHERE Owner = '%d'", pvData[x][cID]);
						mysql_tquery(g_SQL, string);
						pvData[x][PurchasedvToy] = false;

						GameTextForPlayer(playerid, "~r~~h~All Toy Rested!~y~!", 3000, 4);
					}
				}
				case 5:
				{
					new vehid = pData[playerid][VehicleID];
					for(new i = 0; i < 4; i++)
					{
						new Float:vPosx, Float:vPosy, Float:vPosz;
						DestroyObject(vtData[vehid][i][vtoy_model]);
						GetVehiclePos(pData[playerid][VehicleID], vPosx, vPosy, vPosz);

						vtData[vehid][0][vtoy_model] = CreateObject(vtData[vehid][i][vtoy_modelid], vPosx, vPosy, vPosz, 0.0, 0.0, 0.0);
						AttachObjectToVehicle(vtData[vehid][i][vtoy_model],
						vehid,
						vtData[vehid][i][vtoy_x],
						vtData[vehid][i][vtoy_y],
						vtData[vehid][i][vtoy_z],
						vtData[vehid][i][vtoy_rx],
						vtData[vehid][i][vtoy_ry],
						vtData[vehid][i][vtoy_rz]);
					}
					GameTextForPlayer(playerid, "~r~~h~Refresh All Object!~y~!", 3000, 4);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_MODTBUY)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					new x = pData[playerid][VehicleID];
					pvData[x][vtoySelected] = 0;
					if(vtData[x][0][vtoy_modelid] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_MODTEDIT, DIALOG_STYLE_LIST, ""RED_E"Executive Roleplay "WHITE_E"Vehicle Toys", ""dot"Edit Toy Position\n"dot""GREY_E"Remove Toy", "Pilih", "Batal");
					}
				}
				case 1: //slot 2
				{
					new x = pData[playerid][VehicleID];
					pvData[x][vtoySelected] = 1;
					if(vtData[x][1][vtoy_modelid] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_MODTEDIT, DIALOG_STYLE_LIST, ""RED_E"Executive Roleplay "WHITE_E"Vehicle Toys", ""dot"Edit Toy Position\n"dot""GREY_E"Remove Toy", "Pilih", "Batal");
					}
				}
				case 2: //slot 3
				{
					new x = pData[playerid][VehicleID];
					pvData[x][vtoySelected] = 2;
					if(vtData[x][2][vtoy_modelid] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_MODTEDIT, DIALOG_STYLE_LIST, ""RED_E"Executive Roleplay "WHITE_E"Vehicle Toys", ""dot"Edit Toy Position\n"dot""GREY_E"Remove Toy", "Pilih", "Batal");
					}
				}
				case 3: //slot 4
				{
					new x = pData[playerid][VehicleID];
					pvData[x][vtoySelected] = 3;
					if(vtData[x][3][vtoy_modelid] == 0)
					{
						ShowModelSelectionMenu(playerid, viptoyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_MODTEDIT, DIALOG_STYLE_LIST, ""RED_E"Executive Roleplay "WHITE_E"Vehicle Toys", ""dot"Edit Toy Position\n"dot""GREY_E"Remove Toy", "Pilih", "Batal");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_MODTEDIT) 	//ShowPlayerDialog("Remove Vehicle Toys\nShow/Hide Vehicle Toys\nShare Position Vehicle Toys\nEdit Pos Vehicle Toys", "Pilih", "Batal");
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: 	// Remove Veh Toys
				{
					new vehid = pData[playerid][VehicleID];
		    		foreach(new i: PVehicles)
					{
						if(vehid == pvData[i][cVeh])
						{
			    			new vehid1 = pvData[i][cVeh];
			    			new toyslotid = pvData[vehid1][vtoySelected];
							vtData[vehid1][toyslotid][vtoy_modelid] = 0;
							DestroyObject(vtData[vehid1][toyslotid][vtoy_model]);
							GameTextForPlayer(playerid, "~r~~h~Vehicle Toy Removed_~y~!", 3000, 4);
							TogglePlayerControllable(playerid, true);
							MySQL_SaveVehicleToys(i);
						}
		    		}	
				}
				case 1: 	// Show/Hide Veh Toys
				{
					new vehid = pData[playerid][VehicleID];
					new toyslotid = pvData[vehid][vtoySelected];
					if(IsValidObject(vtData[vehid][toyslotid][vtoy_model]))
					{
						DestroyObject(vtData[vehid][toyslotid][vtoy_model]);
						GameTextForPlayer(playerid, "~r~~h~Object Hide~y~!", 3000, 4);
					}
					else
					{
					    vtData[vehid][toyslotid][vtoy_model] = CreateObject(vtData[vehid][toyslotid][vtoy_modelid], 0.0, 0.0, -14.0, 0.0, 0.0, 0.0);
						AttachObjectToVehicle(vtData[vehid][toyslotid][vtoy_model],
						vehid,
						vtData[vehid][toyslotid][vtoy_x],
						vtData[vehid][toyslotid][vtoy_y],
						vtData[vehid][toyslotid][vtoy_z],
						vtData[vehid][toyslotid][vtoy_rx],
						vtData[vehid][toyslotid][vtoy_ry],
						vtData[vehid][toyslotid][vtoy_rz]);
						GameTextForPlayer(playerid, "~r~~h~Object Show~y~!", 3000, 4);
					}					
				}
				case 2: 	// Share Pos Veh Toys
				{
					new vehid = pData[playerid][VehicleID];
					new toyslotid = pvData[vehid][vtoySelected];
					SendNearbyMessage(playerid, 10.0, COLOR_GREEN, "[VTOY BY %s] "WHITE_E"PosX: %.3f | PosY: %.3f | PosZ: %.3f | PosRX: %.3f | PosRY: %.3f | PosRZ: %.3f",
					ReturnName(playerid), vtData[vehid][toyslotid][vtoy_x], vtData[vehid][toyslotid][vtoy_y], vtData[vehid][toyslotid][vtoy_z],
					vtData[vehid][toyslotid][vtoy_rx], vtData[vehid][toyslotid][vtoy_ry], vtData[vehid][toyslotid][vtoy_rz]);
				}
				case 3:
				{
					new vehid = pData[playerid][VehicleID];
					new toyslotid = pvData[vehid][vtoySelected];

					new str[256]; 	// DIALOG_MODTSETPOS
					format(str, sizeof str, "Pos vToys X: %f\nPos vToys Y: %f\nPos vToys Z: %f\nPos vToys RX: %f\nPos vToys RY: %f\nPos vToys RZ: %f\n",
					vtData[vehid][toyslotid][vtoy_x], vtData[vehid][toyslotid][vtoy_y], vtData[vehid][toyslotid][vtoy_z],
					vtData[vehid][toyslotid][vtoy_rx], vtData[vehid][toyslotid][vtoy_ry], vtData[vehid][toyslotid][vtoy_rz]);
					ShowPlayerDialog(playerid, DIALOG_MODTSETPOS, DIALOG_STYLE_LIST, "Edit Position Veh Toys", str, "Edit", "Batal");
				}
				// case 0: // edit
				// {
				// 	Info(playerid,"Fungsi ini untuk mengatur berapa jumlah float pos +/- untuk sekali click pada textdraw.");
				// 	ShowPlayerDialog(playerid, DIALOG_MODTSETVALUE, DIALOG_STYLE_INPUT, "Vehicle Toy PosX", "Set current float value\nNormal Value = 0.05\n\nEnter Float NudgeValue in here:", "Pilih", "Kembali");
				// }
				// case 1: // remove toy
				// {
				// 	new vehid = GetPlayerVehicleID(playerid);
		  //   		foreach(new i: PVehicles)
				// 	{
				// 		if(vehid == pvData[i][cVeh])
				// 		{
		  //   				new x = pvData[i][cVeh];
				// 			vtData[x][pvData[x][vtoySelected]][vtoy_modelid] = 0;
				// 			DestroyObject(vtData[x][pvData[x][vtoySelected]][vtoy_model]);
				// 			GameTextForPlayer(playerid, "~r~~h~Vehicle Toy Removed_~y~!", 3000, 4);
				// 			TogglePlayerControllable(playerid, true);
				// 			MySQL_SaveVehicleToys(i);
		  //   			}
		  //   		}
				// }
				// case 2:	//hide/show
				// {
				// 	new vehid = pData[playerid][VehicleID];
				// 	if(IsValidObject(vtData[vehid][pvData[vehid][vtoySelected]][vtoy_model]))
				// 	{
				// 		DestroyObject(vtData[vehid][pvData[vehid][vtoySelected]][vtoy_model]);
				// 		GameTextForPlayer(playerid, "~r~~h~Object Hide~y~!", 3000, 4);
				// 	}
				// 	else
				// 	{
				// 	    vtData[vehid][pvData[vehid][vtoySelected]][vtoy_model] = CreateObject(vtData[vehid][pvData[vehid][vtoySelected]][vtoy_modelid], 0.0, 0.0, -14.0, 0.0, 0.0, 0.0);
				// 		AttachObjectToVehicle(vtData[vehid][pvData[vehid][vtoySelected]][vtoy_model],
				// 		vehid,
				// 		vtData[vehid][pvData[vehid][vtoySelected]][vtoy_x],
				// 		vtData[vehid][pvData[vehid][vtoySelected]][vtoy_y],
				// 		vtData[vehid][pvData[vehid][vtoySelected]][vtoy_z],
				// 		vtData[vehid][pvData[vehid][vtoySelected]][vtoy_rx],
				// 		vtData[vehid][pvData[vehid][vtoySelected]][vtoy_ry],
				// 		vtData[vehid][pvData[vehid][vtoySelected]][vtoy_rz]);
				// 		GameTextForPlayer(playerid, "~r~~h~Object Show~y~!", 3000, 4);
				// 	}
				// }
				// case 3:	//change toy colour
				// {
				// 	Servers(playerid,"Fungsi ini belum permanent");
				// 	ShowPlayerDialog(playerid, DIALOG_MODTSETCOLOUR, DIALOG_STYLE_LIST, "Select Object Colour", "White\nBlack\nRed\nBlue\nYellow", "Pilih", "Kembali");
				// }
				// case 4:	//share toy pos
				// {
				// 	new x = pData[playerid][VehicleID];
				// 	SendNearbyMessage(playerid, 10.0, COLOR_GREEN, "[VTOY BY %s] "WHITE_E"PosX: %.3f | PosY: %.3f | PosZ: %.3f | PosRX: %.3f | PosRY: %.3f | PosRZ: %.3f",
				// 	ReturnName(playerid), vtData[x][pvData[x][vtoySelected]][vtoy_x], vtData[x][pvData[x][vtoySelected]][vtoy_y], vtData[x][pvData[x][vtoySelected]][vtoy_z],
				// 	vtData[x][pvData[x][vtoySelected]][vtoy_rx], vtData[x][pvData[x][vtoySelected]][vtoy_ry], vtData[x][pvData[x][vtoySelected]][vtoy_rz]);
				// }
				// case 5: //Pos X
				// {
				// 	new x = pData[playerid][VehicleID];
				// 	new mstr[128];
				// 	format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosX: %f\nInput new Toy PosX:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_x]);
				// 	ShowPlayerDialog(playerid, DIALOG_MODTPOSX, DIALOG_STYLE_INPUT, "vehicle Toy PosX", mstr, "Edit", "Batal");
				// }
				// case 6: //Pos Y
				// {
				// 	new x = pData[playerid][VehicleID];
				// 	new mstr[128];
				// 	format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosY: %f\nInput new Toy PosY:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_y]);
				// 	ShowPlayerDialog(playerid, DIALOG_MODTPOSY, DIALOG_STYLE_INPUT, "vehicle Toy PosY", mstr, "Edit", "Batal");
				// }
				// case 7: //Pos Z
				// {
				// 	new x = pData[playerid][VehicleID];
				// 	new mstr[128];
				// 	format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosZ: %f\nInput new Toy PosZ:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_z]);
				// 	ShowPlayerDialog(playerid, DIALOG_MODTPOSZ, DIALOG_STYLE_INPUT, "vehicle Toy PosZ", mstr, "Edit", "Batal");
				// }
				// case 8: //Pos RX
				// {
				// 	new x = pData[playerid][VehicleID];
				// 	new mstr[128];
				// 	format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosRX: %f\nInput new Toy PosRX:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_rx]);
				// 	ShowPlayerDialog(playerid, DIALOG_MODTPOSRX, DIALOG_STYLE_INPUT, "vehicle Toy PosRX", mstr, "Edit", "Batal");
				// }
				// case 9: //Pos RY
				// {
				// 	new x = pData[playerid][VehicleID];
				// 	new mstr[128];
				// 	format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosRY: %f\nInput new Toy PosRY:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_ry]);
				// 	ShowPlayerDialog(playerid, DIALOG_MODTPOSRY, DIALOG_STYLE_INPUT, "Toy PosRY", mstr, "Edit", "Batal");
				// }
				// case 10: //Pos RZ
				// {
				// 	new x = pData[playerid][VehicleID];
				// 	new mstr[128];
				// 	format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosRZ: %f\nInput new Toy PosRZ:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_rz]);
				// 	ShowPlayerDialog(playerid, DIALOG_MODTPOSRZ, DIALOG_STYLE_INPUT, "Toy PosRZ", mstr, "Edit", "Batal");
				// }
			}
		} else callcmd::vtoys(playerid);
		return 1;
	}
	if(dialogid == DIALOG_MODTACCEPT)
	{
		if(response)
		{
			new x = GetPlayerVehicleID(playerid);
			foreach(new i: PVehicles)
			{
				if(x == pvData[i][cVeh])
				{
					MySQL_SaveVehicleToys(i);
					pvData[pvData[i][cVeh]][PurchasedvToy] = true;
					Servers(playerid, "Succes Save This Object");
				}
			}
		}
		else
		{
			new vehid = GetPlayerVehicleID(playerid);
    		foreach(new i: PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
    				new x = pvData[i][cVeh];
					vtData[x][pvData[x][vtoySelected]][vtoy_modelid] = 0;
					DestroyObject(vtData[x][pvData[x][vtoySelected]][vtoy_model]);
					GameTextForPlayer(playerid, "~r~~h~Vehicle Toy Removed_~y~!", 3000, 4);
					pvData[pvData[i][cVeh]][PurchasedvToy] = true;
    			}
    		}
		}
	}
	if(dialogid == DIALOG_MODTSETVALUE)
	{
		if(response)
		{
			if(isnull(inputtext))
			{
				NudgeVal[playerid] = 0.05;
				ShowPlayerDialog(playerid, DIALOG_MODTSELECTPOS, DIALOG_STYLE_LIST, "Select Editing Pos", "Position X\nPosition Y\nPosition Z\nPosition RX\nPosition RY\nPosition RZ", "Pilih", "Kembali");
			}
			else
			{
				NudgeVal[playerid] = floatstr(inputtext);
				ShowPlayerDialog(playerid, DIALOG_MODTSELECTPOS, DIALOG_STYLE_LIST, "Select Editing Pos", "Position X\nPosition Y\nPosition Z\nPosition RX\nPosition RY\nPosition RZ", "Pilih", "Kembali");
			}
		}
	}
	if(dialogid == DIALOG_MODTSETCOLOUR)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //White
				{
					new x = pData[playerid][VehicleID];
					SetObjectMaterial(vtData[x][pvData[x][vtoySelected]][vtoy_model], 0, 18955, "Jester", "wall6", 0xFFFFFFAA);
					Servers(playerid, "Anda Telah berhasil mengubah warna object ke Putih");
					//SCM(playerid, 0xFFFFFFAA, "White");
				}
				case 1: //Black
				{
					new x = pData[playerid][VehicleID];
					SetObjectMaterial(vtData[x][pvData[x][vtoySelected]][vtoy_model], 0, 18955, "Jester", "wall6", 0xFF000000);
					Servers(playerid, "Anda Telah berhasil mengubah warna object ke {ff0000}Hitam");
					//SCM(playerid, 0xFF000000, "Black");
				}
				case 2: //Red
				{
					new x = pData[playerid][VehicleID];
					SetObjectMaterial(vtData[x][pvData[x][vtoySelected]][vtoy_model], 0, 18955, "Jester", "wall6", 0xFF0000FF);
					Servers(playerid, "Anda Telah berhasil mengubah warna object ke {ff0000}Merah");
					//SCM(playerid, 0xFF0000FF, "Red");
				}
				case 3: //Blue
				{
					new x = pData[playerid][VehicleID];
					SetObjectMaterial(vtData[x][pvData[x][vtoySelected]][vtoy_model], 0, 18955, "Jester", "wall6", 0x004BFFFF);
					Servers(playerid, "Anda Telah berhasil mengubah warna object ke {004bff}Biru");
					//SCM(playerid, 0x004BFFFF, "Blue");
				}
				case 4: //Yellow
				{
					new x = pData[playerid][VehicleID];
					SetObjectMaterial(vtData[x][pvData[x][vtoySelected]][vtoy_model], 0, 18955, "Jester", "wall6", 0xFFFF00FF);
					Servers(playerid, "Anda Telah berhasil mengubah warna object ke {ff00ff}Kuning");
					//SCM(playerid, 0xFFFF00FF, "Yellow");
				}
			}
		}
	}
	if(dialogid == DIALOG_MODTSELECTPOS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //Pos X
				{
					pData[playerid][EditStatus] = FloatX;
					ShowEditVehicleTD(playerid);
					Servers(playerid, "You are now editing vehicle toys position 'X', one click to add %f", NudgeVal[playerid]);
				}
				case 1: //Pos Y
				{
					pData[playerid][EditStatus] = FloatY;
					ShowEditVehicleTD(playerid);
					Servers(playerid, "You are now editing vehicle toys position 'Y', one click to add %f", NudgeVal[playerid]);
				}
				case 2: //Pos Z
				{
					pData[playerid][EditStatus] = FloatZ;
					ShowEditVehicleTD(playerid);
					Servers(playerid, "You are now editing vehicle toys position 'Z', one click to add %f", NudgeVal[playerid]);
				}
				case 3: //Pos RX
				{
					pData[playerid][EditStatus] = FloatRX;
					ShowEditVehicleTD(playerid);
					Servers(playerid, "You are now editing vehicle toys position 'RX', one click to add %f", NudgeVal[playerid]);
				}
				case 4: //Pos RY
				{
					pData[playerid][EditStatus] = FloatRY;
					ShowEditVehicleTD(playerid);
					Servers(playerid, "You are now editing vehicle toys position 'RY', one click to add %f", NudgeVal[playerid]);
				}
				case 5: //Pos RZ
				{
					pData[playerid][EditStatus] = FloatRZ;
					ShowEditVehicleTD(playerid);
					Servers(playerid, "You are now editing vehicle toys position 'RZ', one click to add %f", NudgeVal[playerid]);
				}
			}
		}
	}
	if(dialogid == DIALOG_MODTPOSX)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext), vehid = pData[playerid][VehicleID], idxs = pvData[pData[playerid][VehicleID]][vtoySelected];

			AttachObjectToVehicle(vtData[vehid][idxs][vtoy_model],
			vehid,
			posisi,
			vtData[vehid][idxs][vtoy_y],
			vtData[vehid][idxs][vtoy_z],
			vtData[vehid][idxs][vtoy_rx],
			vtData[vehid][idxs][vtoy_ry],
			vtData[vehid][idxs][vtoy_rz]);

			vtData[vehid][idxs][vtoy_x] = posisi;
			new x = GetPlayerVehicleID(playerid);
			foreach(new i: PVehicles)
			{
				if(x == pvData[i][cVeh])
				{
					MySQL_SaveVehicleToys(i);
				}
			}

			new toyslotid = pvData[x][vtoySelected];

			new str[256];
			format(str, sizeof str, "Pos vToys X: %f\nPos vToys Y: %f\nPos vToys Z: %f\nPos vToys RX: %f\nPos vToys RY: %f\nPos vToys RZ: %f\n",
			vtData[x][toyslotid][vtoy_x], vtData[x][toyslotid][vtoy_y], vtData[x][toyslotid][vtoy_z],
			vtData[x][toyslotid][vtoy_rx], vtData[x][toyslotid][vtoy_ry], vtData[x][toyslotid][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_MODTSETPOS, DIALOG_STYLE_LIST, "Edit Position Veh Toys", str, "Edit", "Batal");
		}
		else
		{
			new vehid = GetPlayerVehicleID(playerid);
			new toyslotid = pvData[vehid][vtoySelected];

			new str[256];
			format(str, sizeof str, "Pos vToys X: %f\nPos vToys Y: %f\nPos vToys Z: %f\nPos vToys RX: %f\nPos vToys RY: %f\nPos vToys RZ: %f\n",
			vtData[vehid][toyslotid][vtoy_x], vtData[vehid][toyslotid][vtoy_y], vtData[vehid][toyslotid][vtoy_z],
			vtData[vehid][toyslotid][vtoy_rx], vtData[vehid][toyslotid][vtoy_ry], vtData[vehid][toyslotid][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_MODTSETPOS, DIALOG_STYLE_LIST, "Edit Position Veh Toys", str, "Edit", "Batal");
		}
	}
	if(dialogid == DIALOG_MODTPOSY)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext), vehid = pData[playerid][VehicleID], idxs = pvData[vehid][vtoySelected];

			AttachObjectToVehicle(vtData[vehid][idxs][vtoy_model],
			vehid,
			vtData[vehid][idxs][vtoy_x],
			posisi,
			vtData[vehid][idxs][vtoy_z],
			vtData[vehid][idxs][vtoy_rx],
			vtData[vehid][idxs][vtoy_ry],
			vtData[vehid][idxs][vtoy_rz]);

			vtData[vehid][idxs][vtoy_y] = posisi;
			new x = GetPlayerVehicleID(playerid);
			foreach(new i: PVehicles)
			{
				if(x == pvData[i][cVeh])
				{
					MySQL_SaveVehicleToys(i);
				}
			}

			new toyslotid = pvData[x][vtoySelected];

			new str[256];
			format(str, sizeof str, "Pos vToys X: %f\nPos vToys Y: %f\nPos vToys Z: %f\nPos vToys RX: %f\nPos vToys RY: %f\nPos vToys RZ: %f\n",
			vtData[x][toyslotid][vtoy_x], vtData[x][toyslotid][vtoy_y], vtData[x][toyslotid][vtoy_z],
			vtData[x][toyslotid][vtoy_rx], vtData[x][toyslotid][vtoy_ry], vtData[x][toyslotid][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_MODTSETPOS, DIALOG_STYLE_LIST, "Edit Position Veh Toys", str, "Edit", "Batal");
		}
		else
		{
			new vehid = GetPlayerVehicleID(playerid);
			new toyslotid = pvData[vehid][vtoySelected];

			new str[256];
			format(str, sizeof str, "Pos vToys X: %f\nPos vToys Y: %f\nPos vToys Z: %f\nPos vToys RX: %f\nPos vToys RY: %f\nPos vToys RZ: %f\n",
			vtData[vehid][toyslotid][vtoy_x], vtData[vehid][toyslotid][vtoy_y], vtData[vehid][toyslotid][vtoy_z],
			vtData[vehid][toyslotid][vtoy_rx], vtData[vehid][toyslotid][vtoy_ry], vtData[vehid][toyslotid][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_MODTSETPOS, DIALOG_STYLE_LIST, "Edit Position Veh Toys", str, "Edit", "Batal");
		}		
	}
	if(dialogid == DIALOG_MODTPOSZ)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext), vehid = pData[playerid][VehicleID], idxs = pvData[pData[playerid][VehicleID]][vtoySelected];

			AttachObjectToVehicle(vtData[vehid][idxs][vtoy_model],
			vehid,
			vtData[vehid][idxs][vtoy_x],
			vtData[vehid][idxs][vtoy_y],
			posisi,
			vtData[vehid][idxs][vtoy_rx],
			vtData[vehid][idxs][vtoy_ry],
			vtData[vehid][idxs][vtoy_rz]);

			vtData[vehid][idxs][vtoy_z] = posisi;
			new x = GetPlayerVehicleID(playerid);
			foreach(new i: PVehicles)
			{
				if(x == pvData[i][cVeh])
				{
					MySQL_SaveVehicleToys(i);
				}
			}

			new toyslotid = pvData[x][vtoySelected];

			new str[256];
			format(str, sizeof str, "Pos vToys X: %f\nPos vToys Y: %f\nPos vToys Z: %f\nPos vToys RX: %f\nPos vToys RY: %f\nPos vToys RZ: %f\n",
			vtData[x][toyslotid][vtoy_x], vtData[x][toyslotid][vtoy_y], vtData[x][toyslotid][vtoy_z],
			vtData[x][toyslotid][vtoy_rx], vtData[x][toyslotid][vtoy_ry], vtData[x][toyslotid][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_MODTSETPOS, DIALOG_STYLE_LIST, "Edit Position Veh Toys", str, "Edit", "Batal");
		}
		else
		{
			new vehid = GetPlayerVehicleID(playerid);
			new toyslotid = pvData[vehid][vtoySelected];

			new str[256];
			format(str, sizeof str, "Pos vToys X: %f\nPos vToys Y: %f\nPos vToys Z: %f\nPos vToys RX: %f\nPos vToys RY: %f\nPos vToys RZ: %f\n",
			vtData[vehid][toyslotid][vtoy_x], vtData[vehid][toyslotid][vtoy_y], vtData[vehid][toyslotid][vtoy_z],
			vtData[vehid][toyslotid][vtoy_rx], vtData[vehid][toyslotid][vtoy_ry], vtData[vehid][toyslotid][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_MODTSETPOS, DIALOG_STYLE_LIST, "Edit Position Veh Toys", str, "Edit", "Batal");
		}
	}
	if(dialogid == DIALOG_MODTPOSRX)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext), vehid = pData[playerid][VehicleID], idxs = pvData[pData[playerid][VehicleID]][vtoySelected];

			AttachObjectToVehicle(vtData[vehid][idxs][vtoy_model],
			vehid,
			vtData[vehid][idxs][vtoy_x],
			vtData[vehid][idxs][vtoy_y],
			vtData[vehid][idxs][vtoy_z],
			posisi,
			vtData[vehid][idxs][vtoy_ry],
			vtData[vehid][idxs][vtoy_rz]);

			vtData[vehid][idxs][vtoy_rx] = posisi;
			new x = GetPlayerVehicleID(playerid);
			foreach(new i: PVehicles)
			{
				if(x == pvData[i][cVeh])
				{
					MySQL_SaveVehicleToys(i);
				}
			}

			new toyslotid = pvData[x][vtoySelected];

			new str[256];
			format(str, sizeof str, "Pos vToys X: %f\nPos vToys Y: %f\nPos vToys Z: %f\nPos vToys RX: %f\nPos vToys RY: %f\nPos vToys RZ: %f\n",
			vtData[x][toyslotid][vtoy_x], vtData[x][toyslotid][vtoy_y], vtData[x][toyslotid][vtoy_z],
			vtData[x][toyslotid][vtoy_rx], vtData[x][toyslotid][vtoy_ry], vtData[x][toyslotid][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_MODTSETPOS, DIALOG_STYLE_LIST, "Edit Position Veh Toys", str, "Edit", "Batal");
		}
		else
		{
			new vehid = GetPlayerVehicleID(playerid);
			new toyslotid = pvData[vehid][vtoySelected];

			new str[256];
			format(str, sizeof str, "Pos vToys X: %f\nPos vToys Y: %f\nPos vToys Z: %f\nPos vToys RX: %f\nPos vToys RY: %f\nPos vToys RZ: %f\n",
			vtData[vehid][toyslotid][vtoy_x], vtData[vehid][toyslotid][vtoy_y], vtData[vehid][toyslotid][vtoy_z],
			vtData[vehid][toyslotid][vtoy_rx], vtData[vehid][toyslotid][vtoy_ry], vtData[vehid][toyslotid][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_MODTSETPOS, DIALOG_STYLE_LIST, "Edit Position Veh Toys", str, "Edit", "Batal");
		}
    }
	if(dialogid == DIALOG_MODTPOSRY)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext), vehid = pData[playerid][VehicleID], idxs = pvData[pData[playerid][VehicleID]][vtoySelected];

			AttachObjectToVehicle(vtData[vehid][idxs][vtoy_model],
			vehid,
			vtData[vehid][idxs][vtoy_x],
			vtData[vehid][idxs][vtoy_y],
			vtData[vehid][idxs][vtoy_z],
			vtData[vehid][idxs][vtoy_rx],
			posisi,
			vtData[vehid][idxs][vtoy_rz]);

			vtData[vehid][idxs][vtoy_ry] = posisi;
			new x = GetPlayerVehicleID(playerid);
			foreach(new i: PVehicles)
			{
				if(x == pvData[i][cVeh])
				{
					MySQL_SaveVehicleToys(i);
				}
			}

			new toyslotid = pvData[x][vtoySelected];

			new str[256];
			format(str, sizeof str, "Pos vToys X: %f\nPos vToys Y: %f\nPos vToys Z: %f\nPos vToys RX: %f\nPos vToys RY: %f\nPos vToys RZ: %f\n",
			vtData[x][toyslotid][vtoy_x], vtData[x][toyslotid][vtoy_y], vtData[x][toyslotid][vtoy_z],
			vtData[x][toyslotid][vtoy_rx], vtData[x][toyslotid][vtoy_ry], vtData[x][toyslotid][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_MODTSETPOS, DIALOG_STYLE_LIST, "Edit Position Veh Toys", str, "Edit", "Batal");
		}
		else
		{
			new vehid = GetPlayerVehicleID(playerid);
			new toyslotid = pvData[vehid][vtoySelected];

			new str[256];
			format(str, sizeof str, "Pos vToys X: %f\nPos vToys Y: %f\nPos vToys Z: %f\nPos vToys RX: %f\nPos vToys RY: %f\nPos vToys RZ: %f\n",
			vtData[vehid][toyslotid][vtoy_x], vtData[vehid][toyslotid][vtoy_y], vtData[vehid][toyslotid][vtoy_z],
			vtData[vehid][toyslotid][vtoy_rx], vtData[vehid][toyslotid][vtoy_ry], vtData[vehid][toyslotid][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_MODTSETPOS, DIALOG_STYLE_LIST, "Edit Position Veh Toys", str, "Edit", "Batal");
		}
	}
	if(dialogid == DIALOG_MODTPOSRZ)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext), vehid = pData[playerid][VehicleID], idxs = pvData[pData[playerid][VehicleID]][vtoySelected];

			AttachObjectToVehicle(vtData[vehid][idxs][vtoy_model],
			vehid,
			vtData[vehid][idxs][vtoy_x],
			vtData[vehid][idxs][vtoy_y],
			vtData[vehid][idxs][vtoy_z],
			vtData[vehid][idxs][vtoy_rx],
			vtData[vehid][idxs][vtoy_ry],
			posisi);

			vtData[vehid][idxs][vtoy_rz] = posisi;
			new x = GetPlayerVehicleID(playerid);
			foreach(new i: PVehicles)
			{
				if(x == pvData[i][cVeh])
				{
					MySQL_SaveVehicleToys(i);
				}
			}

			new toyslotid = pvData[x][vtoySelected];

			new str[256];
			format(str, sizeof str, "Pos vToys X: %f\nPos vToys Y: %f\nPos vToys Z: %f\nPos vToys RX: %f\nPos vToys RY: %f\nPos vToys RZ: %f\n",
			vtData[x][toyslotid][vtoy_x], vtData[x][toyslotid][vtoy_y], vtData[x][toyslotid][vtoy_z],
			vtData[x][toyslotid][vtoy_rx], vtData[x][toyslotid][vtoy_ry], vtData[x][toyslotid][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_MODTSETPOS, DIALOG_STYLE_LIST, "Edit Position Veh Toys", str, "Edit", "Batal");
		}
		else
		{
			new vehid = GetPlayerVehicleID(playerid);
			new toyslotid = pvData[vehid][vtoySelected];

			new str[256];
			format(str, sizeof str, "Pos vToys X: %f\nPos vToys Y: %f\nPos vToys Z: %f\nPos vToys RX: %f\nPos vToys RY: %f\nPos vToys RZ: %f\n",
			vtData[vehid][toyslotid][vtoy_x], vtData[vehid][toyslotid][vtoy_y], vtData[vehid][toyslotid][vtoy_z],
			vtData[vehid][toyslotid][vtoy_rx], vtData[vehid][toyslotid][vtoy_ry], vtData[vehid][toyslotid][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_MODTSETPOS, DIALOG_STYLE_LIST, "Edit Position Veh Toys", str, "Edit", "Batal");
		}
	}
	if(dialogid == DIALOG_MODTSETPOS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //Pos X
				{
					new x = pData[playerid][VehicleID];
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosX: %f\nInput new Toy PosX:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_x]);
					ShowPlayerDialog(playerid, DIALOG_MODTPOSX, DIALOG_STYLE_INPUT, "vehicle Toy PosX", mstr, "Edit", "Batal");
				}
				case 1: //Pos Y
				{
					new x = pData[playerid][VehicleID];
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosY: %f\nInput new Toy PosY:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_y]);
					ShowPlayerDialog(playerid, DIALOG_MODTPOSY, DIALOG_STYLE_INPUT, "vehicle Toy PosY", mstr, "Edit", "Batal");
				}
				case 2: //Pos Z
				{
					new x = pData[playerid][VehicleID];
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosZ: %f\nInput new Toy PosZ:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_z]);
					ShowPlayerDialog(playerid, DIALOG_MODTPOSZ, DIALOG_STYLE_INPUT, "vehicle Toy PosZ", mstr, "Edit", "Batal");
				}
				case 3: //Pos RX
				{
					new x = pData[playerid][VehicleID];
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosRX: %f\nInput new Toy PosRX:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_rx]);
					ShowPlayerDialog(playerid, DIALOG_MODTPOSRX, DIALOG_STYLE_INPUT, "vehicle Toy PosRX", mstr, "Edit", "Batal");
				}
				case 4: //Pos RY
				{
					new x = pData[playerid][VehicleID];
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosRY: %f\nInput new Toy PosRY:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_ry]);
					ShowPlayerDialog(playerid, DIALOG_MODTPOSRY, DIALOG_STYLE_INPUT, "Toy PosRY", mstr, "Edit", "Batal");
				}
				case 5: //Pos RZ
				{
					new x = pData[playerid][VehicleID];
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosRZ: %f\nInput new Toy PosRZ:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_rz]);
					ShowPlayerDialog(playerid, DIALOG_MODTPOSRZ, DIALOG_STYLE_INPUT, "Toy PosRZ", mstr, "Edit", "Batal");
				}				
			}
		} else ShowPlayerDialog(playerid, DIALOG_MODTEDIT, DIALOG_STYLE_LIST, ""RED_E"Executive Roleplay "WHITE_E"Vehicle Toys", "Remove Vehicle Toys\nShow/Hide Vehicle Toys\nShare Position Vehicle Toys\nEdit Pos Vehicle Toys", "Pilih", "Batal");
	}
	if(dialogid == DIALOG_BENSIN)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					foreach(new gsid : GStation)
					{
						if(IsPlayerInRangeOfPoint(playerid, 1.0, gsData[gsid][gsPosX], gsData[gsid][gsPosY], gsData[gsid][gsPosZ]))
						{
							new veh = pData[playerid][pFillVeh];

							if(GetVehicleFuel(veh) == 100)
								return ErrorMsg(playerid, "Bensin di kendaraan anda sudah penuh");

							if(pData[playerid][pGrabFuel] == true)
								return ErrorMsg(playerid, "Anda sudah memegang Nozzle");

							if(pData[playerid][pFillStatus] == 1)
								return ErrorMsg(playerid, "Anda sedang mengisi bahan bakar, mohon ditunggu!");

							if(pData[playerid][pFillCapOpen] == 0)
								return ErrorMsg(playerid, "Tanki belum terbuka, /bukatanki untuk membuka");

							if(gsData[gsid][gsStock] < 1)
								return ErrorMsg(playerid, "Pom bensin tidak mempunyai stok!");

							new str[128];
							pData[playerid][pGrabFuel] = true;
							pData[playerid][pFill] = gsid;
							pData[playerid][pFillCp] = true;
							SetPlayerCheckpoint(playerid, pData[playerid][pCapX], pData[playerid][pCapY], pData[playerid][pCapZ], 2.0);
							SetPlayerAttachedObject(playerid, 9, 19621, 6, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
							InfoMsg(playerid, "Silahkan ke Checkpoint");
						}
					}
				}
				case 1:
				{
					callcmd::belijerigen(playerid, "");
				}
			}
		}
	}
	if(dialogid == DIALOG_ISIBENSIN)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new value = amount * GasOilPrice;
			if(amount < 0 || amount > 100) return ErrorMsg(playerid, "Maximal 100");
			if(GetPlayerMoney(playerid) < value) return ErrorMsg(playerid, "Uang anda kurang.");
			if(GasOil < amount) return ErrorMsg(playerid, "Bensin dalam SPBU tidak mencukupi.");
			ShowProgressbar(playerid, "Mengisi Bensin..", 10);
			pData[playerid][pFillStatus] = 1;
			ApplyAnimation(playerid, "SAMP", "FishingIdle", 4.1, 0, 0, 0, 1, 0, 1);
			SetTimerEx("MengisiBensin", 10000, false, "dddd", playerid, amount, value, pData[playerid][pFillVeh]);
		}
	}
    return 1;
}
