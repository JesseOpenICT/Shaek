extends Area2D

var speed

func _ready() -> void:
	$AnimatedSprite2D.rotation = randf_range(-PI, PI)


func _process(delta: float) -> void:
	position.x += delta * speed
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
