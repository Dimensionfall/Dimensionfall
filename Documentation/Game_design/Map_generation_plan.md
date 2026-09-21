You have now completed the **foundation, minimal generator, general placement-primitives, manual evaluation-harness, features/furniture, and building-geometry milestones**. The project can generate and batch-test structurally valid, visually recognizable 32×32 outdoor Dimensionfall maps from compact recipes, and it can now place furniture features and physically enclosed multi-level buildings; it cannot yet compose towns, roads-as-semantic-networks beyond map-local routes, or complete gameplay locations.

## Overall goal

The long-term objective is a map-authoring pipeline where an agent describes a map at a meaningful design level rather than manually writing thousands of JSON entries.

```text
Map concept
    ↓
Compact recipe
    ↓
Deterministic generator
    ↓
Complete Dimensionfall map JSON
    ↓
Automated validation and tests
    ↓
Godot/editor smoke test
    ↓
Playable map
```

For example, the eventual recipe should express concepts such as:

```text
Create a forest settlement with:
- a road entering from the west
- three small buildings around a square
- a pond to the southeast
- trees around the perimeter
- indoor and outdoor areas
```

The generator should handle the mechanical work:

* converting top-down coordinates and logical z values to level and tile-array indices;
* producing all 1024 entries per populated level;
* inserting valid tile and furniture IDs;
* generating metadata;
* creating areas and connections;
* enforcing horizontal and vertical bounds;
* creating and validating transitions between logical levels;
* producing deterministic output;
* rejecting invalid designs before they reach Godot.

The agent remains responsible for map intent and composition. The generator remains responsible for correctness.

---

# Current state

## 1. Agent guidance: complete

`AGENTS.md` was revised to work well with Hermes rather than relying on Codex-specific or TaskMaster-specific behavior.

The repository guidance is now intended to be:

* tool-independent;
* repository-specific;
* suitable for multiple Hermes profiles;
* focused on project structure, coding standards, validation, and safe editing;
* free of personal Docker, worktree, Kanban, and model configuration details.

This gives the map-making agents a stable set of repository instructions.

## 2. Existing-map sanitation: complete

The project now sanitizes malformed tile data when maps are serialized.

Corrupt or incomplete tile dictionaries—particularly entries missing a valid tile ID—are converted to the established empty-tile representation:

```json
{}
```

A GUT test was added around this behavior.

This protects existing and generated maps from lingering malformed tile entries.

## 3. Map validator improvements: complete

`Tools/map_validator.py` now understands the fixed Dimensionfall map dimensions.

It rejects:

* `mapwidth` values other than `32`;
* `mapheight` values other than `32`;
* populated levels with fewer than 1024 entries;
* populated levels with more than 1024 entries.

It continues accepting unused levels represented as:

```json
[]
```

The validator successfully caught the original invalid generated prototype:

```text
width: 12
height: 8
level 10 entries: 96
```

That is an important milestone because the validator now independently enforces the structural assumptions used by the generator.

## 4. Recipe-driven generator prototype: complete

The merged work added:

```text
Tools/map_generator.py
Tools/examples/map_recipe.json
Tools/tests/test_map_generator.py
Documentation/Modding/map_recipe_generator.md
```

The generator currently supports:

* map ID;
* display name;
* description;
* deterministic integer seed;
* legacy-compatible ground-level generation at level-array index 10;
* explicit logical levels from `z: -10` through `z: 10`;
* multiple populated levels using per-placement `z` or grouped `levels` definitions;
* a base tile covering the entire legacy ground level or an explicit grouped level;
* ordered rectangular regions;
* ordered, level-aware `set`, `rectangle`, `rectangle_outline`, `line`, and `scatter` operations;
* inclusive Bresenham line rasterization;
* deterministic scatter by count or density;
* root-level reusable cell-pattern definitions;
* ordered, level-aware pattern placement at an anchor with fixed quarter-turn rotation;
* root-level weighted tile palettes referenced by base tiles and placement operations;
* fixed tile rotations;
* deterministic random rotations;
* `null` region tiles that produce `{}`;
* tile-ID validation against the tile database;
* strict rejection of unknown recipe fields;
* region bounds validation;
* output filename validation;
* overwrite protection;
* generation to a temporary file;
* validation before publication;
* atomic replacement of the target file.

It always produces:

```text
mapwidth: 32
mapheight: 32
populated level size: 1024
unused levels: []
logical z range: -10 through +10
level-array index: logical z + 10
```

## 5. Generator and validator tests: complete for version 1

The current Python test suite contains 156 tests and passes. Focused GUT suites verify slope rotation and baked connectivity across Godot runtime geometry paths.

Coverage includes:

* fixed 32×32 dimensions;
* exactly 1024 entries;
* deterministic generation;
* rectangular overlays;
* single-cell placement;
* filled and outlined rectangles, including thin outlines;
* horizontal, vertical, and diagonal lines;
* deterministic scatter by count and density;
* operation ordering and overwrite behavior;
* operation field, type, coordinate, bounds, and scatter-argument validation;
* empty-tile representation;
* unknown fields;
* invalid IDs;
* unknown tile IDs;
* palette references, weighted deterministic selection, and malformed palette rejection;
* reusable pattern expansion, rotation, ordering, determinism, compatibility, and validation;
* logical-z conversion and bounds;
* legacy per-placement z targeting across every operation type;
* grouped multi-level generation, declaration order, local overwrite order, and RNG order;
* duplicate, ambiguous, malformed, and nested z-definition rejection;
* exact 21-level output and validator rejection of incorrect level counts;
* maintained two-level hill and depression recipes with structurally supported slope endpoints;
* editor-facing slope rotation conversion and rendered-mesh high edges in Godot;
* matching collision high edges for all four slope rotations;
* matching navigation-source high edges for all four slope rotations;
* asynchronously baked, bidirectional navigation paths across all four slope rotations;
* invalid metadata;
* malformed tile databases;
* out-of-bounds placement;
* output filename mismatch;
* overwrite protection;
* validator rejection of bad dimensions;
* validator rejection of short and long levels;
* acceptance of unused empty levels;
* acceptance of correctly generated maps.

This is sufficient coverage for the prototype’s present capabilities.

## 6. Repository ownership and remotes: complete

Your working repository is now your fork:

```text
origin:
https://github.com/snipercup/CataX.git

upstream:
https://github.com/Dimensionfall/Dimensionfall.git
```

That gives you control over the generator roadmap without depending on every experimental stage being accepted upstream immediately.

Your working directory remains:

```bash
~/hermes/dimensionfall/workspace/Dimensionfall-test-runner
```

## 7. Manual example generation and evaluation: complete

The project now includes:

```text
Tools/generate_map_examples.py
Tools/tests/test_generate_map_examples.py
Documentation/Modding/map_example_generation.md
```

The runner generates one or more deterministic seed variants from maintained recipes, delegates validation and atomic publication to the existing generator, and can place outputs directly in a mod's `Maps` directory for content-editor inspection. It validates the complete batch and rejects duplicate output paths before publication. Newly created outputs and their SHA-256 digests are recorded in a non-JSON manifest so cleanup removes only unchanged runner-owned files.

Ten focused tests cover variant IDs, complete map shape, determinism, CLI generation and cleanup, overwrite ownership, changed-file preservation, malformed recipes, duplicate outputs, and failed-publication safety.

---

# What the generator cannot do yet

The current recipe language is intentionally minimal. It cannot yet express most meaningful maps.

It does not currently support:

* nested, shape-based, or multi-level pattern composition;
* circles or irregular regions;
* terrain blending;
* features or furniture;
* areas or rooms;
* doors;
* buildings;
* roads as semantic objects;
* map-edge connection placement;
* reusable templates;
* towns or settlements;
* biome rules;
* general walkability checks beyond the Phase 7 road-route navigation test;
* accessibility or connectivity checks;
* encounters, creatures, items, or spawn points;
* standalone image or HTML previews outside Godot; generated map JSON can already be opened with the existing content-editor map preview;
* importing an existing map into a recipe;
* regeneration while preserving hand-authored changes.

At present, it can create a recognizable outdoor terrain layout with paths, bounded clearings, and scattered variation. It cannot yet create a credible playable location because it has no furniture, semantic areas, buildings, or gameplay content.

---

# Progress tracking

This document is the roadmap source of truth. Keep it current at milestone boundaries rather than recording a chronological activity log:

* use `planned`, `next`, `in progress`, or `complete` for each phase;
* mark a phase complete only after its success criterion and listed validation pass;
* when a phase changes, update its delivered list, current capabilities and limitations, test count, recommended next task, and the one-view summary together;
* keep temporary implementation notes and command output out of this document;
* preserve detailed operation contracts in `Documentation/Modding/map_recipe_generator.md` and tests rather than duplicating them here.

---

# Roadmap

## Phase 1 — Structural safety

**Status: complete**

Goals:

* sanitize malformed map data;
* understand the real map structure;
* improve validator coverage;
* establish agent guidance.

Delivered:

* sanitation in `DMap`;
* GUT sanitation test;
* improved validator;
* Hermes-oriented `AGENTS.md`.

## Phase 2 — Minimal deterministic generator

**Status: complete**

Goals:

* define a compact recipe;
* generate one valid ground level;
* validate before writing;
* test determinism and failure cases.

Delivered:

* recipe format version 1;
* generator CLI;
* fixed 32×32 output;
* base tile plus rectangular overlays;
* tile validation;
* 16 Python tests;
* documentation and example.

## Phase 3 — General placement primitives

**Status: complete**

Delivered:

* ordered `operations` applied after legacy `regions`;
* `set`, filled `rectangle`, and `rectangle_outline` placement;
* inclusive one-cell-wide lines using the integer Bresenham algorithm;
* deterministic scatter using exactly one of `count` or `density`;
* strict bounds with no silent clipping;
* unknown-field and unknown-operation rejection;
* shared placement logic for legacy regions and rectangle operations;
* an outdoor example with a path, bounded clearing, and scattered flowers;
* focused tests and recipe documentation.

### Success criterion

A recipe can generate a visually recognizable outdoor layout containing:

* a base terrain;
* one path;
* one bounded clearing;
* some deterministic scattered variation.

No furniture or buildings yet. This criterion is met by `Tools/examples/map_recipe.json`.

## Phase 4A — Manual example generation and evaluation harness

**Status: complete**

Delivered:

* a Python CLI that reuses the existing generator rather than duplicating it;
* one-command generation of multiple deterministic seed variants;
* unique map IDs and matching filenames;
* configurable recipe, tile database, output directory, variant count, and starting seed;
* overwrite protection inherited from the generator;
* a non-JSON ownership manifest with SHA-256 identity checks and exact-file cleanup;
* direct output to a mod's `Maps` directory for inspection in the existing content-editor preview;
* focused tests and a manual tester guide with example commands.

### Success criterion

A developer can run one documented command, launch Godot, and inspect at least three deterministic generated variants in the content editor without manually editing recipes or renaming output files. Cleanup leaves unrelated maps untouched.

## Phase 4B — Tile palettes and reusable patterns

**Status: complete**

Raw tile IDs are cumbersome and encourage agents to invent invalid identifiers. Introduce semantic recipe-level palettes.

Example:

```json
{
  "palette": {
    "ground": [
      {
        "id": "grass_plain_01",
        "weight": 8
      },
      {
        "id": "grass_flowers_00",
        "weight": 2
      }
    ],
    "path": [
      {
        "id": "dirt_light_00",
        "weight": 3
      },
      {
        "id": "grass_dirt_00",
        "weight": 1
      }
    ]
  }
}
```

