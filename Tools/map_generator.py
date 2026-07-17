#!/usr/bin/env python3
"""Generate a Dimensionfall map JSON file from a compact recipe."""

from __future__ import annotations

import argparse
import json
import os
import random
import re
import sys
import tempfile
from pathlib import Path
from typing import Any

try:
    from .map_validator import MapValidator
except ImportError:  # Direct execution from Tools/.
    from map_validator import MapValidator


LEVEL_COUNT = 21
POPULATED_LEVEL_INDEX = 10
MAP_WIDTH = 32
MAP_HEIGHT = 32
DEFAULT_CONNECTIONS = {
    "north": "ground",
    "east": "ground",
    "south": "ground",
    "west": "ground",
}
VALID_ROTATIONS = (0, 90, 180, 270)
TILE_FIELDS = {"id", "rotation"}
REGION_FIELDS = {"x", "y", "width", "height", "tile"}
SET_FIELDS = {"type", "x", "y", "tile"}
RECTANGLE_FIELDS = {"type", "x", "y", "width", "height", "tile"}
LINE_FIELDS = {"type", "from", "to", "tile"}
SCATTER_FIELDS = {"type", "region", "tile", "count", "density"}
SCATTER_REGION_FIELDS = {"x", "y", "width", "height"}
OPERATION_TYPES = {"set", "rectangle", "rectangle_outline", "line", "scatter"}
RECIPE_FIELDS = {
    "id",
    "name",
    "description",
    "seed",
    "base_tile",
    "regions",
    "operations",
}


class RecipeError(ValueError):
    """Raised when a map recipe is invalid."""


def _validate_unicode(value: str, context: str) -> None:
    try:
        value.encode("utf-8")
    except UnicodeEncodeError as error:
        raise RecipeError(f"{context} must contain valid Unicode") from error


def load_recipe(path: Path) -> dict[str, Any]:
    with Path(path).open(encoding="utf-8") as handle:
        recipe = json.load(handle)
    if not isinstance(recipe, dict):
        raise RecipeError("recipe must be a JSON object")
    return recipe


def write_map(
    recipe_path: Path,
    output_path: Path,
    tiles_path: Path,
    overwrite: bool = False,
) -> None:
    output_path = Path(output_path)
    if output_path.exists() and not overwrite:
        raise FileExistsError(
            f"output already exists: {output_path}; use --overwrite to replace it"
        )

    generated = generate_map(load_recipe(Path(recipe_path)), Path(tiles_path))
    expected_name = f"{generated['id']}.json"
    if output_path.name != expected_name:
        raise RecipeError(
            f"output must be named {expected_name} so the filename matches the map ID"
        )
    output_path.parent.mkdir(parents=True, exist_ok=True)
    serialized = json.dumps(generated, indent="\t", ensure_ascii=False) + "\n"

    temporary_path: Path | None = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w",
            encoding="utf-8",
            dir=output_path.parent,
            prefix=f".{output_path.name}.",
            delete=False,
        ) as temporary:
            temporary.write(serialized)
            temporary_path = Path(temporary.name)

        validator = MapValidator()
        validator.validate_map(str(temporary_path))
        if validator.errors:
            raise RecipeError(
                "generated map failed validation: " + "; ".join(validator.errors)
            )

        if overwrite:
            os.replace(temporary_path, output_path)
            temporary_path = None
        else:
            try:
                os.link(temporary_path, output_path)
            except FileExistsError as error:
                raise FileExistsError(
                    f"output already exists: {output_path}; use --overwrite to replace it"
                ) from error
    finally:
        if temporary_path is not None:
            temporary_path.unlink(missing_ok=True)


def _tile_ids(tiles_path: Path) -> set[str]:
    with tiles_path.open(encoding="utf-8") as handle:
        tile_data = json.load(handle)
    if not isinstance(tile_data, list):
        raise RecipeError("tile database must be a JSON array")
    return {
        tile["id"]
        for tile in tile_data
        if isinstance(tile, dict) and isinstance(tile.get("id"), str)
    }


