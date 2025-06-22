extends Node2D

const GRAVITY = 750.0
const JUMP_VELOCITY = -350.0
signal died

var alive = false
var velocity = Vector2.ZERO
var screen_height = 0
var is_dead = false

@onready var audio_player = $audio
@onready var start = $"../start"
@onready var bird_node = self
@onready var enemy_node = $"../enemy"
@onready var background_node = $"../background"
@onready var pipe_node = $"../pipemaster"
@onready var score_node = $"../label/score"

func _ready():
	if not get_tree().has_meta("from_restart") or get_tree().get_meta("from_restart") == false:
		call_deferred("die") # First time: trigger game over
	else:
		get_tree().set_meta("from_restart", false)  # Clear the flag after use

	screen_height = get_viewport_rect().size.y
	audio_player.play()
	start.position.y = -500
	start.visible = false

func _process(delta):
	if is_dead:
		return

	velocity.y += GRAVITY * delta

	var keys_pressed = 0

	if Input.is_key_pressed(KEY_W):
		keys_pressed = 1
	if Input.is_key_pressed(KEY_A):
		keys_pressed = 0.01
	if Input.is_key_pressed(KEY_D):
		keys_pressed = 2

	if keys_pressed > 0:
		velocity.y = JUMP_VELOCITY * keys_pressed

	if Input.is_key_pressed(KEY_S):
		velocity.y += GRAVITY * delta * 3

	position.y += velocity.y * delta

	# Death by screen bounds
	if position.y < 0 or position.y > 1080:
		die()

	# Death by enemy
	var dist_x = abs(self.position.x - enemy_node.position.x)
	var dist_y = abs(self.position.y - enemy_node.position.y)
	if dist_x <= 50 and dist_y <= 50:
		die()

	# Death by touching any pipe
	if is_touching_pipe():
		die()

func is_touching_pipe() -> bool:
	for pipe in pipe_node.get_children():
		if pipe is Sprite2D and pipe.texture:
			var pipe_rect = Rect2(
				pipe.global_position - (pipe.texture.get_size() * 0.5 * pipe.scale),
				pipe.texture.get_size() * pipe.scale
			)
			var bird_rect = Rect2(
				global_position - (self.texture.get_size() * 0.5 * scale),
				self.texture.get_size() * scale
			)
			if bird_rect.intersects(pipe_rect):
				return true
	return false

func die():
	
	if is_dead:
		return
	
	is_dead = true
	emit_signal("died")
	start.visible = true
	score_node.visible = false

	var push_down_amount = 10000
	var target_ui_y = 100
	enemy_node.push_down(push_down_amount)

	var tween = create_tween()
	tween.tween_property(enemy_node, "position", enemy_node.position + Vector2(0, push_down_amount), 0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(pipe_node, "position", pipe_node.position + Vector2(0, push_down_amount), 0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(bird_node, "position", bird_node.position + Vector2(0, push_down_amount), 0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(background_node, "position", background_node.position + Vector2(0, push_down_amount), 0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(start, "position", Vector2(start.position.x, target_ui_y), 0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
