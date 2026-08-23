extends Control

@onready var click: AudioStreamPlayer = $Click
@onready var church_bell: AudioStreamPlayer = $ChurchBell


func _ready() -> void:
	church_bell.play()
	Music.stop()

func _on_restart_pressed() -> void:
	click.play()
	await click.finished
	print("pressed")
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/fighting_area.tscn")
