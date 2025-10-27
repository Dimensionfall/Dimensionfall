## 1. Introduction/Overview
NPCs (Non-Player Characters) are non-combatant entities that provide world flavor and potential interaction points. This feature introduces the ability to define simple NPC data in JSON, similar to how mobs are defined. It establishes data structures for loading NPC definitions so mods can include them.

## 2. Goals
1. Allow mods to define NPC data using JSON files.
2. Create data classes `Dnpc` and `Rnpc` to load and represent NPCs.
3. Provide a sample NPC named **Hank** within the Dimensionfall mod.

## 3. User Stories
- **As a mod creator**, I want to define NPCs in JSON so I can add characters without modifying game code.
- **As a developer**, I want to load NPC definitions into runtime objects using `Dnpc` and `Rnpc` so the game can access their data.

## 4. Functional Requirements
1. **NPC JSON Format** – Define NPCs in `Mods/<ModName>/Npcs/`. Each entry must include at least:
- `id`: unique string identifier
- `name`: display name
- `description`: short text description
- `sprite`: filename of sprite asset
- `health`: integer, default 100
2. **Data Classes** – Implement `Dnpc` (data) and `Rnpc` (runtime) classes in `Scripts/Gamedata` and `Scripts/Runtimedata` to parse and store NPC data.
3. **Mod Loading** – Extend the mod loading system so NPC JSON files are read during initialization and accessible via `Gamedata` and `Runtimedata`.
4. **Example NPC** – Add a `hank.json` entry under `Mods/Dimensionfall/Npcs/` containing Hank's data (id, name, description, sprite reference, health set to 100).
5. **Unit Test** – Create a test verifying that Hank's data loads into `Gamedata` correctly using the new classes.

## 5. Non-Goals (Out of Scope)
- NPC movement, dialogue, quests, combat, or spawning logic.
- Editor interfaces for creating or editing NPCs.

## 6. Design Considerations (Optional)
- Follow existing JSON structure used for mobs to maintain consistency.
- Place NPC sprites in the same mod folder alongside their JSON files.

## 7. Technical Considerations (Optional)
- Use Godot 4.4 and GDScript 4 syntax with tab indentation.
- Ensure loading functions mirror existing mob loading logic for ease of maintenance.

## 8. Success Metrics
- Game startup reads NPC JSON without errors.
- `Gamedata` contains an entry for "Hank" accessible via its id.
- Unit tests pass showing NPC data was loaded.

## 9. Open Questions
- Should NPCs share any fields with mobs beyond those listed?
- Will future features require linking NPCs to quests or factions?

## 10. Referenced PRD-background files
- No additional PRD-background files were provided.
