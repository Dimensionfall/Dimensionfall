## 1. Introduction/Overview
The current system only uses Intelligence as a bonus for crafting skill checks. Mod creators want the ability to specify a different stat for each crafting recipe so that items can rely on attributes like Dexterity or Strength instead. This feature introduces a configurable stat bonus per recipe, allowing greater flexibility in modded content.

## 2. Goals
- Allow modders to select one stat for each crafting recipe that contributes directly to the required skill.
- Default to no bonus if a stat is not provided.
- Ensure the crafting calculation uses the selected stat in addition to the skill level.

## 3. User Stories
- **As a mod creator**, I want to choose which stat boosts a recipe so that items can scale with different character attributes.
- **As a player**, I want crafting requirements to reflect the intended stat so that characters with high Dexterity (for example) can craft relevant items more easily.

## 4. Functional Requirements
1. **Recipe Editor Field**: The item crafting editor must provide a new field using `DropEntityTextEdit.tscn` to select a single stat reference for each recipe.
2. **Data Model Update**: `DItem` and `RItem` must store this stat reference and expose it for recipe evaluation.
3. **Crafting Calculation**: During crafting, the system must add the selected stat's current value to the crafter's skill level when checking requirements. Formula: `effective skill = skill level + stat value`.
4. **Default Handling**: If no stat is specified, the bonus is zero; the calculation uses only the skill level.
5. **Backward Compatibility**: Existing recipes without a stat remain valid and function with no bonus.

## 5. Non-Goals (Out of Scope)
- Supporting multiple stats for a single recipe.
- Allowing custom formulas for combining stat and skill values.

## 6. Design Considerations (Optional)
- The stat selection field should match other DropEntityTextEdit usages for consistency.
- Validation must restrict input to valid stat entities only.

## 7. Technical Considerations (Optional)
- Follow Godot 4.4 best practices and use GDScript 4 with tab indentation.
- Ensure references between stats and items remain stable when mods are loaded or updated.

## 8. Success Metrics
- Modders can assign a stat bonus in the crafting editor without errors.
- Crafting calculations correctly apply the chosen stat when recipes are tested in gameplay.

## 9. Open Questions
- Should the UI show the effective skill during recipe preview? (Clarify if needed.)

## 10. Referenced PRD-background files
None.
