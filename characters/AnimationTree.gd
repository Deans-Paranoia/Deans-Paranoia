extends AnimationTree
var taskVector = Vector2.ZERO
@onready var sprite_to_back_to:Sprite2D = $"../Sprite2DWalkingStudentGirlAnimations"
func _on_task_script_npc_sprite_task(task_type):
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
		sprite_to_back_to = $"../Sprite2DWalkingStudentGirlAnimations"
		taskVector = Vector2(-1,0)
		set_vector_and_sprite.rpc("base",taskVector)
		while  get_parent().get_parent().is_in_group("takingNotes"):
			var time = float(randi_range(0,20))/10
			await get_tree().create_timer(3.0+time).timeout
			if get_parent().get_parent().is_in_group("takingNotes"):
				#print("takingNotes" + get_parent().get_parent().name +" " + get_parent().get_parent().get_groups()[1] )
				run_animation(taskVector)
				run_animation.rpc(taskVector)
func computer_loop():

	sprite_to_back_to = $"../Sprite2DWalkingStudentGirlAnimations"
	taskVector = Vector2(0,1)
	set_vector_and_sprite.rpc("base",taskVector)
	while get_parent().get_parent().is_in_group("computer"):
		var time = float(randi_range(0,20))/10
		await get_tree().create_timer(3.5+time).timeout
		if get_parent().get_parent().is_in_group("computer"):
			#print("computer" + get_parent().get_parent().name +" " + get_parent().get_parent().get_groups()[1])
			run_animation(taskVector)
			run_animation.rpc(taskVector)
			
func vending_machine_loop():
	
	if  get_parent().get_parent().is_in_group("vendingMachine"):
		taskVector = Vector2(1,0)
		sprite_to_back_to = $"../Sprite2DWalkingStudentGirlAnimations"
		set_vector_and_sprite.rpc("right",taskVector)
	else:
		taskVector = Vector2(0,-1)
		sprite_to_back_to = $"../Sprite2DWalkingStudentGirlAnimations"
		set_vector_and_sprite.rpc("left",taskVector)
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
	$"../Sprite2DFakingTasks".set("visible", false)
	$"../Sprite2DWalkingStudentGirlAnimations".set("visible", true)
	match direction:
		#wywoluje na poczatku taska chodzenia
		"start":
			$".".get("parameters/playback").travel("Idle")
			$".".get("parameters/playback").travel("Walking")
		#gdy postac sie zatrzyma na gorze
		"idle_up":
			$".".get("parameters/playback").travel("Idle")
		#gdy postac sie zatrzyma na dole
		"idle_down":
			$".".get("parameters/playback").travel("Idle")
		#gdy postac idzie w gore
		"up":
			$".".get("parameters/playback").travel("Walking")
			set("parameters/Walking/blend_position", Vector2(0,-1))
		#gdy postac idzie w dol
		"down":
			$".".get("parameters/playback").travel("Walking")
			set("parameters/Walking/blend_position", Vector2(0,1))
#ustawiam sprite idle zeby postac byla skierowana w strone taska (potem usune zmienna vector)
@rpc("any_peer","call_remote")
func set_vector_and_sprite(sprite, vector):
	$"../Sprite2DWalkingStudentGirlAnimations".set("visible", false)
	match sprite:
		"right":
			sprite_to_back_to = $"../Sprite2DWalkingStudentGirlAnimations"
		"left":
			sprite_to_back_to = $"../Sprite2DWalkingStudentGirlAnimations"
		"base":
			sprite_to_back_to = $"../Sprite2DWalkingStudentGirlAnimations"
	sprite_to_back_to.set("visible",true)
#metoda odpowiada za wyswietlanie animacji odpowiedniej
@rpc("any_peer","call_remote")
func run_animation(taskVector):
	#upewniam się że postacie nie są dziwnie ulozone przez chodzenie
	$"../Sprite2DWalkingStudentGirlAnimations".set("visible", false)
	set("parameters/Idle/blend_position",  Vector2(0,0))
	set("parameters/Walking/blend_position",  Vector2(0,0))
	#pojawiam animacje taska
	$".".get("parameters/playback").travel("FakingTasks")
	$"../Sprite2DFakingTasks".set("visible", true)
	#upewniam sie ze prawidlowe blend position jest przydzielane (w innym miejscu sie upewnilem ze przypisywanie do grup dziala dobrze)
	if get_parent().get_parent().is_in_group("vendingMachine"):
		set("parameters/FakingTasks/blend_position", Vector2(1,0))
	elif get_parent().get_parent().is_in_group("vendingMachine2"):
		set("parameters/FakingTasks/blend_position", Vector2(0,-1))
	elif get_parent().get_parent().is_in_group("computer"):
		set("parameters/FakingTasks/blend_position",  Vector2(0,1))
	elif  get_parent().get_parent().is_in_group("takingNotes"):
		set("parameters/FakingTasks/blend_position",  Vector2(-1,0))
	
	
	await get_tree().create_timer(1).timeout
	#chowam animacje taska po sekundzie
	$"../Sprite2DFakingTasks".set("visible", false)
	#wylaczam taska włączam idle
	$".".get("parameters/playback").travel("Idle")
	
	sprite_to_back_to.set("visible",true)