Delivered:

* root-level semantic tile palettes;
* weighted deterministic selection;
* palette references from `base_tile`, legacy `regions`, and every placement operation;
* strict palette validation and known tile-ID checking;
* updated example recipe using palettes for ground, clearing, paths, and flowers.
* named reusable cell patterns with signed offsets;
* anchored pattern operations with fixed quarter-turn rotation;
* strict pattern-definition, reference, field, and expanded-bounds validation;
* deterministic cell-order expansion using existing tile and palette semantics;
* updated example recipe reusing one flower-cluster pattern at three orientations.

### Success criterion

The generator can create terrain that looks varied without requiring a recipe entry for every cell.

This criterion is met by weighted palettes, deterministic scatter, and reusable cell patterns. Richer nested and shape-based composition belongs in Phase 8 rather than extending this foundation phase indefinitely.

## Phase 4C — Vertical levels and 3D placement foundations

**Status: complete**

Dimensionfall maps already contain 21 level arrays. Level-array index `10` is logical elevation `0`, with valid logical elevations from `-10` through `+10`:

```text
level-array index = logical z + 10
logical z = level-array index - 10
```

Existing maps use this structure for hills, holes, craters, underground locations, and multi-story buildings. The generator needs a shared vertical-coordinate contract before features, rooms, buildings, and templates are added.

Goals:

* add recipe-level logical `z` coordinates while preserving top-down `[x, y]` coordinates;
* default omitted `z` to `0` so existing recipes remain compatible;
* support multiple populated level arrays;
* allow every placement operation and pattern invocation to target a logical level;
* investigate a per-level recipe structure for substantial multi-level maps;
* define per-level base-tile and empty-level behavior;
* map logical elevations `-10` through `+10` to level-array indices `0` through `20`;
* preserve exactly 1024 entries in every populated level and `[]` for unused levels;
* define deterministic operation and RNG ordering across levels;
* validate horizontal bounds, vertical bounds, duplicate level definitions, and complete pattern expansion;
* investigate slope, stair, support, collision, and traversal semantics before enforcing gameplay rules.

Delivered:

* logical `z` validation from `-10` through `+10` and conversion to the fixed 21 level-array indices;
* backwards-compatible root placement where omitted `z` remains logical level `0`;
* optional `z` on legacy regions and every root placement operation, including pattern invocation;
* strict grouped `levels` definitions with unique `z`, optional per-level base tiles, regions, and operations;
* rejection of ambiguous mixing between grouped levels and root `base_tile`, `regions`, or `operations`;
* declaration-order RNG consumption across grouped levels and existing region-before-operation ordering within each level;
* automatic preservation of all-empty levels as `[]` and exactly 1024 entries for every populated level;
* independent validator enforcement of exactly 21 level arrays;
* maintained two-level hill and depression recipes using known `shape: "slope"` transition tiles;
* focused tests for vertical bounds, compatibility, every placement type, deterministic ordering, malformed schemas, exact level shape, and slope endpoint support;
* focused GUT tests for editor-to-runtime slope conversion and matching mesh, collider, and navigation-source high edges;
* robust convex slope-collider construction that initializes the shape before assigning it to a collision node;
* an explicit `navigation_mesh_baked` completion signal for deterministic asynchronous verification;
* safe handling of stale asynchronous bake callbacks when a chunk has already begun unloading;
* focused Godot integration coverage that bakes one chunk navigation map and verifies low-to-high and high-to-low paths for every slope orientation;
* manual player-controller verification on the maintained two-level hill and depression maps, covering all four slope orientations in both directions without traversal or invisible-collision problems.

Recommended compatibility form for individual placement:

```json
{
  "type": "pattern",
  "pattern": "wildflower_cluster",
  "at": [16, 12],
  "z": 1,
  "rotation": 90
}
```

For larger recipes, prefer grouping content by logical level rather than repeating `z` on every operation:

```json
{
  "levels": [
    {
      "z": 0,
      "base_tile": {"palette": "ground"},
      "operations": []
    },
    {
      "z": 1,
      "operations": []
    }
  ]
}
```

Legacy root-level `base_tile`, `regions`, and `operations` cannot coexist with grouped `levels`. The generator rejects that ambiguous layout instead of inventing merge or overwrite ordering.

Initial structural validation:

* `z` is an integer from `-10` through `+10`;
* converted level indices remain within `0` through `20`;
* the output always contains exactly 21 level arrays;
* every populated level contains exactly 1024 row-major tile entries;
* unused levels remain `[]`;
* every operation and expanded pattern remains horizontally and vertically in bounds;
* duplicate or ambiguous per-level definitions are rejected;
* identical recipes and seeds produce identical output across every populated level.

Runtime investigation established:

* `Chunk.create_block_position_dictionary_new_arraymesh()` maps level-array index `i` to world height `i - 10`;
* tiles with `shape: "slope"` generate sloped mesh, collision, and navigation geometry within one vertical block;
* recipe and map-editor slope rotation selects the high edge: `0` north, `90` east, `180` south, and `270` west;
* `Chunk.get_block_rotation()` converts those newly loaded slope values before mesh, collision, and navigation code uses its internal orientation, so recipes must preserve the editor-facing values rather than pre-converting them;
* existing hills, holes, and buildings place slope tiles on the upper of the two connected logical levels;
* the maintained examples can therefore validate occupied high-side and lower-level low-side endpoints without inventing a broader support model.
* focused GUT coverage confirms all four editor rotations produce matching high edges in rendered mesh vertices, convex collision geometry, and navigation-source faces.
* the real asynchronous navigation bake synchronizes all four transition orientations into a chunk navigation map, with queryable paths in both directions between lower and upper surfaces.
* manual playtesting of the generated hill and depression confirms that the player controller can walk up and down every slope orientation without problems.

Later phases must determine broader structure-specific rules as their schemas are introduced:

* whether transitions require corresponding tiles on both levels;
* how floors, walls, roofs, ceilings, and intentional air gaps occupy stacked levels;
* whether support is determined by tile presence, collision shape, or another runtime rule;
* which broader transition, support, and reachability checks belong in Python, Godot unit tests, or later gameplay validation.

Reference fixtures should include existing hills, depressions, deep craters, buildings, and underground maps such as `field_grass_hill_00`, `field_grass_hole_00`, `crater_small`, `two_story_house`, and `underground_lab`.

### Success criterion

Generate and validate one two-level hill and one two-level depression from recipes. Each map has correctly sized populated levels, preserves unused levels as `[]`, uses valid transition tiles, loads in Godot, and permits runtime traversal between generated elevations.

This success criterion is met. The maintained recipes generate valid two-level maps, deterministic Godot tests cover mesh, collision, navigation-source geometry, and asynchronously baked bidirectional paths, and manual playtesting confirms that the real player controller traverses all four slope orientations in both directions without problems.

## Phase 5 — Features and furniture

**Status: complete**

This is where generated maps start becoming playable rather than merely visual.

Schema investigation established:

* newly generated furniture is stored as one `feature` dictionary embedded directly in a non-empty terrain tile, not in a separate map-level object array;
* the serialized feature uses `type: "furniture"`, a furniture `id`, an editor-facing quarter-turn `rotation`, and optional `itemgroups`;
* no state or mode field is present in authored map features; blueprint `mode` appears only in saved runtime furniture data;
* logical height is inherited from the containing level-array index, and `Chunk.process_level_data()` converts index `i` to world height `i - 10`;
* runtime furniture data chooses the static or physics spawner from the referenced furniture definition's `moveable` property;
* furniture IDs come from the merged furniture definitions; the generator validates against the selected `Furniture.json` database for this initial core-mod workflow;
* the map editor permits only one feature dictionary per terrain cell and writes an empty `itemgroups` array when no container contents are selected;
* existing map data does not encode a general multi-tile footprint or adjacent-level occupancy contract, so neither is inferred in this first slice.

Delivered recipe concept:

```json
{
  "type": "furniture",
  "x": 15,
  "y": 13,
  "z": 0,
  "id": "bench_garden",
  "rotation": 90
}
```

Delivered:

* root-level furniture operations with optional logical `z`, defaulting to `0` consistently with existing operations;
* grouped-level furniture operations that inherit the enclosing logical level and reject repeated nested `z`;
* strict operation fields, horizontal and vertical bounds, known furniture-ID checks, and fixed quarter-turn rotation validation;
* required supporting terrain on the target cell and rejection when that tile already has a feature;
* explicit ordered behavior: a duplicate furniture placement conflicts, while a later terrain operation replaces the complete earlier tile and feature;
* established map/editor serialization with `type`, `id`, `rotation`, and empty `itemgroups` when the recipe omits an override;
* optional non-empty furniture-operation `itemgroups`, validated against `Itemgroups.json` and serialized as an authored container-loot override;
* lazy furniture-database loading so terrain-only recipes remain compatible and do not require furniture data;
* independent structural validator checks for furniture feature fields, ID shape, rotation, and itemgroup arrays;
* a maintained `generated_furnished_clearing` recipe at logical `z: 0` using a garden bench, tree, and pine tree;
* Python coverage for root and grouped logical levels, exact serialization, support and feature conflicts, operation ordering, strict validation, compatibility, and maintained-example output;
* Godot coverage confirming `Chunk.process_level_data()` preserves the feature and derives the expected world height from its serialized logical level.
* named weighted furniture palettes with strict known-ID, positive-weight, and editor-facing rotation validation;
* bounded `furniture_scatter` operations that enumerate terrain-without-feature candidates in row-major order, sample them without replacement, select weighted furniture deterministically, and fail before placement when count exceeds eligibility;
* an expanded furnished clearing with explicit garden bench, unlit campfire, and potted plant plus 24 conflict-aware tree, pine, willow, or burned-stump placements;
* manual editor and `save and test` verification by the maintainer that all clearing features behave correctly, including the seeded placements and explicit features;
* two new core static Nature furniture definitions: `rock_field_00` and `wild_vegetation_00`, using dedicated AI-generated 32×32 sprites `ai_rock_32_32.png` and `ai_vegetation_32_32.png` in the core furniture sprite directory;
* maintained-example reference entries and a weighted groundcover scatter pass containing the new rock and vegetation IDs, giving the clearing trees, rocks, vegetation, and simple decorative/interactable objects without changing the feature schema.

Final verification:

* the temporary art was replaced with dedicated AI-generated sprites `ai_rock_32_32.png` and `ai_vegetation_32_32.png`;
* the maintainer regenerated `generated_furnished_clearing`, inspected it in the editor with `save and test`, and confirmed that both rock and wild-vegetation furniture spawn without issues;
* the generated clearing therefore meets this phase's outdoor-composition success criterion with trees, rocks, vegetation, and simple decorative/interactable objects.

### Success criterion

Generate an outdoor map with trees, rocks, vegetation, and simple interactable or decorative objects. The first example may remain at `z: 0`, but the feature schema and validation must support explicit logical levels from its first version.

## Phase 6 — Areas, rooms, and buildings

**Status: complete; authored area/room/building foundations and a physically generated, enterable multi-level building slice complete**

The generator needs semantic areas before it can create convincing buildings.

### Completed foundation

The established map contract was inspected before extending the generator:

