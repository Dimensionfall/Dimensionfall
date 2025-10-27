extends GutTest

var player: Player

func before_all():
	var custom_mods: Array[DMod] = [Gamedata.mods.by_id("Core"), Gamedata.mods.by_id("Test")]
	Runtimedata.reconstruct(custom_mods)
	await get_tree().process_frame

func before_each():
	const PLAYER_SCENE = preload("res://Scenes/player.tscn")
	player = PLAYER_SCENE.instantiate()
	player.testing = true
	add_child(player)
	await get_tree().process_frame

func after_each():
	if player:
		player.queue_free()

func after_all():
	Runtimedata.reset()

func _create_recipe(level: int, bonus_stat: String = "") -> RItem.CraftRecipe:
	var data := {
		"skill_requirement": {"id": "fabrication", "level": level},
		"skill_bonus_stat": bonus_stat
	}
	return RItem.CraftRecipe.new(data)

func test_has_required_skill_without_bonus_stat():
	player.skills["fabrication"] = {"level": 2, "xp": 0}
	player.set_stat("strength", 5)
	var recipe := _create_recipe(5)
	assert_false(CraftingRecipesManager.has_required_skill(recipe), "Crafting should fail without bonus stat")

func test_has_required_skill_with_bonus_stat():
	player.skills["fabrication"] = {"level": 2, "xp": 0}
	player.set_stat("strength", 5)
	var recipe := _create_recipe(5, "strength")
	assert_true(CraftingRecipesManager.has_required_skill(recipe), "Crafting should succeed with bonus stat")
