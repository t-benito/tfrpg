#pragma semicolon 1
#pragma newdecls required

// assumed from Path_SM
#define ITEMS_PATH "configs/rpg_data/items.json"

#include <rpg/json>

enum ItemType {
	ARMOR,
	CONSUMABLE,
}

enum ItemSubtype {
	PANTS,
	CHEST,
	HELMET,
}

enum ItemFlags (<<= 1) {
	UNTRADEABLE,
}

public StringMap g_smItems = null;

public void Items_PluginStart() {
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), ITEMS_PATH);
	
	if (!FileExists(path)) {
		SetFailState("items cant initialize, the given file (%s) doesnt exist", path);
		return;
	}
	
	File file = OpenFile(path, "r");
	if (file == null)return;
	
	char content[8192];
	file.ReadString(content, sizeof(content));
	delete file;

	g_smItems = new StringMap();
	
	JSON_Object root = json_decode(content);
	for (int i = 0; i < root.Length; i++) {
		char key[64];
		obj.GetKey(i, key, sizeof(key));

		JSON_Object item = root.GetObject(key);
		if (item == null) {
			SetFailState("item at %d in items.json is not an object", i);
			return;
		}

		char typebuf[32];
		item.GetString("type", typebuf, sizeof(typebuf));
		if (typebuf[0] == '\0') {
			SetFailState("item at %d doesnt have a type field", i);
			return;
		}

		char subtypebuf[32];
		item.GetString("subtype", subtypebuf, sizeof(subtypebuf));
		if (subtypebuf[0] == '\0') {
			SetFailState("item at %d doesnt have a subtype field", i)
			return;
		}

		ItemType type = GetType(typebuf); 
		ItemSubtype subtype = GetSubtype(subtypebuf);
		if (type == null || subtype == null) {
			SetFailState("item at %d has wrong type or sub type", i);
			return;
		}

		char name[64];
		item.GetString("name", name, sizeof(name));
		if (name == null) {
			SetFailState("item at %d doesnt have a name field", i);
			return;
		} // these are alot of fail states...

		switch (type) {
			case ARMOR: {
				
			}
			case CONSUMABLE: {
				
			}
		}
	}
	json_cleanup_and_delete(root);
	
	if (g_hItems == null) {
		char err[64];
		json_get_last_error(err, sizeof(err));
		SetFailState("failed parsing items.json: %s", err);
	}
}

ItemType GetType(const char[] typebuf) {
	if (StrEqual(typebuf, "armor")) return ItemType.ARMOR;
	if (StrEqual(typebuf, "consumable")) return ItemType.CONSUMABLE;
	
	return null;
}

ItemSubtype GetSubtype(const char[] stypebuf) {
	if (StrEqual(stypebuf, "pants")) return ItemSubtype.PANTS;
	if (StrEqual(stypebuf, "chest")) return ItemSubtype.CHEST;
	if (StrEqual(stypebuf, "helmet")) return ItemSubtype.HELMET;

	return null;
}