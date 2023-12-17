extends Node2D

var is_tablet_open: bool = false
# sprawdza czy wywołana została akcja "open_tablet" i wywołuje odpowiednią funkcję
var body:CharacterBody2D
var can_use_alarm : bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna odpalic alarm
func _ready():
	body = get_node_or_null(str(self.name))
func _input(event):
	# event do obslugi tabletu przez dziekana
	if event.is_action_pressed("open_tablet"):
		if self.name == str(multiplayer.get_unique_id()):
			manage_deans_tablet()
	if body!= null and body.can_move == false:
		return
	# event do interakcji z obiektami przez dziekana
	if event.is_action_pressed("interaction"):
		# obsluga alarmu
		if self.name == str(multiplayer.get_unique_id()):
			var fire_alarm_reference = get_node_or_null("../thirdFloor/fire_alarm")
			if fire_alarm_reference and fire_alarm_reference.useable and can_use_alarm and self.name == str(multiplayer.get_unique_id()):
				ring_fire_alarm()
				fire_alarm_reference.useable = false
				change_alarm_state.rpc()
				
			var catchable_objects = get_tree().get_nodes_in_group("Catchable_Students")
			for catchable_object in catchable_objects:
				var student_id = str(catchable_object.name)
				catchable_object.catch_student.rpc_id(int(student_id))

@rpc("any_peer","call_remote")
func change_alarm_state():
	var fire_alarm_reference = get_node_or_null("../thirdFloor/fire_alarm")
	if fire_alarm_reference:
		fire_alarm_reference.useable = false	
@rpc("any_peer","call_local")
func remove_obstacle(_obstacle_to_destroy):
	_obstacle_to_destroy.queue_free()
func manage_deans_tablet():
	# funkcja do obsługi tabletu przez dziekana
	match is_tablet_open:
		false:
			print("Tablet opened")
			is_tablet_open = true
		true:
			print("Tablet closed")
			is_tablet_open = false

func ring_fire_alarm():
	# funkcja do obsługi alarmu przez dziekana
	print("Alarm rang")
	
func catch_student():
	pass

func kick_student():
	pass
	

func _on_area_2d_area_entered(area):
	#funkcja  do rejestrowanie aktualnie area, do ktorej weszlismy
	var area_entered = area.get_name()
	if (area_entered == "FireAlarmArea"):
		can_use_alarm = true


func _on_area_2d_area_exited(area):
	#funkcja  do rejestrowania aktualnie opuszczonej are
	var area_exited = area.get_name()
	if (area_exited == "FireAlarmArea"):
		can_use_alarm = false


func _on_catch_student_area_area_entered(area):
	var object = area.get_parent().get_parent()
	if object.is_in_group("Student"):
		object.add_to_group("Catchable_Students")
		
func _on_catch_student_area_area_exited(area):
	var object = area.get_parent().get_parent()
	if object.is_in_group("Student"):
		object.remove_from_group("Catchable_Students")
