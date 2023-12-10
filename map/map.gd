extends Node2D
@export var studentScene:PackedScene
@export var deanScene:PackedScene
@export var npcScene:PackedScene
signal taskType(taskType)
# Called when the node enters the scene tree for the first time.
func _ready():
	$RoundTimer.start()
	var j = 0
	for i in globalScript.Players:
		var currentPlayer
		var label
		if multiplayer.get_unique_id() ==1:
			while j < 13-globalScript.Players.size():
				var rand = RandomNumberGenerator.new()
				var task_number = rand.randi() % globalScript.Tasks.size()
				var name_number = rand.randi() % globalScript.studentsNames.size()
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
		if multiplayer.get_unique_id() ==1:
			var rand = RandomNumberGenerator.new()
			var task_number = rand.randi() % globalScript.Tasks.size()
			setPlayer(i,task_number)
			setPlayer.rpc(i,task_number)
	
	pass # Replace with function body.
@rpc("any_peer","call_remote")
func setNpc(name,task_number):
	var task_data = globalScript.get_task_data(task_number)
	var position = Vector2(task_data.positionX, task_data.positionY)
	var npc = npcScene.instantiate()
	var taskscript = npc.get_node("CharacterBody2D/TaskScript")
	taskType.connect(taskscript.on_npc_task_type_emitted)
	npc.global_transform.origin = position
	var node = npc.get_node("CharacterBody2D/Label")
	node.text=globalScript.studentsNames[name]
	add_child(npc)
	taskType.emit(task_data.taskType)
	taskType.disconnect(taskscript.on_npc_task_type_emitted)
	globalScript.remove_name(name)
	globalScript.manage_task(task_number)
@rpc("any_peer","call_remote")		
func setPlayer(i,task_number):
	var player:Node2D = get_node_or_null(str(i))
	if(player != null):
		var task_data = globalScript.get_task_data(task_number)
		var position = Vector2(task_data.positionX, task_data.positionY)
		player.global_position = position
		globalScript.manage_task(task_number)


func _on_round_timer_timeout():
	#tymczasowo disabled zeby mozna bylo testowac, aby uruchomic wystaczy usunąć # dla linjki nizej
	#change_view.rpc()
	pass
@rpc("any_peer","call_remote")
func change_view():
	var camera:Camera2D = get_node("lecture_hall/Camera2D")
	camera.enabled = true
	camera.make_current()
