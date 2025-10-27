## Selected maintenance goal
- 7: Maintainability & Performance Cleanup

## Pre-Feature Development Project Tree
```text
.
├── AGENTS.md
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
├── FeatureList.md
├── Images
│   ├── Icons
│   └── Main menu
├── ItemProtosets.tres
├── LICENSE
├── LevelGenerator.gd
├── LevelGenerator.gd.uid
├── LevelManager.gd
├── LevelManager.gd.uid
├── Main_menu_buttons.tres
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
```

## Relevant Files

- Scripts/FurnitureStaticSrv.gd: Added safe disconnect logic for minute_passed signal.
- Scripts/item_manager.gd: Guarded disconnect calls with is_connected checks.
- .project-management/current-prd/tasks-maintainability-performance-cleanup.md: Updated task statuses.

### Files To Remove
- (none)

### Notes
- Unit tests should typically be placed in `/Tests/Unit/`.

## Tasks
- [x] 4.0 Clean signal connections
  - [x] 4.1 Audit scripts for unused signals
  - [x] 4.2 Remove stale connections and document remaining ones
  - [x] 4.3 Verify no runtime warnings on connect/disconnect
*End of document*
