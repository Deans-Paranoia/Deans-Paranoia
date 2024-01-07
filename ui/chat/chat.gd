## Klasa odpowiedzialna za obsługę warstwy czatu
extends CanvasLayer

## Zmienna przechowująca scenę dla nowej wiadomości
@export var new_message: PackedScene

## Referencja do kontrolki wprowadzania tekstu
@onready var line_edit = $Panel/VBoxInput/Input

## Referencja do panelu wiadomości
@onready var message_panel = $Panel/VBoxMessages

## Flaga określająca, czy czat jest aktualnie używany
var chat_in_use: bool = false

## Sygnał informujący o otwarciu lub zamknięciu czatu
signal chat_opened(is_opened: bool)

## Funkcja obsługująca użycie czatu przez studenta
func _on_student_use_chat(name):
	# Połączenie sygnału z funkcją obsługującą otwarcie czatu dla konkretnego studenta
	chat_opened.connect(get_parent().get_node(str(name)+"/"+str(name))._on_chat_chat_opened)
	
	# Sprawdzenie, czy czat jest obecnie używany
	if chat_in_use:
		# Jeżeli pole tekstowe jest puste, zakończ używanie czatu
		if len(line_edit.text) <= 0:
			line_edit.release_focus()
			line_edit.placeholder_text = "Press ENTER to type"
			chat_in_use = false
			chat_opened.emit(false)
			$".".scale = Vector2(0.5,0.5)
			$"Panel".modulate = Color(1,1,1,0.5)
		else:
			## Dodaj nową wiadomość do czatu
			add_message_to_chat(line_edit.text,name)
			add_message_to_chat.rpc(line_edit.text,name)
			line_edit.text = ""
	else:
		# Rozpocznij korzystanie z czatu
		line_edit.grab_focus()
		line_edit.placeholder_text = ""
		chat_in_use = true
		
		# Emituj sygnał o otwarciu czatu
		chat_opened.emit(true)
		
		$".".scale = Vector2(1,1)
		$"Panel".modulate = Color(1,1,1,1)
		
	# Odłącz sygnał po zakończeniu użycia czatu
	chat_opened.disconnect(get_parent().get_node(str(name)+"/"+str(name))._on_chat_chat_opened)
	
## Parametry: name
## Funkcja obsługująca wyjście studenta z czatu
func _on_student_exit_chat(name):
	# Sprawdzenie, czy czat jest obecnie używany
	if chat_in_use:
		# Połączenie sygnału z funkcją obsługującą otwarcie czatu dla konkretnego studenta
		chat_opened.connect(get_parent().get_node(str(name)+"/"+str(name))._on_chat_chat_opened)
		
		# Zakończ używanie czatu
		line_edit.release_focus()
		chat_in_use = false
		chat_opened.emit(false)
		$".".scale = Vector2(0.5,0.5)
		$"Panel".modulate = Color(1,1,1,0.5)
		
		# Odłącz sygnał po zakończeniu użycia czatu
		chat_opened.disconnect(get_parent().get_node(str(name)+"/"+str(name))._on_chat_chat_opened)
		
		chat_in_use = false
		line_edit.text = ""
		line_edit.placeholder_text = "Press ENTER to type"

## Funkcja dodająca wiadomość do czatu (zdalnie wywoływana)
@rpc("any_peer", "call_remote")
func add_message_to_chat(message_content,name):
	# Instancja nowej wiadomości
	var new_message_instance = new_message.instantiate()
	message_panel.add_child(new_message_instance)
	
	# Ustawienie treści wiadomości
	var label = new_message_instance.get_node("Message")
	label.text = globalScript.Players[int(str(name))].fakeName+ ": "+message_content
