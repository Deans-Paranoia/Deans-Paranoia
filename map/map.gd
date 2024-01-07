extends Node2D
## Deklaracja zmiennych przechowujących trzy sceny: studentScene, deanScene, npcScene
@export var studentScene: PackedScene
@export var deanScene: PackedScene
@export var npcScene: PackedScene

## Inicjalizacja pustej listy 'textures'
var textures = []

## Ładowanie sceny 'time.tscn' z katalogu 'ui' i tworzenie instancji tej sceny
@onready var timeUi = load("res://ui/time.tscn").instantiate()

## Inicjalizacja zmiennej 'isVotingProcess' jako logicznej wartości 'False'
var isVotingProcess = false

## Inicjalizacja zmiennej 'day' jako liczby całkowitej równą 1
var day = 1

## Inicjalizacja generatora liczb losowych
var rand = RandomNumberGenerator.new()

## Sygnał 'taskType' emitowany z argumentem 'taskType'
signal taskType(taskType)

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(10):
		textures.append(load("res://assets/terminal_" + str(i) + ".png"))
	textures.append(load("res://assets/green.png"))
	textures.append(load("res://assets/purple.png"))
	textures.append(load("res://assets/yellow.png"))
	if multiplayer.get_unique_id() ==1:
		$Camera2D.enabled = true
		$RoundTimer.start()
		var random = rand.randi_range(1,3)
		set_code_number.rpc(random,day)
		set_code_number(random,day)
	timeUi.get_node("Control/VBoxContainer/Label").text = "60"
	
	add_child(timeUi)
	var j = 0
	for i in globalScript.Players:
		var currentPlayer
		var label
		if multiplayer.get_unique_id() ==1:
			$Chat.visible = false
			while j < 13-globalScript.Players.size():
				
				var task_number = rand.randi() % globalScript.Tasks.size()
				var name_number = rand.randi() % globalScript.studentsNames.size()
				#setNpc(name_number,task_number)
				setNpc.rpc(globalScript.studentsNames[name_number],task_number,false)
				set_npc_for_host(globalScript.studentsNames[name_number],task_number,false)
				j+=1
		if i==globalScript.deanId:
			currentPlayer = deanScene.instantiate()
			label = currentPlayer.get_node_or_null("CharacterBody2D/Label")
			if(label != null):
				label.text = "Dean"
			currentPlayer.position = Vector2(600,-1200)
		else:
			currentPlayer = studentScene.instantiate()
			label = currentPlayer.get_node_or_null("CharacterBody2D/Label")
			if(label != null):
				label.text = globalScript.Players[i].fakeName
				
		currentPlayer.name = str(globalScript.Players[i].id)
		currentPlayer.add_to_group("ThirdFloor")
		if(i == multiplayer.get_unique_id()):
			label.modulate = Color(0.2,1,0.2)
		elif multiplayer.get_unique_id() != globalScript.deanId:
			label.modulate = Color(0.2,1,0.2)
		var body = currentPlayer.get_node("CharacterBody2D")
		if body != null:	
			body.name =  str(globalScript.Players[i].id)
		add_child(currentPlayer)	
		if multiplayer.get_unique_id() ==1 and i != globalScript.deanId:
			var rand = RandomNumberGenerator.new()
			var task_number = rand.randi() % globalScript.Tasks.size()
			setPlayer(i,task_number)
			setPlayer.rpc(i,task_number)
	if(multiplayer.get_unique_id()==1):
		get_node("lecture_hall").on_npc_spawn()
	elif multiplayer.get_unique_id()==globalScript.deanId:
		$Chat.visible = false
		
func _process(delta):
	if(multiplayer.get_unique_id()==1):
		var timeLeft = str(int($RoundTimer.time_left))
		set_time_ui(timeLeft)
		set_time_ui.rpc(timeLeft)
		
@rpc("any_peer","call_remote")
	## Funkcja restartująca taski npc
