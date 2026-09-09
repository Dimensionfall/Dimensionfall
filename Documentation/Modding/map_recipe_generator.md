# Recipe-driven map generator

`Tools/map_generator.py` converts a compact JSON recipe into a complete Dimensionfall map JSON file. Dimensionfall maps have fixed dimensions of 32 x 32 tiles and 21 possible logical levels from `z: -10` through `z: 10`. Every populated level has exactly 1024 entries; unused levels remain `[]`.

## Usage

Run from the repository root:

```sh
python3 Tools/map_generator.py \
  Tools/examples/map_recipe.json \
  /tmp/generated_meadow_prototype.json
python3 Tools/map_validator.py /tmp/generated_meadow_prototype.json
```

Recipes used for production maps may live under `Tools/recipes/`; small schema fixtures remain under `Tools/examples/`. Both use the same generator and validator contract. Maintained production examples include Pine Hollow (`Tools/recipes/pine_hollow_outpost.json` → `Mods/Dimensionfall/Maps/pine_hollow_outpost.json`) and Crater Research Camp (`Tools/recipes/crater_research_camp.json` → `Mods/Dimensionfall/Maps/crater_research_camp.json`). Published maps also need a same-ID `.png` preview for warning-free Godot loading and map-browser thumbnails.

The output filename must be `<id>.json`, matching the map loader's filename-derived ID. Existing output is protected. Pass `--overwrite` only when replacement is intended. Use `--tiles PATH` to validate tile IDs against a tile database other than `Mods/Dimensionfall/Tiles/Tiles.json`. Furniture operations validate against `Furniture/Furniture.json` beside the selected `Tiles` directory by default; use `--furniture PATH` when that database is elsewhere.

For batch generation of deterministic seed variants and instructions for inspecting them in Godot's content editor, see [`map_example_generation.md`](map_example_generation.md).

## Recipe format

The root must be a JSON object with these fields:

| Field | Type | Meaning |
| --- | --- | --- |
| `id` | string | Map ID using only letters, numbers, `_`, and `-`. |
| `name` | non-empty string | Display name. |
| `description` | non-empty string | Map description. |
| `categories` | array of strings | Optional map-selection categories. Pine Hollow uses `["Field"]` so it participates as a generic field map rather than a road segment. |
| `seed` | integer | Fixed seed used by tile and furniture palettes, random rotations, scatter, and pattern cells. Recipe input only; the map format does not store it. |
| `base_tile` | tile object | Legacy-mode tile initially placed in every cell at `z: 0`. Required unless `levels` is used. |
| `palette` | object | Named weighted tile sets that tile objects can reference. Optional; defaults to `{}`. |
| `furniture_palette` | object | Named weighted furniture sets used by `furniture_scatter`. Optional; defaults to `{}`. |
| `areas` | array | Strict runtime area definitions referenced by `area_rectangle`. Optional; defaults to `[]`. |
| `patterns` | object | Named arrays of relative tile placements used by `pattern` operations. Optional; defaults to `{}`. |
| `regions` | array | Legacy filled rectangles. Optional; defaults to `[]`. |
| `operations` | array | Ordered placement operations. Optional; defaults to `[]`. |
| `levels` | non-empty array | Explicit grouped level definitions. Cannot be combined with root `base_tile`, `regions`, or `operations`. |
| `connections` | object | Authored map-edge connection metadata. Optional; defaults to all `"ground"`. |
| `road_endpoints` | array | Authored road endpoint anchors at map edges. Optional; defaults to `[]`. |
| `road_paths` | array | Authored cardinal routes between road endpoints. Optional; defaults to `[]`; a path may paint a map-local route with `tile`. |
| `templates` | object | Reusable template definitions with relative `levels`, optional named `anchors`, and declared parameter definitions. Optional; requires `placements` when present. |
| `placements` | array | Template placements with a literal `origin` or anchor-to-anchor alignment through `anchor_to` and `at_anchor`, plus optional parameter overrides. |
| `building_surfaces` | array | Authored per-building floor, ceiling, and roof surface semantics. Optional; defaults to `[]`. |
| `building_supports` | array | Authored multi-level structural support paths. Optional; defaults to `[]`. |

A recipe does not define map dimensions: all generated maps are 32 x 32. Top-down `[x, y]` coordinates start at the top-left. Logical `z` is vertical elevation, not a third element in `[x, y]`. Every shape must fit entirely within the map; operations are never silently clipped.

A tile object has exactly one of:

- `id`: a raw tile ID from the selected `Tiles.json`; or
- `palette`: the name of a root-level palette.

It may also include an optional `rotation` when using `id`. Rotation is `0`, `90`, `180`, `270`, or `"random"`. Operation tiles may be `null`, which writes the project's empty-tile representation, `{}`.

Palette entries are objects with `id`, optional positive integer `weight` (default `1`), and optional `rotation`. Palette names may contain only letters, numbers, underscores, and hyphens. Palette selection uses the same seeded random-number generator as scatter, furniture scatter, and random rotation, so the same complete recipe and seed produce identical output. Changing a recipe from a raw tile to a palette reference may change later random choices because palette selection consumes random numbers.

```json
{
  "palette": {
    "ground": [
      {"id": "grass_plain_01", "weight": 8, "rotation": "random"},
      {"id": "grass_flowers_00", "weight": 2, "rotation": "random"}
    ],
    "path": [
      {"id": "dirt_light_00", "weight": 3},
      {"id": "grass_dirt_00", "weight": 1, "rotation": "random"}
    ]
  },
  "base_tile": {"palette": "ground"}
}
```

Legacy `regions` are applied first in array order, followed by `operations` in array order. Pattern cells are expanded in their definition order at the position of the invoking operation. Later tile placements on the same logical level overwrite earlier cells, including the complete `feature` of an earlier furnished tile. A furniture operation instead rejects a cell that already has a feature. `regions` remain supported for version-one recipes and use the same filled-rectangle placement implementation as `rectangle` operations.

## Map-edge connections

The `connections` field authors the map's edge connection metadata — the type of terrain or road that connects at each cardinal edge. The runtime uses these values to select appropriate edge tiles when the map is instanced in the overworld.

```json
{
  "connections": {
    "north": "ground",
    "east": "road",
    "south": "ground",
    "west": "road"
  }
}
```

Each key is one of `north`, `east`, `south`, or `west`; each value is one of `ground` or `road`. Omitted directions default to `"ground"`, so existing recipes without a `connections` field remain compatible. The standalone validator rejects unknown directions and unsupported connection types.

This field authors metadata only: it does not generate road tiles, path routing, or edge tile placement. It declares what the runtime should expect at each edge so the overworld generator can connect adjacent maps correctly.

For a field location such as Pine Hollow, leave all four edge connections as `"ground"` and use an ordinary `line` operation for a local pedestrian/service path. That path is map-local geometry and does not imply that vehicles can enter the map from an edge. Pine Hollow's maintained recipe uses a short `dirt_light_00` line from `[8, 14]` to `[10, 14]`, ending at the connection-level exterior approach.

## Road endpoints

The `road_endpoints` field authors named anchor points that identify where roads enter or exit the map at its edges. Each endpoint is a data-only reference point — it does not generate road tiles, path routing, or geometry.

```json
{
  "connections": {"north": "ground", "east": "road", "south": "ground", "west": "road"},
  "road_endpoints": [
    {"id": "west_entrance", "direction": "west", "at": [0, 16], "z": 0},
    {"id": "east_exit", "direction": "east", "at": [31, 16], "z": 0}
  ]
}
```

Each entry has exactly `id`, `direction`, `at`, and `z`. `id` is unique within the recipe and follows the standard naming pattern. `direction` is one of `north`, `east`, `south`, or `west` and must match a `connections` entry whose value is `"road"` — a road endpoint cannot be placed on an edge declared as `"ground"`. `at` is a two-integer `[x, y]` coordinate that must lie on the correct map edge for its `direction` (north edge: `y = 0`, south edge: `y = 31`, west edge: `x = 0`, east edge: `x = 31`). `z` must be `0` — road endpoints are ground-level only in this first slice.

The standalone validator independently checks the same content: it rejects unknown directions, duplicate IDs, coordinates not on the correct edge, and non-zero `z` values. `DMap` preserves valid road endpoints through editor save/load and removes entries with missing fields, invalid directions, duplicate IDs, or malformed coordinates.

`road_paths` authors a named cardinal polyline between two road endpoints. For a map-local physical route, add a `tile` field; the generator rasterizes every cell in the route and replaces its terrain with that tile. This keeps route geometry explicit and deterministic while avoiding a second pathfinding system.