* `DMap` serializes area definitions in the map-level `areas` array;
* the map editor stores spatial membership in each terrain tile as an `areas` array of `{ "id", "rotation" }` references;
* `Helper.map_manager.process_areas_in_map()` selects a definition by `spawn_chance` and applies it to connected tile-membership clusters on every populated level;
* distinct area IDs may overlap on one tile, matching editor/runtime behavior; a duplicate reference to the same area ID is rejected by the recipe generator;
* memberships do not introduce a new parallel map representation and do not replace terrain or features.

The recipe generator now supports strict root `areas` definitions plus an `area_rectangle` operation. The operation uses existing logical-level rules: root operations default to `z: 0`, can target `-10` through `10`, and grouped operations inherit their containing level. It requires supporting terrain, validates its named area, uses only editor-facing quarter-turn rotations, and serializes the existing runtime/editor tile membership object.

`Tools/examples/map_recipe_area_meadow.json` is the maintained evidence: a deterministic `12×12` `meadow_clearing` membership rectangle from `[10, 10]` through `[21, 21]` at `z: 0`, with a 100-percent runtime rule that applies `grass_dirt_00`. Python coverage verifies level placement, malformed references, duplicate memberships, unsupported cells, maintained-example bounds, and validator shape/rotation checks.

The area entity contract is now strict and catalog-aware. Recipes may use the existing runtime entity types `furniture`, `mob`, `mobgroup`, and `itemgroup`; each record must have a known catalog ID and a positive integer weight. Entity selection deliberately remains runtime-owned: `map_manager` appends its implicit no-spawn weight and selects a new outcome for every membership tile when the map is instanced. This keeps area fields unique between runs, unlike deterministic `furniture_scatter`, which pre-writes the same seeded feature positions into generated JSON. `Tools/examples/map_recipe_area_entity_clearing.json` is the maintained evidence: its 12×12 `stump_clearing` boundary has no pre-baked features, then independently rolls `burned_tree_stump` features at runtime. Focused GUT coverage proves membership rotation is retained for the spawned furniture structure and runtime processing reaches serialized level `11` (logical `z: +1`).

Authored room semantics use a separate map-level `rooms` array plus exclusive tile-local `rooms: ["id"]` membership. Each definition has a stable authored ID and exactly one semantic kind: `enclosed`, `covered_open`, or `ruin`. These labels are deliberately independent from floor material and runtime `areas`: one wood or concrete floor can span several rooms, a roofed garage can be `covered_open`, and a ruined room remains a room despite intended wall gaps. `Tools/examples/map_recipe_room_semantics.json` is the maintained evidence and puts adjacent `office` and `garage_bay` labels on the same `concrete_00` material.

`room_connections` adds explicit authored door intent without topology inference. Each root connection names a unique `id`, an `[x, y]` coordinate, required logical `z`, and two distinct endpoints: a known room or `exterior`. An optional `target_at` may name the physical door-furniture tile separately from the authored `at` coordinate, decoupling the room-edge anchor from the door tile. The target must be an existing terrain tile with catalog-recognized door-capable furniture; current evidence uses the runtime-native `door_wood` feature. This covers both room-to-exterior and room-to-room doors while preserving existing door opening, collision, and rotation behavior. `Tools/examples/map_recipe_room_connections.json` carries both cases. The generator and independent validator reject malformed endpoints, unknown rooms, duplicate door targets, or non-door targets; `DMap` preserves valid connections and removes links that name deleted rooms.

`room_boundaries` provides the explicit compatibility path for authored physical evidence without generating a building perimeter. Each record identifies one room, exact `[x, y, z]`, and either `wall_tile` or `door_furniture`; a directional `side` may identify its cardinal edge. Optional `target_at` and `room_at` fields may name the physical wall/door tile and the room-membership tile explicitly, so an authored boundary can reference a wall tile that is not the room tile itself. Wall records use the room's logical z while their existing `Wall`-category tile is materialized one level above it, with implicit dirt support at z0; door records point outward from their existing door-capable furniture tile and require a same-location `room_connections` endpoint naming the room. A room cannot duplicate a target, but one wall tile can be declared for different rooms. `Tools/examples/map_recipe_room_boundaries.json` demonstrates a complete opt-in `office` enclosure with eleven `brick_wall_00` segments and one existing `door_wood` opening, while retaining deliberately partial `covered_open` garage and `ruin` records.

An `enclosed` room may add `boundary_validation: "complete"`. Only this opt-in mode requires directional evidence and validates every exposed cardinal edge of every room-membership tile: exactly one wall or connected-door boundary must map to each edge. Missing, incorrectly oriented, duplicate, and non-exposed declarations are rejected. `covered_open` and `ruin` cannot opt in, so their intentional openings and damage remain valid without blanket enclosure requirements.

The generator, standalone map validator, and `DMap` save/load path validate or preserve definitions and references. A first `buildings` root field groups existing room content under one explicit, data-only rectangular footprint at one logical z. Each record names a nonempty set of known rooms, requires every owned membership, boundary target, and named door-connection target to sit inside its bounds, disallows same-level overlap, and requires at least one owned `enclosed` room with complete boundary validation. `Tools/examples/map_recipe_single_level_building.json` provides a 4×4 `office_building` containing the already-proven office, its eleven wall tiles, and exterior door. The footprint does not generate or modify geometry, furniture, roofs, collision, navigation, lighting, weather, or indoor state; it only gives authored validated evidence a first building-level grouping.

`building_surfaces` now adds one narrow overhead semantic layer to that validated footprint. Each root record has a unique `id`, names one existing `building`, declares `kind` as `roof` or `ceiling`, and declares the immediately overhead logical level (`building.z + 1`). One building may carry one authored record of each kind; the records inherit the building rectangle rather than duplicate per-cell geometry. `Tools/examples/map_recipe_building_surfaces.json` demonstrates both classifications over `office_building` at `z: 1`. These records do not generate roof/ceiling tiles or meshes, mark any cell occupied or indoors, imply support/collision, or alter lighting, weather, or runtime behavior.

`building_compositions` adds an opt-in cross-record constraint over the existing building and surface metadata. Each record has a unique `id`, names one existing `building`, and lists one or both required surface kinds (`roof`, `ceiling`); each named kind must already have a matching authored `building_surfaces` record. A building has at most one composition, while buildings without compositions remain valid. The maintained building-surfaces example asserts that `office_building` requires both its roof and ceiling classifications. This verifies authored consistency only: it creates no geometry, coverage, occupancy, support, indoor state, or runtime behavior.

A building may now opt into `access_validation: "complete"`. Every owned room must reach `exterior` through same-z authored `room_connections`; exterior door links seed reachability and owned room-to-room links propagate it. Links to rooms outside the building do not satisfy the validation. `office_building` opts in through its existing `office_front_door` exterior link. The check validates authored semantic access only: it does not infer physical door adjacency, collision, navigation, or player traversal.

A building may explicitly classify a nonempty subset of its owned rooms with `interior_rooms`. Every interior room must remain an authored `enclosed` room with complete boundary validation; `covered_open` and `ruin` cannot be interior. This metadata is never inferred from access, floor materials, wall/door placement, roof/ceiling records, or topology, and it adds no indoor runtime behavior. The maintained office building classifies its already-complete enclosed `office` as its interior room.

A building may explicitly classify a nonempty subset of its owned rooms with `open_space_rooms`. Every named room must be `covered_open` or `ruin`, and it cannot overlap `interior_rooms`. The maintained building marks its covered-open `garage_bay` as open space. This metadata is never inferred from missing walls, exterior access, floor materials, roof/ceiling records, or topology, and it adds no geometry or runtime indoor/outdoor behavior.

An opted-in `room_partition_validation: "complete"` now requires every room owned by a building to be classified exactly once as either interior or open space. The maintained office/garage building demonstrates this complete partition. The rule validates authored labels only: it does not require all footprint cells to be room-labelled or add runtime indoor/outdoor behavior.

An opted-in `overhead_validation: "complete"` requires that a validated single-level building carry both authored `roof` and `ceiling` classifications at its immediately overhead logical z; for a multi-level building it requires a `floor` or `ceiling` at every declared occupied level above ground and a `roof` at the highest declared occupied level. This checks classification consistency only: it does not generate surfaces, assert physical coverage, mark cells occupied/indoors, or alter support, collision, lighting, weather, or runtime behavior.

`exterior_context` now names one existing room-free terrain tile at the building’s z directly outside and cardinally adjacent to its footprint. It is a data-only external reference point: it does not generate or reserve terrain, infer streets/yards, alter runtime areas, establish an entrance, or change runtime behavior. The maintained building names `[6, 8, 0]` west of its footprint.

`exterior_access_context` now explicitly associates that context with one existing owned room-to-exterior connection at the same logical z. The maintained building names `office_front_door`. This validates authored semantic association only: it does not infer physical routes or door/context adjacency, create entrances, alter collision/navigation, or change runtime behavior.

`entrance` now authors one data-only building-level entrance semantic. Each record has exactly `connection` and `facing`: `connection` names an existing same-z room-to-exterior connection owned by the building (the same contract as `exterior_access_context.connection`), and `facing` is one of `north`, `east`, `south`, or `west`. It requires `exterior_context` and, when `exterior_access_context` is also present, `entrance.connection` must match it. The `facing` direction must point from `exterior_context.at` toward the building footprint: stepping one cell in that direction from the context coordinate must land inside the footprint. The maintained building authors `office_front_door` facing `east`, matching its west-of-footprint exterior context. This validates authored entrance orientation only: it does not generate a door, infer a physical route, require coordinate adjacency between the context tile and the referenced door, or alter collision, navigation, lighting, weather, or runtime behavior.

`entrance_validation: "complete"` now opts a building into complete entrance orientation and approach validation. It requires `entrance` and then checks two authored constraints. First, the `room_boundaries` record with `element: "door_furniture"` at the entrance connection's `at` and `z`, naming a building-owned room, must have a `side` equal to the opposite of `entrance.facing`—the door opens toward the approaching direction. Second, `exterior_context.at` and the entrance connection's `at` must both fall within the footprint's perpendicular range, ensuring the approach path runs along the correct building side. The maintained building opts in; its `office_northwest_door` boundary at `[8, 8]` with `side: "west"` matches `entrance.facing: "east"`, and both the context Y (8) and door Y (8) fall within the footprint height (7–10). This validates authored orientation and alignment only: it does not generate or modify geometry, infer a walkable path, check collision or navigation, or alter runtime behavior.

`entrances` now authors multiple data-only building-level entrance semantics as an alternative to the singular `entrance`. Each record is a non-empty array of `{ "id", "connection", "facing" }` entries following the same per-entrance contract as the singular form. `entrance` and `entrances` are mutually exclusive. Each `id` is unique within the building, and each `connection` may be referenced by at most one entrance. `entrances` requires `exterior_context`; when `exterior_access_context` is also present, its `connection` must match one of the entrance connections. The primary entrance is the one whose `connection` matches `exterior_access_context.connection`, or the first entry when `exterior_access_context` is absent. Only the primary entrance is checked against `exterior_context.at` for the facing-toward-footprint constraint; non-primary entrances are not checked against the context tile because a single context coordinate cannot serve multiple approach directions. `entrance_validation: "complete"` validates door orientation for every entrance and approach alignment for the primary entrance. `Tools/examples/map_recipe_multi_entrance_building.json` demonstrates the maintained office building with two entrances: `front_entrance` (office front door facing east) and `garage_entrance` (garage opening facing west), each with its own door-furniture boundary. This validates authored multi-entrance orientation and alignment only: it does not generate doors, infer physical routes, check collision or navigation, or alter runtime behavior.

