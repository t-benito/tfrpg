#pragma semicolon 1
#pragma newdecls required

// assumed from SM_Path
#define ITEMS_PATH = "configs/rpg_data/items.json"

public void Items_PluginStart()
{
	char path[PLATFORM_MAX_PATH]
	BuildPath(SM_Path, path, sizeof(path), ITEMS_PATH);
}