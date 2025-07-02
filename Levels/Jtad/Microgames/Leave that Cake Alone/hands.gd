extends Sprite2D

var traveled_distance : float:
	set(value):
		traveled_distance = value
		arc = 128 - 198 * pow(traveled_distance-1, 2)
		position.x = arc
		if traveled_distance > 1:
			$"..".win = false
			$"../Cake".position.x = arc

var grappled : bool
var arc : int


func _ready() -> void:
	$"..".win = true


func grapple():
	if not grappled:
		$"../Yoink".pitch_scale = $"..".speed * .55
		$"../Yoink".play()
		grappled = true
		var tween : Tween = create_tween()
		tween.tween_property(self, "traveled_distance", 3., 1.5/$"..".speed)
		await tween.finished
		$"../OhNoes".visible = true


func _input(event: InputEvent) -> void:
	if event.is_action_just_pressed("left_mouse"):
		grapple()
