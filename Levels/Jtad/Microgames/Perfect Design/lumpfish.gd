extends Sprite2D


var target_scale : Vector2 = Vector2(.5, .5)
var holding
var startscale : Vector2
var holdpos : Vector2

func _ready() -> void:
	target_scale.x = randf_range(.3, .5)
	target_scale.y = randf_range(.3, .5)
	if randi_range(0,4) == 2:
		target_scale.y = .5
	elif randi_range(0,2) == 2:
		target_scale.x = .5
	elif randi_range(0,2) == 2:
		target_scale.x = .15
	
	$"../Frame".scale = target_scale


func win(to:bool):
	$"..".win = to
	$"../Frame".material.set("shader_parameter/color", Vector3(1,1,1) if to else Vector3(1,.282,.11))



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		holding = true
		holdpos = get_viewport().get_mouse_position()
		startscale = scale
		
		if abs (startscale.x- position.x) < 15:
			startscale.x += 60
		if abs (startscale.y- position.x) < 15:
			startscale.y += 60
		
		$"../Spark".visible = false
	
	elif event.is_action_released("left_mouse"):
		holding = false
	elif event is InputEventMouseMotion and holding:
		var mp = get_viewport().get_mouse_position()
		scale = startscale * abs( (mp-position) / (holdpos-position) )
		
		win(abs(scale.x - target_scale.x) < .024 and abs(scale.y - target_scale.y) < .036 )
