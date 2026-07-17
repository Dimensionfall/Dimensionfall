# Recipe-driven map generator

`Tools/map_generator.py` converts a compact JSON recipe into a complete Dimensionfall map JSON file. Dimensionfall maps have fixed dimensions of 32 x 32 tiles. The prototype creates one populated ground level (level array index `10`) with exactly 1024 entries and leaves the other 20 levels empty.

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
| `seed` | integer | Fixed seed used by random rotations. Recipe input only; the map format does not store it. |
| `base_tile` | tile object | Tile initially placed in every cell. |
| `regions` | array | Rectangles applied in array order; later rectangles replace earlier cells. Optional; defaults to `[]`. |

A recipe does not define map dimensions: all generated maps are 32 x 32. The names `width` and `height` remain part of each rectangular region because they describe the rectangle, not the map. Supplying either field at the recipe root is an error.

A tile object has a required `id` from the selected `Tiles.json` and an optional `rotation`. Rotation is `0`, `90`, `180`, `270`, or `"random"`. A region has non-negative integer `x` and `y`, positive integer `width` and `height`, and a `tile`. Region coordinates start at the top-left, and the rectangle must fit within the fixed 32 x 32 map. A region's `tile` may be `null`; this writes the project's empty-tile representation, `{}`.

The generator rejects unknown fields at every recipe level, root-level dimension fields, malformed or out-of-bounds regions, malformed tile databases, unknown tile IDs, invalid rotations, invalid Unicode, and non-object recipes. It validates generated data with `Tools/map_validator.py` before publishing the output.

## Generated map defaults and limitations

The output uses 21 levels, with the generated row-major grid at index 10. It sets `categories` to `[]`, `weight` to `1000`, and all four connections to `"ground"`. It omits `areas`, matching `DMap.get_data()` when the area list is empty. Version 1 does not generate areas, features, roads, buildings, towns, additional levels, or complex templates. The same recipe and seed produce the same map data.
