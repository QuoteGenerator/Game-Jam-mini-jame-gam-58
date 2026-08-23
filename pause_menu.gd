extends Control

@onready var click: AudioStreamPlayer = $Click
@onready var shop: Control = $"../Shop"

func _process(delta):
	testESC()

func resume():
	get_tree().paused = false
	hide()

func pause ():
	get_tree().paused = true
	show()
	print("showing")
	
func testESC():
	if Input.is_action_just_pressed("Pause") and !get_tree().paused:
		pause()
	
	#elif Input.is_action_just_pressed("Pause") and get_tree().paused:
	#	resume()

func _on_resume_pressed() -> void:
	click.play()
	resume()
	print("pressed")

func _on_shop_pressed() -> void:
	click.play()
	hide()
	shop.show()
	print("pressed")

func _on_restart_pressed() -> void:
	click.play()
	await click.finished
	print("pressed")
	resume()
	get_tree().reload_current_scene()
