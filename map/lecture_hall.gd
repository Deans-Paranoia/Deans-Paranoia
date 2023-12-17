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

@rpc("any_peer","call_remote")
func move_student(name):
	var student = get_node(str(name))
	student.position = get_node("deathZones/"+str(kicked_player_number)).position
	student.get_node("CharacterBody2D/KickScript").on_lecture_hall = false
	kicked_player_number+=1
	clicked +=1
func set_hovered_student(name):
	hovered_student = name
