# Dimensionfall Map Format Documentation

This document defines the structure and usage of map JSON files in Dimensionfall. This knowledge is intended for agents or developers creating new maps or modifying existing ones through automated means.

## Overview
Dimensionfall maps are stored as JSON files. A map consists of metadata (name, weight, etc.), a list of areas that can be randomly spawned on the map, and a multi-layered grid representing the actual tile layout.

## Map JSON Structure

### Top-Level Fields (Metadata)

| Field | Type | Required | Description |
| :---0|:---|:---|:---|
| `id` | String | Yes | Unique identifier for the map (matches filename without `.json`). |
| `name` | String | Yes | User-friendly name. |
| `description` | String | No | Flavor text describing the map. |
| `categories` | Array[String] | No | Tags used for grouping maps (e.g., `["Field", "Plains"]`). |
| `weight` | Integer | No | Probability weight when selecting maps in a pool (default: `1000`). |
| `mapwidth` | Integer | No | Width of the map grid in tiles (default: `32`). |
| `mapheight` | Integer | No | Height of the map grid in tiles (default: `32`). |
| `connections` | Dictionary | No | Road connection types for cardinal directions (`north`, `south`, `east`, `west`). Values are typically `"road"` or `"ground"`. |
| `areas` | Array[Object] | Yes | List of areas that can be instantiated on the map. |
| `levels` | Array[Array[Object]] | Yes | The actual tile data for each layer/level. |

### Areas Structure
An area defines a "template" for what tiles and entities exist in a specific part of the map. These are used to populate the levels or define specific zones.

**Area Object Fields:**
- `id` (String): Unique identifier for this area template.
- `rotate_random` (Boolean): If true, the area's tile's rotation is randomized upon spawning.
- `spawn_chance` (Integer): Probability (0-100) that this area will spawn in its designated level.
- `tiles` (Array[Object]): A list of tiles that belong to this area. 
	- Each tile object: `{ "id": "tile_id", "count": integer }`.
	- A "null" tile is used to alter the spawn chance of entities, eg. if { "id": "null", "count": 1000 } and the entity is { "id": "Tree_00", "type": "furniture", "count": 1 }, the tree's spawn chance is 1/1000
- `entities` (Array[Object]): A list of entities (furniture, mobs, itemgroups) belonging to this area.
    - Each entity object: `{ "id": "entity_id", "type": "furniture" | "mob" | "mobgroup" | "itemgroup", "count": integer }`.

### Levels Structure
The `levels` field is an array of arrays. Each inner array represents a single depth/layer. 
- An index in the `levels` array containing an empty array `[]` represents an empty level.
- A populated level contains objects (Tiles) that represent actual tile placements.

**Tile Object (in Levels):**
- `id` (String): The ID of the tile to place. Must correspond to a valid entry in `Tiles.json`.
- `rotation` (Integer): Rotation in degrees ($0, 90, 180, 270$).
- `areas` (Array[Object]): A list of area references that are "active" at this tile's location.
	- Each reference: `{ "id": "area_id", "rotation": integer }`.
	- The rotation of the area will be used when the area's tiles and entities are placed, so the default tile/entity's rotation may alter when the area is applied.

## Valid Content References

When constructing maps, ensure all IDs used exist in their respective source files:

1.  **Tiles**: Verified via `Mods/Dimensionfall/Tiles/Tiles.json`.
	*   *Examples*: `grass_plain_01`, `forest_underbrush_00`, `brick_wall_00`.
2.  **Furniture**: Verified via `Mods/Dimensionfall/Furniture/Furniture.json`.
	*   *Examples*: `table_round_wood`, `chair_wood`, `door_wood`.
3.  **Entities**:
	*   `mobgroup`: e.g., `basic_zombies`.
	*   `itemgroup`: e.s., `generic_field_finds`.

## Map Editor Behavior
The Map Editor (`mapeditor.gd`) provides a UI for manual editing. It:
- Allows browsing and selecting tiles from the tile database.
- Supports setting map metadata (name, description, categories).
- Provides checkboxes to toggle `"road"` vs `"ground"` connections.
- Saves changes back to the JSON file using `DMap.save_data_to_disk()`.

## Examples

### Simple Field Map (`field_grass_basic_00.json`)
A minimal map with a base layer of grass tiles and simple area templates for trees and items. Uses many empty levels to represent height/depth layers that are unused.

### Complex Structure (`Generichouse.json`)
Includes specific `pick_one: true` areas which select from a list of floor types (e.g., different carpet or wood patterns) to make sure that area is made using only that one floor type.

## Agent Guidance

### ✅ Do
- **Create new files** for entirely new map concepts to avoid breaking existing mod content.
- Use the `areas` system to build complex, randomized terrain without manually defining thousands of tile entries.
- Respect `mapwidth` and `mapheight` boundaries when populating `levels`.
- Verify all `id` strings against `Tiles.json` and `Furniture.json`.

### ❌ Do Not
- **Modify existing maps** unless specifically tasked to a small change (e.g., changing a connection type).
- Hardcode massive lists of tiles in the `levels` array for large areas; instead, define those tiles in an `area` object and reference that area in the level's tile entry.
- Use IDs that do not exist in the project's content databases.
