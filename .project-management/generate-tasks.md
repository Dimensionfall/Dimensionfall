
# Rule: Generating a Task List from a PRD

## Goal

To guide an AI assistant in creating a detailed, step-by-step task list in Markdown format based on an existing Product Requirements Document (PRD). The task list should guide a developer through implementation.

## Output

- **Format:** Markdown (`.md`)
- **Location:** `/.project-management/current-prd/` 
- **Filename:** `tasks-[prd-file-name].md` (e.g., `tasks-prd-user-profile-editing.md`)` 

## Process

1.  **Receive PRD Reference:** The user points the AI to a specific PRD file
2.  **Analyze PRD:** The AI reads and analyzes the functional requirements, user stories, and other sections of the specified PRD.
3.  **Phase 1: Generate Parent Tasks:** Based on the PRD analysis, create the file and generate the main, high-level tasks required to implement the feature. Use your judgement on how many high-level tasks to use. It's likely to be about 5. If the parent task is informed by a referenced file in the PRD (like a feature specification), make note of the full file path in the task description. Present these tasks to the user in the specified format (without sub-tasks yet). Inform the user: "I have generated the high-level tasks based on the PRD. Ready to generate the sub-tasks? Respond with 'Go' to proceed."
4.  **Wait for Confirmation:** Pause and wait for the user to respond with "Go".
5.  **Phase 2: Generate Sub-Tasks:** Once the user confirms, break down each parent task into smaller, actionable sub-tasks necessary to complete the parent task. Ensure sub-tasks logically follow from the parent task and cover the implementation details implied by the PRD.
6.  **Identify Relevant Files:** Based on the tasks and PRD, identify potential files that will need to be created or modified. List these under the `Relevant Files` section, including corresponding test files if applicable.
7.  **Generate Final Output:** Combine the parent tasks, sub-tasks, relevant files, and notes into the final Markdown structure.
8.  **Save Task List:** Save the generated document to `/.project-management/current-prd/tasks-[prd-file-name].md`, where `[prd-file-name]` matches the base name of the input PRD file (e.g., if the input was `prd-user-profile-editing.md`, the output is `tasks-prd-user-profile-editing.md`).

## Output Format

The generated task list _must_ follow this structure:

```markdown
## Pre-Feature Development Project Tree
- Use command line tools to get current project tree view, ommitting any directory that starts with `.` or verbose nested directories like addons, etc...  
## Relevant Files
- Reference *existing* project files here
### Proposed New Files
- `path/to/potential/file1.gd` - Brief description of why this file is relevant (e.g., Contains the main component for this feature).
- `/Tests/Unit/test_file1.gd` - Unit tests for `file1.gd`.
- `path/to/another/file.gd` - Brief description (e.g., signal broker involvement).
- `/Tests/Unit/test_file.gd` - Unit tests for `another/file.gd`.
### Existing Files Modified
- `scripts/utils/helpers.gd` - Brief description (e.g., Utility functions needed for calculations).
- `/Tests/Unit/test_helpers.gd` - Unit tests for `helpers.gd`.

### Notes

- Unit tests should typically be placed in /Tests/Unit/.
- Summarize Design and Technology considerations from the PRD not specifically referenced in tasks.

## Tasks

- [ ] 1.0 Parent Task Title
  - [ ] 1.1 [Sub-task description 1.1]
  - [ ] 1.2 [Sub-task description 1.2]
- [ ] 2.0 Parent Task Title
  - [ ] 2.1 [Sub-task description 2.1]
- [ ] 3.0 Parent Task Title (may not require sub-tasks if purely structural or configuration)
*End of document*
```

## Interaction Model

The process explicitly requires a pause after generating parent tasks to get user confirmation ("Go") before proceeding to generate the detailed sub-tasks. This ensures the high-level plan aligns with user expectations before diving into details.

## Target Audience

Assume the primary reader of the task list is a **junior developer** who will implement the feature.
