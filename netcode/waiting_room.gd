extends Control
signal button_pressed(node)
signal dean_picked(deanId)
@export var serverInfo:PackedScene
var current:int
var dean:int
var isServer = false
func _ready():
	#if multiplayer.is_server():
		#$HBoxContainer/GoBack.disabled = true
	pass
func _process(delta):
	#for i in GameManager.Players:
	#	for j in $Panel/VBoxContainer.get_children():
	#		if str(i) == j.name:
	#			return
	pass
func enable_dean_change():
	isServer = true
func makeAsDean(id):
	dean_picked.emit(id)
func _on_start_game_button_down():
	button_pressed.emit()
	
func findDeanId():
	var candidate:int
	var e = 1
	if globalScript.Players.size()<1:
		return 0;
	for x in globalScript.Players:
		if e == 1:
			candidate = x
			e+=1
		if(globalScript.deanId == x):
			return x
	return candidate
func refresh_table():
	var deanId:int = findDeanId()
	if deanId == 0:
		return
	for j in $Panel/VBoxContainer.get_children():
		j.hide()
	for i in globalScript.Players:
		var currentInfo = serverInfo.instantiate()
		currentInfo.name = str(i)
		currentInfo.get_node("Name").text = "Player "+str(i)
		if i == current:
			currentInfo.get_node("Name").modulate = Color(0,0.9,0)
		if i == deanId:
			currentInfo.get_node("Role").text = "Dziekan"
			currentInfo.get_node("MakeAsDean").disabled = true
		else:
			currentInfo.get_node("Role").text = "Student"
			currentInfo.get_node("MakeAsDean").disabled = false
		if isServer:
			currentInfo.get_node("MakeAsDean").disabled = false
		$Panel/VBoxContainer.add_child(currentInfo)
		currentInfo.makeAsDean.connect(makeAsDean)	
	dean_picked.emit(deanId)	
func on_current_player(id):
	current = id
func _on_timer_timeout():
	refresh_table()

@rpc("any_peer","call_remote")
func delete_player(id):
	if globalScript.Players.has(id):
		globalScript.Players.erase(id)
	var player = get_node_or_null("Panel/VBoxContainer/"+str(id))
	if player !=null:
		player.queue_free()
	if id==1:
		for i in globalScript.Players:
			get_tree().root.get_node_or_null("Waiting_room").delete_player(i)
		get_tree().root.get_node("main/ServerBrowser").cleanUp()
		_on_go_back_button_down()
func _on_go_back_button_down():
	var id = multiplayer.get_unique_id()
	delete_player.rpc(id)
	delete_player(id)
	multiplayer.multiplayer_peer.disconnect_peer(id)
	get_tree().root.get_node("MainMenu").visible = true
	get_tree().root.get_node("main").queue_free()
	get_tree().root.get_node("Waiting_room").queue_free()
