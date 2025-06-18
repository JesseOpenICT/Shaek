extends AnimatedSprite2D

@export var target : Node2D


func _ready() -> void:
	position.x = randf_range(50, 220)
	position.y = 0.000000000001 * pow(position.x, 6) + 30
	position = Vector2i(position)
	
	if randf() < randf():
		play("Carrot")
	else:
		play("Fruit")
	stop()
	frame = 0

func win():
	if !$"..".win:
		$"../Trans".play()
		$"..".win = true
		target.reduce()
		frame = 1

func _process(_delta: float) -> void:
	if position.distance_to(target.position) < 16:
		win()
