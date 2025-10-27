## 1. Introduction/Overview
This feature updates tile rotation logic to ensure that all entities stored in a tile's `feature` dictionary rotate correctly when the map rotates. Currently furniture rotation is handled using the legacy `tile.furniture` property and is broken. The goal is to rely entirely on the `feature` dictionary for rotation and audit the codebase for remaining `tile.furniture` references.

## 2. Goals
- Furniture, mobs, item groups or other features that store rotation data in `tile.feature` rotate properly when the map is rotated.
- Remove dependence on the deprecated `tile.furniture` property across the codebase.

## 3. User Stories
- **As a player**, when I rotate a map that contains furniture and mobs, the orientation of those features should remain consistent with the new rotation.
- **As a developer**, I want all scripts to read and write rotation data from `tile.feature` so that future features rely on a single representation.

## 4. Functional Requirements
1. Update `rotate_level_clockwise` in `chunk.gd` to read from `tile.feature` instead of `tile.furniture` when rotating features.
2. Rotate any feature types (e.g., furniture, mob, mobgroup, itemgroup) that include a `rotation` field in their data.
3. Search the codebase for any remaining uses of `tile.furniture` and refactor them to use `tile.feature` where appropriate.

## 5. Non-Goals (Out of Scope)
- Backwards compatibility for maps still using the legacy `furniture` field.
- Adding or updating automated tests for this feature.

## 6. Design Considerations
- Follow GDScript 4 syntax and Godot 4.4 best practices.
- Maintain existing data structures for the unified `feature` dictionary.

## 7. Technical Considerations
- Update logic to handle rotation for any entity type stored in `tile.feature` that defines a `rotation` attribute.
- Ensure that no leftover references to `tile.furniture` remain after the audit.

## 8. Success Metrics
- Rotating a map results in correctly oriented features.
- No remaining code references to `tile.furniture`.

## 9. Open Questions
- Are there any edge cases where some features should not rotate or have additional rotation rules?

## 10. Referenced PRD-background files
- `.project-management/current-prd/feature-specification.md` – contains original details of the feature request to update `rotate_level_clockwise` to use the `feature` property.