`furniture_anchors` now authors named data-only furniture anchor metadata for a validated building. Each record is a non-empty array of `{ "id", "at", "z", "kind" }` entries. Each `id` is unique within the building and follows the standard naming pattern. `at` is a two-integer `[x, y]` coordinate within map bounds. `z` is a logical level from `-10` through `10` and must match the building's own `z`. `kind` is a non-empty free-form semantic label (e.g. `"door"`, `"storage"`, `"workstation"`) — not an enumerated set and carrying no runtime behavior. Each anchor must reference a tile inside the building footprint that has an existing furniture feature at the authored `[x, y, z]`; the anchor does not generate furniture, modify terrain, infer walkability, check furniture category or function, or alter collision, navigation, lighting, weather, or runtime behavior. `Tools/examples/map_recipe_furniture_anchors.json` demonstrates the maintained office building with two furniture anchors: `office_door_anchor` and `garage_door_anchor`, each pointing to an existing `door_wood` feature inside the footprint. This is a data-only authored reference point that future template composition and gameplay validation can use as an anchor.

`building_levels` now provides the first multi-level building footprint foundation and per-floor room/furniture ownership metadata. A building remains rooted at ground floor `z: 0` and may declare strictly ascending occupied floor levels at even logical z values: `z: 0` ground, `z: 1` intentional open gap, `z: 2` ceiling/first floor, `z: 3` open gap, and so on through `z: 10`. Each level may assign aggregate building rooms and furniture anchors exactly once. Walls follow the simple derived rule: the wall layer is `floor_z + 1`; no independent wall elevation is stored. A future `wall_height` property may support genuinely tall storeys, but is intentionally deferred.

`staircases` now adds authored physical transition semantics to that foundation. Each staircase names `lower_at` and `upper_at` coordinates plus editor-facing rotations, and validation requires matching slope tiles (any tile-database `shape: "slope"` tile) at the lower coordinate on `z: 1` and upper coordinate on `z: 2` — exactly the two slope blocks required for player ascent. Straight stairs use two cardinally adjacent slopes with the same rotation; corner stairs insert one flat landing block at `z: 1` between the slopes so the upper slope turns the corner (`upper_rotation`). Slopes never stack: the upper slope is always horizontally offset from the lower slope. `Tools/examples/map_recipe_multi_level_building_foundation.json` demonstrates the corner formation with a landing block; the straight formation remains covered by focused tests.

`building_surfaces` now authors per-floor floor and roof surfaces for multi-level buildings in addition to single-level roof/ceiling semantics. For a building with `building_levels`, `z` must name a declared occupied level and `kind` may be `floor`, `ceiling`, or `roof`; a multi-level `roof` must be at the highest declared occupied level. The physical generator materializes the roof tile at the authored roof surface z. If that z is already an occupied floor level, the existing floor layer is reused as the roof and no second roof layer is generated. Ceiling remains metadata-only and is intentionally omitted from physical generation. `building_supports` adds authored structural support paths from lower to upper occupied levels.

The generator, standalone map validator, and `DMap` save/load path validate or preserve these contracts. An opt-in `building_geometry` record now generates physical floors on declared occupied levels, wall tiles from authored room boundaries, support tiles from authored support paths, and the authored roof tile at the roof surface z when a roof surface is authored. Walls materialize at `boundary_z + 1`. Only walls whose boundary is on the building ground level receive `dirt_light_00` beneath them; upper-storey walls retain the declared `floor_tile` beneath them. Implicit wall `set` operations follow the same dirt-below-wall convention. Existing doors and staircase slopes remain authored operations. Lower staircase slope and landing cells reserve empty headroom on the directly overhead z2 floor so the player is not blocked by the upper floor. The generated geometry uses the existing Chunk collision/navigation pipeline; focused tests verify the maintained building's multi-level route and roof geometry.

This slice intentionally does **not** yet define polygons, topology-derived room boundaries, indoor/outdoor runtime behavior, automatic door or staircase generation, or generalized templates.

Capabilities:

* named, level-aware rectangular or polygonal areas;
* room boundaries;
* floors and walls;
* doors and openings;
* indoor/outdoor designation;
* area metadata;
* reusable building footprints;
* furniture anchors;
* multi-level building geometry using logical z coordinates;
* occupied-floor, wall, roof, and intentional-air-space semantics;
* vertical transition anchors.

Example concept:

```json
{
  "buildings": [
    {
      "template": "small_cabin",
      "origin": {
        "at": [10, 9],
        "z": 0
      },
      "entrance": "south",
      "area_id": "cabin_1"
    }
  ]
}
```

Important checks:

* every room has an entrance;
* doors connect compatible cells;
* walls do not block all access;
* area definitions match physical boundaries;
* upper geometry has valid support according to the runtime rules established in Phase 4C;
* occupied floors have valid, unobstructed vertical transitions;
* stairs and slopes connect valid destinations on adjacent logical levels;
* roofs, ceilings, and walls do not incorrectly occupy walkable interior cells;
* furniture remains inside intended rooms.

### Success criterion

Generate one small, enterable building that loads correctly and has a reachable interior. The generated structure must exercise physical floor, wall, support, and standable roof geometry, include at least two reachable occupied floors, valid generated support, an authored working vertical transition, and correctly scoped rooms and furniture. The maintained multi-level building recipe provides the evidence for this criterion.

## Phase 7 — Roads and map connections

**Status: complete; authored map-edge connections, road endpoints, map-local road painting, and runtime walkability validation complete**

The prototype previously hardcoded all four edge connections as `"ground"`. These are now authored recipe-level metadata, with named endpoint anchors identifying the exact map-edge cells where roads enter or exit.

### Completed foundation

The recipe generator supports a root-level `connections` field. It accepts up to four keys — `north`, `east`, `south`, and `west` — each with a value of `ground` or `road`, matching the existing runtime map format. Omitted directions default to `ground`, so existing recipes without the field remain compatible. The generator validates unknown directions and unsupported connection types and outputs the complete four-direction dictionary. The standalone validator independently checks the same content.

The recipe generator now also supports root-level `road_endpoints`. Each endpoint has a unique `id`, a cardinal `direction`, an edge coordinate `at`, and ground-level `z: 0`. Its direction must be declared as `"road"` in `connections`, and its coordinate must lie on the corresponding map edge. The generator, standalone validator, and DMap save/load path validate or preserve these authored references. `Tools/examples/map_recipe_road_endpoints.json` is the maintained evidence: a simple outdoor map with west and east road endpoints and a deterministic connecting dirt path.

`road_paths` now authors a named ground-level cardinal polyline between two validated `road_endpoints`. The generator and standalone validator require different existing endpoint IDs, optional map-bounded waypoints, and cardinal continuity across the complete endpoint-to-endpoint sequence. A path may now provide a known `Ground` cube `tile`; the generator rasterizes and paints the complete route after validating supporting terrain and rejecting feature overwrites. The maintained `map_recipe_road_endpoints.json` demonstrates a generated west-to-east dirt route. A focused GUT test bakes a corresponding ground route through the real Chunk navigation pipeline and verifies a path between interior points near both map edges. This remains map-local geometry: it does not integrate multiple maps.

Capabilities:

* entrances on map edges;
* road endpoints;
* path routing and deterministic road painting between anchors;
* north/east/south/west connection metadata;
* guaranteed map-local terrain continuity between declared entry points;
* bridge or obstacle handling remains future work beyond this narrow map-local slice.

Validation should determine:

* whether every declared connection has a corresponding terrain edge;
* whether every generated route has continuous supporting terrain;
* whether road paths terminate at their declared endpoints;
* whether generated Ground cube routes are connected by runtime navigation;
* whether edge tiles match adjacent-map expectations; this map-to-map compatibility contract is intentionally deferred and may be resumed later.

### Success criterion

Generate a standalone map with one or more road edge connections and a continuous, deterministically painted ground-level route between declared endpoints. The route must use conservative walkable terrain and pass a real Godot navigation-path check. Full multi-map route integration remains later validation or an overmap concern.

## Phase 8 — Templates and compositional generation

**Status: Phase 8 complete; deterministic nested and rotation-aware template expansion, validated 3D footprints, compositional locations, facing-compatible anchors, bounded numeric/collection variants, and structured parameter objects complete**

The first Phase 8 slice adds reusable template definitions without creating a second generation pipeline. Templates expand into ordinary root operations before the existing recipe validation and map generation stages.

### Completed foundation

* named template definitions with relative `dz` level sections;
* unrotated placements with translated horizontal origins and `origin.z + dz` resolution;
* named template anchors with absolute anchor resolution; exterior connection anchors place distinct footprints adjacently while coincident interior anchors intentionally overlap;
* anchor-to-anchor placement against prior placements;
* typed `tile_id`, `boolean`, and enum template parameters with required/default resolution and placement-level overrides;
* conditional template operations for boolean inclusion and enum-selected semantic variants;
* bounded integer parameters for operation coordinates, dimensions, and counts;
* constrained string-list parameters with conditional operation inclusion;
* placement rotations of `0`, `90`, `180`, and `270` degrees, rotating local horizontal geometry, anchors, and anchor facings while preserving `dz`;
* automatic anchor-to-anchor rotation selection from cardinal facings, with explicit rejection when either connected anchor lacks facing metadata;
* recursive nested template placements with local origins, cumulative rotation and `dz`, forwarded parameter overrides, and cycle rejection;
* structured object parameters with declared property schemas, per-property defaults/required values, placement overrides, and dotted references;
* rotated 5×3 cabin coverage and automatically oriented brick/metal cabin connection coverage;
* complete three-dimensional template-footprint validation before ordinary generation, with conservative operation coverage, map/logical-z bounds, and unconnected-conflict rejection;
* named rectangular compositional locations with rotation-aware placement, matching-volume checks, and intentional aligned-volume overlap;
* expansion into existing ordinary root operations before normal validation;

### Phase 8 completion note

The next map-generation work should remain separate from generalized town or overmap composition until a concrete gameplay need requires it.

## Phase 9 — Map-local compositional locations

**Status: complete; maintained village-square composition and field_farmland semantic acceptance fixture**

The first Phase 9 slice proves map-local composition with `Tools/examples/map_recipe_village_square_composition.json`. It expands a central `village_square` template with nested plaza fixtures and named road anchors, then uses automatic facing-compatible anchor placement to attach a metal open-top cabin and a brick roofed cabin. `Tools/examples/map_recipe_field_farmland.json` is the maintained semantic acceptance fixture for the legacy `field_farmland` footprint: its representative farmhouse preserves x3…18/y19…29, floors z0/z2, ordinary z1/z3 wall layers, and one explicit concrete roof at z4. It adds a complete kitchen, connected ground room, upper room, authored entrance and furniture anchors, `reachability_validation`, and a z1→z2 staircase without adding farmland-specific generator logic. Both generated maps remain standalone tactical-map assets; neither introduces town, settlement, or overmap-wide composition.

### Phase 9 execution milestones

Phase 9 is implemented in generic slices. `field_farmland` is an acceptance fixture, not a special-case implementation.

#### 9.1 Generic semantic building profile — complete

Canonical fixtures now provide a generic authoring reference before farmland enrichment:

* `Tools/examples/map_recipe_semantic_single_storey_building.json` and `Mods/Dimensionfall/Maps/generated_semantic_single_storey_building.json`;
* `Tools/examples/map_recipe_semantic_two_storey_building.json` and `Mods/Dimensionfall/Maps/generated_semantic_two_storey_building.json`;
* focused generator coverage in `Tools/tests/test_map_generator.py`.

