class_name DItem
extends RefCounted

# There's a D in front of the class name to indicate this class only handles map data, nothing more
# This script is intended to be used inside the GameData autoload singleton
# This script handles the data for one item. You can access it through Gamedata.mods.by_id("Core").items

# Constants for default values
const DEFAULT_WEIGHT = 1.0
const DEFAULT_VOLUME = 1.0
const DEFAULT_STACK_SIZE = 1

# This class represents a piece of item with its properties
var id: String
var name: String
var description: String
var weight: float
var volume: float
var sprite: Texture
var spriteid: String
var image: String
var stack_size: int
var max_stack_size: int
var two_handed: bool
var parent: DItems

# Other properties per type
var craft: Craft
var magazine: Magazine
var ranged: Ranged
var melee: Melee
var food: Food
var medical: Medical
var ammo: Ammo
var wearable: Wearable
var tool: Tool


# Inner class to handle the Craft property
class CraftRecipe:
	var craft_amount: int
	var craft_time: int
	var flags: Dictionary # Example: { "requires_light": false, "hand_craftable": true }
	var required_resources: Array # A list of objects like {"amount": 1, "id": "steel_scrap"}
	var skill_progression: Dictionary # example: { "id": "fabrication", "xp": 10 }
	var skill_requirement: Dictionary # example: { "id": "fabrication", "level": 1 }

	# Constructor to initialize craft properties from a dictionary
	func _init(data: Dictionary):
		craft_amount = data.get("craft_amount", 1)
		craft_time = data.get("craft_time", 0)
		flags = data.get("flags", {})
		required_resources = data.get("required_resources", [])
		skill_progression = data.get("skill_progression", {})
		skill_requirement = data.get("skill_requirement", {})

	# Get data function to return a dictionary with all properties
	func get_data() -> Dictionary:
		var mydata: Dictionary = {
			"craft_amount": craft_amount,
			"craft_time": craft_time,
			"flags": flags,
			"required_resources": required_resources
		}
		if not skill_requirement.is_empty():
			mydata["skill_requirement"] = skill_requirement
		if not skill_progression.is_empty():
			mydata["skill_progression"] = skill_progression
		return mydata
		
	# Function to get used skill IDs
	func get_used_skill_ids() -> Array:
		var skill_ids = []
		if skill_requirement.has("id"):
			skill_ids.append(skill_requirement["id"])
		if skill_progression.has("id"):
			skill_ids.append(skill_progression["id"])
		return skill_ids

	# Function to remove all instances of a skill from the recipe
	func remove_skill(skill_id: String) -> bool:
		var changes_made = false
		if skill_requirement.has("id") and skill_requirement["id"] == skill_id:
			skill_requirement.clear()
			changes_made = true
		if skill_progression.has("id") and skill_progression["id"] == skill_id:
			skill_progression.clear()
			changes_made = true
		return changes_made


class Craft:
	var recipes: Array[CraftRecipe] = []

	# Constructor to initialize craft properties from a dictionary
	func _init(data: Array):
		for recipe in data:
			recipes.append(CraftRecipe.new(recipe))

	# Get data function to return a dictionary with all properties
	func get_data() -> Array:
		var craft_data: Array = []
		if recipes.size() > 0:
			for recipe in recipes:
				craft_data.append(recipe.get_data())
		return craft_data
		
	# Function to get used skill IDs
	func get_used_skill_ids() -> Array:
		var skill_ids = []
		for recipe in recipes:
			skill_ids += recipe.get_used_skill_ids()
		return skill_ids
	
	# Function to remove all instances of an item from all recipes
	func remove_item_from_recipes(item_id: String) -> bool:
		var changes_made = false
		for recipe in recipes:
			var resources = recipe.required_resources
			for i in range(len(resources) - 1, -1, -1):
				if resources[i].get("id") == item_id:
					resources.remove_at(i)
					changes_made = true
		return changes_made

	# Function to get all used items in the recipes
	func get_all_used_items() -> Array:
		var used_items = []
		for recipe in recipes:
			var resources = recipe.required_resources
			for resource in resources:
				if not used_items.has(resource["id"]):
					used_items.append(resource["id"])
		return used_items
	
	# Function to remove all instances of a skill from all recipes
	func remove_skill_from_recipes(skill_id: String) -> bool:
		var changes_made = false
		for recipe in recipes:
			if recipe.remove_skill(skill_id):
				changes_made = true
		return changes_made
	

