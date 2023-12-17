extends Node2D

var useable: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func use_alarm():
	useable = false
	set_lecture_hall()
	set_lecture_hall.rpc()
@rpc("any_peer","call_remote")
func set_lecture_hall():
	var hall = get_node("../../lecture_hall")
	hall.maximum_ammount_to_kick = 3
	if multiplayer.get_unique_id() ==1:
		var timer = get_node("../../RoundTimer")
		timer.stop()
		timer.wait_time = 0.01
		timer.start()