The single-storey fixture exercises the complete existing same-level semantic profile. Both canonical fixtures explicitly paint all required footprint-perimeter wall cells, including all four corners. The lower storey omits the wall at its authored door coordinate so the doorway has clear z1 headroom; every remaining z1 wall, including every corner, has a dirt support tile at z0. The two-storey fixture adds complete ground-room boundary evidence, per-floor room and furniture-anchor ownership, ordinary z1/z3 wall geometry, an explicit z4 roof, and `workroom_staircase` to prove cross-floor reachability and runtime traversal; its loft is enclosed but not boundary-complete because the stairwell opening breaks the perimeter. The explicit roof remains recipe geometry until the deferred generalized `wall_height` contract defines derived tall-storey roof metadata.

The canonical profile uses existing fields in this order:

1. physical floor, wall, roof, and transition geometry;
2. root `rooms` plus `room_rectangle` memberships;
3. complete `room_boundaries` and door evidence;
4. `room_connections` and building ownership;
5. `building_levels` room/anchor assignment;
6. `interior_rooms`, `open_space_rooms`, and `room_partition_validation`;
7. `exterior_context`, `exterior_access_context`, `entrance`, and `entrance_validation`;
8. `furniture_anchors` and maintained target objects.

A valid profile must prove that room membership is inside the footprint, complete enclosed rooms have complete boundaries, doors connect declared endpoints, and every room/anchor is assigned to one intended level. The single-storey profile also proves current same-z semantic access validation. Cross-floor semantic access is intentionally deferred to 9.3, where validated staircases become vertical graph edges. `access_validation` remains semantic graph validation; it is not a collision or navigation proof.

#### 9.2 Independent data-boundary validation — complete

Both canonical recipes generate deterministically and validate with `Tools/map_validator.py`. `Tests/Unit/test_dmap_sanitization.gd` loads both recipe sources through the production JSON helper and proves that room, connection, boundary, building, and support metadata round-trips through DMap sanitization.

This exposed and fixed one real compatibility gap: Godot JSON parsing represents numeric literals as floats, while DMap semantic sanitizers require integers for coordinates, z levels, and rotations. `Scripts/Helper/json_helper.gd` now recursively normalizes whole-number JSON floats to integers before returning parsed dictionaries or arrays; non-integral floats remain floats. Do not duplicate this generic boundary coverage for farmland.

#### 9.3 Generic required-route contract — complete

Buildings may declare an optional `reachability_validation` record:

```json
{
  "required_entrances": ["front_entrance"],
  "required_furniture_anchors": ["workbench"],
  "required_building_levels": [0, 2]
}
```

It names only existing entrances, furniture anchors, and declared occupied levels. It stores no coordinates, tile IDs, or precomputed paths. Static validation rejects unknown targets, undeclared levels, unreachable semantic rooms, and missing vertical graph links. Vertical graph edges derive only from already-valid authored staircases; the link is floor-granular because staircase slopes occupy the intentional open gap with no room membership. The contract is implemented independently in `Tools/map_generator.py`, `Tools/map_validator.py`, and `Scripts/Gamedata/DMap.gd`, with focused negative and positive tests in `Tools/tests/test_map_generator.py` and DMap preservation coverage in `Tests/Unit/test_dmap_sanitization.gd`. Python does not simulate runtime collision or navigation; the reusable Phase 9.4 helper proves runtime traversal. The maintained multi-level foundation, canonical two-storey fixture, and `field_farmland` acceptance fixture demonstrate full cross-storey records through their authored staircases.

#### 9.4 Reusable runtime navigation fixture — complete

`Tests/Unit/helpers/map_navigation_fixture.gd` provides the reusable GUT helper around the existing Chunk setup, navigation baking, grid-to-world conversion, and `NavigationServer3D.map_get_path()` assertions. The helper is generic: it receives endpoint coordinates, shapes, and labels; it does not know farmland, room semantics, or any maintained recipe.

Proven with:

* `Tests/Unit/test_semantic_single_storey_navigation.gd` — exterior-to-interior and return on the canonical single-storey geometry;
* `Tests/Unit/test_semantic_two_storey_navigation.gd` — exterior-to-ground, ground-to-upper through the authored staircase, and both returns;
* `Tests/Unit/test_chunk_road_navigation.gd` and `Tests/Unit/test_multi_level_building_navigation.gd`, refactored onto the same helper with unchanged coverage.

Required runtime checks are exterior-to-ground target and, for two-storey fixtures, ground-to-upper target. Runtime tests prove collision/navigation behavior; Python tests do not replace them. To make the two-storey proof possible, the canonical two-storey fixture now authors `workroom_staircase` (lower slope [10, 10] on z1, upper slope [10, 9] on z2) and upgrades its `reachability_validation` to require `loft_bench` and level z2; the loft is `enclosed` but intentionally not `boundary_validation: complete` because the stairwell opening breaks its perimeter, mirroring the maintained multi-level foundation.

#### 9.5 Apply the generic profile to farmland — complete

`Tools/examples/map_recipe_field_farmland.json` applies the existing generic profile to a representative `field_farmland` farmhouse: a complete `farmhouse_kitchen`, connected `farmhouse_ground_room`, `farmhouse_upper_room`, building ownership across z0/z2, a room-to-exterior entrance, door and workstation anchors, `reachability_validation`, and `farmhouse_staircase`. It preserves the legacy farmhouse footprint x3…18/y19…29, ordinary floor/wall elevations (z0/z1 and z2/z3), and one roof at z4. The recipe intentionally represents only the kitchen/ground-room/upper-room slice needed for the acceptance fixture; it does not reproduce every legacy map room or introduce farmland-specific generator behavior.

`Tests/Unit/test_field_farmland_navigation.gd` uses the generic navigation helper to prove exterior→kitchen, kitchen→ground-room, and bidirectional ground↔upper traversal. `Mods/Dimensionfall/Maps/generated_field_farmland.json` is the deterministic generated artifact and passes independent `Tools/map_validator.py` validation.

#### 9.6 Execution workflow and validation

Every implementation slice follows the same test-first sequence:

1. add one behavior-focused failing test;
2. run only that test and confirm the failure is caused by the missing contract, not a test error;
3. implement the smallest change in the generator;
4. mirror the contract in the standalone validator and DMap only when that data boundary handles the field;
5. rerun the focused test, then the complete Python suite;
6. regenerate the maintained JSON artifact;
7. run `Tools/map_validator.py`, relevant GUT tests, and `git diff --check`.

Primary files by responsibility:

* generator and recipe tests: `Tools/map_generator.py`, `Tools/tests/test_map_generator.py`;
* independent static validation: `Tools/map_validator.py`;
* runtime serialization/sanitization: `Scripts/Gamedata/DMap.gd`, `Tests/Unit/test_dmap_sanitization.gd`;
* runtime navigation: `Tests/Unit/test_semantic_single_storey_navigation.gd`, `Tests/Unit/test_semantic_two_storey_navigation.gd`, and `Tests/Unit/test_field_farmland_navigation.gd`;
* maintained recipes/artifacts: `Tools/examples/` and `Mods/Dimensionfall/Maps/`;
* documentation: this roadmap and `Documentation/Modding/map_recipe_generator.md`.

The focused commands are:

```bash
PYTHONPATH=. python3 -m unittest discover -s Tools/tests -p "test_*.py"
python3 -m py_compile Tools/map_generator.py Tools/map_validator.py Tools/tests/test_map_generator.py
python3 Tools/map_generator.py <recipe> <generated-map> --overwrite
python3 Tools/map_validator.py <generated-map>
/usr/local/bin/godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://Tests/Unit -gexit
git diff --check
```

#### 9.7 Phase 9 success criterion

A new map-local location can be composed from reusable templates and authored with the generic semantic profile, statically validated, generated deterministically, and checked through real runtime navigation. The resulting map remains an individual tactical-map/overmap asset. Generalized settlement generation and map-to-map edge compatibility remain deferred.

## Phase 10 — Quality and gameplay validation

**Status: in progress; Phase 10.1.1 automatic room-boundary generation is complete**

Phase 10 converts structural validity into explicit acceptance checks. Implement the checks in this order:

### 10.1 Static authored checks

Add focused checks for:

* every required entrance names an existing entrance/connection and has a valid exterior approach;
* every required furniture anchor exists, belongs to the building, and is assigned to a declared floor;
* every required occupied floor is declared;
* every semantic room has an authored route to an exterior connection or a valid vertical transition;
* every staircase endpoint is inside the footprint, has valid terrain and matching slope evidence, and reaches a declared target floor;
* doors, stairs, and important targets are not hidden by incompatible authored geometry;
* all logical z values remain within `-10` through `+10`;
* deterministic regeneration produces byte-equivalent output.

These checks belong in `Tools/map_generator.py` and `Tools/map_validator.py`; they must report the building, room/target ID, floor, and missing relation in failures.

#### 10.1.1 Room-boundary reliability and concise authoring — complete

The current `room_boundaries` contract is an explicit compatibility path: each record supplies authored physical evidence for one wall edge or door. It must continue to support existing recipes, irregular geometry, ruins, intentional openings, and unusual wall materials. It must not remain the only way to author an ordinary complete enclosed room.

Add an opt-in room-level perimeter-generation contract for normal enclosed rooms, for example:

```json
{
  "id": "farmhouse_kitchen",
  "kind": "enclosed",
  "boundary_validation": "complete",
  "boundary_generation": "walls"
}
```

When enabled, the generator derives the final room perimeter from room membership and uses the owning building's `building_geometry.wall_tile` to create the physical wall ring. `room_rectangle` remains a room-membership operation; it does not itself place walls. The derived perimeter must include corner caps and must leave openings only for valid `room_connections` crossing that room edge. A room-to-room connection consumes the facing edge for both participating generated rooms. The resolver must work from the final membership mask so future non-rectangular room operations, translation, nesting, and horizontal rotation do not require rectangle-specific special cases.

Implement this slice in the following order:

1. Add characterization tests before changing generation. Cover a complete 3×3 room, all perimeter corners, exterior and room-to-room openings, invalid or non-cardinal connections, missing door furniture, shared generated-room edges, and preservation of existing explicit `room_boundaries` behavior.
2. Add and validate the new room-level field. Initially restrict it to `enclosed` rooms with `boundary_validation: "complete"`; reject mixing generated boundaries with explicit `room_boundaries` for the same room and level so wall ownership is unambiguous.
3. Implement one reusable perimeter resolver that derives exposed semantic edges, connection openings, wall-ring coordinates, and deterministic shared-wall ownership from final room membership. Do not duplicate this logic in recipe-specific code.
4. Materialize the resolved walls at `floor_z + 1`, using the owning building wall tile, and reject incompatible authored geometry instead of silently overwriting it. Generate ground supports only at the owning floor.
5. Preserve semantic metadata when a support replaces a ground tile. Replacing a tile for support must not erase its `rooms`, `areas`, or other compatible metadata.
6. Mirror the resolver and diagnostics in `Tools/map_validator.py`; preserve and sanitize the room-level field in `Scripts/Gamedata/DMap.gd` when that data boundary handles it.
7. Migrate the `field_farmland` kitchen to the concise room-level declaration and remove its redundant per-wall records and duplicate kitchen wall operations. Verify that the generated perimeter includes the missing corner cells `[7,22]` and `[7,26]`, while connection openings remain open.
8. Document the compact declaration, the explicit-boundary escape hatch, connection-derived openings, and conflict rules in `Documentation/Modding/map_recipe_generator.md` and `Documentation/Modding/map_example_generation.md`.

