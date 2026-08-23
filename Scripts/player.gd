extends CharacterBody2D

@export var time_label: Label

@onready var sword_miss: AudioStreamPlayer = $SwordMiss
@onready var sword_perfekt: AudioStreamPlayer = $SwordPerfekt
@onready var damage_taken: AudioStreamPlayer = $DamageTaken
@onready var phases: AnimatedSprite2D = $CanvasLayer/Control/Phases
@onready var ph: Control = $CanvasLayer/Control

@export var animationPlayer: AnimationPlayer
@export var sword_hitbox: Area2D
@onready var hp_bar: ColorRect = $CanvasLayer/HP_Bar
@onready var hp_overlay: TextureRect = $CanvasLayer/HP_Overlay

var max_hp_scale_x: float

var max_health = 100
var health = 100
var time_left = 300.0 # 5 Minuten
var timer_running = false

var damage = 10

var goingDirection = "up"
var attacking = false

var kills = 0

var speed = 70

var time = 5

var can_take_damage = true


func _ready() -> void:
	add_to_group("player")
	
	sword_hitbox.monitoring = false
	max_hp_scale_x = hp_bar.scale.x


func _process(delta: float) -> void:
	if timer_running:
		time_left -= delta
	if health <= 0 or time_left <= 0:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
	
	update_time_label()


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
		sword_miss.play()
		attack()

	move_and_slide()

	# Prüfen, ob Player einen Slime berührt
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if (collider is slime or collider is slimeKing) and can_take_damage:
			take_damage(10)
			damage_taken.play()

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

		if body is slime or body is slimeKing:
			body.health -= damage
			body.hit_flash()

			print("SLIME GETROFFEN! HP: ", body.health)


func take_damage(amount: int) -> void:
	if not can_take_damage:
		return

	# Unverwundbar machen
	can_take_damage = false

	# Schaden
	health -= amount
	health = max(health, 0)
	
	hp_bar.scale.x = max_hp_scale_x * (float(health) / max_health)
	print("PLAYER GETROFFEN! HP: ", health)

	# Player rot färben
	for child in $Visuals.get_children():
		if child is Sprite2D:
			child.modulate = Color(1, 0.2, 0.2)

	# Kurz rot bleiben
	await get_tree().create_timer(0.1).timeout

	# Wieder normale Farbe
	for child in $Visuals.get_children():
		if child is Sprite2D:
			child.modulate = Color.WHITE

	# 1 Sekunde unverwundbar
	await get_tree().create_timer(0.9).timeout

	# Wieder Schaden bekommen können
	can_take_damage = true


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

func update_time_label() -> void:
	var total_seconds := int(time_left)

	var minutes := total_seconds / 60
	var seconds := total_seconds % 60

	var milliseconds := int((time_left - int(time_left)) * 100)

	time_label.text = "Time: %02d:%02d:%02d" % [minutes, seconds, milliseconds]


func update_phase():
	if kills >= 60:
		phases.play("phase4")
	elif kills > 40:
		phases.play("phase3")
	elif kills >= 25:
		phases.play("phase2")
	else:
		phases.play("phase1")
