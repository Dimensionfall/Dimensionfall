## 1. Introduction/Overview
- Introduces an `npc_tile` feature for the map editor brush composer, enabling creators to mark coordinates where NPCs may spawn.
- Solves the current inability to designate NPC spawn locations on maps.

## 2. Goals
- Allow map designers to paint `npc_tile` locations on maps.
- Ensure `npc_tile` data (coordinates and rotation) persists through save/load.
- Provide feedback during map processing that `npc_tile` entries were handled.

## 3. User Stories
- As a mod creator, I can place an `npc_tile` on the map so that any NPC may spawn at that coordinate.
- As a mapper, I replace existing map features with `npc_tile` to mark NPC spawn points without specifying the NPC type.

## 4. Functional Requirements
1. The brush composer must include an `npc_tile` button styled exactly like the existing `null_tile` button and using `res://Scenes/ContentManager/Mapeditor/Images/nulltile_32.png` as its icon.
2. Users must be able to paint `npc_tile` onto map coordinates via the brush composer.
3. Painting an `npc_tile` onto a coordinate that already has `mob`, `mobgroup`, `furniture`, or `itemgroup` must replace the existing feature with `npc_tile`.
4. Each `npc_tile` must store the rotation set at paint time (0, 90, 180, or 270 degrees).
5. When saving a map, `npc_tile` coordinates and rotation must be serialized to the map JSON through DMap and DMaps.
6. When `map_manager.gd` processes the map, it must log that an `npc_tile` was processed and allow subsequent placement of other features to overwrite the `npc_tile` if needed.

## 5. Non-Goals (Out of Scope)
- Actual spawning of NPCs in-game.
- Defining which specific NPC spawns at an `npc_tile`.

## 6. Design Considerations (Optional)
- The `npc_tile` button and brush icon should visually match the current `null_tile` button and icon.

## 7. Technical Considerations (Optional)
- `npc_tile` data should integrate with existing map serialization via DMap and DMaps.
- Edge cases are expected to be handled by the existing map editor logic.

## 8. Success Metrics
- Map files retain `npc_tile` coordinates and rotations after save/load cycles.
- During processing, `map_manager.gd` logs each `npc_tile` encountered.

## 9. Open Questions
- None identified.

## 10. Referenced PRD-background files
- None.
