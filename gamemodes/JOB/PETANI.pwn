enum E_PETANI
{
    STREAMER_TAG_MAP_ICON:NanamMap,
	STREAMER_TAG_CP:NanamTani,
	STREAMER_TAG_MAP_ICON:LockerMap,
	STREAMER_TAG_CP:LockerTani,
	STREAMER_TAG_CP:NanamLagi,
	STREAMER_TAG_CP:NanamJuga,
	STREAMER_TAG_CP:NanamAja,
	STREAMER_TAG_CP:PembuatanJadiApa,
	STREAMER_TAG_CP:PembuatanJadiApaMap
}
new PetaniArea[MAX_PLAYERS][E_PETANI];

DeletePetaniCP(playerid)
{
    if(IsValidDynamicCP(PetaniArea[playerid][LockerTani]))
	{
		DestroyDynamicCP(PetaniArea[playerid][LockerTani]);
		PetaniArea[playerid][LockerTani] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PetaniArea[playerid][NanamTani]))
	{
		DestroyDynamicCP(PetaniArea[playerid][NanamTani]);
		PetaniArea[playerid][NanamTani] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PetaniArea[playerid][NanamLagi]))
	{
		DestroyDynamicCP(PetaniArea[playerid][NanamLagi]);
		PetaniArea[playerid][NanamLagi] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PetaniArea[playerid][NanamJuga]))
	{
		DestroyDynamicCP(PetaniArea[playerid][NanamJuga]);
		PetaniArea[playerid][NanamJuga] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicCP(PetaniArea[playerid][PembuatanJadiApa]))
	{
		DestroyDynamicCP(PetaniArea[playerid][PembuatanJadiApa]);
		PetaniArea[playerid][PembuatanJadiApa] = STREAMER_TAG_CP: -1;
	}
	if(IsValidDynamicMapIcon(PetaniArea[playerid][PembuatanJadiApaMap]))
	{
		DestroyDynamicMapIcon(PetaniArea[playerid][PembuatanJadiApaMap]);
		PetaniArea[playerid][PembuatanJadiApaMap] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicMapIcon(PetaniArea[playerid][NanamMap]))
	{
		DestroyDynamicMapIcon(PetaniArea[playerid][NanamMap]);
		PetaniArea[playerid][NanamMap] = STREAMER_TAG_MAP_ICON: -1;
	}
	if(IsValidDynamicMapIcon(PetaniArea[playerid][LockerMap]))
	{
		DestroyDynamicMapIcon(PetaniArea[playerid][LockerMap]);
		PetaniArea[playerid][LockerMap] = STREAMER_TAG_MAP_ICON: -1;
	}
}

