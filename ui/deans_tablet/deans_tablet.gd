## Klasa odpowiedzialna za obsługę warstwy CanvasLayer
extends CanvasLayer

## Referencja do sceny pojedynczego studenta
@onready var single_scene = load("res://ui/tablet_single_student.tscn")

## Funkcja wywoływana po przygotowaniu obiektu do użycia
func _ready():
	# Inicjalizacja zmiennej pomocniczej
	var i = 1
	
	# Wyświetlenie liczby używanych nazw w konsoli
	print(str(globalScript.usedNames.size()))
	
	# Iteracja przez listę używanych nazw
	for j in globalScript.usedNames:
		# Instancja sceny pojedynczego studenta
		var scene = single_scene.instantiate()
		
		# Ustawienie tekstu etykiety na nazwę studenta
		scene.get_node("Label").text = str(j)
		
		# Dodanie sceny do odpowiedniego kontenera w zależności od wartości i (parzyste/nieparzyste)
		if i % 2 == 1:
			get_node("Tablet/VBoxContainer").add_child(scene)
		else:
			get_node("Tablet/VBoxContainer2").add_child(scene)
		
		# Inkrementacja zmiennej pomocniczej i
		i += 1
