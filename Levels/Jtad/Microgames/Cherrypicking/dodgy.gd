extends Sprite2D


var hovered : bool
@export var real : bool
var velocity : Vector2

func _process(delta: float) -> void:
	if $"..".win:
		return
	if abs(position.x - 128) > 110:
		velocity.x = move_toward(
			velocity.x,
			(position.x - 128)*-100,
			8.5 * delta)
	if abs(position.y - 96) > 78:
		velocity.y = move_toward(
			velocity.y,
			(position.y - 96)*-100,
			8.5 * delta)
	
	if position.distance_to(get_viewport().get_mouse_position()) < 30:
		velocity = velocity.move_toward(
			(position - get_viewport().get_mouse_position()).normalized() * 200, 
			1.5 * delta)
	else:
		velocity = velocity.move_toward(Vector2(0,0), delta*2)
	position += velocity * 80 * delta
	if abs(velocity.x) > 0.005 and real:
		scale.x = -1 if velocity.x > 0 else 1

func _input(event: InputEvent) -> void:
	if !$"..".win and event.is_action_pressed("left_mouse"):
		if real and position.distance_to(get_viewport().get_mouse_position()) < 20:
			$"..".win = true
			z_index = 2
			$"../Blackout".visible = true
			$"../RealFish/CPUParticles2D".emitting = true
			$"../Correct".play()
			position = Vector2i(position)
		elif not real and position.distance_to(get_viewport().get_mouse_position()) < 30:
			velocity = (position - get_viewport().get_mouse_position()).normalized() *2.5