Phase 10.1.1 is complete. Focused generator and standalone-validator coverage proves a generated 3×3 complete room creates its complete 5×5 exterior wall ring—including all four corner caps—while a valid exterior `room_connection` remains the only opening. Additional coverage proves room-to-room links open both facing edges while retaining one physical door target, diagonal crossings are rejected, adjacent generated rooms share one deterministic partition wall, explicit `room_boundaries` behavior remains intact, and support replacement preserves tile metadata. `field_farmland` now migrates its kitchen to the concise declaration: it no longer lists per-wall boundaries or duplicate kitchen-wall operations, and its generated ring includes `[7,22]` and `[7,26]`.

This slice belongs in Phase 10.1 because it improves generic authored diagnostics and structural reliability. It is not farmland-specific and must not introduce a farmland conditional in the generator or validator.

### 10.2 Runtime gameplay checks — complete

Phase 10.2 is complete for the migrated `field_farmland` farmhouse runtime traversal slice. `Tests/Unit/test_field_farmland_navigation.gd` uses the generic `MapNavigationFixture`, real `Chunk` navigation baking, and `NavigationServer3D` path queries to verify:

* exterior approach → kitchen through the west door;
* kitchen → ground room through the declared room connection;
* bidirectional ground room ↔ upper room traversal through the authored staircase;
* navigation baking completes only after the `NavigationServer3D` map iteration advances and two further physics frames settle the newly attached region.

Runtime wall-blocking is not claimed by this slice: the current fixture contributes block top faces to navigation source geometry, so a one-block wall can itself be represented as an elevated navigation surface. A follow-up collision/navigation-fixture change is required before asserting that automatic wall cells block crossings. Dynamic door state, combat, and full player-input traversal remain outside this phase.

Use real Chunk navigation baking and `NavigationServer3D`; do not introduce a Python pathfinder.

### 10.3 Maintained acceptance fixtures — complete

The maintained acceptance suite is complete. `MapGeneratorTests.test_maintained_recipe_suite_generates_validates_and_is_deterministic` enumerates every maintained `Tools/examples/map_recipe*.json` recipe, including the generic single-storey and two-storey semantic fixtures, the multi-level foundation, village-square composition, and `field_farmland`. For each recipe it:

* generates two independently written artifacts;
* validates each artifact through `write_map`'s publication validation and a fresh standalone `MapValidator` instance;
* requires byte-identical output from both regenerations; and
* fails when a recipe is added or removed without updating the explicit maintained suite.

Relevant GUT runtime coverage remains focused by geometry class: semantic single-storey, semantic two-storey, `field_farmland`, and Pine Hollow Outpost run real `Chunk` baking and `NavigationServer3D` navigation checks. Keep this suite green whenever maintained examples or map-generation behavior change; add an equivalent focused runtime test only when a fixture introduces gameplay geometry not already covered.

### 10.4 Phase 10 success criterion — complete

The Phase 10 success criterion is complete for the maintained fixture set. The generator, standalone validator, DMap persistence, and runtime navigation tests now provide actionable coverage for authored structure and traversal: intended farmhouse doors, room connections, and stairs are reachable, while bounded runtime checks reject unintended crossings through the automatic kitchen walls and generated corner caps. The generic `MapNavigationFixture` models walls as vertical navigation obstacles rather than walkable top surfaces, so these checks exercise the same navigation-server path query used by gameplay.

### 10.5 New authored location: Pine Hollow Outpost — implemented; manual visual inspection complete

**Status: automated and manual visual/compositional acceptance complete; field-map placement conversion complete**

Phase 10.5 shifts the primary acceptance target from reproducing an existing authored map to creating a new location from a concise design request. `field_farmland` remains a behavioral and visual reference, but the new fixture must not copy its coordinates, operation sequence, or complete tile/feature layout.

The first location is a small abandoned rural logging outpost suited to Dimensionfall's rural survival setting:

* a weathered caretaker cabin with an enclosed room and loft;
* a covered-open lean-to or wood-storage shelter beside the cabin;
* a short pedestrian/service dirt path from the yard to the cabin entrance;
* a fenced or partially overgrown work yard;
* a well, hand pump, workstation, or representative storage furniture;
* trees, rough terrain, and sparse environmental detail around the site.

The purpose is to exercise the existing generic vocabulary in a new composition: base terrain, field-map classification, local pedestrian paths, rooms, automatic walls, building geometry, entrances, furniture anchors, stairs, areas, and deterministic variation. Do not introduce a settlement-generation system, a farmhouse-specific conditional, or a new physical-building primitive unless the outpost exposes a concrete missing requirement.

#### 10.5 success criterion

The generated Pine Hollow Outpost must:

* be authored from a new concise recipe rather than a hand-authored source-map transcription;
* produce a visually recognizable rural survival outpost with a cabin, lean-to/storage area, yard, and short pedestrian/service path;
* provide an enterable cabin with an exterior entrance and an intentional connection to the outdoor/covered-open area;
* provide a loft or raised storage level with a valid staircase, headroom, and reachable upper surface;
* retain representative furniture/features and area semantics important to gameplay;
* block unintended crossings through enclosed walls while preserving declared entrances and connections;
* pass generator validation, standalone `MapValidator` validation, deterministic regeneration, and the maintained recipe acceptance matrix;
* pass focused runtime checks using real `Chunk` baking and `NavigationServer3D` for the service-path-to-cabin, cabin-to-outdoor-area, and cabin-to-loft traversal.

Decorative details, exact terrain scatter, minor prop placement, and other non-gameplay-critical differences from `field_farmland` are intentionally allowed. Phase 10.5 should add comparison/reporting only where it clarifies structural or visual equivalence; it must not turn the new recipe into a byte-equivalent snapshot of the authored farmhouse.

The production recipe is `Tools/recipes/pine_hollow_outpost.json`, with stable ID `pine_hollow_outpost`; its published runtime asset is `Mods/Dimensionfall/Maps/pine_hollow_outpost.json`. This promotion does not replace the legacy `field_outpost.json` map. The example recipe remains a separate maintained regression fixture with the `generated_pine_hollow_outpost` ID.

`Tests/Unit/test_pine_hollow_outpost_navigation.gd` uses real `Chunk` baking and `NavigationServer3D` path queries to verify the service-path-to-cabin and cabin-to-lean-to routes, bidirectional lower-to-loft traversal, and an isolated north-wall pocket that cannot be crossed. The automated structural/runtime portion and the manual Godot content-editor review are complete. The review confirmed the pedestrian approach, door alignment, cabin/lean-to silhouette, work yard, furniture/props, loft/stairs/roof, concrete threshold, and absence of roof coverage over the lean-to.

The implementation order is:

1. ~~author `Tools/examples/map_recipe_pine_hollow_outpost.json` from the location concept;~~
2. ~~add focused generator and standalone-validator coverage for the new composition;~~
3. ~~add or extend focused GUT runtime navigation coverage for the declared routes and blocked wall crossings;~~
4. ~~generate the map and inspect it through the existing Godot/editor workflow;~~
5. ~~mark the visual review complete only after that inspection confirms the intended rural outpost composition.~~

### 10.6 Room-derived surface operations — implemented

**Status: implemented; automated acceptance complete**

Phase 10.6 closes the Pine Hollow room-owned-geometry gap without merging distinct semantic layers. The root `rooms` registry remains the definition source, `buildings[].rooms` remains the backwards-compatible ownership relationship, and `building_levels[].rooms` remains the per-floor ownership relationship.

`room_surface` now derives physical coverage from final authored room membership:

```json
{"type": "room_surface", "room": "outpost_loft", "z": 2, "tile": {"id": "concrete_00"}}
{"type": "room_surface", "room": "outpost_loft", "z": 4, "tile": {"id": "concrete_00"}, "outline_padding": 1}
```

It accepts one known room, target logical z, tile specification, and optional non-negative `outline_padding`. Derived cells use the final membership of a room that occupies exactly one source z; padding expands that membership by Chebyshev radius and must remain map-bounded. Surface materialization is deferred until room labels are complete, preserves existing metadata/features, and retains authored slope tiles at the same z. Raw `rectangle` operations remain valid for terrain, roads, yards, and intentional eaves. `room_connections` remain authoritative; this phase does not infer doors or openings.

`building_geometry` now limits floor materialization on declared `building_levels` to the member cells of that level's rooms, plus required wall supports, unless that level explicitly declares a building-wide `building_surfaces` floor. It no longer silently fills an entire multi-level footprint when only a subset room owns an elevated level.

Pine Hollow now expresses its `6×6` loft floor and padded `8×8` roof without duplicate coordinate rectangles:

```text
outpost_loft membership: x12..17, y11..16 (6×6)
loft wall envelope:       x11..18, y10..17 (8×8)
loft roof:                x11..18, y10..17 (8×8)
lean-to:                  outside the loft floor and roof coverage
```

Automated coverage verifies final-membership derivation independent of operation order, padded coverage, unknown rooms/tiles/invalid padding/missing membership/out-of-bounds diagnostics, preserved loft crate and stairs, excluded lean-to cells, deterministic maintained-recipe regeneration, independent `MapValidator` validation of output, and existing real runtime navigation acceptance. `room_surface` is recipe-only syntax and does not appear in generated map data, so no DMap persistence field or standalone generated-map validator schema extension is needed.

The Phase 10.5 manual Godot content-editor visual/compositional review of Pine Hollow's pedestrian approach, cabin/lean-to silhouette, work yard, and prop placement is complete.

### 10.7 Canonical doorway and entrance declarations — complete

**Status: complete**

Phase 10.7 reduces the duplicated descriptions of a single physical doorway exposed by Pine Hollow. A current exterior door can be described by a root `room_connections` record, a building-level entrance record, `exterior_context`, `exterior_access_context`, a door-kind `furniture_anchor`, a per-floor anchor assignment, and a separate door-furniture operation. These records do not all represent the same concern, but their repeated IDs and coordinates make recipes difficult to author and maintain.

The target model is to make a room connection the canonical identity of a doorway or opening. A room-to-exterior connection may opt into entrance metadata:

```json
{
  "id": "outpost_front_door",
  "at": [12, 14],
  "target_at": [11, 14],
  "z": 0,
  "from": {"kind": "room", "id": "outpost_cabin"},
  "to": {"kind": "exterior"},
  "entrance": {
    "exterior_at": [10, 14],
    "facing": "east"
  }
}
```

In this model:

* `room_connections[].id` is the stable identity used by building and reachability metadata;
* `at` remains the semantic room-edge coordinate;
* `target_at` remains the physical door/opening coordinate, preserving the existing semantic-versus-physical distinction;
* `entrance.exterior_at` replaces the separate building `exterior_context` for that entrance;
* `entrance.facing` replaces the separate building `entrance`/`entrances` facing declaration;
* an entrance is identified by its connection ID, so a separate entrance ID is not required;
* door-kind furniture anchors and per-floor door-anchor assignments are derived from the connection target rather than authored again;
* generic furniture anchors remain independent for crates, benches, workstations, storage, and other gameplay targets;
* internal room-to-room connections remain valid without entrance metadata;
* `room_connections` remain semantic declarations and do not automatically generate a door feature in the first slice.

