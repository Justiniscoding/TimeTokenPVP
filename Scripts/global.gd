extends Node

signal hpChange(player, amount)

var p1hp = 100
var p2hp = 100

var playerNumber = 1
var player2Number = 3

func remove_hp(playerNum: int, amount: int) -> void:
	if playerNum == 1:
		p1hp -= amount
	else:
		p2hp -= amount
	emit_signal("hpChange", playerNum, amount)
