You have now completed the **foundation and first generator milestone**. The project can generate a structurally valid 32×32 Dimensionfall map from a compact recipe, but it cannot yet describe or place enough content to build a useful playable map.

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

* converting coordinates to array indices;
* producing all 1024 entries per populated level;
* inserting valid tile and furniture IDs;
* generating metadata;
* creating areas and connections;
* enforcing bounds;
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
* one populated level at level-array index 10;
* a base tile covering the entire map;
* ordered rectangular regions;
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
```

## 5. Generator and validator tests: complete for version 1

The current Python test suite contains 16 tests and passes.

Coverage includes:

* fixed 32×32 dimensions;
* exactly 1024 entries;
* deterministic generation;
* rectangular overlays;
* empty-tile representation;
* unknown fields;
* invalid IDs;
* unknown tile IDs;
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

---

# What the generator cannot do yet

The current recipe language is intentionally minimal. It cannot yet express most meaningful maps.

It does not currently support:

* lines or paths;
* rectangle outlines;
* circles or irregular regions;
* scattered terrain;
* weighted tile variation;
* terrain blending;
* multiple populated vertical levels;
* features or furniture;
* areas or rooms;
* doors;
* buildings;
* roads as semantic objects;
* map-edge connection placement;
* reusable templates;
* towns or settlements;
* biome rules;
* walkability checks;
* accessibility or connectivity checks;
* encounters, creatures, items, or spawn points;
* visual previews;
* importing an existing map into a recipe;
* regeneration while preserving hand-authored changes.

At present, it can create a technically valid field with rectangular patches. It cannot yet create a credible playable location.

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

**Status: next**

This should be the next branch.

Suggested name:

```text
feature/map-generator-primitives
```

or:

```text
hermes/map-generator-primitives
```

Recommended additions:

* single-cell placement;
* filled rectangle;
* rectangle outline;
* horizontal and vertical lines;
* general line placement;
* circles or ellipses;
* deterministic scattered placement;
* deterministic clusters;
* checker or repeating patterns;
* strict versus clipped boundary behavior.

These primitives are the basic vocabulary needed before attempting authored maps.

A recipe might begin to support:

```json
{
  "operations": [
    {
      "type": "line",
      "from": [0, 16],
      "to": [31, 16],
      "tile": {
        "id": "dirt-light"
      },
      "width": 2
    },
    {
      "type": "scatter",
      "region": {
        "x": 0,
        "y": 0,
        "width": 32,
        "height": 32
      },
      "tile": {
        "id": "grass-tall"
      },
      "density": 0.12
    }
  ]
}
```

The exact schema should be designed after inspecting the available tile and map formats.

### Success criterion

A recipe can generate a visually recognizable outdoor layout containing:

* a base terrain;
* one path;
* one bounded clearing;
* some deterministic scattered variation.

No furniture or buildings yet.

## Phase 4 — Tile palettes and reusable patterns

**Status: planned**

Raw tile IDs are cumbersome and encourage agents to invent invalid identifiers. Introduce semantic recipe-level palettes.

Example:

```json
{
  "palette": {
    "ground": [
      {
        "tile": "grass",
        "weight": 8
      },
      {
        "tile": "grass_variant",
        "weight": 2
      }
    ],
    "path": [
      {
        "tile": "dirt-light",
        "weight": 3
      },
      {
        "tile": "dirt-dark",
        "weight": 1
      }
    ]
  }
}
```

Goals:

* weighted deterministic selection;
* named tile sets;
* automatic rotation rules;
* reusable pattern definitions;
* fewer raw IDs throughout recipes;
* centralized checking of allowed tiles.

### Success criterion

The generator can create terrain that looks varied without requiring a recipe entry for every cell.

## Phase 5 — Features and furniture

**Status: planned; requires schema investigation**

This is where generated maps start becoming playable rather than merely visual.

The agent should first determine:

* how features are represented;
* how furniture or objects are stored;
* whether objects belong directly to tiles or separate arrays;
* how rotation and state are encoded;
* how IDs are validated;
* whether occupied tiles require supporting terrain;
* how multi-tile objects work.

Likely recipe concepts:

```json
{
  "features": [
    {
      "template": "tree",
      "at": [5, 8]
    },
    {
      "template": "bench",
      "at": [15, 13],
      "rotation": 90
    }
  ]
}
```

Necessary validation:

* known feature IDs;
* bounds;
* occupied-cell conflicts;
* support rules;
* prohibited overlap;
* deterministic scatter;
* placement failure reporting.

### Success criterion

Generate an outdoor map with trees, rocks, vegetation, and simple interactable or decorative objects.

## Phase 6 — Areas, rooms, and buildings

**Status: planned**

The generator needs semantic areas before it can create convincing buildings.

Capabilities:

* named rectangular or polygonal areas;
* room boundaries;
* floors and walls;
* doors and openings;
* indoor/outdoor designation;
* area metadata;
* reusable building footprints;
* furniture anchors;
* optional additional levels.

Example concept:

```json
{
  "buildings": [
    {
      "template": "small_cabin",
      "origin": [10, 9],
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
* upper levels have valid support and transitions;
* furniture remains inside intended rooms.

### Success criterion

Generate one small, enterable building that loads correctly and has a reachable interior.

## Phase 7 — Roads and map connections

**Status: planned**

The prototype currently puts placeholder connection values in the output. These need to become meaningful.

Capabilities:

* entrances on map edges;
* road endpoints;
* path routing between anchors;
* north/east/south/west connection metadata;
* guaranteed connection between entry points and important locations;
* bridge or obstacle handling where supported.

Validation should determine:

* whether every declared connection has a corresponding traversable edge;
* whether important map areas are reachable;
* whether roads terminate correctly;
* whether edge tiles match adjacent-map expectations.

### Success criterion

Generate a map with one or more working edge connections and a traversable road to its main feature.

## Phase 8 — Templates and compositional generation

**Status: planned**

Once primitives and object placement work, add reusable templates.

Possible templates:

```text
small cabin
large house
shop
warehouse
crossroads
road bend
pond
farm plot
forest clearing
camp
ruin
village square
```

Templates should be:

* parameterized;
* deterministic;
* validated independently;
* composable;
* able to expose anchors such as entrances and road connections.

Example:

```json
{
  "placements": [
    {
      "template": "village_square",
      "origin": [16, 16],
      "rotation": 0
    },
    {
      "template": "small_house",
      "anchor": "square.north",
      "entrance_facing": "south"
    }
  ]
}
```

### Success criterion

Create a small settlement by composing templates rather than manually specifying every wall, road, and object.

## Phase 9 — Semantic map recipes

**Status: long-term target**

At this point the agent should be able to write recipes in terms of design intent:

```json
{
  "biome": "temperate_forest",
  "layout": {
    "type": "small_settlement",
    "entry": "west",
    "center": "village_square"
  },
  "requirements": [
    "three houses",
    "one workshop",
    "a pond southeast of the square",
    "a road connecting west and east",
    "dense trees around the outer border"
  ]
}
```

The generator or a planning layer would translate those requirements into:

* anchors;
* templates;
* primitives;
* placement constraints;
* routing;
* validation.

This may eventually involve two distinct stages:

```text
High-level design
       ↓
Expanded concrete recipe
       ↓
Map generator
       ↓
Map JSON
```

Keeping planning separate from final generation would make failures easier to inspect.

## Phase 10 — Quality and gameplay validation

**Status: long-term requirement**

Structural validity is not enough. Generated maps eventually need higher-level checks:

* all required locations are reachable;
* edge connections are usable;
* doors are not blocked;
* buildings have interiors;
* paths do not end unexpectedly;
* important objects are accessible;
* no impossible overlaps occur;
* minimum walkable-space requirements are met;
* map density remains within useful ranges;
* visual variety is adequate;
* deterministic regeneration works.

Some checks can be implemented in Python. Others may need Godot or project runtime logic.

### Final success criterion

An agent can create a new playable map from a concise design request, run all relevant checks, and produce a map that needs refinement rather than structural repair.

---

# Recommended immediate next task

The next contribution should stay narrow: **placement primitives only**.

Do not combine primitives, buildings, features, roads, and semantic map generation into one branch. That would make the recipe format unstable and difficult to review.

A suitable Hermes task is:

```text
Extend the recipe-driven Dimensionfall map generator with a small set of
general-purpose tile placement primitives.

Read the repository guidance, current generator, validator, tests,
documentation, example recipe, tile database, and representative valid maps
before editing.

Keep the existing fixed 32x32 map format and one populated ground level.

Add an ordered `operations` recipe array. Preserve support for the existing
`regions` field during this branch unless there is a strong, documented reason
to migrate it.

Implement these operations:

1. `set`
   - places one tile at x, y

2. `rectangle`
   - places a filled rectangle
   - equivalent to the current region behavior

3. `rectangle_outline`
   - places only a rectangle's border
   - define behavior for width or height equal to 1

4. `line`
   - places a deterministic one-tile-wide line between two integer points
   - document the rasterization algorithm
   - support horizontal, vertical, and diagonal lines

5. `scatter`
   - places tiles within a rectangular region using the recipe seed
   - use either an explicit count or density, but not both
   - deterministic for the same recipe and seed
   - document whether existing cells are replaced

Requirements:

- operations execute in array order;
- later operations may overwrite earlier terrain;
- every coordinate must be checked against the fixed 32x32 grid;
- preserve `{}` as the empty-tile representation;
- reject unknown operation fields;
- reject invalid operation types;
- reject invalid coordinates and dimensions;
- do not silently clip out-of-bounds shapes unless clipping is explicitly part
  of the documented operation contract;
- preserve deterministic output;
- keep the generator independent of Godot;
- do not add furniture, areas, buildings, roads, towns, or additional levels
  in this branch.

Decide whether `regions` should internally translate into a rectangle
operation to avoid maintaining duplicate placement logic.

Add tests covering:

- each operation;
- operation ordering and overwrite behavior;
- horizontal, vertical, and diagonal lines;
- thin rectangle outlines;
- deterministic scatter;
- invalid scatter arguments;
- out-of-bounds operations;
- unknown operation fields and types;
- unchanged fixed dimensions and 1024-tile invariant;
- backwards compatibility with the current example recipe, if retained.

Update the recipe documentation and add or revise an example that produces a
recognizable outdoor test layout with a path, clearing, and scattered terrain.

Run the Python test suite, generate the example map, run the map validator,
inspect generated dimensions and tile count, and run git diff --check.

Do not commit or push.

Report the chosen recipe schema, placement semantics, tests, validation
results, limitations, and git diff summary.
```

---

# Current position in one view

```text
[Complete] Hermes-compatible repository guidance
[Complete] Existing map sanitation
[Complete] Fixed-size map validation
[Complete] Minimal JSON recipe format
[Complete] Deterministic 32×32 generator
[Complete] Base tile and rectangle overlays
[Complete] Generator and validator test suite
[Complete] Documentation and example recipe
[Complete] Development moved to snipercup/CataX

[Next]     General tile-placement primitives
[Planned]  Palettes and deterministic variation
[Planned]  Features and furniture
[Planned]  Areas and buildings
[Planned]  Roads and map connections
[Planned]  Reusable templates
[Planned]  Semantic map planning
[Planned]  Connectivity and gameplay validation
[Target]   Agent-generated playable maps
```

You are no longer experimenting with whether maps can be generated safely. That part is established. The project is now at the point of expanding the generator’s vocabulary until it can express an actual location.

