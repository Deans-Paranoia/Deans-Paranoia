extends Node2D

var can_use_alarm : bool = false

# sprawdza czy znajduje sie w strefie gdzie mozna odpalic alarm

var can_use_server : bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna otworzyc serwer
var can_move: bool
var has_booster: bool = false

var can_use_elevator: bool = false
# Zmienna pomocna w kontroli położenia gracza w obszarze użycia któregoś z powyższych obiektów

var temp_speed

func _ready():
	set_process_input(true)
	
func _process(_delta):
	if Input.is_action_just_pressed("use_alarm"):
		var fire_alarm_reference = get_node("../fire_alarm")
		if fire_alarm_reference.useable and can_use_alarm:
			sabotage_alarm()
			fire_alarm_reference.useable = false
			stop_player_movement()
			$CharacterBody2D/FreezeTimer.start()

	if Input.is_action_just_pressed("use_server"):
		if can_use_server:
			use_server()
			

	if Input.is_action_just_pressed("use_elevator"):
		var elevator_reference = get_node("../elevator")
		if can_use_elevator:
			use_elevator()


func _input(event):
	
	if event.is_action_pressed("use_boost") and not has_booster:
		var booster = get_node("../booster")
		
		# sprawdzenie czy gracz w pobliżu boostera, jesli tak to daje boosta
		var distance = $CharacterBody2D.global_position.distance_to(booster.global_position)

		if distance < 50.0:
			booster.on_boost_requested() # usuniecie boostera
			
			# boost
			acquire_booster()

#write your logic for student here, also create booster scene and you can attach a script for this scene
func acquire_booster():
	has_booster = true
	print("Boost taken")
	
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
	var serverOpened = get_node("../server")
	if serverOpened.server_opened == false:
		print("server opened")
		serverOpened.server_opened = true
	else:
		print("server closed")
		serverOpened.server_opened = false
	
func _on_player_area_area_entered(area):
	#metoda do rejestrowanie aktualnie area, do ktorej weszlismy
	var area_entered = area.get_name()
	if (area_entered == "FireAlarmArea"):
		can_use_alarm = true

	if (area_entered == "ServerArea"):
		can_use_server = true

	if (area_entered == "ElevatorArea"):
		can_use_elevator = true


func _on_player_area_area_exited(area):
	#metoda do rejestrowania aktualnie opuszczonej area
	var area_exited = area.get_name()
	if (area_exited == "FireAlarmArea"):
		can_use_alarm = false

	if (area_exited == "ServerArea"):
		can_use_server = false

	if (area_exited == "ElevatorArea"):
		can_use_elevator = false


func stop_player_movement():
	#metoda do zatrzymania movementu studenta, zbiera aktualna predkosc i przechowuje ja w temp_speed
	temp_speed = $CharacterBody2D.take_current_speed_value()
	$CharacterBody2D.stop_player_movement()


func _on_freeze_timer_timeout():
	#metoda, ktora po skonczeniu timera przywraca stary movement studentowi
	$CharacterBody2D.restore_player_movement(temp_speed)
