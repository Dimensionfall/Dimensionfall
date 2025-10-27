extends GutTest


class TestState:
	extends State

	func enter():
		Transitioned.emit(self, "next")


func test_transitioned_signal_fires():
	var state = TestState.new()
	add_child(state)
	state.call_deferred("enter")
	assert_true(await wait_for_signal(state.Transitioned, 1), "Transitioned signal did not fire")
