extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const DOUBLE_JUMP_VELOCITY = -250.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


var jump_count = 0
func _physics_process(delta: float) -> void:
# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		# 2. Reset the counter when we touch the ground
		jump_count = 0

# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			# First jump from the ground
			velocity.y = JUMP_VELOCITY
			jump_count = 1
		elif jump_count < 2:
			# 3. Second jump in the air
			velocity.y = DOUBLE_JUMP_VELOCITY
			jump_count = 2 # This prevents a third jump

# Get the input direction and handle the movement/deceleration.
# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")

# Flip player character
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true


# 	Apply Movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
