extends Node2D

@onready var timer: Timer = $Timer
@onready var fade: AnimationPlayer = $fade_screen/AnimationPlayer
@onready var fade_screen: ColorRect = $fade_screen
@onready var start: Button = $Button_Manager/Start

#var button_type = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade_screen.hide()

func _on_start_pressed() -> void:
	#button_type = "start"
	fade_screen.show()
	start.hide()
	fade.play("fade_in")
	timer.start()
	
func _on_timer_timeout() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/StarterArea.tscn")
