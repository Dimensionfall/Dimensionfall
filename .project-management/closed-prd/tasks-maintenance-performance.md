## Selected maintenance goal
- Maintainability & Performance Cleanup (Goal 7)

## Pre-Feature Development Project Tree
```
.
├── Assets
│   └── Fonts
├── Defaults
│   ├── Blocks
│   ├── Mobs
│   ├── Player
│   ├── Projectiles
│   ├── Shaders
│   └── Sprites
├── Documentation
│   ├── Game_design
│   ├── Game_development
│   └── Modding
├── Images
│   ├── Icons
│   └── Main menu
├── Media
│   ├── Catax_basic.png
│   ├── Catax_basic.png.import
│   ├── Catax_basic_zoomed_out.png
│   ├── Catax_basic_zoomed_out.png.import
│   ├── Catax_content_editor.png
│   ├── Catax_content_editor.png.import
│   ├── Catax_crafting_editor.png
│   ├── Catax_crafting_editor.png.import
│   ├── Catax_furniture_editor.png
│   ├── Catax_furniture_editor.png.import
│   ├── Catax_item_editor.png
│   ├── Catax_item_editor.png.import
│   ├── Catax_itemgroup_editor.png
│   ├── Catax_itemgroup_editor.png.import
│   ├── Catax_map_editor.png
│   ├── Catax_map_editor.png.import
│   ├── Catax_map_editor_area_editor.png
│   ├── Catax_map_editor_area_editor.png.import
│   ├── Catax_map_editor_areas.png
│   ├── Catax_map_editor_areas.png.import
│   ├── Catax_map_editor_preview.png
│   ├── Catax_map_editor_preview.png.import
```


### Files To Remove
- None identified

### Notes
- Unit tests should typically be placed in `/Tests/Unit/`.

## Tasks
- [ ] 4.0 Reorganize Scenes and Scripts Structure
  - [x] 4.1 Move scenes into categorized folders under `Scenes/`
  - [ ] 4.2 Align script names with scene names and update references
  - [x] 4.3 Update `override.cfg` and `project.godot` paths

## Relevant Files
### Existing Files Modified
- `hud.tscn` - Updated paths to moved scenes.
- `Scenes/UI/InventoryWindow.tscn` - Adjusted path to list item scene.
- `project.godot` - Added folder color for `Scenes/UI`.
### Files Moved
- `Scenes/InventoryWindow.tscn` → `Scenes/UI/InventoryWindow.tscn`
- `Scenes/InventoryContainerListItem.tscn` → `Scenes/UI/InventoryContainerListItem.tscn`
- `Scenes/GameOver.tscn` → `Scenes/UI/GameOver.tscn`
- `Scenes/LoadingScreen.tscn` → `Scenes/UI/LoadingScreen.tscn`
