The mapeditor_brushcomposer.gd currently has a `null_tile` used to control probabilities and distribution. I want to add another tile called npc_tile. It will use `res://Scenes/ContentManager/Mapeditor/Images/nulltile_32.png` as an image for now. THe npc_tile represents a location where an NPC can spawn. The map has no information about what NPC will spawn there since that is controlled outside of the map. The NPC tile only provides information about what coordinates are suitable for NPCs to spawn in.

The goal of this feature is to add a button just like the null_tile button that allows the user to add a npc_tile to the brushcomposer. The user can then use the brushcomposer to paint this tile onto the map. The NPC tile can exist as a feature on a tile, but not together with `mob`, `mobgroup`, `furniture` and `itemgroup`. If an NPC tile is painted onto a coordinate that already has a feature, it should be replaced by the NPC tile. 

When the map is saved, the information about the NPC tile should be saved to the map json trough DMap and DMaps. 

When the `map_manager.gd` is processing the map for the purpose of spawning it into the world, it should only print out a statement that the npc tile has been processed and nothing more. If an area would place furniture or a mob or mobgroup or item on the location of the npc tile, it should replace the NPC tile. 
