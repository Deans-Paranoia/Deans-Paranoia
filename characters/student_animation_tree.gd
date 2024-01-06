extends AnimationTree


# Called when the node enters the scene tree for the first time.
func _ready():
		$"../Sprite2DFakingTasks".set("visible", false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_character_body_2d_direction(velocity:Vector2):
	## Parametry: velocity:Vector2 - prędkość animacji
	## Funkcja do włączania animacji gracza
	run_animation(velocity)
	if $"../../Timer/".is_stopped():
		run_animation.rpc(velocity)
		$"../../Timer".set("wait_time", 0.1)
		$"../../Timer".start()
			
@rpc("any_peer","call_remote")
func run_animation(velocity):
	## Parametry: velocity:Vector2 - prędkość animacji
	## Funkcja animacji gracza, przełącza między animacją chodzenia a staniem
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
		$"../Sprite2DWalkingStudentGirlAnimations".set("visible", true)



func _on_student_player_task(task_type):
	## Parametry: task_type - typ tasku
	## Funkcja do przekierowania typu taska, odpala animacje konkretnego taska 
	## dla gracza.
	task_animation(task_type)
	task_animation.rpc(task_type)

@rpc("any_peer","call_remote")
func task_animation(task_type):
	## Parametry: task_type - typ tasku
	## Funkcja do odtwarzania animacji tasków gracza
	$".".get("parameters/playback").travel("Idle")
	var taskVector = Vector2.ZERO
	$"../Sprite2DWalkingStudentGirlAnimations".set("visible", false)
	
	match task_type:
		"computer":
			taskVector = Vector2(0,1)
		"takingNotes":
			taskVector = Vector2(-1,0)
		"vendingMachine1":
			taskVector = Vector2(1,0)
			
		"vendingMachine2":
			taskVector = Vector2(0,-1)
		_:
			print("Something else")
			
	$".".get("parameters/playback").travel("FakingTasks")
	set("parameters/FakingTasks/blend_position", taskVector)
	$"../Sprite2DFakingTasks".set("visible", true)
	await get_tree().create_timer(1).timeout
	$".".get("parameters/playback").travel("Idle")
	$"../Sprite2DWalkingStudentGirlAnimations".set("visible", true)
	$"../Sprite2DFakingTasks".set("visible", false)

