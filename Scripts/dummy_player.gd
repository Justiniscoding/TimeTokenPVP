extends CharacterBody2D

var targetPosition: Vector2
var facing = "1"

var player_number = 1

func _ready() -> void:
	if player_number == 3:
		$AnimatedSprite2D.position.x = -4
		$AnimatedSprite2D.position.y = -16
	if player_number == 4:
		$AnimatedSprite2D.position.x = 2
		$AnimatedSprite2D.position.y = -0.5

func _process(_delta: float) -> void:
	position = lerp(position, targetPosition, 0.2)

	if facing == "1":
		$AnimatedSprite2D.flip_h = true

		if player_number == 3:
			$AnimatedSprite2D.position.x = 22

		if player_number == 4:
			$AnimatedSprite2D.offset.x = 15
		else:
			$AnimatedSprite2D.offset.x = 5

	else:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.offset.x = -7
		if player_number == 3:
			$AnimatedSprite2D.position.x = -4