```json
{
  "road_paths": [
    {
      "id": "west_to_east_road",
      "from": "west_entrance",
      "to": "east_exit",
      "waypoints": [],
      "tile": {"id": "dirt_light_00"}
    }
  ]
}
```

Each path requires `id`, `from`, `to`, and `waypoints`; `tile` is optional for backwards-compatible metadata-only paths. Both endpoint IDs must exist and be different. `waypoints` is an optional array of map-bounded `[x, y]` coordinates; the complete sequence from the `from` endpoint through the waypoints to the `to` endpoint must form cardinally aligned segments. When `tile` is present, it must reference a known non-empty `Ground` cube tile, every route cell must contain supporting terrain, route cells may not contain features, and the generator paints the complete ground-level route. This conservative tile guard makes the generated route suitable for runtime navigation geometry; the Godot navigation test verifies actual connectivity. The generator still does not run pathfinding, alter collision/navigation, or integrate multiple maps. `DMap` preserves valid paths with or without `tile` and removes paths with stale endpoints, malformed points, duplicate IDs, invalid tile objects, or non-cardinal segments.

`Tools/examples/map_recipe_road_endpoints.json` demonstrates the maintained example with two road endpoints: `west_entrance` at the west edge and `east_exit` at the east edge.

## Minimal template expansion

Templates are expanded before ordinary recipe validation and generation. A template defines relative `levels` and may define named anchors as `{ "at": [x, y], "z": dz, "facing": "north" }`. Anchors are relative to the placement origin and are not serialized into the generated map. A placement may use a literal `origin`, or align its `at_anchor` to an anchor on a prior placement using `anchor_to`.

```json
{
  "templates": {
    "small_cabin": {
      "parameters": {
        "floor_tile": {"type": "tile_id", "default": "concrete_00"},
        "wall_material": {"type": "enum", "values": ["brick", "metal"], "default": "brick"},
        "style": {
          "type": "object",
          "properties": {
            "support_tile": {"type": "tile_id", "default": "dirt_light_00"},
            "wall_tile": {"type": "tile_id", "default": "brick_wall_00"},
            "include_roof": {"type": "boolean", "default": true}
          }
        },
        "width": {"type": "integer", "minimum": 3, "maximum": 6, "default": 4},
        "height": {"type": "integer", "minimum": 3, "maximum": 6, "default": 4},
        "features": {"type": "string_list", "values": ["roof"], "default": ["roof"]}
      },
      "anchors": {
        "entrance": {"at": [0, 1], "z": 0, "facing": "west"},
        "exit": {"at": [4, 1], "z": 0, "facing": "east"}
      },
      "levels": [
        {"dz": 0, "operations": [
          {"type": "rectangle", "x": 0, "y": 0, "width": "$width", "height": "$height", "tile": {"id": "concrete_00"}}
        ]}
      ]
    }
  },
  "placements": [
    {"template": "small_cabin", "origin": {"at": [10, 10], "z": 0}, "rotation": 0},
    {
      "template": "small_cabin",
      "anchor_to": {"placement": 0, "anchor": "exit"},
      "at_anchor": "entrance",
      "parameters": {"style": {"wall_tile": "metal_wall_00", "include_roof": false}},
      "rotation": 0
    }
  ]
}
```

Templates can also expose named rectangular `locations` for richer three-dimensional composition:

```json
"locations": {
  "roof_pad": {"at": [0, 0], "z": 2, "width": 4, "height": 4}
}
```

A root placement may align an equal-sized location on an earlier placement:

```json
{
  "template": "roof_module",
  "location_to": {"placement": 0, "location": "roof_pad"},
  "at_location": "roof_pad",
  "rotation": 0
}
```

Locations resolve their local rectangle through placement rotation and `origin.z + location.z`. The placed and referenced rotated dimensions must match exactly. Location alignment intentionally permits overlap inside the referenced location volume; ordinary root placements still reject conflicting three-dimensional footprints. Anchor-connected placements likewise permit overlap with their explicitly referenced placement, preserving intentional coincident-anchor composition. Each placement footprint is conservatively derived from its resolved set, rectangle, outline, line, pattern, scatter, furniture, area, room, and nested operations. Out-of-bounds x/y/z cells and unconnected conflicts are rejected before ordinary generation.

Nested templates are declared with a template-local `placements` array. A nested placement uses `{ "template", "origin", "rotation", "parameters" }`; its `origin.at` and `origin.z` are relative to the enclosing template origin, its rotation is added to the enclosing rotation, and its parameter values may reference enclosing parameters. The child template expands recursively into ordinary root operations. Nested placements intentionally use literal local origins in this slice: they cannot use `anchor_to`, `at_anchor`, or `rotation: "auto"`, and child anchors are not re-exported through the parent. Cycles, unknown child templates, malformed local origins, unsupported rotations, unresolved forwarded parameters, and logical-z overflow are rejected.

For anchor-to-anchor placement, the referenced placement must appear earlier in the `placements` array. `rotation` accepts `0`, `90`, `180`, or `270` degrees clockwise around the template origin. It rotates all local horizontal operation coordinates, rectangular footprints, line endpoints, scatter regions, patterns, anchors, anchor `facing`, and explicit tile/furniture/pattern rotations; it never changes relative `dz`. Set `rotation` to `"auto"` only with `anchor_to` and `at_anchor` to derive the quarter-turn that makes the placed anchor face opposite the referenced anchor. Auto rotation requires both connected anchors to declare cardinal `facing` values; it resolves the placed `at_anchor` after rotation before aligning it to the prior anchor. To place separate structures side by side, author connection anchors on the exterior edge immediately beyond each footprint (for example, a 4×4 template can use west `[0, 1]` and east `[4, 1]` anchors); interior anchors intentionally produce overlapping geometry when coincident.

Templates may declare typed `parameters`. `tile_id` values substitute exact `$parameter_name` strings before normal operation validation and may provide a string `default`; without a default they are required on every placement. `boolean` values may provide a boolean `default` and control a template operation with `"when": "$parameter_name"`. `enum` values require a non-empty, unique string `values` array and may provide a default from that array; they select semantic operation variants with `"when": {"parameter": "material", "equals": "metal"}`. `integer` values require inclusive integer `minimum` and `maximum` bounds and can substitute operation coordinates, dimensions, or counts. `string_list` values require an allowed non-empty, unique string `values` array; each resolved list is unique and may be empty, and `"when": {"parameter": "features", "contains": "roof"}` conditionally includes an operation. `object` values require a non-empty declared `properties` object; each property uses any supported parameter schema, resolves its own default or required value, and rejects unknown fields. Use an exact dotted reference such as `$style.wall_tile` or `$style.include_roof` to substitute a declared object field. Placements override declared values through `parameters`. Unknown overrides, missing required values, malformed declarations, invalid enum/list values, out-of-range integers, unresolved `$` references, and invalid conditions are rejected. Substituted tile IDs then follow the same tile-database validation as literal tile IDs.

The expansion supports existing `set`, rectangle, outline, line, pattern, scatter, furniture, area-rectangle, room-rectangle, and furniture-scatter operation shapes. It rejects nested operation `z` values, unsupported rotations, automatic rotation without a connected facing anchor pair, invalid nested placements, template cycles, malformed locations, incompatible location dimensions, unknown templates or anchors, duplicate relative `dz` levels, forward root-anchor/location references, out-of-bounds three-dimensional footprints, and unconnected conflicting footprints. Templates cannot yet be combined with the grouped root `levels` layout. The generated map contains only expanded ordinary recipe output; `templates`, `placements`, anchors, and locations are not serialized.

`Tools/examples/map_recipe_small_cabin_template.json` is the maintained template-feature example. Its tests verify deterministic expansion, relative `dz` placement, nested roof-panel composition with forwarded style and dimension parameters, anchor-to-anchor alignment, automatic facing-compatible rotation, structured style-object overrides, bounded integer footprint dimensions, and a rotated 5×3 footprint.

`Tools/examples/map_recipe_village_square_composition.json` is the maintained Phase 9 map-local composition example. It composes a central plaza with nested benches, exposed road anchors, and two automatically oriented multi-level cabin variants. Generate it with `python3 Tools/map_generator.py Tools/examples/map_recipe_village_square_composition.json Mods/Dimensionfall/Maps/generated_village_square_composition.json --overwrite`, then validate the generated map with `python3 Tools/map_validator.py Mods/Dimensionfall/Maps/generated_village_square_composition.json`.
## Logical levels

Map level-array index `10` is logical ground level `z: 0`. The conversion is:

```text
level-array index = logical z + 10
logical z = level-array index - 10
```

Valid logical levels are integers from `-10` through `10`. Booleans are not integers for recipe purposes. A populated level contains 1024 row-major cells, while a level containing no non-empty tiles is serialized as unused `[]`.

