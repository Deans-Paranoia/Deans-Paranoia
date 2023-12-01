extends Node2D

var can_use_alarm : bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna odpalic alarm

var can_use_server : bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna otworzyc serwer

var can_use_elevator: bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna uzyc windy

var can_use_booster: bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna uzyc boostera

var has_booster: bool = false
# sprawdza czy student posiada booster

var can_move: bool

var temp_speed
# zmienna przechowujaca tymczasowa predkosc

var _obstacle_to_destroy
var _is_space_pressed = false	
var _dig_speed : float = 0.5

#dfunc _process(_delta):
	#dig()
func _ready():
	set_process_input(true)
	
func _input(event):
	# interakcja z obiektami 
	if event.is_action_pressed("interaction"):
		# obsluga alarmu przez studenta
		var fire_alarm_reference = get_node("../fire_alarm")
		if fire_alarm_reference !=null and fire_alarm_reference.useable and can_use_alarm:
			sabotage_alarm()
			fire_alarm_reference.useable = false
			stop_player_movement()
			$CharacterBody2D/FreezeTimer.start()

		# obsluga serwera przez studenta
		if can_use_server:
			use_server()
			
		# obsluga windy przez studenta
		var elevator_reference = get_node("../elevator")
		if can_use_elevator:
			use_elevator()
		
		# obsluga boostera przez studenta
		if can_use_booster and !has_booster:
			var booster = get_node("../booster")
		
			if can_use_booster:
				# usuniecie boostera
				booster.on_boost_requested() 
			
				# nadanie boosta
				acquire_booster()
	elif event.is_action_pressed("dig"):
		dig()
	elif event.is_action_released("dig"):
		stop_dig()
		

func sabotage_alarm():
	# funkcja do sabotowania alarmu przez studenta
	print("Alarm sabotaged")
	
func use_server():
	# funkcja do uzywania serwera przez studenta
	var server_reference = get_node("../server")
	if server_reference.server_opened == false:
		print("server opened")
		server_reference.server_opened = true
	else:
		print("server closed")
		server_reference.server_opened = false
	
func use_elevator():
	# funkcja do uzywania windy przez studenta
	print("Elevator works!")
	
func acquire_booster():
	# funkcja nadajaca booster dla studenta
	has_booster = true
	print("Boost taken")
	

	
#metoda usuwa obstacle po przytrzymaniu spacji, jeśli gracz znajduje się blisko przeszkody i jest zwrócony przodem do niej
func dig():
	var _is_facing_obstacle = false
	var obstacles_nearby = $CharacterBody2D/PlayerArea.get_overlapping_bodies()
	for obstacle in obstacles_nearby:
		if obstacle.is_in_group("obstacles"):
			_is_facing_obstacle = _is_student_facing_obstacle(obstacle)
			if _is_facing_obstacle:
				_obstacle_to_destroy = obstacle
				if not _is_space_pressed:
					_is_space_pressed = true
					$CharacterBody2D/DiggingTimer.wait_time = _dig_speed
					$CharacterBody2D/DiggingTimer.start()
		
func stop_dig():
	_is_space_pressed = false
	$CharacterBody2D/DiggingTimer.stop()
func use_terminal():
	pass

func _on_player_area_area_entered(area):
	#funkcja do rejestrowanie aktualnie area, do ktorej weszlismy
	var area_entered = area.get_name()
	if (area_entered == "FireAlarmArea"):
		can_use_alarm = true

	if (area_entered == "ServerArea"):
		can_use_server = true

	if (area_entered == "ElevatorArea"):
		can_use_elevator = true
		
	if (area_entered == "BoosterArea"):
		can_use_booster = true

func _on_player_area_area_exited(area):
	#funkcja  do rejestrowania aktualnie opuszczonej area
	var area_exited = area.get_name()
	if (area_exited == "FireAlarmArea"):
		can_use_alarm = false

	if (area_exited == "ServerArea"):
		can_use_server = false

	if (area_exited == "ElevatorArea"):
		can_use_elevator = false
		
	if (area_exited == "BoosterArea"):
		can_use_elevator = false

func stop_player_movement():
	#funkcja  do zatrzymania movementu studenta, zbiera aktualna predkosc i przechowuje ja w temp_speed
	temp_speed = $CharacterBody2D.take_current_speed_value()
	$CharacterBody2D.stop_player_movement()

func _on_freeze_timer_timeout():
	#funkcja, ktora po skonczeniu timera przywraca stary movement studentowi
	$CharacterBody2D.restore_player_movement(temp_speed)
	
func _on_digging_timer_timeout():
	#metoda po skończeniu DiggingTimer niszczy obstacle
	if (_obstacle_to_destroy != null):
		_obstacle_to_destroy.queue_free()
		_obstacle_to_destroy = null

func _is_student_facing_obstacle(obstacle):
	#metoda sprawdza czy student jest zwrócony w strone przeszkody
	
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

