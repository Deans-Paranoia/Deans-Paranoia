extends Node2D

var useable: bool = true
signal change_texture

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

## Używa alarm
func use_alarm(isSabotaged):
	if useable:
		emit_signal("change_texture")
		useable = false
		if isSabotaged == false:
			set_lecture_hall()
			set_lecture_hall.rpc()
			
@rpc("any_peer","call_remote")
## Ustanawia lecture hall
func set_lecture_hall():
	var hall = get_node("../../lecture_hall")
	hall.maximum_ammount_to_kick = 3
	if multiplayer.get_unique_id() ==1:
		var timer = get_node("../../RoundTimer")
		timer.stop()
		timer.wait_time = 0.01
		timer.start()
