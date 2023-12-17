extends Node2D
@onready var npcScene = load("res://characters/npc.tscn")
@onready var deanScene = load("res://characters/dean.tscn")
var counter = 1
var kicked_player_number = 1
var maximum_ammount_to_kick = 1
var hovered_student
func _ready():
	for i in globalScript.usedNames:
		var scene = npcScene.instantiate()
		scene.name = i;
		var label = scene.get_node("CharacterBody2D/Label")
		label.text = i
		var spawnpoint = get_node("spawnPoints/"+str(counter))
		scene.position = spawnpoint.position
		scene.get_node("CharacterBody2D/KickScript").on_lecture_hall = true
		scene.get_node("CharacterBody2D/KickScript").on_student_hovered.connect(set_hovered_student)
		counter+=1
		scene.scale = Vector2(1,1)
		add_child(scene)
	var dean = deanScene.instantiate()
	dean.name = "dean"
	var label = dean.get_node("CharacterBody2D/Label")
	label.text = "Dean"
	var spawnPoint = get_node("spawnPoints/deanSpawn")
	dean.position = spawnPoint.position
	dean.scale = Vector2(3,3)
	add_child(dean)
func on_student_moved():
	if(hovered_student != null):
		move_student(hovered_student)
		move_student.rpc(hovered_student)
		hovered_student = null

@rpc("any_peer","call_remote")
func move_student(name):
	var student = get_node(str(name))
	student.position = get_node("deathZones/"+str(kicked_player_number)).position
	student.get_node("CharacterBody2D/KickScript").on_lecture_hall = false
	kicked_player_number+=1
func set_hovered_student(name):
	hovered_student = name
