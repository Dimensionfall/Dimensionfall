Right now the overmap visualization tool shows an error when hitting generate

```
Invalid call. Nonexistent function 'get_maps_by_category' in base 'Nil'.
```


We need to reconstruct the runtimedata in order to fix this error:

```
	Runtimedata.reconstruct()  # Load all mod data in the proper way
```

This will load all enabled mods in the proper order. 

THe maps will then be accessed in OvermapGrid.gd when the `overmap_grid_visualization.gd` calls the `generate_grid` function
```
var road_maps: Array[RMap] = Runtimedata.maps.get_maps_by_category("Road")
var forest_road_maps: Array[RMap] = Runtimedata.maps.get_maps_by_category("Forest Road")
```

The goal of this feature is to make sure that the runtimedata is reconstructed sometime after `_on_generate_button_button_up` is called when the player presses the generate button.
