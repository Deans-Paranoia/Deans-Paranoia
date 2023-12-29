extends CanvasLayer

@export var new_message: PackedScene

@onready var line_edit = $Panel/VBoxInput/Input
@onready var message_panel = $Panel/VBoxMessages

var chat_in_use: bool = false

signal chat_opened(is_opened: bool)

func _on_student_use_chat(name):
	chat_opened.connect(get_parent().get_node(str(name)+"/"+str(name))._on_chat_chat_opened)
	if chat_in_use:
		if len(line_edit.text) <= 0:
			line_edit.release_focus()
			line_edit.placeholder_text = "Press ENTER to type"
			chat_in_use = false
			chat_opened.emit(false)
			$".".scale = Vector2(0.5,0.5)
			$"Panel".modulate = Color(1,1,1,0.5)
		else:
			add_message_to_chat(line_edit.text,name)
			add_message_to_chat.rpc(line_edit.text,name)
			line_edit.text = ""
	else:
		line_edit.grab_focus()
		line_edit.placeholder_text = ""
		chat_in_use = true
		
		chat_opened.emit(true)
		
		$".".scale = Vector2(1,1)
		$"Panel".modulate = Color(1,1,1,1)
	chat_opened.disconnect(get_parent().get_node(str(name)+"/"+str(name))._on_chat_chat_opened)
@rpc("any_peer","call_remote"	)
func add_message_to_chat(message_content,name):
	var new_message_instance = new_message.instantiate()
	message_panel.add_child(new_message_instance)
	var label = new_message_instance.get_node("Message")
	label.text = globalScript.Players[int(str(name))].fakeName+ ": "+message_content
