extends CharacterBody2D


var speed = 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("moveRight"):
		direction.x = 1
	if Input.is_action_pressed("moveLeft"):
		direction.x = -1
	if Input.is_action_pressed("moveUp"):
		direction.y = -1
	if Input.is_action_pressed("moveDown"):
		direction.y = 1
		
	velocity = direction * speed
	
	move_and_slide()
