extends Microgame


func _ready() -> void:
	super()
	var widths : Array = range(0,6)
	var heights : Array = [89, 92, 169, 110, 144, 85]
	
	for i in [$RealFish, $Fakefish,$Fakefish2,$Fakefish3,$Fakefish4,]:
		var current_width = randi_range(0,widths.size()-1)
		i.position = Vector2(43, heights[current_width])
		i.position.x += 32 * widths[current_width]
		if randf() > randf():
			i.scale.x = -1
			i.position.x += 10
		widths.erase(widths[current_width])
		heights.erase(heights[current_width])
	
