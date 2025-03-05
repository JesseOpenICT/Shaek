extends GPUParticles2D


func _process(delta : float) -> void:
	emitting = (global_rotation > -0.2)
