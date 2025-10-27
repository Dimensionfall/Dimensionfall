## Selected maintenance goal
- 4 - Decouple Tightly Coupled Scripts & Scenes

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
- `hud.tscn`
- `Scenes/player.tscn`
- `Scripts/hud.gd`
- `Scripts/PlayerShooting.gd`
- `Scripts/Helper/SignalBroker/player_input_signal_broker.gd`
- `Scripts/input_manager.gd`

### Proposed New Files
- `/Tests/Unit/test_hud_signals.gd` - Unit tests verifying HUD emits and receives signals correctly.

### Existing Files Modified
- `Scripts/hud.gd` - replace NodePath dependencies with signals.
- `hud.tscn` - remove NodePath properties referencing other scenes.
- `Scenes/player.tscn` - update to remove NodePath linking to HUD.
- `Scripts/PlayerShooting.gd` - replace `player` NodePath with signal connection.
- `Scripts/Helper/SignalBroker/player_input_signal_broker.gd` - add reload_weapon signal.
- `Scripts/input_manager.gd` - emit reload_weapon signal on input.

### Files To Remove
- none

### Notes
- Unit tests should typically be placed in `/Tests/Unit/`.

## Tasks
- [ ] 2.0 Convert HUD interactions to use signals via `Helper.signal_broker`.
  - [ ] 2.1 Add signals to hud.gd for HUD actions.
  - [ ] 2.2 Connect other scripts to HUD via Helper.signal_broker.
  - [ ] 2.3 Remove old NodePath exports from hud.gd.
- [ ] 3.0 Refactor Player and PlayerShooting to rely on signals instead of direct NodePaths.
  - [ ] 3.1 Emit signals from player.gd for state changes.
  - [x] 3.2 Update PlayerShooting.gd to use signals instead of NodePaths.
  - [ ] 3.3 Connect Player signals to HUD via signal broker.
- [ ] 4.0 Update scenes to remove exported NodePath properties and wire up signal connections.
  - [ ] 4.1 Remove NodePath exports from hud.tscn and player.tscn.
  - [ ] 4.2 Connect scenes to signals in their _ready functions.
- [ ] 5.0 Add unit tests to confirm HUD and Player signal interactions work as expected.
  - [ ] 5.1 Implement GUT test for HUD signals.
  - [ ] 5.2 Test PlayerShooting signal emissions.
  - [ ] 5.3 Run full test suite and confirm pass.

*End of document*
