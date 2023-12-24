extends Node2D

signal npc_walking_task
signal npc_sprite_task(task_type: String)

func on_npc_task_type_emitted(task_type):
	run_task(task_type)
	pass
func run_task(task_type):
	match task_type:
		"takingNotes":
			print ("Notes " + str(get_parent().get_parent().name))
			task_taking_notes()
		"computer":
			print ("computer " + str(get_parent().get_parent().name))
			task_computer()
		"walking":
			print ("walking " + str(get_parent().get_parent().name))
			task_walking()
		"vendingMachine":
			print ("vending " + str(get_parent().get_parent().name))
			vending_machine()
		"vendingMachine2":
			print ("vending " + str(get_parent().get_parent().name))
			vending_machine()

func task_computer():
	npc_sprite_task.emit("computer")

func task_taking_notes():
	npc_sprite_task.emit("takingNotes")

func task_walking():
	npc_walking_task.emit()

func vending_machine():
	npc_sprite_task.emit("vendingMachine")
