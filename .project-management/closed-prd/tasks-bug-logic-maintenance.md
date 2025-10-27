## Selected maintenance goal
- Bug & Logic Error Identification

## Pre-Feature Development Project Tree
```
.
├── AGENTS.md
├── Assets
│   └── Fonts
├── Defaults
│   ├── Blocks
│   ├── Mobs
│   ├── Player
│   ├── Projectiles
│   ├── Shaders
│   └── Sprites
├── Documentation
│   ├── Game_design
│   ├── Game_development
│   └── Modding
├── FeatureList.md
├── Images
│   ├── Icons
│   └── Main menu
├── ItemProtosets.tres
├── LICENSE
├── LevelGenerator.gd
├── LevelGenerator.gd.uid
├── LevelManager.gd
├── LevelManager.gd.uid
├── Main_menu_buttons.tres
├── Media
│   ├── Catax_basic.png
│   ├── Catax_basic.png.import
│   ├── Catax_basic_zoomed_out.png
│   ├── Catax_basic_zoomed_out.png.import
│   ├── Catax_content_editor.png
│   ├── Catax_content_editor.png.import
│   ├── Catax_crafting_editor.png
│   ├── Catax_crafting_editor.png.import
│   ├── Catax_furniture_editor.png
│   ├── Catax_furniture_editor.png.import
│   ├── Catax_item_editor.png
│   ├── Catax_item_editor.png.import
│   ├── Catax_itemgroup_editor.png
│   ├── Catax_itemgroup_editor.png.import
│   ├── Catax_map_editor.png
│   ├── Catax_map_editor.png.import
│   ├── Catax_map_editor_area_editor.png
│   ├── Catax_map_editor_area_editor.png.import
│   ├── Catax_map_editor_areas.png
│   ├── Catax_map_editor_areas.png.import
│   ├── Catax_map_editor_preview.png
│   ├── Catax_map_editor_preview.png.import
│   ├── Catax_mob_editor.png
│   ├── Catax_mob_editor.png.import
│   ├── Catax_overmap_large.png
│   ├── Catax_overmap_large.png.import
│   ├── Catax_playerattribute_editor.png
│   ├── Catax_playerattribute_editor.png.import
│   ├── Catax_quest_editor.png
│   ├── Catax_quest_editor.png.import
│   ├── Catax_skills_editor.png
│   ├── Catax_skills_editor.png.import
│   ├── Catax_stats_editor.png
│   ├── Catax_stats_editor.png.import
│   ├── Catax_tacticalmap_editor.png
│   ├── Catax_tacticalmap_editor.png.import
│   ├── Catax_tile_editor.png
│   ├── Catax_tile_editor.png.import
│   ├── Catax_wearableslots_editor.png
│   ├── Catax_wearableslots_editor.png.import
│   ├── Dimensionfall_add_remove_mod_menu.png
│   ├── Dimensionfall_add_remove_mod_menu.png.import
│   ├── Dimensionfall_crafting_station.png
│   ├── Dimensionfall_crafting_station.png.import
│   ├── Dimensionfall_inventory.png
│   ├── Dimensionfall_inventory.png.import
│   ├── Dimensionfall_main_menu.png
│   ├── Dimensionfall_main_menu.png.import
│   ├── Dimensionfall_mobfaction_editor.png
│   ├── Dimensionfall_mobfaction_editor.png.import
│   ├── Dimensionfall_mobgroup_editor.png
│   ├── Dimensionfall_mobgroup_editor.png.import
│   ├── Dimensionfall_overmap.png
│   ├── Dimensionfall_overmap.png.import
│   ├── Dimensionfall_overmaparea_editor.png
│   ├── Dimensionfall_overmaparea_editor.png.import
│   ├── Dimensionfall_overmaparea_generator.png
│   ├── Dimensionfall_overmaparea_generator.png.import
│   ├── Dimensionfall_quest_journal.png
│   └── Dimensionfall_quest_journal.png.import
├── Mods
│   ├── Backrooms
│   ├── Core
│   ├── Dimensionfall
│   └── Test
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
├── Sounds
│   ├── Ambience
│   ├── Music
│   ├── SFX
│   └── default_bus_layout.tres
├── Tests
│   └── Unit
├── Textures
│   ├── 9mm.png
│   ├── 9mm.png.import
│   ├── Screenshot_167.png
│   ├── Screenshot_167.png.import
│   ├── above.png
│   ├── above.png.import
│   ├── bar_border.png
│   ├── bar_border.png.import
│   ├── bar_progress.png
│   ├── bar_progress.png.import
│   ├── bullet.png
│   ├── bullet.png.import
│   ├── container_32.png
│   ├── container_32.png.import
│   ├── container_filled_32.png
│   ├── container_filled_32.png.import
│   ├── enemy.png
│   ├── enemy.png.import
│   ├── head.png
│   ├── head.png.import
│   ├── imgonline-com-ua-TextureSeamless-vPpbshdid4ZMVqj.png
│   ├── imgonline-com-ua-TextureSeamless-vPpbshdid4ZMVqj.png.import
│   ├── leftarm.png
│   ├── leftarm.png.import
│   ├── leftleg.png
│   ├── leftleg.png.import
│   ├── pistol_magazine.png
│   ├── pistol_magazine.png.import
│   ├── plank.png
│   ├── plank.png.import
│   ├── player.png
│   ├── player.png.import
│   ├── pointer2.png
│   ├── pointer2.png.import
│   ├── pointer3.png
│   ├── pointer3.png.import
│   ├── rightarm.png
│   ├── rightarm.png.import
│   ├── rightleg.png
│   ├── rightleg.png.import
│   ├── steel_scrap.png
│   ├── steel_scrap.png.import
│   ├── survivor.png
│   ├── survivor.png.import
│   ├── torso.png
│   ├── torso.png.import
│   ├── ui_concrete.png
│   ├── ui_concrete.png.import
│   ├── under_construction_32.png
│   └── under_construction_32.png.import
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

41 directories, 278 files
```

## Relevant Files
- `Scripts/Helper/quest_helper.gd`
- `Scripts/Mob/Mob.gd`
- `Scripts/Mob/MobAttack.gd`
- `Scripts/Mob/MobFollow.gd`
- `Scripts/Mob/MobRangedAttack.gd`
- `Scripts/EquippedItem.gd`
- `Scripts/bullet.gd`
- `Scripts/target_manager.gd`
- `Scripts/Helper/SignalBroker/signal_broker.gd`

### Proposed New Files
- `/Tests/Unit/test_quest_helper.gd` - Unit tests for quest mob kill tracking.

### Existing Files Modified
- `Scripts/Helper/quest_helper.gd` - Track killer for mob kill quests.
- `Scripts/Mob/Mob.gd` - Provide killer information when mobs die.
- `Scripts/Mob/MobAttack.gd` - Include source in attack data.
- `Scripts/Mob/MobFollow.gd` - Adjust mob_killed handler signature.
- `Scripts/Mob/MobRangedAttack.gd` - Include source in attack data.
- `Scripts/EquippedItem.gd` - Tag attacks with player as source.
- `Scripts/bullet.gd` - Pass shooter as attack source.
- `Scripts/target_manager.gd` - Adjust mob_killed handler signature.
- `Scripts/Helper/SignalBroker/signal_broker.gd` - Emit killer with mob_killed.

### Files To Remove
- *(none)*

### Notes
- Unit tests should typically be placed in `/Tests/Unit/`.

## Tasks
- [c] 2.0 Include killer information in quest updates

*End of document*
