extends Node2D

var player_number := 1
var character_number := 2

func _ready() -> void:
	player_number = Global.winning_player
	character_number = Global.playerNumber

	if player_number == 2:
		$ColorRect.color = Color8(0x40, 0x40, 0x7D)
		character_number = Global.player2Number

	$Background.play(str(player_number))

	await get_tree().create_timer(0.2).timeout
	$Front.play(str(character_number))

	await $Front.animation_finished

	get_tree().create_timer(4).connect("timeout", func():
		get_tree().change_scene_to_file("res://Scenes/PlayerSelect.tscn")
		Global.p1hp = 100
		Global.p2hp = 100)