# Inner class to handle the Magazine property
class Magazine:
	var current_ammo: int
	var max_ammo: int
	var used_ammo: String

	# Constructor to initialize magazine properties from a dictionary
	func _init(data: Dictionary):
		current_ammo = int(data.get("current_ammo", 0))
		max_ammo = int(data.get("max_ammo", 0))
		used_ammo = data.get("used_ammo", "")

	# Get data function to return a dictionary with all properties
	func get_data() -> Dictionary:
		return {
			"current_ammo": current_ammo,
			"max_ammo": max_ammo,
			"used_ammo": used_ammo
		}


# Inner class to handle the Ranged property
class Ranged:
	var firing_speed: float
	var firing_range: int
	var recoil: int
	var reload_speed: float
	var spread: int
	var sway: int
	var used_ammo: String
	var used_magazine: String
	var used_skill: Dictionary # example: {"skill_id": "handguns", "xp": 1}
	var accuracy_stat: String

	# Constructor to initialize ranged properties from a dictionary
	func _init(data: Dictionary):
		firing_speed = data.get("firing_speed", 0.0)
		firing_range = data.get("range", 0)
		recoil = data.get("recoil", 0)
		reload_speed = data.get("reload_speed", 0.0)
		spread = data.get("spread", 0)
		sway = data.get("sway", 0)
		used_ammo = data.get("used_ammo", "")
		used_magazine = data.get("used_magazine", "")
		used_skill = data.get("used_skill", {})
		accuracy_stat = data.get("accuracy_stat", "")

	# Get data function to return a dictionary with all properties
	func get_data() -> Dictionary:
		var data: Dictionary = {
			"firing_speed": firing_speed,
			"range": firing_range,
			"recoil": recoil,
			"reload_speed": reload_speed,
			"spread": spread,
			"sway": sway,
			"used_ammo": used_ammo,
			"used_magazine": used_magazine,
			"used_skill": used_skill
		}
		if accuracy_stat != "":
			data["accuracy_stat"] = accuracy_stat
		return data
		
	# Function to get used skill ID
	func get_used_skill_ids() -> Array:
		if used_skill.has("skill_id"):
			return [used_skill["skill_id"]]
		return []

	# Function to remove all instances of a skill
	func remove_skill(skill_id: String) -> bool:
		if used_skill.has("skill_id") and used_skill["skill_id"] == skill_id:
			used_skill.clear()
			return true
		return false


# Inner class to handle the Melee property
class Melee:
	var damage: int
	var reach: int
	var used_skill: Dictionary # example: {"skill_id": "bashing", "xp": 1}
	var damage_stat: String
	var accuracy_stat: String

	# Constructor to initialize melee properties from a dictionary
	func _init(data: Dictionary):
		damage = data.get("damage", 0)
		reach = data.get("reach", 0)
		used_skill = data.get("used_skill", {})
		damage_stat = data.get("damage_stat", "")
		accuracy_stat = data.get("accuracy_stat", "")

	# Get data function to return a dictionary with all properties
	func get_data() -> Dictionary:
		var data: Dictionary = {
			"damage": damage,
			"reach": reach,
			"used_skill": used_skill
		}
		if damage_stat != "":
			data["damage_stat"] = damage_stat
		if accuracy_stat != "":
			data["accuracy_stat"] = accuracy_stat
		return data

	# Function to get used skill ID
	func get_used_skill_ids() -> Array:
		if used_skill.has("skill_id"):
			return [used_skill["skill_id"]]
		return []

	# Function to remove all instances of a skill
	func remove_skill(skill_id: String) -> bool:
		if used_skill.has("skill_id") and used_skill["skill_id"] == skill_id:
			used_skill.clear()
			return true
		return false


