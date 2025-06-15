extends Node2D  # Attach this to your "pipemaster" node

const START_X      := 1300       # Starting X position (off-screen right)
const END_X        := -500       # When pipes go off-screen left
const SPEED        := 400        # Speed of movement
const PAIR_SPACING := 500        # Distance between pipe pairs

var pipe_pairs = []

func _ready():
	pipe_pairs = [
		[get_node("pipe1"), get_node("pipe5")],
		[get_node("pipe2"), get_node("pipe6")],
		[get_node("pipe3"), get_node("pipe7")],
		[get_node("pipe4"), get_node("pipe8")]
	]

	# Set starting positions for each pair
	for i in range(pipe_pairs.size()):
		var pair = pipe_pairs[i]
		var start_x = START_X + i * PAIR_SPACING

		# Add random offset
		var offset_y = randf_range(-250, 250)

		for pipe in pair:
			pipe.position.x = start_x
			pipe.position.y += offset_y

func _process(delta):
	for pair in pipe_pairs:
		var x = pair[0].position.x - SPEED * delta

		if x <= END_X:
			x += PAIR_SPACING * pipe_pairs.size()  # wrap around

			# Random vertical offset between -250 and +250
			var offset_y = randf_range(-250, 250)
			for pipe in pair:
				pipe.position.y += offset_y

		# Apply same new X position
		for pipe in pair:
			pipe.position.x = x
