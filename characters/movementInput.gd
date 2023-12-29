extends CharacterBody2D

signal direction(direction_vector: Vector2)

#nazwa zmieniona z name na player_name (name w Godot to słowo kluczowe)
var player_name: String
var can_move: bool = true
#zmienna która pozwala określić w którą stronę zwrócony jest gracz (jego wektor przed zatrzymaniem)
var last_direction = Vector2.ZERO
var temp_speed
#speed zostało dodane dodatkowo tymczasowo (bez tego ruch jest niezauważalny)
var speed: int = 250

# zmienna okresla czy gracz moze sie ruszac
var canMove = true

func _ready():
	#dodaj to do klasy movementinput, also dodaj multiplayerSychronizer ( nie wiem czy do deana i studenta czy tez playera)
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	if multiplayer != null:
		
		if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
			var camera = Camera2D.new()
			
			camera.name = "camera " +str( multiplayer.get_unique_id())
			camera.zoom = Vector2(1.8,1.8)
			#if camera.enabled && camera.is_inside_tree():
			if camera.enabled && camera.is_inside_tree():
				camera.make_current()
			
			add_child(camera)
func _physics_process(_delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id() and can_move:
		apply_physics()

func apply_physics():
	if canMove:
		velocity = calculate_velocity()
		emit_direction_signal(velocity)
		move_and_slide()
	
func calculate_velocity():
	var direction = Input.get_vector("left","right","up","down")
	if direction.length() > 0:
		last_direction = direction.normalized()
	return direction.normalized() * speed
	
func take_current_speed_value() -> int:
	#metoda zwraca aktualna wartosc speed
	return speed

func stop_player_movement():
	#metoda do zastopowania playera (jego movementu)
	speed = 0
	
func restore_player_movement(tempspeed):
	#metoda do przywrocenia dawnego movementu
	speed = tempspeed
	
func emit_direction_signal(velocity):
	direction.emit(velocity)


func _on_disable_player_movement_for_duration(duration):
	canMove = false
	await get_tree().create_timer(duration).timeout
	canMove = true


@rpc("any_peer","call_remote")
func stop_walking_animation():
	get_node_or_null("AnimationTree").get("parameters/playback").travel("Idle")
func _on_chat_chat_opened(is_opened):
	if is_opened:
		temp_speed = speed
		speed = 0
		stop_walking_animation()
		stop_walking_animation.rpc()
	else:
		speed = temp_speed
	canMove = !is_opened
