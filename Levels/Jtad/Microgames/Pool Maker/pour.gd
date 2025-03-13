extends GPUParticles2D


func _process(_delta : float) -> void:
	emitting = (global_rotation > -0.2)
	if emitting and !$AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()


func _on_microgame_end(_won) -> void:
	var tween = create_tween()
	tween.tween_property($AudioStreamPlayer, "volume_db", -80, 0.2)
