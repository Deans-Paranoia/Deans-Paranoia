extends Node

func _ready():
	# rejestruje skrypt jako singleton (umożliwia dostęp z innych skryptów)
	Engine.register_singleton("global", self)

var player_type: String

class Task:
	var positionX: float
	var positionY: float
	var taskType: String

	func _init(positionX, positionY, taskType):
		self.positionX = positionX
		self.positionY = positionY
		self.taskType = taskType


var Tasks: Dictionary = {
	1: Task.new(0.0, 50.0, "taskType1"),
	2: Task.new(100.0, 50.0, "taskType2"),
	3: Task.new(200.0, 100.0, "taskType3"),
	4: Task.new(140.0, 140.0, "taskType4"),
	5: Task.new(100.0, 100.0, "taskType5"),
	6: Task.new(50.0, 300.0, "taskType6"),
	7: Task.new(500.0, 100.0, "taskType7"),
	8: Task.new(250.0, 0.0, "taskType8"),
	9: Task.new(0.0, 250.0, "taskType9"),
	10: Task.new(500.0, 500.0, "taskType10"),
}

var UsedTasks: Dictionary = { }

func get_task_data(task_number: int) -> Task:
	# zwraca taska, ktorego wylosowal npc
	return Tasks[task_number]

func manage_task(task_number: int):
	# dodaje taska do UsedTasks
	UsedTasks[task_number] = get_task_data(task_number)
	remove_task(task_number)

func remove_task(task_number: int):
	# usuwa wczesniej dodanego taska do UsedTasks z Tasks
	Tasks.erase(task_number)
