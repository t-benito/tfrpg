#pragma semicolon 1
#pragma newdecls required

// start from Path_SM
#define ENTITIES_PATH "configs/rpg_data/entities.json"
#define MAX_DROPS 3

#include "../../include/rpg/json.inc"

methodmap EntityDrop < StringMap {
    public EntityDrop() {
        return view_as<EntityDrop>(new StringMap());
    }
    public void GetName(char[] buf, int maxlen) {
        this.GetString("name", buf, maxlen);
    }
    property float Chance {
        public get() {
            float v;
            this.GetValue("chance", v);
            return v;
        }
    }
}

methodmap EntitySpawn < StringMap {
    public EntitySpawn() {
        return view_as<EntitySpawn>(new StringMap());
    }
    public void GetName(char[] buf, int maxlen) {
        this.GetString("name", buf, maxlen);
    }
    public EntityDrop[] GetDrops() {
        EntityDrop buf[MAX_DROPS];
        this.GetArray("drops", buf, sizeof(buf));
        return buf;
    }
    property int MinHP {
        public get() {
            int v;
            this.GetValue("min_hp", v);
            return v;
        }
    }
    property int MaxHP {
        public get() {
            int v;
            this.GetValue("max_hp", v);
            return v;
        }
    }
    property int MinXP {
        public get() {
            int v;
            this.GetValue("min_xp", v);
            return v;
        }
    }
    property int MaxXP {
        public get() {
            int v;
            this.GetValue("max_xp", v);
            return v;
        }
    }
}

StringMap g_smEntities = null;

public void Entities_PluginStart() {
    char path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, path, sizeof(path), ENTITIES_PATH);
	
	if (!FileExists(path)) {
		SetFailState("entities cant initialize, the given file (%s) doesnt exist", path);
	}
	
	File file = OpenFile(path, "r");
	if (file == null)return;
	
	char content[1024 * 256]; // 256kb
	file.ReadString(content, sizeof(content));
	delete file;

	g_smEntities = new StringMap();
	
	JSON_Object root = json_decode(content);
	if (root == null) {
		SetFailState("failed to decode entities.json");
	}
	for (int i = 0; i < root.Length; i += 1) {
        char key[64];
		root.GetKey(i, key, sizeof(key));

		if (key[0] == '\0' || root.GetHidden(key) || root.GetType(key) == JSON_Type_Invalid) {
			continue;
		}

		JSON_Object item = root.GetObject(key);
		if (item == null) {
			continue;
		}

        char name[64];
        item.GetString("name", name, sizeof(name));
        if (name[0] == '\0') {
            SetFailState("%s: no name", key);
        }

        float respawn_time = item.GetFloat("respawn_time");
        if (respawn_time == 0.0) {
            SetFailState("%s: respawn time either odsnt exist or is at zero, and i dont know which one is worse.",key);
        }

        JSON_Object health = item.GetObject("health");
        if (health == null) {
            SetFailState("%s: doesnt have health", key);
        }

        float min_hp = health.GetFloat("min");
        float max_hp = health.GetFloat("max");

        JSON_Object xp = item.GetObject("xp");
        if (health == null) {
            SetFailState("%s: doesnt have xp", key);
        }

        int min_xp = xp.GetInt("min");
        int max_xp = xp.GetInt("max");

        JSON_Object odrops = item.GetObject("drops");
        EntityDrop[] drops = new EntityDrop[MAX_DROPS];

        if (odrops != null) {
            for (int j=0; j < odrops.Length; j++) {
                char str[64];
                IntToString(j, str, sizeof(str));

                JSON_Object drop = odrops.GetObject(str);
                if (drop == null) {
                    SetFailState("%s: huh", key);
                }

                char iitem[64];
                drop.GetString("item", iitem, sizeof(iitem));
                if (iitem[0] == '\0') {
                    SetFailState("%s: %d drop has no item", key, j);
                }

                float chance = drop.GetFloat("chance");

                EntityDrop edrop = new EntityDrop();
                edrop.SetString("item", iitem);
                edrop.SetValue("chance", chance);
            }
        }

        EntitySpawn spawn = new EntitySpawn();
        spawn.SetString("name", name);
        spawn.SetArray("drops", drops, MAX_DROPS);
        spawn.SetValue("min_hp", min_hp);
        spawn.SetValue("max_hp", max_hp);
        spawn.SetValue("min_xp", min_xp);
        spawn.SetValue("max_xp", max_xp);

        g_smEntities.SetValue(key, spawn);
        LogMessage("parsed entity '%s' aka '%s'", key, name);
    }
    json_cleanup_and_delete(root);
    
    if (g_smEntities == null) {
        SetFailState("failed to parse entities.json");
    }
}