There are two mutually exclusive authoring modes.

### Legacy-compatible root layout

Existing recipes continue to use root `base_tile`, `regions`, and `operations`. The base tile fills `z: 0`. Every root region and operation accepts optional `z`; omission means `z: 0`. Targeting a previously unused level starts that level as empty cells before applying the placement.

```json
{
  "base_tile": {"id": "grass_plain_01"},
  "operations": [
    {
      "type": "pattern",
      "pattern": "wildflower_cluster",
      "at": [16, 12],
      "z": 1,
      "rotation": 90
    }
  ]
}
```

Root `regions` are still processed before root `operations`, even when entries target different logical levels. RNG consumption follows this exact processing order.

### Grouped multi-level layout

For substantial multi-level maps, use a root `levels` array. Every entry requires one unique logical `z` and may contain `base_tile`, `regions`, and `operations`. The entry's base tile, when present, fills that level before its regions and operations. Without a base tile, the level starts empty.

```json
{
  "levels": [
    {
      "z": 0,
      "base_tile": {"id": "grass_plain_01"}
    },
    {
      "z": 1,
      "operations": [
        {
          "type": "rectangle",
          "x": 10,
          "y": 10,
          "width": 12,
          "height": 12,
          "tile": {"id": "grass_plain_01"}
        }
      ]
    }
  ]
}
```

Grouped entries are processed in declaration order. Within each entry, regions precede operations. This declaration order also defines deterministic RNG consumption across levels. Nested regions and operations inherit the entry's `z` and must not repeat a `z` field. Root `base_tile`, `regions`, and `operations` cannot coexist with `levels`; this rejects ambiguous merge and overwrite ordering.

Reusable pattern definitions remain two-dimensional. A root pattern operation selects its target with `z`, while a grouped pattern operation inherits the enclosing level. Multi-level pattern and template composition is outside the current schema.

## Reusable cell patterns

`patterns` maps a name to a non-empty array of relative tile placements. Pattern names follow the same naming rules as palettes. Every cell has an integer `[x, y]` offset in `at` and a `tile`; offsets may be negative, and tiles may use raw IDs, palettes, rotations, or `null` just like operation tiles.

Pattern definitions do not consume random numbers. An invoked pattern consumes randomness in cell-array order only when a cell uses a palette or `"random"` tile rotation. Unused definitions therefore do not change generated output.

```json
{
  "patterns": {
    "wildflower_cluster": [
      {"at": [0, 0], "tile": {"palette": "flowers"}},
      {"at": [1, 0], "tile": {"palette": "flowers"}},
      {"at": [-1, 1], "tile": {"palette": "flowers"}}
    ]
  }
}
```

## Furniture palettes

`furniture_palette` maps a name to a non-empty weighted array of known furniture entries. Entries have `id`, optional positive integer `weight` (default `1`), and optional editor-facing `rotation` (`0`, `90`, `180`, `270`, or `"random"`). Furniture palette names use the same letters/numbers/underscore/hyphen rule as tile palettes. Every entry is validated against the selected furniture database, including unused palette definitions.

```json
{
  "furniture_palette": {
    "clearing_trees": [
      {"id": "Tree_00", "weight": 4, "rotation": "random"},
      {"id": "PineTree_00", "weight": 3, "rotation": "random"},
      {"id": "WillowTree_00", "weight": 1, "rotation": "random"},
      {"id": "burned_tree_stump", "weight": 2, "rotation": "random"}
    ]
  }
}
```

Definitions themselves consume no randomness. An invoked `furniture_scatter` first samples eligible cells, in row-major candidate order, and then selects one palette entry and resolves any random rotation for each sampled cell in the sample order. This is part of the shared recipe RNG stream: moving, adding, or removing an earlier RNG-consuming operation can change later selections.

## Placement operations

Every operation requires a `type`. Unknown operation types and fields are errors. At the recipe root, every operation accepts optional logical `z` and defaults to `0`. Inside a grouped level, the operation inherits `z` and must omit the field.

## Runtime areas and tile membership

Dimensionfall's existing area system has two linked serialized forms:

1. the map-level `areas` array defines a runtime spawn/transformation rule; and
2. a terrain tile's `areas` array records membership as `{"id": "...", "rotation": 0}`.

At runtime, `Helper.map_manager.process_areas_in_map()` selects definitions by `spawn_chance`, then applies each selected definition to connected clusters of matching tile memberships on every populated level. The editor displays these memberships and permits multiple *different* area IDs on one tile, so recipe generation preserves that supported overlay behavior. It rejects a duplicate membership of the same area ID on the same cell.

Recipe area definitions require exactly `id`, `spawn_chance`, `rotate_random`, `pick_one`, `tiles`, and `entities`. Area IDs use letters, numbers, `_`, and `-`; `spawn_chance` is an integer from `0` through `100`; `rotate_random` and `pick_one` are booleans. `tiles` is a non-empty array of `{ "id", "count" }` entries whose IDs are known tiles or the runtime's `"null"` sentinel. `entities` is an array of `{ "id", "type", "count" }` entries. The generator accepts only the existing runtime entity types—`furniture`, `mob`, `mobgroup`, and `itemgroup`—and validates each ID against its core catalog before publishing a map.

```json
{
  "areas": [
    {
      "id": "meadow_clearing",
      "spawn_chance": 100,
      "rotate_random": false,
      "pick_one": false,
      "tiles": [{"id": "grass_dirt_00", "count": 1}],
      "entities": []
    }
  ]
}
```

### Runtime entity variation

An area entity is a runtime rule, not a pre-generated feature. For every processed membership tile, `map_manager` adds an implicit no-spawn entry weighted by the total `tiles` weight, then selects one declared entity by `count`. As a result, the generated JSON boundary is deterministic, but an entity-bearing field can differ each time the map is instanced. Do not replace this with `furniture_scatter` when per-instance variation is desired: scatter intentionally writes the same seeded features into every generated map.

Entity `count` values must be positive integers in recipes. The generator enforces that stricter authoring rule; the standalone validator accepts positive numeric legacy weights so existing authored maps continue to match the runtime's weighted-picker contract. The supported types and ID catalogs are:

| Type | Catalog | Runtime feature result |
|---|---|---|
| `furniture` | `Furniture/Furniture.json` | `{ "type", "id", "rotation" }` |
| `mob` | `Mobs/Mobs.json` | `{ "type", "id", "rotation" }` |
| `mobgroup` | `Mobgroups/Mobgroups.json` | `{ "type", "id", "rotation" }` |
| `itemgroup` | `Itemgroups/Itemgroups.json` | `{ "type": "itemgroup", "itemgroups": ["id"], "rotation" }` |

When `rotate_random` is false, a selected entity uses the membership's editor-facing rotation. When it is true, runtime chooses a quarter turn. Entity selection remains runtime-owned and is never pre-baked by the Python generator.

```json
{
  "id": "stump_clearing",
  "spawn_chance": 100,
  "rotate_random": false,
  "pick_one": false,
  "tiles": [{"id": "grass_dirt_00", "count": 100}],
  "entities": [{"id": "burned_tree_stump", "type": "furniture", "count": 1}]
}
```

### `area_rectangle`

Adds one area membership to every terrain tile in a filled rectangle. Fields are `type`, `area`, `x`, `y`, positive `width`, positive `height`, optional root-level `z`, and optional editor-facing `rotation`. The rotation defaults to `0` and accepts `0`, `90`, `180`, or `270`.

```json
{
  "type": "area_rectangle",
  "area": "meadow_clearing",
  "x": 10,
  "y": 10,
  "width": 12,
  "height": 12,
  "z": 0,
  "rotation": 0
}
```

The referenced top-level area must exist and every target cell must already contain terrain at the selected logical level. A membership operation does not replace terrain, features, or other distinct area memberships, and consumes no RNG. Coordinates are preflighted against the complete `32×32` map, so the operation cannot be clipped or partially applied.

## Authored room semantics

Rooms are authored semantic labels; they are not inferred from floor material, wall topology, door placement, or roof coverage. A recipe may define a root `rooms` array whose entries contain exactly an `id` and `kind`:

```json
{
  "rooms": [
    {"id": "office", "kind": "enclosed"},
    {"id": "garage_bay", "kind": "covered_open"},
    {"id": "ruined_store", "kind": "ruin"}
  ]
}
```

Supported kinds are:

| Kind | Authored meaning |
|---|---|
| `enclosed` | A conventional room intended to be physically enclosed once geometry generation is added. |
| `covered_open` | A roofed but intentionally open space, such as a garage without a garage door. |
| `ruin` | A semantic room that may deliberately have holes or open wall sections. |

