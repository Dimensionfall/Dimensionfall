## 1. Introduction/Overview
Players currently see every possible action in an item's context menu when right-clicking, but unavailable actions appear disabled. This can confuse casual players by implying the action might become available later. The goal is to hide any inapplicable actions so the context menu only shows valid options for the selected item(s).

## 2. Goals
- Ensure the context menu displays only actions that can be performed on the selected item(s).
- Prevent players from seeing disabled context menu options.
- Keep existing inventory and modding systems intact.

## 3. User Stories
- **As a player**, when I right-click an item, I only see actions that make sense for that item so I'm not misled by greyed-out options.
- **As a player**, I can still perform universal actions like "Drop" on any item since those always apply.

## 4. Functional Requirements
1. The inventory context menu must dynamically include only the actions that apply to the selected item(s).
2. Actions that do not apply must be omitted entirely from the menu rather than shown disabled.
3. New actions added in mods or future updates should follow the same rule—hidden if inapplicable to the current selection.
4. The feature should work in `CtrlInventoryStackedCustom.tscn` without requiring items to store extra state.

## 5. Non-Goals (Out of Scope)
- Showing tooltips or explanations for why actions are hidden.
- Changing how item properties determine whether an action is valid.

## 6. Design Considerations
- The context menu should remain compact with only relevant actions displayed.
- Keep existing ordering of actions where possible so players recognize familiar options.

## 7. Technical Considerations
- Use the existing logic that currently disables actions to decide which menu items to remove before display.
- Ensure the change does not break mods that rely on the context menu signals.

## 8. Success Metrics
- Manual testing confirms no disabled actions appear in the context menu for any item.

## 9. Open Questions
- None at this time.

## 10. Referenced PRD-background files
- *(No additional background files were provided.)*
