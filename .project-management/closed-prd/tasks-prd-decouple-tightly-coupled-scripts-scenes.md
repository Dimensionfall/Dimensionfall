## Selected maintenance goal
- 4. Decouple Tightly Coupled Scripts & Scenes

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

## Relevant Files
- `LevelManager.gd`

### Existing Files Modified
- `LevelManager.gd` - Subscribe to player spawn signals instead of polling groups.

### Files To Remove
- *(none)*

### Notes
- Unit tests should typically be placed in `/Tests/Unit/`.

## Tasks
- [x] 4.0 Update `LevelManager` to receive player references via signal
  - [x] 4.1 Define a `player_spawned` signal in the relevant player or spawner script.
  - [x] 4.2 Modify `LevelManager.gd` to connect to `player_spawned` instead of polling groups.
  - [x] 4.3 Store the player reference provided via signal and update internal logic accordingly.
  - [x] 4.4 Clean up any residual group-check logic or unused variables.
- [c] 5.0 test
  - [c] 5.4 Ensure tests run and pass after refactoring.

*End of document*
