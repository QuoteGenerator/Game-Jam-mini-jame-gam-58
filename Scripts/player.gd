extends CharacterBody2D

@export var animationPlayer: AnimationPlayer
@export var sword_hitbox: Area2D

var health = 100

var goingDirection = "down"
var attacking = false

var speed = 50


func _ready() -> void:
	# SwordHitbox ist am Anfang aus
	sword_hitbox.monitoring = false


func _process(delta: float) -> void:
	if health <= 0:
		get_tree().change_scene_to_file("res://Scenes/StarterArea.tscn")


func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	
	# Bewegung
	if Input.is_action_pressed("moveRight"):
		goingDirection = "right"
		direction.x = 1
	
	if Input.is_action_pressed("moveLeft"):
		goingDirection = "left"
		direction.x = -1
	
	if Input.is_action_pressed("moveUp"):
		goingDirection = "up"
		direction.y = -1
	
	if Input.is_action_pressed("moveDown"):
		goingDirection = "down"
		direction.y = 1

	velocity = direction * speed

	# Angriff
	if Input.is_action_just_pressed("attack") and attacking == false:
		attack()

	move_and_slide()

	# Prüfen, ob Player einen Slime berührt
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider is Slime:
			health -= 0

	# Animation nur wenn wir nicht angreifen
	update_animation()


func update_animation() -> void:
	if attacking:
		return

	# Alle Visuals ausblenden
	for child in $Visuals.get_children():
		if child is Sprite2D:
			child.visible = false

	# Idle
	if velocity == Vector2.ZERO:
		var idle_visual = get_node("Visuals/idle_" + goingDirection)

		animationPlayer.play("idle_" + goingDirection)
		idle_visual.visible = true

	# Laufen
	else:
		var walk_visual = get_node("Visuals/walk_" + goingDirection)

		animationPlayer.play("walk_" + goingDirection)
		walk_visual.visible = true


func attack() -> void:
	print("ATTACK!")

	attacking = true

	# SwordHitbox in die richtige Richtung bewegen
	update_sword_hitbox()

	# Alle Sprites ausblenden
	for child in $Visuals.get_children():
		if child is Sprite2D:
			child.visible = false

	# Schwert anzeigen
	var sword_visual = get_node("Visuals/sword_" + goingDirection)

	animationPlayer.play("sword_" + goingDirection)
	sword_visual.visible = true

	# Warten bis Schwertanimation fertig ist
	await animationPlayer.animation_finished

	attacking = false


func check_sword_hit() -> void:
	var bodies = sword_hitbox.get_overlapping_bodies()

	print("Bodies in SwordHitbox: ", bodies.size())

	for body in bodies:
		print("Gefunden: ", body.name)

		if body is Slime:
			body.health -= 10
			body.hit_flash()

			print("SLIME GETROFFEN! HP: ", body.health)


func update_sword_hitbox() -> void:
	match goingDirection:
		"up":
			sword_hitbox.position = Vector2(0, -20)

		"down":
			sword_hitbox.position = Vector2(0, 20)

		"left":
			sword_hitbox.position = Vector2(-20, 0)

		"right":
			sword_hitbox.position = Vector2(20, 0)