# Inner class to handle the Food property
class Food:
	var attributes: Array = []  # example: [{"id":"food","amount":10}]

	# Constructor to initialize food properties from a dictionary
	func _init(data: Dictionary):
		attributes = []
		if data.has("attributes"):
			attributes = data["attributes"]

	# Get data function to return a dictionary with all properties
	func get_data() -> Dictionary:
		var food_data: Dictionary = {}
		if not attributes.is_empty():
			food_data["attributes"] = attributes
		return food_data

	# Function to return an array of all "id" values in the attributes array
	func get_attr_ids() -> Array:
		var ids: Array = []
		for attribute in attributes:
			if attribute.has("id"):
				ids.append(attribute["id"])
		return ids

	# Function to remove a player attribute by its ID
	func remove_player_attribute(attribute_id: String) -> void:
		for i in range(attributes.size()):
			if attributes[i]["id"] == attribute_id:
				attributes.remove_at(i)	 # Remove the attribute if the ID matches
				break  # Exit the loop after removing the attribute


# Inner class to handle the Medical property
class Medical:
	var attributes: Array = []  # example: [{"id":"torso","amount":10}]
	var amount: float  # The general amount to be added to attributes
	# The order by which to apply the amount. Can be "Ascending", "Descending"
	# "Lowest first", "Highest first" and "Random"
	var order: String

	# Constructor to initialize Medical properties from a dictionary
	func _init(data: Dictionary):
		attributes = []
		if data.has("attributes"):
			attributes = data["attributes"]
		amount = data.get("amount", 0.0)
		order = data.get("order", "Random")  # Default to "Random" if not provided

	# Get data function to return a dictionary with all properties
	func get_data() -> Dictionary:
		var medical_data: Dictionary = {}
		if not attributes.is_empty():
			medical_data["attributes"] = attributes
		medical_data["amount"] = amount
		medical_data["order"] = order
		return medical_data

	# Function to return an array of all "id" values in the attributes array
	func get_attr_ids() -> Array:
		var ids: Array = []
		for attribute in attributes:
			if attribute.has("id"):
				ids.append(attribute["id"])
		return ids

	# Function to remove a player attribute by its ID
	func remove_player_attribute(attribute_id: String) -> void:
		for i in range(attributes.size()):
			if attributes[i]["id"] == attribute_id:
				attributes.remove_at(i)	 # Remove the attribute if the ID matches
				break  # Exit the loop after removing the attribute


# Inner class to handle the Ammo property
class Ammo:
	var damage: int

	# Constructor to initialize food properties from a dictionary
	func _init(data: Dictionary):
		damage = int(data.get("damage", 0))

	# Get data function to return a dictionary with all properties
	func get_data() -> Dictionary:
		return {
			"damage": damage
		}

# Inner class to handle the Wearable property
class Wearable:
	var slot: String
	# Hold key-value pairs for player attributes. New format: {"id": "inventory_space", "value": 200}
	var player_attributes: Array  

	# Constructor to initialize wearable properties from a dictionary
	func _init(data: Dictionary):
		slot = data.get("slot", "")
		# Initialize player_attributes with the new format
		player_attributes = data.get("player_attributes", [])

	# Get data function to return a dictionary with all properties
	func get_data() -> Dictionary:
		var mydata: Dictionary = {}
		if slot:
			mydata["slot"] = slot
		if not player_attributes.is_empty():
			mydata["player_attributes"] = player_attributes
		return mydata

	# Function to add a reference for the wearable slot
	func add_reference(item_id: String):
		if slot != "":
			Gamedata.mods.add_reference(DMod.ContentType.WEARABLESLOTS, slot, DMod.ContentType.ITEMS, item_id)

	# Function to remove a reference for the wearable slot
	func remove_reference(item_id: String):
		if slot != "":
			Gamedata.mods.remove_reference(DMod.ContentType.WEARABLESLOTS, slot, DMod.ContentType.ITEMS, item_id)

	# Function to get the value of a specific player attribute by ID
	func get_attribute_value(attribute_id: String) -> Variant:
		for attribute in player_attributes:
			if attribute["id"] == attribute_id:
				return attribute["value"]
		return null  # Return null if the attribute is not found

	# Function to remove a player attribute by its ID
	func remove_player_attribute(attribute_id: String) -> void:
		for i in range(player_attributes.size()):
			if player_attributes[i]["id"] == attribute_id:
				player_attributes.remove_at(i)	# Remove the attribute if the ID matches
				break  # Exit the loop after removing the attribute


