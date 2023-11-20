extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("open_tablet"):
		open_deans_tablet()

func open_deans_tablet():
	print("Tablet opened")

func catch_student():
	pass

func ring_fire_alarm():
	pass

func kick_student():
	pass
