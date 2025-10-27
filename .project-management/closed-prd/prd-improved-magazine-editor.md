## 1. Introduction/Overview
The current Item Ranged Editor lists every magazine from all mods in a single scrollable list. As the number of magazines grows this becomes difficult for modders to manage. The goal is to replace this list with a field that accepts dragged magazine items, mirroring the drag-and-drop list behavior used by the itemgroup editor. This will make adding magazine compatibility more intuitive while keeping the resulting JSON format unchanged.

## 2. Goals
- Allow modders to drag a magazine item from the item list and drop it onto a magazines field.
- Support assigning multiple magazines to a ranged item.
- Reject drops that are not magazine items or not items at all.
- Preserve the existing JSON representation of magazine IDs where possible.

## 3. User Stories
- *As a modder*, I want to drag magazine IDs from the items list onto a "Magazines" field so I can specify which magazines a ranged weapon uses.
- *As a modder*, I want to see the selected magazines displayed in an editable list so I can remove entries and review compatibility quickly.

## 4. Functional Requirements
1. The magazine field must allow multiple magazine IDs to be dropped from the items list.
2. When a drop occurs, the system shall validate that the dropped entry represents an item of type `magazine`; invalid entries are ignored.
3. Dropped magazine IDs shall appear in an editable list within the field. Users can remove entries from this list.
4. Saving the ranged item shall store the magazine IDs in the same comma-separated string format used today.
5. Loading an existing ranged item shall populate the list with magazine IDs parsed from the stored string.

## 5. Non-Goals (Out of Scope)
- Filtering magazines by compatibility rules.
- Changing the JSON schema for ranged items beyond the existing comma-separated list of magazine IDs.

## 6. Design Considerations (Optional)
- Use a layout similar to the faction editor's drag-and-drop list field for consistency.

## 7. Technical Considerations (Optional)
- Replicate the drag-and-drop logic from the factions editor (`hostile_grid_container` for example) to enforce magazine validation.
- No new dependencies are required.

## 8. Success Metrics
- Modders can successfully add or remove magazines using drag-and-drop without editing text manually.
- Only magazine items can be added to the field; dropping other item types has no effect.
- Saving and reloading a ranged item yields the same JSON format before and after the feature is implemented.

## 9. Open Questions
- Should the UI display magazine names or only IDs in the list?
- Are there limits on how many magazines can be associated with a single item?

## 10. Referenced PRD-background files
None.
