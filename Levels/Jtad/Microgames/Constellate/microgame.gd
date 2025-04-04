extends Microgame

var progress = 0
var won : bool

@export var guardian : Dictionary = {
	image = preload("res://Levels/Jtad/Microgames/Constellate/guardian.png"),
	points = [
		Vector2i(64, 33),
		Vector2i(101, 52),
		Vector2i(166, 70),
		Vector2i(193, 133),
		Vector2i(128, 129),
		Vector2i(73, 106),
	]
}
@export var omen : Dictionary = {
	image = preload("res://Levels/Jtad/Microgames/Constellate/omen.png"),
	points = [
		Vector2i(67, 61),
		Vector2i(125, 59),
		Vector2i(125, 107),
		Vector2i(100, 149),
		Vector2i(181, 121),
		Vector2i(195, 175),
	]
}
@export var knight : Dictionary = {
	image = preload("res://Levels/Jtad/Microgames/Constellate/knight.png"),
	points = [
		Vector2i(90, 143),
		Vector2i(80, 81),
		Vector2i(141, 73),
		Vector2i(153, 40),
		Vector2i(180, 128),
		Vector2i(193, 87),
	]
}
@export var chariot : Dictionary = {
	image = preload("res://Levels/Jtad/Microgames/Constellate/chariot.png"),
	points = [
		Vector2i(60, 89),
		Vector2i(118, 52),
		Vector2i(19, 99),
		Vector2i(139, 131),
		Vector2i(150, 87),
		Vector2i(214, 82),
	]
}
@export var lover : Dictionary = {
	image = preload("res://Levels/Jtad/Microgames/Constellate/lover.png"),
	points = [
		Vector2i(65, 159),
		Vector2i(85, 128),
		Vector2i(129, 126),
		Vector2i(119, 44),
		Vector2i(170, 81),
		Vector2i(193, 87),
	]
}

@export var art = Sprite2D
@export var points : Array[Node]
@export var raycast : RayCast2D
@export var line : Line2D

var random_constellation
var latest_star : Node

var found_points : Array[Node]


func _ready() -> void:
	super()
	art.material.set("shader_parameter/opacity", 0)
	random_constellation = [guardian,omen,knight,chariot,lover][randi_range(0,4)]
	var index = 0
	for star in points:
		star.position = random_constellation["points"][index]
		index+=1
	line.points[0] = (points[0].position)
	found_points.append(points[0])
	latest_star = points[0]
	line.points[1] = (get_window().get_mouse_position())
	art.material.set("shader_parameter/constellation", random_constellation["image"])


func _process(delta: float) -> void:
	super(delta)
	if not win:
		if !line.points:
			return
		line.points[line.points.size()-1] = get_window().get_mouse_position()
		
		raycast.position = line.points[line.points.size()-2]
		raycast.target_position = get_window().get_mouse_position() - raycast.position
		
		var body = raycast.get_collider()
		if body:
			line.add_point(get_window().get_mouse_position())
			line.points[line.points.size()-2] = body.position
			
			if latest_star != body:
				latest_star = body
				var n :float = found_points.size()-5
				$ting.pitch_scale = 2**(n/12)
				$ting.play()
			if body not in found_points:
				found_points.append(body)
				if points.size() == found_points.size():
					win = true
					line.points[line.points.size()-1] = line.points[line.points.size()-2]
	else:
		progress = min(1, progress+delta*speed)
		art.material.set("shader_parameter/opacity", progress)
		$ConstellationLine.default_color.a = (1- progress)/2 + 0.5
		if not won:
			won = true
			
