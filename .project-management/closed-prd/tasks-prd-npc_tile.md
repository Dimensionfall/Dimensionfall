## Pre-Feature Development Project Tree
- Assets
- Defaults
- Documentation
- Images
- Media
- Mods
  - Backrooms
  - Core
  - Dimensionfall
  - Test
- Scenes
  - ContentManager
  - Overmap
  - UI
- Scripts
  - Components
  - Gamedata
  - Helper
  - Mob
  - Runtimedata
- Shaders
- Sounds
  - Ambience
  - Music
  - SFX
- Tests
  - Unit
- Textures

## Relevant Files
### Proposed New Files
- `Tests/Unit/tilebrush_npc_tile_test.gd` - Unit tests for `npc_tile` brush placement and rotation.
- `Tests/Unit/dmap_npc_tile_test.gd` - Unit tests for serialization and deserialization of `npc_tile` data.
- `Tests/Unit/map_manager_npc_tile_test.gd` - Unit tests for `npc_tile` map processing behavior.

### Existing Files Modified
- `Scenes/ContentManager/Mapeditor/Scripts/mapeditor_brushcomposer.gd` - Adds `npc_tile` button to brush composer.
- `Scenes/ContentManager/Mapeditor/Scripts/GridContainer.gd` - Implements painting logic for `npc_tile` with rotation and feature replacement.
- `Scripts/Gamedata/DMap.gd` - Stores `npc_tile` coordinates and rotation.
- `Scripts/Gamedata/DMaps.gd` - Serializes and deserializes `npc_tile` data.
- `Scripts/Helper/map_manager.gd` - Processes `npc_tile` entries and allows overwrites.
- `Scenes/ContentManager/Mapeditor/Scripts/mapeditortile.gd` - Visualizes `npc_tile` features in the editor.

### Notes
- Follow GDScript 4 syntax and Godot 4.4 best practices.
- Use tabs for indentation.
- Run `gdformat` on changed scripts and execute GUT tests after modifications.
- `npc_tile` uses `res://Scenes/ContentManager/Mapeditor/Images/nulltile_32.png` as its icon.

## Tasks
 - [x] 1.0 Add `npc_tile` brush option alongside `null_tile` in the map editor brush composer (`Scenes/ContentManager/Mapeditor/Scripts/mapeditor_brushcomposer.gd`).
  - [x] 1.1 Update brush options list to include `npc_tile`, ensuring it appears in the composer UI.
  - [x] 1.2 Implement UI logic to select `npc_tile`, mirroring the selection flow used for `null_tile`.
  - [x] 1.3 Validate that selection updates internal state correctly and triggers necessary callbacks.
- [x] 2.0 Implement painting logic that places `npc_tile` with rotation and replaces existing `mob`, `mobgroup`, `furniture`, or `itemgroup` features (`Scenes/ContentManager/Mapeditor/Scripts/GridContainer.gd`).
  - [x] 2.1 Extend painting function to recognize `npc_tile` selection and capture rotation data.
  - [x] 2.2 Implement feature-replacement logic so `npc_tile` overwrites `mob`, `mobgroup`, `furniture`, or `itemgroup` on the same tile.
- [x] 4.0 Handle `npc_tile` entries during map processing, logging their presence and allowing later features to overwrite them (`Scripts/Helper/map_manager.gd`).
  - [x] 4.1 Extend map processing loop to detect `npc_tile` entries and log them for debugging.
- [x] 5.0 Add tests covering brush placement, serialization/deserialization, and map processing of `npc_tile` entries (`Tests/Unit/`).
  - [x] 5.1 Write unit tests for brush placement and rotation handling in `GridContainer.gd`.
  - [x] 5.2 Write serialization/deserialization tests ensuring `npc_tile` data persists accurately.
  - [x] 5.3 Add tests for map processing logic confirming correct overwrite behavior and logging.
  - [x] 5.4 Run all existing test suites to ensure no regressions.
- [x] 6.0 Update `mapeditortile.gd` so that it can visualize the npc tile.
  - [x] 6.1 Update the `update_display` function to handle npc_tile feature.
  - [x] 6.2 Use the `npcTexture` to display the npc tile feature on the `ObjectSprite`.

*End of document*
