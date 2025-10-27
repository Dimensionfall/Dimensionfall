## Pre-Feature Development Project Tree
```
.
├── AGENTS.md
├── Defaults
│   ├── Blocks
│   ├── Mobs
│   ├── Player
│   ├── Projectiles
│   ├── Shaders
│   └── Sprites
├── FeatureList.md
├── ItemProtosets.tres
├── LICENSE
├── LevelGenerator.gd
├── LevelGenerator.gd.uid
├── LevelManager.gd
├── LevelManager.gd.uid
├── Main_menu_buttons.tres
├── README.md
├── Scenes
│   ├── ContentManager
│   ├── GameOver.tscn
│   ├── InventoryContainerListItem.tscn
│   ├── InventoryWindow.tscn
│   ├── LoadingScreen.tscn
│   ├── Overmap
│   ├── UI
│   ├── input_manager.tscn
│   └── player.tscn
├── Scripts
│   ├── AttributesWindow.gd
│   ├── AttributesWindow.gd.uid
│   ├── BuildManager.gd
│   ├── BuildManager.gd.uid
│   ├── BuildingMenu.gd
│   ├── BuildingMenu.gd.uid
│   ├── Camera.gd
│   ├── Camera.gd.uid
│   ├── CharacterWindow.gd
│   ├── CharacterWindow.gd.uid
│   ├── Chunk.gd
│   ├── Chunk.gd.uid
│   ├── ChunkLevel.gd
│   ├── ChunkLevel.gd.uid
│   ├── Client.gd
│   ├── Client.gd.uid
│   ├── Components
│   ├── ConstructionGhost.gd
│   ├── ConstructionGhost.gd.uid
│   ├── CraftingMenu.gd
│   ├── CraftingMenu.gd.uid
│   ├── CtrlInventoryStackedCustom.gd
│   ├── CtrlInventoryStackedCustom.gd.uid
│   ├── CtrlInventoryStackedListItem.gd
│   ├── CtrlInventoryStackedListItem.gd.uid
│   ├── CtrlInventoryStackedlistHeaderItem.gd
│   ├── CtrlInventoryStackedlistHeaderItem.gd.uid
│   ├── Documentation.gd
│   ├── Documentation.gd.uid
│   ├── EquipmentSlot.gd
│   ├── EquipmentSlot.gd.uid
│   ├── EquippedItem.gd
│   ├── EquippedItem.gd.uid
│   ├── EscapeMenu.gd
│   ├── EscapeMenu.gd.uid
│   ├── FurnitureBlueprintSpawner.gd
│   ├── FurnitureBlueprintSpawner.gd.uid
│   ├── FurnitureBlueprintSrv.gd
│   ├── FurnitureBlueprintSrv.gd.uid
│   ├── FurnitureConstructionWindow.gd
│   ├── FurnitureConstructionWindow.gd.uid
│   ├── FurniturePhysicsSpawner.gd
│   ├── FurniturePhysicsSpawner.gd.uid
│   ├── FurniturePhysicsSrv.gd
│   ├── FurniturePhysicsSrv.gd.uid
│   ├── FurnitureStaticSpawner.gd
│   ├── FurnitureStaticSpawner.gd.uid
│   ├── FurnitureStaticSrv.gd
│   ├── FurnitureStaticSrv.gd.uid
│   ├── FurnitureWindow.gd
│   ├── FurnitureWindow.gd.uid
│   ├── GameOver.gd
│   ├── GameOver.gd.uid
│   ├── Gamedata
│   ├── HeldItem.gd
│   ├── HeldItem.gd.uid
│   ├── Helper
│   ├── Helper.gd
│   ├── Helper.gd.uid
│   ├── InventoryContainerListItem.gd
│   ├── InventoryContainerListItem.gd.uid
│   ├── InventoryWindow.gd
│   ├── InventoryWindow.gd.uid
│   ├── ItemAmmoEditor.gd
│   ├── ItemAmmoEditor.gd.uid
│   ├── ItemCraftEditor.gd
│   ├── ItemCraftEditor.gd.uid
│   ├── ItemDetector.gd
│   ├── ItemDetector.gd.uid
│   ├── ItemEditor.gd
│   ├── ItemEditor.gd.uid
│   ├── ItemFoodEditor.gd
│   ├── ItemFoodEditor.gd.uid
│   ├── ItemMagazineEditor.gd
│   ├── ItemMagazineEditor.gd.uid
│   ├── ItemMedicalEditor.gd
│   ├── ItemMedicalEditor.gd.uid
│   ├── ItemMeleeEditor.gd
│   ├── ItemMeleeEditor.gd.uid
│   ├── ItemRangedEditor.gd
│   ├── ItemRangedEditor.gd.uid
│   ├── ItemToolEditor.gd
│   ├── ItemToolEditor.gd.uid
│   ├── ItemWearableEditor.gd
│   ├── ItemWearableEditor.gd.uid
│   ├── LoadingScreen.gd
│   ├── LoadingScreen.gd.uid
│   ├── Mob
│   ├── NonHUDclick.gd
│   ├── NonHUDclick.gd.uid
│   ├── OvermapGrid.gd
│   ├── OvermapGrid.gd.uid
│   ├── PlayerAttribute.gd
│   ├── PlayerAttribute.gd.uid
│   ├── PlayerShooting.gd
│   ├── PlayerShooting.gd.uid
│   ├── QuestTrackerUI.gd
│   ├── QuestTrackerUI.gd.uid
│   ├── QuestWindow.gd
│   ├── QuestWindow.gd.uid
│   ├── Runtimedata
│   ├── WearableSlot.gd
│   ├── WearableSlot.gd.uid
│   ├── bullet.gd
│   ├── bullet.gd.uid
│   ├── container.gd
│   ├── container.gd.uid
│   ├── crafting_recipes_manager.gd
│   ├── crafting_recipes_manager.gd.uid
│   ├── gamedata.gd
│   ├── gamedata.gd.uid
│   ├── general.gd
│   ├── general.gd.uid
│   ├── hud.gd
│   ├── hud.gd.uid
│   ├── input_manager.gd
│   ├── input_manager.gd.uid
│   ├── item_manager.gd
│   ├── item_manager.gd.uid
│   ├── player.gd
│   ├── player.gd.uid
│   ├── runtimedata.gd
│   ├── runtimedata.gd.uid
│   ├── scene_selector.gd
│   ├── scene_selector.gd.uid
│   ├── target_manager.gd
│   ├── target_manager.gd.uid
│   ├── weapon.gd
│   └── weapon.gd.uid
├── Shaders
│   ├── HideAbovePlayer.gdshader
│   ├── HideAbovePlayer.gdshader.uid
│   ├── HideAbovePlayerShadow.gdshader
│   └── HideAbovePlayerShadow.gdshader.uid
├── Tests
│   └── Unit
├── day_night.gd
├── day_night.gd.uid
├── day_night.tscn
├── documentation.tscn
├── entity_manager.gd
├── entity_manager.gd.uid
├── export_presets.cfg
├── front_light.gd
├── front_light.gd.uid
├── front_light.tscn
├── hud.tscn
├── icon.svg
├── icon.svg.import
├── level_generation.tscn
├── override.cfg
├── project.godot
├── scene_selector.tscn
├── spot_light_3d.tscn
├── spot_light_3d_2.tscn
├── test_environment.gd
├── test_environment.gd.uid
├── test_environment.tscn
└── torso.aseprite

21 directories, 167 files
```
\n## Relevant Files

### Existing Files Modified
- `Scripts/general.gd` - Document functions and cleanup naming.
- `Scripts/EquippedItem.gd` - Updated variable references and indentation.
- `Scripts/NonHUDclick.gd` - Updated variable references.
- `Scripts/Mob/Mob.gd` - Updated reference to shared collision shape.

### Files To Remove
- None

### Notes
- Unit tests should typically be placed in `/Tests/Unit/`.
\n## Tasks
- [x] 1.0 Document and clean up `general.gd`
	- [x] 1.1 Add docstrings for each function
	- [x] 1.2 Remove unused variables and clarify names
