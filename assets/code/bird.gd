extends Sprite2D

const GRAVITY = 1000.0
const JUMP_VELOCITY = -500.0

var velocity = Vector2.ZERO
var is_dead = false

@onready var audio_player = $audio
@onready var start = $"/root/main/start"
@onready var enemy = $"../enemy"
@onready var background = $"/root/main/background"
@onready var pipemaster = $"../pipe"
@onready var score = $"/root/main/ui/score"
@onready var high = $"/root/main/start/high_score"
@onready var sprite = $"/root/main/game"

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

	# --- Keyboard Input ---
	if Input.is_key_pressed(KEY_E):
		velocity.y = JUMP_VELOCITY * 4
	elif Input.is_key_pressed(KEY_Q):
		velocity.y += GRAVITY * delta * 4
	elif Input.is_key_pressed(KEY_A):
		velocity.y = JUMP_VELOCITY * 0.03
	elif Input.is_key_pressed(KEY_W):
		velocity.y = JUMP_VELOCITY
	elif Input.is_key_pressed(KEY_D):
		velocity.y = JUMP_VELOCITY * 2
	elif Input.is_key_pressed(KEY_S):
		velocity.y += GRAVITY * delta * 2

	# Death by screen bounds
	if position.y < 0 or position.y > 1000:
		die()

	# Death by enemy
	var dist_x = abs(self.position.x - enemy.position.x)
	var dist_y = abs(self.position.y - enemy.position.y)
	if dist_x <= 50 and dist_y <= 50:
		die()

	# Death by touching any pipe
	if is_touching_pipe():
		die()

func is_touching_pipe() -> bool:
	for pipe in pipemaster.get_children():
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
	score.visible = true

	var push_down_amount = 10000
	var target_ui_y = 0
	score.frozen = true
	high.frozen = true
	enemy.push_down(push_down_amount)

	var tween = create_tween()
	var nodes_to_move = [enemy, pipemaster, self, background]
	for node in nodes_to_move:
		tween.tween_property(node, "position", node.position + Vector2(0, push_down_amount), 0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.tween_property(start, "position", Vector2(start.position.x, target_ui_y), 0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