The first implementation should preserve backwards compatibility. Recipes using the existing building-level `entrance`, `entrances`, `exterior_context`, `exterior_access_context`, and door furniture anchors remain valid. If legacy and connection-level entrance metadata are both present, the generator and standalone validator must require them to describe the same connection, target, exterior context, and facing. Generated maps should continue to serialize the established runtime-compatible building metadata until consumers can migrate.

Reachability should use all owned room-to-exterior connections with entrance metadata as default seeds. `required_entrances` remains an optional narrowing requirement for buildings with multiple entrances; ordinary one-entrance buildings should not need to repeat the connection ID in a separate requirement list.

Automatic door-feature generation is deliberately deferred. A later slice may allow an entrance connection to declare a door feature and rotation, but that requires explicit conflict, legacy-door, locked-door, window, and non-door opening rules. Phase 10.7 initially canonicalizes identity and validation; it does not infer topology, collision, navigation, or indoor state.

#### 10.7 success criterion

A migrated Pine Hollow-style recipe must describe its exterior doorway with one canonical room-connection ID while preserving the current generated map and runtime behavior. The generator and standalone `MapValidator` must validate connection-level entrance metadata, detect conflicts with legacy declarations, derive default reachability seeds, preserve internal connections and generic furniture anchors, and keep generated output compatible with DMap/runtime consumers. Deterministic generation, maintained-recipe validation, DMap round-trip behavior, and real navigation acceptance must remain green.

#### 10.7 implementation order

1. ~~Add test-first generator and standalone-validator coverage for a connection-level `entrance` block, including default reachability seeding and invalid/conflicting legacy metadata. Keep the initial test red before adding production code.~~ The focused coverage is now GREEN in `Tools/tests/test_map_generator.py`.
2. ~~Add the smallest backwards-compatible schema validation and normalized internal representation in `Tools/map_generator.py` and `Tools/map_validator.py`.~~ Both tools now accept and validate the optional `entrance` object, preserve it in generated connection data, validate external linkage, bounds, facing, and reject malformed declarations.
3. ~~Migrate Pine Hollow’s exterior door to the new declaration while retaining the legacy form temporarily as an exact-equivalence compatibility test.~~ Both Pine Hollow recipe copies now use `room_connections[].entrance`; the temporary legacy building entrance/context, door furniture, and door-anchor declarations were subsequently removed after exact-equivalence testing.
4. ~~Mirror the normalized persisted building metadata in `Scripts/Gamedata/DMap.gd` and add DMap round-trip coverage if serialized fields change.~~ `DMap` now preserves valid connection-level entrance metadata and removes malformed nested entrance data without discarding an otherwise valid connection; `Tests/Unit/test_dmap_sanitization.gd` covers both behaviors.
5. ~~Remove redundant Pine Hollow door anchor, per-level door-anchor, and separate entrance/context declarations only after compatibility tests prove equivalent output.~~ The canonical connection-level entrance now owns doorway identity and exterior approach metadata; the redundant declarations were removed from both Pine Hollow recipes.
6. ~~Re-run maintained generation, deterministic comparison, standalone validation, and focused Godot navigation coverage; document the final authoring contract.~~ The maintained acceptance matrix remains green after regeneration and the final authoring contract is documented above.

### 10.8 Pine Hollow Outpost detail and immersion pass — complete

**Status: complete; controlled field variation, shabby wood floors, cabin furnishing, bounded exterior nature dressing, container itemgroups, and acceptance validation complete**

Phase 10.7 made Pine Hollow a correctly classified, playable field map. Phase 10.8 completed its authored detail and immersion pass using the existing generic terrain, palette, area, furniture, and room/building primitives without adding Pine-Hollow-specific generator conditionals.

The implemented first slice uses the existing field-compatible `grass_plain_01`, `grass_dirt_00`–`02`, `grass_medium_dirt_00`, and `grass_flowers_00` palette entries. It deliberately excludes `forest_underbrush_00`: Pine Hollow is a field map, not a forest map. It also excludes `grass_dead_00`, which does not fit the intended maintained field treatment. The `outpost_ground` runtime area covers every map cell outside the cabin footprint and always replaces its covered ground with a mostly-grass weighted mix; it does not use `null`. The cabin and loft use `floor_wood_shabby_00`, while the exterior threshold and open lean-to use explicit `concrete_00`. The ground-floor composition uses a wooden bed, stove, cabinet, table, chair, and lean-to tool bench; bounded exterior nature dressing uses an `outpost_field_nature` runtime area with wild vegetation, field rock, pine tree, and burned-stump weights in exterior-only membership regions. The `outpost_yard` runtime area has three dirt variants and deliberately excludes the path, building, and lean-to. Runtime area selection makes exterior dressing vary by map instance rather than baking it into the generated JSON. Focused generator assertions protect the material, route, required prop, non-forest palette, runtime-area, and clearance contracts.

#### 10.8.1 Authored composition contract

Keep the following spatial intent stable while adding detail:

* the map remains a `Field` map with all four edge connections set to `"ground"`;
* the map has no `road_endpoints` or `road_paths`; the route is a local pedestrian/service path, not drivable road infrastructure;
* `room_connections[].id` remains the canonical doorway identity;
* `entrance.exterior_at` remains the outdoor approach point at `[10, 14]`;
* the physical threshold at `[11, 14]` remains concrete and retains the `door_wood` feature;
* the cabin room, lean-to, loft, stairs, wall opening, and blocked wall-crossing contract remain unchanged;
* the service path remains continuous from the outer yard into the entrance approach and must not be replaced by random ground variation;
* the cabin entrance, stairs, furniture clearances, and required navigation routes are reserved before scatter or decorative placement is applied.

Do not use decoration to alter room membership, create openings, bypass building validation, or imply a new overmap placement rule.

#### 10.8.2 Ground and path treatment

Replace the current nearly uniform outdoor treatment with controlled deterministic variation:

* define a weighted ground palette using compatible grass, grass/dirt, rough-ground, and seasonal or weathered variants already present in the tile catalog;
* keep the base field readable as grass rather than turning the entire map into dirt;
* use a lower-variation yard treatment around the cabin and lean-to, with worn patches near the entrance, work area, storage, fence remnants, and path;
* retain the short `dirt_light_00` service path from the yard to `[10, 14]` and keep its width intentionally pedestrian-scale;
* avoid palette or scatter placement on the cabin, lean-to, loft, roof/support, threshold, stair, wall, furniture, and reserved navigation cells;
* use the fixed recipe seed and assert that repeated generation is byte-identical;
* prefer palettes and bounded scatter over large hand-authored tile lists, while keeping deliberately composed focal cells explicit.

The exact palette membership must be chosen from the real tile catalog during implementation. Do not invent tile IDs in the roadmap implementation without catalog validation.

#### 10.8.3 Cabin floors and structural material

Change the cabin’s authored floor treatment from generic concrete to a suitable walkable wood tile where the catalog and runtime support it:

* use a wood floor for the ground-floor cabin room and, if appropriate, the loft;
* retain concrete at the exterior threshold if it communicates a worn foundation or weather-protected entry;
* preserve the stairs, door tile/feature, wall supports, roof, and all room membership while changing floor material;
* verify that the selected wood tile is a valid walkable `Ground`/`Floor` tile and that it does not introduce a navigation or collision regression;
* decide explicitly whether the lean-to remains wood, dirt, or open ground rather than allowing the building footprint to imply a floor there;
* keep the physical standable roof contract unchanged; do not add physical ceilings as part of this visual pass.

If no suitable wood tile exists, stop and add the smallest catalog/content prerequisite rather than silently retaining concrete while documenting the floor as complete.

#### 10.8.4 Ground-floor furnishing plan

Add a deliberate interior furnishing composition to `outpost_cabin`, leaving a clear route from the door to the stairs and preserving the required navigation targets. The first furnishing set should include:

* one sleeping arrangement or bed-like prop;
* one table or work surface with one or more seats where available;
* one stove, fireplace, lantern, or equivalent survival utility prop if an existing catalog item supports it;
* storage for supplies, tools, or firewood, using crates/shelves where appropriate;
* a small amount of abandoned clutter or damage rather than filling every cell;
* no furniture on the threshold, staircase landing, upper-clearance cell, wall opening, or required path endpoints.

Each placement must use an existing furniture ID, valid rotation, supporting terrain, and one-feature-per-cell rules. Generic furniture anchors should be added only for gameplay-relevant targets such as storage or workstations; decorative furniture should not receive redundant semantic anchors.

The loft should receive only a small sleeping/storage composition. The lean-to should remain visually distinct as covered storage/work space, with room for the existing work crate and an unobstructed cabin-side route.

#### 10.8.5 Vegetation and exterior storytelling

Use the existing nature furniture and scatter vocabulary to make the field feel reclaimed without turning it into an impassable forest:

* place sparse wild vegetation and grass-height clutter around the map perimeter and beyond the maintained yard;
* add a few rocks, stumps, shrubs, or trees to establish the outpost’s rural/woodland setting;
* concentrate overgrowth near fence remnants, the lean-to exterior, yard edges, and less-used corners;
* leave the service path, exterior approach, door threshold, cabin interior, stairs, lean-to access, and navigation test points clear;
* avoid placing vegetation over existing features, room-derived surfaces, wall supports, slopes, or reserved cells;
* use a bounded, exterior-only runtime `areas[].entities` palette for broad nature dressing so each map instance varies; retain explicit furniture operations only for focal props that must remain stable;
* distinguish static decorative nature props from area entities: use authored deterministic features when the visual composition must remain stable, and use area entities only when runtime variation is intentional.

The density should be tuned through editor inspection rather than an arbitrary global count. Record the chosen protected regions, runtime-area weights, and reserved cells in focused tests.

#### 10.8.6 Work-yard and abandonment details

Strengthen the outpost story with a restrained exterior composition:

* retain the existing partially destroyed fence markers;
* add a small work/storage cluster near the lean-to without blocking the route;
* use worn-ground patches to connect the path, door, work area, and storage area;
* add one or two abandoned or damaged props only if existing furniture definitions support them;
* keep the yard readable from above and avoid making every outdoor cell equally busy;
* preserve the `outpost_yard` area semantics independently from visual tile variation and furniture placement.

This is authored environmental storytelling, not a new generic settlement or overmap composition system.

#### 10.8.7 Implementation order

All planned implementation steps are complete. The maintained production recipe, example recipe, published map, generator tests, validator checks, deterministic regeneration, and runtime navigation acceptance remain aligned. The final content/editor acceptance was completed as part of closing this phase.

1. ~~Inventory the real tile and furniture catalogs for wood floors, beds, tables, seats, stoves/utilities, storage, rocks, vegetation, shrubs, trees, stumps, and damaged props. Record unavailable concepts and choose the closest existing assets.~~
2. ~~Add test-first assertions for the intended recipe contract: `Field` classification, all-ground edges, no road metadata, preserved service-path cells, wood floor cells, threshold concrete, and reserved clearances.~~
3. ~~Add the smallest ground palette and deterministic terrain variation. Run the focused generator tests and inspect the generated map before adding furniture.~~
4. ~~Replace the ground-floor concrete material where appropriate, preserving threshold and staircase exceptions. Validate the generated map independently.~~
5. ~~Add the ground-floor cabin furnishing composition and any loft/lean-to additions. Add only gameplay-relevant furniture anchors and update required target assertions.~~
6. ~~Add bounded exterior vegetation and nature-prop runtime area membership, then tune density and protected regions through editor inspection.~~
7. ~~Add restrained work-yard wear, clutter, fence/overgrowth relationships, and any available abandoned props.~~
8. ~~Regenerate both the maintained example and production map from their respective recipes, compare the complete published artifact, and inspect the result in Godot/content editor.~~
9. ~~Run the structural, deterministic, validator, DMap, and real navigation acceptance matrix. Do not mark this phase complete if any detail pass blocks an existing route or changes the canonical doorway contract.~~