def _validate_tile_spec(
    spec: Any,
    known_tiles: set[str],
    context: str,
    *,
    allow_empty: bool = False,
) -> tuple[str | None, int | str]:
    if spec is None and allow_empty:
        return None, 0
    if not isinstance(spec, dict):
        empty_hint = " or null" if allow_empty else ""
        raise RecipeError(f"{context} must be an object{empty_hint}")
    unknown_fields = sorted(set(spec) - TILE_FIELDS)
    if unknown_fields:
        raise RecipeError(f"unknown {context} field '{unknown_fields[0]}'")
    tile_id = spec.get("id")
    if not isinstance(tile_id, str) or not tile_id.strip():
        raise RecipeError(f"{context}.id must be a non-empty string")
    _validate_unicode(tile_id, f"{context}.id")
    if tile_id not in known_tiles:
        raise RecipeError(f"{context}.id references unknown tile '{tile_id}'")
    rotation = spec.get("rotation", 0)
    if rotation != "random" and (
        type(rotation) is not int or rotation not in VALID_ROTATIONS
    ):
        raise RecipeError(f"{context}.rotation must be 0, 90, 180, 270, or 'random'")
    return tile_id, rotation


def _make_tile(
    spec: Any,
    rng: random.Random,
    known_tiles: set[str],
    context: str,
    *,
    allow_empty: bool = False,
) -> dict[str, Any]:
    tile_id, rotation = _validate_tile_spec(
        spec, known_tiles, context, allow_empty=allow_empty
    )
    if tile_id is None:
        return {}
    if rotation == "random":
        rotation = rng.choice(VALID_ROTATIONS)
    tile: dict[str, Any] = {"id": tile_id}
    if rotation:
        tile["rotation"] = rotation
    return tile


def _coordinate(value: Any, context: str, maximum: int) -> int:
    if type(value) is not int or not 0 <= value < maximum:
        raise RecipeError(
            f"{context} must be an integer between 0 and {maximum - 1}"
        )
    return value


def _apply_set(
    level: list[dict[str, Any]],
    operation: dict[str, Any],
    rng: random.Random,
    known_tiles: set[str],
    context: str,
) -> None:
    unknown_fields = sorted(set(operation) - SET_FIELDS)
    if unknown_fields:
        raise RecipeError(f"unknown {context} field '{unknown_fields[0]}'")
    x = _coordinate(operation.get("x"), f"{context}.x", MAP_WIDTH)
    y = _coordinate(operation.get("y"), f"{context}.y", MAP_HEIGHT)
    level[y * MAP_WIDTH + x] = _make_tile(
        operation.get("tile"), rng, known_tiles, f"{context}.tile", allow_empty=True
    )


def _rectangle_dimensions(spec: dict[str, Any], context: str) -> dict[str, int]:
    dimensions: dict[str, int] = {}
    for field in ("x", "y", "width", "height"):
        value = spec.get(field)
        minimum = 0 if field in ("x", "y") else 1
        if type(value) is not int or value < minimum:
            qualifier = "non-negative" if minimum == 0 else "positive"
            raise RecipeError(f"{context}.{field} must be a {qualifier} integer")
        dimensions[field] = value
    if (
        dimensions["x"] + dimensions["width"] > MAP_WIDTH
        or dimensions["y"] + dimensions["height"] > MAP_HEIGHT
    ):
        raise RecipeError(f"{context} extends outside the {MAP_WIDTH}x{MAP_HEIGHT} map")
    return dimensions


def _apply_rectangle(
    level: list[dict[str, Any]],
    spec: dict[str, Any],
    rng: random.Random,
    known_tiles: set[str],
    context: str,
    fields: set[str],
) -> None:
    unknown_fields = sorted(set(spec) - fields)
    if unknown_fields:
        raise RecipeError(f"unknown {context} field '{unknown_fields[0]}'")
    dimensions = _rectangle_dimensions(spec, context)
    for y in range(dimensions["y"], dimensions["y"] + dimensions["height"]):
        for x in range(dimensions["x"], dimensions["x"] + dimensions["width"]):
            level[y * MAP_WIDTH + x] = _make_tile(
                spec.get("tile"),
                rng,
                known_tiles,
                f"{context}.tile",
                allow_empty=True,
            )


