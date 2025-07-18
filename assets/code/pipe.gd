extends Node2D

const START_X      := 1000       # Starting X position (off-screen right)
const END_X        := 0          # When pipes go off-screen left
const SPEED        := 500        # Speed of movement
const PAIR_SPACING := 500        # Distance between pipe pairs

var pipe_pairs = []
var base_y_positions = {}

func _ready():
	pipe_pairs = [
		[get_node("pipe1"), get_node("pipe5")],
		[get_node("pipe2"), get_node("pipe6")],
		[get_node("pipe3"), get_node("pipe7")],
		[get_node("pipe4"), get_node("pipe8")]
	]

	# Store base Y positions
	for pair in pipe_pairs:
		for pipe in pair:
			base_y_positions[pipe] = pipe.position.y

	# Set starting positions
	for i in range(pipe_pairs.size()):
		var pair = pipe_pairs[i]
		var start_x = START_X + i * PAIR_SPACING

		var offset_y = randf_range(-500, 500)

		for pipe in pair:
			pipe.position.x = start_x
			pipe.position.y = base_y_positions[pipe] + offset_y

func _process(delta):
	for pair in pipe_pairs:
		var x = pair[0].position.x - SPEED * delta

		if x <= END_X:
			x += PAIR_SPACING * pipe_pairs.size()

			var offset_y = randf_range(-500, 500)
			for pipe in pair:
				pipe.position.y = base_y_positions[pipe] + offset_y

		for pipe in pair:
			pipe.position.x = x
