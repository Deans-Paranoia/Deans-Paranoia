extends Node2D

signal npc_walking_task
signal npc_sprite_task(task_type: String)

func on_npc_task_type_emitted(task_type):
	run_task(task_type)

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

func task_computer():
	print(get_parent().get_parent().name + "computer")
	npc_sprite_task.emit("computer")

func task_taking_notes():
	print(get_parent().get_parent().name + " notes")
	npc_sprite_task.emit("takingNotes")

func task_walking():
	print(get_parent().get_parent().name + " walking")
	npc_walking_task.emit()

func vending_machine():
	print(get_parent().get_parent().name + "vending")
	npc_sprite_task.emit("vendingMachine")
