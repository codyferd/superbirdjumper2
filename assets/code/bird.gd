extends Sprite2D

const GRAVITY = 600.0
const JUMP_VELOCITY = -250.0

var velocity = Vector2.ZERO
var screen_height = 0

func _ready():
	screen_height = get_viewport_rect().size.y

func _process(delta):
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

func die():
	get_tree().reload_current_scene()
