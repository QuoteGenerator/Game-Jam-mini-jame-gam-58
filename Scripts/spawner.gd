extends Node2D

@export var slime_scene: PackedScene
@export var spawn_interval = 3.0
@export var map_size = Vector2(400, 400)

var player: CharacterBody2D

var timer: float = 0.0

func _ready():
	player = get_node("../Player")

func _process(delta: float) -> void:
	timer += delta

	if timer >= spawn_interval:
		spawn_slime()
		timer = 0.0


func spawn_slime() -> void:
	var slime = slime_scene.instantiate()

	slime.position = Vector2(
		randf_range(-map_size.x, map_size.x),
		randf_range(-map_size.y, map_size.y)
	)
	slime.target = player

	add_child(slime)
