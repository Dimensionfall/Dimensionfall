## 1. Introduction/Overview
When right-clicking a gun in the inventory, players see an "Unload" option even if the gun has no magazine attached. This leads to confusion, especially for new players, because selecting the option does nothing. The feature aims to hide the "Unload" option entirely when no magazine is present, preventing misleading or useless menu entries.

## 2. Goals
- Only show the "Unload" context menu option when the gun currently has a detachable magazine inserted.
- Keep the inventory experience straightforward for new players.

## 3. User Stories
- **As a new player**, when I right-click a gun without a magazine, I should not see an "Unload" option, so I know there is nothing to remove.
- **As a new player**, when a magazine is inserted, right-clicking the gun shows the "Unload" option so I can remove the magazine if I want.

## 4. Functional Requirements
1. The context menu for guns must check if a magazine is inserted before adding the "Unload" option.
2. If no magazine is detected, the "Unload" option must not appear.
3. The check should ignore chambered rounds and rely solely on the magazine's presence.
4. The change should apply to all ranged weapons in the game.

## 5. Non-Goals (Out of Scope)
- Handling guns with internal/fixed magazines (none currently exist).
- Adding extra user feedback beyond hiding the option.

## 6. Design Considerations (Optional)
- Maintain existing ordering of context menu options so players recognize familiar actions.

## 7. Technical Considerations (Optional)
- Reuse the same logic that determines when a gun can be unloaded; simply skip adding the menu item if the check fails.

## 8. Success Metrics
- Manual tests confirm guns without magazines never show the "Unload" option.
- No regressions in existing inventory or mod functionality.

## 9. Open Questions
- None.

## 10. Referenced PRD-background files
- `.project-management/current-prd/feature-specification.md` – initial description of the unload option appearing without a magazine.
