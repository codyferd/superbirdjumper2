extends Control

func _ready():
	$restart.pressed.connect(restart_game)
	$quit.pressed.connect(quit_game)

func restart_game():
	get_tree().reload_current_scene()

func quit_game():
	get_tree().quit()
