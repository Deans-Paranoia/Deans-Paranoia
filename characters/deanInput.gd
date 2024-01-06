extends Node2D
signal student_picked()
signal student_catched(name)
@onready var ui_hints_instance = load("res://ui/ui_hints.tscn").instantiate()
var is_tablet_open: bool = false
@onready var scene = load("res://ui/deans_tablet/deans_tablet.tscn")
var tablet_scene
# sprawdza czy wywołana została akcja "open_tablet" i wywołuje odpowiednią funkcję
var body:CharacterBody2D

var can_use_alarm : bool = false
# sprawdza czy znajduje sie w strefie gdzie mozna odpalic alarm
func _ready():
	var hall = get_tree().root.get_node("Map/lecture_hall")
	body = get_node_or_null(str(self.name))
	if globalScript.deanId == multiplayer.get_unique_id() and get_parent().name != "lecture_hall":
		student_picked.connect(hall.on_student_moved)
		student_catched.connect(hall.on_student_catched)
		ui_hints_instance.get_node("e_key").visible = false
		ui_hints_instance.get_node("space_key").visible = false
		ui_hints_instance.get_node("space_key/Label2").text = "Złap"
		ui_hints_instance.get_node("e_key/Label").text = "alarm"
		add_child(ui_hints_instance)
func _input(event):
	# event do obslugi tabletu przez dziekana
	if event.is_action_pressed("open_tablet"):
		if self.name == str(multiplayer.get_unique_id()):
			manage_deans_tablet()
	if event.is_action_pressed("kick_student"):
		if self.name == str(multiplayer.get_unique_id()) and body.can_move == false:
			student_picked.emit()
				
	if body!= null and body.can_move == false:
		return
	# event do interakcji z obiektami przez dziekana
	if event.is_action_pressed("interaction"):
		# obsluga alarmu
		if self.name == str(multiplayer.get_unique_id()):
			var fire_alarm_reference = get_node_or_null("../thirdFloor/fire_alarm")
			if fire_alarm_reference and fire_alarm_reference.useable and can_use_alarm and self.name == str(multiplayer.get_unique_id()):
				change_alarm_state.rpc()
	if event.is_action_pressed("catch_student"):	
		if self.name == str(multiplayer.get_unique_id()):		
			var catchable_objects = get_tree().get_nodes_in_group("Catchable_Students")
			for catchable_object in catchable_objects:
				if catchable_object.catchable and catchable_object.is_catched ==false:
					var student_id = str(catchable_object.name)
					catchable_object.catch_student.rpc_id(int(student_id))
					print("catched")
					#print(globalScript.Players[])
					student_catched.emit(globalScript.Players[int(student_id)].fakeName)
			
@rpc("any_peer","call_remote")
func change_alarm_state():
	var fire_alarm_reference = get_node_or_null("../thirdFloor/fire_alarm")
	if fire_alarm_reference:
		fire_alarm_reference.use_alarm(false)

func manage_deans_tablet():
	
	# funkcja do obsługi tabletu przez dziekana
	match is_tablet_open:
		false:
			if get_tree().root.get_node_or_null("DeansTablet")==null:
				tablet_scene = scene.instantiate()
				get_tree().root.add_child(tablet_scene)
			tablet_scene.visible = true
			is_tablet_open = true
		true:
			tablet_scene.visible = false
			is_tablet_open = false


	
func catch_student():
	pass

func kick_student():
	pass
	

func _on_area_2d_area_entered(area):
	#funkcja  do rejestrowanie aktualnie area, do ktorej weszlismy
	var area_entered = area.get_name()
	if (area_entered == "FireAlarmArea"):
		can_use_alarm = true
		ui_hints_instance.get_node("e_key").visible = true

func _on_area_2d_area_exited(area):
	#funkcja  do rejestrowania aktualnie opuszczonej are
	var area_exited = area.get_name()
	if (area_exited == "FireAlarmArea"):
		can_use_alarm = false
		ui_hints_instance.get_node("e_key").visible = false
func _on_catch_student_area_area_entered(area):
	var object = area.get_parent().get_parent()
	
	if object.is_in_group("Student"):
		object.add_to_group("Catchable_Students")
	if get_tree().get_nodes_in_group("Catchable_Students").size()>=1:
		for i in get_tree().get_nodes_in_group("Catchable_Students"):
			if i.catchable == true:
				ui_hints_instance.get_node("space_key").visible = true
				return
func _on_catch_student_area_area_exited(area):
	var object = area.get_parent().get_parent()
	if object.is_in_group("Student"):
		object.remove_from_group("Catchable_Students")
	if get_tree().get_nodes_in_group("Catchable_Students").size()==0:
		ui_hints_instance.get_node("space_key").visible = false
	else:
		var is_one_catchable = false
		for i in get_tree().get_nodes_in_group("Catchable_Students"):
			if i.catchable == true:
				is_one_catchable = true
		if is_one_catchable == false:
			ui_hints_instance.get_node("space_key").visible = true
		else:
			ui_hints_instance.get_node("space_key").visible = false
