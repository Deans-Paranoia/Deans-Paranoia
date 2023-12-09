extends Node2D

@onready var terminal1 = get_node("terminal1")
@onready var terminal2 = get_node("terminal2")
@onready var terminal3 = get_node("terminal3")

var value = globalScript.ServerValue

func calculate_value():
	if (100 * terminal1.actual_value + 10 * terminal2.actual_value + terminal3.actual_value) == value:
		print("koniec gry")
		return true
	else:
		print("kod niepoprawny")
		return false
