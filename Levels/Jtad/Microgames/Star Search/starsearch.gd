extends Microgame

var velocity : Vector2
var starspot : Vector2


func _ready() -> void:
	super()
	var random_angle = randf_range(-PI,PI)
	var spin = Vector2(1,0).rotated(random_angle)
	starspot = Vector2(256, 192) * spin
	$Backdrop/Star.position = starspot


func _process(delta: float) -> void:
	var modified_delta = delta * speed
	var max_speed = 1
	if win:
		max_speed = 0.4
	velocity = velocity.move_toward(max_speed * Input.get_vector("left", "right", "up", "down"), modified_delta*10)
	$Backdrop.position -= 250 * modified_delta * velocity
	$Backdrop.position = $Backdrop.position.clamp(Vector2(-128, -96), Vector2(384, 288)) 
	
	if velocity and not $Tick.playing:
		$Tick.play()
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Star"):
		win = true
		$Lens.play("win")
		var tween = create_tween()
		tween.tween_property($Backdrop, "position", Vector2(128, 96)-starspot, 0.4/speed)
		$Backdrop/Star.rotation = 0
		var tween2 = create_tween()
		$Backdrop/Star.rotation = 0
		tween2.tween_property($Backdrop/Star, "rotation", 2*PI, 2.5/speed).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
		$FoundYa/Timer.start(1/speed)
		await $FoundYa/Timer.timeout
		$FoundYa.play()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Star"):
		win = false
		$Lens.play("lose")
