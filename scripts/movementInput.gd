extends CharacterBody2D

#nazwa zmieniona z name na player_name (name w Godot to słowo kluczowe)
var player_name: String

#zmienna która pozwala określić w którą stronę zwrócony jest gracz (jego wektor przed zatrzymaniem)
var last_direction = Vector2.ZERO

#speed zostało dodane dodatkowo tymczasowo (bez tego ruch jest niezauważalny)
var speed: int = 250

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
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		apply_physics()

func apply_physics():
	velocity = calculate_velocity()
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
	
