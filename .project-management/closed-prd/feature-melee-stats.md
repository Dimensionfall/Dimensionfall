Title: Melee Weapon Bonus Stat Entry

Author: Game Development Team

Objective

Provide mod creators with the ability to assign an existing stat to melee weapons to adjust damage and accuracy bonuses.

Overview

The current melee weapon editor lacks the ability to specify a stat that influences its bonuses. Ranged weapons already allow an accuracy stat, so this feature brings melee weapons up to parity. The stat entry should only accept stat references (no skills or other entities) and leverage DropEntityTextEdit.tscn for consistency.

User Story

As a mod creator, I want to select a stat for melee weapons so that damage and accuracy bonuses can be tied to that stat.

Functional Requirements

UI Update

Add a stat entry field to the melee weapon editor using DropEntityTextEdit.tscn.

The field should match the style and behavior of the ranged weapon editor’s accuracy stat field.

Validation

Restrict selection to valid stats. Skills or unrelated entities must be rejected.

Default value remains blank unless specified by the mod creator.

Data Handling

The chosen stat is stored with the weapon configuration and used to modify damage and accuracy calculations.

Existing stats do not require any modification.

Editor Workflow

When editing or creating a melee weapon, the stat field should allow drop-down search or manual entry, consistent with other stat fields.

The weapon preview should update to reflect the bonus stat’s effects where applicable.

Non-Functional Requirements

Follow Godot 4 best practices with GDScript 4 syntax and use tab-based indentation.

Keep functionality decoupled via signals and maintain clarity with short, focused functions in any related scripts.

Ensure that the new field does not disrupt existing editor workflows.

Acceptance Criteria

A new stat entry field appears in the melee weapon editor and behaves like the one used for ranged weapon accuracy.

Only valid stats can be selected; skills or unrelated entities cannot be dropped into this field.

The chosen stat affects damage and accuracy bonuses during gameplay as expected.

This PRD defines the scope and desired behavior for introducing a stat-selection field in the melee weapon editor. It aligns with the approach used for ranged weapon accuracy while ensuring only relevant stats are accepted. This will allow mod creators to scale melee weapons based on player statistics.
