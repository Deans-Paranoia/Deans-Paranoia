extends Node2D
@onready var npcScene = load("res://characters/npc.tscn")
@onready var deanScene = load("res://characters/dean.tscn")
var counter = 1
var clicked = 0
var kicked_player_number = 1
var maximum_ammount_to_kick = 1
var hovered_student
func on_npc_spawn():
	if(multiplayer.get_unique_id() ==1):
		for i in globalScript.usedNames:
			set_student(i)
			set_student.rpc(i)
			set_dean()
			set_dean.rpc()
@rpc("any_peer","call_remote")
func set_student(name):
	#if(counter>14):
		#return
	var scene = npcScene.instantiate()
	scene.name = name;
	var label = scene.get_node("CharacterBody2D/Label")
	label.text = name
	var spawnpoint = get_node("spawnPoints/"+str(counter))
	scene.position = spawnpoint.position
	scene.get_node("CharacterBody2D/KickScript").on_lecture_hall = true
	scene.get_node("CharacterBody2D/KickScript").on_student_hovered.connect(set_hovered_student)
	scene.scale = Vector2(1,1)
	add_child(scene)
	counter+=1
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
		hovered_student = null
		if(check_if_was_player(hovered_student)):
			print("he was player")
		else:
			print("he was bot")
		if clicked == maximum_ammount_to_kick:
			back_to_game()
			back_to_game.rpc()
			
@rpc("any_peer","call_remote")
func back_to_game():
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
	var student = get_node(str(name))
	student.position = get_node("deathZones/"+str(kicked_player_number)).position
	student.get_node("CharacterBody2D/KickScript").on_lecture_hall = false
	kicked_player_number+=1
	clicked +=1
func set_hovered_student(name):
	hovered_student = name
func check_if_was_player(name):
	for i in globalScript.Players:
		if globalScript.Players[i].fakeName == name:
			return true
	return false