func restart_tasks():
	globalScript.resetTasks()
	#print(str(get_tree().get_nodes_in_group("npc").size()))
	if multiplayer.get_unique_id() ==1:
		for x in get_tree().get_nodes_in_group("npc"):
			var name = x.name
			var task_number = rand.randi() % globalScript.Tasks.size()
			restart_npc.rpc(name,task_number)
			restart_npc(name,task_number)
		for i in globalScript.Players:
			if i != globalScript.deanId:
				var task_number = rand.randi() % globalScript.Tasks.size()
				setPlayer(i,task_number)
				setPlayer.rpc(i,task_number)
			else:
				set_dean_position(globalScript.deanId,Vector2(600,-1200))
				set_dean_position.rpc(globalScript.deanId, Vector2(600,-1200))
				#player.position = Vector2(600,-1200)
				
@rpc("any_peer","call_remote")
## Parametry: deanId - indeks dziekana, vector - pozycja dziekana
## Ustanowienie początkowe pozycji dziekana
func set_dean_position(deanId, vector):
	var dean = get_node(str(deanId))
	dean.get_node(str(deanId)).position = Vector2(0,0)
	dean.position =vector
	
@rpc("any_peer","call_remote")
## Parametry: name - imię studenta, task_number - numer taska, które robi student
## Funkcja restartuje wybranego npc.
func restart_npc(name,task_number):
	var npc = get_tree().root.get_node_or_null("Map/"+name)
	if npc != null:
		var body = npc.get_node("CharacterBody2D")
		var prevTask = npc.get_groups()[1]
		npc.remove_from_group("vendingMachine")
		npc.remove_from_group("vendingMachine2")
		npc.remove_from_group("walking")
		npc.remove_from_group("takingNotes")
		npc.remove_from_group("computer")
		npc.remove_from_group("walking")
		var task_data = globalScript.get_task_data(task_number)
		var position = Vector2(task_data.positionX, task_data.positionY)
		var taskscript = npc.get_node("CharacterBody2D/TaskScript")
		npc.global_transform.origin = position
		npc.add_to_group(task_data.taskType)
		if multiplayer.get_unique_id() ==1 and prevTask != task_data.taskType:
			if ((prevTask == "vendingMachine" or prevTask == "vendingMachine2") and (task_data.taskType == "vendingMachine" or task_data.taskType == "vendingMachine2")) == false:
				body.can_move = false
				body.walking_task = false
				body.position = Vector2(0,0)
				taskType.connect(taskscript.on_npc_task_type_emitted)
				taskType.emit(task_data.taskType)
				taskType.disconnect(taskscript.on_npc_task_type_emitted)
		globalScript.manage_task(task_number)
		
@rpc("any_peer","call_remote")
## Parametry: time - czas ui
## Funkcja ustanawia podany czas w ui, do pokazania na ekranie
func set_time_ui(time):
	var label = timeUi.get_node("Control/VBoxContainer/Label")
	if time == "0":
		label.visible = false
	else:
		label.visible = true
		label.text= time
		
@rpc("any_peer","call_remote")
## Parametry: name - imię studenta, task_number - numer taska, które robi student
## has_name - zmienna bool, mówiąca czy npc już posiada imię
## Funkcja ustawia npc na początku gry
func setNpc(name,task_number,has_name):
	var task_data = globalScript.get_task_data(task_number)
	var position = Vector2(task_data.positionX, task_data.positionY)
	var npc = npcScene.instantiate()
	npc.global_transform.origin = position
	var node = npc.get_node("CharacterBody2D/Label")
	node.text=name
	npc.name =name
	npc.add_to_group("npc")
	add_child(npc)
	#npc.visible = false
	npc.add_to_group(task_data.taskType)
	if has_name ==false:
		globalScript.remove_name(globalScript.studentsNames.find(name))
	globalScript.manage_task(task_number)
	
@rpc("any_peer","call_remote")
## Parametry: i - indeks gracza, task_number - numer taska w który znajduję
## się gracz
## Funkcja ustawia gracza na początku gry
func setPlayer(i,task_number):
	var player:Node2D = get_node_or_null(str(i))
	var body = player.get_node(str(i))
	body.position = Vector2(0,0)
	if player != null and i != globalScript.deanId:
		var task_data = globalScript.get_task_data(task_number)
		var position = Vector2(task_data.positionX, task_data.positionY)
		player.global_position = position
		player.current_task_area = task_data.taskType
		globalScript.manage_task(task_number)
		
