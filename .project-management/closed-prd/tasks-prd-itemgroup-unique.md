## Pre-Feature Development Project Tree
- Scenes
  - UI
  - Overmap
  - ContentManager
- Assets
  - Fonts
- Mods
  - Core
  - Backrooms
  - Dimensionfall
  - Test
- Shaders
- Images
  - Main menu
  - Icons
- Defaults
  - Projectiles
  - Shaders
  - Blocks
  - Player
  - Mobs
  - Sprites
- Documentation
  - Game_design
  - Modding
  - Game_development
- Media
- Sounds
  - Music
  - SFX
  - Ambience
- Scripts
  - Runtimedata
  - Mob
  - Components
  - Helper
  - Gamedata
- Textures
- Tests
  - Unit

## Relevant Files
- `Scenes/ContentManager/Custom_Editors/Scripts/ItemgroupEditor.gd` - Enforces unique item drops.
- `Tests/Unit/test_itemgroup_editor.gd` - Unit tests verifying duplicate item drops are ignored.

### Notes

- Unit tests should typically be placed in /Tests/Unit/.

## Tasks

- [x] 1.0 Ensure item drops are unique in the itemgroup editor
  - [x] 1.1 Locate the itemgroup editor code to understand how item drops are stored and manipulated
  - [x] 1.2 Update the drop-adding mechanism to check for existing entries and avoid inserting duplicates
- [x] 2.0 Create unit tests verifying duplicate item drops are ignored
  - [x] 2.1 Write tests that attempt to insert duplicates into an itemgroup and confirm only one instance remains

*End of document*
