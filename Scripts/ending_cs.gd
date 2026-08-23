extends Node2D

@onready var whiteflash: AnimationPlayer = $ColorRect/AnimationPlayer
@onready var timer1: Timer = $Timer
@onready var timer_flashout: Timer = $TimerFlashout
@onready var chronos: AnimatedSprite2D = $Chronos
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var timer_dialogue_start: Timer = $TimerDialogueStart
@onready var textbox: DialogueBox_End = $Textbox
@onready var blackscreen: AnimationPlayer = $Black/AnimationPlayer
@onready var teleport: AudioStreamPlayer = $Teleport
@onready var timer_2: Timer = $Timer2

var dialogue_open = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textbox.dialogue_end_finished.connect(_on_dialogue_end_finished)
	Music.play("opening_cs")
	timer1.start()
	blackscreen.play("fade_out")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	whiteflash.play("fade_in")
	teleport.play()
	timer_flashout.start()


func _on_timer_flashout_timeout() -> void:
	whiteflash.play("fade_out")
	chronos.show()
	player_sprite.play("tweak")
	timer_dialogue_start.start()


func _on_timer_dialogue_start_timeout() -> void:
	textbox.show()
	dialogue_open = true
	textbox.queue_text("Chronos: Greetings, Human.")
	textbox.queue_text("Chronos: I see you've accomplished your mission, your color is returning to you.")
	textbox.queue_text("Chronos: Your people will be forever grateful to you.")
	textbox.queue_text("Chronos: Thank you. May the power of time be with you.")

func _on_dialogue_end_finished():
	player_sprite.play("colored_idle")
	textbox.hide()
	dialogue_open = false
	blackscreen.play("fade_in")
	timer_2.start()
	


func _on_timer_2_timeout() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/end_screen.tscn")