Tile membership uses `rooms` as a one-element string array, for example `{"id": "concrete_00", "rooms": ["garage_bay"]}`. A terrain tile may have exactly one room label, while it may still carry multiple runtime `areas` memberships. This makes floor material and area behavior independent from room semantics: adjacent rooms may share one floor material, and one floor-like area can span several rooms.

### `room_rectangle`

Adds one authored room label to every terrain tile in a filled rectangle. Fields are `type`, `room`, `x`, `y`, positive `width`, positive `height`, and optional root-level `z`. It has no rotation because it is semantic metadata, not a spatial transform.

```json
{
  "type": "room_rectangle",
  "room": "garage_bay",
  "x": 12,
  "y": 7,
  "width": 10,
  "height": 8,
  "z": 0
}
```

The referenced root room must exist. Every target cell must already contain terrain, and room membership is exclusive: an operation cannot overlap another room label or partially apply. A same-z `room_surface` (below) may provide that terrain after membership has been declared. Room definitions and membership consume no RNG.

### `room_surface`

Materializes one tile across the final authored membership of a room. It is deliberately separate from generic coordinate operations: use `rectangle` for terrain, roads, yards, and intentional eaves; use `room_surface` when a floor or roof belongs to a room.

```json
{"type": "room_surface", "room": "outpost_loft", "z": 2, "tile": {"id": "concrete_00"}}
{"type": "room_surface", "room": "outpost_loft", "z": 4, "tile": {"id": "concrete_00"}, "outline_padding": 1}
```

Fields are exactly `type`, `room`, root-level `z`, `tile`, and optional `outline_padding`. The room must have authored membership on exactly one logical level. `outline_padding` defaults to `0`; a non-negative value expands every member cell by that Chebyshev radius, producing a one-cell padded `8×8` roof envelope around Pine Hollow's `6×6` loft without naming a duplicate rectangle. Derived cells must stay inside the map.

Room surfaces are deferred until every layout operation has painted room membership, so their result is independent of the order of `room_rectangle` operations. Existing runtime metadata is preserved. Features and authored slope tiles remain authoritative when a same-z room surface materializes beneath them. The operation validates unknown rooms, malformed or unknown tiles, invalid padding, missing room membership, multi-storey room membership, and out-of-bounds derived cells.

This slice preserves `rooms` through `DMap`/content-editor save-load paths and validates generated map output independently. `room_surface` is recipe-only authoring syntax and is not serialized into generated maps, so it requires no new DMap persistence field.

### `room_connections`

`room_connections` accepts the existing fields `id`, `at`, `target_at`, `z`, `from`, and `to`, plus the optional connection-level `entrance` object. Phase 10.7 implementation and focused tests now cover this object. It is valid only on room-to-exterior connections and must define exactly `exterior_at` and `facing`; both coordinates must be in bounds and facing must be cardinal. Generated connection data preserves the validated object. Conflicting legacy building entrance metadata is rejected during the compatibility window.

The supported form is:

```json
{
  "id": "office_front_door",
  "at": [8, 8],
  "target_at": [7, 8],
  "z": 0,
  "from": {"kind": "room", "id": "office"},
  "to": {"kind": "exterior"},
  "entrance": {"exterior_at": [6, 8], "facing": "east"}
}
```

The connection-level form is implemented and may now be used for new recipes. Existing recipes may continue using the established building-level `entrance`/`entrances`, `exterior_context`, and `exterior_access_context` fields during migration. Do not remove legacy door anchors or entrance/context records until exact-equivalence coverage is in place.


```json
{
  "room_connections": [
    {
      "id": "office_front_door",
      "at": [11, 10],
      "z": 0,
      "from": {"kind": "room", "id": "office"},
      "to": {"kind": "exterior"}
    },
    {
      "id": "office_to_garage",
      "at": [12, 10],
      "z": 0,
      "from": {"kind": "room", "id": "office"},
      "to": {"kind": "room", "id": "garage_bay"}
    }
  ]
}
```

`id` must be unique and use the normal definition-name characters. `at` is exactly `[x, y]` within the `32×32` map and `z` is a required logical level from `-10` through `10`. Endpoints use one of two exact forms:

```json
{"kind": "room", "id": "office"}
{"kind": "exterior"}
```

Room IDs must exist in root `rooms`; the two endpoints must be distinct; and one door coordinate may have only one connection. The target tile must already exist at the declared level and contain a catalog-recognized door-capable furniture feature—for example, `door_wood`, whose existing runtime implementation owns open/closed state and collision behavior.

Connections are semantic metadata only. They preserve their authored `from`/`to` order but do not create a new door feature, alter existing door behavior, infer enclosure, generate geometry, or introduce an indoor/outdoor runtime state. `DMap` preserves valid links through content-editor save/load and removes links that name deleted rooms.

### `room_boundaries`

`room_boundaries` explicitly attaches an existing physical wall tile or connected door opening to one authored room. It does not derive a perimeter from rooms, floor material, wall rotation, or neighboring geometry. A legacy/partial record contains `id`, `room`, `at`, `z`, and `element`; it may add `side` when directional evidence is needed:

```json
{
  "room_boundaries": [
    {
      "id": "office_north_wall",
      "room": "office",
      "at": [8, 7],
      "z": 0,
      "element": "wall_tile",
      "side": "south"
    },
    {
      "id": "office_front_opening",
      "room": "office",
      "at": [11, 10],
      "z": 0,
      "element": "door_furniture"
    }
  ]
}
```

`id` is unique and uses normal definition-name characters. `room` must name a root room, `at` is an in-bounds `[x, y]`, and `z` is a required logical level from `-10` through `10`. `element` is exactly one of:

| Element | Existing target requirement |
|---|---|
| `wall_tile` | The target terrain ID is in the tile catalog and has the `Wall` category; it must be cardinally adjacent to a tile labelled with the named room. |
| `door_furniture` | The target terrain tile contains catalog-recognized door-capable furniture and a `room_connections` entry at the same `[x, y, z]` names the room. |

A room cannot name the same target coordinate twice, but one wall tile may deliberately bound different rooms through separate records. `side`, when present, is `north`, `east`, `south`, or `west`. For `wall_tile`, it points from the wall tile toward its room; for `door_furniture`, it points outward from the room tile through that door.

An `enclosed` room may opt in to strict completeness by adding `"boundary_validation": "complete"` to its root definition. The legacy explicit mode requires every exposed cardinal edge of every labelled room tile to have exactly one directed `room_boundaries` record. Its records therefore require `side`: a wall must point to the matching room edge, and a door must start on the matching room tile and retain its required `room_connections` endpoint. Missing, wrongly oriented, duplicate, or non-exposed records are rejected. `covered_open` and `ruin` rooms cannot opt in and continue to allow partial boundary evidence.

For a normal generated enclosure, add `"boundary_generation": "walls"` alongside `boundary_validation` instead of enumerating each wall:

```json
{
  "id": "kitchen",
  "kind": "enclosed",
  "boundary_validation": "complete",
  "boundary_generation": "walls"
}
```

This mode requires an owning building with `building_geometry.wall_tile`. After final room membership is painted, the generator derives a one-tile wall ring at `floor_z + 1`, including diagonal corner caps. Every same-z `room_connections` link crossing a generated room perimeter becomes an opening; room-to-room links open the facing edge for both rooms while retaining the one authored door-furniture target. Connection crossings must be cardinal. Adjacent generated rooms without a connection share exactly one partition wall, deterministically placed on the lexicographically higher room ID's membership cell. Explicit `room_boundaries` for a generated room are rejected, so a recipe cannot mix competing wall-ownership modes. The standalone validator independently checks the resulting wall ring and openings against the building's declared wall tile. `room_rectangle` remains membership-only; it does not directly place walls.

Generated ground-storey wall supports use `dirt_light_00` while preserving existing room, area, and compatible tile metadata. Boundary generation does not create door furniture, infer connections, change navigation, or add indoor/outdoor effects.

### `buildings`

`buildings` groups authored room evidence into one explicit, rectangular building footprint. By default it remains metadata-only. An opted-in `building_geometry` record generates physical floors, authored wall-boundary tiles, and authored support tiles while preserving existing door features and staircase slopes:

```json
{
  "buildings": [
    {
      "id": "office_building",
      "rooms": ["office"],
      "footprint": {"x": 7, "y": 7, "width": 4, "height": 4},
      "z": 0
    }
  ]
}
```

