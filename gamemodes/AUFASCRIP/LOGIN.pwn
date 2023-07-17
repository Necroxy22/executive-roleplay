#include <YSI\y_hooks>
#include <YSI\y_timers>

hook OnPlayerConnect(playerid) { 

        defer NongolSebelumLogin(playerid);
        for(new i = 0; i < 5; i++)
		{
			TextDrawShowForPlayer(playerid, Aufalogin[i]);
		}
           return 1;
	}
	timer NongolSebelumLogin[5000](playerid) {
        for(new i = 0; i < 5; i++)
		{
			TextDrawHideForPlayer(playerid, Aufalogin[i]);
		}
           return 1;
}