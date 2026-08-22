extends CharacterBody2D
@export var animationPlayer: AnimationPlayer

var goingDirection = "down"
var attacking = false
var attackingFinished = true

var speed = 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	
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
	if Input.is_action_just_pressed("attack"):
		attack()
	
	move_and_slide()
	update_animation()


func update_animation() -> void:
	
	
	if attacking == false:
		for child in $Visuals.get_children():
			if child is Sprite2D:
				child.visible = false

	if attacking == false:
		if velocity == Vector2.ZERO:
			var idle_visual = get_node("Visuals/idle_" + goingDirection)
			animationPlayer.play("idle_" + goingDirection)
			idle_visual.visible = true
		else:
			var idle_visual = get_node("Visuals/walk_" + goingDirection)
			animationPlayer.play("walk_" + goingDirection)
			idle_visual.visible = true


		
func attack() -> void:
	attacking = true
	
	for child in $Visuals.get_children():
		if child is Sprite2D:
			child.visible = false
			
	var idle_visual = get_node("Visuals/sword_" + goingDirection)
	animationPlayer.play("sword_" + goingDirection)
	idle_visual.visible = true
	
	await animationPlayer.animation_finished
	
	attacking = false
