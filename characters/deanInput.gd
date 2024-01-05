## Klasa Dean - skrypt obsługujący postać dziekana w grze.

extends Node2D

## Sygnał informujący o wybraniu studenta.
signal student_picked()

## Sygnał informujący o złapaniu studenta. Przekazuje nazwę złapanego studenta.
signal student_catched(name)

## Instancja widżetu odpowiadającego za informacje o złapaniu studenta.
@onready var catch_info_instance = load("res://ui/dig_and_dean_catch_info.tscn").instantiate()

## Flaga określająca, czy tablet dziekana jest otwarty.
var is_tablet_open: bool = false

## Gotowy widget sceny tabletu.
@onready var scene = load("res://ui/deans_tablet/deans_tablet.tscn")

## Scena tabletu.
var tablet_scene

## Zmienna określająca, czy dziekan znajduje się w obszarze zadania.
var is_task_area 

## Referencja do ciała postaci.
var body: CharacterBody2D

## Flaga określająca, czy Dean może aktywować alarm przeciwpożarowy.
var can_use_alarm : bool = false

func _ready():
	## Parametry: None
	## Return: None
	## Funkcja wywoływana przy inicjalizacji obiektu.
	var hall = get_tree().root.get_node("Map/lecture_hall")
	body = get_node_or_null(str(self.name))
	
	# Dodanie połączeń sygnałów z salą wykładową w przypadku, gdy jesteśmy dziekanem.
	if globalScript.deanId == multiplayer.get_unique_id() and get_parent().name != "lecture_hall":
		student_picked.connect(hall.on_student_moved)
		student_catched.connect(hall.on_student_catched)
		catch_info_instance.visible = false
		catch_info_instance.get_node("dean_catch_and_dig_info/Label").text = "Złap"
		get_node("UI/UIContainer").add_child(catch_info_instance)

func _input(event):
	## Parametry: None
	## Return: None
	## Funkcja obsługująca wejścia z klawiatury i myszy.

	# Obsługa otwierania tabletu przez dziekana.
	if event.is_action_pressed("open_tablet"):
		if self.name == str(multiplayer.get_unique_id()):
			manage_deans_tablet()
	
	# Obsługa wyboru studenta przez dziekana.
	if event.is_action_pressed("kick_student"):
		if self.name == str(multiplayer.get_unique_id()) and body.can_move == false:
			student_picked.emit()

	if body!= null and body.can_move == false:
		return

	# Obsługa interakcji z obiektami przez dziekana.
	if event.is_action_pressed("interaction"):
		# Obsługa aktywacji alarmu.
		if self.name == str(multiplayer.get_unique_id()):
			var fire_alarm_reference = get_node_or_null("../thirdFloor/fire_alarm")
			if fire_alarm_reference and fire_alarm_reference.useable and can_use_alarm and self.name == str(multiplayer.get_unique_id()):
				change_alarm_state.rpc()
	
	# Obsługa łapania studenta.
	if event.is_action_pressed("catch_student"):
		if self.name == str(multiplayer.get_unique_id()):
			var catchable_objects = get_tree().get_nodes_in_group("Catchable_Students")
			for catchable_object in catchable_objects:
				if catchable_object.catchable and catchable_object.is_catched ==false:
					var student_id = str(catchable_object.name)
					catchable_object.catch_student.rpc_id(int(student_id))
					print("catched")
					#print(globalScript.Players[])
					student_catched.emit(globalScript.Players[int(student_id)].fakeName)

@rpc("any_peer","call_remote")
func change_alarm_state():
	## Parametry: None
	## Return: None
	## Funkcja zdalna obsługująca zmianę stanu alarmu przeciwpożarowego.
	var fire_alarm_reference = get_node_or_null("../thirdFloor/fire_alarm")
	if fire_alarm_reference:
		fire_alarm_reference.use_alarm(false)

func manage_deans_tablet():
	## Parametry: None
	## Return: None
	## Funkcja zarządzająca widżetem tabletu dziekana.
	# Obsługa otwierania i zamykania tabletu przez dziekana.
	match is_tablet_open:
		false:
			if get_tree().root.get_node_or_null("DeansTablet")==null:
				tablet_scene = scene.instantiate()
				get_tree().root.add_child(tablet_scene)
			tablet_scene.visible = true
			is_tablet_open = true
		true:
			tablet_scene.visible = false
			is_tablet_open = false

func catch_student():
	## Funkcja placeholder do obsługi złapanego studenta.
	pass

func kick_student():
## Funkcja placeholder do obsługi kopnięcia studenta.
	pass

func _on_area_2d_area_entered(area):
	## Parametry: area - obszar który może wchodzić w interakcje z graczem
	## Return: None
	## Funkcja wywoływana po wejściu w obszar 2D.
	# Rejestracja aktualnie odwiedzonej strefy.
	var area_entered = area.get_name()
	if (area_entered == "FireAlarmArea"):
		can_use_alarm = true
	else:
		if (area_entered == "TerminalArea" or area_entered == "VendingMachine1Area" or area_entered == "VendingMachine2Area" or area_entered == "ComputersArea" or area_entered == "NotesArea"  or area_entered == "WalkingArea"):
			is_task_area = true
			catch_info_instance.visible = false

## Funkcja wywoływana po opuszczeniu obszaru 2D.
func _on_area_2d_area_exited(area):
	## Parametry: area - obszar który może wchodzić w interakcje z graczem
	## Return: None
	## Funkcja wywoływana po opuszczeniu obszaru 2D.
	# Rejestracja aktualnie opuszczonej strefy.
	var area_exited = area.get_name()
	if (area_exited == "FireAlarmArea"):
		can_use_alarm = false
	else:
		if (area_exited == "TerminalArea" or area_exited == "VendingMachine1Area" or area_exited == "VendingMachine2Area" or area_exited == "ComputersArea" or area_exited == "NotesArea"  or area_exited == "WalkingArea"):
			is_task_area = false
			catch_info_instance.visible = false

func _on_catch_student_area_area_entered(area):
	## Parametry: area - obszar który może wchodzić w interakcje z graczem
	## Return: None
	## Funkcja wywoływana po wejściu w obszar łapania studenta.
	var object = area.get_parent().get_parent()

	# Dodanie studenta do grupy złapanych studentów.
	if object.is_in_group("Student"):
		object.add_to_group("Catchable_Students")
	# Wyświetlenie informacji o złapaniu, jeśli to ostatni student w obszarze z zadaniem.
	if get_tree().get_nodes_in_group("Catchable_Students").size()==1 and is_task_area:
		catch_info_instance.visible = true

func _on_catch_student_area_area_exited(area):
	## Parametry: area - obszar który może wchodzić w interakcje z graczem
	## Return: None
	## Funkcja wywoływana po wyjściu z obszaru łapania studenta.
	var object = area.get_parent().get_parent()
	if object.is_in_group("Student"):
		object.remove_from_group("Catchable_Students")
	if get_tree().get_nodes_in_group("Catchable_Students").size()==0 and is_task_area:
		catch_info_instance.visible = false
