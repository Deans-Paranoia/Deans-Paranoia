extends Node2D

func _ready():
	# ustawia gracza (mniej więcej) na środku
	position.x = 550
	position.y = 275

var has_booster: bool

var can_move: bool

func acquire_booster():
	pass

func sabotage_alarm():
	pass

func dig():
	pass

func use_terminal():
	pass

func use_elevator():
	pass

func use_server():
	pass
