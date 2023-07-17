#define MAX_CONTACTS 10
enum contactData {
	contactID,
	contactExists,
	contactName[32],
	contactNumber
};
new ContactData[MAX_PLAYERS][MAX_CONTACTS][contactData];
new ListedContacts[MAX_PLAYERS][MAX_CONTACTS];
stock ShowContacts(playerid)
{
	new
	    string[32 * MAX_CONTACTS],
		count = 0, status[500];

	string = ""YELLOW_E"Tambahkan Kontak\n";

	for (new i = 0; i != MAX_CONTACTS; i ++) if (ContactData[playerid][i][contactExists])
	{
	    if(IsPlayerConnected(i))
		{
			status = ""LG_E"(Online)";
		}
		else
		{
			status = ""RED_E"(Offline)";
		}
	    format(string, sizeof(string), "%s%s | %d %s\n", string, ContactData[playerid][i][contactName], ContactData[playerid][i][contactNumber], status);
		ListedContacts[playerid][count++] = i;
	}
	SimpanHp(playerid);
	ShowPlayerDialog(playerid, DIALOG_PHONE_CONTACT, DIALOG_STYLE_LIST, "Executive - Daftar Kontak", string, "Pilih", "Kembali");
	return 1;
}
forward OnContactAdd(playerid, id);
public OnContactAdd(playerid, id)
{
	ContactData[playerid][id][contactID] = cache_insert_id();
	return 1;
}
function LoadContact(playerid)
{
    new cname[50];
	new count = cache_num_rows();
	if(count)
  	{
		for (new i = 0; i < count && i < MAX_CONTACTS; i ++)
		{
			cache_get_value_name(i, "contactName", cname);
			format(ContactData[playerid][i][contactName], 50, "%s", cname);
			ContactData[playerid][i][contactExists] = true;
		    cache_get_value_name_int(i, "contactID", ContactData[playerid][i][contactID]);
		    cache_get_value_name_int(i, "contactNumber", ContactData[playerid][i][contactNumber]);
		}
	}
}

CMD:peri(playerid, params[])
{
	ShowContacts(playerid);
}
