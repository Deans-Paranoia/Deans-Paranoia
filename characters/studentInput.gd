extends Node2D

signal player_task(task_type: String)
signal disable_player_movement_for_duration(duration: float)
@onready var dig_info_instance = load("res://ui/dig_and_dean_catch_info.tscn").instantiate()
signal use_chat(name)
signal exit_chat(name)
var current_task_area = "" # pusty string jesli gracz nie w tasku
var fourthFloor = load("res://map/fourth_floor.tscn")
var thirdFloor = load("res://map/level.tscn")

@onready var action_instance = load("res://ui/action_info.tscn").instantiate()
var label_energizer
var label_alarm_sabotage

var dangerScene = preload("res://ui/task_exited.tscn")
var danger_instance
# pusta zmienna do ktorej przypisywana jest instancja sceny
var task_finished = true
var catchable: bool = false
# sprawdza czy student moze zostac zlapany przez dziekana

var is_catched : bool = false
# sprawdza czy student zostal juz zlapany

var can_use_alarm : bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna odpalic alarm
var multiplayerId = self.name 
var can_use_server : bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna uzyc serwer
var can_use_server_again : bool = true
# sprawdza czy gracz moze juz ponownie uzyc servera

var level: int = 3

var can_use_elevator: bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna uzyc windy

var can_use_booster: bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna uzyc boostera

var has_booster: bool = false
# sprawdza czy student posiada booster

var can_use_terminal: bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna uzyc terminalu
var terminal_address

var fire_alarm_reference;

var temp_speed
# zmienna przechowujaca tymczasowa predkosc
var body:CharacterBody2D
var _obstacle_to_destroy
var _is_space_pressed = false	
var _dig_speed : float = 1

#dfunc _process(_delta):
	#dig()
func _ready():
	label_alarm_sabotage = action_instance.get_node("Control/VBoxContainer/LabelAlarmSabotage")
	label_energizer = action_instance.get_node("Control/VBoxContainer/LabelEnergizer")
	get_tree().root.add_child(action_instance)
	dig_info_instance.visible = false
	get_node("UI/UIContainer").add_child(dig_info_instance)
	set_process_input(true)
	if(multiplayer.get_unique_id()!=1):
		body = get_node_or_null(str(self))
	use_chat.connect(get_tree().root.get_node("Map/Chat")._on_student_use_chat)
	exit_chat.connect(get_tree().root.get_node("Map/Chat")._on_student_exit_chat)
func _input(event):
	if event.is_action_pressed("use_chat") and self.name == str(multiplayer.get_unique_id()):
		use_chat.emit(self.name)
	if event.is_action_pressed("exit_chat") and self.name == str(multiplayer.get_unique_id()):
		exit_chat.emit(self.name)
	if body!= null and body.can_move == false:
		return
	# interakcja z obiektami 
	if event.is_action_pressed("interaction"):
		# obsluga alarmu przez studenta
		fire_alarm_reference = get_node_or_null("../thirdFloor/fire_alarm")
		if fire_alarm_reference !=null and fire_alarm_reference.useable and can_use_alarm and self.name == str(multiplayer.get_unique_id()):
			sabotage_alarm()

		# obsluga serwera przez studenta
		if can_use_server and can_use_server_again and self.name == str(multiplayer.get_unique_id()):
			use_server()
			
		# obsluga windy przez studenta
		var elevatorsThird = get_tree().get_nodes_in_group("elevator")
		var elevatorsFourth = get_tree().get_nodes_in_group("elevatorFourth")
		if can_use_elevator and self.name == str(multiplayer.get_unique_id()):
			if level == 3:
				if (abs(body.global_position - elevatorsThird[1].global_position) < abs(body.global_position - elevatorsThird[0].global_position)):
					use_elevator("left")
				else:
					use_elevator("right")
				level = 4
			elif level == 4:
				if (abs(body.global_position - elevatorsFourth[1].global_position) < abs(body.global_position - elevatorsFourth[0].global_position)):
					use_elevator("left")
				else:
					use_elevator("right")
				level = 3
				
			
			
		# obsluga terminalu przez studenta
		if terminal_address != null and self.name == str(multiplayer.get_unique_id()):
			terminal_address.use_terminal()
			terminal_address.use_terminal.rpc()
			
		# obsluga boostera przez studenta
		if can_use_booster and !has_booster and self.name == str(multiplayer.get_unique_id()):
			var booster = get_node_or_null("../thirdFloor/booster")
			if booster !=null and can_use_booster and self.name == str(multiplayer.get_unique_id()):
				# usuniecie boostera
				removeBooster.rpc()
				# nadanie boosta
				acquire_booster()
				
		# wykonanie taska przez studenta	
		if not danger_instance and current_task_area != "" and current_task_area != "walking" and task_finished:
			task_execution()
			
	elif event.is_action_pressed("dig") and self.name == str(multiplayer.get_unique_id()):
		dig()
	elif event.is_action_released("dig") and self.name == str(multiplayer.get_unique_id()):
		stop_dig()
		
	

