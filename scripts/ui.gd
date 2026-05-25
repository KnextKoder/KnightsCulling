extends CanvasLayer
@onready var coin_label: Label = %CoinLabel
@onready var dino_label: Label = %DinoLabel
@onready var win_label: Label = %WinLabel
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.win_label = %WinLabel
	GameManager.initialize_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
# Update text every frame based on GameManager variables
	coin_label.text = "Coins: " + str(GameManager.coins)
	dino_label.text = "Dinos Left: " + str(GameManager.dinos_remaining)


func _on_win_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			GameManager.restart()
