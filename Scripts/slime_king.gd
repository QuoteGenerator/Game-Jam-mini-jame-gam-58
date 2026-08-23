class_name slimeKing
extends CharacterBody2D

@export var slime_scene: PackedScene

var speed = 200
var health = 1000

var player: CharacterBody2D
@export var animationPlayer: AnimationPlayer

var direction: Vector2 = Vector2.ZERO
var triangleAttackInitiated = false
var spawnSlimesInitiated = false
var spawnTimer = 10
var triangleAttackUsed = 0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	Music.play("boss")

func _process(delta: float) -> void:
	
	if health <= 0:	
		queue_free()
		
	spawnTimer -= delta
	
	if spawnTimer <= 0 and spawnSlimesInitiated == false:
		spawnSlimes()

func _physics_process(delta: float) -> void:
	
	if triangleAttackInitiated == false:
		triangleAttack()
	
	velocity = direction * speed
	
	move_and_slide()
	update_animation()

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
	
func update_animation() -> void:
	# Alle Sprites ausschalten
	for child in get_children():
		if child is Sprite2D:
			child.visible = false
	
	var animation_name: String
	
	if velocity == Vector2.ZERO:
		animation_name = "slimeking_idle"
	elif velocity.y < 0:
		animation_name = "slimeking_up"
	else:
		animation_name = "slimeking_down"
	
	# Passenden Sprite einschalten
	var king_visual = get_node(animation_name)
	king_visual.visible = true
	
	# Animation abspielen
	if animationPlayer.current_animation != animation_name:
		animationPlayer.play(animation_name)


func hit_flash() -> void:
	for child in get_children():
		if child is Sprite2D:
			child.modulate = Color(1, 0.2, 0.2)

	# Kurz warten
	await get_tree().create_timer(0.08).timeout

	# Wieder normale Farbe
	for child in get_children():
		if child is Sprite2D:
			child.modulate = Color.WHITE
