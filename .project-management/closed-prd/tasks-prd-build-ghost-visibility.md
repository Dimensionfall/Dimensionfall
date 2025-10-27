## Pre-Feature Development Project Tree
```bash
$(cat /tmp/project_tree.txt)
```

## Relevant Files
- `Scripts/BuildManager.gd`
- `Scripts/ConstructionGhost.gd`
- `Scripts/BuildingMenu.gd`
- `Scenes/UI/BuildingMenu.tscn`
- `hud.tscn`
- `level_generation.tscn`

### Proposed New Files
- `Tests/Unit/test_build_ghost_visibility.gd` - Unit tests for Build Ghost visibility logic on menu open and block selection changes.

### Existing Files Modified
- `Scripts/BuildManager.gd` - Show ConstructionGhost when Build Manager opens, update ghost selection, and log events.
- `Scripts/BuildingMenu.gd` - Provide method to query the selected construction option.
- `Scripts/ConstructionGhost.gd` - Add debug logs for visibility state.

### Notes
- Ghost should appear with default block type (`concrete_wall`) when Build Manager opens in `level_generation.tscn`.
- Changing selection in BuildingMenu should update the ghost without closing the menu.

## Tasks
- [x] **1.0 Investigate Build Ghost Initialization**
  - [x] 1.1 Review `level_generation.tscn` for default visibility of `ConstructionGhost`.
  - [x] 1.2 Trace signal connections in `BuildManager.gd` and `BuildingMenu.gd` to understand when `start_building()` runs.
  - [x] 1.3 Verify that the ghost stays hidden on first open because no construction choice event fires.
- [ ] **2.0 Fix Ghost Visibility on Menu Open**
  - [c] 2.1 Add a `get_selected_type_and_choice()` method in `BuildingMenu.gd` to return the current option.
  - [c] 2.2 Update `BuildManager.gd` to call this method when the build menu opens and no build session is active.
  - [c] 2.3 Ensure `start_building()` sets `construction_ghost.visible` and positions it at the default location.
  - [c] 2.4 Update `set_building_state()` to handle visibility toggles when closing the menu.
- [ ] **3.0 Update Ghost When Block Selection Changes**
  - [ ] 3.1 Keep `_on_hud_construction_chosen()` connected to BuildingMenu selection events.
  - [ ] 3.2 Ensure `update_construction_ghost()` immediately changes the ghost mesh/material while the menu remains open.
- [ ] **4.0 Add Debug Logging**
  - [c] 4.1 Insert `print_debug()` statements in `BuildManager.gd` around ghost initialization and visibility changes.
  - [c] 4.2 Insert similar debug logs in `ConstructionGhost.gd` when visibility or rotation changes.
- [ ] **5.0 Create Unit Tests for Visibility Logic**
  - [c] 5.1 Write `test_build_ghost_visibility.gd` using GUT to confirm the ghost appears on first menu open.
  - [c] 5.2 Add a test that changes the selected block and verifies the ghost updates accordingly.
*End of document*
