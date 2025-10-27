extends GutTest


func test_update_recipe_buttons_adds_buttons():
	var menu := preload("res://Scripts/CraftingMenu.gd").new()
	menu.recipeVBoxContainer = VBoxContainer.new()
	add_child(menu.recipeVBoxContainer)

	var recipes := [{}, {}, {}]
	menu._update_recipe_buttons(recipes)
	assert_eq(
		menu.recipeVBoxContainer.get_child_count(),
		recipes.size(),
		"Should create one button per recipe"
	)
