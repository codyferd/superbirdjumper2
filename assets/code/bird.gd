extends Node2D

const GRAVITY = 1000.0
const JUMP_VELOCITY = -500.0

var velocity = Vector2.ZERO
var is_dead = false

@onready var audio_player = $audio
@onready var start = $"../start"
@onready var enemy_node = $"../enemy"
@onready var background_node = $"../background"
@onready var pipe_node = $"../pipemaster"
@onready var score_node = $"../label/score"
@onready var high_node = $"../start/high_score"

func _ready():
	if not get_tree().has_meta("from_restart") or get_tree().get_meta("from_restart") == false:
		call_deferred("die") # First time: trigger game over
	else:
		get_tree().set_meta("from_restart", false)  # Clear the flag after use

	audio_player.play()
	start.position.y = -500
	start.visible = false

func _process(delta):
	if is_dead:
		return

	velocity.y += GRAVITY * delta
	position.y += velocity.y * delta
	
	var keys_pressed = 0

	# --- Keyboard Input ---
	if Input.is_key_pressed(KEY_A):
		velocity.y = JUMP_VELOCITY * 0.1
	elif Input.is_key_pressed(KEY_W):
		velocity.y = JUMP_VELOCITY
	elif Input.is_key_pressed(KEY_D):
		velocity.y = JUMP_VELOCITY * 2
	elif Input.is_key_pressed(KEY_S):
		velocity.y += GRAVITY * delta * 2

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
	start.visible = true
	score_node.visible = true

	var push_down_amount = 10000
	var target_ui_y = 0
	score_node.frozen = true
	high_node.frozen = true
	enemy_node.push_down(push_down_amount)

	var tween = create_tween()
	var nodes_to_move = [enemy_node, pipe_node, self, background_node]
	for node in nodes_to_move:
		tween.tween_property(node, "position", node.position + Vector2(0, push_down_amount), 0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.tween_property(start, "position", Vector2(start.position.x, target_ui_y), 0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
