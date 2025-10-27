**Feature Specification – Bundling Tile Entities into `tile_feature`**

The current tile representation spreads mutually exclusive entities across separate keys. The `maptile` inner class lists `furniture`, `mob`, `mobgroup`, and `itemgroups` as distinct properties. Editor code repeatedly checks and erases these fields individually before painting or updating tiles. Similar patterns appear when processing area data in `map_manager.gd` and when displaying a tile in the editor.

To simplify handling and guarantee that only one feature exists per tile, we will consolidate these fields into a single dictionary under a new key `feature`.

### 1. Data Model

1. **`maptile` structure**
   - Replace `furniture`, `mob`, `mobgroup`, and `itemgroups` with:
     ```gdscript
     var feature: Dictionary = {}  # {type = "furniture|mob|mobgroup|itemgroup", id = String, rotation = int, itemgroups = Array}
     ```
   - Update `set_data` and `get_data` to read/write `feature`. Old maps containing the legacy fields should be migrated by converting the present field into `feature`. When saving, omit empty `feature` entries.

2. **Compatibility**
   - When loading, check for legacy keys (`mob`, `mobgroup`, `furniture`, `itemgroups`). If found, convert them into the new `feature` dictionary.
   - When saving, only the `feature` key is written.

### 2. Map Generation & Management

1. **Area Processing**
   - In `map_manager.gd`, functions such as `_process_entities_data` should produce a `feature` dictionary instead of adding separate keys.
   - During tile processing, existing features are removed by clearing `tile["feature"]` before assigning a new one.
   
2. **Removal Helper**
   - `remove_entity_from_map` and `remove_entity_from_levels` should check `tile["feature"]["type"]` to decide whether to remove it, rather than erasing each key individually.

### 3. Map Editor

1. **Editing Logic**
   - In `GridContainer.gd`, replace the conditional block that erases multiple keys with logic that either removes or writes to `tileData.feature`.
   - When painting a new entity, set `feature` as:
     ```gdscript
     tileData["feature"] = {"type": entity_type, "id": brush.entityID, "rotation": rotation, "itemgroups": ...}
     ```
     `itemgroups` is only populated when `type` is `"itemgroup"` or when painting furniture with embedded itemgroups.

2. **Display Updates**
   - `mapeditortile.gd` should read from `tileData.feature.type` when determining which sprite to show.
   - Tooltip generation should also reference `feature` to display feature information.

3. **Brush Composer**
   - Brush composition should supply `feature` dictionaries when applying or erasing brushes. Itemgroup lists on furniture continue to be stored in `feature.itemgroups`.

### 4. Migration and Testing

1. **Map Migration Utility**
   - Provide a one-time conversion function that scans all maps and rewrites their tiles using the new structure. This can reside in a helper script or be run as part of loading.

2. **Unit Tests**
   - Add tests verifying that:
     - Loading legacy data correctly populates `feature`.
     - Editing operations only produce a single `feature` per tile.
     - Display functions react to the new structure.

### Benefits

- All tile entity information resides in a single structure, preventing inconsistent states.
- Editor code no longer requires lengthy `if/elif` chains when adding or removing features.
- Future extensions (e.g., new feature types) can be added with minimal changes.
