extends AnimationTree


# Called when the node enters the scene tree for the first time.
func _ready():
	#$"../Sprite2DWalkingStudentGirlAnimations".set("visible", true)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_character_body_2d_direction(velocity:Vector2):
	run_animation(velocity)
	if $"../../Timer/".is_stopped():
		run_animation.rpc(velocity)
		run_animation(velocity)
		$"../../Timer".set("wait_time", 0.1)
		$"../../Timer".start()
func _on_student_catched():
	run_catch_animation()
	run_catch_animation.rpc()
@rpc("any_peer","call_remote")
func run_catch_animation():
	$"../Sprite2D".set("visible", false)
	$".".get("parameters/playback").travel("CatchStudentGirl")
			
@rpc("any_peer","call_remote")
func run_animation(velocity):
	if velocity == Vector2.ZERO:
		if $".".get("parameters/playback").get_current_node() != "Idle":
			$".".get("parameters/playback").travel("Idle")
	else:
		$".".get("parameters/playback").travel("Walking")
		velocity = velocity.normalized()
		set("parameters/Walking/blend_position", velocity)
		set("parameters/Idle/blend_position", velocity)

