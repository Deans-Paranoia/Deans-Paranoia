extends Node2D
@onready var npcScene = load("res://characters/npc.tscn")
@onready var deanScene = load("res://characters/dean.tscn")
var rng = RandomNumberGenerator.new()
var available_spots = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
var clicked = 0
var kicked_player_number = 1
var maximum_ammount_to_kick = 1
var hovered_student
var students_to_kick = []
var playersCount=0
var endgame = load("res://ui/endgame.tscn")
func on_npc_spawn():
	if(multiplayer.get_unique_id() ==1):
		for i in globalScript.usedNames:
			var spot = rng.randi_range(0,available_spots.size()-1)
			set_student(i,spot)
			set_student.rpc(i,spot)
		set_dean()
		set_dean.rpc()
	playersCount = get_tree().get_nodes_in_group("Student").size()
@rpc("any_peer","call_remote")
func set_student(name,spot):
	var scene = npcScene.instantiate()
	scene.name = name;
	var label = scene.get_node("CharacterBody2D/Label")
	label.text = name
	var spawnpoint = get_node("spawnPoints/"+str(available_spots[spot]))
	available_spots.pop_at(spot)
	scene.position = spawnpoint.position
	scene.get_node("CharacterBody2D/KickScript").on_lecture_hall = true
	scene.get_node("CharacterBody2D/KickScript").on_student_hovered.connect(set_hovered_student)
	scene.scale = Vector2(1,1)
	add_child(scene)
@rpc("any_peer","call_remote")
func set_dean():
	var dean = deanScene.instantiate()
	dean.name = "dean"
	var label = dean.get_node("CharacterBody2D/Label")
	label.text = "Dean"
	var spawnPoint = get_node("spawnPoints/deanSpawn")
	dean.position = spawnPoint.position
	dean.scale = Vector2(3,3)
	add_child(dean)
func on_student_moved():
	if(hovered_student != null and clicked<maximum_ammount_to_kick):
		move_student(hovered_student)
		move_student.rpc(hovered_student)
		if(check_if_was_player(hovered_student)):
			print("he was player")
			playersCount -=1
			if playersCount <1:
				show_end_screen()
				show_end_screen.rpc()
		else:
			print("he was bot")
		hovered_student = null
		clicked +=1
		if clicked == maximum_ammount_to_kick:
			await get_tree().create_timer(3.0).timeout
			back_to_game.rpc()
			back_to_game()
			
func on_student_catched(name):
	hovered_student = name
	move_student(hovered_student)
	move_student.rpc(hovered_student)
	playersCount -=1
	print("catched")
	if playersCount <1:
		show_end_screen()
		show_end_screen.rpc()
	hovered_student = null
@rpc("any_peer","call_remote")
func quit_game():
	get_tree().quit()
@rpc("any_peer","call_remote")
func show_end_screen():
	var endgame_instance = endgame.instantiate()
	get_tree().root.add_child(endgame_instance)
	self.hide()	
@rpc("any_peer","call_remote")
func send_restart_task_call():
	if multiplayer.get_unique_id() ==1:
		get_parent().restart_tasks.rpc()
		get_parent().restart_tasks()
		restart_map.rpc()
		restart_map()		
@rpc("any_peer","call_remote")
func back_to_game():
	for i in students_to_kick:
		var isPlayer = false
		var lecture_hall_node = get_node(str(i))
		lecture_hall_node.queue_free()
		kicked_player_number = 1
		for j in globalScript.Players:
			if globalScript.Players[j].fakeName == i:
				isPlayer = true
				var playerNode = get_tree().root.get_node("Map/"+str(j))
				if globalScript.deanId == multiplayer.get_unique_id():
					quit_game.rpc_id(j)
				if playerNode != null:
					playerNode.queue_free()
					globalScript.Players.erase(j)
		if isPlayer == false:
			var npcNode = get_tree().root.get_node_or_null("Map/"+i)
			if npcNode != null:
				npcNode.remove_from_group("npc")
				npcNode.remove_from_group("vendingMachine")
				npcNode.remove_from_group("walking")
				npcNode.remove_from_group("takingNotes")
				npcNode.remove_from_group("computer")
				var npc_body = npcNode.get_node("CharacterBody2D")
				npc_body.can_move = false
				npc_body.walking_task = false
				npc_body.get_node("Sprite2D").continue_loop = false
				npcNode.queue_free()
	send_restart_task_call()
	
@rpc("any_peer","call_remote")
func restart_map():
	students_to_kick = []
	clicked = 0
	maximum_ammount_to_kick = 1
	$"../Camera2D".enabled = false
	var map = get_node("../")
	map.isVotingProcess = false
	
		
	if(multiplayer.get_unique_id()!=1):
		var body = map.get_node(str(multiplayer.get_unique_id())+"/"+str(multiplayer.get_unique_id()))
		body.can_move = true
		var camera = body.get_node("camera "+str(multiplayer.get_unique_id()))
		camera.make_current()
		var canvas =  body.get_parent().get_node_or_null("CanvasLayer")
		if canvas != null:
			canvas.visible = false
	else:
		var timer = map.get_node("RoundTimer")
		timer.stop()
		timer.wait_time = 15.0
		timer.start()
		map.set_time_ui.rpc("15")
		var cam = map.get_node("Camera2D")
		cam.enabled = true
		cam.make_current()
		
@rpc("any_peer","call_remote")
func move_student(name):
	students_to_kick.append(name)
	var student = get_node(str(name))
	student.position = get_node("deathZones/"+str(kicked_player_number)).position
	student.get_node("CharacterBody2D/KickScript").on_lecture_hall = false
	kicked_player_number+=1
func set_hovered_student(name):
	hovered_student = name
func check_if_was_player(name):
	for i in globalScript.Players:
		if globalScript.Players[i].fakeName == name:
			return true
	return false
