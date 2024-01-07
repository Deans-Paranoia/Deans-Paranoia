extends AnimationTree


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../Sprite2D".set("visible", true)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_character_body_2d_direction(velocity:Vector2):
	run_animation(velocity)
	if $"../../Timer/".is_stopped():
		run_animation.rpc(velocity)
		$"../../Timer".set("wait_time", 0.1)
		$"../../Timer".start()

			
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

