# GdUnit generated TestSuite
class_name MainTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")
# TestSuite generated from
const __source = "res://scripts/main.gd"


func before():
	var main1 := scene_runner("res://scenes/main.tscn")
	#var ServerBrowser = mock(find_child("ServerBrowser"))
	var _ServerIp1 = auto_free(main1.find_child("ServerIp"))
	#var test = ServerIp.get_property("text")
	_ServerIp1.text = "192.168.8.107"
	main1.invoke("_on_host_button_down")
	await await_millis(10000)
	main1.invoke("on_start_game")
	#var main2 := scene_runner("res://scenes/main.tscn")


#
#var _ServerIp2 = auto_free(main2.find_child("ServerIp"))
#
#await await_millis(20000)


func after():
	assert_not_yet_implemented()


func test__ready() -> void:
	# remove this line and complete your test
	assert_not_yet_implemented()
