# Task Module - As specified in AGENTS.md, this is triggered when the task description is 'TaskMaster'
You have entered the codex task-based work module. The task list file for this project is `.project-management\current-prd\tasks.*.md`.  Open it to view the tasks for this feature.  It will contain the current status of tasks in this format :
- [x] 1.0 Parent Task Title 
  - [x] 1.1 [Sub-task description 1.1]
  - [c] 1.2 [Sub-task description 1.2]
- [ ] 2.0 Parent Task Title
  - [ ] 2.1 [Sub-task description 2.1]
- [ ] 3.0 Parent Task Title
`[x]`: Finished
`[c]`: Committed
`[ ]`: Open
Follow the remaining guidelines below to manage this file.

## Task Implementation
- **Task committment**
  1. Anayze the tasks and select those that can be completed in one task run
  2. Make your selections by marking them complete and saving the file like so `[c]`
- **Completion protocol:**  
  1. When you finish a **sub‑task**, immediately mark it as completed by changing `[ ]` to `[x]`.  
  2. If **all** subtasks underneath a parent task are now `[x]`, also mark the **parent task** as completed. 

## Task List Maintenance

1. **Update the task list as you work:**
   - Mark tasks and subtasks as completed (`[x]`) per the protocol above.
   - Add new tasks as they emerge.

2. **Maintain the “Relevant Files” section:**
   - List every file created or modified.
   - Give each file a one‑line description of its purpose.

## AI Instructions

When working with task lists, the AI must:

1. Regularly update the task list file after finishing any significant work.
2. Follow the completion protocol:
   - Mark each finished **sub‑task** `[x]`.
   - Mark the **parent task** `[x]` once **all** its subtasks are `[x]`.
3. Add newly discovered tasks.
4. Keep “Relevant Files” accurate and up to date with new or yet-unreferenced existing file changes
5. Before starting work, check which sub‑task is next.
6. After implementing a sub‑task, update the file 
*End of document*