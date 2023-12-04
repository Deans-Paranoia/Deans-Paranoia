extends Control
signal joinGame(ip)
@export var listenPort: int = 8911
@export var broadcastPort: int = 8912
@export var broadcastAddress: String = ""
@export var serverInfo: PackedScene
var broadcastTimer: Timer
var RoomInfo = {"name": "name", "playerCount": 0}
var playerCount = 0
var broadcaster: PacketPeerUDP
var listener: PacketPeerUDP


func _ready():
	broadcastTimer = $BroadcastTimer
	setUp()
	pass


func _process(delta):
	if listener.get_available_packet_count() > 0:
		$"../Title".visible = false
		var serverIp = listener.get_packet_ip()
		var serverPort = listener.get_packet_port()
		var bytes = listener.get_packet()
		var data = bytes.get_string_from_ascii()
		var roomInfo = JSON.parse_string(data)
		#print(serverIp +":"+ str(serverPort) + " " + str(roomInfo))
		playerCount = roomInfo.playerCount
		if $VBoxContainer.get_children().size() > 0:
			for i in $VBoxContainer.get_children():
				if i.name == roomInfo.name:
					i.get_node("playerCount").text = str(playerCount) + "/8"
					i.get_node("ip").text = str(serverIp)
					return
		else:
			var currentInfo = serverInfo.instantiate()
			currentInfo.name = roomInfo.name
			currentInfo.get_node("name").text = roomInfo.name
			currentInfo.get_node("playerCount").text = str(roomInfo.playerCount) + "/8"
			currentInfo.get_node("ip").text = serverIp
			$VBoxContainer.add_child(currentInfo)
			currentInfo.joinGame.connect(joinByIp)

		#$"../Host".disabled = true


func setBroadcastAddress(address: String):
	var parts = address.split(".")
	if parts.size() == 4:
		var newAddress = parts[0] + "." + parts[1] + "." + parts[2]
		broadcastAddress = newAddress + ".255"
		return true
	else:
		return false


func setUp():
	listener = PacketPeerUDP.new()
	var ok = listener.bind(listenPort)
	if ok == OK:
		print("Bound to listen port " + str(listenPort) + "succesfull")

		$"Host".visible = false
	else:
		print("Failed to bind to listen port")

		$"../Title".visible = false
		$ServerIp.visible = true


func setupBroadcast(name):
	RoomInfo.name = name
	RoomInfo.playerCount = globalScript.Players.size()
	broadcaster = PacketPeerUDP.new()
	broadcaster.set_dest_address(broadcastAddress, listenPort)

	var ok = broadcaster.bind(broadcastPort)
	if ok == OK:
		print("Bound to broadcast port " + str(broadcastPort) + "succesfull")

	else:
		print("Failed to bind to broadcast port")
	$BroadcastTimer.start()


func _on_broadcast_timer_timeout():
	#print("Broadcasting game!")
	RoomInfo.playerCount = globalScript.Players.size()
	var data = JSON.stringify(RoomInfo)
	var packet = data.to_ascii_buffer()
	broadcaster.put_packet(packet)

	pass


func exit_tree():
	cleanUp()


func cleanUp():
	print("broadcaster closed")
	listener.close()
	$BroadcastTimer.stop()
	if broadcaster != null:
		broadcaster.close()

		for i in $VBoxContainer.get_children():
			i.queue_free()


func joinByIp(ip):
	joinGame.emit(ip)
