# Manual example-map generation

`Tools/generate_map_examples.py` generates deterministic variants of maintained map recipes for manual inspection. It delegates map construction, validation, overwrite protection, and atomic publication to `Tools/map_generator.py`; it does not contain a second generator implementation.

Run all commands from the repository root. On the standard Hermes host checkout:

```bash
cd ~/local/dimensionfall/repository
```

## Safe first run

Generate three variants in a temporary directory:

```bash
python3 Tools/generate_map_examples.py \
  --output-dir /tmp/dimensionfall-map-examples
```

The default recipe is `Tools/examples/map_recipe.json`. Each variant receives:

- a unique ID and matching filename ending in `_example_001`, `_example_002`, and so on;
- a sequential seed, beginning with the recipe's seed unless `--seed` is supplied;
- complete 32 x 32 map data validated before publication.

Inspect the generated files with the validator if desired:

```bash
python3 Tools/map_validator.py /tmp/dimensionfall-map-examples
```

## Choose the number of variants and starting seed

Generate five reproducible variants using seeds `1000` through `1004`:

```bash
python3 Tools/generate_map_examples.py \
  --output-dir /tmp/dimensionfall-map-examples \
  --variants 5 \
  --seed 1000
```

Running the same complete recipe with the same starting seed produces the same map JSON. Changing the seed changes seeded scatter placement and random tile rotations.

## Inspect generated maps in the content editor

Place examples in the core mod's map directory:

```bash
python3 Tools/generate_map_examples.py \
  --output-dir Mods/Dimensionfall/Maps \
  --variants 3 \
  --seed 1000
```

Launch Godot after generation and run the Dimensionfall project.
In the running project, navigate to:

```text
Content Manager
  → Content Editor
  → select the Dimensionfall mod
  → Expand the Maps category if it is still collapsed
  → open a generated map by doubleclicking it in the map list
  → View Map in the editor, click `save and test` to test it manually
```

If Godot was already running when files were generated, restart it so mod content is loaded again. The existing map-editor preview displays generated map JSON; the Python tool does not create a separate image or HTML preview.

Dimensionfall also looks for a same-named `.png` map sprite during startup. The runner intentionally generates map JSON only, so Godot currently logs a non-fatal missing-resource error for that sprite. This does not prevent the JSON map from loading or the map editor's tile-grid preview from rendering it.

## Generate from specific recipes

Pass one or more recipe paths before the options. The runner generates the requested number of variants for every recipe:

```bash
python3 Tools/generate_map_examples.py \
  Tools/examples/map_recipe.json \
  --output-dir /tmp/dimensionfall-map-examples \
  --variants 2 \
  --seed 500
```

Use a different tile database when testing another mod's recipe:

```bash
python3 Tools/generate_map_examples.py \
  path/to/recipe.json \
  --output-dir /tmp/dimensionfall-map-examples \
  --tiles path/to/Tiles.json
```

## Overwrite protection

Existing output files are protected by default. A repeated command using the same IDs reports an error instead of replacing them.

To deliberately regenerate those files, add `--overwrite`:

```bash
python3 Tools/generate_map_examples.py \
  --output-dir /tmp/dimensionfall-map-examples \
  --variants 3 \
  --seed 1000 \
  --overwrite
```

An overwritten file that was not originally created by this runner is not claimed by its cleanup manifest and will not be deleted by `--clean`.

## Safe cleanup

The runner records newly created output filenames and SHA-256 digests in:

```text
.dimensionfall-map-examples-manifest
```

The manifest has no `.json` extension, so it is not treated as a map. Cleanup removes only recorded map files whose contents still match their generated SHA-256 digest:

```bash
python3 Tools/generate_map_examples.py \
  --output-dir /tmp/dimensionfall-map-examples \
  --clean
```

Remove examples installed for editor inspection with:

```bash
python3 Tools/generate_map_examples.py \
  --output-dir Mods/Dimensionfall/Maps \
  --clean
```

Unrelated maps in the output directory are left untouched. A generated path that has since been changed or replaced is also preserved. If the manifest is missing, cleanup removes nothing. If it is malformed, cleanup stops rather than guessing which files are safe to delete.

## Useful checks

Show all command options:

```bash
python3 Tools/generate_map_examples.py --help
```

Validate all generated maps in a temporary output directory:

```bash
python3 Tools/map_validator.py /tmp/dimensionfall-map-examples
```

Confirm generated map dimensions and populated levels:

```bash
python3 - <<'PY'
import json
from pathlib import Path

for path in sorted(Path("/tmp/dimensionfall-map-examples").glob("*.json")):
    data = json.loads(path.read_text(encoding="utf-8"))
    populated = [index for index, level in enumerate(data["levels"]) if level]
    print(
        path.name,
        f"{data['mapwidth']}x{data['mapheight']}",
        f"ground tiles={len(data['levels'][10])}",
        f"populated levels={populated}",
    )
PY
```

## Current limitations

- Variants change the recipe seed; they do not synthesize new recipe operations.
- Generated maps contain terrain only. Furniture, areas, buildings, semantic roads, and additional populated levels are not supported yet.
- The maps can be inspected with the existing content-editor preview, but the runner does not launch Godot or inject maps into an already-running editor session.
- Installing examples under `Mods/Dimensionfall/Maps` makes them available to the content editor, but does not automatically reference them from overmap-area generation.
