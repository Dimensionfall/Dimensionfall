## Pre-Feature Development Project Tree
``` 
.
├── AGENTS.md
├── Assets
├── Defaults
├── Documentation
├── FeatureList.md
├── Images
├── ItemProtosets.tres
├── LICENSE
├── LevelGenerator.gd
├── LevelGenerator.gd.uid
├── LevelManager.gd
├── LevelManager.gd.uid
├── Main_menu_buttons.tres
├── Media
├── Mods
├── README.md
├── Scenes
├── Scripts
├── Shaders
├── Sounds
├── Tests
├── Textures
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

13 directories, 33 files
```

## Tasks
- [x] 1.0 Add stat selection field to `Scenes/ContentManager/Custom_Editors/ItemEditor/ItemCraftEditor.tscn` using `Scenes/ContentManager/Custom_Widgets/DropEntityTextEdit.tscn`.
- [x] 2.0 Update `Scripts/ItemCraftEditor.gd` to load and save the chosen stat for each recipe.
- [x] 3.0 Extend `Scripts/Gamedata/DItem.gd` and `Scripts/Runtimedata/RItem.gd` craft structures to store the stat reference.
- [x] 4.0 Modify `Scripts/crafting_recipes_manager.gd` to include the selected stat in skill requirement checks.
- [x] 5.0 Add unit tests verifying stat bonus application and default behavior when no stat is set.
- [x] 6.0 Add missing unit tests verifying skill bonus stat functionality.

*End of document*
