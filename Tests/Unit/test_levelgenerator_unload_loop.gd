extends GutTest

# This test will test the LevelGenerator.gd script

# Preload the LevelGenerator script so we can instantiate it in tests
const LevelGenerator = preload("res://LevelGenerator.gd")

# A lightweight stub to stand in for real Chunk nodes during tests
class StubChunk:
	extends Node3D

	# Mimic the LoadStates enum from the real Chunk
	enum LoadStates { NEITHER, LOADING, UNLOADING }

	# Current load state (starts as neither)
	var load_state: LoadStates = LoadStates.NEITHER

	# The chunk's position in world space
	var mypos: Vector3

	# Simulate the chunk unloading process
	func unload_chunk():
		# Mark as unloading
		load_state = LoadStates.UNLOADING
		# Then remove ourselves from the scene
		queue_free()


# The LevelGenerator under test
var generator: LevelGenerator

# Called before each test runs
func before_each():
	# Create a fresh LevelGenerator instance
	generator = LevelGenerator.new()
	# Add it to the scene tree so it can emit signals, process, etc.
	add_child(generator)

# Called after each test completes
func after_each():
	# Clean up the generator instance if it still exists
	if generator:
		generator.queue_free()

# Test that handle_chunk_unload iterates over loaded_chunks, calls unload_chunk(),
# waits for all to free themselves, then emits all_chunks_unloaded and clears the map.
func test_handle_chunk_unload_uses_loop():
	var count = 25  # number of chunks to simulate

	# 1) Populate generator.loaded_chunks with our stubs
	for i in range(count):
		var chunk = StubChunk.new()
		# Position each stub at a distinct x-offset
		chunk.mypos = Vector3(i * generator.level_width, 0, 0)
		# Insert into the generator's map keyed by chunk grid coordinates
		generator.loaded_chunks[Vector2(i, 0)] = chunk
		# Add to scene to allow queue_free() to work
		add_child(chunk)
		# The generator may look for nodes in the "chunks" group
		chunk.add_to_group("chunks")

	# 2) Listen for the completion signal
	var done: Dictionary = {"sent": false}
	generator.all_chunks_unloaded.connect(func(): done.sent = true)

	# 3) Invoke the unload routine (it's async/yieldable)
	await generator.handle_chunk_unload()

	# 4) Verify the completion signal fired
	assert_true(done.sent, "all_chunks_unloaded should emit")

	# 5) Ensure the internal map was cleared
	assert_eq(generator.loaded_chunks.size(), 0, "Loaded chunks should be empty")