Each record has required `id`, `rooms`, `footprint`, and `z`, plus optional `building_geometry`, `building_levels`, `staircases`, `access_validation`, `interior_rooms`, `open_space_rooms`, `room_partition_validation`, `overhead_validation`, `exterior_context`, `exterior_access_context`, `entrance`, `entrances`, `entrance_validation`, and `furniture_anchors`. `id` is unique; `rooms` is a nonempty list of unique known room IDs; `footprint` has exactly non-negative integer `x`/`y` plus positive integer `width`/`height`, fully inside the 32×32 map; and `z` is a required logical level from `-10` through `10`. Footprints on the same logical z must not overlap, though they may touch.

Every owned room must have membership only at the building level and wholly inside its footprint. At least one owned room must be an `enclosed` room with `"boundary_validation": "complete"`. Its same-level `room_boundaries` and any same-level `room_connections` naming it must also lie inside the footprint. Without `building_geometry`, this remains a strict ownership/containment contract; with it, the footprint's declared occupied levels receive generated floor terrain.

`building_geometry` has exactly these fields:

```json
{
  "building_geometry": {
    "floor_tile": {"id": "concrete_00"},
    "wall_tile": {"id": "brick_wall_00"},
    "support_tile": {"id": "brick_wall_00"},
    "roof_tile": {"id": "concrete_00"}
  }
}
```

`floor_tile` and `roof_tile` must be known `Ground`, `Floor`, or `Urban` tiles; `wall_tile` and `support_tile` must be known `Wall` or `Ground` tiles. The generator fills every declared occupied building level, materializes `wall_tile` boundaries one logical level above their boundary z, materializes `support_tile` at `building_supports.from_z`, and materializes `roof_tile` at the authored roof surface z. Every authored matching `wall_tile` at a building's ground-wall level receives `dirt_light_00` beneath it; elevated wall boundaries retain their storey's `floor_tile` beneath them. Existing features and slope tiles are preserved, lower staircase slope coordinates reserve empty headroom on the directly overhead z2 floor, and generated geometry rejects feature overwrites. `upper_clearance_at`, when authored on a staircase, clears that coordinate on z2 so an exceptional stair approach can retain player headroom. There is no independent wall elevation property; a future `wall_height` feature is deferred until genuinely tall storeys are required. Doors and staircase slopes remain authored operations; collision and navigation are verified by Godot tests rather than inferred by Python.

A building may declare a multi-level footprint foundation with `building_levels`:

```json
{
  "id": "office_building",
  "rooms": ["office"],
  "footprint": {"x": 7, "y": 7, "width": 4, "height": 4},
  "z": 0,
  "building_levels": [{"z": 0}, {"z": 2}]
}
```

`building_levels` is an optional non-empty, strictly ascending array of objects with required `z` and optional `rooms` and `furniture_anchors` arrays. The building record itself remains rooted at ground level `z: 0`. Declared occupied floor levels must be even logical levels: `z: 0` is the ground floor, `z: 1` is an intentional open gap, `z: 2` is the ceiling/first-floor level, `z: 3` is another open gap, and so on. The current supported range is `0` through `10`. Walls are derived at `floor_z + 1`; do not add an independent wall elevation field. A future `wall_height` property is deferred until genuinely tall storeys are needed. The declaration must start with `{"z": 0}`; odd levels are not occupied floor declarations. A declaration such as `[{"z": 0, "rooms": ["office"], "furniture_anchors": ["desk_anchor"]}, {"z": 2, "rooms": ["office_upper"], "furniture_anchors": ["upper_bench_anchor"]}]` assigns each room and furniture anchor to one occupied floor. When either ownership list is used, it must assign every aggregate building room or anchor exactly once. A declaration such as `[{"z": 0}, {"z": 2}, {"z": 4}]` remains valid as a vertical-only foundation without per-floor ownership lists.

Without `building_geometry`, this is a metadata-only foundation. With `building_geometry`, the generator creates physical floor, wall-boundary, support, and authored-roof tiles for the declared building levels. It still does not generate ceilings, doors, stairs, vertical transitions, indoor runtime state, or runtime behavior beyond the existing Chunk geometry for the emitted tiles. `DMap` preserves valid declarations through save/load and removes malformed declarations. Its shared JSON loader normalizes whole-number numeric literals to integers before sanitization, preserving JSON-authored coordinates, z levels, rotations, and other integer contracts; non-integral values remain floats.

A building may declare staircases with `staircases`. Staircases are authored physical transition semantics for a two-floor building: exactly two slope blocks are needed to ascend from the ground floor to the first floor. The two slopes never stack — the upper slope must be horizontally offset from the lower slope. Both slope tiles must be tiles whose tile-database `shape` is `"slope"` (for example `grass_ramp_00`, `wood_stairs`, or `dirt_light_ramp_00`), placed on `z: 1` (lower) and `z: 2` (upper). Staircases require declared building levels `z: 0` and `z: 2`.

**Straight stairs** use two cardinally adjacent slopes:

```json
{
  "building_levels": [{"z": 0}, {"z": 2}],
  "staircases": [
    {"id": "office_staircase", "lower_at": [9, 9], "upper_at": [10, 9], "rotation": 90}
  ]
}
```

The lower slope at `lower_at` on `z: 1` and the upper slope at `upper_at` on `z: 2` are cardinally adjacent, and both use the same editor-facing `rotation` so the slope continues in the same direction.

**Corner stairs** insert one flat landing block at `z: 1` between the two slopes, so the upper slope is diagonally offset from the lower slope and turns the corner:

```json
{
  "building_levels": [{"z": 0}, {"z": 2}],
  "staircases": [
    {"id": "corner_staircase", "lower_at": [10, 10], "upper_at": [11, 9], "landing_at": [11, 10], "rotation": 90, "upper_rotation": 0}
  ]
}
```

The landing block at `landing_at` on `z: 1` must be a flat (non-slope) existing tile, cardinally adjacent to both `lower_at` and `upper_at`. `upper_rotation` is optional and defaults to `rotation`; it is the editor-facing rotation of the upper slope, which may turn the corner. The maintained `Tools/examples/map_recipe_multi_level_building_foundation.json` demonstrates both formations.

Every staircase record has a unique `id` and required `lower_at`, `upper_at`, and editor-facing `rotation`. All coordinates must be inside the building footprint. `upper_clearance_at` is optional and clears one authored coordinate on z2 for an exceptional stair approach; it does not add a slope or landing. Staircase metadata still does not generate slope tiles; it validates existing slope evidence. When combined with `building_geometry`, floors and supports are generated around those authored slopes, while the existing slope runtime tests remain responsible for mesh, collision, navigation, and traversal behavior.

A building may opt into authored access completeness with `"access_validation": "complete"`:

```json
{"id": "office_building", "rooms": ["office"], "footprint": {"x": 7, "y": 7, "width": 4, "height": 4}, "z": 0, "access_validation": "complete"}
```

For that building, every owned room must have a path to `exterior` through same-z authored `room_connections`. A room-to-exterior connection seeds the path; a room-to-room connection propagates it only when both endpoint rooms belong to the same building. Links to rooms outside the building do not satisfy the rule. This validates semantic authored access, not physical walkability: it does not infer door adjacency, rotation, collision, navigation, or player traversal.

A building may explicitly classify a nonempty subset of its owned rooms as interior with `interior_rooms`:

```json
{"id": "office_building", "rooms": ["office"], "footprint": {"x": 7, "y": 7, "width": 4, "height": 4}, "z": 0, "interior_rooms": ["office"]}
```

Every declared interior room must be a unique, owned, known room whose authored kind is `enclosed` and whose `boundary_validation` is `complete`. The contract never infers interiors from floor material, walls, doors, access links, roof/ceiling records, or geometry. It deliberately excludes `covered_open` and `ruin`; those retain their authored semantic meanings without being classified as interior.

A building may explicitly classify a nonempty subset of its owned rooms as open space with `open_space_rooms`:

```json
{"id": "office_building", "rooms": ["office", "garage_bay"], "footprint": {"x": 7, "y": 7, "width": 5, "height": 4}, "z": 0, "interior_rooms": ["office"], "open_space_rooms": ["garage_bay"]}
```

Every declared open-space room must be unique, owned, known, and authored as `covered_open` or `ruin`. It must not overlap `interior_rooms`. This makes a roofed/open-front garage or damaged annex explicit without treating it as an interior. The contract does not infer open space from missing walls, absent roofs, exterior access, terrain material, or geometry, and it neither generates nor changes physical openings.

A building may opt into a complete authored room partition with `room_partition_validation: "complete"`:

```json
{"id": "office_building", "rooms": ["office", "garage_bay"], "footprint": {"x": 7, "y": 7, "width": 5, "height": 4}, "z": 0, "interior_rooms": ["office"], "open_space_rooms": ["garage_bay"], "room_partition_validation": "complete"}
```

