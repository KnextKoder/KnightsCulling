extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const DOUBLE_JUMP_VELOCITY = -250.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword_hitbox: CollisionShape2D = $SwordArea/CollisionShape2D
@onready var sword_area: Area2D = $SwordArea
@onready var slash_sprite: AnimatedSprite2D = $SwordArea/SlashSprite


var jump_count = 0
var is_dead = false
var is_attacking = false


func _physics_process(delta: float) -> void:
	if is_dead:
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return

# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		# 2. Reset the counter when we touch the ground
		jump_count = 0

# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			# First jump from the ground
			velocity.y = JUMP_VELOCITY
			jump_count = 1
		elif jump_count < 2:
			# 3. Second jump in the air
			velocity.y = DOUBLE_JUMP_VELOCITY
			jump_count = 2 # This prevents a third jump

# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")

# Handle Attack
	if Input.is_action_just_pressed("attack") and not is_dead and not is_attacking:
		if GameManager.spend_coin():
			is_attacking = true
			sword_hitbox.disabled = false
			
			# 1. Play the Knight's physical swing and play the sword slash effect
			animated_sprite.play("attack")
			slash_sprite.show()
			slash_sprite.play("slash")

			await get_tree().physics_frame
	
			var areas = sword_area.get_overlapping_areas()

			for area in areas:
				if area.name == "HurtBox":
					var dino = area.get_parent()
					if dino.has_method("take_damage"):
						dino.take_damage()
			
			# 2. WAIT for the swing to finish
			await get_tree().create_timer(0.3).timeout
			
			# 3. Clean up
			slash_sprite.hide()
			sword_hitbox.disabled = true
			is_attacking = false
		else:
			print("Not enough coins to attack!")

# Flip player character
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	if animated_sprite.flip_h:
		sword_area.scale.x = -1 # Face Left
	else:
		sword_area.scale.x = 1  # Face Right

# 	Play Animations
	if not is_attacking:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			elif direction > 0 or direction < 0:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")

# 	Apply Movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