# Inner class to handle the Tool property
class Tool:
	var tool_qualities: Dictionary	# Example: { "flashlight": 1 }

	# Constructor to initialize tool properties from a dictionary
	func _init(data: Dictionary):
		tool_qualities = data.get("tool_qualities", {})

	# Get data function to return a dictionary with all properties
	func get_data() -> Dictionary:
		return { "tool_qualities": tool_qualities }


# Constructor to initialize item properties from a dictionary
# myparent: The list containing all items for this mod
func _init(data: Dictionary, parent_container: DItems):
	parent = parent_container
	_initialize_general_properties(data)
	_initialize_specialized_properties(data)


# --- Initialization Functions ---
# Initialize general item properties from data
func _initialize_general_properties(data: Dictionary) -> void:
	id = data.get("id", "")
	name = data.get("name", "")
	description = data.get("description", "")
	weight = data.get("weight", DEFAULT_WEIGHT)
	volume = data.get("volume", DEFAULT_VOLUME)
	spriteid = data.get("sprite", "")
	image = data.get("image", "")
	stack_size = data.get("stack_size", DEFAULT_STACK_SIZE)
	max_stack_size = data.get("max_stack_size", DEFAULT_STACK_SIZE)
	two_handed = data.get("two_handed", false)


# Initialize specialized item properties
func _initialize_specialized_properties(data: Dictionary) -> void:
	craft = _initialize_subclass(data, "Craft", Craft)
	magazine = _initialize_subclass(data, "Magazine", Magazine)
	ranged = _initialize_subclass(data, "Ranged", Ranged)
	melee = _initialize_subclass(data, "Melee", Melee)
	food = _initialize_subclass(data, "Food", Food)
	medical = _initialize_subclass(data, "Medical", Medical)
	ammo = _initialize_subclass(data, "Ammo", Ammo)
	wearable = _initialize_subclass(data, "Wearable", Wearable)
	tool = _initialize_subclass(data, "Tool", Tool)


# Helper to initialize a subclass if data is present
func _initialize_subclass(data: Dictionary, key: String, cls: Object) -> Object:
	return cls.new(data[key]) if data.has(key) else null


# Get data function to return a dictionary with all properties
func get_data() -> Dictionary:
	var data: Dictionary = {
		"id": id,
		"name": name,
		"description": description,
		"weight": weight,
		"volume": volume,
		"sprite": spriteid,
		"image": image,
		"stack_size": stack_size,
		"max_stack_size": max_stack_size,
		"two_handed": two_handed
	}

	# Add Craft and Magazine data if they exist
	if craft:
		data["Craft"] = craft.get_data()

	if magazine:
		data["Magazine"] = magazine.get_data()

	if ranged:
		data["Ranged"] = ranged.get_data()

	if melee:
		data["Melee"] = melee.get_data()

	if food:
		data["Food"] = food.get_data()

	if medical:
		data["Medical"] = medical.get_data()

	if ammo:
		data["Ammo"] = ammo.get_data()

	if tool:
		data["Tool"] = tool.get_data()

	if wearable:
		var wearabledata = wearable.get_data()
		if not wearabledata.is_empty():
			data["Wearable"] = wearabledata

	return data


# Returns the path of the sprite
func get_sprite_path() -> String:
	return parent.spritePath + spriteid


