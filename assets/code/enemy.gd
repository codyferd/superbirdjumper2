extends Sprite2D

var tween = create_tween()

func _ready():
	# Start looping tween up and down
	tween.tween_property(self, "position:y", 800, 2.0)
	tween.tween_property(self, "position:y", 200, 2.0)
	tween.set_loops()

func push_down(amount: float = 100):
	# Stop the existing looping tween so it doesn't override
	if tween.is_valid():
		tween.kill()

	# Create a new tween to push down and keep it there
	var push_tween = create_tween()
	push_tween.tween_property(self, "position", position + Vector2(0, amount), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
