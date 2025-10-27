## Rule: Generating a Content Creation Task List

### Goal  
To guide an AI assistant in creating a detailed, step-by-step content creation task list in Markdown format based on the findings after analyzing the existing game data. The task list should guide a developer through implementing new content that aligns with the design and systems of Dimensionfall.

---

### Content Creation Goals

1. **Map Categorization and Template Generation**  
   Three map categories are: "urban", "nature", "industrial". Add two more to this list for a total of 5 categories. Review the maps in `/mods/dimensionfall/maps` as an example of what the output should look like. For each category, add two new maps. The new maps must include the following fields: `mapheight`, `mapwidth`, `name`, `weight`, `description`, `id`, `categories`, and `connections`. Include a `levels` array with a value of `[[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]` representing 21 empty levels to allow manual map painting later. Use a name and description that aligns with the chosen category. The end result will be a total of 10 new maps. Exclude integration into existing systems like overmapareas or references.

2. **Add New Items**  
   Three item categories are: "urban", "nature", "industrial". Add two more to this list for a total of 5 categories. For each category, analyze the items in `/mods/dimensionfall/items` and propose two new items. Each item must include basic properties and appropriate type-specific fields (e.g., melee stats, food properties). Ensure the new items fit the theme of the game. Use "./Mods/Dimensionfall/Items/9mm.png" as a placeholder sprite for each item. The end result will be a total of 10 new items. Since these are new items, we can exclude any references from consideration.

3. **Add New Furniture**  
   The current furniture categories include: "urban", "nature", and "industrial". As you create new furniture, imagine two new categories to expand the total to five. For each category, analyze the existing furniture definitions in `/Mods/Dimensionfall/furniture` and propose two new furniture pieces. Each piece must include: `id`, `name`, and `moveable`. Ensure the new furniture fits the thematic tone and mechanics of Dimensionfall. Use `./Mods/Dimensionfall/furniture/toilet_48.png` as a placeholder sprite for all furniture entries. The final result will be 10 new furniture definitions total. Since these are new additions, you can ignore references or cross-links from existing game data.

4. **Maintain and Expand Itemgroups**  
   Review existing itemgroups in `/Mods/Dimensionfall/Itemgroups` and analyze the items in `/Mods/Dimensionfall/items`. Propose new itemgroups where appropriate, and add existing or newly created items to the correct groups. Ensure each itemgroup serves a meaningful gameplay purpose and fits thematically. Avoid duplicate entries. The goal is to improve item distribution, random generation, and loot balance. Avoid integrating the itemgroup with other entities as this should be a manual task (for example altering references or maps or furniture that might use the itemgroup).

5. **Add Tiles Based on Map Context**  
   Analyze existing maps in `/mods/dimensionfall/maps` and determine which environment-specific tiles are missing. For example, an industrial map might require a reinforced wall tile that doesn't yet exist. Create definitions for up to five new tiles that complement the environments represented by the maps. Include appropriate `id`, `name`, and `category` fields. Use `./Mods/Dimensionfall/tiles/1.png` as a placeholder sprite and ensure the tile is suitable for placement in procedural or hand-crafted environments.

---

### Content Task Guidelines

- Focus only on adding or expanding content — not code or performance improvements.
- Ensure that each content task includes descriptive names, context-appropriate settings, and uses existing folders and conventions.
- Use placeholder sprites instead of new sprites, all functional and thematic data must be complete.
- Tasks must be actionable and ready to implement by a developer or designer.

---

### Process for Generating Content Tasks  

1. **Pick a goal**  
   - Generate a number between 1 and 5 and write it down. Commit to the goal from the 'Content Creation Goals' that corresponds to the resulting number.

2. **Analyze the mod files**  
   - The AI scans content definitions in `/Mods/Dimensionfall` to identify opportunities to expand content under the selected goal.

3. **Phase 1: Generate Parent Tasks**  
   - Based on the content analysis, create the file and generate the high-level tasks required to implement the new content. Expect about 1-2 top-level content creation tasks.  
   - Present these tasks to the user in the specified format (without sub-tasks yet).  
   - Inform the user: "I have generated the high-level tasks based on the analysis. Ready to generate the sub-tasks? Respond with 'Go' to proceed."

4. **Wait for Confirmation**  
   - Pause and wait for the user to respond with "Go."

5. **Phase 2: Generate Sub-Tasks**  
   - Once the user confirms, break down each parent task into smaller, actionable sub-tasks necessary to complete the parent task. Ensure sub-tasks logically follow from the parent task and cover the implementation details implied by the content goal.

6. **Identify Relevant Files**  
   - Based on the tasks and content goal, identify potential files that will need to be created or updated. List these under the Relevant Files section, including sample asset paths if needed.

7. **Generate Final Output**  
   - Combine the parent tasks, sub-tasks, relevant files, and notes into the final Markdown structure.

8. **Save Task List**  
   - Save the generated document to `/project-management/current-prd/tasks-[prd-file-name].md`, where `[prd-file-name]` is based on the current goals of the content tasks.

---

## Output  
**Format:** Markdown (`.md`)  
**Location:** `.project-management/current-prd/`  
**Filename:** `tasks-[prd-file-name].md` (e.g., `tasks-prd-content-additions.md`)


# Output Format
The generated task list must follow this structure:

```
## Selected content goal
- The randomly generated number + the corresponding content goal so we know if the tasks align with this goal

## Pre-Feature Development Project Tree  
- Use command line tools to get current project tree view, omitting any directory that starts with `.` or verbose nested directories like `addons`, etc...

## Relevant Files  
- Reference *existing* project files here  

### Proposed New Files  
- `path/to/potential/file1.json` - Appliccable to maps. Brief description of new map if appliccable to the current goal

### Existing Files Modified  
- `Mods/Dimensionfall/type/my_type.json` - Brief description (e.g., add new items / furniture / itemgroups).  

## Tasks

- [ ] 1.0 Parent Task Title
  - [ ] 1.1 [Sub-task description 1.1]
  - [ ] 1.2 [Sub-task description 1.2]
- [ ] 2.0 Parent Task Title
  - [ ] 2.1 [Sub-task description 2.1]
- [ ] 3.0 Parent Task Title (may not require sub-tasks if purely structural or configuration)

```

*End of document*
