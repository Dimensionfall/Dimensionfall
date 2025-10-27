## Pre-Feature Development Project Tree
```bash
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

```
## Relevant Files
- `Scenes/ContentManager/Custom_Editors/NpcEditor.tscn` - UI for editing NPC data, modeled after StatsEditor with a health field.
- `Scenes/ContentManager/Custom_Editors/Scripts/NpcEditor.gd` - Logic for loading and saving DNpc entries.
- `Scenes/ContentManager/Custom_Editors/Scripts/NpcEditor.gd.uid` - UID file for the editor script.
- `Scenes/ContentManager/Scripts/contenteditor.gd` - Register NPC content type and open the NPC editor.
- `Scenes/ContentManager/contenteditor.tscn` - Add packed scene export and UI hooks for NPC editor.
- `Scripts/Gamedata/DNpc.gd` - Provide save/delete methods for persistence.
- `Scripts/Gamedata/DNpcs.gd` - Manage saving to disk and CRUD operations.
### Proposed New Files
- `Tests/Unit/test_npc_editor.gd` - Unit tests for NPC editor behavior.
### Notes
- Follow GDScript 4 syntax and Godot 4.4 best practices with tab indentation.
- Layout of the NPC editor should mirror StatsEditor for consistency.
- Saving uses DNpc.save_to_disk which delegates to DNpcs.save_npcs_to_disk.

## Tasks
- [c] **1.0** Integrate `DNpc` content type with `contenteditor.gd`
  - [c] **1.1** Add `npcEditor` export variable and map `DMod.ContentType.NPCS` to a new editor scene.
  - [c] **1.2** Update `refresh_lists()` to call `load_content_list` for NPCs.
  - [c] **1.3** Include `NPCs` in type selector menu and editor configuration.
- [c] **2.0** Create NPC editor scene and script
  - [c] **2.1** Duplicate `StatsEditor.tscn` as `NpcEditor.tscn` and insert a SpinBox for health.
  - [c] **2.2** Implement `NpcEditor.gd` to load DNpc fields and emit `data_changed` on save.
  - [c] **2.3** Connect Load and Save buttons to DNpc properties.
- [c] **3.0** Implement persistence in DNpc classes
  - [c] **3.1** Add `save_to_disk`, `changed`, and `delete` methods in `DNpc.gd`.
  - [c] **3.2** Extend `DNpcs.gd` with `save_npcs_to_disk`, `add_new`, `append_new`, and `delete_by_id`.
- [c] **4.0** Update content editor workflow for NPCs
  - [c] **4.1** Add packed scene reference to `contenteditor.tscn` for `NpcEditor`.
  - [c] **4.2** Ensure activating an NPC list item opens the NPC editor tab.
  - [c] **4.3** Allow creation and deletion of NPC entries through `content_list.gd`.
- [ ] **5.0** Write unit tests for NPC editor
- [c] **5.1** Instantiate `NpcEditor.tscn` with a sample `DNpc` in tests.
- [c] **5.2** Verify fields load correctly and saving updates the DNpc instance.
  - [ ] **5.3** Test adding and deleting NPCs through the content list.
- [ ] **6.0** Add tests for NPC list add/delete functionality.
*End of document*
