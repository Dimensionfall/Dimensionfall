# Dimensionfall Agent Guide

This is the Dimensionfall repository.
# Dimensionfall Agent Guide

This is the Dimensionfall repository.

This is the only `AGENTS.md` file in the repository. Do not search for additional agent instruction files.

---

# Project Overview

Dimensionfall is a moddable survival RPG built with Godot 4.

Most gameplay content is data-driven and stored as JSON inside the `Mods` directory. The project contains an extensive in-game content editor for maintaining game data.

Unless explicitly requested otherwise, extend existing systems instead of introducing new ones.

---

# Repository Structure

## Core Logic & Scenes
- **Scripts/**: Gameplay logic written in GDScript. Includes subdirectories for components and modular logic (e.g., `Mob/`, `Runtimedata/`).
- **Scenes/**: Godot scenes, editor interfaces, and UI layouts.
- **Tests/Unit**: GUT unit tests located here.

## Content & Modding
- **Mods/**: Core game content including maps, *tiles, furniture, items, mobs, quests, etc.* (Note: Most data is in JSON).
- **Defaults/**: Default configurations for player, blocks, and entities.

## Assets & Media
- **Assets/ / Textures/ / Shaders/**: Visual assets, textures, and custom GDShader files.
- **Sounds/ / Images/ / Media/**: Audio (SFX/Music), screenshots, and editor preview media.
- **Documents/**: Technical documentation and design notes.

## Tools & Infrastructure
- **Tools/**: Developer utilities and validation scripts (e.g., `map_validator.py`).
- **addons/**: Third-party plugins (e.g., `gloot` for inventory, `gut` for testing). Do not modify unless explicitly requested.

---

# Coding Standards

- Use Godot 4.x GDScript syntax.
- Follow the existing coding style and use tabs for indentation.
- Add comments only when they improve maintainability.
- Prefer small, focused changes.
- Avoid introducing unnecessary external dependencies.
- Reuse existing systems (especially in `Scripts/` and `Mods/`) whenever practical.

---

# Working Rules

- Work from the current workspace.
- Preserve existing user changes; do not overwrite unrelated files.
- Inspect the current implementation before proposing replacements or refactors.
- Explain unexpected findings or architectural conflicts before making broad changes.
- When changing data formats (JSON/Resource) or serialization, preserve backwards compatibility.

---

# Validation

Validate changes when appropriate for the task. 
**Note:** When adding new files, ensure they are properly recognized by the project via `project.godot`.

Available validation tools include:
- GUT unit tests (`Tests/Unit`)
- Godot headless import/validation
- Project validation scripts in `Tools/`

If validation is performed, report:
- Errors and warnings
- Failed tests
- Notable observations

Do not hide failures.

---

# Development Process

1. **Understand**: Research the existing implementation and relevant documentation.
2. **Implement**: Make the smallest reasonable change to achieve the goal.
3. **Validate**: Run appropriate tests or validation scripts.
4. **Summarize**: Clear description of what was changed.
5. **Report**: Detail any remaining issues or recommended follow-up work.
