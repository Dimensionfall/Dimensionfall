## Pre-Feature Development Project Tree
```
./
├── AGENTS.md
├── Defaults/
│   ├── Blocks/
│   ├── Mobs/
│   ├── Player/
│   ├── Projectiles/
│   ├── Shaders/
│   └── Sprites/
├── FeatureList.md
├── ItemProtosets.tres
├── LICENSE
├── LevelGenerator.gd
├── LevelGenerator.gd.uid
├── LevelManager.gd
├── LevelManager.gd.uid
├── Main_menu_buttons.tres
├── README.md
├── Scenes/
│   ├── ContentManager/
│   ├── GameOver.tscn
│   ├── InventoryContainerListItem.tscn
│   ├── InventoryWindow.tscn
│   ├── LoadingScreen.tscn
│   ├── Overmap/
│   ├── UI/
│   ├── input_manager.tscn
│   └── player.tscn
├── Scripts/
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
│   ├── Components/
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
│   ├── Gamedata/
│   ├── HeldItem.gd
│   ├── HeldItem.gd.uid
│   ├── Helper/
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
│   ├── Mob/
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
│   ├── Runtimedata/
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
├── Shaders/
│   ├── HideAbovePlayer.gdshader
│   ├── HideAbovePlayer.gdshader.uid
│   ├── HideAbovePlayerShadow.gdshader
│   └── HideAbovePlayerShadow.gdshader.uid
├── Tests/
│   └── Unit/
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
## Relevant Files
- `Scripts/CtrlInventoryStackedCustom.gd`
- `Scripts/item_manager.gd`
- `Scripts/InventoryWindow.gd`
### Proposed New Files
- `Tests/Unit/test_reload_proximity_magazine.gd` - Unit tests for proximity reload logic.
### Existing Files Modified
- `Scripts/CtrlInventoryStackedCustom.gd` - Detect reload from proximity and transfer magazine if space.
- `Scripts/item_manager.gd` - Reload magazines using bullets from player or proximity inventories.
- `Scripts/InventoryWindow.gd` - Ensure bullet count updates after reload.

### Notes
- Unit tests should typically be placed in /Tests/Unit/.
- Follow Godot 4.4 best practices and use GDScript 4 syntax.

## Tasks
- [c] 1.0 Support reloading magazines from proximity inventory
  - [c] 1.1 In `CtrlInventoryStackedCustom.gd`, check if selected magazine is in proximity inventory
  - [c] 1.2 If player inventory has space, transfer magazine before calling reload
  - [c] 1.3 If inventory is full, reload magazine in place
- [c] 2.0 Prioritize player ammo when reloading
  - [c] 2.1 Update `ItemManager.reload_magazine` to search player inventory first
  - [c] 2.2 Use `transfer_items_to_inventory` to pull bullets from proximity if needed
  - [c] 2.3 Reload magazine using any available ammo
- [c] 3.0 Update inventories after reload action
  - [c] 3.1 Refresh UI lists so bullet counts display correctly
  - [c] 3.2 Ensure magazine ends in player inventory when moved
- [c] 4.0 Add unit tests for proximity magazine reload
  - [c] 4.1 Test reload succeeds when ammo only in proximity
  - [c] 4.2 Test reload uses player ammo first
  - [c] 4.3 Test no action when inventory full and no ammo
*End of document*
