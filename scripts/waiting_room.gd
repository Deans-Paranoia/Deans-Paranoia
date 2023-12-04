extends Control
signal button_pressed(node)
signal dean_picked(deanId)
@export var serverInfo: PackedScene
var current: int
var dean: int
var isServer = false


func _ready():
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
	var candidate: int
	var e = 1
	if globalScript.Players.size() < 1:
		return 0
	for x in globalScript.Players:
		if e == 1:
			candidate = x
			e += 1
		if globalScript.deanId == x:
			return x
	return candidate


func refresh_table():
	var deanId: int = findDeanId()
	if deanId == 0:
		return
	for j in $Panel/VBoxContainer.get_children():
		j.hide()
	for i in globalScript.Players:
		var currentInfo = serverInfo.instantiate()
		currentInfo.name = str(i)
		currentInfo.get_node("Name").text = "Player " + str(i)
		if i == current:
			currentInfo.get_node("Name").modulate = Color(0, 0.9, 0)
		if i == deanId:
			currentInfo.get_node("Role").text = "Dean"
			currentInfo.get_node("MakeAsDean").disabled = true
		else:
			currentInfo.get_node("Role").text = "Player"
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
