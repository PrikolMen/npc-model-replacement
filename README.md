# npc-model-replacement
Simple script for replacing npc models and randomizing skins and bodygroups.

## Customization from Lua
The `true`/`false` in `Skin` and `BodyGroups` means random, if true, the script chooses a random value for that key.

```lua
list.Set( "NPCModelReplacement", "original/model/path", "your/model/path" )
list.Set( "NPCModelReplacement", "original/model/path", { "your/model/path", "your/model/path2", "your/model/path3" }  )
list.Set( "NPCModelReplacement", "original/model/path", { ModelPath = "your/model/path", Skin = 0, BodyGroups = "000000" }  )
list.Set( "NPCModelReplacement", "original/model/path", {
    { ModelPath = "your/model/path", Skin = 0, BodyGroups = "000000" },
    { ModelPath = "your/model/path2", Skin = false, BodyGroups = false },
    { ModelPath = "your/model/path3", Skin = true, BodyGroups = true },
    { ModelPath = "your/model/path3", Skin = { 0, 4 }, BodyGroups = {
            {
                id = 0,
                value = 1
            },
            {
                id = 2,
                value = 0
            }
        }
    }
} )
```

# Customization from JSON in SERVER data
Supports all the same things as Lua customization but in JSON format, more info at wiki.facepunch.com/gmod
```json
{
	"models/monk.mdl": "models/alyx.mdl",
	"path/to/model2": "path/to/other/model2"
}
```
