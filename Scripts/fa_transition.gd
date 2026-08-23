extends Node2D

@onready var path_follower: PathFollow2D = $Path2D/PathFollow2D
@onready var ps: AnimatedSprite2D = $Path2D/PathFollow2D/AnimatedSprite2D
@onready var player: CharacterBody2D = $Path2D/PathFollow2D/Player
@onready var timer: Timer = $Timer
@onready var a1: AnimationPlayer = $Path2D/PathFollow2D/Player/CanvasLayer2/Label/AnimationPlayer
@onready var a2: AnimationPlayer = $Path2D/PathFollow2D/Player/CanvasLayer2/HP_Bar/AnimationPlayer
@onready var a3: AnimationPlayer = $Path2D/PathFollow2D/Player/CanvasLayer2/HP_Overlay/AnimationPlayer
@onready var a4: AnimationPlayer = $Path2D/PathFollow2D/Player/CanvasLayer2/Control/AnimationPlayer
@onready var textbox: DialogueBoxTut = $Textbox

var is_path_following = false
var dialogue_open = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music.stop()
	
	textbox.dialogue_tut_finished.connect(_on_dialogue_tut_finished)
	player.set_physics_process(false)
	#play walk up anim
	is_path_following = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta):
	if is_path_following:
		path_follower.progress_ratio += 0.011
		
		if path_follower.progress_ratio >= 1:
			is_path_following = false
			ps.play("idle_up")
			#player.hp_bar.show()
			#player.hp_overlay.show()
			#player.time_label.show()
			a1.play("fade_in")
			a2.play("fade_in")
			a3.play("fade_in")
			a4.play("fade_in")
			
			timer.start()


func _on_timer_timeout() -> void:
	textbox.show()
	dialogue_open = true
	textbox.queue_text("TUTORIAL: LEFT CLICK to slash in the direction you're facing, 'E' to interact.")
	textbox.queue_text("TUTORIAL: When the timer on top runs out, you lose!")
	textbox.queue_text("TUTORIAL: For each enemy you kill, gain +3 seconds.")
	textbox.queue_text("TUTORIAL: After a certain amount of enemies slain, the top right icon will begin to change.")
	textbox.queue_text("TUTORIAL: This icon indicates in which phase you are currently in, of which there are 4.")
	textbox.queue_text("TUTORIAL: Press 'ESC' to pause your game.")
	textbox.queue_text("TUTORIAL: In the pause menu, there is a shop. In this shop, you can buy upgrades using your time left from the timer as currency.")
	textbox.queue_text("TUTORIAL: Spend your time wisely. Off you go!")
	
	
func _on_dialogue_tut_finished():
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/fighting_area.tscn")
