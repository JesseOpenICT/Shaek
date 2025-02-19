@icon("res://game.png")

extends Node2D
class_name Microgame


## Something like "Jump!" "Avoid!" "Push!"
@export var preparation_text : String 
## Image of mouse, arrow keys, spacebar, ideally nothing else
@export var preparation_image : CompressedTexture2D

## amount of beats the microgame takes. Oughtta be a multiple of 4.
@export var beats : int 
var remaining_ticks : float
var remaining_beats : int

## Multiply your delta by this. That means that a speed of 2 results in double speed microgames.
## This value is set automatically based on the music's BPM. Typically this means you will want to
## Half your microgames speed because a 120 BPM seems pretty average and that results in 2* speed.
var speed : float = 1


var win : bool

signal end


func _ready() -> void:
	remaining_beats = beats + 1
	tick_down(0)


func _process(delta: float) -> void:
	var _modified_delta = delta * speed


func tick_down(_beat_n:int):
	remaining_beats -= 1
	if remaining_beats < 9:
		$Countdown.visible = true
		$Countdown.frame = max(0, 8-remaining_beats)
		if remaining_beats==0:
			end.emit(win)
