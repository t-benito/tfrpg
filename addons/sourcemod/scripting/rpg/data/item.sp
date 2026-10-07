#pragma semicolon 1
#pragma newdecls required

// assumed from Path_SM
#define ITEMS_PATH "configs/rpg_data/items.json"
#define MAX_FLAGS 3

#include "../../include/rpg/json.inc" // this is ugly but my vs code doesnt accept it otherwise

enum ItemType {
	TYPE_NONE,
	TYPE_ARMOR,
	TYPE_CONSUMABLE,
}

enum ItemSubtype {
	SUBTYPE_NONE,
	SUBTYPE_PANTS,
	SUBTYPE_CHEST,
	SUBTYPE_HELMET,
}

enum ItemFlags {
	FLAG_NONE = 0,
	FLAG_UNTRADEABLE = 1,
	FLAG_UNSELLABLE = 2,
}

methodmap Item < StringMap {
	public Item() {
		return view_as<Item>(new StringMap());
	}
	
	public void GetName(char[] buf, int maxlen) {
		this.GetString("name", buf, maxlen);
	}

	property ItemType Type {
		public get() {
			int v;
			this.GetValue("type", v);
			return view_as<ItemType>(v);
		}
	}
	property ItemSubtype Subtype {
		public get() {
			int v;
			this.GetValue("subtype", v);
			return view_as<ItemSubtype>(v);
		}
	}
	property ItemFlags Flags {
		public get() {
			int v;
			this.GetValue("flags", v);
			return view_as<ItemFlags>(v);
		}
	}
	property Handle Data {
		public get() {
			Handle h;
			this.GetValue("data", h);
			return h;
		}
	}
}

methodmap ConsumableData < ArrayList {
	public ConsumableData() {
		return view_as<ConsumableData>(new ArrayList(1, 1));
	}
	property int Heal {
		public get() {
			return this.Get(0);
		}
		public set(int val) {
			this.Set(0, val);
		}
	}
}

public StringMap g_smItems = null;

public void Items_PluginStart() {
	char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), ITEMS_PATH);
	
	if (!FileExists(path)) {
		SetFailState("items cant initialize, the given file (%s) doesnt exist", path);
	}
	
	File file = OpenFile(path, "r");
	if (file == null)return;
	
	char content[1024 * 256]; // 256kb
	file.ReadString(content, sizeof(content));
	delete file;

	g_smItems = new StringMap();
	
	JSON_Object root = json_decode(content);
	if (root == null) {
		SetFailState("failed to decode items.json");
	}
	for (int i = 0; i < root.Length; i += 1) {
		char key[64];
		root.GetKey(i, key, sizeof(key));

		if (key[0] == '\0' || root.GetHidden(key) || root.GetType(key) == JSON_Type_Invalid) {
			continue; // eh
		}

		JSON_Object item = root.GetObject(key);
		if (item == null) {
			continue;
		}

		char typebuf[32];
		item.GetString("type", typebuf, sizeof(typebuf));
		if (typebuf[0] == '\0') {
			SetFailState("item %s at %d doesnt have a type field", key, i);
		}

		char subtypebuf[32];
		item.GetString("subtype", subtypebuf, sizeof(subtypebuf));
		if (subtypebuf[0] == '\0') {
			strcopy(subtypebuf, sizeof(subtypebuf), "");
		}

		ItemFlags flags = FLAG_NONE;
		JSON_Object oflags = item.GetObject("flags");
		if (oflags != null) {
			for (int j = 0; j < MAX_FLAGS; j++) {
				char flag[64];
				oflags.GetKey(j, flag, sizeof(flag));

				ItemFlags iflag = GetFlag(flag);
				flags <<= iflag;
			}
		}
		
		ItemType type = GetType(typebuf); 
		ItemSubtype subtype = GetSubtype(subtypebuf);
		if (type == TYPE_NONE) {
			SetFailState("item %s at %d has wrong type ", key, i);
		}

		char name[64];
		item.GetString("name", name, sizeof(name));
		if (name[0] == '\0') {
			SetFailState("item %s at %d doesnt have a name field", key, i);
		} // these are alot of fail states...

		Item itemr = new Item();
		itemr.SetString("name", name);
		itemr.SetValue("type", view_as<int>(type));
		itemr.SetValue("subtype", view_as<int>(subtype));
		itemr.SetValue("flags", view_as<int>(flags));

		switch (type) {
			case TYPE_ARMOR: {
				// do some stuff with stats here im gtoo lazy
				// like a loop.. or something
				// perhaps make a modular system so i could use it
				// with weapons later aswell? hm
				// todo 
				// still todo btw
			}
			case TYPE_CONSUMABLE: {
				int heal = item.HasKey("heal") ? item.GetInt("heal") : 0;

				ConsumableData data = new ConsumableData();
				data.Heal = heal;

				itemr.SetValue("data", data);
			}
		}
		g_smItems.SetValue(key, itemr);

		LogMessage("parsed item '%s'", name);
	}
	json_cleanup_and_delete(root);
	
	if (g_smItems == null) {
		char err[64];
		json_get_last_error(err, sizeof(err));
		SetFailState("failed parsing items.json: %s", err);
	}
}

ItemType GetType(const char[] typebuf) {
	if (StrEqual(typebuf, "armor")) return TYPE_ARMOR;
	if (StrEqual(typebuf, "consumable")) return TYPE_CONSUMABLE;
	
	return TYPE_NONE;
}

ItemSubtype GetSubtype(const char[] stypebuf) {
	if (StrEqual(stypebuf, "pants")) return SUBTYPE_PANTS;
	if (StrEqual(stypebuf, "chest")) return SUBTYPE_CHEST;
	if (StrEqual(stypebuf, "helmet")) return SUBTYPE_HELMET;

	return SUBTYPE_NONE;
}

ItemFlags GetFlag(const char[] flagbuf) {
	if (StrEqual(flagbuf, "untradeable")) return FLAG_UNTRADEABLE;
	if (StrEqual(flagbuf, "unsellable")) return FLAG_UNSELLABLE;

	return FLAG_NONE;
}