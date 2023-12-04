# GdUnit generated TestSuite
class_name MainTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")
# TestSuite generated from
const __source = "res://scripts/main.gd"


func before():
	var runner := scene_runner("res://scenes/main.tscn")
	#var ServerBrowser = mock(find_child("ServerBrowser"))
	var _ServerIp = auto_free(runner.find_child("ServerIp"))
	#var test = ServerIp.get_property("text")
	_ServerIp.text = "192.168.8.107"
	runner.invoke("_on_host_button_down")
	runner.invoke("on_start_game")

	await await_millis(2000)


func after():
	assert_not_yet_implemented()


func test__ready() -> void:
	# remove this line and complete your test
	assert_not_yet_implemented()
