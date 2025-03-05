extends Microgame

func smooch():
	win = true


func _ready() -> void:
	super()
	$GrabbableFish.position.x = randi_range(150, 220)
	$GrabbableFish.position.y = randi_range(40, 160)
	$GrabbableFish2.position = Vector2(256, 192) - $GrabbableFish.position
