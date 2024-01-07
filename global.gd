## Klasa odpowiedzialna za przechowywanie globalnych danych i funkcji gry
extends Node

## Funkcja wywoływana po przygotowaniu obiektu do użycia
func _ready():
	# Rejestrowanie tego skryptu jako singletona (umożliwia dostęp z innych skryptów)
	Engine.register_singleton("global", self)
	
## Słownik przechowujący informacje o graczach
var Players = {}
## Identyfikator dziekana
var deanId: int

## Klasa reprezentująca zadanie
class Task:
	var positionX: float
	var positionY: float
	var taskType: String

	## Inicjalizator klasy Task
	func _init(positionX, positionY, taskType):
		self.positionX = positionX
		self.positionY = positionY
		self.taskType = taskType

## Lista dostępnych nazw studentów
var studentsNames = [
	"imie1", "imie2", "imie3", "imie4", "imie5", "imie6", "imie7", "imie8", "imie9", "imie10", "imie11", "imie12", "imie13"
]
## Lista użytych nazw studentów
var usedNames = []
## Lista dostępnych zadań
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
## Lista użytych zadań
var UsedTasks: = []

## Funkcja dodająca zwolnioną nazwę studenta do listy dostępnych nazw
func remove_name(nameNumber: int):
	usedNames.append(studentsNames[nameNumber])
	studentsNames.pop_at(nameNumber)

## Funkcja resetująca listę zadań, przenosząca zadania z UsedTasks z powrotem do Tasks
func resetTasks():
	for i in UsedTasks:
		Tasks.append(i)
	UsedTasks = []

## Funkcja zwracająca dane o zadaniu o określonym numerze
func get_task_data(task_number: int) -> Task:
	# zwraca taska, którego wylosował NPC
	return Tasks[task_number]

## Funkcja zarządzająca zadaniem o określonym numerze
func manage_task(task_number: int):
	# dodaje taska do UsedTasks
	UsedTasks.append(get_task_data(task_number)) 
	remove_task(task_number)

## Funkcja usuwająca zadanie o określonym numerze z listy dostępnych zadań
func remove_task(task_number: int):
	# usuwa wcześniej dodanego taska do UsedTasks z Tasks
	Tasks.pop_at(task_number)
