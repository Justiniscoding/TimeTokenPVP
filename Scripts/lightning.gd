extends Area2D

func _ready() -> void:
	$AudioStreamPlayer.play()
	$AnimatedSprite2D.play()

var didStunm = false



func _physics_process(_delta: float) -> void:
	if has_overlapping_bodies():
		for body in get_overlapping_bodies():
			var playerNumber
			if body.name == "Player":
				playerNumber = 1
			else:
				playerNumber = 2
			#if body.name == "Player" and not didStunm:
			if not didStunm:
				didStunm = true

				if Global.isMultiplayer:
					Global.emit("hitPlayer", body.get_parent().name, 5, 0, 0, 45)
				else:
					Global.remove_hp(playerNumber, 5)
					body.stun.reset(45)

	if not $AnimatedSprite2D.is_playing():
		queue_free()
