extends CharacterBody2D

signal rotate(direction: String)

var speed = 400
@onready var destination = Vector2()
@onready var point_A: Vector2
@onready var point_B: Vector2
var move_direction = Vector2(1, 0)
var can_move: bool
var walking_task = false

@onready var rng = RandomNumberGenerator.new()
func _on_task_script_npc_walking_task():
	var time = rng.randf_range(0.0,2.5)
	await get_tree().create_timer(time).timeout
	walking_task = true
	can_move = true
	
func _ready():
	point_A = position
	point_B = point_A + Vector2(0, 600)
	destination = point_B

func _process(delta):
	if walking_task:
		if position != destination and can_move: 
			position = position.move_toward(destination, delta * speed)
		elif can_move: 
			can_move = false
			wait()
			if destination == point_A:
				destination = point_B
			else: 
				destination = point_A
				
func wait():
	var time = rng.randf_range(0.0,2.0)
	await get_tree().create_timer(1.5+time).timeout
	can_move = true
	if destination == point_A:
		rotate.emit("up")
	else: 
		rotate.emit("down")

