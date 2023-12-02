extends Control
signal current_player(id)
signal isServer
signal gameStart
@export var Address = ""
@export var Port = 8909
var peer
# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	$ServerBrowser.joinGame.connect(joinByIp)
	
	pass	

# called on the server and clients
func peer_connected(id):
	print("Player connected " + str(id))
		
# called on the server and clients
func peer_disconnected(id):
	print("Player disconnected " + str(id))
	globalScript.Players.erase(id)
	
	var players = get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name == str(id):
			i.queue_free()
# called only from clients
func connected_to_server():
	print("Connected to server")
	SendPlayerInformation.rpc_id(1, "Player " + str(globalScript.Players.size()+1), multiplayer.get_unique_id() )
	var scene = load("res://scenes/waiting_room.tscn").instantiate()
	
	current_player.connect(scene.on_current_player)
	current_player.emit( multiplayer.get_unique_id())
	get_tree().root.add_child(scene)
#called only from clients
func connection_failed():
	print("Connection failed")
func _process(delta):
	pass


	
@rpc("any_peer")
func disableJoin(server):
	server.Button.disabled = true
	
@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !globalScript.Players.has(id):
		globalScript.Players[id] = {
			"name": name,
			"id": id
		}
	if multiplayer.is_server():
		for i in globalScript.Players:
			SendPlayerInformation.rpc(globalScript.Players[i].name, i)
@rpc("any_peer","call_local")
func StartGame(control):
	var scene = load("res://scenes/level.tscn").instantiate()
	self.hide()
	#print(control)
	var rooms = get_tree().get_nodes_in_group("room")
	for i in rooms:
		i.hide()
	get_tree().root.add_child(scene)
	
func hostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(Port,8)
	if error != OK:
		print("Cannot host: " + str(error))
		return false
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("waiting for players...")
	var scene:Node = load("res://scenes/waiting_room.tscn").instantiate()
	var node:Button = scene.get_node("StartGame")
	node.disabled = false
	scene.button_pressed.connect(on_start_game)
	scene.dean_picked.connect(on_update_id)
	isServer.connect(scene.enable_dean_change)
	get_tree().root.add_child(scene)
	isServer.emit()
	self.hide()
	return true
	
@rpc("any_peer","call_local")
func update_dean_id(id):
	globalScript.deanId = int(id);
func on_update_id(id):
	update_dean_id.rpc(id)
func _on_host_button_down():
	if $ServerBrowser.setBroadcastAddress($ServerBrowser/ServerIp.text):
		if hostGame():
			
			$ServerBrowser.setupBroadcast("Dean's Paranoia")
				
		pass # Replace with function body.

func _on_join_button_down():
	joinByIp(Address)
	pass # Replace with function body.

func joinByIp(ip):
	if $ServerBrowser.playerCount <8:
		peer = ENetMultiplayerPeer.new()
		self.hide()
		peer.create_client(ip,Port)
	
		peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
		multiplayer.set_multiplayer_peer(peer)
	else:
		for i in $ServerBrowser/VBoxContainer.get_children():
			i.get_node("Button").text = "room is full"
func on_start_game(control):
	StartGame.rpc(control)
	pass
