extends AnimationTree

## Wektor związany z bieżącym zadaniem postaci NPC.
var taskVector = Vector2.ZERO

## Sprite, do którego zostanie przywrócony animowany sprite po zakończeniu zadania.
@onready var sprite_to_back_to: Sprite2D = $"../Sprite2D"

## Metoda obsługująca animacje zadania "takingNotes".
func taking_notes_loop():
	sprite_to_back_to = $"../Sprite2D"
	taskVector = Vector2(-1, 0)
	set_vector_and_sprite.rpc("base", taskVector)
	
	while get_parent().get_parent().is_in_group("takingNotes"):
		var time = float(randi_range(0, 20)) / 10
		await get_tree().create_timer(3.0 + time).timeout
		
		if get_parent().get_parent().is_in_group("takingNotes"):
			run_animation(taskVector)
			run_animation.rpc(taskVector)

## Metoda obsługująca animacje zadania "computer".
func computer_loop():
	sprite_to_back_to = $"../Sprite2D"
	taskVector = Vector2(0, 1)
	set_vector_and_sprite.rpc("base", taskVector)
	
	while get_parent().get_parent().is_in_group("computer"):
		var time = float(randi_range(0, 20)) / 10
		await get_tree().create_timer(3.5 + time).timeout
		
		if get_parent().get_parent().is_in_group("computer"):
			run_animation(taskVector)
			run_animation.rpc(taskVector)

## Metoda obsługująca animacje zadania "vendingMachine".
func vending_machine_loop():
	if get_parent().get_parent().is_in_group("vendingMachine"):
		taskVector = Vector2(1, 0)
		sprite_to_back_to = $"../Sprite2DWalkingRight"
		set_vector_and_sprite.rpc("right", taskVector)
	else:
		taskVector = Vector2(0, -1)
		sprite_to_back_to = $"../Sprite2DWalkingLeft"
		set_vector_and_sprite.rpc("left", taskVector)
	
	while get_parent().get_parent().is_in_group("vendingMachine") or get_parent().get_parent().is_in_group("vendingMachine2"):
		var time = float(randi_range(0, 20)) / 10
		await get_tree().create_timer(4.0 + time).timeout
		
		if get_parent().get_parent().is_in_group("vendingMachine") or get_parent().get_parent().is_in_group("vendingMachine2"):
			run_animation(taskVector)
			run_animation.rpc(taskVector)

## Metoda obsługująca zdarzenie obrotu postaci NPC.
func _on_character_body_2d_rotate(direction):
	rotate_npc(direction)
	rotate_npc.rpc(direction)

## Parametry: direction
## Metoda zdalna obsługująca obrót postaci NPC.
@rpc("any_peer", "call_remote")
func rotate_npc(direction):
	match direction:
		"start":
			$".".get("parameters/playback").travel("Idle")
			$".".get("parameters/playback").travel("Walking")
		"idle_up":
			$".".get("parameters/playback").travel("Idle")
		"idle_down":
			$".".get("parameters/playback").travel("Idle")
		"up":
			$".".get("parameters/playback").travel("Walking")
			$"../Sprite2D".set("visible", true)
			$"../Sprite2DWalkingDown".set("visible", false)
			set("parameters/Walking/blend_position", Vector2(0, -1))
		"down":
			$".".get("parameters/playback").travel("Walking")
			$"../Sprite2D".set("visible", false)
			$"../Sprite2DWalkingDown".set("visible", true)
			set("parameters/Walking/blend_position", Vector2(0, 1))

## Parametry: sprite, vector
## Metoda zdalna ustawiająca wektor i sprite postaci NPC.
@rpc("any_peer", "call_remote")
func set_vector_and_sprite(sprite, vector):
	$"../Sprite2DWalkingDown".set("visible", false)
	$"../Sprite2DWalkingRight".set("visible", false)
	$"../Sprite2DWalkingLeft".set("visible", false)
	$"../Sprite2D".set("visible", false)
	
	match sprite:
		"right":
			sprite_to_back_to = $"../Sprite2DWalkingRight"
		"left":
			sprite_to_back_to = $"../Sprite2DWalkingLeft"
		"base":
			sprite_to_back_to = $"../Sprite2D"
	
	sprite_to_back_to.set("visible", true)

## Parametry: taskVector
## Metoda zdalna uruchamiająca odpowiednią animację postaci NPC.
@rpc("any_peer", "call_remote")
func run_animation(taskVector):
	$"../Sprite2DWalkingDown".set("visible", false)
	$"../Sprite2DWalkingRight".set("visible", false)
	$"../Sprite2DWalkingLeft".set("visible", false)
	$"../Sprite2D".set("visible", false)
	
	set("parameters/Idle/blend_position", Vector2(0, 0))
	set("parameters/Walking/blend_position", Vector2(0, 0))
	
	$".".get("parameters/playback").travel("FakingTasks")
	$"../Sprite2DFakingTasks".set("visible", true)
	
	if get_parent().get_parent().is_in_group("vendingMachine"):
		set("parameters/FakingTasks/blend_position", Vector2(1, 0))
	elif get_parent().get_parent().is_in_group("vendingMachine2"):
		set("parameters/FakingTasks/blend_position", Vector2(0, -1))
	elif get_parent().get_parent().is_in_group("computer"):
		set("parameters/FakingTasks/blend_position", Vector2(0, 1))
	elif get_parent().get_parent().is_in_group("takingNotes"):
		set("parameters/FakingTasks/blend_position", Vector2(-1, 0))
	
	await get_tree().create_timer(1).timeout
	
	$"../Sprite2DFakingTasks".set("visible", false)
	$".".get("parameters/playback").travel("Idle")
	
	sprite_to_back_to.set("visible", true)
