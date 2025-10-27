## Pre-Feature Development Project Tree
```
.
├── AGENTS.md
├── FeatureList.md
├── ItemProtosets.tres
├── LICENSE
├── LevelGenerator.gd
├── LevelGenerator.gd.uid
├── LevelManager.gd
├── LevelManager.gd.uid
├── Main_menu_buttons.tres
├── README.md
├── Assets
├── Defaults
├── Images
├── Mods
├── Scenes
├── Scripts
├── Shaders
├── Sounds
└── Textures
```

## Relevant Files
- `Scripts/Chunk.gd` - Contains the `rotate_level_clockwise` function.
- `.project-management/current-prd/feature-specification.md` - Background details on using the `feature` dictionary.

### Proposed New Files
- *(none at this stage)*

### Existing Files Modified
- `Scripts/Gamedata/DMap.gd` - Update feature handling for entity sets.
- `Scripts/Chunk.gd` - Refactor rotation logic to rely on `tile.feature`.

### Notes
- Follow GDScript 4 syntax and Godot 4.4 best practices.
- No additional automated tests are required for this feature.

## Tasks
- [x] 1.0 Refactor `rotate_level_clockwise` in `Scripts/Chunk.gd` to use `tile.feature` for rotation as described in `.project-management/current-prd/feature-specification.md`.
  - [x] 1.1 Locate the `rotate_level_clockwise` function in `Scripts/Chunk.gd`.
  - [x] 1.2 Replace checks for `tile.furniture` with logic that reads from `tile.feature`.
  - [x] 1.3 Ensure that rotated features update their `rotation` field correctly.
  - [x] 1.4 Run `gdformat Scripts/Chunk.gd` to apply consistent formatting.
- [x] 2.0 Implement rotation handling for all feature types (`furniture`, `mob`, `mobgroup`, `itemgroup`) that include a `rotation` field.
  - [x] 2.1 Expand the rotation logic to handle each feature type.
  - [x] 2.2 Verify that mobs and item groups preserve their orientation after rotation.
- [x] 3.0 Audit the codebase and replace any remaining references to `tile.furniture` with `tile.feature`.
  - [x] 3.1 Search the repository for `tile.furniture` occurrences.
  - [x] 3.2 Update each script to reference `tile.feature` instead.
  - [x] 5.2 Mention the removal of the `furniture` property.
- [x] 4.0 Review DMap.gd and replace any remaining references to furniture, mobs or itemgroups with `tile.feature`.
  - [x] 4.1 Update remove_my_reference_from_all_entities to use feature instead of mobs, itemgroups, furniture.
  - [x] 4.2 Update data_changed to reference `tile.feature` instead.
  - [x] 4.3 Update collect_unique_entities to use feature instead of mob, itemgroup and furniture.
  - [x] 4.4 Review the DMap script and replace the use of mobs, itemgroups and furniture with the feature property.
*End of document*
