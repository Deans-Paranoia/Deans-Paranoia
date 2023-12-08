extends Node2D
@export var studentScene:PackedScene
@export var deanScene:PackedScene
@export var npcScene:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	var j = 0
	for i in globalScript.Players:
		var currentPlayer
		var label
		if multiplayer.get_unique_id() ==1:
			while j < 13-globalScript.Players.size():
				var rand = RandomNumberGenerator.new()
				var task_number = rand.randi() % globalScript.Tasks.size()
				var name_number = rand.randi() % globalScript.studentsNames.size()
				
				#var npc = npcScene.instantiate()
				#var node = npc.get_node("Label")
				#node.text=str(j)
				setNpc(name_number,task_number)
				setNpc.rpc(name_number,task_number)
				j+=1
		#if i==globalScript.deanId:
		#	currentPlayer = deanScene.instantiate()
		#	label = currentPlayer.get_node_or_null("CharacterBody2D/Label")
		#	if(label != null):
		#		label.text = "Dean"
		#else:
		currentPlayer = studentScene.instantiate()
		label = currentPlayer.get_node_or_null("CharacterBody2D/Label")
		if(label != null):
			label.text = globalScript.Players[i].fakeName
				
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
@rpc("any_peer","call_remote")
func setNpc(name,task_number):
	var task_data = globalScript.get_task_data(task_number)
	var position = Vector2(task_data.positionX, task_data.positionY)
	var npc = npcScene.instantiate()
	npc.global_transform.origin = position
	var node = npc.get_node("Label")
	node.text=globalScript.studentsNames[name]
	add_child(npc)
	globalScript.remove_name(name)
	globalScript.manage_task(task_number)
	#emit_signal("task_type_emitted", task_data.taskType)
	#var currentNpc = npcScene.instantiate()
	#var npcLabel  =currentNpc.get_node_or_null("Label")
	#if(npcLabel != null):
		#npcLabel.text = globalScript.studentsNames[name_number]
		#globalScript.remove_name(name_number)
		#add_child(currentNpc)
		#print(str(globalScript.studentsNames.size()))
		

