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

func _ready():
	set_process_input(true)
	
func _input(event):
	# event do obslugi alarmu przez studenta
	if event.is_action_pressed("use_alarm"):
		var fire_alarm_reference = get_node("../fire_alarm")
		if fire_alarm_reference.useable and can_use_alarm:
			sabotage_alarm()
			fire_alarm_reference.useable = false
			stop_player_movement()
			$CharacterBody2D/FreezeTimer.start()

	# event do obslugi serwera przez studenta
	if event.is_action_pressed("use_server"):
		if can_use_server:
			use_server()
			
	# event do obslugi windy przez studenta
	if event.is_action_pressed("use_elevator"):
		var elevator_reference = get_node("../elevator")
		if can_use_elevator:
			use_elevator()
	
	# event do obslugi boostera przez studenta
	if event.is_action_pressed("use_boost") and not has_booster:
		var booster = get_node("../booster")
		
		if can_use_booster:
			# usuniecie boostera
			booster.on_boost_requested() 
			
			# nadanie boosta
			acquire_booster()

func sabotage_alarm():
	# funkcja do sabotowania alarmu przez studenta
	print("Alarm sabotaged")
	
func use_server():
	# funkcja do uzywania serwera przez studenta
	var serverOpened = get_node("../server")
	if serverOpened.server_opened == false:
		print("server opened")
		serverOpened.server_opened = true
	else:
		print("server closed")
		serverOpened.server_opened = false
	
func use_elevator():
	# funkcja do uzywania windy przez studenta
	print("Elevator works!")
	
func acquire_booster():
	# funkcja nadajaca booster dla studenta
	has_booster = true
	print("Boost taken")
	

func dig():
	pass

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
