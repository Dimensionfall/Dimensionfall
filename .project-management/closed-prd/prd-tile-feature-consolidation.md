## 1. Introduction/Overview
This feature consolidates tile entity data (furniture, mobs, mob groups, and item groups) into a single `feature` dictionary stored on each tile. The change improves code readability and prevents conflicting data from being assigned to the same tile.

## 2. Goals
- Ensure each tile stores feature information in a unified dictionary.
- Maintain compatibility with maps saved in the old format.
- Update the map editor and all relevant data classes to read and write the new format.

## 3. User Stories
- **As a developer**, I want tile data stored in one structure so that I no longer handle multiple mutually exclusive keys during editing or map generation.
- **As a developer**, I want old map files to load correctly even after the change, so that existing content does not break.

## 4. Functional Requirements
1. Loading logic must detect legacy fields (`mob`, `mobgroup`, `furniture`, `itemgroups`) and convert them into the new `feature` dictionary.
2. Saving logic must store tile feature data only under the `feature` key when present.
3. Map editor scripts must read from and write to `tileData.feature`.
4. Data classes and helper scripts must use `feature.type` to determine the tile's entity and remove features accordingly.
5. Unit tests must verify migration from legacy map data, correct editing behavior, and proper display of features.

## 5. Non-Goals (Out of Scope)
- Modifying the map editor's UI layout or visual elements.
- Any changes to player inventory logic, network features, or unrelated systems.

## 6. Design Considerations
- No UI or design changes are necessary; only data structure updates are required.

## 7. Technical Considerations
- None identified beyond maintaining compatibility with existing map data.

## 8. Success Metrics
- Legacy maps load without errors and convert to the new structure when saved.
- Map editor operations correctly use `tileData.feature` with no redundant fields.

## 9. Open Questions
- None.

## 10. Referenced PRD-background files
- *None.*
