extends Node2D

## Sygnał informujący o najechaniu myszką na studenta.
signal on_student_hovered(name)

## Flaga określająca, czy postać studenta znajduje się w sali wykładowej.
var on_lecture_hall = false

## Funkcja wywoływana przy inicjalizacji obiektu.
func _ready():
	# Ustawienie możliwości interakcji z myszką dla postaci studenta.
	get_parent().input_pickable = true

## Funkcja obsługująca zdarzenie najechania myszką na postać studenta.
func _on_character_body_2d_mouse_entered():
	# Sprawdzenie, czy aktualny gracz to dziekan i czy student znajduje się w sali wykładowej.
	if globalScript.deanId == multiplayer.get_unique_id() and on_lecture_hall:
		# Emitowanie sygnału z nazwą studenta.
		on_student_hovered.emit(get_parent().get_parent().name)

## Funkcja obsługująca zdarzenie opuszczenia myszką obszaru postaci studenta.
## Sprawdza, czy aktualny gracz to dziekan i czy student znajduje się w sali wykładowej.
func _on_character_body_2d_mouse_exited():
	if globalScript.deanId == multiplayer.get_unique_id() and on_lecture_hall:
		# Emitowanie sygnału z wartością null, gdy myszka opuszcza obszar postaci studenta.
		on_student_hovered.emit(null)
