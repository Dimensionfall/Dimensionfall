## 1. Introduction/Overview
The NPC Editor allows mod creators to create, load, and update NPC definitions through the in-game content editor. It builds on the existing DNpc and RNpc data loading system so that NPC JSON files can be managed without manually editing them. The editor mirrors the StatsEditor layout for simplicity.

## 2. Goals
- Enable mod creators to create new NPC entries via the content editor.
- Allow viewing and editing of existing NPC data.
- Provide a way to delete NPCs from the content list.

## 3. User Stories
- **As a mod creator**, I want to open the NPC editor from the content editor so that I can modify NPC attributes without editing JSON manually.
- **As a mod creator**, I want to create a new NPC entry to add characters for my mod.
- **As a mod creator**, I want to delete NPCs I no longer need.

## 4. Functional Requirements
1. The content editor must include a new content type `DMod.ContentType.NPCS` representing DNpc data.
2. Selecting NPCs in the content list must open the NPC editor scene.
3. The NPC editor must display and allow editing of these fields:
   - sprite (image path)
   - id (string)
   - name (string)
   - description (text)
   - health (integer via spinbox)
4. The editor must provide Load and Save buttons mirroring StatsEditor behavior.
5. Saving must update the DNpc instance, which handles persisting to JSON.
6. The content list must support adding new NPCs and deleting existing ones.

## 5. Non-Goals (Out of Scope)
- Editing NPC behavior, dialogue, quests, or other advanced data.
- Linking NPCs with other content types like quests or factions.

## 6. Design Considerations
- The NPC editor's layout should replicate `StatsEditor.gd` for a consistent look.
- Keep the interface simple: a few input fields and a spinbox for health.

## 7. Technical Considerations
- Use GDScript 4 and Godot 4.4 conventions with tab indentation.
- Follow the saving pattern used in StatsEditor where DNpc manages file writes.
- DNpc should be added to ContentEditor using the new content type constant.

## 8. Success Metrics
- A mod creator can load an existing NPC, modify it, and save changes.
- A mod creator can create a new NPC and have it appear in the mod's NPC JSON files.
- A mod creator can delete an NPC from the content list, removing it from the mod data.

## 9. Open Questions
- None at this time.

## 10. Referenced PRD-background files
- `.project-management/current-prd/feature-specificaiton.md` – original feature request describing DNpc integration and NPC editor scope.
