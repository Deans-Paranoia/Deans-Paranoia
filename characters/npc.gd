extends Node2D

signal task_type_emitted
# sygnal do emitowania wylosowanego taska

func _ready():
	# pobieramy numer zadania
	if(multiplayer.get_unique_id() == 1):
		var rand = RandomNumberGenerator.new()
		var task_number = rand.randi() % globalScript.Tasks.size()
		set_task(task_number)
		set_task.rpc(task_number)
		globalScript.manage_task(task_number)
func _process(_delta):
	pass
@rpc("any_peer","call_remote")	
func set_task(task_number):
	var task_data = globalScript.get_task_data(task_number)
	# ustawiamy zmienna position na ta, ktora otrzymalismy w tasku
	var position = Vector2(task_data.positionX, task_data.positionY)
	
	# zmieniamy pozycje gracza na pozycje z taska
	global_transform.origin = position
	
	# emitujemy sygnal z wylosowanym zadaniem
	emit_signal("task_type_emitted", task_data.taskType)
