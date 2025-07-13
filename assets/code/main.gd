extends Node2D

var is_paused := false

@onready var shader = $"ui/shader"
@onready var pauses = $"ui/pause"

func _ready():
	pauses.pressed.connect(toggle_pause)
	shader.hide()

func _process(delta):
	if is_paused == false:
		shader.hide()

func toggle_pause():
	is_paused = !is_paused
	shader.show()
	
	for node in get_tree().get_nodes_in_group("pause"):
		node.set_process(!is_paused)
		node.set_physics_process(!is_paused)

		if node.has_method("pause_enemy"):
			node.pause_enemy(is_paused)

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		toggle_pause()
