extends Node2D
@onready var npcScene = load("res://characters/npc.tscn")
@onready var deanScene = load("res://characters/dean.tscn")
var counter = 1
func _ready():
	for i in globalScript.usedNames:
		var scene = npcScene.instantiate()
		scene.name = i;
		var label = scene.get_node("CharacterBody2D/Label")
		label.text = i
		var spawnpoint = get_node("spawnPoints/"+str(counter))
		scene.position = spawnpoint.position
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