#### 10.8.8 Acceptance criteria

All acceptance criteria below are complete for the maintained Pine Hollow outpost. The final implementation includes controlled ground variation, furnished and navigable cabin spaces, sparse runtime nature dressing, authored container itemgroups, preserved route/doorway semantics, generated-map validation, deterministic output, and final content/editor acceptance.

The detail pass is complete because all of the following acceptance conditions were met:

* the ground has visible but controlled deterministic variation beyond one uniform grass tile;
* the cabin ground floor visibly reads as wood or an explicitly documented catalog limitation is resolved;
* the ground floor contains a deliberate, playable furnishing composition;
* vegetation and nature props are visible in the field and around the outpost without obstructing routes;
* the service path remains pedestrian-scale, continuous, and distinct from road infrastructure;
* the cabin entrance, threshold, stairs, loft, lean-to, work crate, and required furniture remain valid;
* no feature overwrites, unsupported IDs, invalid rotations, or out-of-bounds placements are introduced;
* the production and fixture recipes remain semantically equivalent where intended, while retaining their distinct IDs;
* the standalone `MapValidator` reports no errors for the published map;
* production regeneration is byte-identical to the committed published map;
* the full Python map-tool suite passes;
* focused and full Godot GUT suites pass, including real `Chunk`/`NavigationServer3D` Pine Hollow traversal and blocked-wall tests;
* manual Godot/content-editor review confirms the outpost reads as a rural, weathered, inhabited-then-abandoned location rather than a decorated test rectangle.

#### 10.8.9 Explicit non-goals

Do not include the following in this detail pass:

* a new generic automatic room-furnishing algorithm;
* automatic vegetation inferred from `Field` classification;
* a new roadside placement or adjacency system;
* map-to-map road integration;
* town, settlement, or overmap-wide composition;
* physical ceiling generation;
* generalized tall-storey `wall_height`.

### 10.9 Crater Research Camp maintained content map — implementation complete

**Status: implementation and automated acceptance complete; manual in-game/content-editor visual review pending**

`crater_research_camp` demonstrates that the generic recipe workflow can ship a finished field location without adding map-specific generator behavior. The map uses `Field` and `Plains` categories with `ground` on all four edges. Its authored composition includes a four-level-deep rock crater with an asymmetric rounded basin and irregular rim inspired by `crater_small`, nested solid-backed terraces, exposed-surface debris coverage kept off the access route, and four sparse reversible slopes linking the surface to z=-4, an enclosed metal research hut with a canonical east-side entrance and an explicitly authored standable cracked-concrete roof, a connected service path, a concrete outdoor equipment pad, scientific and industrial furniture with deliberate rotations, container itemgroup overrides, hazardous-material props, and reserved navigation cells.

Runtime areas provide broad field-ground variation outside the protected camp/crater envelope, sparse nature dressing, crater-floor rock debris, and a possible security-robot patrol. The field palette follows the proven `crater_small` grass/dirt/flower proportions; the crater, hut, path, and equipment pad remain explicitly authored so runtime area selection cannot overwrite focal geometry. Existing catalog assets were sufficient, so no new tile or furniture definitions were introduced. A dedicated 128×128 tactical-map preview accompanies the published JSON.

The maintained source/output set is:

* `Tools/recipes/crater_research_camp.json` — production source of truth;
* `Tools/examples/map_recipe_crater_research_camp.json` — structurally equivalent maintained fixture with distinct example identity;
* `Mods/Dimensionfall/Maps/crater_research_camp.json` and `.png` — published runtime map and preview;
* `Tests/Unit/test_crater_research_camp_navigation.gd` — real `Chunk`/`NavigationServer3D` hut-to-rim and crater descent/ascent acceptance.

The generated-map contract asserts map classification and connections, crater depth and slope rotation, building ownership and canonical entrance metadata, exact focal furniture rotations and itemgroups, protected clear route cells, runtime-area entity pools, production/fixture parity, deterministic publication, and standalone validation.

## Phase 11 — Generalized tall-storey wall height

**Status: deferred pending a concrete tall-storey gameplay requirement; Phase 10 acceptance is green**

Do not reintroduce `wall_z`. Ordinary storeys always derive walls as `floor_z + 1`.

When a real tall-room requirement exists, add the smallest generic `wall_height` contract:

```json
{"z": 0, "wall_height": 2, "rooms": ["tall_hall"]}
```

This means:

```text
floor z0
wall layers z1 and z2
roof surface z3
```

Required constraints:

* omitted `wall_height` means `1`;
* it is a positive integer;
* every derived wall layer remains within logical bounds;
* a wall span ends strictly below the next occupied floor;
* the roof surface is derived from the highest wall layer;
* wall boundaries materialize across every derived wall layer;
* supports remain at the owning floor and are not duplicated vertically;
* multi-layer door/window openings are rejected initially unless an explicit opening-span design exists.

Implement this only with test-first coverage in `Tools/tests/test_map_generator.py`, then mirror validation in `Tools/map_validator.py` and `Scripts/Gamedata/DMap.gd`. Add a minimal `Tools/examples/map_recipe_tall_storey_building.json` and focused GUT navigation/collision coverage before applying it to farmland or any other maintained map.

---

# Recommended immediate next task

**Recommended next task: manually review Crater Research Camp in the content editor/game, then define a concrete tall-room gameplay requirement before implementing Phase 11 (`wall_height`).** Pine Hollow is complete, and Crater Research Camp has complete implementation and automated acceptance with only its visual walkthrough pending. After that review, the plan has no remaining location-specific work for either map. Phase 11 is the next defined generator milestone, but it should remain deferred until a real location or gameplay feature requires storeys taller than the current one-wall-layer rule. Once that requirement exists, begin with test-first coverage for the generic `wall_height` contract, then update the generator, standalone validator, DMap sanitization, a minimal example recipe, and focused Godot navigation/collision tests.

Until that requirement exists, the best next step is a short discovery/design pass: choose the first concrete tall-room use case, define its door/window opening behavior and expected roof/support geometry, and only then start Phase 11 implementation. Do not reopen Pine Hollow or generate towns/overmap-wide composition as a substitute; preserve the established map-level areas, room semantics, runtime itemgroup behavior, and map-edge contracts.

Run the complete Python suite, relevant Godot tests or smoke checks, all maintained example generations through `Tools/map_validator.py`, and `git diff --check` after implementation work.

Do not commit or push unless explicitly requested.

---

# Current position in one view

```text
[Complete] Hermes-compatible repository guidance
[Complete] Existing map sanitation
[Complete] Fixed-size map validation
[Complete] Minimal JSON recipe format
[Complete] Deterministic 32×32 generator
[Complete] Base tile and rectangle overlays
[Complete] General tile-placement primitives
[Complete] Manual example generation and evaluation harness
[Complete] Generator and validator test suite
[Complete] Documentation and recognizable outdoor example
[Complete] Development moved to snipercup/CataX

[Complete] Palettes, reusable cell patterns, and deterministic variation
[Complete] Vertical-level schema and 3D placement foundations
[Complete] Structural generation, slope geometry, baked paths, and player traversal
[Complete] Feature and furniture schema investigation
[Complete] Level-aware single-cell furniture placement
[Complete] Deterministic conflict-aware outdoor furniture distribution
[Complete] Furnished-clearing editor and runtime verification
[Complete] Outdoor rock and wild-vegetation content definitions
[Complete] Dedicated AI-generated outdoor sprite replacement
[Complete] Final Phase 5 outdoor-asset inspection
[Complete] Level-aware runtime area schema and maintained example
[Complete] Catalog-validated runtime area entity variation
[Complete] Authored room semantics (`enclosed`, `covered_open`, `ruin`)
[Complete] Explicit room-to-exterior and room-to-room door-link metadata
[Complete] Authored existing-wall and connected-door boundary references
[Complete] Opt-in directional completeness validation for `enclosed` rooms
[Complete] Small single-level authored building footprint
[Complete] Authored roof/ceiling semantics for validated footprints
[Complete] Validated building-level composition constraints
[Complete] Authored building access-completeness validation
[Complete] Authored building interior classification constraints
[Complete] Authored building exterior/open-space classification constraints
[Complete] Validated building-level room partition constraints
[Complete] Validated building overhead-classification constraints
[Complete] Authored building-level external footprint context constraints
[Complete] Validated building-level exterior-access context constraints
[Complete] Authored building-level entrance semantics constraints
[Complete] Validated building-level entrance orientation and approach alignment
[Complete] Authored multi-entrance building semantics with per-entrance validation
[Complete] Authored furniture anchor metadata
[Complete] Authored map-edge connection metadata
[Complete] Authored road endpoint anchoring
[Complete] Authored road path routing metadata
[Complete] Multi-level building footprint foundation with intentional open gaps
[Complete] Per-floor room and furniture ownership metadata
[Complete] Two-slope staircase physical semantics at z 1 and z 2
[Complete] Straight and corner staircase formations with no slope stacking
[Complete] Per-floor ceiling/floor surface semantics (top-down)
[Complete] Multi-level roof/support semantics
[Complete] Opt-in physical building floors, wall boundaries, and supports
[Complete] Multi-level building navigation test through authored slope geometry
[Complete] Enclosed maintained building geometry with walls one level up and dirt below
[Complete] Manual player traversal of the maintained enclosed generated building
[Complete] Physical standable roof generation for the maintained multi-level building
[Complete] Wall and door placement decoupling via `target_at`/`room_at`
[Complete] Map-local road route painting between declared endpoints
[Complete] Runtime navigation validation for a painted local road route
[Deferred] Explicit map-to-map edge compatibility (resume if needed)
[Complete] Rooms and buildings
[Complete] Roads and map connections
[Complete] Multi-level reusable templates and richer composition
[Complete] Phase 9.1 generic semantic single-storey and two-storey building profiles
[Complete] Phase 9.2 independent validator and DMap preservation for generic profiles
[Complete] Phase 9.3 generic required-route/static reachability contract
[Complete] Phase 9.4 reusable Godot runtime navigation fixture
[Complete] Phase 9.5 apply generic semantics and runtime checks to `field_farmland`
[Complete] Phase 10.2 focused `field_farmland` runtime gameplay checks
[Complete] Phase 10.3 maintained-fixture generation, standalone validation, and deterministic regeneration acceptance suite
[Complete] Phase 10.4 runtime structural-quality validation and Phase 10 success criterion
[Complete] Phase 10.5 Pine Hollow Outpost automated and manual acceptance plus field-map placement conversion
[Complete] Phase 10.6 room-derived surface operations and room-owned multi-level geometry
[Complete] Phase 10.7 canonical doorway and entrance declarations
[Complete] Phase 10.8 Pine Hollow detail and immersion pass
[In review] Phase 10.9 Crater Research Camp maintained content map — automated acceptance complete; manual visual review pending
[Next, pending concrete requirement] Phase 11 generalized tall-storey `wall_height`
[Target] Agent-generated playable maps
```

You are no longer experimenting with whether maps can be generated safely. That part is established. The project is now at the point of expanding the generator’s vocabulary until it can express an actual location.

