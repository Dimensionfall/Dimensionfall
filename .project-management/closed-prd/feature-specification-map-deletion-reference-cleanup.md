The reason why we keep references is so that we can update the rest of the mod content when one element is gone.

When a map is deleted, it should find the map id in `/maps/references.json`
For each of the references for that map id, it should remove the map from that entity. For example, if an NPC references the map, it should be removed from the NPC's spawn_map list
if overmapareas reference the map, the map should also be removed from the overmap area
lastly, the map ID should be removed from the `/maps/references.json` file

Here is an example from /maps/references.json where the `radio_tower` map is referenced by an overmaparea called `city` and a quest called `quest radio signal 01 `.
```Json

	"radio_tower": {
		"overmapareas": [
			"city"
		],
		"quests": [
			"quest_radio_signal_01"
		]
	},
```

When radio tower is deleted, it should remove the map from the overmaparea trough the DOvermapareas class. It should also edit the radio signal quest so that the quest no longer uses the deleted radio tower map.

Since the references are properly created, the goal of this feature is to make sure that we use the references to update other entities that use the deleted map.
