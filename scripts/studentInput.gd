extends Node2D
var fourthFloor = load("res://scenes/fourth_floor.tscn")
var thirdFloor = load("res://scenes/level.tscn")
var can_use_alarm : bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna odpalic alarm
var multiplayerId = self.name 
var can_use_server : bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna otworzyc serwer

var can_use_elevator: bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna uzyc windy

var can_use_booster: bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna uzyc boostera

var has_booster: bool = false
# sprawdza czy student posiada booster

var can_use_terminal: bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna uzyc terminalu
var terminal_address

var can_move: bool

var temp_speed
# zmienna przechowujaca tymczasowa predkosc
var body:CharacterBody2D
var _obstacle_to_destroy
var _is_space_pressed = false	
var _dig_speed : float = 0.5

#dfunc _process(_delta):
	#dig()
func _ready():
	set_process_input(true)
	if(multiplayer.get_unique_id()!=1):
		body = get_node_or_null(str(multiplayer.get_unique_id()))
func _input(event):
	# interakcja z obiektami 
	if event.is_action_pressed("interaction"):
		# obsluga alarmu przez studenta
		var fire_alarm_reference = get_node_or_null("../level/fire_alarm")
		if fire_alarm_reference !=null and fire_alarm_reference.useable and can_use_alarm and self.name == str(multiplayer.get_unique_id()):
			sabotage_alarm()
			fire_alarm_reference.useable = false
			change_alarm_state.rpc()

		# obsluga serwera przez studenta
		if can_use_server and self.name == str(multiplayer.get_unique_id()):
			use_server()
			
		# obsluga windy przez studenta
		var elevator_reference = get_node_or_null("../level/elevator")
		if can_use_elevator and self.name == str(multiplayer.get_unique_id()):
			use_elevator()
			
		# obsluga terminalu przez studenta
		if terminal_address != null and self.name == str(multiplayer.get_unique_id()):
			terminal_address.use_terminal()
			
		# obsluga boostera przez studenta
		if can_use_booster and !has_booster and self.name == str(multiplayer.get_unique_id()):
			var booster = get_node_or_null("../level/booster")
			if booster !=null and can_use_booster and self.name == str(multiplayer.get_unique_id()):
				# usuniecie boostera
				removeBooster.rpc()
				# nadanie boosta
				acquire_booster()
	elif event.is_action_pressed("dig") and self.name == str(multiplayer.get_unique_id()):
		dig()
	elif event.is_action_released("dig") and self.name == str(multiplayer.get_unique_id()):
		stop_dig()
@rpc("any_peer","call_remote")
func hide_me(id,isThirdFloor):
	var player = get_node_or_null("../"+str(id))
	if(player != null):
		if isThirdFloor:
			if(self.is_in_group("ThirdFloor")):
				player.visible = true
				player.process_mode = PROCESS_MODE_ALWAYS
			else: 
				player.visible = false
				player.process_mode = PROCESS_MODE_DISABLED
		else:
			if self.is_in_group("FourthFloor"):
				player.visible = true
				player.process_mode = PROCESS_MODE_ALWAYS
			else: 
				player.visible = false
				player.process_mode = PROCESS_MODE_DISABLED
@rpc("any_peer","call_remote")
func change_alarm_state():
	var fire_alarm_reference = get_node_or_null("../level/fire_alarm")
	fire_alarm_reference.useable = false
@rpc("any_peer","call_local")
func removeBooster():
	var booster = get_node_or_null("../level/booster")
	if booster!= null:
		booster.on_boost_requested()
func sabotage_alarm():
	# funkcja do sabotowania alarmu przez studenta
	print("Alarm sabotaged")
	stop_player_movement()
	body.get_node("FreezeTimer").start()
	
func use_server():
	# funkcja do uzywania serwera przez studenta
	var server_reference = get_node_or_null("../level/server")
	if server_reference.server_opened == false:
		print("server opened")
		server_reference.server_opened = true
	else:
		print("server closed")
		server_reference.server_opened = false
	
