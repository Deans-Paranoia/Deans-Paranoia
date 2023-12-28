extends CanvasLayer

@onready var lineEdit = $Control/VBoxContainer/LineEdit

func _on_student_use_chat():
	lineEdit.grab_focus()
