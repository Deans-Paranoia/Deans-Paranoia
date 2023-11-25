extends Node2D

var can_use_alarm : bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna odpalic alarm

var is_tablet_open: bool = false
# sprawdza czy wywołana została akcja "open_tablet" i wywołuje odpowiednią funkcję

func _process(_delta):
	if Input.is_action_just_pressed("open_tablet"):
		manage_deans_tablet()
	
	if Input.is_action_just_pressed("use_alarm"):
		var fire_alarm_reference = get_node("../fire_alarm")
		if fire_alarm_reference.useable and can_use_alarm:
			ring_fire_alarm()
			fire_alarm_reference.useable = false
			

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
#write your logic for dean here, also create fireAlarm scene and you can attach a script for this scene
func ring_fire_alarm():
	print("Alarm rang")

func kick_student():
	pass
	
func _on_player_area_area_entered(area):
	#metoda do rejestrowanie aktualnie area, do ktorej weszlismy
	var area_entered = area.get_name()
	if (area_entered == "FireAlarmArea"):
		can_use_alarm = true

func _on_player_area_area_exited(area):
	#metoda do rejestrowania aktualnie opuszczonej are
	var area_exited = area.get_name()
	if (area_exited == "FireAlarmArea"):
		can_use_alarm = false
