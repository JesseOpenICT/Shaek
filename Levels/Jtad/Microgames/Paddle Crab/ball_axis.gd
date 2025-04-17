extends Node2D


var direction = 0.0
var distance = 0.5

var y_min = 60
var y_max = 160
var bounce = 0.3

var ball_minmax = 90
var trajectory = 0.0


func _ready() -> void:
	$Ball.position.x = randf_range(-60, 60)
	trajectory = randf_range(1, 1.2)
	$"..".win = true
	$"../Opponent_Rail/Opponent/Hands".speed_scale = $"..".speed
	$"../Player/Hands".speed_scale = $"..".speed
	
	$"../Timer".wait_time = 1.0/$"..".speed
	$"../Timer".start()
	await $"../Timer".timeout
	direction = -1.0


func _process(delta: float) -> void:
	distance += direction * $"..".speed * delta / 2
	bounce +=  $"..".speed * delta / 2 
	position.y = y_min + distance*(y_max-y_min)
	scale = Vector2(1,1) * (distance*0.6 + 0.4)
	$Ball/BallNotShadow.position.y = abs(sin((bounce)*PI)) * -30.0
	$Ball/BallNotShadow.position = Vector2i($Ball/BallNotShadow.position)
	
	if distance > 1.:
		if abs($Ball.position.x - ($"../Player".position.x-128)) < 34 and $"..".win:
			distance = 2-distance
			direction = -1.0
			$"../Player/Hands".frame = 0
			$"../Player/Hands".play()
		else:
			get_parent().win = false
			z_index =2
			
	if distance < 0.:
		distance = -distance
		direction = 1.0
		$"../Opponent_Rail/Opponent/Hands".frame = 0
		$"../Opponent_Rail/Opponent/Hands".play()
	
	$Ball.position.x += trajectory * delta * $"..".speed * 60
	$"../Opponent_Rail/Opponent".position.x = int(clamp($Ball.position.x, -90+30, 90-30))
	if abs($Ball.position.x) > 90:
		$Ball.position.x = (180-abs($Ball.position.x)) * (1 if $Ball.position.x > 0 else -1)
		trajectory = -trajectory
	
	$"../Player".position.x = int(clamp(get_viewport().get_mouse_position().x, -90+128+30, 90+128-30))
	
	
	$"../Player".frame = int(fmod(($"../Player".position.x + 128) , 10) > 5)
	$"../Opponent_Rail/Opponent".frame = int(fmod(($"../Opponent_Rail/Opponent".position.x + 128) , 10) > 5)
