## Selected maintenance goal
Documentation & Style Consistency

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
...
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
- `README.md` - Central documentation that will link to style guidelines
- `Documentation/Game_design/Game_architecture.md` - Existing architecture doc with typos
- `Documentation/Game_development/Getting_started.md` - Contains introductory instructions
- `Documentation/Game_development/Working_with_codex.md` - Details Codex workflow
- `Scripts/Helper.gd` - Contains constants that need naming cleanup
- `Scripts/Helper/save_helper.gd` - Adjust save/load for renamed map_seed variable
- `Scripts/Helper/overmap_manager.gd` - Use map_seed for noise generation
- `Scripts/scene_selector.gd` - Initialize map_seed when starting demo
- `Documentation/Game_design/Game_architecture.md` - Updated terminology for map_seed
### Files To Remove
- _None_

### Notes
- Unit tests should typically be placed in `/Tests/Unit/`.

## Tasks
- [x] 3.0 Normalize variable naming conventions
  - [x] 3.1 Identify variables with inconsistent casing
  - [x] 3.2 Rename variables using preferred style
  - [x] 3.3 Update references in other scripts

*End of document*
