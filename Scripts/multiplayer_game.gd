extends Node2D

const playerScene = preload("res://Scenes/player.tscn")
const dummyPlayerScene = preload("res://Scenes/DummyPlayer.tscn")

var player
var otherPlayers

func playerMove(id: String, x: String, y: String, facing: String, anim: String) -> void:
	var otherPlayer = get_node("OtherPlayers/" + id)
	otherPlayer.targetPosition = Vector2(int(x), int(y))
	otherPlayer.facing = facing

	if not (otherPlayer.get_node("AnimatedSprite2D").animation.begins_with("double_jump") and anim.begins_with("double_jump")):
		otherPlayer.get_node("AnimatedSprite2D").play(anim)

func playerHit(damage: String, x: String, y: String, stun: String) -> void:
	print("here")
	player.targetVel.x += int(x)
	player.targetVel.y += int(y)

	if stun and stun != "0":
		player.stun.reset(int(stun))

func _ready() -> void:
	Global.isMultiplayer = true
	Global.init_multiplayer()

	Global.on("inGame", func(x, y):
		player = playerScene.instantiate()
		player.position = Vector2(int(x), int(y))
		add_child(player))
	Global.on("newPlayer", func(id, x, y):
		var newPlayer = dummyPlayerScene.instantiate()
		newPlayer.targetPosition = Vector2(int(x), int(y))
		newPlayer.position = Vector2(int(x), int(y))
		newPlayer.name = id
		$OtherPlayers.add_child(newPlayer))
	Global.on("playerQuit", func(id):
		get_node("OtherPlayers/" + id).queue_free())

	Global.on("playerMove", playerMove)
	Global.on("hit", playerHit)

var lastUpdate = 0

func _process(delta: float) -> void:
	if !player:
		return

	lastUpdate += delta

	if lastUpdate >= 1 / 20.0:
		lastUpdate = 0

		var anim = player.get_node("AnimatedSprite2D").animation

		Global.emit("playerMove", player.position.x, player.position.y, player.facing, anim)