# Some item has been changed
# We need to update the relation between the item and other items based on crafting recipes
func changed(olddata: DItem):
	# Handle wearable slot reference. 
	if wearable:
		# If the slot data changed between old and new, we update the reference
		var old_slot = null
		if olddata.wearable:
			old_slot = olddata.wearable.slot

		if old_slot != wearable.slot:
			if old_slot:
				olddata.wearable.remove_reference(id)
			if wearable.slot:
				wearable.add_reference(id)
		
		process_wearable_player_attributes(olddata)
		
	elif olddata.wearable and olddata.wearable.slot:
		# The wearable is present in the old data but not in the new, so we remove the reference
		olddata.wearable.remove_reference(id)
	
	
	# Dictionaries to track unique resource IDs across all recipes
	var old_resource_ids: Dictionary = {}
	var new_resource_ids: Dictionary = {}

	# Collect all unique resource IDs from old recipes if olddata.craft is not null
	if olddata.craft:
		for recipe: CraftRecipe in olddata.craft.recipes:
			for resource in recipe.required_resources:
				old_resource_ids[resource["id"]] = true

	# Collect all unique resource IDs from new recipes if craft is not null
	if craft:
		for recipe in craft.recipes:
			for resource in recipe.required_resources:
				new_resource_ids[resource["id"]] = true

	# Resources that are no longer in the recipe will no longer reference this item
	for res_id in old_resource_ids:
		if not new_resource_ids.has(res_id):
			Gamedata.mods.remove_reference(DMod.ContentType.ITEMS, res_id, DMod.ContentType.ITEMS, id)
	
	# Add references for new resources, nothing happens if they are already present
	for res_id in new_resource_ids:
		Gamedata.mods.add_reference(DMod.ContentType.ITEMS, res_id, DMod.ContentType.ITEMS, id)
	update_item_skill_references(olddata)
	update_item_stat_references(olddata)
	update_item_attribute_references(olddata)
	
	parent.save_items_to_disk()


# Function to process player attributes in the wearable and update references accordingly
func process_wearable_player_attributes(olddata: DItem):
	if not wearable:
		# If there's no wearable in the new data but the olddata wearable has attributes, remove their references
		if olddata.wearable and not olddata.wearable.player_attributes.is_empty():
			# Loop over old player attributes and remove references
			for old_attr in olddata.wearable.player_attributes:
				Gamedata.mods.remove_reference(DMod.ContentType.PLAYERATTRIBUTES, old_attr["id"], DMod.ContentType.ITEMS, id)
		return	# Exit since there's no wearable in the new data
	
	if wearable.player_attributes.is_empty():
		# If the new wearable has no player attributes, remove all references from olddata if they exist
		if olddata.wearable and not olddata.wearable.player_attributes.is_empty():
			for old_attr in olddata.wearable.player_attributes:
				Gamedata.mods.remove_reference(DMod.ContentType.PLAYERATTRIBUTES, old_attr["id"], DMod.ContentType.ITEMS, id)
		return	# Exit since there are no player attributes to add

	# Collect new and old player attributes
	var new_player_attributes = wearable.player_attributes
	var old_player_attributes = olddata.wearable.player_attributes if olddata.wearable else []

	# Dictionary to track old attribute ids for easy lookup
	var old_attr_dict: Dictionary = {}
	for old_attr in old_player_attributes:
		old_attr_dict[old_attr["id"]] = old_attr

	# Loop over new attributes and add references
	for new_attr in new_player_attributes:
		var attribute_id = new_attr["id"]
		# Add reference for the new attribute
		Gamedata.mods.add_reference(DMod.ContentType.PLAYERATTRIBUTES, attribute_id, DMod.ContentType.ITEMS, id)

		# Remove the old attribute from the dictionary, as it still exists
		old_attr_dict.erase(attribute_id)

	# Any remaining attributes in old_attr_dict were removed, so remove their references
	for old_attr_id in old_attr_dict.keys():
		Gamedata.mods.remove_reference(DMod.ContentType.PLAYERATTRIBUTES, old_attr_id, DMod.ContentType.ITEMS, id)


