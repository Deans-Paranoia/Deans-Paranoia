extends Node2D
var endgame = load("res://ui/endgame.tscn")
var rng = RandomNumberGenerator.new()
@onready var green_terminal = load("res://assets/terminal_green.png")
@onready var violet_terminal = load("res://assets/terminal_violet.png")
@onready var yellow_terminal = load("res://assets/terminal_yellow.png")
@onready var terminal1 = get_node("terminal1")
@onready var terminal2 = get_node("terminal2")
@onready var terminal3 = get_node("terminal3")
var serverValue
@onready var digits_sprites = []
func _ready():
	if multiplayer.get_unique_id()==1:
		serverValue = rng.randi_range(100, 999)
		print("yellow-violet-green:"+str(serverValue))
		set_server_value.rpc(serverValue)
		set_terminals_position_for_host()
	for i in range(0,10):
		var texture = load("res://assets/terminal_"+str(i) +".png")
		digits_sprites.append(texture)
@rpc("any_peer","call_remote")
func set_server_value(value):
	serverValue = value
	
func calculate_value():
	if (100 * terminal1.actual_value + 10 * terminal2.actual_value + terminal3.actual_value) == serverValue:
		show_end_screen.rpc()
		show_end_screen()
		return true
	else:
		run_server_error()
		run_server_error.rpc()
		return false
@rpc("any_peer","call_remote")		
func run_server_error():
	$"body/sprite/Digit 1".texture = digits_sprites[0]
	$"body/sprite/Digit 2".texture = digits_sprites[0]
	$"body/sprite/Digit 3".texture = digits_sprites[0]
	for i in range(1,6):
		for j in $body/sprite.get_children():
			j.visible = false
		await get_tree().create_timer(0.4).timeout
		for j in $body/sprite.get_children():
			j.visible = true
		await  get_tree().create_timer(0.6).timeout
	$"body/sprite/Digit 1".texture = digits_sprites[terminal1.actual_value]
	$"body/sprite/Digit 2".texture = digits_sprites[terminal2.actual_value]
	$"body/sprite/Digit 3".texture = digits_sprites[terminal3.actual_value]
func set_terminals_position_for_host():
	var obstacles_top = get_tree().get_nodes_in_group("obstacle_top")
	var obstacle1 = obstacles_top[randi() % obstacles_top.size()]
	terminal1.global_position = obstacle1.global_position
	terminal1.get_node("Terminal/Sprite2D").texture = yellow_terminal
	var obstacles_middle = get_tree().get_nodes_in_group("obstacle_middle")
	var obstacle2 = obstacles_middle[randi() % obstacles_middle.size()]
	terminal2.global_position = obstacle2.global_position
	terminal2.get_node("Terminal/Sprite2D").texture = violet_terminal
	var obstacles_bottom = get_tree().get_nodes_in_group("obstacle_bottom")
	var obstacle3 = obstacles_bottom[randi() % obstacles_bottom.size()]
	print(obstacle1.name + " "+ obstacle2.name + " " + obstacle3.name)
	terminal3.global_position = obstacle3.global_position
	terminal3.get_node("Terminal/Sprite2D").texture = green_terminal
	set_terminals_position.rpc(obstacle1.global_position, obstacle2.global_position,obstacle3.global_position)
	
@rpc("any_peer","call_remote")
func set_terminals_position(position1, position2, position3):
	terminal1.global_position = position1
	terminal1.get_node("Terminal/Sprite2D").texture =  green_terminal
	terminal2.global_position = position2
	terminal2.get_node("Terminal/Sprite2D").texture = violet_terminal
	terminal3.global_position = position3
	terminal3.get_node("Terminal/Sprite2D").texture = yellow_terminal
@rpc("any_peer","call_remote")
func show_end_screen():
	var endgame_instance = endgame.instantiate()
	get_tree().root.add_child(endgame_instance)
	get_tree().root.get_node("Map").queue_free()
	if globalScript.deanId != multiplayer.get_unique_id():
		endgame_instance.get_node("ColorRect/VBoxContainer2/Label").text = "Wygrałeś!"
	self.hide()		
func on_number_changed(name, value):
	if name == "terminal1":
		$"body/sprite/Digit 1".texture = digits_sprites[value]
	elif name == "terminal2":
		$"body/sprite/Digit 2".texture = digits_sprites[value]
	elif name == "terminal3":
		$"body/sprite/Digit 3".texture = digits_sprites[value]
