extends Node2D
@export var studentScene:PackedScene
@export var deanScene:PackedScene
@export var npcScene:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for i in globalScript.Players:
		var currentPlayer
		#if i==globalScript.deanId:
		#	currentPlayer = deanScene.instantiate()
		#else:
		currentPlayer = studentScene.instantiate()
		currentPlayer.name = str(globalScript.Players[i].id)
		currentPlayer.add_to_group("ThirdFloor")
		var body = currentPlayer.get_node("CharacterBody2D")
		if body != null:	
			body.name =  str(globalScript.Players[i].id)
		add_child(currentPlayer)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		index +=1		
	pass # Replace with function body.
