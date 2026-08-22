extends Node2D

@onready var dialogue1: DialogueBox1 = $dialogue1
@onready var dialogue2: DialogueBox2 = $dialogue2
@onready var player: CharacterBody2D = $Player

var dialogue1_open = false
var dialogue2_open = false
var npc1_entered = false
var npc2_entered = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogue1.dialogue1_finished.connect(_on_dialogue1_finished)
	dialogue2.dialogue2_finished.connect(_on_dialogue2_finished)
	#dialogue1.queue_text("hello") #queue any text
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	run_dialogue1()
	run_dialogue2()

func _on_area_2d_body_entered(body: Node2D) -> void: #npc1
	if body.name != "Player":
		return

	npc1_entered = true
	print("npc1 entered")
	print(body.name)


func _on_area_2d_body_exited(body: Node2D) -> void: #npc1
	npc1_entered = false
	
func _on_npc_2_range_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return

	npc2_entered = true
	print("npc1 entered")
	print(body.name)
	
func _on_npc_2_range_body_exited(body: Node2D) -> void:
	npc2_entered = false

func _on_dialogue1_finished():
	dialogue1.hide()
	dialogue1_open = false
	player.set_physics_process(true)
	
func _on_dialogue2_finished():
	dialogue2.hide()
	dialogue2_open = false
	player.set_physics_process(true)
	
func run_dialogue1():
	if Input.is_action_just_pressed("Interact") and npc1_entered and not dialogue1_open:
		player.set_physics_process(false)
		dialogue1_open = true
		dialogue1.show()
		dialogue1.queue_text("hello im npc 1!")
		dialogue1.queue_text("it is nice to meet u :D")

func run_dialogue2():
	if Input.is_action_just_pressed("Interact") and npc2_entered and not dialogue2_open:
		player.set_physics_process(false)
		dialogue2_open = true
		dialogue2.show()
		dialogue2.queue_text("hello im npc 2!")
		dialogue2.queue_text("dont mind me, im just sitting here.")
