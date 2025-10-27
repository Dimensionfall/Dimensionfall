Previously, the DNpc and RNpc classes were created to load and save NPC data. Next, I want to configure where the NPC will spawn. This feature will exclude the actual spawning mechanic, and instead includes the configuration of where the NPC might spawn.

The requirements are:
1. An NPC will have a weighted list of maps in its data, similar to an OvermapArea
2. An user can open the NPC editor and drag a map from the maps content_list onto the NPC editor to add it to the weighted list
3. The map list for NPCs will include a map id and a number representing the weight. The default weight will be 100
