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
```

## Relevant Files
- `Scripts/Gamedata/DMap.gd` - Map and tile data structure definitions.
- `Scripts/Helper/map_manager.gd` - Processes map entity data during generation.
- `Scenes/ContentManager/Mapeditor/Scripts/GridContainer.gd` - Handles painting and erasing of entities in the map editor.
- `Scenes/ContentManager/Mapeditor/Scripts/mapeditortile.gd` - Displays tiles in the map editor.
- `Tests/Unit/test_map_manager.gd` - Current tests for map manager utilities.
- `.project-management/current-prd/tasks-prd-tile-feature-consolidation.md` - Task list for tile feature consolidation.
- `Scripts/Chunk.gd` - Generates chunks and reads tile feature data.

### Proposed New Files
- `Scripts/Helper/tile_feature_migration.gd` - Helper to convert legacy map data to the unified feature structure.
- `Tests/Unit/test_tile_feature_migration.gd` - Unit tests for the migration utility.

### Existing Files Modified
- `Scripts/Gamedata/DMap.gd` - Introduce `feature` dictionary and conversion helpers.
- `Scripts/Helper/map_manager.gd` - Read and write the `feature` dictionary during map generation.
- `Scenes/ContentManager/Mapeditor/Scripts/GridContainer.gd` - Update painting logic to modify `tileData.feature`.
- `Scenes/ContentManager/Mapeditor/Scripts/mapeditortile.gd` - Display tiles and tooltips based on `tileData.feature`.
- `Tests/Unit/test_map_manager.gd` - Update tests for new feature structure.
- `Scripts/Chunk.gd` - Process feature dictionaries when generating chunks.

### Notes
- Unit tests reside in `/Tests/Unit/`.
- No UI layout changes are required; updates are limited to data structure handling.

## Tasks
- [x] 1.0 Refactor map tile data to use a unified `feature` dictionary. *(DMap.gd)*
  - [x] 1.1 Add `feature` property to the `maptile` class.
  - [x] 1.2 Update `set_data` and `get_data` to read/write the dictionary.
  - [x] 1.3 Convert legacy keys to `feature` when loading tiles.
  - [x] 1.4 Skip writing empty `feature` entries when saving.
- [x] 2.0 Update map management logic to read/write the new `feature` field. *(map_manager.gd)*
  - [x] 2.1 Modify `_process_entities_data` to output `feature` dictionaries.
  - [x] 2.2 Update removal helpers to check `feature.type`.
  - [x] 2.3 Replace references to legacy keys with `feature` accessors.
- [x] 3.0 Modify map editor painting logic to update `tileData.feature`. *(GridContainer.gd)*
-  - [x] 3.1 Remove legacy field clearing and set `tileData.feature` directly.
-  - [x] 3.2 Store rotation and itemgroup lists in the dictionary.
- [x] 4.0 Update tile display and tooltips to reference `tileData.feature`. *(mapeditortile.gd)*
  - [x] 4.1 Determine sprite based on `feature.type` and `id`.
  - [x] 4.2 Update tooltips to show feature information.
  - [x] 4.3 Remove checks for obsolete fields.
 - [x] 5.0 Update feature processing in chunk.gd.
  - [x] 5.1 Look for `tileJSON.has("mobgroup")` and similar statements and update them to use tileJSON.feature
  - [x] 5.2 At least the `process_level_data` will need an update.

*End of document*