For an opted-in building, every owned room must appear exactly once across `interior_rooms` and `open_space_rooms`. Existing classification rules supply the exact-once guarantees: the lists cannot overlap, interiors must be complete `enclosed` rooms, and open spaces must be `covered_open` or `ruin`. This is optional and validates authored labels only; it does not require every footprint cell to belong to a room and does not infer a classification from geometry or runtime behavior.

A building may opt into complete authored overhead classification with `overhead_validation: "complete"`:

```json
{"id": "office_building", "rooms": ["office", "garage_bay"], "footprint": {"x": 7, "y": 7, "width": 5, "height": 4}, "z": 0, "overhead_validation": "complete"}
```

The building must then have both exactly-valid authored `roof` and `ceiling` `building_surfaces` at logical `z: 1` (`building.z + 1`). Existing surface validation continues to require that those records name the building, have their own unique IDs/kinds, and sit exactly at that overhead level. This opt-in rule validates classifications only: it does not create roof or ceiling geometry, require physical coverage, mark cells occupied or indoors, imply support/collision, or alter lighting/weather/runtime behavior.

A building may author one data-only external footprint context coordinate:

```json
{"id": "office_building", "rooms": ["office", "garage_bay"], "footprint": {"x": 7, "y": 7, "width": 5, "height": 4}, "z": 0, "exterior_context": {"at": [6, 8], "z": 0}}
```

`exterior_context` has exactly `at` and `z`. It must target an existing terrain tile on the building’s own logical z, lie outside the footprint, be cardinally adjacent to one of its footprint cells, and have no room membership. It provides one explicitly authored external reference point without reusing runtime `areas`, inferring streets/yards, or changing terrain. It does not generate a tile, require a particular terrain material, reserve the cell, create an entrance, or alter runtime behavior.

A building may explicitly associate that external context with one existing semantic access connection:

```json
{"id": "office_building", "rooms": ["office", "garage_bay"], "footprint": {"x": 7, "y": 7, "width": 5, "height": 4}, "z": 0, "exterior_context": {"at": [6, 8], "z": 0}, "exterior_access_context": {"connection": "office_front_door"}}
```

`exterior_access_context` has exactly `connection`. It requires `exterior_context` and names an existing same-z `room_connections` record for one of the building’s owned rooms whose other endpoint is `exterior`. The association is explicit—it does not infer a physical route, coordinate adjacency, door rotation, collision, navigation, or player traversal between the context tile and the referenced door.

A building may author one data-only entrance semantic with `entrance`:

```json
{"id": "office_building", "rooms": ["office", "garage_bay"], "footprint": {"x": 7, "y": 7, "width": 5, "height": 4}, "z": 0, "exterior_context": {"at": [6, 8], "z": 0}, "exterior_access_context": {"connection": "office_front_door"}, "entrance": {"connection": "office_front_door", "facing": "east"}}
```

`entrance` has exactly `connection` and `facing`. It requires `exterior_context` and names an existing same-z `room_connections` record for one of the building’s owned rooms whose other endpoint is `exterior`, following the same contract as `exterior_access_context.connection`. When `exterior_access_context` is also present, `entrance.connection` must match it. `facing` is one of `north`, `east`, `south`, or `west` and must point from `exterior_context.at` toward the building footprint: stepping one cell in the facing direction from the context coordinate must land inside the footprint. This validates authored entrance orientation only—it does not generate a door, infer a physical route, require coordinate adjacency between the context tile and the referenced door, or alter collision, navigation, lighting, weather, or runtime behavior.

A building may author multiple data-only entrance semantics with `entrances`:

```json
{"id": "office_building", "rooms": ["office", "garage_bay"], "footprint": {"x": 7, "y": 7, "width": 5, "height": 4}, "z": 0, "exterior_context": {"at": [6, 8], "z": 0}, "exterior_access_context": {"connection": "office_front_door"}, "entrances": [{"id": "front_entrance", "connection": "office_front_door", "facing": "east"}, {"id": "garage_entrance", "connection": "garage_opening", "facing": "west"}], "entrance_validation": "complete"}
```

`entrances` is a non-empty array of entrance records. `entrance` and `entrances` are mutually exclusive. Each entry has exactly `id`, `connection`, and `facing`. `id` is unique within the building and follows the same naming pattern as other authored IDs. `connection` names an existing same-z `room_connections` record for one of the building's owned rooms whose other endpoint is `exterior`, following the same contract as the singular `entrance.connection`. Each connection may be referenced by at most one entrance. `facing` is one of `north`, `east`, `south`, or `west`. `entrances` requires `exterior_context`. When `exterior_access_context` is also present, its `connection` must match one of the entrance connections.

The primary entrance is the one whose `connection` matches `exterior_access_context.connection`, or the first entry when `exterior_access_context` is absent. Only the primary entrance is checked against `exterior_context.at`: stepping one cell in its `facing` direction from the context coordinate must land inside the footprint. Non-primary entrances are not checked against `exterior_context` because a single context tile cannot serve multiple approach directions.

A building may opt into complete entrance orientation and approach validation with `entrance_validation: "complete"`:

```json
{"id": "office_building", "rooms": ["office", "garage_bay"], "footprint": {"x": 7, "y": 7, "width": 5, "height": 4}, "z": 0, "exterior_context": {"at": [6, 8], "z": 0}, "exterior_access_context": {"connection": "office_front_door"}, "entrance": {"connection": "office_front_door", "facing": "east"}, "entrance_validation": "complete"}
```

For an opted-in building, `entrance_validation` requires `entrance` or `entrances` and then checks two authored constraints per entrance:

1. **Door orientation**: the `room_boundaries` record with `element: "door_furniture"` at the entrance connection's `at` and `z`, naming a building-owned room, must have a `side` equal to `OPPOSITE_SIDES[facing]`—the door opens toward the approaching direction. A missing door boundary, missing `side`, or wrong-facing door is rejected.
2. **Approach alignment** (primary entrance only): `exterior_context.at` and the primary entrance connection's `at` must both fall within the footprint's perpendicular range. For `east`/`west` facing, both Y values must be within the footprint height; for `north`/`south` facing, both X values must be within the footprint width. This ensures the approach path from the context tile to the door runs along the correct building side.

This validates authored orientation and alignment only: it does not generate or modify geometry, infer a walkable path, check collision or navigation, require the context tile and door to be cardinally adjacent, or alter runtime behavior.

`DMap` preserves building records through editor save/load and removes records whose room list, declared interior rooms, declared open-space rooms, malformed exterior context, stale exterior-access connection, stale entrance connection, malformed entrances array, stale entrance connection in the entrances array, malformed entrance validation, malformed furniture anchors, or malformed `reachability_validation` requirements becomes stale. The standalone validator performs strict shape, containment, same-level overlap, complete-enclosed-room, opted-in access, and authored interior/open-space/partition/overhead/exterior-context/exterior-access-context/entrance/entrances/entrance-validation/furniture-anchors checks.

A building may author named furniture anchor metadata with `furniture_anchors`:

```json
{"id": "office_building", "rooms": ["office", "garage_bay"], "footprint": {"x": 7, "y": 7, "width": 5, "height": 4}, "z": 0, "furniture_anchors": [{"id": "office_door_anchor", "at": [8, 9], "z": 0, "kind": "door"}, {"id": "garage_door_anchor", "at": [11, 8], "z": 0, "kind": "door"}]}
```

`furniture_anchors` is a non-empty array of anchor records. Each entry has exactly `id`, `at`, `z`, and `kind`. `id` is unique within the building and follows the same naming pattern as other authored IDs. `at` is a two-integer `[x, y]` coordinate within map bounds. `z` is a logical level from `-10` through `10` and must match the building's own `z` or one of its declared `building_levels`. `kind` is a non-empty semantic label (e.g. `"door"`, `"storage"`, `"workstation"`) — it is free-form text, not an enumerated set, and carries no runtime behavior.

Each anchor must reference a tile inside the building footprint that has an existing furniture feature at the authored `[x, y, z]`. The anchor does not generate furniture, modify terrain, infer walkability, check furniture category or function, or alter collision, navigation, lighting, weather, or runtime behavior. It is a data-only authored reference point — a named semantic label for existing furniture that future template composition and gameplay validation can use as an anchor.

`Tools/examples/map_recipe_furniture_anchors.json` demonstrates the maintained office building with two furniture anchors: `office_door_anchor` and `garage_door_anchor`, each pointing to an existing `door_wood` feature inside the footprint.

### `reachability_validation`

A building may opt in to static semantic reachability requirements with `reachability_validation`:

```json
{
  "reachability_validation": {
    "required_entrances": ["front_entrance", "garage_entrance"],
    "required_furniture_anchors": ["office_door_anchor", "garage_door_anchor", "upper_bench_anchor"],
    "required_building_levels": [0, 2]
  }
}
```

