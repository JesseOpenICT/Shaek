extends Microgame

func _ready() -> void:
	$Timer.wait_time = 1.6 / speed
	super()


func _process(delta: float) -> void:
	super(delta)
	if $Pour.active and $RoofPivot.active and !win:
		win = true
		$Timer.start()
		await $Timer.timeout
		microgame_won()

func microgame_won():
	win = true
	$WinScreen.visible = true
	var tween = create_tween()
	tween.tween_property($WinScreen, "scale", Vector2(1,1), 0.3/speed)
