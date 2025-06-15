extends CPUParticles2D


func _ready() -> void:
	emitting = true
	await finished
	queue_free()
