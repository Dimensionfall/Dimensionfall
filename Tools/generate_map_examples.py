#!/usr/bin/env python3
"""Generate deterministic example-map variants from maintained recipes."""

from __future__ import annotations

import argparse
import copy
import hashlib
import json
import os
import sys
import tempfile
from pathlib import Path

try:
    from .map_generator import generate_map, load_recipe, write_map
except ImportError:  # Direct execution from Tools/.
    from map_generator import generate_map, load_recipe, write_map


MANIFEST_NAME = ".dimensionfall-map-examples-manifest"
ROOT = Path(__file__).resolve().parents[1]
DEFAULT_RECIPE_PATH = ROOT / "Tools" / "examples" / "map_recipe.json"
DEFAULT_TILES_PATH = ROOT / "Mods" / "Dimensionfall" / "Tiles" / "Tiles.json"


def _manifest_path(output_dir: Path) -> Path:
    return output_dir / MANIFEST_NAME


def _load_manifest(output_dir: Path) -> dict[str, str]:
    manifest_path = _manifest_path(output_dir)
    if not manifest_path.exists():
        return {}
    with manifest_path.open(encoding="utf-8") as handle:
        manifest = json.load(handle)
    if not isinstance(manifest, dict) or manifest.get("version") != 2:
        raise ValueError(f"invalid example-map manifest: {manifest_path}")
    files = manifest.get("files")
    if not isinstance(files, dict):
        raise ValueError(f"invalid example-map manifest: {manifest_path}")
    for filename, digest in files.items():
        if (
            not isinstance(filename, str)
            or Path(filename).name != filename
            or not filename.endswith(".json")
            or not isinstance(digest, str)
            or len(digest) != 64
            or any(character not in "0123456789abcdef" for character in digest)
        ):
            raise ValueError(f"invalid example-map manifest entry: {filename!r}")
    return files


def _write_manifest(output_dir: Path, files: dict[str, str]) -> None:
    output_dir.mkdir(parents=True, exist_ok=True)
    manifest_path = _manifest_path(output_dir)
    temporary_path: Path | None = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w",
            encoding="utf-8",
            dir=output_dir,
            prefix=f".{MANIFEST_NAME}.",
            delete=False,
        ) as temporary:
            json.dump({"version": 2, "files": files}, temporary, indent=2)
            temporary.write("\n")
            temporary_path = Path(temporary.name)
        os.replace(temporary_path, manifest_path)
        temporary_path = None
    finally:
        if temporary_path is not None:
            temporary_path.unlink(missing_ok=True)


def _file_digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def clean_examples(output_dir: Path) -> list[Path]:
    """Remove unchanged files recorded in the example-runner manifest."""
    output_dir = Path(output_dir)
    files = _load_manifest(output_dir)
    removed_paths: list[Path] = []
    for filename, expected_digest in files.items():
        path = output_dir / filename
        if path.is_file() and _file_digest(path) == expected_digest:
            path.unlink()
            removed_paths.append(path)
    _manifest_path(output_dir).unlink(missing_ok=True)
    return removed_paths


def generate_examples(
    recipe_paths: list[Path],
    output_dir: Path,
    tiles_path: Path,
    *,
    variants: int = 3,
    starting_seed: int | None = None,
    overwrite: bool = False,
) -> list[Path]:
    """Generate validated seed variants and return their output paths."""
    if type(variants) is not int or variants < 1:
        raise ValueError("variants must be a positive integer")

    output_dir = Path(output_dir)
    tiles_path = Path(tiles_path)
    owned_files = _load_manifest(output_dir)
    planned_outputs: list[tuple[dict, Path]] = []
    output_paths: set[Path] = set()

    for recipe_path in recipe_paths:
        source_recipe = load_recipe(Path(recipe_path))
        generate_map(source_recipe, tiles_path)
        base_seed = (
            source_recipe.get("seed") if starting_seed is None else starting_seed
        )
        if type(base_seed) is not int:
            raise ValueError("starting seed must be an integer")

        for variant_index in range(variants):
            variant_number = variant_index + 1
            recipe = copy.deepcopy(source_recipe)
            recipe["id"] = f"{source_recipe['id']}_example_{variant_number:03d}"
            recipe["name"] = f"{source_recipe['name']} Example {variant_number:03d}"
            recipe["description"] = (
                f"{source_recipe['description']} "
                f"Example seed: {base_seed + variant_index}."
            )
            recipe["seed"] = base_seed + variant_index
            generate_map(recipe, tiles_path)
            output_path = output_dir / f"{recipe['id']}.json"
            if output_path in output_paths:
                raise ValueError(f"duplicate output path: {output_path}")
            output_paths.add(output_path)
            planned_outputs.append((recipe, output_path))

    if not overwrite:
        existing_paths = [path for _, path in planned_outputs if path.exists()]
        if existing_paths:
            raise FileExistsError(
                f"output already exists: {existing_paths[0]}; "
                "use --overwrite to replace it"
            )

    generated_paths: list[Path] = []
    for recipe, output_path in planned_outputs:
        existed_before = output_path.exists()

        with tempfile.NamedTemporaryFile(
            mode="w", encoding="utf-8", suffix=".json", delete=False
        ) as temporary:
            json.dump(recipe, temporary, ensure_ascii=False)
            temporary_path = Path(temporary.name)
        try:
            write_map(temporary_path, output_path, tiles_path, overwrite)
        finally:
            temporary_path.unlink(missing_ok=True)
        if not existed_before or output_path.name in owned_files:
            owned_files[output_path.name] = _file_digest(output_path)
            try:
                _write_manifest(output_dir, owned_files)
            except Exception:
                output_path.unlink(missing_ok=True)
                raise
        generated_paths.append(output_path)

    return generated_paths


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "recipes",
        nargs="*",
        type=Path,
        help="recipe paths (defaults to Tools/examples/map_recipe.json)",
    )
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--variants", type=int, default=3)
    parser.add_argument("--seed", type=int)
    parser.add_argument("--overwrite", action="store_true")
    parser.add_argument("--clean", action="store_true")
    parser.add_argument("--tiles", type=Path, default=DEFAULT_TILES_PATH)
    args = parser.parse_args(argv)

    try:
        if args.clean:
            if args.recipes or args.overwrite or args.seed is not None:
                parser.error(
                    "--clean cannot be combined with recipes, --overwrite, or --seed"
                )
            removed_paths = clean_examples(args.output_dir)
            print(f"Removed {len(removed_paths)} example map(s) from {args.output_dir}")
            return 0

        recipe_paths = args.recipes or [DEFAULT_RECIPE_PATH]
        generated_paths = generate_examples(
            recipe_paths,
            args.output_dir,
            args.tiles,
            variants=args.variants,
            starting_seed=args.seed,
            overwrite=args.overwrite,
        )
    except (OSError, ValueError, json.JSONDecodeError) as error:
        parser.exit(2, f"error: {error}\n")

    print(f"Generated {len(generated_paths)} example map(s):")
    for path in generated_paths:
        print(f"  {path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