# Collects all skills defined in an item and updates the references to that skill
func update_item_skill_references(olddata: DItem):
	# Function to collect skill IDs from a list of used skills
	var collect_skill_ids: Callable = func (item: DItem):
		var skill_ids = []
		if item.craft:
			skill_ids += item.craft.get_used_skill_ids()
		if item.ranged:
			skill_ids += item.ranged.get_used_skill_ids()
		if item.melee:
			skill_ids += item.melee.get_used_skill_ids()
		return skill_ids

	# Collect skill IDs from old and new data
	var old_skill_ids = collect_skill_ids.call(olddata)
	var new_skill_ids = collect_skill_ids.call(self)

	# Remove old skill references that are not in the new list
	for old_skill_id in old_skill_ids:
		if not new_skill_ids.has(old_skill_id):
			Gamedata.mods.remove_reference(DMod.ContentType.SKILLS, old_skill_id, DMod.ContentType.ITEMS, id)
	
	# Add new skill references
	for new_skill_id in new_skill_ids:
		Gamedata.mods.add_reference(DMod.ContentType.SKILLS, new_skill_id, DMod.ContentType.ITEMS, id)

# Updates references between this item’s accuracy & damage stats and the stat entities
func update_item_stat_references(olddata: DItem) -> void:
	# 1) Collect old stats
	var old_stats: Array[String] = []
	if olddata.ranged and olddata.ranged.accuracy_stat != "":
		old_stats.append(olddata.ranged.accuracy_stat)
	if olddata.melee:
		old_stats.append(olddata.melee.damage_stat)
		old_stats.append(olddata.melee.accuracy_stat)

	# 2) Clean out empty and dedupe
	old_stats = old_stats.filter(func(id): return id != "")
	old_stats = _dedupe_array(old_stats)

	# 3) Collect new stats (from this item's current data)
	var new_stats: Array[String] = []
	if ranged and ranged.accuracy_stat != "":
		new_stats.append(ranged.accuracy_stat)
	if melee:
		new_stats.append(melee.damage_stat)
		new_stats.append(melee.accuracy_stat)

	# 4) Clean out empty and dedupe
	new_stats = new_stats.filter(func(id): return id != "")
	new_stats = _dedupe_array(new_stats)

	# 5) Remove references for stats we no longer use
	for stat_id in old_stats:
		if not new_stats.has(stat_id):
			Gamedata.mods.remove_reference(
				DMod.ContentType.STATS, stat_id,
				DMod.ContentType.ITEMS, id
			)

	# 6) Add references for newly used stats
	for stat_id in new_stats:
		Gamedata.mods.add_reference(
			DMod.ContentType.STATS, stat_id,
			DMod.ContentType.ITEMS, id
		)

# Helper to remove duplicates while preserving order
func _dedupe_array(arr: Array[String]) -> Array[String]:
	var seen := {}
	var result: Array[String] = []
	for element in arr:
		if not seen.has(element):
			seen[element] = true
			result.append(element)
	return result


# Collects all attributes defined in an item and updates the references to that attribute
func update_item_attribute_references(olddata: DItem):
	# Collect all attribute IDs from old and new data (food and medical)
	var old_attr_ids = []
	var new_attr_ids = []

	if olddata.food:
		old_attr_ids.append_array(olddata.food.get_attr_ids())
	if olddata.medical:
		old_attr_ids.append_array(olddata.medical.get_attr_ids())

	if food:
		new_attr_ids.append_array(food.get_attr_ids())
	if medical:
		new_attr_ids.append_array(medical.get_attr_ids())

	# Remove old attribute references that are not in the new list
	for old_attr_id in old_attr_ids:
		if not new_attr_ids.has(old_attr_id):
			Gamedata.mods.remove_reference(DMod.ContentType.PLAYERATTRIBUTES, old_attr_id, DMod.ContentType.ITEMS, id)
	
	# Add new attribute references
	for new_attr_id in new_attr_ids:
		Gamedata.mods.add_reference(DMod.ContentType.PLAYERATTRIBUTES, new_attr_id, DMod.ContentType.ITEMS, id)


