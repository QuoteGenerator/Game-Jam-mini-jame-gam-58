class_name Slime
extends CharacterBody2D

@export var animationPlayer: AnimationPlayer
@export var speed := 30.0

var health := 20

var target: CharacterBody2D
var goingDirection := "down"

# Dash-Slime
var dash_direction := Vector2.ZERO
var dash_timer := 0.0
var is_dashing := false


func _ready() -> void:
	if target.kills > 40:
		modulate = Color.BLACK
		health = 20
	elif target.kills >= 25:
		health = 40
		speed = 50
		modulate = Color(0.361, 0.361, 0.361, 1.0)


func _physics_process(delta: float) -> void:
	if health <= 0:
		target.time_left += 3
		target.kills += 1
		queue_free()
		return

	if target:
		# Schwarzer Dash-Slime
		if target.kills > 40:
			dash_timer -= delta

			if dash_timer <= 0:
				if is_dashing:
					# Dash ist vorbei -> 4 Sekunden stehen bleiben
					is_dashing = false
					dash_timer = 4.0
					velocity = Vector2.ZERO
				else:
					# Neuen Dash starten
					dash_direction = global_position.direction_to(target.global_position)
					velocity = dash_direction * 180.0
					is_dashing = true
					dash_timer = 2.0

			if is_dashing:
				velocity = dash_direction * 180.0
				move_and_slide()
			else:
				velocity = Vector2.ZERO

			update_animation()
			return

		# Normaler Slime
		var direction := global_position.direction_to(target.global_position)

		velocity = direction * speed

		if direction.y > 0:
			goingDirection = "down"
		elif direction.y < 0:
			goingDirection = "up"

		move_and_slide()
		update_animation()


func update_animation() -> void:
	# Alle Sprites ausschalten
	for child in get_children():
		if child is Sprite2D:
			child.visible = false

	# Richtigen Sprite einschalten
	var slime_visual = get_node("slime_" + goingDirection)
	slime_visual.visible = true

	# Animation abspielen
	var animation_name = "slime_" + goingDirection

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
