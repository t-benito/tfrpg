#include <sourcemod>

#include "database.sp"
#include "player.sp"
#include "json/item.sp"
#include "json/entity.sp"

#pragma semicolon 1
#pragma newdecls required

public void RPG_PluginStart() {
	LogMessage("rpg time");

	DB_PluginStart();
	Items_PluginStart();
	Entities_PluginStart();
}

public void RPG_ClientPutInServer(int client) {
	DB_ClientPutInServer(client);
}

public void RPG_ClientDisconnect(int client) {
	DB_ClientDisconnect(client);
}