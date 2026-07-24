import contextlib
import io
import json
import tempfile
import unittest
from pathlib import Path

from Tools.generate_map_examples import (
    MANIFEST_NAME,
    clean_examples,
    generate_examples,
    main,
)


ROOT = Path(__file__).resolve().parents[2]
RECIPE_PATH = ROOT / "Tools" / "examples" / "map_recipe.json"
TILES_PATH = ROOT / "Mods" / "Dimensionfall" / "Tiles" / "Tiles.json"


class GenerateMapExamplesTests(unittest.TestCase):
    def test_generates_requested_seed_variants_with_unique_ids(self):
        with tempfile.TemporaryDirectory() as directory:
            output_dir = Path(directory)

            generated_paths = generate_examples(
                [RECIPE_PATH],
                output_dir,
                TILES_PATH,
                variants=3,
                starting_seed=700,
            )

            self.assertEqual(
                [path.name for path in generated_paths],
                [
                    "generated_meadow_prototype_example_001.json",
                    "generated_meadow_prototype_example_002.json",
                    "generated_meadow_prototype_example_003.json",
                ],
            )
            maps = [
                json.loads(path.read_text(encoding="utf-8"))
                for path in generated_paths
            ]
            self.assertEqual(
                [data["id"] for data in maps],
                [path.stem for path in generated_paths],
            )
            self.assertTrue(
                all(
                    data["mapwidth"] == 32
                    and data["mapheight"] == 32
                    and len(data["levels"][10]) == 1024
                    for data in maps
                )
            )
            self.assertNotEqual(maps[0]["levels"][10], maps[1]["levels"][10])

    def test_cleanup_removes_only_manifest_owned_maps(self):
        with tempfile.TemporaryDirectory() as directory:
            output_dir = Path(directory)
            unrelated_path = output_dir / "existing_map.json"
            unrelated_path.write_text("{}", encoding="utf-8")
            generated_paths = generate_examples(
                [RECIPE_PATH], output_dir, TILES_PATH, variants=2
            )

            manifest_path = output_dir / MANIFEST_NAME
            self.assertTrue(manifest_path.is_file())

            removed_paths = clean_examples(output_dir)

            self.assertEqual(removed_paths, generated_paths)
            self.assertTrue(unrelated_path.is_file())
            self.assertTrue(all(not path.exists() for path in generated_paths))
            self.assertFalse(manifest_path.exists())

    def test_cli_generates_and_cleans_default_recipe(self):
        with tempfile.TemporaryDirectory() as directory:
            output_dir = Path(directory)
            stdout = io.StringIO()

            with contextlib.redirect_stdout(stdout):
                result = main(
                    [
                        "--output-dir",
                        str(output_dir),
                        "--variants",
                        "2",
                        "--seed",
                        "900",
                    ]
                )

            self.assertEqual(result, 0)
            self.assertEqual(len(list(output_dir.glob("*.json"))), 2)
            self.assertIn("Generated 2 example map(s)", stdout.getvalue())

            with contextlib.redirect_stdout(stdout):
                result = main(["--output-dir", str(output_dir), "--clean"])

            self.assertEqual(result, 0)
            self.assertEqual(list(output_dir.glob("*.json")), [])

    def test_overwritten_unowned_map_is_not_added_to_cleanup_manifest(self):
        with tempfile.TemporaryDirectory() as directory:
            output_dir = Path(directory)
            output_path = output_dir / "generated_meadow_prototype_example_001.json"
            output_path.write_text("original", encoding="utf-8")

            with self.assertRaises(FileExistsError):
                generate_examples(
                    [RECIPE_PATH], output_dir, TILES_PATH, variants=1
                )
            self.assertEqual(output_path.read_text(encoding="utf-8"), "original")

            generate_examples(
                [RECIPE_PATH],
                output_dir,
                TILES_PATH,
                variants=1,
                overwrite=True,
            )

            self.assertEqual(clean_examples(output_dir), [])
            self.assertTrue(output_path.is_file())

    def test_invalid_recipe_does_not_publish_an_output_or_manifest(self):
        with tempfile.TemporaryDirectory() as directory:
            directory_path = Path(directory)
            output_dir = directory_path / "output"
            recipe = json.loads(RECIPE_PATH.read_text(encoding="utf-8"))
            recipe["base_tile"] = {"id": "missing_tile"}
            recipe_path = directory_path / "invalid_recipe.json"
            recipe_path.write_text(json.dumps(recipe), encoding="utf-8")

            with self.assertRaisesRegex(ValueError, "unknown tile 'missing_tile'"):
                generate_examples([recipe_path], output_dir, TILES_PATH, variants=1)

            self.assertEqual(list(output_dir.glob("*.json")), [])
            self.assertFalse((output_dir / MANIFEST_NAME).exists())

    def test_malformed_recipe_is_rejected_before_variant_naming(self):
        with tempfile.TemporaryDirectory() as directory:
            directory_path = Path(directory)
            recipe = json.loads(RECIPE_PATH.read_text(encoding="utf-8"))
            recipe.pop("id")
            recipe_path = directory_path / "malformed_recipe.json"
            recipe_path.write_text(json.dumps(recipe), encoding="utf-8")

            with self.assertRaisesRegex(ValueError, "id must be a non-empty string"):
                generate_examples(
                    [recipe_path], directory_path / "output", TILES_PATH, variants=1
                )

    def test_same_recipe_and_seed_produce_identical_variants(self):
        with (
            tempfile.TemporaryDirectory() as first_directory,
            tempfile.TemporaryDirectory() as second_directory,
        ):
            first_paths = generate_examples(
                [RECIPE_PATH],
                Path(first_directory),
                TILES_PATH,
                variants=2,
                starting_seed=50,
            )
            second_paths = generate_examples(
                [RECIPE_PATH],
                Path(second_directory),
                TILES_PATH,
                variants=2,
                starting_seed=50,
            )

            self.assertEqual(
                [path.read_text(encoding="utf-8") for path in first_paths],
                [path.read_text(encoding="utf-8") for path in second_paths],
            )

    def test_duplicate_recipe_ids_are_rejected_before_publication(self):
        with tempfile.TemporaryDirectory() as directory:
            directory_path = Path(directory)
            output_dir = directory_path / "output"
            first_recipe = directory_path / "first.json"
            second_recipe = directory_path / "second.json"
            recipe_text = RECIPE_PATH.read_text(encoding="utf-8")
            first_recipe.write_text(recipe_text, encoding="utf-8")
            second_recipe.write_text(recipe_text, encoding="utf-8")

            with self.assertRaisesRegex(ValueError, "duplicate output path"):
                generate_examples(
                    [first_recipe, second_recipe],
                    output_dir,
                    TILES_PATH,
                    variants=2,
                    overwrite=True,
                )

            self.assertFalse(output_dir.exists())

    def test_cleanup_preserves_generated_path_replaced_by_other_content(self):
        with tempfile.TemporaryDirectory() as directory:
            output_dir = Path(directory)
            generated_path = generate_examples(
                [RECIPE_PATH], output_dir, TILES_PATH, variants=1
            )[0]
            replacement = '{"unrelated": true}\n'
            generated_path.write_text(replacement, encoding="utf-8")

            removed_paths = clean_examples(output_dir)

            self.assertEqual(removed_paths, [])
            self.assertEqual(generated_path.read_text(encoding="utf-8"), replacement)
            self.assertFalse((output_dir / MANIFEST_NAME).exists())

    def test_existing_later_output_is_rejected_before_any_publication(self):
        with tempfile.TemporaryDirectory() as directory:
            output_dir = Path(directory)
            existing_path = (
                output_dir / "generated_meadow_prototype_example_002.json"
            )
            existing_path.write_text("existing", encoding="utf-8")

            with self.assertRaises(FileExistsError):
                generate_examples(
                    [RECIPE_PATH], output_dir, TILES_PATH, variants=2
                )

            self.assertFalse(
                (output_dir / "generated_meadow_prototype_example_001.json").exists()
            )
            self.assertEqual(existing_path.read_text(encoding="utf-8"), "existing")
            self.assertFalse((output_dir / MANIFEST_NAME).exists())


if __name__ == "__main__":
    unittest.main()
