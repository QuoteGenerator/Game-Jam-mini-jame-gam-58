extends Node2D

@onready var path_follower: PathFollow2D = $Path2D/PathFollow2D
@onready var ps: AnimatedSprite2D = $Path2D/PathFollow2D/AnimatedSprite2D
@onready var player: CharacterBody2D = $Path2D/PathFollow2D/Player
@onready var timer: Timer = $Timer
@onready var a1: AnimationPlayer = $Path2D/PathFollow2D/Player/CanvasLayer2/Label/AnimationPlayer
@onready var a2: AnimationPlayer = $Path2D/PathFollow2D/Player/CanvasLayer2/HP_Bar/AnimationPlayer
@onready var a3: AnimationPlayer = $Path2D/PathFollow2D/Player/CanvasLayer2/HP_Overlay/AnimationPlayer

var is_path_following = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music.stop()
	
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
			
			timer.start()


func _on_timer_timeout() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/fighting_area.tscn")
	
