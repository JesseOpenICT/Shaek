extends Microgame


var swirl : float = -3
const CENTRE = Vector2(128, 96)
var wincon_positive : bool


func _ready() -> void:
	super()
	swirl = [-5,5][randi_range(0,1)]
	$StargazingDown.material.set("shader_parameter/warp", swirl)
	wincon_positive = swirl < 0
	$StargazingDown/Arrow.scale.x = -1 if wincon_positive else 1


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not win:
		var end_coords = event.position
		var start_coords = end_coords - event.relative
		var start_angle = CENTRE.angle_to_point(start_coords)
		
		$StargazingDown/Arrow.rotation = CENTRE.angle_to_point(end_coords)
		
		end_coords = (end_coords-CENTRE).rotated(-start_angle) + CENTRE
		var end_angle = CENTRE.angle_to_point(end_coords)
		
		swirl -= end_angle / 3
		if (wincon_positive and swirl >= 0) or (!wincon_positive and swirl <= 0):
			swirl = 0
			win = true
			var tween : Tween = create_tween()
			tween.tween_property($StargazingDown/Arrow, "modulate", Color.TRANSPARENT, .5)
			tween.parallel().tween_property($StargazingDown/Arrow, "scale", $StargazingDown/Arrow.scale*2, .5)
		
		$StargazingDown.material.set("shader_parameter/warp", swirl)
