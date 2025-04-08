extends AnimatedSprite2D

@export var direction : String = "left": #"right" "up" "down"
	set(value):
		animation = value
		direction = value
@export var index : int
var tone : int


func play_note(correct:bool): 
	$"../Trumpet".pitch_scale = 2**(float(tone)/12)
	$"../Trumpet".play()
	if correct:
		var tween = create_tween()
		tween.tween_property(self, "position", Vector2(position.x, -80), .3)
	else:
		scale = Vector2(1.2, 1.2)