RefreshJobTani(playerid)
{
	DeletePetaniCP(playerid);
	if(pData[playerid][pJob] == 7)
	{
	    PetaniArea[playerid][LockerTani] = CreateDynamicCP(-1060.852172,-1195.437011,129.664138, 2.0, -1, -1, playerid, 30.0);
		PetaniArea[playerid][LockerMap] = CreateDynamicMapIcon(-1060.852172,-1195.437011,129.664138, 11, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
		PetaniArea[playerid][PembuatanJadiApa] = CreateDynamicCP(-1431.233398,-1460.474975,101.693000, 2.0, -1, -1, playerid, 30.0);
		PetaniArea[playerid][PembuatanJadiApaMap] = CreateDynamicMapIcon(-1431.233398,-1460.474975,101.693000, 11, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
		PetaniArea[playerid][NanamTani] = CreateDynamicCP(-1141.685791,-1095.497192,129.218750, 2.0, -1, -1, playerid, 30.0);
		PetaniArea[playerid][NanamLagi] = CreateDynamicCP(-1129.279663,-1095.668579,129.218750, 2.0, -1, -1, playerid, 30.0);
   		PetaniArea[playerid][NanamJuga] = CreateDynamicCP(-1125.371826,-1084.356811,129.218750, 2.0, -1, -1, playerid, 30.0);
   		PetaniArea[playerid][NanamAja] = CreateDynamicCP(-1138.143554,-1084.205688,129.218750, 2.0, -1, -1, playerid, 30.0);
		PetaniArea[playerid][NanamMap] = CreateDynamicMapIcon(-1138.143554,-1084.205688,129.218750, 11, 0, -1, -1, playerid, 99999.0, MAPICON_GLOBAL);
	}
	return 1;
}

function NanamPadi(playerid)
{
	pData[playerid][pPadiOlahan] += 5;
	ShowItemBox(playerid, "Padi", "Received_5x", 2901, 2);
}
function NanamCabai(playerid)
{
    pData[playerid][pCabaiOlahan] += 5;
    ShowItemBox(playerid, "Cabai", "Received_5x", 2901, 2);
}
function NanamJagung(playerid)
{
    pData[playerid][pJagungOlahan] += 5;
    ShowItemBox(playerid, "Jagung", "Received_5x", 2901, 2);
}
function NanamTebu(playerid)
{
    pData[playerid][pTebuOlahan] += 5;
    ShowItemBox(playerid, "Tebu", "Received_5x", 2901, 2);
}
function ProsesPadi(playerid)
{
	pData[playerid][pBeras] += 5;
	ShowItemBox(playerid, "Beras", "Received_5x", 19638, 2);
}
function ProsesCabai(playerid)
{
    pData[playerid][pSambal] += 5;
    ShowItemBox(playerid, "Sambal", "Received_5x", 19636, 2);
}
function ProsesJagung(playerid)
{
    pData[playerid][pTepung] += 5;
    ShowItemBox(playerid, "Tepung", "Received_5x", 19570, 2);
}
function ProsesTebu(playerid)
{
    pData[playerid][pGula] += 5;
    ShowItemBox(playerid, "Gula", "Received_5x", 19824, 2);
}
CMD:belibibitAufa(playerid, params[])
{
    if(pData[playerid][pJob] == 7)
	{
		if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
		ShowPlayerDialog(playerid, DIALOG_BELIBIBIT, DIALOG_STYLE_TABLIST_HEADERS, "Petani - Pembelian Bibit", "Jenis Bibit\tHarga\nPadi\t-> $4\nCabai\t-> $1\nJagung\t-> $3\nTebu\t-> $2", "Pilih", "Tutup");
	}
	return 1;
}

CMD:plantAufa(playerid, params[])
{
    if(pData[playerid][pJob] == 7)
	{
		if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
		ShowPlayerDialog(playerid, DIALOG_NANAMBIBIT, DIALOG_STYLE_TABLIST_HEADERS, "Petani - Menanam Bibit", "Jenis Bibit\tWaktu\nPadi\t-> 10 detik\nCabai\t-> 5 detik\nJagung\t-> 8 detik\nTebu\t-> 6 detik", "Pilih", "Tutup");
	}
	return 1;
}

CMD:prosesAufa(playerid, params[])
{
    if(pData[playerid][pJob] == 7)
	{
		if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
		ShowPlayerDialog(playerid, DIALOG_PROSESTANI, DIALOG_STYLE_TABLIST_HEADERS, "Petani - Proses", "Nama\tBahan\nBeras\t-> 5 Padi\nSambal\t-> 5 Cabai\nTepung\t-> 5 Jagung\nGula\t-> 5 Tebu", "Pilih", "Tutup");
	}
	return 1;
}

CMD:jualberasAufa(playerid, params[])
{
    new total = pData[playerid][pBeras];
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if(pData[playerid][pBeras] < 5) return ErrorMsg(playerid, "Anda Tidak Memiliki 1 Paket Beras");
    ShowProgressbar(playerid, "Menjual Beras..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pBeras] * 3;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pBeras] -= total;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, 4);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Beras", str, 19638, 4);
    Inventory_Update(playerid);
	return 1;
}

CMD:jualsambalAufa(playerid, params[])
{
    new total = pData[playerid][pSambal];
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if(pData[playerid][pSambal] < 5) return ErrorMsg(playerid, "Anda Tidak Memiliki 1 Paket sambal Sambal");
    ShowProgressbar(playerid, "Menjual Sambal..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pSambal] * 2;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pSambal] -= total;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, 4);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Sambal", str, 19636, 4);
    Inventory_Update(playerid);
	return 1;
}
CMD:jualtepungAufa(playerid, params[])
{
    new total = pData[playerid][pTepung];
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if(pData[playerid][pTepung] < 5) return ErrorMsg(playerid, "Anda Tidak Memiliki 1 Paket Tepung");
    ShowProgressbar(playerid, "Menjual Tepung..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pTepung] * 2;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pTepung] -= total;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, 4);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Tepung", str, 19570, 4);
    Inventory_Update(playerid);
	return 1;
}
CMD:jualgulaAufa(playerid, params[])
{
    new total = pData[playerid][pGula];
    if(pData[playerid][pProgress] == 1) return ErrorMsg(playerid, "Anda masih memiliki activity progress!");
    if(pData[playerid][pGula] < 5) return ErrorMsg(playerid, "Anda Tidak Memiliki 1 paket Gula");
    ShowProgressbar(playerid, "Menjual Gula..", 10);
	ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);
	new pay = pData[playerid][pGula] * 2;
	GivePlayerMoneyEx(playerid, pay);
	pData[playerid][pGula] -= total;
	new str[500];
	format(str, sizeof(str), "Received_%dx", pay);
	ShowItemBox(playerid, "Uang", str, 1212, 4);
	format(str, sizeof(str), "Removed_%dx", total);
	ShowItemBox(playerid, "Gula", str, 19824, 4);
    Inventory_Update(playerid);
	return 1;
}
