## Rule: Generating a Maintenance Task list

### Goal  
To guide an AI assistant in creating a detailed, step-by-step task list in Markdown format based on the findings after analyzing the existing codebase. The task list should guide a developer through implementation.


---
### Refactoring & Code Quality Improvement Goals

1. **Code Refactoring & Simplification**  
   Identify functions, modules, or gameplay systems (excluding the `addons/` folder) that could benefit from refactoring and simplifying complex code. Find opportunities to improve readability, maintainability, or reduce code duplication.

2. **Error Handling Review**  
   Review error handling patterns across the codebase and propose improvements to make error messages clearer, logging more consistent, or edge cases better covered.

3. **Bug & Logic Error Identification**  
   Analyze the codebase (excluding `addons/`) for bugs, logic errors, or overlooked edge cases, and create detailed tasks to fix them.

4. **Decouple Tightly Coupled Scripts & Scenes**  
   Identify tightly coupled scripts and scenes and propose strategies to decouple them using best practices such as signals, event buses, or service locators.

5. **Modding System & Content Review**  
   Review mod definitions (items, mobs, tiles, furniture) and data structures in `/mods` for consistency, completeness, and usability improvements. Propose enhancements to the modding tools and in-game editors.

6. **Test Coverage & QA Enhancement**  
   Examine test coverage and propose test cases for weak or untested systems, including mod validation. Use GUT (Godot Unit Test).

7. **Maintainability & Performance Cleanup**  
   Identify performance-critical paths (rendering, AI, loops), as well as unused signals, redundant logic, or poorly organized folders. Propose tasks to improve both runtime efficiency and code structure.

8. **UI/UX Improvement Proposals**  
   Suggest improvements to the game’s UI layout, in-game editor usability, and control responsiveness based on current implementations.

9. **Gameplay Balance Assessment**  
   Evaluate the balance of mechanics such as progression pace, loot distribution, and combat difficulty. Suggest tweaks or new systems to enhance fairness and pacing.

10. **Documentation & Style Consistency**  
    Propose fixes for typos in variable names, labels, comments, or documentation entries. Identify missing or unclear documentation and recommend consistent naming conventions and formatting.

11. **Procedural Generation Improvements**  
    Evaluate procedural systems and suggest ways to increase variety, coherence, modularity, or performance in map or encounter generation.

12. **AI Behavior Improvements**  
    Review AI behaviors and identify opportunities to improve movement, targeting, pathfinding, or adaptive logic.

13. **Lore & Design Implementation Review**  
    Cross-check the implemented content with design documents, roadmap, and lore. Suggest additions or corrections to bring the game closer to its intended narrative and feature set.

14. **Map Categorization and Template Generation**  
    Three map categories are: "urban", "nature", "industrial". Add two more to this list for a total of 5 categories. Review the maps in `/mods/dimensionfall/maps` as an example of what the output should look like. For each category, add two new maps. The new maps must include the following fields: `mapheight`, `mapwidth`, `name`, `weight`, `description`, `id`, `categories`, and `connections`. Include a `levels` array with a value of `[[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]` representing 21 empty levels to allow manual map painting later. Use a name and description that aligns with the chosen category. The end result will be a total of 10 new maps. Exclude integration into existing systems like overmapareas or references.

15. **Add new items**  
    Three item categories are: "urban", "nature", "industrial". Add two more to this list for a total of 5 categories. For each category, analyze the items in `/mods/dimensionfall/items` and propose two new items. Each item must include basic properties and appropriate type-specific fields (e.g., melee stats, food properties). Ensure the new items fit the theme of the game. Use "./Mods/Dimensionfall/Items/9mm.png" as a placeholder sprite for each item. The end result will be a total of 10 new items. Since these are new items, we can exclude any references from consideration.

**16. Add new furniture**
The current furniture categories include: **"urban"**, **"nature"**, and **"industrial"**. As you create new furniture, imagine **two new categories** to expand the total to **five**. For each category, analyze the existing furniture definitions in `/mods/dimensionfall/furniture` and propose **two new furniture pieces**. Each piece must include: id, name, moveable. Ensure the new furniture fits the thematic tone and mechanics of **Dimensionfall**. Use `./Mods/Dimensionfall/furniture/toilet_48.png` as a placeholder sprite for all furniture entries. The final result will be **10 new furniture definitions** total. Since these are new additions, you can **ignore references or cross-links** from existing game data.


