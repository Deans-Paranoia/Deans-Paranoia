extends Node2D
@export var studentScene:PackedScene
@export var deanScene:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for i in globalScript.Players:
		var currentPlayer
		var label
		#if i==globalScript.deanId:
		#	currentPlayer = deanScene.instantiate()
		#	label = currentPlayer.get_node_or_null("CharacterBody2D/Label")
		#	if(label != null):
		#		label.text = "Dean"
		#else:
		currentPlayer = studentScene.instantiate()
		label = currentPlayer.get_node_or_null("CharacterBody2D/Label")
		if(label != null):
			label.text = "Student"
				
		currentPlayer.name = str(globalScript.Players[i].id)
		currentPlayer.add_to_group("ThirdFloor")
		if(i == multiplayer.get_unique_id()):
			label.modulate = Color(0.2,1,0.2)
		var body = currentPlayer.get_node("CharacterBody2D")
		if body != null:	
			body.name =  str(globalScript.Players[i].id)
		add_child(currentPlayer)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		index +=1		
	pass # Replace with function body.
