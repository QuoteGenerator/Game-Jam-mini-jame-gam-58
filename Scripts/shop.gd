extends Control

@onready var pause_menu: Control = $"../PauseMenu"
@onready var click: AudioStreamPlayer = $Click

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func resume():
	get_tree().paused = false
	hide()


func _on_atk_pressed() -> void:
	print("pressed")
	click.play()


func _on_speed_pressed() -> void:
	print("pressed")
	click.play()

func _on_hp_pressed() -> void:
	print("pressed")
	click.play()

func _on_x_pressed() -> void:
	hide()
	click.play()
	pause_menu.show()
	print("pressed")
