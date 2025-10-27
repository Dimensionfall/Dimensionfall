## 1. Introduction/Overview
The current game allows players to reload magazines while they are in the player's own inventory. However, attempting to reload a magazine located in the proximity inventory (e.g., a nearby container or loot pile) does nothing. This feature will ensure that magazines in the proximity inventory can be reloaded using available bullets, moving the magazine to the player's inventory if possible.

## 2. Goals
- Allow reloading of magazines directly from the proximity inventory.
- Prioritize using bullets from the player's inventory, then fall back to bullets from the proximity inventory.
- Move the magazine to the player's inventory when reloading, if space is available; otherwise reload it in place.
- If no bullets are available, attempt to move the magazine to the player's inventory without reloading. If it cannot be moved, no action occurs.

## 3. User Stories
1. **As a player**, I want to reload magazines found in a nearby container so that I can quickly prepare them for use without manually transferring them first.
2. **As a player**, I want the reload action to use my existing bullets first so I don't accidentally spend container ammo I might want to keep separate.
3. **As a player**, I want the reload action to do nothing if I lack both inventory space and ammo so that I can see consistent behavior.

## 4. Functional Requirements
1. The system must detect when the "Reload" option is used on a magazine in the proximity inventory.
2. When reloading, the game must pull bullets from the player's inventory before using bullets from the proximity inventory.
3. If there is space in the player's inventory, the magazine must be moved there before reloading.
4. If the player's inventory is full, the magazine must reload in place within the proximity inventory, using available ammo.
5. If there are no bullets available in either inventory, the system must only attempt to move the magazine to the player's inventory without providing feedback; if it cannot move, no change occurs.
6. After reloading, the magazine's displayed bullet count must update to reflect the new total.
7. This feature applies to the single existing magazine type only.

## 5. Non-Goals (Out of Scope)
- Support for additional magazine types beyond the existing one.
- UI feedback messages or error dialogs when reloading fails or succeeds.
- Changes to the base reload logic for magazines already in the player's inventory.

## 6. Design Considerations (Optional)
- The proximity inventory UI already displays items near the player. The existing reload option should remain in the right-click context menu for magazines in this inventory.
- No new UI elements are required beyond updating the magazine's bullet count.

## 7. Technical Considerations (Optional)
- Ensure the reloading logic checks the player's inventory first, then the proximity inventory.
- Moving the magazine between inventories must respect existing capacity checks.
- Use GDScript 4 syntax and adhere to Godot 4.4 practices for any code changes.

## 8. Success Metrics
- The magazine's bullet count increases when reloaded from the proximity inventory under valid conditions.
- No crashes or unintended item duplication occurs during this process.

## 9. Open Questions
- None at this time.

## 10. Referenced PRD-background files
- None.
