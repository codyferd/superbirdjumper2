extends Sprite2D

func _ready():
	for pipe in get_children():
		if pipe is Sprite2D:
			if pipe.name == "pipe1" or pipe.name == "pipe4":
				var tweens = create_tween()
				tweens.set_loops()
				tweens.tween_property(pipe, "position:x", 1300, 0)
				tweens.tween_property(pipe, "position:x", -500, 3.0)
			elif pipe.name == "pipe2" or pipe.name == "pipe3":
				pipe.set_meta("repeat_count", 0)
				move_pipe_with_repeats(pipe)
			elif pipe.name == "pipe5" or pipe.name == "pipe6":
				pipe.set_meta("repeat_count", 0)
				move_pipe(pipe)

func move_pipe_with_repeats(pipe: Node2D):
	var count = pipe.get_meta("repeat_count")
	if count < 1:
		pipe.set_meta("repeat_count", count + 1)
		var tween = create_tween()
		tween.tween_property(pipe, "position:x", 1300, 0)
		tween.tween_property(pipe, "position:x", -500, 5.0)
		tween.tween_callback(Callable(func(): move_pipe_with_repeats(pipe)))
	else:
		var tween = create_tween()
		tween.tween_property(pipe, "position:x", 1300, 0)
		tween.tween_property(pipe, "position:x", -500, 3.0)
		tween.set_loops()

func move_pipe(pipe: Node2D):
	var count = pipe.get_meta("repeat_count")
	if count < 1:
		pipe.set_meta("repeat_count", count + 1)
		var tween = create_tween()
		tween.tween_property(pipe, "position:x", 1300, 0)
		tween.tween_property(pipe, "position:x", -500, 7.0)
		tween.tween_callback(Callable(func(): move_pipe_with_repeats(pipe)))
	else:
		var tween = create_tween()
		tween.tween_property(pipe, "position:x", 1300, 0)
		tween.tween_property(pipe, "position:x", -500, 3.0)
		tween.set_loops()
