@icon("res://pink.png")

extends Node2D
class_name Gamepack

## Add all Microgames as [b]reference links[/b]
@export var microgames : Array[String] 
## List of microgames as packed scenes. We can instantiate these right away.
var loaded_microgames : Array[Microgame] 
var rolled_levels : Array[int] ## For the bag system
var next_microgame : Microgame ## The next selected microgame

## Amount of levels won this run
var levels_cleared : int
## These are the nodes that will represent your lives. 
## They get removed from this array as they disappear, and once it's empty, your run will end. 
## Before being removed though they will receive a signal, allowing you to play an animation for them.
@export var lives : Array[Node] 

## This is just the music player
@export var music_player : AudioStreamPlayer
## What happens to your music during microgames. 
## If set to [b]pause music[/b], the music will pause, then continue afterwards. 
## If set to [b]reduce volume[/b], instead the volume will keep playing but reduce according to the variable below.
@export_enum("pause music", "reduce volume") var microgame_music 
## The volume in decibels for the music during microgames. 
## Remember! 0 is default, 6 is double -6 is half, then -12 is half of -6 etc.
@export var microgame_music_volume : float
## The BPM of your background music. The microgame's speed varies based on this value, and the increasing speed variable. 
@export var music_BPM : int = 120
var passed_ticks : float

var speed : float = 1

## Send a signal that if true, open a curtain. If false, close it.
## You should connect other nodes to this signal to unhide them. 
signal open(open:bool)


func _process(delta: float) -> void:
	var modified_delta = delta * (music_BPM/60.) * speed
	passed_ticks += modified_delta
	print(passed_ticks)


func preload_levels() -> void:
	for game in microgames:
		loaded_microgames.append(load(game))
	return


func await_next_microgame():
	choose_microgame()
	# NEED MORE CODE STARTING HERE FOR THE INBETWEEN MICROGAMES STUFF

func choose_microgame():
	if rolled_levels.size() == 0:
		for index in loaded_microgames.size():
			rolled_levels.append(index)
	var microgame_picked_index = rolled_levels[randi_range(1, rolled_levels.size())-1]
	var next_microgame = loaded_microgames[microgame_picked_index]


func instatiate_microgame(microgame:Microgame):
	microgame.instantiate()
	microgame.speed = speed
	microgame.music_BPM = music_BPM
	microgame.end.connect(completed_microgame)
	$Subscript/ActiveMicrogameContainer.add_child(microgame)


func completed_microgame(won:bool):
	print_rich("[color=green]win" if won else "[color=red]lose")
	passed_ticks = fmod(passed_ticks, 1)
	await_next_microgame()
