extends Node2D

var fireAlarmReference
signal areaEntered

var has_booster: bool

var can_move: bool

func _process(delta):
	if Input.is_action_just_pressed("use_alarm"):
		fireAlarmReference = get_node("../FireAlarm")
		if fireAlarmReference.useable:
			sabotage_alarm()
			can_move = false 
			fireAlarmReference.useable = false

func acquire_booster():
	pass
#write your logic for student here, also create fireAlarm scene and you can attach a script for this scene

func sabotage_alarm():
	print("Alarm sabotaged")

func dig():
	pass

func use_terminal():
	pass

func use_elevator():
	pass

func use_server():
	pass
