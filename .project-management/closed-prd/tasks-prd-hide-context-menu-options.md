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
├── ItemProtosets.tres
├── LICENSE
├── LevelGenerator.gd
├── LevelGenerator.gd.uid
├── LevelManager.gd
├── LevelManager.gd.uid
├── Main_menu_buttons.tres
├── README.md
├── Scenes
│   ├── ContentManager
│   ├── GameOver.tscn
│   ├── InventoryContainerListItem.tscn
│   ├── InventoryWindow.tscn
│   ├── LoadingScreen.tscn
│   ├── Overmap
│   ├── UI
│   ├── input_manager.tscn
│   └── player.tscn
├── Scripts
│   ├── AttributesWindow.gd
│   ├── AttributesWindow.gd.uid
│   ├── BuildManager.gd
│   ├── BuildManager.gd.uid
│   ├── BuildingMenu.gd
│   ├── BuildingMenu.gd.uid
│   ├── Camera.gd
│   ├── Camera.gd.uid
│   ├── CharacterWindow.gd
│   ├── CharacterWindow.gd.uid
│   ├── Chunk.gd
│   ├── Chunk.gd.uid
│   ├── ChunkLevel.gd
│   ├── ChunkLevel.gd.uid
│   ├── Client.gd
│   ├── Client.gd.uid
│   ├── Components
│   ├── ConstructionGhost.gd
│   ├── ConstructionGhost.gd.uid
│   ├── CraftingMenu.gd
│   ├── CraftingMenu.gd.uid
│   ├── CtrlInventoryStackedCustom.gd
│   ├── CtrlInventoryStackedCustom.gd.uid
│   ├── CtrlInventoryStackedListItem.gd
│   ├── CtrlInventoryStackedListItem.gd.uid
│   ├── CtrlInventoryStackedlistHeaderItem.gd
│   ├── CtrlInventoryStackedlistHeaderItem.gd.uid
│   ├── Documentation.gd
│   ├── Documentation.gd.uid
│   ├── EquipmentSlot.gd
│   ├── EquipmentSlot.gd.uid
│   ├── EquippedItem.gd
│   ├── EquippedItem.gd.uid
│   ├── EscapeMenu.gd
│   ├── EscapeMenu.gd.uid
```
## Relevant Files
- `Scenes/UI/CtrlInventoryStackedCustom.tscn`
- `Scripts/CtrlInventoryStackedCustom.gd`
### Proposed New Files
- `Tests/Unit/test_context_menu_options.gd` - Unit tests for context menu item visibility.
### Existing Files Modified
- `Scripts/CtrlInventoryStackedCustom.gd` - Build menu dynamically to hide inapplicable options.
- `Scenes/UI/CtrlInventoryStackedCustom.tscn` - Ensure node setup supports runtime menu updates.

### Notes
- Unit tests should typically be placed in /Tests/Unit/.
- Use the existing logic that currently disables options to determine which menu items are removed.
- Keep the ordering of menu options consistent so players recognize familiar actions.

## Tasks
- [ ] 1.0 Refactor context menu building in `CtrlInventoryStackedCustom.gd`
  - [x] 1.1 Locate the method that populates the context menu
  - [x] 1.2 Use existing enable/disable logic to determine valid actions
  - [x] 1.3 Remove menu entries that do not pass the check
- [ ] 2.0 Update `CtrlInventoryStackedCustom.tscn` if needed for dynamic menu
  - [x] 2.1 Review node structure for menu buttons
  - [x] 2.2 Add or adjust containers to support runtime menu updates
- [ ] 3.0 Verify mod signals remain functional with hidden options
  - [ ] 3.1 Test base game context menu actions after refactor
  - [ ] 3.2 Run a sample mod to confirm its actions still emit signals
- [ ] 4.0 Add unit tests verifying valid options appear for various items
  - [x] 4.1 Create `Tests/Unit/test_context_menu_options.gd`
  - [x] 4.2 Test that universal actions like `Drop` always appear
  - [x] 4.3 Test that inapplicable actions are omitted
*End of document*
