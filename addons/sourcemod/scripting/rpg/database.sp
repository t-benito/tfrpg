#pragma semicolon 1
#pragma newdecls required

// assumed start from Path_SM
#define SAVE_PATH "data/rpg_store.cfg"

#include "player.sp"

KeyValues g_kvDatabase = null;

char g_sPath[PLATFORM_MAX_PATH];

public void DB_PluginStart()
{
	g_kvDatabase = new KeyValues("savedata");
	
	BuildPath(Path_SM, g_sPath, sizeof(g_sPath), SAVE_PATH);
	
	if (!g_kvDatabase.ImportFromFile(g_sPath))
	{
		g_kvDatabase.ExportToFile(g_sPath);
	}
}

public void DB_ClientPutInServer(int client)
{
	if (IsFakeClient(client))
		return;
	
	char steamid[32];
	if (!GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid)))
		return;
		
	if (g_kvDatabase.JumpToKey(steamid))
	{
		g_iCredits[client] = g_kvDatabase.GetNum("credits");
		
		g_kvDatabase.Rewind();
	}
	else
	{ // default values
		g_iCredits[client] = 0;
	}
}	

public void DB_ClientDisconnect(int client)
{
	if (IsFakeClient(client))
		return;
		
	char steamid[32];
	if (!GetClientAuthId(client, AuthId_Steam2, steamid, sizeof(steamid)))
		return;
		
	if (g_kvDatabase.JumpToKey(steamid, true))
	{
		g_kvDatabase.SetNum("credits", g_iCredits[client]);
		g_kvDatabase.Rewind();
		
		g_kvDatabase.ExportToFile(g_sPath);
	}
}