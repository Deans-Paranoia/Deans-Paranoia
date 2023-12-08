extends Node

func _ready():
	# rejestruje skrypt jako singleton (umożliwia dostęp z innych skryptów)
	Engine.register_singleton("global", self)
var Players ={}
var deanId:int
var player_type: String

class Task:
	var positionX: float
	var positionY: float
	var taskType: String

	func _init(positionX, positionY, taskType):
		self.positionX = positionX
		self.positionY = positionY
		self.taskType = taskType


var Tasks: = [
	 Task.new(0.0, 50.0, "takingNotes"),
	 Task.new(100.0, 50.0, "takingNotes"),
	 Task.new(200.0, 100.0, "takingNotes"),
	 Task.new(140.0, 140.0, "takingNotes"),
	 Task.new(100.0, 100.0, "computer"),
	 Task.new(50.0, 300.0, "computer"),
	 Task.new(500.0, 100.0, "computer"),
	 Task.new(250.0, 0.0, "walking"),
	 Task.new(0.0, 250.0, "walking"),
	 Task.new(500.0, 500.0, "walking"),
	 Task.new(-200.0, 500.0, "walking"),
	 Task.new(-300.0, 500.0, "vendingMachine"),
	 Task.new(-400.0, 500.0, "vendingMachine"),
]

var UsedTasks: = []

func get_task_data(task_number: int) -> Task:
	# zwraca taska, ktorego wylosowal npc
	return Tasks[task_number]

func manage_task(task_number: int):
	# dodaje taska do UsedTasks
	UsedTasks.append(get_task_data(task_number)) 
	remove_task(task_number)

func remove_task(task_number: int):
	# usuwa wczesniej dodanego taska do UsedTasks z Tasks
	Tasks.erase(task_number)
