# Agent Guide

This is the Dimensionfall repository.
This is the only AGENTS.md file, do not look for others.

## Special Task Instructions
- If the user task message consists of just the word 'TaskMaster' then open .project-management/process-tasks-cloud.md for instructions, otherwise ignore this file.
- If the user task message consists of just the word CreatePrd then open .project-management/create-prd.md for instructions, otherwise ignore this file.
- If the user task message consists of just the word CreateTasks then open .project-management/generate-tasks.md for instructions, otherwise ignore this file.
- If the user task message consists of just the word ClosePrd then open .project-management/close-prd.md for instructions, otherwise ignore this file.
- If the user task message consists of just the word 'MaintenanceTasks' then open .project-management/maintenance-tasks.md for instructions, otherwise ignore this file.
- If the user task message consists of just the word 'ContentTasks' then open .project-management/content-tasks.md for instructions, otherwise ignore this file.

## Relevant Folders
1. Documentation: Used for users to understand the game and code
2. Mods: Contains sprites and json files. These make up the contents of the game
3. Scenes: Contains scenes that Godot uses in its function
4. Scripts: The scripts that support the scenes. Most of the coding is done here
5. Tests/Unit: Unit tests are located here
6. Addons: These support the game as dependencies. Exclude everything in this folder from modification.

## Conventions
-  Add comments where needed.
-  Use the GDScript 4 syntax.
-  Use Godot 4.4 best practices.
-  Use tabs for indentation.

## Development Flow
1. Start tasks from the workspace.
2. After modifications, run `gdformat path/to/modified_script.gd` on any script that was modified to properly format it.
3. Run the GUT tests:
   ```bash
   godot --headless --import
   godot --headless -s --path "$PWD" addons/gut/gut_cmdln.gd -gexit -gdir=res://Tests/Unit
   ```
4. Report back any tests that fail.
5. Make sure that the requirements are satisfied.
