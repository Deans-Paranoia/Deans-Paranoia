extends CharacterBody2D

#nazwa zmieniona z name na player_name (name w Godot to słowo kluczowe)
var player_name: String

#zmienna która pozwala określić w którą stronę zwrócony jest gracz (jego wektor przed zatrzymaniem)
var last_direction = Vector2.ZERO

#speed zostało dodane dodatkowo tymczasowo (bez tego ruch jest niezauważalny)
var speed: int = 200

func _physics_process(_delta):
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
	
