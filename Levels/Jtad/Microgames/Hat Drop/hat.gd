extends Sprite2D


var move : float
var fall : float 
const CENTRE = 128
const RANGE = 80
const MOVE_RATE = .7
const CONSISTENCY = .6
const WIN_RANGE = 32 ## (64/2)
const WIN_HEIGHT = 110


var stopped : bool


func _ready() -> void:
	if randf() < randf():
		texture = preload("res://Levels/Jtad/Microgames/Hat Drop/hat2.png")


func _process(delta: float) -> void:
	if not stopped:
		var modified_move_rate = get_parent().speed/2 * (1-CONSISTENCY) + CONSISTENCY
		move = fmod(move + delta * MOVE_RATE * modified_move_rate, 1)
		position.x = (CENTRE-RANGE + 4.*abs(move-.5) *RANGE)
	
	else:
		
		if position.y < WIN_HEIGHT or abs(position.x-CENTRE) > WIN_RANGE:
			fall += delta*get_parent().speed *2
			position.y += get_parent().speed * delta * 60 * (sqrt(3*fall)/2)
		if not (position.y < WIN_HEIGHT or abs(position.x-CENTRE) > WIN_RANGE):
			position.y = WIN_HEIGHT
			if not get_parent().win:
				get_parent().win = true
				win()


func win():
	$"../Land".play()
	$"../Drop".stop()
	var tween = create_tween()
	tween.tween_property($"../BG".material, "shader_parameter/morph", 1, 0.5/get_parent().speed)
	$"../Head".texture = preload("res://Levels/Jtad/Microgames/Hat Drop/fis2.png")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space") and not stopped:
		stopped = true
		$"../Drop".play()


func end():
	$"../Drop".stop()
	$"../Land".stop()
