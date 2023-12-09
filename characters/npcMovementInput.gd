extends CharacterBody2D

signal rotate(direction: String)

var speed = 200
@onready var destination = Vector2()
@onready var point_A: Vector2
@onready var point_B: Vector2
var move_direction = Vector2(1, 0)
var can_move: bool
var walking_task = false

func _on_task_script_npc_walking_task():
	walking_task = true

func _ready():
	point_A = position
	print(point_A)
	point_B = point_A + Vector2(0, 600)
	destination = point_B

func _process(delta):
	if walking_task:
		if position != destination and can_move: 
			position = position.move_toward(destination, delta * speed)
		else: 
			can_move = false
			wait()
			if destination == point_A:
				destination = point_B
			else: 
				destination = point_A

func wait():
	await get_tree().create_timer(2.0).timeout
	can_move = true
	if destination == point_A:
		rotate.emit("up")
	else: 
		rotate.emit("down")