# An item is being deleted from the data
# We have to remove it from everything that references it
func delete():
	# Check to see if any mod has a copy of this item. if one or more remain, we can keep references
	# Otherwise, the last copy was removed and we need to remove references
	var all_results: Array = Gamedata.mods.get_all_content_by_id(DMod.ContentType.ITEMS, id)
	if all_results.size() > 1:
		parent.remove_reference(id) # Erase the reference for the id in this mod
		return
		
	# For each mod, remove this item from the itemgroup in this item's references
	for mod: DMod in (Gamedata.mods.get_all_mods() as Array[DMod]):
		mod.itemgroups.remove_item_from_all_itemgroups(id)
		mod.items.remove_item_from_all_recipes(id)
		mod.quests.remove_item_from_all_quests(id)
		mod.furnitures.remove_item_from_all_furniture(id)
		mod.wearableslots.remove_item_from_all_wearableslot(id)
	
	if food and not food.attributes.is_empty():
		for food_attribute in food.attributes:
			Gamedata.mods.remove_reference(DMod.ContentType.PLAYERATTRIBUTES, food_attribute["id"], DMod.ContentType.ITEMS, id)
			
	if medical and not medical.attributes.is_empty():
		for medical_attribute in medical.attributes:
			Gamedata.mods.remove_reference(DMod.ContentType.PLAYERATTRIBUTES, medical_attribute["id"], DMod.ContentType.ITEMS, id)
			
	if wearable and not wearable.player_attributes.is_empty():
		for wearableattr in wearable.player_attributes:
			Gamedata.mods.remove_reference(DMod.ContentType.PLAYERATTRIBUTES, wearableattr["id"], DMod.ContentType.ITEMS, id)
			
	var skill_ids: Dictionary = {}
	# Check if 'craft' is not null before proceeding
	if craft:
		# For each recipe and for each item in each recipe, remove the reference to this item
		for resource in craft.get_all_used_items():
			Gamedata.mods.remove_reference(DMod.ContentType.ITEMS, resource, DMod.ContentType.ITEMS, id)

		# Collect unique skill IDs from the item's recipes
		for skillid in craft.get_used_skill_ids():
			skill_ids[skillid] = true

	# Add the ranged skill to the skill list
	if ranged and ranged.used_skill:
		skill_ids[ranged.used_skill.skill_id] = true

	# Add the melee skill to the skill list
	if melee and melee.used_skill:
		skill_ids[melee.used_skill.skill_id] = true

# Remove the reference of this item from each skill
	for skill_id in skill_ids.keys():
		Gamedata.mods.remove_reference(DMod.ContentType.SKILLS, skill_id, DMod.ContentType.ITEMS, id)

	if ranged and ranged.accuracy_stat != "":
		Gamedata.mods.remove_reference(DMod.ContentType.STATS, ranged.accuracy_stat, DMod.ContentType.ITEMS, id)
	if melee and melee.damage_stat != "":
		Gamedata.mods.remove_reference(DMod.ContentType.STATS, melee.damage_stat, DMod.ContentType.ITEMS, id)


# Function to remove all instances of a skill from the item
func remove_skill(skill_id: String) -> bool:
	var changes_made = false
	if craft and craft.remove_skill_from_recipes(skill_id):
		changes_made = true
	if ranged and ranged.remove_skill(skill_id):
		changes_made = true
	if melee and melee.remove_skill(skill_id):
		changes_made = true
	return changes_made


# Function to remove all instances of a playerattribute from the item
func remove_playerattribute(playerattribute_id: String):
	if wearable and not wearable.player_attributes.is_empty():
		wearable.remove_player_attribute(playerattribute_id)
	if food and not food.attributes.is_empty():
		food.remove_player_attribute(playerattribute_id)
	if medical and not medical.attributes.is_empty():
		medical.remove_player_attribute(playerattribute_id)


# Function to remove all instances of a wearableslot_id from the item
func remove_wearableslot(wearableslot_id: String):
	if wearable and wearable.slot == wearableslot_id:
		wearable = null

# Function to check if the item is craftable
func is_craftable() -> bool:
	# Check if the craft property is not null and has at least one recipe
	return craft != null and craft.recipes.size() > 0
