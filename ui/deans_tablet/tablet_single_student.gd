extends HBoxContainer

@onready var questionmark = load("res://assets/questionmark.png")
@onready var checkmark = load("res://assets/checkmark.png")
@onready var cross = load("res://assets/cross.png")

@onready var Checks = [questionmark, checkmark, cross]

var CheckNumber = 0

func _on_button_button_down():
	CheckNumber = (CheckNumber + 1) % 3
	$Panel/Button.icon = Checks[CheckNumber]


	
