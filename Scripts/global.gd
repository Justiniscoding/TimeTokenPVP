extends Node

signal hpChange(player, amount)

var p1hp = 100
var p2hp = 100

var playerNumber = 1
var player2Number = 3

var isMultiplayer = false
var socket: WebSocketPeer

func remove_hp(playerNum: int, amount: int) -> void:
	if playerNum == 1:
		p1hp -= amount
	else:
		p2hp -= amount
	emit_signal("hpChange", playerNum, amount)

func _ready() -> void:
	set_process(false)
	init_multiplayer()

func init_multiplayer():
	isMultiplayer = true

	socket = WebSocketPeer.new()

	var wsUrl = "ws://localhost:8080"

	if OS.has_feature("web"):
		wsUrl = ""

	var error = socket.connect_to_url(wsUrl, TLSOptions.client_unsafe())

	if error == OK:
		print("connected to websocket")
		set_process(true)
	else:
		push_error("error connecting to websocket")

var events = {}

func on(event_name: String, callback: Callable):
	if events.has(event_name):
		events[event_name].push_back(callback)
	else:
		events[event_name] = [
			callback
		]

func emit(event_name: String, ...params):
	var text = event_name
	for param in params:
		text += "\n" + str(param)
	socket.send_text(text)

func _process(_delta: float) -> void:
	socket.poll()
	var state = socket.get_ready_state()

	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var packet = socket.get_packet()
			if socket.was_string_packet():
				var content = packet.get_string_from_utf8().split("\n")
				var title = content[0]

				if events.has(title):
					for callback in events[title]:
						callback.callv(content.slice(1))

# all this is just to make sure players get removed in multiplayer and don't persist
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST and Global.isMultiplayer:
		socket.close()
		get_tree().quit()
