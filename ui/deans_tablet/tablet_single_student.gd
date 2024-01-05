extends HBoxContainer
var isChecked
@onready var checkmark = load("res://ui/deans_tablet/checkmark.png")
@onready var cross = load("res://assets/cross.png")

func _on_button_button_down():
	if isChecked:
		$Button.icon = cross
		isChecked = false
	else:
		$Button.icon = checkmark
		isChecked = true
	
