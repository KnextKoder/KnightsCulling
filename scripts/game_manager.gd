extends Node

var coins: int = 5
var total_coins_in_level: int = 0
var dinos_remaining: int = 0


# calls when the level starts
func initialize_level():
	dinos_remaining = get_tree().get_nodes_in_group("dinos").size()
	total_coins_in_level = get_tree().get_nodes_in_group("coins").size()

func add_coin():
	coins += 1
	print("You collected %d coins" % coins)

func spend_coin():
	if coins > 0:
		coins -= 1
		print("Coin spent! Remaining: ", coins)
		return true
	return false

func dino_killed():
	dinos_remaining -= 1
