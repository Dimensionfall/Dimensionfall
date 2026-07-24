## 1. Introduction/Overview
- The itemgroup editor currently allows the same item to be added multiple times, which leads to uncertain spawn counts and potential save/load issues. This PRD defines a fix to ensure each item appears only once per itemgroup for modders.

## 2. Goals
- Ensure itemgroup entries remain unique within the editor.
- Prevent accidental duplication without disrupting existing data.

## 3. User Stories
- **As a modder**, I want the editor to ignore duplicate item drops so that itemgroups remain consistent.

## 4. Functional Requirements
1. When a modder drops an item onto an itemgroup editor, the system must check if the item ID already exists in the group.
2. If the item ID is already present, the drop must be ignored and the itemgroup must remain unchanged.
3. Existing itemgroups should be treated as duplicate-free; the system must not attempt automatic cleanup.
4. Any new duplicates must be prevented without notifying the user with an error.

## 5. Non-Goals
- Cleaning up pre-existing duplicates in itemgroups.
- Supporting nested itemgroups or case-insensitive matching.

## 6. Design Considerations (Optional)
- None.

## 7. Technical Considerations (Optional)
- The fix will involve updating `_handle_item_drop` in `itemgroupeditor.gd` to skip additions when the item ID is already in the list.

## 8. Success Metrics
- Modders can drop items into the itemgroup editor without creating duplicates.

## 9. Open Questions
- None.

## 10. Referenced PRD-background files
- None.
