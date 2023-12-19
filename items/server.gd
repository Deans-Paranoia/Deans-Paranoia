extends Node2D
var endgame = load("res://ui/endgame.tscn")
var rng = RandomNumberGenerator.new()
@onready var terminal1 = get_node("terminal1")
@onready var terminal2 = get_node("terminal2")
@onready var terminal3 = get_node("terminal3")
var serverValue
func _ready():
	if multiplayer.get_unique_id()==1:
		serverValue = rng.randi_range(100, 999)
		print("yellow-blue-green:"+str(serverValue))
		set_server_value.rpc(serverValue)
		set_terminals_position_for_host()
		
@rpc("any_peer","call_remote")
func set_server_value(value):
	serverValue = value
	
func calculate_value():
	if (100 * terminal1.actual_value + 10 * terminal2.actual_value + terminal3.actual_value) == serverValue:
		show_end_screen.rpc()
		show_end_screen()
		return true
	else:
		return false
		

func set_terminals_position_for_host():
	var obstacles_top = get_tree().get_nodes_in_group("obstacle_top")
	var obstacle1 = obstacles_top[randi() % obstacles_top.size()]
	terminal1.global_position = obstacle1.global_position
	terminal1.modulate = Color(0.9,0.9,0.6)
	var obstacles_middle = get_tree().get_nodes_in_group("obstacle_middle")
	var obstacle2 = obstacles_middle[randi() % obstacles_middle.size()]
	terminal2.global_position = obstacle2.global_position
	terminal2.modulate = Color(0.1,0.1,0.9)
	var obstacles_bottom = get_tree().get_nodes_in_group("obstacle_bottom")
	var obstacle3 = obstacles_bottom[randi() % obstacles_bottom.size()]
	print(obstacle1.name + " "+ obstacle2.name + " " + obstacle3.name)
	terminal3.global_position = obstacle3.global_position
	terminal3.modulate = Color(0.1,1,0.1)
	set_terminals_position.rpc(obstacle1.global_position, obstacle2.global_position,obstacle3.global_position)
	
@rpc("any_peer","call_remote")
func set_terminals_position(position1, position2, position3):
	terminal1.global_position = position1
	terminal1.modulate = Color(0.9,0.9,0.1)
	terminal2.global_position = position2
	terminal2.modulate = Color(0.1,0.1,0.9)
	terminal3.global_position = position3
	terminal3.modulate = Color(0.1,1,0.1)
@rpc("any_peer","call_remote")
func show_end_screen():
	var endgame_instance = endgame.instantiate()
	get_tree().root.add_child(endgame_instance)
	endgame_instance.get_node("ColorRect/VBoxContainer2/Label").text = "Wygrali studenci"
	self.hide()		
