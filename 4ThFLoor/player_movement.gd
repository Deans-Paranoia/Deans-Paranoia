extends CharacterBody2D
## Ta klasa - player_movemnt.gd jest przedłużeniem (dziedzyczy)
## po klasie CharacterBody2D

@export var MAX_SPEED = 300
@export var ACCELERATION = 10000
@export var FRICTION = 2000
## Deklaracja zmiennych, które zostaną wyeksportowane -
## zapisane wraz z zasobem, do którgo są ten skrypt jest załączony
## tj. scenta world.tscn

@onready var axis = Vector2.ZERO
## Zmienna, która zostanie zainicjalizowana
## po wywołaniu funkcji _ready() - po
## załadowaniu sceny world.tscn, do której
## ten skrypt jest załączony

func _physics_process(delta):
## Metoda wewnetrzba Godot, uruchamiana gdy przetwarzanie fizyki jest włączone
## Uruchamiania podczas przetwarzania fizyki w głównej pętli. Przetwarzanie fizyki jest połączone
## z ilością klatek na sekundę - fizyka jest liczona co klatkę
## Przyjmuje delte jako paramter.
## Delta czas potrzebny na wyrenderowanie jednej klatki(ostatniej wyrenderowanej)'
## Uruchamia metodę move - lokalną klast plater_movement.gd, z parametrem delta
	move(delta)

func get_input_axis():
## Zwraca wartość próby przesunięcia się gracza, dla każdej osi (x, y) oddzielnie.
## Za pomocą Vector2
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return axis.normalized()

func move(delta):
## Metoda klasy player_movement.gd odpowiedzialna, że przesuwanie obiektu
## Korzystając z get_input_axis() otrzymuje Vector2, mówiący w którą stronę
## Gracz chce się poruszyć
## Decycuje czy ruch ma być z tarciem, czy bez
## Na końcu wywołuje wewnętrzną metodę silnika - move_and_slide()
	axis = get_input_axis()
	
	if axis == Vector2.ZERO:
		apply_friction(FRICTION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
		
	move_and_slide()


func apply_friction(amount):
## Jeżeli obiekt byl w spoczynku, to symulujemy tracie, czyli: 
## Zmniejszamy prękość ruchu, aby owo tarcie symulować
## tarcie sluszy plynemu zatrzymywaniu i rozpoczynaniu ruchu obiektu
## zmienia wartość velocity - szybkości, z którego korzysta
## move_and_slide()
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO


func apply_movement(accel):
## zmienia wartość velocity - szybkości, z którego korzysta
## move_and_slide()
## przyjmuje paramter accel - mówiący o przyspieszeniu obiektu
	velocity += accel
	velocity = velocity.limit_length(MAX_SPEED)
