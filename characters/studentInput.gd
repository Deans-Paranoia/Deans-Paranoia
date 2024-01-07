## Klasa rozszerza Node2D, co oznacza, że jest to węzeł 2D w strukturze sceny.

extends Node2D

## Sygnał emitowany, gdy gracz otrzymuje nowe zadanie. Parametr task_type określa typ zadania.
signal player_task(task_type: String)

## Sygnał emitowany w celu wyłączenia ruchu gracza na określony czas. Parametr duration określa długość wyłączenia.
signal disable_player_movement_for_duration(duration: float)

## Gotowa zmienna przechowująca instancję sceny dig_and_dean_catch_info, która będzie używana do wyświetlania informacji o kopaniu i złapaniu przez dziekana.
@onready var dig_info_instance = load("res://ui/dig_and_dean_catch_info.tscn").instantiate()

## Sygnał używany do uruchomienia czatu. Parametr name określa nazwę czatu.
signal use_chat(name)

## Sygnał używany do wyjścia z czatu. Parametr name określa nazwę czatu.
signal exit_chat(name)

## Zmienna przechowująca aktualną strefę zadania gracza. Pusty string, jeśli gracz nie wykonuje zadania.
var current_task_area = "" # pusty string jesli gracz nie w tasku

## Gotowa zmienna przechowująca scenę czwartego piętra.
var fourthFloor = load("res://map/fourth_floor.tscn")

## Gotowa zmienna przechowująca scenę trzeciego piętra.
var thirdFloor = load("res://map/level.tscn")

## Gotowa zmienna przechowująca scenę informującą o wyjściu z zadania.
var dangerScene = preload("res://ui/task_exited.tscn")

## Zmienna do przypisania instancji sceny dangerScene.
var danger_instance

## Flaga określająca, czy zadanie gracza zostało zakończone.
var task_finished = true

## Flaga określająca, czy student może zostać złapany przez dziekana.
var catchable: bool = false

## Flaga określająca, czy student został już złapany.
var is_catched : bool = false

## Flaga określająca, czy gracz znajduje się w strefie, gdzie można aktywować alarm.
var can_use_alarm : bool = false

## Identyfikator wieloosobowy gracza.
var multiplayerId = self.name 

## Flaga określająca, czy gracz znajduje się w strefie, gdzie można użyć serwera.
var can_use_server : bool = false

## Flaga określająca, czy gracz może ponownie użyć serwera.
var can_use_server_again : bool = true

## Zmienna przechowująca poziom gracza.
var level: int = 3

## Flaga określająca, czy gracz znajduje się w strefie, gdzie można użyć windy.
var can_use_elevator: bool = false

## Flaga określająca, czy gracz znajduje się w strefie, gdzie można użyć boostera.
var can_use_booster: bool = false

## Flaga określająca, czy student posiada boostera.
var has_booster: bool = false

## Flaga określająca, czy gracz znajduje się w strefie, gdzie można użyć terminalu.
var can_use_terminal: bool = false

## Adres terminalu, który gracz może użyć.
var terminal_address

## Referencja do obiektu obsługującego alarm przeciwpożarowy.
var fire_alarm_reference;

## Zmienna przechowująca tymczasową prędkość.
var temp_speed

## Referencja do ciała postaci (CharacterBody2D).
var body:CharacterBody2D

## Zmienna do przechowywania przeszkody do zniszczenia.
var _obstacle_to_destroy

## Flaga określająca, czy klawisz Spacji jest wciśnięty.
var _is_space_pressed = false	

## Prędkość kopania.
var _dig_speed : float = 1


#dfunc _process(_delta):
	#dig()
## Ta funkcja jest wywoływana w każdej klatce gry, służy do aktualizacji elementów gry.
func _ready():
	dig_info_instance.visible = false
	get_node("UI/UIContainer").add_child(dig_info_instance)
	set_process_input(true)
	if(multiplayer.get_unique_id()!=1):
		body = get_node_or_null(str(self))
	use_chat.connect(get_tree().root.get_node("Map/Chat")._on_student_use_chat)
	exit_chat.connect(get_tree().root.get_node("Map/Chat")._on_student_exit_chat)

## Ta funkcja obsługuje wejście użytkownika, np. naciśnięcie klawisza czy ruch myszką.
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

## Ta funkcja obsługuje włączanie alarmu przeciwpożarowego.
@rpc("any_peer","call_remote")
func change_alarm_state():
	var fire_alarm_reference = get_node_or_null("../thirdFloor/fire_alarm")
	fire_alarm_reference.use_alarm(true)

