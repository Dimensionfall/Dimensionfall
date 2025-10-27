extends GutTest

func before_all():
	var custom_mods: Array[DMod] = [Gamedata.mods.by_id("Core"), Gamedata.mods.by_id("Dimensionfall")]
	Runtimedata.reconstruct(custom_mods)
	await get_tree().process_frame

func after_all():
	Runtimedata.reset()

func test_hank_loads() -> void:
	var dnpcs: DNpcs = Gamedata.mods.by_id("Dimensionfall").npcs
	assert_true(dnpcs.has_id("hank"), "Hank NPC missing")
	var hank: DNpc = dnpcs.by_id("hank")
	assert_eq(hank.name, "Hank", "Name mismatch")
	assert_eq(hank.health, 100, "Health mismatch")
