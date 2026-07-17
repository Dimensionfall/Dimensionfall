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
RECIPE_FIELDS = {
    "id",
    "name",
    "description",
    "seed",
    "base_tile",
    "regions",
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


def _make_tile(
    spec: Any,
    rng: random.Random,
    known_tiles: set[str],
    context: str,
    *,
    allow_empty: bool = False,
) -> dict[str, Any]:
    if spec is None and allow_empty:
        return {}
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
    if rotation == "random":
        rotation = rng.choice(VALID_ROTATIONS)
    if type(rotation) is not int or rotation not in VALID_ROTATIONS:
        raise RecipeError(f"{context}.rotation must be 0, 90, 180, 270, or 'random'")
    tile: dict[str, Any] = {"id": tile_id}
    if rotation:
        tile["rotation"] = rotation
    return tile


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
        unknown_fields = sorted(set(region) - REGION_FIELDS)
        if unknown_fields:
            raise RecipeError(f"unknown {context} field '{unknown_fields[0]}'")
        dimensions: dict[str, int] = {}
        for field in ("x", "y", "width", "height"):
            value = region.get(field)
            minimum = 0 if field in ("x", "y") else 1
            if type(value) is not int or value < minimum:
                qualifier = "non-negative" if minimum == 0 else "positive"
                raise RecipeError(f"{context}.{field} must be a {qualifier} integer")
            dimensions[field] = value
        if (
            dimensions["x"] + dimensions["width"] > MAP_WIDTH
            or dimensions["y"] + dimensions["height"] > MAP_HEIGHT
        ):
            raise RecipeError(
                f"{context} extends outside the {MAP_WIDTH}x{MAP_HEIGHT} map"
            )
        for y in range(dimensions["y"], dimensions["y"] + dimensions["height"]):
            for x in range(dimensions["x"], dimensions["x"] + dimensions["width"]):
                level[y * MAP_WIDTH + x] = _make_tile(
                    region.get("tile"),
                    rng,
                    known_tiles,
                    f"{context}.tile",
                    allow_empty=True,
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
