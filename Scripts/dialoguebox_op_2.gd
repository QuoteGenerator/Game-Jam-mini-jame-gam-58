extends CanvasLayer
class_name DialogueBox_Op2

signal dialogue_op2_finished

enum State {
	READY,
	READING,
	FINISHED
}
@onready var type_sound: AudioStreamPlayer = $SfxRetroMultiplev1

@onready var textbox_container: MarginContainer = $TextboxContainer
@onready var start_symbol: Label = $TextboxContainer/MarginContainer/HBoxContainer/StartSymbol
@onready var end_symbol: Label = $TextboxContainer/MarginContainer/HBoxContainer/EndSymbol
@onready var label: Label = $TextboxContainer/MarginContainer/HBoxContainer/Label


var tween: Tween
var state: State
var text_queue = []
const CHAR_READ_RATE = 0.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_textbox()
	state = State.READY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		State.READY:
			if not text_queue.is_empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("Interact"):
				finish_text()
		State.FINISHED:
			if Input.is_action_just_pressed("Interact"):
				hide_textbox()
				state = State.READY
				
				if text_queue.is_empty():
					dialogue_op2_finished.emit()


func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	#start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	label.visible_ratio = 0
	textbox_container.hide()

func show_textbox():
	start_symbol.text = "*"
	tween = create_tween()
	tween.finished.connect(finish_text)
	textbox_container.show()

func display_text():
	var next_text = text_queue.pop_front()
	if state != State.READY:
		return
	label.text = next_text
	label.visible_ratio = 0.0
	show_textbox()
	#tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1, len(next_text) * CHAR_READ_RATE)
	state = State.READING
	type_sound.play()
	#tween.start()

func finish_text():
	tween.stop()
	label.visible_ratio = 1
	state = State.FINISHED
	end_symbol.text = "V"
	type_sound.stop()


func _on_dialogue_op_2_finished() -> void:
	pass # Replace with function body.
