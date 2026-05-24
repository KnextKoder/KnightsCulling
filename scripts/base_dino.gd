extends Node2D

const SPEED = 60
var direction = 1
var is_idling = false
var damage_allowance = 1
var is_hurt = false

@onready var base_dino_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var idle_timer: Timer = $IdleTimer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_idling:
		return
# Check for floor
	#if not ray_cast_down.is_colliding():
		#var new_dir = -direction
		#var should_flip = (new_dir == -1)
		#start_idle(new_dir, should_flip)
# Check for objects
	if ray_cast_right.is_colliding() and direction == 1:
		start_idle(-1, true)
	elif ray_cast_left.is_colliding() and direction == -1:
		start_idle(1, false)
	else:
		base_dino_sprite.play("move")
		position.x += direction * SPEED * delta

func start_idle(new_direction, flip):
	is_idling = true
	base_dino_sprite.play("idle")
	
	direction = new_direction
	base_dino_sprite.flip_h = flip
	
	idle_timer.start(0.5)

func take_damage():
	# 1. If he's already hurt, don't let him take damage again yet
	if is_hurt: 
		print("Dino is currently invincible, ignoring hit")
		return 
	
	damage_allowance -= 1
	print("HIT! Damage Allowance left: ", damage_allowance)
	
	if damage_allowance <= 0:
		GameManager.dino_killed()
		queue_free()
	else:
		_trigger_hurt_state()

func _trigger_hurt_state():
	is_hurt = true
	modulate = Color(10, 1, 1) # Turn red
	
	# Instead of a simple await, let's use a SceneTreeTimer 
	# that doesn't care if other logic is running
	await get_tree().create_timer(0.5).timeout
	
	is_hurt = false
	modulate = Color(1, 1, 1) # Back to normal
	print("Dino can be hit again now")

func _on_idle_timer_timeout() -> void:
	is_idling = false
