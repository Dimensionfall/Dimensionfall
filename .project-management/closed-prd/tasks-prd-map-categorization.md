## Selected maintenance goal
- 14: Map Categorization and Template Generation

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
```

## Relevant Files
- `Mods/Dimensionfall/Maps/` - Existing map templates and categories
- `.project-management/current-prd/tasks-prd-map-categorization.md` - Task list

### Proposed New Files
- `Mods/Dimensionfall/Maps/underground_lab.json` - Secret underground lab
- `Mods/Dimensionfall/Maps/underground_cave.json` - Natural cave system
- `Mods/Dimensionfall/Maps/field_farmland.json` - Farmland template
- `Mods/Dimensionfall/Maps/field_outpost.json` - Field area with small outpost
- `Mods/Dimensionfall/Maps/suburban_park.json` - Park in suburban area

### Files To Remove
- None

### Notes
- Unit tests should typically be placed in `/Tests/Unit/`.
- Current categories: field, suburban, urban
- Proposed additional categories: coastal, underground

## Tasks
- [x] 1.0 Audit current map categories and templates
  - [x] 1.1 Review `Overmapareas.json` for current categories
- [x] 2.0 come up with two additional map categories to the project
  - [x] 2.1 Remember these categories for when we create the new maps of all categories
- [x] 3.0 Create two new map JSON templates for each of the five categories
  - [x] 3.1 Create new maps based on the 5 categories

*End of document*
