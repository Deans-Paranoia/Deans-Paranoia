extends Node2D

func _ready():
	# ustawia gracza (mniej więcej) na środku
	position.x = 550
	position.y = 275

# sprawdza czy wywołana została akcja "open_tablet" i wywołuje odpowiednią funkcję
func _process(_delta):
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
