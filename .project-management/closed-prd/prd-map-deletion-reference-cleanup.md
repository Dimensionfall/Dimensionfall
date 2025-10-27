## 1. Introduction/Overview
When a modder deletes a map from the content editor, other mod entities may still refer to that map. This feature ensures that deleting a map also removes any references to it across NPC spawn maps, overmap areas, quests, and any additional entities listed in `/maps/references.json`. The goal is to keep mod data consistent without manual cleanup.

## 2. Goals
- Automatically clean up all references to a map when it is deleted through the content editor.
- Prevent deleted maps from appearing in NPC spawn lists, overmap areas, quests, or other entities described in `/maps/references.json`.
- Provide debug messages when references cannot be removed due to missing or locked data.

## 3. User Stories
- **As a mod creator**, I want map deletion to automatically update related entities so that my mod data stays valid.
- **As a mod creator**, I want NPCs and overmap areas to ignore a map once I delete it so that they do not load nonexistent content.
- **As a mod creator**, I want quests to update if a referenced map is removed so that players do not encounter broken objectives.

## 4. Functional Requirements
1. The content editor must allow deleting maps from its list by selecting a map and pressing a delete button.
2. Upon deletion, the system must read `/maps/references.json` to find entities referencing the map ID.
3. For each reference type (e.g., NPC spawn maps, overmap areas, quests), the system must remove the deleted map from those entities.
4. After updating the entities, the system must remove the map's entry from `/maps/references.json`.
5. If any reference removal fails because the target data is missing or locked, the system must log a debug message but continue processing.
6. The update must occur automatically without prompting the user.

## 5. Non-Goals (Out of Scope)
- Handling map files deleted outside of the content editor.
- Creating or modifying UI designs beyond the existing delete button.
- Logging or tracking detailed reports of deletions.

## 6. Design Considerations
- None. The existing content editor UI is sufficient.

## 7. Technical Considerations
- Reference lookups come entirely from `/maps/references.json`. Entities not listed here are not affected.
- Updates should rely on existing classes such as `DNpcs`, `DOvermapareas`, and quest editors where applicable.
- The `DMap` class already has the `delete` and `remove_my_reference_from_all_entities` functions, so it's good to verify that they work as expacted and change them to meet the requirements.

## 8. Success Metrics
- After deleting a map through the content editor, no entity listed in `/maps/references.json` should still reference that map.
- Automated tests validate that NPCs, overmap areas, and quests no longer include the deleted map ID.

## 9. Open Questions
- Are there any other entity types not yet listed in `/maps/references.json` that may need future cleanup?

## 10. Referenced PRD-background files
- None
