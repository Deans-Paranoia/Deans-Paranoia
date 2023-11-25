extends Node2D

var can_use_alarm : bool = false

var has_booster: bool

var temp_speed

func _process(delta):
	if Input.is_action_just_pressed("use_alarm"):
		var fire_alarm_reference = get_node("../fire_alarm")
		if fire_alarm_reference.useable and can_use_alarm:
			sabotage_alarm()
			fire_alarm_reference.useable = false
			stop_player_movement()
			$CharacterBody2D/FreezeTimer.start()

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

func stop_player_movement():
	temp_speed = $CharacterBody2D.take_current_speed_value()
	$CharacterBody2D.stop_player_movement()


func _on_freeze_timer_timeout():
	$CharacterBody2D.restore_player_movement(temp_speed)
