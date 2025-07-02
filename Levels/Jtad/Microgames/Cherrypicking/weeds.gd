extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var lengths = [
		randi_range(0,2),
		randi_range(0,2),
		randi_range(0,2),
		randi_range(1,3),
		randi_range(2,3),
		randi_range(2,3),
		randi_range(1,1),
		randi_range(0,2),
		randi_range(0,2),
	]
	var index = 0
	
	for i in lengths:
		for l in range(-4,8):
			if i == l:
				set_cell(Vector2i(index, l), 0, Vector2i(0,0))
			elif i < l:
				set_cell(Vector2i(index, l), 0, Vector2i(0,1))
			else:
				erase_cell(Vector2i(index,l))
		index += 1
