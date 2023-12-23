extends AnimationTree
var taskVector = Vector2.ZERO
@onready var sprite_to_back_to:Sprite2D = $"../Sprite2D"
func on_task_script_npc_sprite_task(task_type):
	var time = float(randi_range(0,40))/10
	set_npc(time)
	set_npc.rpc(time)
	match task_type:
		"takingNotes":
			taking_notes_loop()
		"computer":
			computer_loop()
		"vendingMachine":
			vending_machine_loop()
@rpc("any_peer","call_remote")
func set_npc(time):
	await get_tree().create_timer(time).timeout
	$".".get("parameters/playback").travel("Idle")
	var taskVector = Vector2.ZERO
	$".".get("parameters/playback").travel("FakingTasks")
func taking_notes_loop():
		sprite_to_back_to = $"../Sprite2D"
		taskVector = Vector2(-1,0)
		set_vector_and_sprite.rpc("base",taskVector)
		while  get_parent().get_parent().is_in_group("takingNotes"):
			var time = float(randi_range(0,20))/10
			await get_tree().create_timer(3.0+time).timeout
			run_animation()
			run_animation.rpc()
func computer_loop():
	sprite_to_back_to = $"../Sprite2D"
	taskVector = Vector2(0,1)
	set_vector_and_sprite.rpc("base",taskVector)
	while get_parent().get_parent().is_in_group("computer"):
		var time = float(randi_range(0,20))/10
		await get_tree().create_timer(3.5+time).timeout
		
		run_animation()
		run_animation.rpc()
			
func vending_machine_loop():
	taskVector = Vector2(1,0)
	if  get_parent().get_parent().is_in_group("vendingMachine"):
		sprite_to_back_to = $"../Sprite2DWalkingRight"
		set_vector_and_sprite.rpc("right",taskVector)
	else:
		sprite_to_back_to = $"../Sprite2DWalkingLeft"
		set_vector_and_sprite.rpc("left",taskVector)
	while  get_parent().get_parent().is_in_group("vendingMachine") or get_parent().get_parent().is_in_group("vendingMachine2"):
		var time = float(randi_range(0,20))/10
		await get_tree().create_timer(4.0+time).timeout
		run_animation()
		run_animation.rpc()

func _on_character_body_2d_rotate(direction):
	rotate_npc(direction)
	rotate_npc.rpc(direction)
@rpc("any_peer","call_remote")
func rotate_npc(direction):
	match direction:
		"start":
			
			$".".get("parameters/playback").travel("Idle")
			$".".get("parameters/playback").travel("Walking")
		"idle_up":
			$".".get("parameters/playback").travel("Idle")
			
		"idle_down":
			$".".get("parameters/playback").travel("Idle")
			
			
		"up":
			$".".get("parameters/playback").travel("Walking")
			$"../Sprite2D".set("visible", true)
			$"../Sprite2DWalkingDown".set("visible", false)
			set("parameters/Walking/blend_position", Vector2(0,-1))
		"down":
			$".".get("parameters/playback").travel("Walking")
			$"../Sprite2D".set("visible", false)
			$"../Sprite2DWalkingDown".set("visible", true)
			set("parameters/Walking/blend_position", Vector2(0,1))
@rpc("any_peer","call_remote")
func set_vector_and_sprite(sprite, vector):
	match sprite:
		"right":
			sprite_to_back_to = $"../Sprite2DWalkingRight"
		"left":
			sprite_to_back_to = $"../Sprite2DWalkingLeft"
		"base":
			sprite_to_back_to = $"../Sprite2D"
	taskVector = vector
	$"../Sprite2D".set("visible", false)
	sprite_to_back_to.set("visible",true)
@rpc("any_peer","call_remote")
func run_animation():
	sprite_to_back_to.set("visible", false)
	set("parameters/FakingTasks/blend_position", taskVector)
	$"../Sprite2DFakingTasks".set("visible", true)
	await get_tree().create_timer(1).timeout
	$".".get("parameters/playback").travel("Idle")
	$"../Sprite2DFakingTasks".set("visible", false)
	sprite_to_back_to.set("visible",true)
