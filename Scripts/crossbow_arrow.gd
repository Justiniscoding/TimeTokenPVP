extends Area2D

const speed = 300

var direction = 1
var damage = 0

var startTimer = 0

func _ready() -> void:
	if direction == 1:
		$Sprite2D.flip_h = true

func _process(delta: float) -> void:
	startTimer += delta

	position.x += speed * delta * direction

	if startTimer > 5:
		queue_free()

	if has_overlapping_bodies():
		for body in get_overlapping_bodies():
			if body.name.begins_with("Player"):
				var playerNumber = 1 if body.name == "Player" else 2

				if Global.isMultiplayer:
					Global.emit("hitPlayer", body.get_parent().name, damage, 1000 * direction, 0, 0)
				else:
					Global.remove_hp(playerNumber, damage)
					body.targetVel.x = 1000 * direction
					# set_process(false)
					# reparent(body)
					# return
		queue_free()