The record is optional, must be an object, and must define at least one of exactly three keys:

- `required_entrances` names entries of the building's `entrances` array by their `id`. A singular `entrance` has no ID and cannot be referenced.
- `required_furniture_anchors` names entries of the building's `furniture_anchors` by `id`.
- `required_building_levels` names declared `building_levels` z values (or the building's own `z` when no `building_levels` are declared).

Every requirement is a non-empty array without duplicate entries; entrance and anchor names are non-empty strings, and levels are integers. The record must not store coordinates, tile IDs, or precomputed paths — it names only existing entrances, anchors, and declared levels.

Validation is a static breadth-first search over authored semantic facts, never a collision or navigation simulation. Graph nodes are `(room, level)` pairs; a room's level comes from its `building_levels` assignment, or the building `z` when levels are undeclared. Seed nodes are the rooms behind room-to-exterior connections whose connection `z` equals the room's level — restricted to the named entrances when `required_entrances` is declared, or all owned exterior connections otherwise. Same-level edges come from room-to-room `room_connections` where both rooms share the room's level and the connection `z` matches. Vertical edges are derived only from already-valid authored `staircases`: a validated staircase connects the declared `z: 0` and `z: 2` floor levels bidirectionally, and the connection is floor-granular because staircase slopes occupy the intentional open gap where no room membership exists. The search must reach the room behind every required entrance, the level of every required furniture anchor, and at least one room node on every required building level. Unknown targets, undeclared levels, and unreachable requirements are rejected; Python never simulates runtime collision or navigation — the Godot runtime navigation tests own that proof.

The generator validates the record shape, echoes it into the building record, and rejects unreachable requirements while authoring. `Tools/map_validator.py` performs the same checks independently on generated maps. `DMap` preserves valid records through editor save/load and removes buildings whose record references stale entrances, anchors, or undeclared levels, or whose requirements are malformed. The maintained `map_recipe_multi_level_building_foundation.json` demonstrates the full record across both storeys through its authored staircase, and the canonical two-storey semantic fixture now does the same through `workroom_staircase`.

### Canonical semantic-building fixtures

`Tools/examples/map_recipe_semantic_single_storey_building.json` is the canonical complete one-storey profile. It combines physical `building_geometry`, one complete enclosed room, required z1 perimeter walls including every corner, a clear z1 headroom cell above its room-to-exterior door, dirt support beneath every remaining lower wall, per-floor room/anchor ownership, `access_validation`, interior/partition classification, exterior and entrance semantics, entrance validation, and a door furniture anchor. Its generated artifact is `Mods/Dimensionfall/Maps/generated_semantic_single_storey_building.json`.

`Tools/examples/map_recipe_semantic_two_storey_building.json` is the canonical ordinary two-storey profile. It assigns a complete `workroom` at z0 and a complete `loft` at z2, gives each one furniture-anchor ownership, explicitly paints the required z1/z3 perimeter walls of its 6×6 footprint, and authors a concrete roof at z4. The z1 cell above its lower door is deliberately empty; all other z1 walls, including the corners, are supported by `dirt_light_00` at z0. Its generated artifact is `Mods/Dimensionfall/Maps/generated_semantic_two_storey_building.json`. The fixture also authors `workroom_staircase` — a straight staircase with the lower slope at [10, 10] on z1 and the upper slope at [10, 9] on z2 — so its `reachability_validation` can require `loft_bench` and level z2. The loft is `enclosed` but intentionally not `boundary_validation: complete`: the stairwell opening breaks its perimeter, so the fixture mirrors the maintained multi-level foundation rather than forcing invalid complete-boundary records. The explicit z4 roof remains recipe geometry until a future generalized `wall_height` contract can derive a roof surface from the upper wall span.

The `access_validation` contract follows only same-z `room_connections`. The two-storey fixture therefore does not opt into it: generic cross-floor semantic routes are expressed by `reachability_validation`, which adds graph edges only through already-valid `staircases`. Neither contract replaces Godot navigation checks; collision and real traversal are proven at runtime by `Tests/Unit/test_semantic_single_storey_navigation.gd`, `Tests/Unit/test_semantic_two_storey_navigation.gd`, and `Tests/Unit/test_field_farmland_navigation.gd` through the reusable `Tests/Unit/helpers/map_navigation_fixture.gd` helper, which provides generic chunk navigation setup, baking, grid-to-world conversion, and path assertions for any map geometry without knowing room semantics.

`Tools/examples/map_recipe_field_farmland.json` applies this generic profile to the legacy `field_farmland` acceptance footprint x3…18/y19…29. It deliberately keeps only a representative complete kitchen, connected ground room, upper room, doors, anchors, reachability requirements, and a z1→z2 staircase; it is not a farmland-specific generator path and does not attempt to reproduce every legacy room.

### `building_surfaces`

`building_surfaces` declares authored overhead semantics for an existing validated building footprint without creating roof or ceiling geometry:

```json
{
  "building_surfaces": [
    {"id": "office_roof", "building": "office_building", "kind": "roof", "z": 1},
    {"id": "office_ceiling", "building": "office_building", "kind": "ceiling", "z": 1}
  ]
}
```

Each record has exactly `id`, `building`, `kind`, and `z`. `id` is unique; `building` must name a root `buildings` record; and `kind` is exactly `roof`, `ceiling`, or `floor`. A building may have at most one record of each kind at each `z`.

For a single-level building (no `building_levels`), `z` is the logical level immediately above the building footprint (`building.z + 1`), and only `roof` and `ceiling` kinds are allowed. `roof` and `ceiling` are separate authored classifications and may both be present for one building.

For a multi-level building (with `building_levels`), `z` must name a declared occupied building level. `floor` and `ceiling` may target declared occupied levels, while `roof` is allowed only at the highest declared occupied level. This models the top-down vertical story directly:

```text
z: 0  ground-floor surface      -> kind "floor"
z: 1  air gap (never a surface)
z: 2  first-floor surface       -> kind "floor"
z: 2  ground-floor ceiling      -> kind "ceiling"
```

In the top-down game the player never sees the ceiling: a `ceiling` at `z: 2` is the underside of the first-floor slab that closes the air gap above the ground floor, and it is authored metadata only — it is never rendered. `ceiling` cannot be declared at the ground level itself.

Surfaces do not place tiles on their `z`, create a roof/ceiling/floor mesh, imply collision/support, change lighting/weather, mark rooms indoors, or make overhead cells occupied. `DMap` preserves valid records and removes surfaces whose referenced building is deleted, whose kind is unsupported, or whose `z` no longer matches the building's declared levels; generator and standalone validation enforce the strict reference, uniqueness, and z relationship.

### `building_supports`

`building_supports` authors structural support semantics for a multi-level building without generating columns, walls, beams, collision, or support geometry:

```json
{
  "building_supports": [
    {
      "id": "northwest_column",
      "building": "office_building",
      "at": [7, 7],
      "from_z": 0,
      "to_z": 2,
      "kind": "column"
    }
  ]
}
```

Each record has exactly `id`, `building`, `at`, `from_z`, `to_z`, and `kind`. `kind` is currently `column` or `wall`. The support coordinate must lie inside the building footprint; `from_z` and `to_z` must be ascending declared occupied building levels. This is an authored assertion that the upper-floor/roof semantics have a structural support path back to a lower occupied level. It does not infer support from tile presence or furniture and does not generate or alter runtime geometry.

`DMap` preserves valid support records and removes records with stale buildings, invalid coordinates, unsupported kinds, or undeclared/non-ascending levels.

### `building_compositions`

`building_compositions` is an opt-in, data-only assertion that an existing building contains the named authored overhead classifications:

```json
{
  "building_compositions": [
    {
      "id": "office_complete_overhead",
      "building": "office_building",
      "required_surfaces": ["roof", "ceiling"]
    }
  ]
}
```

Each record has exactly `id`, `building`, and nonempty `required_surfaces`. `id` is unique; one composition may target each building; `building` must name an existing root `buildings` record; and every required surface kind must be unique and exactly `roof` or `ceiling`. Each named kind must have a matching valid `building_surfaces` record for the same building. This is opt-in: a building without a composition remains valid, and composition does not require all supported kinds unless its author lists them.

Compositions add no geometry or runtime behavior. They only validate authored cross-record consistency; they do not infer indoor status, surface coverage, support, or the presence of any roof/ceiling tiles or meshes. `DMap` preserves valid records and removes ones that reference deleted buildings.

No generalized templates, polygons, multi-level building records, furniture anchors, or generation operations are introduced.

### `set`

Places one tile. Fields: `type`, `x`, `y`, `tile`, and optional root-level `z`.

```json
{"type": "set", "x": 16, "y": 15, "tile": {"id": "grass_flowers_01"}}
```

### `rectangle`

Fills a rectangle. Fields: `type`, `x`, `y`, positive `width`, positive `height`, `tile`, and optional root-level `z`.

```json
{"type": "rectangle", "x": 10, "y": 9, "width": 12, "height": 14, "tile": {"id": "grass_plain_01"}}
```

### `rectangle_outline`

Places only the rectangle border and uses the same fields as `rectangle`. If width or height is `1`, every cell in the resulting one-cell-wide shape is border.

```json
{"type": "rectangle_outline", "x": 10, "y": 9, "width": 12, "height": 14, "tile": {"id": "grass_dirt_00"}}
```

### `line`

Places an inclusive, one-tile-wide line between integer `[x, y]` endpoints. Fields: `type`, `from`, `to`, `tile`, and optional root-level `z`. Lines use the integer Bresenham algorithm, so horizontal, vertical, diagonal, steep, and reversed lines are deterministic.

```json
{"type": "line", "from": [0, 16], "to": [31, 16], "tile": {"id": "dirt_light_00"}}
```

### `scatter`

Selects unique cells in a rectangular `region` using the recipe's seeded random-number generator. Fields: `type`, `region`, exactly one of `count` or `density`, `tile`, and optional root-level `z`.

- `count` is an integer from zero through the number of cells in the region.
- `density` is a number from `0` through `1`; the placement count is `floor(region area × density)`.
- Selected cells replace their existing tiles.
- The same complete recipe and seed produce the same selection and output.

```json
{
  "type": "scatter",
  "region": {"x": 0, "y": 0, "width": 32, "height": 32},
  "density": 0.1,
  "tile": {"id": "grass_flowers_00", "rotation": "random"}
}
```

### `pattern`

Places every cell from a named pattern relative to an anchor. Fields: `type`, `pattern`, `at`, optional root-level `z`, and optional `rotation`. Rotation defaults to `0` and accepts fixed clockwise quarter turns: `0`, `90`, `180`, or `270`.

Offsets rotate around the anchor: `90` maps `[x, y]` to `[-y, x]`. The generator preflights the complete expansion and rejects the operation if any resulting cell is outside the map; patterns are never clipped or partially applied.

```json
{
  "type": "pattern",
  "pattern": "wildflower_cluster",
  "at": [16, 12],
  "rotation": 90
}
```

### `furniture`

Embeds one known single-cell furniture feature in an existing terrain tile. Fields: `type`, `x`, `y`, `id`, optional root-level `z`, optional `rotation`, and optional `itemgroups`. Rotation defaults to `0` and accepts fixed editor-facing quarter turns: `0`, `90`, `180`, or `270`. When present, `itemgroups` must be a non-empty array of known IDs from the selected `Itemgroups/Itemgroups.json` catalog.

```json
{
  "type": "furniture",
  "x": 16,
  "y": 16,
  "z": 0,
  "id": "cabinet_wood_00",
  "rotation": 270,
  "itemgroups": ["cabinet_general"]
}
```

The target cell must already contain a terrain tile on the selected logical level and must not already contain a feature. The generator validates `id` against the selected furniture database and writes the existing map/editor representation:

```json
{
  "id": "grass_dirt_00",
  "feature": {
    "type": "furniture",
    "id": "bench_garden",
    "rotation": 90,
    "itemgroups": []
  }
}
```

The operation consumes no randomness. Repeating a furniture operation on the same cell is a conflict error. A later tile operation deliberately replaces the complete tile dictionary and therefore removes an earlier feature, following the established ordered tile-overwrite behavior. For container furniture, a non-empty recipe `itemgroups` list overrides the furniture definition's default container group; runtime chooses one listed group at random when the map instance first creates loot. Omit the field to retain the furniture definition's default group.

The serialized feature has no logical-level, static/movable, state, or mode field. `Chunk.process_level_data()` derives world height from the containing level-array index, and runtime furniture data selects the static or physics spawner from the referenced furniture definition's `moveable` property. Blueprint `mode` belongs to saved runtime furniture state and is not part of a newly generated map feature.

### `furniture_scatter`

Places a bounded number of single-cell furniture features selected from a named `furniture_palette`. Fields: `type`, `region`, `palette`, exactly one of `count` or `density`, and optional root-level `z`.

- `count` is an integer from zero through the geometric region area.
- `density` is a number from `0` through `1`; the requested placement count is `floor(region area × density)`.
- Eligible cells must already contain terrain on the target logical level and must not already have a feature.
- If the requested count exceeds the remaining eligible cells, generation fails before mutating the scatter operation's target cells.
- Candidate coordinates are enumerated in row-major order, then sampled without replacement with the recipe RNG. Each sampled cell selects one weighted furniture entry and resolves its rotation in sample order.
- Scatter embeds the same `feature` object as explicit `furniture`; it does not infer footprints, itemgroups, or adjacent-level occupancy.

```json
{
  "type": "furniture_scatter",
  "region": {"x": 8, "y": 8, "width": 16, "height": 16},
  "z": 0,
  "count": 24,
  "palette": "clearing_trees"
}
```

## Validation and limitations

The generator rejects unknown fields at every recipe level, root-level dimension fields, malformed or out-of-bounds placements, logical levels outside `-10` through `10`, duplicate grouped levels, ambiguous root/grouped layouts, malformed tile or furniture databases, unknown tile and furniture IDs, malformed area definitions or memberships, duplicate area IDs or same-ID tile memberships, unsupported area cells, feature conflicts, scatter requests that exceed eligible cells, invalid rotations, invalid Unicode, and non-object recipes. It validates generated data with `Tools/map_validator.py` before publishing the output. The validator independently requires exactly 21 level arrays and exactly 1024 entries in every populated level, and structurally validates embedded furniture fields, IDs, rotations, itemgroup arrays, and area-reference arrays.

The output uses 21 levels; logical `z: 0` is row-major grid index `10`. It sets `categories` to `[]`, `weight` to `1000`, and all four connections to `"ground"`. It omits `areas`, matching `DMap.get_data()` when the area list is empty.

The generator currently creates explicit, known, single-cell furniture features, deterministic weighted furniture scatter over eligible terrain, strict runtime-compatible rectangular area memberships at explicit logical levels, and authored room labels through terrain-backed `room_rectangle` operations. Areas can additionally declare catalog-validated weighted runtime `furniture`, `mob`, `mobgroup`, and `itemgroup` entities; selection occurs when the map is instanced rather than during Python generation. Room labels are semantic only and do not yet create or infer geometry. The core mod defines `rock_field_00` and `wild_vegetation_00` for outdoor composition, using the dedicated AI-generated sprites `ai_rock_32_32.png` and `ai_vegetation_32_32.png`. It does not yet support furniture itemgroup contents, multiple features per cell, multi-tile or tall-object occupancy, automatic support inference, polygonal areas, walls, doors, buildings, roads as semantic objects, towns, nested or multi-level patterns, or shape-based templates.

The maintained area examples are `Tools/examples/map_recipe_area_meadow.json` and `Tools/examples/map_recipe_area_entity_clearing.json`; the maintained room example is `Tools/examples/map_recipe_room_semantics.json`. The maintained furniture example is `Tools/examples/map_recipe_furniture_outdoor.json`. Maintained structural examples are available at `Tools/examples/map_recipe_two_level_hill.json` and `Tools/examples/map_recipe_two_level_depression.json`. They use `grass_ramp_00`, whose tile definition has `shape: "slope"`.

Slope rotations in recipes use the same values shown by the map editor:

| Rotation | High edge |
|---:|---|
| `0` | north |
| `90` | east |
| `180` | south |
| `270` | west |

The generator preserves these editor-facing values in map JSON. When a newly generated map is loaded, `Chunk.get_block_rotation()` applies the slope's shape-specific conversion before rendered mesh, collision, and navigation geometry use the internal orientation. Do not pre-convert recipe rotations to the internal `calculate_slope_vertices()` mapping.

`Tests/Unit/test_chunk_slope_rotation.gd` verifies all four editor rotations against the converted runtime rotation and confirms matching high edges in rendered mesh vertices, convex collision geometry, and navigation-source faces. `Tests/Unit/test_chunk_slope_navigation.gd` performs the real asynchronous bake and confirms that every orientation has a queryable path from low to high and from high to low. The Python example test separately confirms that the authored high-side tile and lower-level low-side tile are occupied. Manual playtesting of both maintained maps has also confirmed that the real player controller walks up and down all four slope orientations without traversal or invisible-collision problems.
