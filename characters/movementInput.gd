## Klasa PlayerCharacter - skrypt obsługujący postać gracza.

extends CharacterBody2D

## Sygnał informujący o kierunku ruchu postaci.
signal direction(direction_vector: Vector2)

## Nazwa gracza.
var player_name: String

## Flaga określająca możliwość ruchu postaci.
var can_move: bool = true

## Zmienna określająca ostatni kierunek ruchu gracza przed zatrzymaniem.
var last_direction = Vector2.ZERO

## Tymczasowa prędkość, używana do zatrzymywania i przywracania ruchu.
var temp_speed
#speed zostało dodane dodatkowo tymczasowo (bez tego ruch jest niezauważalny)
## Prędkość ruchu gracza.
var speed: int = 250

## Flaga określająca, czy gracz może się poruszać.
var canMove = true

## Funkcja wywoływana przy inicjalizacji obiektu.
func _ready():
	# Ustawienie autorytetu dla synchronizacji wieloosobowej.
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	
	# Dodanie kamery dla gracza o autorytecie.
	if multiplayer != null:
		if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
			var camera = Camera2D.new()
			camera.name = "camera " + str(multiplayer.get_unique_id())
			camera.zoom = Vector2(1.8, 1.8)
			
			# Sprawdzenie, czy kamera jest aktywna i znajduje się w drzewie węzłów.
			if camera.enabled && camera.is_inside_tree():
				camera.make_current()
			
			add_child(camera)

## Parametry: _delta
## Funkcja wywoływana w każdej klatce fizyki.
func _physics_process(_delta):
	# Sprawdzenie, czy obecny gracz posiada autorytet do synchronizacji.
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id() and can_move:
		apply_physics()

## Metoda aplikująca fizykę ruchu gracza.
func apply_physics():
	if canMove:
		velocity = calculate_velocity()
		emit_direction_signal(velocity)
		move_and_slide()

## Parametry: None
## Return: Wektor prędkości gracza
## Metoda obliczająca wektor prędkości gracza na podstawie kierunku z wejścia.
func calculate_velocity():
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.length() > 0:
		last_direction = direction.normalized()
	return direction.normalized() * speed

## Return: Prędkość gracza
## Metoda zwracająca aktualną wartość prędkości gracza.
func take_current_speed_value() -> int:
	return speed

## Metoda zatrzymująca ruch gracza.
func stop_player_movement():
	speed = 0

## Parametry: tempspeed
## Metoda przywracająca ruch gracza.
func restore_player_movement(tempspeed):
	speed = tempspeed

## Parametry: velocity - wektor prędkości
## Funkcja emitująca sygnał informujący o kierunku ruchu.
func emit_direction_signal(velocity):
	direction.emit(velocity)

## Parametry: duration - czas wyłaczenia ruchu
## Metoda wyłączająca ruch gracza na określony czas.
func _on_disable_player_movement_for_duration(duration):
	canMove = false
	await get_tree().create_timer(duration).timeout
	canMove = true

## Metoda zdalna obsługująca zatrzymanie animacji chodzenia gracza.
@rpc("any_peer", "call_remote")
func stop_walking_animation():
	get_node_or_null("AnimationTree").get("parameters/playback").travel("Idle")

## Parametry: is_opened - flaga przechowująca stan okna chatu (otwarty/zamknięty)
## Metoda obsługująca otwieranie i zamykanie okna czatu.
func _on_chat_chat_opened(is_opened):
	if is_opened:
		temp_speed = speed
		speed = 0
		stop_walking_animation()
		stop_walking_animation.rpc()
	else:
		speed = temp_speed
	canMove = !is_opened
