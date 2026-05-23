extends Node2D

const SPEED = 60
var direction = 1
var is_idling = false

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
	GameManager.dino_killed()
	queue_free() # For now, the dino just disappears instantly

func _on_idle_timer_timeout() -> void:
	is_idling = false
