extends Node

var coins: int = 5
var total_coins_in_level: int = 0
var dinos_remaining: int = 0
var portal: Area2D
var win_label: Label

func initialize_level():
	dinos_remaining = get_tree().get_nodes_in_group("dinos").size()
	total_coins_in_level = get_tree().get_nodes_in_group("coins").size()
	if win_label:
		win_label.visible = false
	if is_instance_valid(portal):
		portal.set_portal_visible(false)

func add_coin():
	coins += 1

func spend_coin():
	if coins > 0:
		coins -= 1
		return true
	return false
	
func reset_coins(x: int = 5):
	coins = x

func dino_killed():
	dinos_remaining -= 1
	if dinos_remaining <= 0:
		if is_instance_valid(portal):
			portal.set_portal_visible(true)
		else:
			print("All dinos dead, but no portal found in this level!")
		if get_tree().current_scene.scene_file_path == "res://scenes/level_2.tscn":
			if win_label:
				win_label.visible = true

func _change_to_level_2():
	reset_coins(4)
	get_tree().call_deferred("change_scene_to_file", "res://scenes/level_2.tscn")

func restart():
	reset_coins(5)
	dinos_remaining = 0
	get_tree().change_scene_to_file("res://scenes/game.tscn")
