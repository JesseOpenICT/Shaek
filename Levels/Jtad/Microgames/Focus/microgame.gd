extends Microgame


var target_position : Vector2
@export var zoom = 1.0


func _ready() -> void:
	$ColorRect.material.set_shader_parameter("shape", preload("res://Levels/Jtad/Microgames/Focus/1.png"))
	super()
	var mouse_pos : Vector2i = get_window().get_mouse_position()
	var quadrant : int = 0
	@warning_ignore("integer_division")
	quadrant += int(mouse_pos.x > 256/2)
	@warning_ignore("integer_division")
	quadrant += int(mouse_pos.y > 192/2)*2
	target_position= Vector2(randi_range(10, 128), randi_range(10, 96))
	if quadrant in [0, 2]:
		target_position.x += 118
	if quadrant in [0, 1]:
		target_position.y += 86
	if target_position.distance_to(mouse_pos) < 10:
		target_position += Vector2(10, 0).rotated(randf_range(-PI, PI))


func _process(delta: float) -> void:
	super(delta)
	var modified_delta = delta * speed
	
	var mouse_pos = clamp(get_window().get_mouse_position(), Vector2(0,0), Vector2(256,192))
	var mouse_dist = target_position.distance_to(mouse_pos)
	
	if win:
		zoom = 0
	else:
		
	
		zoom -= clamp(-((mouse_dist - 100)/100)**3, -0.01, 1 ) * modified_delta * .8
		zoom = clamp(zoom, 0, 1.1)
		if zoom == 0.0:
			win = true
			$Wave.stop()
			$WinAudio.play()
			$ColorRect.material.set_shader_parameter("shape", preload("res://Levels/Jtad/Microgames/Focus/2.png"))
		
		var focus_from_target : Vector2 = (target_position - mouse_pos) / Vector2(256, 192)
		$ColorRect.material.set_shader_parameter("current_position", focus_from_target)
	
	$Wave.pitch_scale = 2 - zoom
	$ColorRect.material.set_shader_parameter("depth", zoom)



func _on_end(_whatever_ahh_bool) -> void:
	$Wave.stop()
