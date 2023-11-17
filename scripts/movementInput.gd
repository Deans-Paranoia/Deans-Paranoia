extends CharacterBody2D

#nazwa zmieniona z name na player_name (name w Godot to słowo kluczowe)
var player_name: String

#speed zostało dodane dodatkowo tymczasowo (bez tego ruch jest niezauważalny)
var speed: int = 200

func _physics_process(_delta):
	apply_physics()

func apply_physics():
	velocity = calculate_velocity()
	move_and_slide()
	
func calculate_velocity():
	var direction = Input.get_vector("left","right","up","down")
	return direction.normalized() * speed
	
