extends Node2D

const GRAVITY = 500.0
const JUMP_VELOCITY = -250.0

var velocity = Vector2.ZERO
var screen_height = 0
var is_dead = false

@onready var audio_player = $audio
@onready var game_over_ui = $"../game_over"  # Adjust path if needed
@onready var bird_node = $"../bird"  # Adjust path if needed
@onready var enemy_node = $"../enemy"
@onready var background_node = $"../background"  # Adjust path if needed
@onready var pipe_node = $"../pipemaster"

func _ready():
	screen_height = get_viewport_rect().size.y
	audio_player.play()

	# Start with GameOver UI hidden and off-screen
	game_over_ui.position.y = -500
	game_over_ui.visible = false

func _process(delta):
	if is_dead:
		return  # No movement if dead

	# Apply gravity
	velocity.y += GRAVITY * delta

	# Jump (W, A, D)
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_D):
		velocity.y = JUMP_VELOCITY

	# Anti-jump (S = fall faster)
	if Input.is_key_pressed(KEY_S):
		velocity.y += GRAVITY * delta * 2

	# Move the sprite
	position.y += velocity.y * delta

	# Death check
	if position.y < 0 or position.y > screen_height:
		die()
		
	var dist_x = abs(self.position.x - enemy_node.position.x)
	var dist_y = abs(self.position.y - enemy_node.position.y)

	if dist_x <= 50 and dist_y <= 50:
		die()

func die():
	if is_dead:
		return  # Prevent multiple calls

	is_dead = true
	game_over_ui.visible = true

	var push_down_amount = 1080  # Pixels to push gameplay elements down
	var target_ui_y = 100       # Final Y position of game_over_ui to slide it into view
	enemy_node.push_down(push_down_amount)
	
	# Create a fresh tween
	var tween = create_tween()
	
	tween.tween_property(enemy_node, "position", enemy_node.position + Vector2(0, push_down_amount), 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(pipe_node, "position", pipe_node.position + Vector2(0, push_down_amount), 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(bird_node, "position", bird_node.position + Vector2(0, push_down_amount), 0.01).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(background_node, "position", background_node.position + Vector2(0, push_down_amount), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Tween game_over_ui down from -500 to visible position
	tween.tween_property(game_over_ui, "position", Vector2(game_over_ui.position.x, target_ui_y), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
