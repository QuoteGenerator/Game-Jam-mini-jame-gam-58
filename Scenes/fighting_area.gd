extends Node2D

@onready var camera: Camera2D = $Player/Camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
