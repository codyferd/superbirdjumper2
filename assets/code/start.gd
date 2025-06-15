extends Control

@onready var start_btn = $start_btn
@onready var quit_btn = $quit_btn

func _ready():
	start_btn.pressed.connect(start_game)
	quit_btn.pressed.connect(quit_game)

func _process(delta):
	if Input.is_key_pressed(KEY_Q):
		start_btn.emit_signal("pressed")  # Simulate button press
	if Input.is_key_pressed(KEY_E):
		quit_btn.emit_signal("pressed")

func start_game():
	get_tree().set_meta("from_restart", true)  # Set a global flag (only for this session)
	get_tree().reload_current_scene()

func quit_game():
	get_tree().quit()
