extends Node2D

var is_tablet_open: bool = false
# sprawdza czy wywołana została akcja "open_tablet" i wywołuje odpowiednią funkcję
func _process(_delta):
	if Input.is_action_just_pressed("open_tablet"):
		manage_deans_tablet()

func manage_deans_tablet():
	match is_tablet_open:
		false:
			print("Tablet opened")
			is_tablet_open = true
		true:
			print("Tablet closed")
			is_tablet_open = false

func catch_student():
	pass

func ring_fire_alarm():
	pass

func kick_student():
	pass
