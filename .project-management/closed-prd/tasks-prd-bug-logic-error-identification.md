## Selected maintenance goal
- 3: Bug & Logic Error Identification

## Pre-Feature Development Project Tree
```
.
./Assets
./Defaults
./Documentation
./Images
./Media
./Mods
./Scenes
./Scripts
./Shaders
./Sounds
./Tests
./Textures
```

## Relevant Files
- Reference *existing* project files here

### Proposed New Files
- `/Tests/Unit/test_state_transitions.gd` - Unit tests for state signal handling.
- `/Tests/Unit/test_mob_ranged_attack.gd` - Unit tests for ranged attack timing and speed.

### Existing Files Modified
- `Scripts/Mob/state.gd` - Rename `Transistioned` signal for clarity.
- `Scripts/Mob/StateMachine.gd` - Connect to renamed `Transitioned` signal.
- `Scripts/Mob/MobAttack.gd` - Emit `Transitioned` for state changes.
- `Scripts/Mob/MobIdle.gd` - Emit `Transitioned` for state changes.
- `Scripts/Mob/MobRangedAttack.gd` - Emit `Transitioned` for state changes.
- `Scripts/Mob/MobFollow.gd` - Emit `Transitioned` for state changes.
- `Tests/Unit/test_mob.gd` - Update test for `Transitioned` signal.
- `Tests/Unit/test_player.gd` - Update test for `Transitioned` signal.

### Files To Remove
- None

### Notes
- Unit tests should typically be placed in `/Tests/Unit/`.

## Tasks
- [x] 1.0 Fix misnamed mob state transition signal
  - [x] 1.1 In `Scripts/Mob/state.gd`, rename the `Transistioned` signal to `Transitioned`.
  - [x] 1.2 Update all references to the old signal name across the codebase.
  - [x] 1.3 Add unit tests (`Tests/Unit/test_state_transitions.gd`) verifying that `Transitioned` fires correctly when state changes occur.

*End of document*
