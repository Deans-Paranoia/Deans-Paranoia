extends Node2D
var rng = RandomNumberGenerator.new()
@onready var terminal1 = get_node("terminal1")
@onready var terminal2 = get_node("terminal2")
@onready var terminal3 = get_node("terminal3")
var serverValue
func _ready():
	if multiplayer.get_unique_id()==1:
		serverValue = rng.randi_range(100, 999)
		print(str(serverValue))
		set_server_value.rpc(serverValue)
		
@rpc("any_peer","call_remote")
func set_server_value(value):
	serverValue = value
	
func calculate_value():
	if (100 * terminal1.actual_value + 10 * terminal2.actual_value + terminal3.actual_value) == serverValue:
		print("koniec gry")
		return true
	else:
		print("kod niepoprawny")
		return false
