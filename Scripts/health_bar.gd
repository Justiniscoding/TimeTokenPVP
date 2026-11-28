extends TextureProgressBar

var health := 100

func init(character_number: int) -> void:
	# prevents both progress bars from being forced to the same images
	texture_under = texture_under.duplicate()
	texture_progress = texture_progress.duplicate()
	texture_over = texture_over.duplicate()

	texture_under.region.position.x = 64 * character_number
	texture_progress.region.position.x += 64 * character_number
	texture_over.region.position.x = 64 * character_number

	if character_number == 3:
		texture_progress.region.position = Vector2(201, 44)
		texture_progress.region.size = Vector2(47, 8)
		texture_progress_offset = Vector2(9, 12)
