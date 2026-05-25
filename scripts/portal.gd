extends Area2D

@onready var portal_sprite: AnimatedSprite2D = $PortalSprite

func _ready() -> void:
	GameManager.portal = self 
	GameManager.initialize_level()

func _on_body_entered(_body: Node2D) -> void:
	if portal_sprite.visible:
		GameManager._change_to_level_2()

func set_portal_visible(p_visible: bool):
	portal_sprite.visible = p_visible
