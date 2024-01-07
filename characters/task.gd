extends Node2D

signal npc_walking_task
signal npc_sprite_task(task_type: String)

## Parametry: task_type - typ tasku
## Funkcja do odtwarzania konkretnego zadania przez gracza
func on_npc_task_type_emitted(task_type):
	run_task(task_type)
	pass
## Parametry: task_type - typ tasku
## Funkcja dobiera odpowiednią funkcje zależnie od zmiennej task_type
func run_task(task_type):
	match task_type:
		"takingNotes":
			task_taking_notes()
		"computer":
			task_computer()
		"walking":
			task_walking()
		"vendingMachine":
			vending_machine()
		"vendingMachine2":
			vending_machine()

## Funkcja emitująca sygnał o task_type = computer
func task_computer():
	#print("computer " + get_parent().get_parent().name + " " + str(get_parent().get_parent().get_groups().size())) 
	npc_sprite_task.emit("computer")

## Funkcja emitująca sygnał o task_type = takingNotes
func task_taking_notes():
	npc_sprite_task.emit("takingNotes")
	#print("notes " + get_parent().get_parent().name + " " + str(get_parent().get_parent().get_groups().size()))	
## Funkcja emitująca sygnał o task_type = walking
func task_walking():
	npc_walking_task.emit()

#print("walking " + get_parent().get_parent().name + " " + str(get_parent().get_parent().get_groups().size()))
## Funkcja emitująca sygnał o task_type = vendingMachine
func vending_machine():
	npc_sprite_task.emit("vendingMachine")
	#print("vending " + get_parent().get_parent().name + " " + str(get_parent().get_parent().get_groups().size()))
