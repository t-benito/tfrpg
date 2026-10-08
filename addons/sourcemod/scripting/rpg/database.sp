#pragma semicolon 1
#pragma newdecls required

// assumed start from Path_SM
#define SAVE_PATH "data/rpg_store.cfg"

#include "player.sp"

KeyValues g_kvDatabase = null;

char g_sPath[PLATFORM_MAX_PATH];

public void DB_PluginStart() {
	g_kvDatabase = new KeyValues("savedata");
	
	BuildPath(Path_SM, g_sPath, sizeof(g_sPath), SAVE_PATH);
	
	if (!g_kvDatabase.ImportFromFile(g_sPath)) {
		g_kvDatabase.ExportToFile(g_sPath);
	}
}

public void DB_ClientPutInServer(int client) {
	if (IsFakeClient(client))
		return;
	
	char steamid[32];
	if (!GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid)))
		return;
	
	Player player = Player_Get(client);
	if (g_kvDatabase.JumpToKey(steamid)) {
		player.Credits = g_kvDatabase.GetNum("credits");
		player.XP = g_kvDatabase.GetNum("xp");
		player.Level = g_kvDatabase.GetNum("lvl");
		// todo : skills loading
		
		g_kvDatabase.Rewind();
	}
	else { // default values
		player.Zero();
	}
}	

public void DB_ClientDisconnect(int client) {
	if (IsFakeClient(client))
		return;
		
	char steamid[32];
	if (!GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid)))
		return;
		
	if (g_kvDatabase.JumpToKey(steamid, true)) {
		g_kvDatabase.SetNum("credits", g_iCredits[client]);
		g_kvDatabase.SetNum("xp", g_iXP[client]);
		g_kvDatabase.SetNum("lvl", g_iLevel[client]);
		g_kvDatabase.Rewind();
		
		g_kvDatabase.ExportToFile(g_sPath);
	}
}