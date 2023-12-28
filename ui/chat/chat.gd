extends CanvasLayer

@export var new_message: PackedScene

@onready var line_edit = $Control/VBoxContainer/LineEdit
@onready var vboxContainer = $Control/VBoxContainer

var chat_in_use: bool = false

signal chat_opened(is_opened: bool)

func _on_student_use_chat():
	if chat_in_use:
		if len(line_edit.text) <= 0:
			line_edit.release_focus()
			chat_in_use = false
			chat_opened.emit(false)
		else:
			add_message_to_chat(line_edit.text)
			line_edit.text = ""
	else:
		line_edit.grab_focus()
		chat_in_use = true
		chat_opened.emit(true)


func add_message_to_chat(message_content):
	var new_message_instance = new_message.instantiate()
	vboxContainer.add_child(new_message_instance)
	var label = new_message_instance.get_node("Label")
	label.text = message_content