---

### Maintenance Task Guidelines

- The primary focus is to clean up and refactor existing code without introducing new functionality.
- Ensure that tasks are actionable, with clear steps and validation.
- Validate fixes through testing, manual checks, or automated procedures.
- Focus on improving code structure, clarity, and reliability.


---

### Process for Generating Maintenance Tasks  

1. **Pick a goal**  
   - Generate a number between 1 and 16 and write it down. Commit to the goal from the 'Refactoring & Code Quality Improvement Goals' that corresponds to the resulting number.

2. **Analyze the codebase**  
   - The AI scans the codebase to identify scripts, scenes, or folders that require maintenance based on the selected refactoring or quality improvement goal.

3. **Phase 1: Generate Parent Tasks**  
   - Based on the codebase analysis, create the file and generate the main, high-level tasks required to implement the feature. Use your judgment on how many high-level tasks to use. It's likely to be about 5. 
   - Present these tasks to the user in the specified format (without sub-tasks yet).  
   - Inform the user: "I have generated the high-level tasks based on the analysis. Ready to generate the sub-tasks? Respond with 'Go' to proceed."

4. **Wait for Confirmation**  
   - Pause and wait for the user to respond with "Go."

5. **Phase 2: Generate Sub-Tasks**  
   - Once the user confirms, break down each parent task into smaller, actionable sub-tasks necessary to complete the parent task. Ensure sub-tasks logically follow from the parent task and cover the implementation details implied by the maintenance goal.

6. **Identify Relevant Files**  
   - Based on the tasks and maintenance goal, identify potential files that will need to be created, modified or removed. List these under the Relevant Files section, including corresponding test files if applicable.

7. **Generate Final Output**  
   - Combine the parent tasks, sub-tasks, relevant files, and notes into the final Markdown structure.

8. **Save Task List**  
   - Save the generated document to `/project-management/current-prd/tasks-[prd-file-name].md`, where `[prd-file-name]` is based on the current goals of the maintenance tasks.

---

## Output  
**Format:** Markdown (`.md`)  
**Location:** `.project-management/current-prd/`  
**Filename:** `tasks-[prd-file-name].md` (e.g., tasks-prd-code-refactor.md)

# Output Format
The generated task list must follow this structure:

```
## Selected maintenance goal
- The randomly generated number + the corresponding maintenance goal so we know if the tasks align with this goal

## Pre-Feature Development Project Tree  
- Use command line tools to get current project tree view, omitting any directory that starts with `.` or verbose nested directories like `addons`, etc...

## Relevant Files  
- Reference *existing* project files here  

### Proposed New Files  
- `path/to/potential/file1.gd` - Brief description of why this file is relevant (e.g., Contains the main component for this feature).  
- `/Tests/Unit/test_file1.gd` - Unit tests for `file1.gd`.  
- `path/to/another/file.gd` - Brief description (e.g., signal broker involvement).  
- `/Tests/Unit/test_file.gd` - Unit tests for `another/file.gd`.  

### Existing Files Modified  
- `scripts/utils/helpers.gd` - Brief description (e.g., Refactor the damage calculation functions).  
- `/Tests/Unit/test_helpers.gd` - Unit tests for `helpers.gd`. 

### Files To Remove  
- `path/to/file_to_remove.gd` - Brief description (e.g., File was no longer in use).  

### Notes  
- Unit tests should typically be placed in `/Tests/Unit/`.

## Tasks

- [ ] 1.0 Parent Task Title
  - [ ] 1.1 [Sub-task description 1.1]
  - [ ] 1.2 [Sub-task description 1.2]
- [ ] 2.0 Parent Task Title
  - [ ] 2.1 [Sub-task description 2.1]
- [ ] 3.0 Parent Task Title (may not require sub-tasks if purely structural or configuration)

```

*End of document*
