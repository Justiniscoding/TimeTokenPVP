extends Node

signal hpChange(player, amount)

var p1hp = 100
var p2hp = 100

var shootDirection = 1

var playerNumber
var player2Number

func remove_hp(playerNum: int, amount: int) -> void:
	if playerNum == 1:
		p1hp -= amount
	else:
		p2hp -= amount
	emit_signal("hpChange", playerNum, amount)
