extends Node2D

var targetPosition: Vector2
var facing = "1"

func _process(_delta: float) -> void:
	position = lerp(position, targetPosition, 0.2)

	if facing == "1":
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.offset.x = -7
	else:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.offset.x = 7
