extends Node2D

@onready var flash: AnimationPlayer = $WhiteFlash/AnimationPlayer
@onready var timer_flash_in: Timer = $TimerFlashIn
@onready var timer_flash_out: Timer = $TimerFlashOut
@onready var fade_out: AnimationPlayer = $BlackFade/AnimationPlayer
@onready var teleport: AudioStreamPlayer = $Teleport
@onready var chronos: AnimatedSprite2D = $Chronos
@onready var rufzeichen: AnimatedSprite2D = $Rufzeichen
@onready var timer_r: Timer = $TimerR
@onready var player: AnimatedSprite2D = $Player
@onready var timer_r_2: Timer = $TimerR2
@onready var op_dialogue: DialogueBox_Op = $Op_dialogue
@onready var timer_start_dialogue: Timer = $TimerStartDialogue
@onready var sword: AnimatedSprite2D = $Sword
@onready var op_dialogue_2: DialogueBox_Op2 = $Op_dialogue2
@onready var timer_fade_out: Timer = $TimerFadeOut
@onready var s1: AnimationPlayer = $S1/AnimationPlayer
@onready var s_1: Sprite2D = $S1
@onready var timer_scene_switch: Timer = $TimerSceneSwitch

var dialogue_open = false
var dialogue2_open =false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	op_dialogue.dialogue_op_finished.connect(_on_dialogue_op_finished)
	op_dialogue_2.dialogue_op2_finished.connect(_on_dialogue_op2_finished)
	fade_out.play("fade_out")
	timer_flash_in.start()
	Music.play("opening_cs")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_flash_in_timeout() -> void:
	flash.play("flash_in")
	timer_flash_out.start()
	teleport.play()


func _on_timer_flash_out_timeout() -> void:
	chronos.show()
	flash.play("flash_out")
	timer_r.start()


func _on_timer_r_timeout() -> void:
	rufzeichen.show()
	rufzeichen.play("pop_in")
	timer_r_2.start()
	

func _on_timer_r_2_timeout() -> void:
	player.play("get_up")
	rufzeichen.play("pop_out")


func _on_player_animation_finished() -> void:
	if player.animation == "get_up":
		player.play("idle")
		timer_start_dialogue.start()


func _on_timer_start_dialogue_timeout() -> void:
	op_dialogue.show()
	dialogue_open = true
	op_dialogue.queue_text("???: ...")
	op_dialogue.queue_text("???: Greetings, Human.")
	op_dialogue.queue_text("???: I feel that you have great potential.")
	op_dialogue.queue_text("???: I'm Chronos, the god of time itself.")
	op_dialogue.queue_text("Chronos: I must ask you, human, do you want to free yourself and your lifeless town from the shadowy shackles that bind you?")
	op_dialogue.queue_text("Chronos: Perfect. I shall aid you in your crusade.")

	
	
func _on_dialogue_op_finished():
	dialogue_open = false
	op_dialogue_2.show()
	dialogue2_open = true
	s1.play("sword_fade_in")
	op_dialogue_2.queue_text("Chronos: Take this magic imbued sword. It may look like any other sword, but special powers lie within.")
	op_dialogue_2.queue_text("Chronos: If wielded correctly, those powers will come to light.")
	op_dialogue_2.queue_text("Chronos: May time guide you.")
	
func _on_dialogue_op2_finished():
	timer_fade_out.start()
	dialogue2_open = false


func _on_timer_fade_out_timeout() -> void:
	fade_out.play("fade_in")
	timer_scene_switch.start()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "sword_fade_in":
		sword.show()
		s_1.hide()


func _on_timer_scene_switch_timeout() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/StarterArea.tscn")
