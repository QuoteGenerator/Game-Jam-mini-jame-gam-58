extends CharacterBody2D

@export var slime_scene: PackedScene

var speed = 200

@export var player: CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var triangleAttackInitiated = false
var spawnSlimesInitiated = false
var spawnTimer = 10
var triangleAttackUsed = 0

func _process(delta: float) -> void:
	spawnTimer -= delta
	
	if spawnTimer <= 0 and spawnSlimesInitiated == false:
		spawnSlimes()

func _physics_process(delta: float) -> void:
	
	if triangleAttackInitiated == false:
		triangleAttack()
	
	velocity = direction * speed
	
	move_and_slide()

func triangleAttack():
	if triangleAttackUsed > 4:
		direction = Vector2.ZERO
		await get_tree().create_timer(10).timeout
	
	triangleAttackInitiated = true
	direction = global_position.direction_to(player.global_position + Vector2(0, -100))
	
	while global_position.distance_to(player.global_position + Vector2(0, -100)) > 5:
		direction = global_position.direction_to(player.global_position + Vector2(0, -100))
		await get_tree().physics_frame
	
	direction = global_position.direction_to(player.global_position + Vector2(-150, 100))
	
	while global_position.distance_to(player.global_position + Vector2(-150, 100)) > 5:
		direction = global_position.direction_to(player.global_position + Vector2(-150, 100))
		await get_tree().physics_frame
		
	direction = global_position.direction_to(player.global_position + Vector2(150, 100))
	
	while global_position.distance_to(player.global_position + Vector2(150, 100)) > 5:
		direction = global_position.direction_to(player.global_position + Vector2(150, 100))
		await get_tree().physics_frame
	
	direction = Vector2.ZERO
	triangleAttackUsed += 1
	triangleAttack()

func spawnSlimes():
	spawnSlimesInitiated = true
	
	for i in range(3):
		var slime = slime_scene.instantiate()
		slime.target = player
		
		get_parent().add_child(slime)
		slime.global_position = global_position
		
		await get_tree().create_timer(2).timeout
		
	spawnSlimes()
