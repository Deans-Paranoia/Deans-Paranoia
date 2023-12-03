extends Node2D

signal task_type_emitted
# sygnal do emitowania wylosowanego taska

func _ready():
	# pobieramy numer zadania
	var task_number = get_task_number()
	
	# pobieramy wartosci taska do zmiennej
	var task_data = globalScript.get_task_data(task_number)
	
	# ustawiamy zmienna position na ta, ktora otrzymalismy w tasku
	var position = Vector2(task_data.positionX, task_data.positionY)
	
	# zmieniamy pozycje gracza na pozycje z taska
	global_transform.origin = position
	
	# dodaje taska do slownika UsedTasks i usuwa go z Tasks
	globalScript.manage_task(task_number)
	
	# emitujemy sygnal z wylosowanym zadaniem
	emit_signal("task_type_emitted", task_data.taskType)
	
func _process(_delta):
	pass
	
func get_task_number() -> int:
	# metoda zwracajaca numerek wylosowanego taska
	var rand = RandomNumberGenerator.new()
	# zmienna do losowania numerku
	return rand.randi() % globalScript.Tasks.size() + 1
	
