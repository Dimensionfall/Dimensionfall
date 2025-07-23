## Selected maintenance goal
- Code Refactoring & Simplification

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
├── Mods
│   ├── Backrooms
│   ├── Core
│   ├── Dimensionfall
│   └── Test
├── Scenes
│   ├── ContentManager
│   ├── Overmap
│   └── UI
├── Scripts
│   ├── Components
│   ├── Gamedata
│   ├── Helper
│   ├── Mob
│   └── Runtimedata
├── Shaders
├── Sounds
│   ├── Ambience
│   ├── Music
│   └── SFX
├── Tests
│   └── Unit
└── Textures

41 directories

## Relevant Files

### Existing Files Modified
- `Scripts/BuildManager.gd` - Separate ghost updates from build logic.

### Files To Remove
- None

### Notes
- Unit tests should typically be placed in `/Tests/Unit/`.

## Tasks


- [ ] 2.0 Refactor `BuildManager.gd`


  - [ ] 2.1 Move ghost update logic into `update_ghost()` method


  - [ ] 2.2 Invoke `update_ghost()` from build functions


  - [ ] 2.3 Add tests for ghost placement