## Ta funkcja usuwa boostera z gry, jeśli istnieje.
@rpc("any_peer","call_local")
func removeBooster():
	var booster = get_node_or_null("../thirdFloor/booster")
	if booster!= null:
		booster.on_boost_requested()

## funkcja do sabotowania alarmu przez studenta, zatrzymuje na chwile ruch gracza
func sabotage_alarm():
	print("Alarm sabotaged")
	stop_player_movement()
	body.get_node("FreezeTimer").start()

## Funkcja do wykonywania taska przez studenta, wysyła sygnał w jakiej area 
## znajduje sie gracz.
func task_execution():
	player_task.emit(current_task_area)
	disable_player_movement_for_duration.emit(1.0) # zatrzymanie ruchu gracza na 1s
	task_finished = false
	await get_tree().create_timer(2.0).timeout
	task_finished = true
	
## Fukcja służąca do łapania studenta, jeśli da się złapać studenta 
## łapie go i zatrzymuje mu ruch.
@rpc("any_peer","call_remote")
func catch_student():
	if catchable and !is_catched:
		is_catched = true
		stop_player_movement()
		change_is_catched.rpc()
	
## Funkcja do uzywania serwera przez studenta, sprawdza czy
## wpisany kod jest poprawny.
func use_server():
		var serverNode = get_node_or_null("../fourthFloor/server")
		var czyPoprawnyKod : bool = serverNode.calculate_value()
		if czyPoprawnyKod == false:
			print("Błędny kod")
			can_use_server_again = false
			body.get_node("ServerTimer").wait_time = 5
			body.get_node("ServerTimer").start()


## Funkcja do używania windy, przenosi gracza na odpowiednie piętro, bierze 
## pod uwagę z której strony gracz wsiada do windy.
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

## Funkcja nadajaca booster dla studenta.
func acquire_booster():
	has_booster = true
	_dig_speed = 0.6
	print("Boost taken, current dig speed: ",_dig_speed)
	

## Teleportuje gracza o wybrane położenie w zmiennej ammount
@rpc("any_peer","call_local")
func teleport(ammount):
	self.global_position.x += ammount

## Wyszukuje przeszkody w pobliżu i uruchamia kopanie, jeśli gracz 
## jest skierowany w stronę przeszkody i nie naciśnięto przycisku spacji.
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
		
## Zatrzymuje proces kopania i wyłącza związany z nim timer.
func stop_dig():
	_is_space_pressed = false
	body.get_node("DiggingTimer").stop()
		
## Rejestruje, gdy gracz wchodzi do określonego obszaru, umożliwiając korzystanie 
## z różnych funkcji w zależności od obszaru.
func _on_player_area_area_entered(area):
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
		
## Rejestruje, gdy gracz opuszcza obszar, wyłączając dostęp do funkcji powiązanych z tym obszarem.
func _on_player_area_area_exited(area):
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
		
## funkcja zdalna zmieniająca stan zmiennej catchable.
@rpc("any_peer","call_remote")
func change_catchable(boolean):
	catchable = boolean
	
## funkcja zdalna zmieniająca stan zmiennej is_catched na true.
@rpc("any_peer","call_remote")
func change_is_catched():
	is_catched = true
## funkcja  do zatrzymania movementu studenta, zbiera aktualna predkosc 
## i przechowuje ja w temp_speed
func stop_player_movement():
	temp_speed = body.take_current_speed_value()
	body.stop_player_movement()

## funkcja, ktora po skonczeniu timera przywraca stary movement studentowi
func _on_freeze_timer_timeout():
	fire_alarm_reference.useable = false
	change_alarm_state.rpc()
	body.restore_player_movement(temp_speed)
	
## metoda po skończeniu DiggingTimer niszczy obstacle
func _on_digging_timer_timeout():
	if (_obstacle_to_destroy != null):
		
		remove_obstacle.rpc(_obstacle_to_destroy.get_parent().name)
		_obstacle_to_destroy = null
		
## funkcja, ktora po skonczeniu timera przywraca mozliwosc ponownego uzycia servera
func _on_server_timer_timeout():
	can_use_server_again = true

## jesli przekazany obiekt istnieje to funkcja go usuwa
@rpc("any_peer","call_local")
func remove_obstacle(_obstacle_to_destroy):
	var obstacle = get_node_or_null("../fourthFloor/Obstacles/"+_obstacle_to_destroy)
	if obstacle:
		obstacle.queue_free()
		
## metoda sprawdza czy student jest zwrócony w strone przeszkody
func _is_student_facing_obstacle(obstacle):
	
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