@rpc("any_peer","call_remote")
func change_alarm_state():
	var fire_alarm_reference = get_node_or_null("../thirdFloor/fire_alarm")
	fire_alarm_reference.use_alarm(true)
@rpc("any_peer","call_local")
func removeBooster():
	var booster = get_node_or_null("../thirdFloor/booster")
	if booster!= null:
		booster.on_boost_requested()
func sabotage_alarm():
	# funkcja do sabotowania alarmu przez studenta
	print("Alarm sabotaged")
	stop_player_movement()
	body.get_node("FreezeTimer").start()
	change_actionInfo_label_visibility.rpc("alarm")
	change_actionInfo_label_visibility("alarm")
func task_execution():
	# funkcja do wykonywania taska przez studenta
	player_task.emit(current_task_area)
	disable_player_movement_for_duration.emit(1.0) # zatrzymanie ruchu gracza na 1s
	task_finished = false
	await get_tree().create_timer(2.0).timeout
	task_finished = true
	
@rpc("any_peer","call_remote")
func catch_student():
	if catchable and !is_catched:
		is_catched = true
		stop_player_movement()
		change_is_catched.rpc()
    body.get_node("AnimationTree")._on_student_catched()

@rpc("any_peer","call_remote")
func change_actionInfo_label_visibility(action):
	if (action == "alarm"): 
		await get_tree().create_timer(2.0).timeout
		label_alarm_sabotage.visible = true
		await get_tree().create_timer(3.5).timeout
		label_alarm_sabotage.visible = false
	else:
		label_energizer.visible = true
		await get_tree().create_timer(3.5).timeout
		label_energizer.visible = false

func use_server():
	# funkcja do uzywania serwera przez studenta
		var serverNode = get_node_or_null("../fourthFloor/server")
		var czyPoprawnyKod : bool = serverNode.calculate_value()
		if czyPoprawnyKod == false:
			print("Błędny kod")
			can_use_server_again = false
			body.get_node("ServerTimer").wait_time = 5
			body.get_node("ServerTimer").start()

	
func use_elevator(side):
	var fourth = get_node_or_null("../fourthFloor")
	var third = get_node_or_null("../thirdFloor")
	if(fourth != null and third!=null):
		if(self.is_in_group("ThirdFloor")):
			self.add_to_group("FourthFloor")
			self.remove_from_group("ThirdFloor")
			dig_info_instance.visible = true
			danger_instance.queue_free()
		
			fourth.visible = true
			third.visible = false
			if (side == "left"):
				body.global_position = Vector2(2970, -800)
			elif (side == "right"):
				body.global_position = Vector2(4283, -800)
				

		else:
			self.add_to_group("ThirdFloor")
			self.remove_from_group("FourthFloor")
			dig_info_instance.visible = false
			fourth.visible = false
			third.visible = true
			danger_instance = dangerScene.instantiate()
			add_child(danger_instance)
			if (side == "left"):
				body.global_position = Vector2(-40, -830)
			elif (side == "right"):
				body.global_position = Vector2(1250, -847)
func acquire_booster():
	# funkcja nadajaca booster dla studenta
	has_booster = true
	_dig_speed = 0.6
	print("Boost taken, current dig speed: ",_dig_speed)
	change_actionInfo_label_visibility("energizer")
	change_actionInfo_label_visibility.rpc("energizer")

