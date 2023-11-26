extends Node2D

var can_use_alarm : bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna odpalic alarm

var has_booster: bool

var temp_speed

var obstacle_instance = null

func _process(_delta):
	dig()
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
	pass
	
#write your logic for student here, also create obstacle scene and you can attach a script for this scene
func dig():
	if Input.is_action_pressed("dig") and obstacle_instance != null:
		if _is_student_facing_obstacle(obstacle_instance):
			$CharacterBody2D/DiggingTimer.start()

func use_terminal():
	pass

func use_elevator():
	pass

func use_server():
	pass
	
func _on_player_area_area_entered(area):
	#metoda do rejestrowanie aktualnie area, do ktorej weszlismy
	var area_entered = area.get_name()
	if (area_entered == "FireAlarmArea"):
		can_use_alarm = true

func _on_player_area_area_exited(area):
	#metoda do rejestrowania aktualnie opuszczonej area
	var area_exited = area.get_name()
	if (area_exited == "FireAlarmArea"):
		can_use_alarm = false

func stop_player_movement():
	#metoda do zatrzymania movementu studenta, zbiera aktualna predkosc i przechowuje ja w temp_speed
	temp_speed = $CharacterBody2D.take_current_speed_value()
	$CharacterBody2D.stop_player_movement()

func _on_freeze_timer_timeout():
	#metoda, ktora po skonczeniu timera przywraca stary movement studentowi
	$CharacterBody2D.restore_player_movement(temp_speed)
	
func _on_digging_timer_timeout():
	#metoda po skończeniu DiggingTimer niszczy obstacle
	obstacle_instance.destroy_obstacle()
	
func _on_student_entered_obstacle_area(obstacle):
	#metoda przechwytuje sygnał wysłany przez obstacle jeśli student się zbliży do przeszkody
	obstacle_instance = obstacle
	
func _on_student_exited_obstacle_area(body):
	#metoda przechwytuje sygnał wysłany przez obstacle jeśli student się oddali do przeszkody
	obstacle_instance = null

func _is_student_facing_obstacle(obstacle):
	#metoda sprawdza czy student jest zwrócony w strone obstacle
	
	var obstacle_position = obstacle.global_position
	var student_position = $CharacterBody2D.global_position
	var student_direction = $CharacterBody2D.last_direction

	#Obliczamy wektor skierowany znormalizowany
	var direction_to_obstacle = (obstacle_position - student_position).normalized()

	if direction_to_obstacle.x < -0.95 and student_direction == Vector2(-1,0):
		return true
	elif direction_to_obstacle.x > 0.95 and student_direction == Vector2(1,0):
		return true
	elif direction_to_obstacle.y < -0.95 and student_direction == Vector2(0,-1):
		return true
	elif direction_to_obstacle.y > 0.95 and student_direction == Vector2(0,1):
		return true
	else:
		return false

