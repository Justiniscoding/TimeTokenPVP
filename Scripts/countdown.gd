extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween: Tween = get_tree().create_tween()
	$AudioStreamPlayer2D.play()
	tween.tween_property($TextureProgressBar, "value", 100, 5.9)
	await $AudioStreamPlayer2D.finished
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
