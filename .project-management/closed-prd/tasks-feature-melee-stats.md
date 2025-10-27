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
- [x] 1.0 Add stat entry field to `Scenes/ContentManager/Custom_Editors/ItemEditor/ItemMeleeEditor.tscn` using `DropEntityTextEdit.tscn`.
- [x] 2.0 Update `Scripts/ItemMeleeEditor.gd` to load, save, and validate the melee bonus stat using drop logic.
- [x] 3.0 Extend `Scripts/Gamedata/DItem.gd` Melee class to store the selected stat and maintain references.
- [x] 4.0 Apply the stat-based bonus during melee combat calculations.
- [x] 5.0 Write unit tests validating the new field and bonus logic.
- [x] 6.0 Review newly added accuracy stat support for melee weapons.
- [x] 7.0 Ensure melee accuracy stat references are removed when deleting an item.

*End of document*
