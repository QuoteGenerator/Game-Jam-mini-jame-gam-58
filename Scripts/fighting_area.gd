extends Node2D

@onready var camera: Camera2D = $Player/Camera
@onready var player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music.play("fighting_area")
	player.time_label.show()
	player.timer_running = true
	player.hp_bar.show()
	player.hp_overlay.show()
	player.ph.show()
	player.ph2.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
