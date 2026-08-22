extends Node2D

@export var slime_scene: PackedScene
@export var spawn_interval = 3.0
@export var map_size = Vector2(500, 500)

var player: CharacterBody2D

var timer: float = 0.0

func _ready():
	player = get_node("../Player")

func _process(delta: float) -> void:
	if player.kills > 60:
		return
		
	
	timer += delta

	if timer >= spawn_interval:
		spawn_slime()
		timer = 0.0


func spawn_slime() -> void:
	var slime = slime_scene.instantiate()

	var side = randi_range(0, 3)

	match side:
		0: # Oben
			slime.position = Vector2(
				randf_range(-map_size.x, map_size.x),
				-map_size.y
			)
		1: # Unten
			slime.position = Vector2(
				randf_range(-map_size.x, map_size.x),
				map_size.y
			)
		2: # Links
			slime.position = Vector2(
				-map_size.x,
				randf_range(-map_size.y, map_size.y)
			)
		3: # Rechts
			slime.position = Vector2(
				map_size.x,
				randf_range(-map_size.y, map_size.y)
			)

	slime.target = player
	add_child(slime)
