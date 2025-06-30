extends Microgame


var placed : int = 3


func _ready() -> void:
	super()
	var index = randi_range(0,2)
	$Hat.set_art(index)
	$Dress.set_art(index)
	$Shoe.set_art(index)


func place():
	placed -= 1
	if placed == 0:
		win = true
		$TextureRect/CPUParticles2D.emitting = true
