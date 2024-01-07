## Klasa odpowiedzialna za obsługę obiektu Node2D, zawierającego obszar notatki, komputera i chodzenia
extends Node2D

#sygnały idą do map.gd
## Sygnał informujący o widoczności zadania z notatkami
signal noteTask(isVisible)
## Sygnał informujący o widoczności zadania z komputerem
signal computerTask(isVisible)
## Sygnał informujący o widoczności zadania z chodzeniem
signal walkingTask(isVisible)

## Referencja do obiektu mapy
@onready var map = get_tree().root.get_node("Map")

## Funkcja wywoływana po przygotowaniu obiektu do użycia
func _ready():
	## Połączenie sygnałów z odpowiednimi funkcjami w skrypcie mapy
	noteTask.connect(map.npcs_notes)
	computerTask.connect(map.npcs_computer)
	walkingTask.connect(map.npcs_walking)

## Funkcja wywoływana przy wejściu na obszar notatki
func _on_notes_area_notifier_screen_entered():
	noteTask.emit(true)

## Funkcja wywoływana przy opuszczeniu obszaru notatki
func _on_notes_area_notifier_screen_exited():
	noteTask.emit(false)

## Funkcja wywoływana przy wejściu na obszar komputera
func _on_computer_area_notifier_screen_entered():
	computerTask.emit(true)

## Funkcja wywoływana przy opuszczeniu obszaru komputera
func _on_computer_area_notifier_screen_exited():
	computerTask.emit(false)

## Funkcja wywoływana przy wejściu na obszar chodzenia
func _on_walking_notifier_screen_entered():
	walkingTask.emit(true)

## Funkcja wywoływana przy opuszczeniu obszaru chodzenia
func _on_walking_notifier_screen_exited():
	walkingTask.emit(true)
