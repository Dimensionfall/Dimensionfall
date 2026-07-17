# Recipe-driven map generator

`Tools/map_generator.py` converts a compact JSON recipe into a complete Dimensionfall map JSON file. Dimensionfall maps have fixed dimensions of 32 x 32 tiles. The generator creates one populated ground level (level array index `10`) with exactly 1024 entries and leaves the other 20 levels empty.

## Usage

Run from the repository root:

```sh
python3 Tools/map_generator.py \
  Tools/examples/map_recipe.json \
  /tmp/generated_meadow_prototype.json
python3 Tools/map_validator.py /tmp/generated_meadow_prototype.json
```

The output filename must be `<id>.json`, matching the map loader's filename-derived ID. Existing output is protected. Pass `--overwrite` only when replacement is intended. Use `--tiles PATH` to validate tile IDs against a tile database other than `Mods/Dimensionfall/Tiles/Tiles.json`.

## Recipe format

The root must be a JSON object with these fields:

| Field | Type | Meaning |
| --- | --- | --- |
| `id` | string | Map ID using only letters, numbers, `_`, and `-`. |
| `name` | non-empty string | Display name. |
| `description` | non-empty string | Map description. |
| `seed` | integer | Fixed seed used by random rotations and scatter. Recipe input only; the map format does not store it. |
| `base_tile` | tile object | Tile initially placed in every cell. |
| `regions` | array | Legacy filled rectangles. Optional; defaults to `[]`. |
| `operations` | array | Ordered placement operations. Optional; defaults to `[]`. |

A recipe does not define map dimensions: all generated maps are 32 x 32. Coordinates start at the top-left. Every shape must fit entirely within the map; operations are never silently clipped.

A tile object has a required `id` from the selected `Tiles.json` and an optional `rotation`. Rotation is `0`, `90`, `180`, `270`, or `"random"`. Operation tiles may be `null`, which writes the project's empty-tile representation, `{}`.

Legacy `regions` are applied first in array order, followed by `operations` in array order. Later placements overwrite earlier cells. `regions` remain supported for version-one recipes and use the same filled-rectangle placement implementation as `rectangle` operations.

## Placement operations

Every operation requires a `type`. Unknown operation types and fields are errors.

### `set`

Places one tile. Fields: `type`, `x`, `y`, and `tile`.

```json
{"type": "set", "x": 16, "y": 15, "tile": {"id": "grass_flowers_01"}}
```

### `rectangle`

Fills a rectangle. Fields: `type`, `x`, `y`, positive `width`, positive `height`, and `tile`.

```json
{"type": "rectangle", "x": 10, "y": 9, "width": 12, "height": 14, "tile": {"id": "grass_plain_01"}}
```

### `rectangle_outline`

Places only the rectangle border and uses the same fields as `rectangle`. If width or height is `1`, every cell in the resulting one-cell-wide shape is border.

```json
{"type": "rectangle_outline", "x": 10, "y": 9, "width": 12, "height": 14, "tile": {"id": "grass_dirt_00"}}
```

### `line`

Places an inclusive, one-tile-wide line between integer `[x, y]` endpoints. Fields: `type`, `from`, `to`, and `tile`. Lines use the integer Bresenham algorithm, so horizontal, vertical, diagonal, steep, and reversed lines are deterministic.

```json
{"type": "line", "from": [0, 16], "to": [31, 16], "tile": {"id": "dirt_light_00"}}
```

### `scatter`

Selects unique cells in a rectangular `region` using the recipe's seeded random-number generator. Fields: `type`, `region`, exactly one of `count` or `density`, and `tile`.

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

## Validation and limitations

The generator rejects unknown fields at every recipe level, root-level dimension fields, malformed or out-of-bounds placements, malformed tile databases, unknown tile IDs, invalid rotations, invalid Unicode, and non-object recipes. It validates generated data with `Tools/map_validator.py` before publishing the output.

The output uses 21 levels, with the generated row-major grid at index 10. It sets `categories` to `[]`, `weight` to `1000`, and all four connections to `"ground"`. It omits `areas`, matching `DMap.get_data()` when the area list is empty.

The generator does not yet create palettes, features, furniture, areas, roads as semantic objects, buildings, towns, additional levels, or complex templates. Structural validity also does not yet guarantee walkability or gameplay quality.
