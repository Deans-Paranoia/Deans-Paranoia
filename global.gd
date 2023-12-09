extends Node

var rng = RandomNumberGenerator.new()

func _ready():
	# rejestruje skrypt jako singleton (umożliwia dostęp z innych skryptów)
	Engine.register_singleton("global", self)
	#generowanie trzycyfrowej wartosci value servera
	var ServerValue = rng.randi_range(100, 999)
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

var studentsNames = [
	"imie1", "imie2", "imie3", "imie4", "imie5", "imie6", "imie7", "imie8", "imie9", "imie10", "imie11", "imie12", "imie13"
]
var Tasks: = [
	 Task.new(150.0, 150.0, "takingNotes"),
	 Task.new(200.0, 150.0, "takingNotes"),
	 Task.new(250.0, 150.0, "takingNotes"),
	 Task.new(300.0, 150.0, "takingNotes"),
	 Task.new(350.0, 150.0, "computer"),
	 Task.new(400.0, 150.0, "computer"),
	 Task.new(450.0, 150.0, "computer"),
	 Task.new(500.0, 150.0, "walking"),
	 Task.new(550.0, 150.0, "walking"),
	 Task.new(600.0, 150.0, "walking"),
	 Task.new(650.0, 150.0, "walking"),
	 Task.new(700.0, 150.0, "vendingMachine"),
	 Task.new(750.0, 150.0, "vendingMachine"),
]

var UsedTasks: = []

func remove_name(nameNumber:int):
	studentsNames.pop_at(nameNumber)

func get_task_data(task_number: int) -> Task:
	# zwraca taska, ktorego wylosowal npc
	return Tasks[task_number]

func manage_task(task_number: int):
	# dodaje taska do UsedTasks
	UsedTasks.append(get_task_data(task_number)) 
	remove_task(task_number)

func remove_task(task_number: int):
	# usuwa wczesniej dodanego taska do UsedTasks z Tasks
	Tasks.pop_at(task_number)
