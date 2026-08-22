class_name Slime
extends CharacterBody2D

@export var animationPlayer: AnimationPlayer
@export var speed := 30.0

var health := 20

var target: CharacterBody2D
var goingDirection := "down"


func _physics_process(delta: float) -> void:
	if health <= 0:
		queue_free()
		return

	if target:
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
	# Alle Slime-Sprites rot färben
	for child in get_children():
		if child is Sprite2D:
			child.modulate = Color(1, 0.2, 0.2)

	# Kurz warten
	await get_tree().create_timer(0.08).timeout

	# Wieder normale Farbe
	for child in get_children():
		if child is Sprite2D:
			child.modulate = Color.WHITE