def _apply_rectangle_outline(
    level: list[dict[str, Any]],
    operation: dict[str, Any],
    rng: random.Random,
    known_tiles: set[str],
    context: str,
) -> None:
    unknown_fields = sorted(set(operation) - RECTANGLE_FIELDS)
    if unknown_fields:
        raise RecipeError(f"unknown {context} field '{unknown_fields[0]}'")
    dimensions = _rectangle_dimensions(operation, context)
    left = dimensions["x"]
    right = left + dimensions["width"] - 1
    top = dimensions["y"]
    bottom = top + dimensions["height"] - 1
    for y in range(top, bottom + 1):
        for x in range(left, right + 1):
            if x in (left, right) or y in (top, bottom):
                level[y * MAP_WIDTH + x] = _make_tile(
                    operation.get("tile"),
                    rng,
                    known_tiles,
                    f"{context}.tile",
                    allow_empty=True,
                )


def _point(value: Any, context: str) -> tuple[int, int]:
    if not isinstance(value, list) or len(value) != 2:
        raise RecipeError(f"{context} must be a two-integer array")
    return (
        _coordinate(value[0], f"{context}[0]", MAP_WIDTH),
        _coordinate(value[1], f"{context}[1]", MAP_HEIGHT),
    )


def _apply_line(
    level: list[dict[str, Any]],
    operation: dict[str, Any],
    rng: random.Random,
    known_tiles: set[str],
    context: str,
) -> None:
    unknown_fields = sorted(set(operation) - LINE_FIELDS)
    if unknown_fields:
        raise RecipeError(f"unknown {context} field '{unknown_fields[0]}'")
    x, y = _point(operation.get("from"), f"{context}.from")
    target_x, target_y = _point(operation.get("to"), f"{context}.to")
    delta_x = abs(target_x - x)
    step_x = 1 if x < target_x else -1
    delta_y = -abs(target_y - y)
    step_y = 1 if y < target_y else -1
    error = delta_x + delta_y
    while True:
        level[y * MAP_WIDTH + x] = _make_tile(
            operation.get("tile"),
            rng,
            known_tiles,
            f"{context}.tile",
            allow_empty=True,
        )
        if x == target_x and y == target_y:
            break
        doubled_error = 2 * error
        if doubled_error >= delta_y:
            error += delta_y
            x += step_x
        if doubled_error <= delta_x:
            error += delta_x
            y += step_y


def _apply_scatter(
    level: list[dict[str, Any]],
    operation: dict[str, Any],
    rng: random.Random,
    known_tiles: set[str],
    context: str,
) -> None:
    unknown_fields = sorted(set(operation) - SCATTER_FIELDS)
    if unknown_fields:
        raise RecipeError(f"unknown {context} field '{unknown_fields[0]}'")
    region = operation.get("region")
    if not isinstance(region, dict):
        raise RecipeError(f"{context}.region must be an object")
    unknown_region_fields = sorted(set(region) - SCATTER_REGION_FIELDS)
    if unknown_region_fields:
        raise RecipeError(
            f"unknown {context}.region field '{unknown_region_fields[0]}'"
        )
    dimensions = _rectangle_dimensions(region, f"{context}.region")
    has_count = "count" in operation
    has_density = "density" in operation
    if has_count == has_density:
        raise RecipeError(f"{context} must define exactly one of count or density")
    area = dimensions["width"] * dimensions["height"]
    if has_count:
        count = operation["count"]
        if type(count) is not int or not 0 <= count <= area:
            raise RecipeError(
                f"{context}.count must be an integer between 0 and {area}"
            )
    else:
        density = operation["density"]
        if type(density) not in (int, float) or not 0 <= density <= 1:
            raise RecipeError(f"{context}.density must be a number between 0 and 1")
        count = int(area * density)
    _validate_tile_spec(
        operation.get("tile"),
        known_tiles,
        f"{context}.tile",
        allow_empty=True,
    )
    candidates = [
        y * MAP_WIDTH + x
        for y in range(dimensions["y"], dimensions["y"] + dimensions["height"])
        for x in range(dimensions["x"], dimensions["x"] + dimensions["width"])
    ]
    for level_index in rng.sample(candidates, count):
        level[level_index] = _make_tile(
            operation.get("tile"),
            rng,
            known_tiles,
            f"{context}.tile",
            allow_empty=True,
        )


