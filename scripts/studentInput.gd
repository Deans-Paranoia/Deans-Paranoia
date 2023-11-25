extends Node2D

var can_use_alarm : bool = false

var has_booster: bool

var can_move: bool = false

func _process(delta):
	if Input.is_action_just_pressed("use_alarm"):
		var fire_alarm_reference = get_node("../fire_alarm")
		if fire_alarm_reference.useable and can_use_alarm:
			sabotage_alarm()
			fire_alarm_reference.useable = false
			can_move = false 

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
	
func _on_player_area_area_entered(area):
	var area_entered = area.get_name()
	if (area_entered == "FireAlarmArea"):
		can_use_alarm = true

func _on_player_area_area_exited(area):
	var area_exited = area.get_name()
	if (area_exited == "FireAlarmArea"):
		can_use_alarm = false

