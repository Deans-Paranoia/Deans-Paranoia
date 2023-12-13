extends AnimationTree


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_character_body_2d_direction(velocity:Vector2):
	if velocity == Vector2.ZERO:
		if $".".get("parameters/playback").get_current_node() != "Idle":
			#print($".".get("parameters/playback").get_current_node())
			$".".get("parameters/playback").travel("Idle")
	else:
		$".".get("parameters/playback").travel("Walking")
		velocity = velocity.normalized()
		set("parameters/Walking/blend_position", velocity)
		set("parameters/Idle/blend_position", velocity)
		$"../Sprite2DWalkingRight".set("visible", false)
		$"../Sprite2DWalkingLeft".set("visible", false)
		$"../Sprite2DWalkingDown".set("visible", false)
		$"../Sprite2D".set("visible", false)

		if velocity.x<0:
			$"../Sprite2DWalkingLeft".set("visible", true)
		elif velocity.x>0:
			$"../Sprite2DWalkingRight".set("visible", true)
		elif velocity.y>0:
			$"../Sprite2DWalkingDown".set("visible", true)
		else:
			$"../Sprite2D".set("visible", true)
			




