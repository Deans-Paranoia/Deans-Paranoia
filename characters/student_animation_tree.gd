extends AnimationTree


# Called when the node enters the scene tree for the first time.
func _ready():
		$"../Sprite2DFakingTasks".set("visible", false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_character_body_2d_direction(velocity:Vector2):
	run_animation(velocity)
	if $"../../Timer/".get("wait_time")==0.0:
		run_animation.rpc(velocity)
			
@rpc("any_peer","call_remote")
func run_animation(velocity):
	if velocity == Vector2.ZERO:
		if $".".get("parameters/playback").get_current_node() != "Idle":
			#print($".".get("parameters/playback").get_current_node())
		
			$".".get("parameters/playback").travel("Idle")
	else:
		$".".get("parameters/playback").travel("Walking")
		velocity = velocity.normalized()
		set("parameters/Walking/blend_position", velocity)
		set("parameters/Idle/blend_position", velocity)
		$"../Sprite2DFakingTasks".set("visible", false)
		$"../Sprite2DWalkingRight".set("visible", false)
		$"../Sprite2DWalkingLeft".set("visible", false)
		$"../Sprite2DWalkingDown".set("visible", false)
		$"../Sprite2D".set("visible", false)
		$"../Sprite2DFakingTasks".set("visible", false)

		if velocity.x<0:
			$"../Sprite2DWalkingLeft".set("visible", true)
		elif velocity.x>0:
			$"../Sprite2DWalkingRight".set("visible", true)
		elif velocity.y>0:
			$"../Sprite2DWalkingDown".set("visible", true)
		else:
			$"../Sprite2D".set("visible", true)



func _on_student_player_task(task_type):
	task_animation(task_type)
	task_animation.rpc(task_type)

@rpc("any_peer","call_remote")
func task_animation(task_type):
	$".".get("parameters/playback").travel("Idle")
	var taskVector = Vector2.ZERO
	var sprite_to_back_to = $"../Sprite2DWalkingDown"
	$"../Sprite2DWalkingRight".set("visible", false)
	$"../Sprite2DWalkingLeft".set("visible", false)
	$"../Sprite2DWalkingDown".set("visible", false)
	$"../Sprite2D".set("visible", false)
	
	match task_type:
		"computer":
			taskVector = Vector2(0,1)
			sprite_to_back_to = $"../Sprite2D"
		"takingNotes":
			taskVector = Vector2(-1,0)
			sprite_to_back_to = $"../Sprite2D"
		"vendingMachine1":
			sprite_to_back_to = $"../Sprite2DWalkingRight"
			taskVector = Vector2(1,0)
			
		"vendingMachine2":
			taskVector = Vector2(0,-1)
			sprite_to_back_to = $"../Sprite2DWalkingLeft"
		_:
			print("Something else")
			
	$".".get("parameters/playback").travel("FakingTasks")
	set("parameters/FakingTasks/blend_position", taskVector)
	$"../Sprite2DFakingTasks".set("visible", true)
	await get_tree().create_timer(1).timeout
	$".".get("parameters/playback").travel("Idle")
	sprite_to_back_to.set("visible",true)
	$"../Sprite2DFakingTasks".set("visible", false)

