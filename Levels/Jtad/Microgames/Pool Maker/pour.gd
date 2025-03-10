extends GPUParticles2D


func _process(_delta : float) -> void:
	emitting = (global_rotation > -0.2)
