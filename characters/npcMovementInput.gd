extends CharacterBody2D

# Sygnał informujący o zmianie kierunku obrotu postaci NPC.
signal rotate(direction: String)

# Prędkość ruchu postaci NPC.
var speed = 400

# Wektor docelowy dla ruchu postaci NPC.
@onready var destination = Vector2()

# Punkt A na trasie ruchu postaci NPC.
@onready var point_A: Vector2

# Punkt B na trasie ruchu postaci NPC.
@onready var point_B: Vector2

# Wektor kierunku ruchu postaci NPC.
var move_direction = Vector2(1, 0)

# Flaga określająca możliwość ruchu postaci NPC.
var can_move: bool

# Flaga określająca, czy postać NPC jest w trakcie zadania poruszania się.
var walking_task = false

## Generator liczb losowych.
@onready var rng = RandomNumberGenerator.new()

func _on_task_script_npc_walking_task():
	## Funkcja obsługująca rozpoczęcie zadania chodzenia postaci NPC.
	# Losowanie czasu oczekiwania przed rozpoczęciem ruchu.
	var time = rng.randf_range(0.0, 2.5)
	
	# Oczekiwanie przed rozpoczęciem ruchu.
	await get_tree().create_timer(time).timeout
	
	# Emitowanie sygnału informującego o rozpoczęciu ruchu.
	rotate.emit("start")
	rotate.emit("down")
	walking_task = true
	can_move = true

func _ready():
	## Funkcja wywoływana przy inicjalizacji obiektu.
	# Ustawienie punktów początkowego i końcowego ruchu postaci NPC.
	point_A = position
	point_B = point_A + Vector2(0, 510)
	destination = point_B

func _process(delta):
	## Parametry: delta
	## Funkcja wywoływana w każdej klatce renderingu.
	if walking_task:
		# Ruch postaci NPC w kierunku docelowym.
		if position != destination and can_move: 
			position = position.move_toward(destination, delta * speed)
		elif can_move: 
			can_move = false
			wait()
			# Zmiana kierunku docelowego po osiągnięciu punktu A lub B.
			if destination == point_A:
				destination = point_B
			else: 
				destination = point_A
	elif can_move:
		# Emitowanie sygnałów informujących o ruchu w trybie "idle".
		if destination == point_A:
			rotate.emit("idle_up")
		else: 
			rotate.emit("idle_down")    

func wait():
	## Funkcja zatrzymująca NPC.
	# Emitowanie sygnałów informujących o ruchu w trybie "idle".
	if destination == point_A:
		rotate.emit("idle_up")
	else: 
		rotate.emit("idle_down")
	
	# Losowanie czasu oczekiwania przed wznowieniem ruchu.
	var time = rng.randf_range(0.0, 2.0)
	
	# Oczekiwanie przed wznowieniem ruchu.
	await get_tree().create_timer(1.5 + time).timeout
	
	# Wznowienie możliwości ruchu i zmiana kierunku docelowego.
	can_move = true
	if destination == point_A:
		rotate.emit("up")
	else: 
		rotate.emit("down")
