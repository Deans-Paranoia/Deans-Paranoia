extends Sprite2D

var computerSprite = preload("res://assets/npc_computer.png")
var notesSprite = preload("res://assets/npc_notes.png")
var vendingSprite = preload("res://assets/npc_vending.png")

var backSprite = preload("res://assets/npc_back.png")

var basicSprite = preload("res://assets/student_new.png")
var continue_loop = false
func on_task_script_npc_sprite_task(task_type):
	var time = float(randi_range(0,40))/10
	await get_tree().create_timer(time).timeout
	continue_loop =true
	match task_type:
		"takingNotes":
			taking_notes_loop()
		"computer":
			computer_loop()
		"vendingMachine":
			vending_machine_loop()

func taking_notes_loop():
	while continue_loop and get_parent().get_parent().is_in_group("takingNotes"):
		var time = float(randi_range(0,20))/10
		await get_tree().create_timer(2.5 + time).timeout
		if continue_loop:
			texture = notesSprite
			scale = Vector2(1,1)
			await get_tree().create_timer(0.3).timeout
			texture = basicSprite
			scale = Vector2(0.07,0.07)
func computer_loop():
	while continue_loop and get_parent().get_parent().is_in_group("computer"):
		var time = float(randi_range(0,20))/10
		await get_tree().create_timer(3.0+time).timeout
		if continue_loop:
			texture = computerSprite
			scale = Vector2(1,1)
			await get_tree().create_timer(0.4).timeout
			texture = basicSprite
			scale = Vector2(0.07,0.07)
func vending_machine_loop():
	while continue_loop and get_parent().get_parent().is_in_group("vendingMachine"):
		var time = float(randi_range(0,20))/10
		await get_tree().create_timer(2.0+time).timeout
		if continue_loop:
			texture = vendingSprite
			scale = Vector2(1,1)
			await get_tree().create_timer(0.3).timeout
			texture = basicSprite
			scale = Vector2(0.07,0.07)

func _on_character_body_2d_rotate(direction):
	match direction:
		"up":
			texture = backSprite
			scale = Vector2(0.37, 0.37)
		"down":
			texture = basicSprite
			scale = Vector2(0.07,0.07)


func _on_texture_changed():
	
	if(multiplayer.get_unique_id()==1):
		change_texture.rpc(texture.resource_path)
		
@rpc("any_peer","call_remote")
func change_texture(texture_path):
	if(texture_path == "res://assets/npc_computer.png"):
		texture = computerSprite
		scale = Vector2(1,1)
	elif texture_path == "res://assets/npc_notes.png":
		texture = notesSprite
		scale = Vector2(1,1)
	elif texture_path == "res://assets/npc_vending.png":
		texture = vendingSprite
		scale = Vector2(1,1)
	elif texture_path == "res://assets/npc_back.png":
		texture = backSprite
		scale = Vector2(0.37, 0.37)
	elif texture_path == "res://assets/student_new.png":
		texture = basicSprite
		scale = Vector2(0.07,0.07)
