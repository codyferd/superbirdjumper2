extends Control

func _ready():
	$restart.pressed.connect(restart_game)
	$quit.pressed.connect(quit_game)
	if Input.is_key_pressed(KEY_S):
		quit_game()
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_D):
		restart_game()

func restart_game():
	get_tree().reload_current_scene()

func quit_game():
	get_tree().quit()