@rpc("any_peer","call_local")
func teleport(ammount):
	self.global_position.x += ammount

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
		
	if (area_entered == "VendingMachine1Area" and self.name == str(multiplayer.get_unique_id()) and danger_instance):
		if danger_instance != null:
			danger_instance.queue_free()
		change_catchable(false)
		change_catchable.rpc(false)
		current_task_area = "vendingMachine1"
		
	if (area_entered == "VendingMachine2Area" and self.name == str(multiplayer.get_unique_id()) and danger_instance):
		if danger_instance != null:
			danger_instance.queue_free()
		change_catchable(false)
		change_catchable.rpc(false)
		current_task_area = "vendingMachine2"
		
	if (area_entered == "ComputersArea" and self.name == str(multiplayer.get_unique_id()) and danger_instance):
		if danger_instance != null:
			danger_instance.queue_free()
		change_catchable(false)
		change_catchable.rpc(false)
		current_task_area = "computer"
		
	if (area_entered == "NotesArea" and self.name == str(multiplayer.get_unique_id()) and danger_instance):
		if danger_instance != null:
			danger_instance.queue_free()
		change_catchable(false)
		change_catchable.rpc(false)
		current_task_area = "takingNotes"
		
	if (area_entered == "WalkingArea" and self.name == str(multiplayer.get_unique_id()) and danger_instance):
		if danger_instance != null:
			danger_instance.queue_free()
		change_catchable(false)
		change_catchable.rpc(false)
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
	if (area_exited == "VendingMachine1Area" and self.name == str(multiplayer.get_unique_id())):
		danger_instance = dangerScene.instantiate()
		add_child(danger_instance)
		change_catchable(true)
		change_catchable.rpc(true)
		current_task_area = ""
		
	if (area_exited == "VendingMachine2Area" and self.name == str(multiplayer.get_unique_id())):
		danger_instance = dangerScene.instantiate()
		add_child(danger_instance)
		change_catchable(true)
		change_catchable.rpc(true)
		current_task_area = ""
		
	if (area_exited == "ComputersArea" and self.name == str(multiplayer.get_unique_id())):
		danger_instance = dangerScene.instantiate()
		add_child(danger_instance)
		change_catchable(true)
		change_catchable.rpc(true)
		current_task_area = ""
		
	if (area_exited == "NotesArea" and self.name == str(multiplayer.get_unique_id())):
		danger_instance = dangerScene.instantiate()
		add_child(danger_instance)
		change_catchable(true)
		change_catchable.rpc(true)
		current_task_area = ""
		
	if (area_exited == "WalkingArea" and self.name == str(multiplayer.get_unique_id())):
		danger_instance = dangerScene.instantiate()
		add_child(danger_instance)
		change_catchable(true)
		change_catchable.rpc(true)
@rpc("any_peer","call_remote")
func change_catchable(boolean):
	catchable = boolean
@rpc("any_peer","call_remote")
func change_is_catched():
	is_catched = true
func stop_player_movement():
	#funkcja  do zatrzymania movementu studenta, zbiera aktualna predkosc i przechowuje ja w temp_speed
	temp_speed = body.take_current_speed_value()
	body.stop_player_movement()

func _on_freeze_timer_timeout():
	#funkcja, ktora po skonczeniu timera przywraca stary movement studentowi
	fire_alarm_reference.useable = false
	change_alarm_state.rpc()
	body.restore_player_movement(temp_speed)
	
func _on_digging_timer_timeout():
	#metoda po skończeniu DiggingTimer niszczy obstacle
	if (_obstacle_to_destroy != null):
		
		remove_obstacle.rpc(_obstacle_to_destroy.get_parent().name)
		_obstacle_to_destroy = null
		
func _on_server_timer_timeout():
	# metoda, ktora po skonczeniu timera przywraca mozliwosc ponownego uzycia servera
	can_use_server_again = true

@rpc("any_peer","call_local")
func remove_obstacle(_obstacle_to_destroy):
	var obstacle = get_node_or_null("../fourthFloor/Obstacles/"+_obstacle_to_destroy)
	if obstacle:
		obstacle.queue_free()
func _is_student_facing_obstacle(obstacle):
	#metoda sprawdza czy student jest zwrócony w strone przeszkody
	
	var obstacle_position = obstacle.global_position
	var student_position = body.global_position
	var student_direction = body.last_direction

	#Obliczamy wektor skierowany znormalizowany
	var direction_to_obstacle = (obstacle_position - student_position).normalized()
	if direction_to_obstacle.x < -0.86 and student_direction == Vector2(-1,0):
		return true
	elif direction_to_obstacle.x > 0.86 and student_direction == Vector2(1,0):
		return true
	elif direction_to_obstacle.y < -0.91 and student_direction == Vector2(0,-1):
		return true
	elif direction_to_obstacle.y > 0.8 and student_direction == Vector2(0,1):
		return true
	else:
		return false


	


