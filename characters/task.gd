extends Node2D

signal npc_walking_task
signal npc_sprite_task(task_type: String)

func on_npc_task_type_emitted(task_type):
	## Parametry: task_type - typ tasku
	## Funkcja do odtwarzania konkretnego zadania przez gracza
	run_task(task_type)
	pass
func run_task(task_type):
	## Parametry: task_type - typ tasku
	## Funkcja dobiera odpowiednią funkcje zależnie od zmiennej task_type
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

func task_computer():
	## Funkcja emitująca sygnał o task_type = computer
	#print("computer " + get_parent().get_parent().name + " " + str(get_parent().get_parent().get_groups().size())) 
	npc_sprite_task.emit("computer")

func task_taking_notes():
	## Funkcja emitująca sygnał o task_type = takingNotes
	npc_sprite_task.emit("takingNotes")
	#print("notes " + get_parent().get_parent().name + " " + str(get_parent().get_parent().get_groups().size()))	
func task_walking():
	## Funkcja emitująca sygnał o task_type = walking
	npc_walking_task.emit()

#print("walking " + get_parent().get_parent().name + " " + str(get_parent().get_parent().get_groups().size()))
func vending_machine():
	## Funkcja emitująca sygnał o task_type = vendingMachine
	npc_sprite_task.emit("vendingMachine")
	#print("vending " + get_parent().get_parent().name + " " + str(get_parent().get_parent().get_groups().size()))
