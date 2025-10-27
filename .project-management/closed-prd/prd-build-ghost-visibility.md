## 1. Introduction/Overview
The build ghost visibility bug occurs when opening the Build Manager in the main game scene (`level_generation`). The construction ghost (a transparent preview of the selected block) does not appear the first time the menu is opened after starting a game. Players must change the selected block for the ghost to show. This feature aims to ensure the ghost is always visible when the Build Manager opens.

## 2. Goals
- Ghost appears at the default build position when the Build Manager is opened.
- Ghost matches the selected block type (default is concrete block).
- Opening the Build Manager after starting a game does not require reselecting a block for the ghost to show.

## 3. User Stories
- *As a single player,* I want the build ghost to appear immediately when I open the Build Manager so I can place blocks without extra steps.
- *As a player,* I want the ghost's appearance to update when I change my block selection so I can preview different block types.

## 4. Functional Requirements
1. The system must instantiate or reveal the `ConstructionGhost` node when the Build Manager opens.
2. The ghost must be positioned at the default build location upon opening.
3. The ghost's mesh/texture must correspond to the currently selected block.
4. Changing the block selection while the Build Manager is open must update the ghost.
5. The ghost must remain visible when first opening the Build Manager after starting the game.

## 5. Non-Goals (Out of Scope)
- Altering block placement mechanics beyond visibility.
- Redesigning the Build Manager UI.

## 6. Design Considerations
- Ghost appearance (transparency and color) is determined by the player's selection; default is the concrete block.

## 7. Technical Considerations
- Investigate where `ConstructionGhost` visibility is toggled in `BuildManager.gd` or related scripts.
- Ensure that the ghost node is properly initialized in `level_generation` and not hidden by default.
- Include debug logging around ghost creation and visibility toggles.

## 8. Success Metrics
- Opening the Build Manager in `level_generation` always shows the construction ghost on first use.
- Ghost updates correctly when changing block selection with no regressions.

## 9. Open Questions
- Are there other menus or actions that might still hide the ghost unexpectedly?
- Should the ghost have any spawn animation or simply appear instantly?

## 10. Referenced PRD-background files
None found.
