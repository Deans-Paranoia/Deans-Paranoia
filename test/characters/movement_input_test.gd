# GdUnit generated TestSuite
class_name MovementInputTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://characters/movementInput.gd'


func test_stop_player_movement() -> void:
	var player = auto_free(preload(__source).new())
	player.speed = 100
	player.stop_player_movement()
	var newSpeed = player.speed
	assert_int(newSpeed).is_equal(0)

func test_restore_player_movement() -> void:
	var player = auto_free(preload(__source).new())
	player.speed = 0
	var tempspeed = 100
	player.restore_player_movement(tempspeed)
	assert_int(player.speed).is_equal(tempspeed)
	



func test_calculate_velocity(direction: String, last_direction:Vector2,
	expected: Vector2, test_parameters :=[
		["up", Vector2.ZERO, Vector2(0, -10)],
		["down", Vector2.ZERO, Vector2(0, 10)],
		["left", Vector2.ZERO, Vector2(-10, 0)],
		["right", Vector2.ZERO, Vector2(10, 0)],
		["", Vector2(1, 1), Vector2.ZERO],
		]) -> void:
	var player = auto_free(preload(__source).new())
	player.speed = 10
	player.last_direction = last_direction
	
	if direction!="":
		Input.action_press(direction)
	var newVelocity:Vector2 = player.calculate_velocity()
	if direction!="":
		Input.action_release(direction)
		
		
		assert_that(player.last_direction).is_equal(expected.normalized())
	else:
		assert_that(player.last_direction).is_equal(last_direction)

	assert_float(newVelocity.x).is_equal(expected.x)
	assert_float(newVelocity.y).is_equal(expected.y)

	
