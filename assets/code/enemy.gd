extends Sprite2D

var y_tween: Tween
var x_tween: Tween

# Y range
@export var y_min := 200
@export var y_max := 800

func _ready():
	start_x_loop()
	do_random_y_tween()

func start_x_loop():
	x_tween = create_tween()
	x_tween.set_loops()
	x_tween.tween_property(self, "position:x", 1250, 5.0)
	x_tween.tween_property(self, "position:x", 250, 5.0)

func do_random_y_tween():
	# Pick a new Y target
	var new_y = randf_range(y_min, y_max)
	y_tween = create_tween()
	y_tween.tween_property(self, "position:y", new_y, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	y_tween.tween_callback(Callable(self, "do_random_y_tween"))

func push_down(amount: float = 1000):
	if y_tween:
		y_tween.kill()
