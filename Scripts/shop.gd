extends Control

@onready var pause_menu: Control = $"../PauseMenu"
@onready var click: AudioStreamPlayer = $Click

@onready var player: CharacterBody2D = $"../.."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func resume():
	get_tree().paused = false
	hide()


func _on_atk_pressed() -> void:
	print("pressed")
	player.damage += 10
	player.time_left -= 60
	click.play()


func _on_speed_pressed() -> void:
	print("pressed")
	player.speed += 10
	player.time_left -= 60
	click.play()

func _on_hp_pressed() -> void:
	print("pressed")
	player.health += 10
	player.time_left -= 60
	click.play()

func _on_x_pressed() -> void:
	hide()
	click.play()
	pause_menu.show()
	print("pressed")
