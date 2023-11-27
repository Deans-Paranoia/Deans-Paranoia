extends Node2D

var can_use_alarm : bool = false
var can_use_elevator: bool = false
# Zmienna pomocna w kontroli położenia gracza w obszarze użycia któregoś z powyższych obiektów

var has_booster: bool

var temp_speed

func _process(_delta):
	if Input.is_action_just_pressed("use_alarm"):
		var fire_alarm_reference = get_node("../fire_alarm")
		if fire_alarm_reference.useable and can_use_alarm:
			sabotage_alarm()
			fire_alarm_reference.useable = false
			stop_player_movement()
			$CharacterBody2D/FreezeTimer.start()
	if Input.is_action_just_pressed("use_elevator"):
		var elevator_reference = get_node("../elevator")
		if can_use_elevator:
			use_elevator()

func acquire_booster():
	pass
#write your logic for student here, also create fireAlarm scene and you can attach a script for this scene

func sabotage_alarm():
	print("Alarm sabotaged")

func dig():
	pass

func use_terminal():
	pass
#write your logic for student here, also create elevator scene and you can attach a script for this scene
func use_elevator():
	print("Elevator works!")

func use_server():
	pass
	
func _on_player_area_area_entered(area):
	#metoda do rejestrowanie aktualnie area, do ktorej weszlismy
	var area_entered = area.get_name()
	if (area_entered == "FireAlarmArea"):
		can_use_alarm = true
	if (area_entered == "ElevatorArea"):
		can_use_elevator = true

func _on_player_area_area_exited(area):
	#metoda do rejestrowania aktualnie opuszczonej area
	var area_exited = area.get_name()
	if (area_exited == "FireAlarmArea"):
		can_use_alarm = false
	if (area_exited == "ElevatorArea"):
		can_use_elevator = false

func stop_player_movement():
	#metoda do zatrzymania movementu studenta, zbiera aktualna predkosc i przechowuje ja w temp_speed
	temp_speed = $CharacterBody2D.take_current_speed_value()
	$CharacterBody2D.stop_player_movement()


func _on_freeze_timer_timeout():
	#metoda, ktora po skonczeniu timera przywraca stary movement studentowi
	$CharacterBody2D.restore_player_movement(temp_speed)
