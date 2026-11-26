extends RigidBody2D

var didStun = false
var shootDirection

func _ready() -> void:
	lock_rotation = true

	var t = 0.4
	var g = ProjectSettings.get_setting("physics/2d/default_gravity") * gravity_scale
	var dx = -100.0
	var dy = 4.0

	linear_velocity = Vector2(shootDirection * (dx / t), dy / t - 0.5 * g * t)
	set_angle()
	$AnimatedSprite2D.play("loop")

func set_angle() -> void:
	var angle = linear_velocity.angle() + rad_to_deg(180)
	$AnimatedSprite2D.rotation = angle
	$Area2D.rotation = angle          

func _physics_process(delta: float) -> void:
	set_angle()

	if didStun:
		return

	for body in $Area2D.get_overlapping_bodies():
		if body == self:
			continue

		if body.name.begins_with("Player"):
			var playerNumber = 1

			if body.name == "Player2":
				playerNumber = 2

			didStun = true

			if Global.isMultiplayer:
				Global.emit("hitPlayer", body.get_parent().name, 3, 0, 0, 45)
			else:
				Global.remove_hp(playerNumber, 3)
				body.stun.reset(45)

		queue_free()
