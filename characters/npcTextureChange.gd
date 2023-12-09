extends Sprite2D

var computerSprite = preload("res://assets/npc_computer.png")
var notesSprite = preload("res://assets/npc_notes.png")
var vendingSprite = preload("res://assets/npc_vending.png")

var backSprite = preload("res://assets/npc_back.png")

var basicSprite = preload("res://assets/npc.png")

func on_task_script_npc_sprite_task(task_type):
	match task_type:
		"takingNotes":
			taking_notes_loop()
		"computer":
			computer_loop()
		"vendingMachine":
			vending_machine_loop()

func taking_notes_loop():
	while true:
		await get_tree().create_timer(5.0).timeout
		texture = notesSprite
		await get_tree().create_timer(0.5).timeout
		texture = basicSprite

func computer_loop():
	while true:
		await get_tree().create_timer(4.0).timeout
		texture = computerSprite
		await get_tree().create_timer(0.4).timeout
		texture = basicSprite

func vending_machine_loop():
	while true:
		await get_tree().create_timer(3.0).timeout
		texture = vendingSprite
		await get_tree().create_timer(0.3).timeout
		texture = basicSprite


func _on_character_body_2d_rotate(direction):
	match direction:
		"up":
			texture = backSprite
		"down":
			texture = basicSprite
