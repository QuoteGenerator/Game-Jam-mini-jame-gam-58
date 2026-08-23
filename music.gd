extends Node

@onready var player: AudioStreamPlayer = $AudioStreamPlayer

var current_track:= ""

const TRACKS := {
	"menu": preload("res://Music/Dreamcore Tone (by juanjo_sound).wav"),
	#"opening_cs": preload("res://assets/1. Dawn of Blades.wav"),
	"starter_area": preload("res://Music/Dreamcore Ice Cream (by juanjo_sound).wav"),
	#"fighting_area": preload("res://assets/13. The Forgotten Grove.wav"),
	"boss": preload("res://Music/LonePeakMusic - 22 Phobos -Retro Gaming Version-.wav"),
}

func _ready():
	player.bus = "music"

func play(track_name: String):
	if current_track == track_name and player.playing:
		return
	
	current_track = track_name
	player.stream = TRACKS[track_name]
	player.play()
	
func stop():
	player.stop()
	current_track = ""
