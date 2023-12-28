extends Node2D
signal on_student_hovered(name)
var on_lecture_hall = false
func _ready():
	get_parent().input_pickable = true
func _on_character_body_2d_mouse_entered():
	if globalScript.deanId == multiplayer.get_unique_id() and on_lecture_hall:
		on_student_hovered.emit(get_parent().get_parent().name)

func _on_character_body_2d_mouse_exited():
	if globalScript.deanId == multiplayer.get_unique_id() and on_lecture_hall:
		on_student_hovered.emit(null)
