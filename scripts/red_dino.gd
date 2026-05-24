extends CharacterBody2D

const SPEED = 60
const CHASE_SPEED = 70.0
var direction = 1
var is_idling = false
var is_chasing = false
var player: CharacterBody2D = null
var is_hurt = false
var damage_allowance = 2

@onready var red_dino: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var idle_timer: Timer = $IdleTimer


func _physics_process(delta: float) -> void:
	if not is_on_floor():
			velocity += get_gravity() * delta
	if is_chasing and player:
		_chase_logic(delta)
	elif not is_idling:
		_patrol_logic(delta)
	else:
		velocity.x = 0
		
	move_and_slide()

func _patrol_logic(_delta: float) -> void:
	if ray_cast_right.is_colliding() and direction == 1:
		start_idle(-1, true)
	elif ray_cast_left.is_colliding() and direction == -1:
		start_idle(1, false)
	else:
		red_dino.play("move")
		velocity.x = direction * SPEED

func _chase_logic(_delta: float) -> void:
	var chase_dir = sign(player.global_position.x - global_position.x)
	velocity.x = chase_dir * CHASE_SPEED
	
	red_dino.play("move")
	red_dino.flip_h = (chase_dir < 0)

func start_idle(new_direction, flip):
	is_idling = true
	red_dino.play("idle")
	direction = new_direction
	red_dino.flip_h = flip
	idle_timer.start(0.5)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		is_chasing = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_chasing = false
		player = null

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