def generate_map(recipe: dict[str, Any], tiles_path: Path) -> dict[str, Any]:
    """Validate a recipe and return map data matching DMap's saved format."""
    if not isinstance(recipe, dict):
        raise RecipeError("recipe must be a JSON object")
    unknown_fields = sorted(set(recipe) - RECIPE_FIELDS)
    if unknown_fields:
        raise RecipeError(f"unknown recipe field '{unknown_fields[0]}'")

    required_strings = ("id", "name", "description")
    for field in required_strings:
        if not isinstance(recipe.get(field), str) or not recipe[field].strip():
            raise RecipeError(f"{field} must be a non-empty string")
        _validate_unicode(recipe[field], field)
    if re.fullmatch(r"[A-Za-z0-9_-]+", recipe["id"]) is None:
        raise RecipeError(
            "id may contain only letters, numbers, underscores, and hyphens"
        )

    seed = recipe.get("seed")
    if type(seed) is not int:
        raise RecipeError("seed must be an integer")
    known_tiles = _tile_ids(Path(tiles_path))
    rng = random.Random(seed)
    level = [
        _make_tile(recipe.get("base_tile"), rng, known_tiles, "base_tile")
        for _ in range(MAP_WIDTH * MAP_HEIGHT)
    ]

    regions = recipe.get("regions", [])
    if not isinstance(regions, list):
        raise RecipeError("regions must be an array")
    for index, region in enumerate(regions):
        context = f"regions[{index}]"
        if not isinstance(region, dict):
            raise RecipeError(f"{context} must be an object")
        _apply_rectangle(level, region, rng, known_tiles, context, REGION_FIELDS)

    operations = recipe.get("operations", [])
    if not isinstance(operations, list):
        raise RecipeError("operations must be an array")
    for index, operation in enumerate(operations):
        context = f"operations[{index}]"
        if not isinstance(operation, dict):
            raise RecipeError(f"{context} must be an object")
        operation_type = operation.get("type")
        if operation_type in OPERATION_TYPES and "tile" not in operation:
            raise RecipeError(f"{context}.tile is required")
        if operation_type == "set":
            _apply_set(level, operation, rng, known_tiles, context)
        elif operation_type == "rectangle":
            _apply_rectangle(
                level, operation, rng, known_tiles, context, RECTANGLE_FIELDS
            )
        elif operation_type == "rectangle_outline":
            _apply_rectangle_outline(level, operation, rng, known_tiles, context)
        elif operation_type == "line":
            _apply_line(level, operation, rng, known_tiles, context)
        elif operation_type == "scatter":
            _apply_scatter(level, operation, rng, known_tiles, context)
        else:
            raise RecipeError(
                f"{context}.type has unknown operation '{operation_type}'"
            )

    levels = [[] for _ in range(LEVEL_COUNT)]
    levels[POPULATED_LEVEL_INDEX] = level

    return {
        "id": recipe["id"],
        "name": recipe["name"],
        "description": recipe["description"],
        "categories": [],
        "weight": 1000,
        "mapwidth": MAP_WIDTH,
        "mapheight": MAP_HEIGHT,
        "levels": levels,
        "connections": DEFAULT_CONNECTIONS.copy(),
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("recipe", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--overwrite", action="store_true")
    parser.add_argument(
        "--tiles",
        type=Path,
        default=(
            Path(__file__).resolve().parents[1]
            / "Mods"
            / "Dimensionfall"
            / "Tiles"
            / "Tiles.json"
        ),
        help="tile database path (defaults to the core Dimensionfall tile database)",
    )
    args = parser.parse_args(argv)
    try:
        write_map(args.recipe, args.output, args.tiles, args.overwrite)
    except (RecipeError, OSError, json.JSONDecodeError) as error:
        parser.exit(2, f"error: {error}\n")
    print(f"Generated {args.output}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
