extends CharacterBody2D

@export var animationPlayer: AnimationPlayer
@export var speed := 50.0

var target: CharacterBody2D
var goingDirection := "down"


func _ready() -> void:
	add_to_group("slime")


func _physics_process(delta: float) -> void:
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
	animationPlayer.play("slime_" + goingDirection)
