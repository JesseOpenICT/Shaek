extends TileMapLayer


var targetspots : Array[Area2D]
@export var targetspot_scene : PackedScene

func set_tile(posit : Vector2i, on:bool):
	for xy in [posit.x, posit.y]:
		if xy < 0 or xy > 7:
			return
	if on:
		set_cell(posit, 1, Vector2i(0,0))
		var spot = targetspot_scene.instantiate()
		spot.position = posit*$"../..".STEP + Vector2i(10, 10)
		spot.positioni = posit
		add_child(spot)
		targetspots.append(spot)
	
	else:
		var odd = (posit.x + posit.y)%2 ## check if tile is odd or even. This is used to determine if it should be light or dark.
		set_cell(posit, 0, Vector2i(0, odd))
		
		


func move_horse(vec:Vector2i):
	$"../..".move_horse(vec)
