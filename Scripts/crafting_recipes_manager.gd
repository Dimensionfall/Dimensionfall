extends Node

# This is a Global autoload script that can be accessed from anywhere

# Items that have the "craft" property and can be crafted
var craftable_items: Array[RItem]


# Called when the node enters the scene tree for the first time.
func _ready():
	Helper.signal_broker.game_started.connect(get_crafting_recipes_from_json)
	Helper.signal_broker.game_loaded.connect(get_crafting_recipes_from_json)

func get_crafting_recipes_from_json() -> void:
	craftable_items = Runtimedata.items.get_hand_craftable_items()


# Function to check if there are enough resources in the inventory to craft a given recipe.
func can_craft_recipe(recipe: RItem.CraftRecipe) -> bool:
	# Loop through each resource required by the recipe.
	for resource in recipe.required_resources:
		# Check if the inventory has a sufficient amount of each required resource.
		if not ItemManager.has_sufficient_item_amount(resource.get("id"), resource.get("amount")):
			return false  # Return false immediately if any resource is insufficient.
	
	# If all checks are passed, return true indicating that crafting can proceed.
	return true


# Function to check if the player meets the skill requirement for a given dictionary
func has_required_skill(recipe: RItem.CraftRecipe) -> bool:
	# Check if "skill_requirement" exists in the provided dictionary
	if recipe.skill_requirement:
		var skill_req = recipe.skill_requirement
		var skill_id = skill_req.get("id", "")
		var required_level = skill_req.get("level", 0)
		var player = get_tree().get_first_node_in_group("Players")
		
		# Check if the player has the required skill and level, taking
		# intelligence stat into account as a bonus
		if player and player.skills.has(skill_id):
			var player_skill_level = player.skills[skill_id]
			var intelligence_bonus = 0
			if player.has_method("get_stat"):
				intelligence_bonus = player.get_stat("intelligence")
			if player_skill_level["level"] + intelligence_bonus >= required_level:
				return true
	else:
		return true
		
	# If the requirement is not met or the skill doesn't exist, return false
	return false
