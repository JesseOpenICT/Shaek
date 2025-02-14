@icon("res://game.png")

extends Node2D
class_name Microgame


## Something like "Jump!" "Avoid!" "Push!"
@export var preparation_text : String 
## Image of mouse, arrow keys, spacebar, ideally nothing else
@export var preparation_image : Texture 

## amount of beats the microgame takes. Oughtta be a multiple of 4.
@export var ticks : int 
var remaining_ticks : float

## BPM of the music
var music_BPM : float = 120
## Multiply your delta by this. That means that a speed of 2 results in double speed microgames
var speed : float = 1


var win : bool

signal end


func _ready() -> void:
	remaining_ticks = ticks

func _process(delta: float) -> void:
	var modified_delta = delta * (music_BPM/60.) * speed
	remaining_ticks -= modified_delta
	
	if ceil(remaining_ticks) < 9:
		$Countdown.visible = true
		$Countdown.frame = max(0, 8- ceil(remaining_ticks))
		if remaining_ticks<=0:
			end.emit(win)
