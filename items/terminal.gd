extends Node2D 
signal change_number(name,value)
var actual_value = 0
var textures = []
var can_update_value: bool = false
func _ready():
	load_textures()
	update_texture()
	change_number.connect(get_parent().on_number_changed)
	
## Funkcja ładowania tekstur
func load_textures():
	for i in range(10):
		textures.append(load("res://assets/terminal_" + str(i) + ".png"))

## Funkcja aktualizująca teksturę terminala
func update_texture():
	$Terminal/Sprite2D/Sprite2D.texture = textures[actual_value]


@rpc("any_peer", "call_remote")
## Funkcja wywoływana po użyciu terminala
func use_terminal():
	actual_value += 1  ## Zwiększa wartość aktualną
	if actual_value > 9:
		actual_value = 0  ## Przewija wartość aktualną na 0, jeśli przekroczy 9
	update_texture()  ## Aktualizuje teksturę
	change_number.emit(self.name, actual_value)  ## Emituje sygnał zmiany numeru

## Funkcja wywoływana, gdy ciało opuszcza obszar terminala
func _on_terminal_area_body_exited(body):
	if body.is_in_group("obstacles"):
			can_update_value = true  ## Ustawia flagę na true
			$".".visible = true  ## Ustawia widoczność
			show_terminal.rpc($".".name)  ## Wywołuje zdalnie funkcję pokazującą terminal

@rpc("any_peer", "call_local")
## Funkcja lokalnie pokazująca terminal
func show_terminal(name):
	var terminal = get_node("../" + str(name))
	terminal.visible = true  ## Ustawia widoczność terminala