func use_elevator():
	var fourth = get_node_or_null("../fourthFloor")
	var third = get_node_or_null("../level")
	
	var id = multiplayer.get_unique_id()
	if(fourth != null and third!=null):
		if(fourth.visible == false):
			self.add_to_group("FourthFloor")
			self.remove_from_group("ThirdFloor")
			var fourthFloorPlayers = get_tree().get_nodes_in_group("FourthFloor")
			var thirdFloorPlayers = get_tree().get_nodes_in_group("ThirdFloor")
			for i in fourthFloorPlayers:
				i.visible = true
				i.process_mode = PROCESS_MODE_ALWAYS
			for i in thirdFloorPlayers:
				i.visible = false
				i.process_mode = PROCESS_MODE_DISABLED
			fourth.visible = true
			fourth.process_mode = PROCESS_MODE_ALWAYS
			third.visible = false
			third.process_mode = PROCESS_MODE_DISABLED
			
			hide_me.rpc(id,false)
			
		else:
			self.add_to_group("ThirdFloor")
			self.remove_from_group("FourthFloor")
			var fourthFloorPlayers = get_tree().get_nodes_in_group("FourthFloor")
			var thirdFloorPlayers = get_tree().get_nodes_in_group("ThirdFloor")
			for i in thirdFloorPlayers:
				i.visible = true
				i.process_mode = PROCESS_MODE_ALWAYS
			for i in fourthFloorPlayers:
				i.visible = false
				i.process_mode = PROCESS_MODE_DISABLED
			fourth.visible = false
			fourth.process_mode = PROCESS_MODE_DISABLED
			third.visible = true
			third.process_mode = PROCESS_MODE_ALWAYS
			
			hide_me.rpc(id,true)
func acquire_booster():
	# funkcja nadajaca booster dla studenta
	has_booster = true
	print("Boost taken")
	

	
#metoda usuwa obstacle po przytrzymaniu spacji, jeśli gracz znajduje się blisko przeszkody i jest zwrócony przodem do niej
func dig():
	var _is_facing_obstacle = false
	var obstacles_nearby = body.get_node("PlayerArea").get_overlapping_bodies()
	for obstacle in obstacles_nearby:
		if obstacle.is_in_group("obstacles"):
			_is_facing_obstacle = _is_student_facing_obstacle(obstacle)
			if _is_facing_obstacle:
				_obstacle_to_destroy = obstacle
				if not _is_space_pressed:
					_is_space_pressed = true
					body.get_node("DiggingTimer").wait_time = _dig_speed
					body.get_node("DiggingTimer").start()
		
func stop_dig():
	_is_space_pressed = false
	body.get_node("DiggingTimer").stop()

func _on_player_area_area_entered(area):
	#funkcja do rejestrowanie aktualnie area, do ktorej weszlismy
	var area_entered = area.get_name()
	if (area_entered == "FireAlarmArea" and self.name == str(multiplayer.get_unique_id())):
		can_use_alarm = true

	if (area_entered == "ServerArea" and self.name == str(multiplayer.get_unique_id())):
		can_use_server = true

	if (area_entered == "ElevatorArea" and self.name == str(multiplayer.get_unique_id())):
		can_use_elevator = true
		
	if (area_entered == "BoosterArea" and self.name == str(multiplayer.get_unique_id())):
		can_use_booster = true
		
	if (area_entered == "TerminalArea" and self.name == str(multiplayer.get_unique_id())):
		can_use_terminal = true
		terminal_address = area.get_parent().get_parent()

func _on_player_area_area_exited(area):
	#funkcja  do rejestrowania aktualnie opuszczonej area
	var area_exited = area.get_name()
	if (area_exited == "FireAlarmArea" and self.name == str(multiplayer.get_unique_id())):
		can_use_alarm = false

	if (area_exited == "ServerArea" and self.name == str(multiplayer.get_unique_id())):
		can_use_server = false

	if (area_exited == "ElevatorArea" and self.name == str(multiplayer.get_unique_id())):
		can_use_elevator = false
		
	if (area_exited == "BoosterArea" and self.name == str(multiplayer.get_unique_id())):
		can_use_booster = false
	
	if (area_exited == "TerminalArea" and self.name == str(multiplayer.get_unique_id())):
		can_use_terminal = false
		terminal_address = null

func stop_player_movement():
	#funkcja  do zatrzymania movementu studenta, zbiera aktualna predkosc i przechowuje ja w temp_speed
	temp_speed = body.take_current_speed_value()
	body.stop_player_movement()

func _on_freeze_timer_timeout():
	#funkcja, ktora po skonczeniu timera przywraca stary movement studentowi
	body.restore_player_movement(temp_speed)
	
func _on_digging_timer_timeout():
	#metoda po skończeniu DiggingTimer niszczy obstacle
	if (_obstacle_to_destroy != null):
		remove_obstacle.rpc(_obstacle_to_destroy.get_parent().name)
		_obstacle_to_destroy = null
@rpc("any_peer","call_local")
func remove_obstacle(_obstacle_to_destroy):
	var obstacle = get_node_or_null("../fourthFloor/"+_obstacle_to_destroy)
	if obstacle:
		obstacle.queue_free()
func _is_student_facing_obstacle(obstacle):
	#metoda sprawdza czy student jest zwrócony w strone przeszkody
	
	var obstacle_position = obstacle.global_position
	var student_position = body.global_position
	var student_direction = body.last_direction

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
