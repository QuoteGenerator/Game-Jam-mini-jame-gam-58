extends Node2D

@onready var camera: Camera2D = $Player/Camera
@onready var player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#player.time_label.show()
	player.timer_running = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
