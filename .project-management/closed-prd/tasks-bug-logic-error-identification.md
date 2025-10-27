## Selected maintenance goal
- 3: Bug & Logic Error Identification

## Pre-Feature Development Project Tree
```
    .
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
    ├── Images
    │   ├── Icons
    │   └── Main menu
    ├── Media
    │   ├── Catax_basic.png
    │   ├── Catax_basic.png.import
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
```

## Relevant Files
### Existing Files Modified
- `Scripts/Helper/map_manager.gd` - Add null checks when retrieving chunks and containers.
- `Scripts/bullet.gd` - Ensure collision callbacks handle null bodies safely.
- `Tests/Unit/test_map_manager.gd` - Cover chunk absence cases for spawn functions.

### Files To Remove
- _None_

### Notes
- Unit tests should be placed in `/Tests/Unit/`.

## Tasks
- [x] 1.0 Harden chunk retrieval and item spawning
  - [x] 1.1 Add null-checks in `spawn_item_at_current_player_map` and `spawn_mob_at_nearby_map`.
  - [x] 1.2 Update related unit tests to cover missing chunk scenarios.
- [x] 3.0 Safe bullet collision handling
  - [x] 3.1 Ensure `_on_body_shape_entered` and `_on_area_3d_body_shape_entered` skip null bodies and log appropriately.
- [x] 4.0 Review: Added tests for missing chunk scenarios.