@rpc("any_peer","call_remote")
## Parametry: random - zmienna losowa, day - dzień
## Funkcja losuje kod do serwerów
func set_code_number(random,day):
	var code_node = get_node("Code")
	var position = get_node("CodeSpawnpoints/"+str(random))
	code_node.position = position.position
	var serverValue:int = get_node("fourthFloor/server").serverValue
	var first_digit = serverValue/100
	var second_digit = (serverValue/10)%10
	var third_digit = serverValue%10
	match day%3:
		1:
			code_node.get_node("Line").texture = textures[10]
			code_node.get_node("Number").texture = textures[first_digit]
			
		2:
			code_node.get_node("Line").texture = textures[11]
			code_node.get_node("Number").texture = textures[second_digit]
		0:
			code_node.get_node("Line").texture = textures[12]
			code_node.get_node("Number").texture = textures[third_digit]
	
@rpc("any_peer","call_remote")
## Funkcja zmienia kod do serwerów
func change_code():
	day+=1
	var random = rand.randi_range(1,3)
	set_code_number(random,day)
	set_code_number.rpc(random,day)
	
## Parametry: name - imię studenta, task_number - numer taska, które robi student
## has_name - zmienna bool, mówiąca czy npc już posiada imię
## Ustawia npc dla hosta.
func set_npc_for_host(name,task_number,has_name):
	var task_data = globalScript.get_task_data(task_number)
	var position = Vector2(task_data.positionX, task_data.positionY)
	var npc = npcScene.instantiate()
	var taskscript = npc.get_node("CharacterBody2D/TaskScript")
	taskType.connect(taskscript.on_npc_task_type_emitted)
	npc.global_transform.origin = position
	var node = npc.get_node("CharacterBody2D/Label")
	node.text=name
	npc.name =name
	npc.add_to_group("npc")
	add_child(npc)
	#npc.visible = false
	npc.add_to_group(task_data.taskType)
	taskType.emit(task_data.taskType)
	taskType.disconnect(taskscript.on_npc_task_type_emitted)
	if has_name == false:
		globalScript.remove_name(globalScript.studentsNames.find(name))
	globalScript.manage_task(task_number)
	
## Funkcja wykonująca się kiedy skończy się czas, przenosi na lecture hall po
## upływie czasu
func _on_round_timer_timeout():
	change_view.rpc()
	var camera:Camera2D = get_node("lecture_hall/Camera2D")
	camera.enabled = true
	camera.make_current()
	pass
	
@rpc("any_peer","call_remote")
## Funkcja zmienia widok gracza na lecture hall
func change_view():
	var camera:Camera2D = get_node("lecture_hall/Camera2D")
	isVotingProcess = true
	camera.enabled = true
	camera.make_current()
	var player = get_node(str(multiplayer.get_unique_id()))
	var canvas =  player.get_node_or_null("CanvasLayer")
	if canvas != null:
		canvas.visible = false
	var body = player.get_node(str(multiplayer.get_unique_id()))
	body.can_move = false
	if player.is_in_group("Student"):
		player.dig_info_instance.visible = false
	if player.is_in_group("Dean"):
		player.catch_info_instance.visible = false
		
func npcs_notes(isVisible):
	var npcs = get_tree().get_nodes_in_group("takingNotes")
	#if(isVisible):
	#	for i in npcs:
	#		i.visible = true	
	#else:
	#	for i in npcs:
	#		i.visible = false
func npcs_walking(isVisible):
	var npcs = get_tree().get_nodes_in_group("walking")
	#if(isVisible):
	#	for i in npcs:
	#		i.visible = true	
	#else:
	#	for i in npcs:
	#		i.visible = false

func npcs_computer(isVisible):
	var npcs = get_tree().get_nodes_in_group("computer")
	#if(isVisible):
	#	for i in npcs:
	#		i.visible = true	
	#else:
	#	for i in npcs:
	#		i.visible = false
