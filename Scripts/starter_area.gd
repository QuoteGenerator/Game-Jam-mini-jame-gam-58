extends Node2D

@onready var dialogue1: DialogueBox1 = $dialogue1
@onready var dialogue2: DialogueBox2 = $dialogue2
@onready var dialogue3: DialogueBox3 = $dialogue3
@onready var player: CharacterBody2D = $Player
@onready var starter_cam: Camera2D = $Player/StarterCam
@onready var fade: AnimationPlayer = $Fade/AnimationPlayer
@onready var fade_timer: Timer = $FadeTimer

var scene_switch = false

var dialogue1_open = false
var dialogue2_open = false
var dialogue3_open = false

var npc1_entered = false
var npc2_entered = false
var npc3_entered = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music.play("starter_area")
	fade.play("fade_out")
	fade_timer.start()
	player.set_physics_process(false)
	starter_cam.make_current()
	dialogue1.dialogue1_finished.connect(_on_dialogue1_finished)
	dialogue2.dialogue2_finished.connect(_on_dialogue2_finished)
	dialogue3.dialogue3_finished.connect(_on_dialogue3_finished)
	#dialogue1.queue_text("hello") #queue any text
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	run_dialogue1()
	run_dialogue2()
	run_dialogue3()

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
	print("npc2 entered")
	print(body.name)
	
func _on_npc_2_range_body_exited(body: Node2D) -> void:
	npc2_entered = false
	
func _on_npc_3_range_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return

	npc3_entered = true
	print("npc3 entered")
	print(body.name)


func _on_npc_3_range_body_exited(body: Node2D) -> void:
	npc3_entered = false

func _on_dialogue1_finished():
	dialogue1.hide()
	dialogue1_open = false
	player.set_physics_process(true)
	
func _on_dialogue2_finished():
	dialogue2.hide()
	dialogue2_open = false
	player.set_physics_process(true)
	
func _on_dialogue3_finished():
	dialogue3.hide()
	dialogue3_open = false
	player.set_physics_process(true)
	
func run_dialogue1():
	if Input.is_action_just_pressed("Interact") and npc1_entered and not dialogue1_open:
		player.set_physics_process(false)
		dialogue1_open = true
		dialogue1.show()
		
		dialogue1.queue_text("Shadow Villager 1: ...")

func run_dialogue2():
	if Input.is_action_just_pressed("Interact") and npc2_entered and not dialogue2_open:
		player.set_physics_process(false)
		dialogue2_open = true
		dialogue2.show()
		
		dialogue2.queue_text("Shadow Villager 3: Save us, chosen one...")

func run_dialogue3():
	if Input.is_action_just_pressed("Interact") and npc3_entered and not dialogue3_open:
		player.set_physics_process(false)
		dialogue3_open = true
		dialogue3.show()
		
		dialogue3.queue_text("Shadow Villager 2: Ever since the day they've taken away my color...")
		dialogue3.queue_text("Shadow Villager 2: I've lost my purpose in life. I can't keep going like this...")
		


func _on_scene_switch_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/fa_transition.tscn")
	#get_tree().change_scene_to_file("res://Scenes/fighting_area.tscn")


func _on_fade_timer_timeout() -> void:
	player.set_physics_process(true)
