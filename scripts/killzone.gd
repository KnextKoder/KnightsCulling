extends Area2D
@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("You died!")
	if body.name == "Player":
		var player_sprite = body.get_node("AnimatedSprite2D")
		body.is_dead = true
		if player_sprite:
			player_sprite.play("death")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
