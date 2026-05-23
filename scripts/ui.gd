extends CanvasLayer
@onready var coin_label: Label = %CoinLabel
@onready var dino_label: Label = %DinoLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.initialize_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
# Update text every frame based on GameManager variables
	coin_label.text = "Budget: " + str(GameManager.coins)
	dino_label.text = "Dinos Left: " + str(GameManager.dinos_remaining)
