## 1. Introduction/Overview
NPCs currently store base information like id, name, description, sprite, and health. This feature introduces a new `spawn_maps` list so mod creators can define which maps an NPC may appear on along with weighted probabilities. The goal is to allow configuring spawn locations through the NPC editor without implementing actual spawn mechanics yet.

## 2. Goals
- Extend DNpc and RNpc data models to include a weighted `spawn_maps` array.
- Allow adding, editing, and removing spawn maps through the NPC editor UI.
- Enable dragging maps from any mod's content list onto the NPC editor.
- Persist spawn map data to NPC JSON files and reload it accurately.
- Provide automated tests verifying save and load behavior for `spawn_maps`.

## 3. User Stories
- **As a mod creator**, I want to specify which maps an NPC can spawn on so that I control their placement.
- **As a mod creator**, I want to set spawn weights with a spinbox so that certain maps are more likely than others.
- **As a mod creator**, I want to drag a map entry onto the NPC editor to quickly assign it as a spawn location.
- **As a mod creator**, I want to remove maps from the list if an NPC should no longer spawn there.

## 4. Functional Requirements
1. The NPC JSON schema must include a `spawn_maps` array. Each entry contains:
   - `map_id` (string) referencing a map.
   - `weight` (positive integer, default 100).
2. RNpc and DNpc classes must load and save the `spawn_maps` property.
3. DNpc must track relations between maps and NPCs so dependencies between mods remain consistent.
4. The NPC editor must display a list of spawn maps in a grid container similar to `overmap_area_region_editor.gd`.
5. Users can drag map entries from any mod's map list onto this grid to create new entries.
6. Each entry shows the map id with an editable spinbox limited to positive numbers for the weight.
7. Users must be able to remove a spawn map entry from the list.
8. There is no limit on how many maps may be assigned.
9. Saving the NPC updates its JSON file with the `spawn_maps` list; loading repopulates the editor accordingly.
10. Unit tests must cover saving and reloading NPCs with spawn maps and basic editor interactions.

## 5. Non-Goals (Out of Scope)
- Implementing the actual spawn mechanics in gameplay.
- Advanced spawn logic like regional restrictions or dynamic weighting.

## 6. Design Considerations
- Reuse layout patterns from `overmap_area_region_editor.gd` where maps are dropped onto a `maps_grid_container`.
- Use a SpinBox control for editing weights, constrained to values greater than zero.
- Maintain Godot 4.4 best practices and GDScript 4 style with tab indentation.

## 7. Technical Considerations
- DNpc and RNpc must update relation tracking when maps from other mods are referenced.
- The spawn map list structure should mirror how OvermapArea handles weighted entries for consistency.
- Tests should utilize the existing GUT framework under `Tests/Unit`.

## 8. Success Metrics
- NPC JSON files correctly store `spawn_maps` after editing and saving.
- Opening an NPC with existing spawn maps shows all entries with proper weights in the editor.
- All new unit tests pass.

## 9. Open Questions
- Should newly created NPCs start with an empty `spawn_maps` list or contain a default entry?
- What visual feedback should be provided when dragging a map onto the editor?

## 10. Referenced PRD-background files
- `.project-management/current-prd/feature-specification.md` – initial request detailing the need for weighted map configuration in NPC data.
