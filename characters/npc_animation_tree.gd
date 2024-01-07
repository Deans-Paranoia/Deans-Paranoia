extends AnimationTree
var taskVector = Vector2.ZERO
func on_task_script_npc_sprite_task(task_type):
	var time = float(randi_range(0,40))/10
	set_npc(time)
	set_npc.rpc(time)
	match task_type:
		"takingNotes":
			taking_notes_loop()
		"computer":
			computer_loop()
		"vendingMachine":
			vending_machine_loop()
@rpc("any_peer","call_remote")
func set_npc(time):
	await get_tree().create_timer(time).timeout
	$".".get("parameters/playback").travel("Idle")
	$".".get("parameters/playback").travel("FakingTasks")
func taking_notes_loop():
		while  get_parent().get_parent().is_in_group("takingNotes"):
			var time = float(randi_range(0,20))/10
			await get_tree().create_timer(3.0+time).timeout
			if get_parent().get_parent().is_in_group("takingNotes"):
				#print("takingNotes" + get_parent().get_parent().name +" " + get_parent().get_parent().get_groups()[1] )
				run_animation(taskVector)
				run_animation.rpc(taskVector)
func computer_loop():
	while get_parent().get_parent().is_in_group("computer"):
		var time = float(randi_range(0,20))/10
		await get_tree().create_timer(3.5+time).timeout
		if get_parent().get_parent().is_in_group("computer"):
			#print("computer" + get_parent().get_parent().name +" " + get_parent().get_parent().get_groups()[1])
			run_animation(taskVector)
			run_animation.rpc(taskVector)
			
func vending_machine_loop():
	while  get_parent().get_parent().is_in_group("vendingMachine") or get_parent().get_parent().is_in_group("vendingMachine2"):
		var time = float(randi_range(0,20))/10
		
		await get_tree().create_timer(4.0+time).timeout
		if get_parent().get_parent().is_in_group("vendingMachine") or get_parent().get_parent().is_in_group("vendingMachine2"):
			#print("vending" + get_parent().get_parent().name +" " + get_parent().get_parent().get_groups()[1])
			run_animation(taskVector)
			run_animation.rpc(taskVector)

func _on_character_body_2d_rotate(direction):
	rotate_npc(direction)
	rotate_npc.rpc(direction)
@rpc("any_peer","call_remote")
func rotate_npc(direction):
	match direction:
		#wywoluje na poczatku taska chodzenia
		"start":
			$"../Sprite2DFakingTasks".set("visible", false)
			$"../Sprite2DWalkingStudentGirlAnimations".set("visible", true)
			$".".get("parameters/playback").travel("Idle")
			$".".get("parameters/playback").travel("Walking")
		#gdy postac sie zatrzyma na gorze
		"idle_up":
			$".".get("parameters/playback").travel("Idle")
			set("parameters/Idle/blend_position", Vector2(0,-1))
		#gdy postac sie zatrzyma na dole
		"idle_down":
			$".".get("parameters/playback").travel("Idle")
			set("parameters/Idle/blend_position", Vector2(0,1))
		#gdy postac idzie w gore
		"up":
			$".".get("parameters/playback").travel("Walking")
			set("parameters/Walking/blend_position", Vector2(0,-1))
		#gdy postac idzie w dol
		"down":
			$".".get("parameters/playback").travel("Walking")
			set("parameters/Walking/blend_position", Vector2(0,1))

	
#metoda odpowiada za wyswietlanie animacji odpowiedniej
@rpc("any_peer","call_remote")
func run_animation(taskVector):
	$".".get("parameters/playback").travel("Idle")
	$"../Sprite2DWalkingStudentGirlAnimations".set("visible", false)
	
	#upewniam się że postacie nie są dziwnie ulozone przez chodzenie
	set("parameters/Idle/blend_position",  Vector2(0,0))
	set("parameters/Walking/blend_position",  Vector2(0,0))
	#pojawiam animacje taska
	$".".get("parameters/playback").travel("FakingTasks")
	$"../Sprite2DFakingTasks".set("visible", true)
	#upewniam sie ze prawidlowe blend position jest przydzielane (w innym miejscu sie upewnilem ze przypisywanie do grup dziala dobrze)
	if get_parent().get_parent().is_in_group("vendingMachine"):
		set("parameters/FakingTasks/blend_position", Vector2(1,0))
		set("parameters/Idle/blend_position", Vector2(1,0))
	elif get_parent().get_parent().is_in_group("vendingMachine2"):
		set("parameters/FakingTasks/blend_position", Vector2(0,-1))
		set("parameters/Idle/blend_position", Vector2(-1,0))
	elif get_parent().get_parent().is_in_group("computer"):
		set("parameters/FakingTasks/blend_position",  Vector2(0,1))
		set("parameters/Idle/blend_position", Vector2(0,-1))
	elif  get_parent().get_parent().is_in_group("takingNotes"):
		set("parameters/FakingTasks/blend_position",  Vector2(-1,0))
		set("parameters/Idle/blend_position", Vector2(0,-1))
	elif get("parameters/Idle/blend_position") == Vector2(0,0):
		set("parameters/Idle/blend_position", Vector2(0,-1))
	
	await get_tree().create_timer(1).timeout
	#chowam animacje taska po sekundzie
	$"../Sprite2DFakingTasks".set("visible", false)
	#wylaczam taska włączam idle
	$".".get("parameters/playback").travel("Idle")
	$"../Sprite2DWalkingStudentGirlAnimations".set("visible", true)
