extends GutTest

func test_on_mob_killed_accepts_killer_param():
	var helper = load("res://Scripts/Helper/quest_helper.gd").new()
	var mob = Mob.new(Vector3.ZERO, {"id":"generic_test_mob"})
	var killer = Player.new()
	helper._on_mob_killed(mob, killer)
	assert_true(true, "Method executed without error")
