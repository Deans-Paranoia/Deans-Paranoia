extends Node

func _ready():
	# rejestruje skrypt jako singleton (umożliwia dostęp z innych skryptów)
	Engine.register_singleton("global", self)
	
		
var Players ={}
var deanId:int
var game_started = false

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
var usedNames = []
var Tasks: = [

	 Task.new(882.0, -2147.0, "takingNotes"),
	 Task.new(978.0, -2147.0, "takingNotes"),
	 Task.new(1074.0, -2147.0, "takingNotes"),
	 Task.new(1170.0, -2147.0, "takingNotes"),
	 Task.new(610.0, -1567.0, "computer"),
	 Task.new(674.0, -1567.0, "computer"),
	 Task.new(738.0, -1567.0, "computer"),
	 Task.new(544.0, -235.0, "walking"),
	 Task.new(608.0, -235.0, "walking"),
	 Task.new(672.0, -235.0, "walking"),
	 Task.new(729.0, -235.0, "walking"),
	 Task.new(1251.0, -650.0, "vendingMachine"),
	 Task.new(-29.0, -1368.0, "vendingMachine2"),

]

var UsedTasks: = []

func remove_name(nameNumber:int):
	usedNames.append(studentsNames[nameNumber])
	studentsNames.pop_at(nameNumber)
	
func resetTasks():
	for i in UsedTasks:
		Tasks.append(i)
	UsedTasks = []
	
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
