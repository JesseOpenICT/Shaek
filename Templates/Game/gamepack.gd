@icon("res://pink.png")

extends Node2D
class_name Gamepack


@export_group("Interface Data")

## The title of your level. This'll be displayed before you play
@export var title : String 
## That's you! Put your username here. It will be displayed for players to see.
@export var author : String 
## Use a square image as cover art to represent your levelpack. I recommend using a 128*128 px 
## texture but other dimensions should work just fine.
@export var cover_art : CompressedTexture2D


@export_group("Game Functionality")

## Add all Microgames as [b]reference links[/b]
@export_file("*.tscn") var microgames : Array[String] 
## The boss microgame. Is optional.
@export_file("*.tscn") var boss_microgame : String 
## Once your score reaches this number minus one, you'll face the boss microgame. So if the number is
## 20, after beating 19 microgames, the 20th will be the boss. You'll win classic mode after beating it.
## If no boss microgame is set, you'll still win classic once you succesfully get this score, but a normal.
## microgame will play.
@export var boss_level : int = 20
## List of microgames as packed scenes. We can instantiate these right away.
var loaded_microgames : Array[PackedScene]
## Just the boss, as a packed scene, so again it can be instantiated sooner than when necessary.
var loaded_boss : PackedScene
## For the bag system 
var rolled_levels : Array[int] 
## The next selected microgame
var next_microgame : Microgame
## Amount of levels won this run
var levels_cleared : int
## These are the nodes that will represent your lives. 
## They get removed from this array as they disappear, and once it's empty, your run will end. 
## Before being removed though the game will attempt to run the dismiss() function on them, 
## allowing you to play an animation for them.
@export var lives : Array[Node]
## The points at which the game will speed up. X represents the amount of cleared microgames. 
## Y represents the scale of the speed (1 being default, 2 being double). I can't recommend going above 2.
@export var speedup_scale : Array[Dictionary] = [
			{"level":6, "speed":1.05},
			{"level":12, "speed":1.1},
			{"level":18, "speed":1.2},
			{"level":24, "speed":1.3},
			{"level":30, "speed":1.4},
			{"level":36, "speed":1.5},
			{"level":42, "speed":1.6},
			{"level":48, "speed":1.8},
			{"level":54, "speed":1.9},
			{"level":60, "speed":2},
		]


@export_subgroup("Downtime")
## The amount of additional beats until the microgames start flowing in, adding
## a little extra breather before the game starts after picking a gamepack.
@export var beats_until_start : int = 8
## The amount of beats until the hint appears. This plus the beats after hint is the amount of time
## between microgames.
@export var beats_until_hint : int = 4
## The amount of beats after the hint appears until the microgame starts and the open signal is sent.
@export var beats_after_hint : int = 4
## When you run out of lives or beat the boss in classic, you wait this many beats until you show the
## game over (or game won) screen. No other signals will be sent after this and no other beat counters.
## will be waited for. So when the microgame ends, it's just this many more beats until the end screen shows.
@export var beats_upon_game_over : int = 8
## The amount of beats added when speedup happens. You can use this for a special animation.
@export var beats_upon_speedup : int = 4


@export_group("Music")

## This is just the music player
@onready var music_player : AudioStreamPlayer = $Subscript/AudioStreamPlayer
## What happens to your music during microgames. 
## If set to [b]pause music[/b], the music will pause, then continue afterwards. 
## If set to [b]reduce volume[/b], instead the volume will keep playing but reduce according to the variable below.
#disabled in favor of not pausing music
#@export_enum("pause music", "reduce volume") var microgame_music_mode = 0
## The volume in decibels for the music during microgames. 
## Remember! 0 is default, 6 is double -6 is half, then -12 is half of -6 etc.
# disabled in favor of microgame specific music volume
#@export var microgame_music_volume : float
## default volume of the music player.
@onready var music_base_volume = music_player.volume_db
## The BPM of your background music. The microgame's speed varies based on this value, and the increasing speed variable. 
@export var music_BPM : int = 120
var passed_beats : int

var speed : float = 1

## Send a signal that if true, open a curtain. If false, close it.
## You should connect other nodes to this signal to unhide them. 
## This signal is sent just before and after a microgame.
signal open(open:bool)
## Send a signal with an interger indicating your current amount of levels cleared. Connect this to
## nodes that will change to indicate your score, typically a Label but it could be a sprite or anything.
## This signal is sent after a microgame is cleared. 
signal set_score(value:int)
## Send a signal to shows a hint for the next microgame, such as "dodge!" or "jump!", and an image that
## shows what controls are used, specifically arrows, space, and/or mouse. Connect this signal to a label 
## and a sprite to show them.
signal show_microgame_preparation_hint(preparation_text : String, preparation_image : CompressedTexture2D)

## Sends another signal when a microgame ends that informs other nodes whether a microgame was won (true) or lost (false).
signal microgame_end(won:bool)

## Sends a signal when the game speeds up, allowing for a special animation to play.
signal speed_up

## Sends a signal when you run out of lives.
signal game_over(score:int)


####################################################################################################


func preload_levels() -> void:
	for game in microgames:
		var microgame = load(game)
		loaded_microgames.append (microgame)
	if boss_microgame:
		loaded_boss = load(boss_microgame)


func await_beats(beats:int) -> void:
	for beat in beats:
		await $Subscript/RhythmNotifier.beat
	return


func _ready() -> void:
	preload_levels()
	await get_tree().process_frame
	await await_beats(beats_until_start)
	await_next_microgame()


## The stuff that happens between microgames. This is mostly a matter of waiting, sending signals,
## and calling the choose_microgame() and instantiate_microgame() script.
func await_next_microgame():
	choose_microgame()
	await await_beats(beats_until_hint)
	show_microgame_preparation_hint.emit(next_microgame.preparation_text, next_microgame.preparation_image)
	await await_beats(beats_after_hint)
	instatiate_microgame(next_microgame)
	music_player.volume_db = music_base_volume + next_microgame.music_volume_DB
	open.emit(true)


## Selects a random microgame using a bag system. Reloads the microgames when you run out.
func choose_microgame():
	if boss_microgame and GlobalFunctions.gamemode == GlobalFunctions.Gamemode.CLASSIC:
		if (levels_cleared+1)%boss_level == 0 and levels_cleared > 0:
			next_microgame = loaded_boss.instantiate()
			return
	## If you don't have a boss coming up:
	if rolled_levels.size() < 1:
		var index = 0
		for microgame in loaded_microgames:
			rolled_levels.append(index)
			index+=1
		print("Levels : "+ str(rolled_levels))
	var microgame_picked_index = rolled_levels[randi_range(0, rolled_levels.size()-1)]
	next_microgame = loaded_microgames[microgame_picked_index].instantiate()
	rolled_levels.erase(microgame_picked_index)


## Instantiates the microgame just before opening it
func instatiate_microgame(microgame:Microgame):
	microgame.speed = (music_BPM/60.) * speed
	microgame.end.connect(completed_microgame)
	$Subscript/RhythmNotifier.beat.connect(microgame.tick_down)
	$Subscript/ActiveMicrogameContainer.add_child(microgame)


## Gets called when a microgame ends, increases your score, handles speedup,
## Heart loss, and Game Over.
func completed_microgame(won:bool) -> void:
	music_player.volume_db = music_base_volume
	open.emit(false)
	microgame_end.emit(won)
	print_rich("[color=green]win" if won else "[color=red]lose")
	passed_beats = 0
	
	if !won:
		var life : Node = lives[0]
		lives.erase(life)
		if life.has_method("dismiss"):
			life.dismiss()
		else:
			life.queue_free()
		if lives.size() == 0:
			game_over.emit(levels_cleared)
			return
	else:
		levels_cleared += 1
		set_score.emit(levels_cleared)
		
		if GlobalFunctions.gamemode == GlobalFunctions.Gamemode.CLASSIC and levels_cleared == boss_level:
			game_over.emit(levels_cleared)
			return
		
	
	
	for speed_scale in speedup_scale:
		if speed_scale["level"] == levels_cleared:
			speed_up.emit()
			await await_beats(beats_upon_speedup)
			$Subscript/AudioStreamPlayer.pitch_scale = speed_scale["speed"]
			speed = speed_scale["speed"]
	
	await_next_microgame()
	
	await await_beats(1)
	$Subscript/ActiveMicrogameContainer.get_children()[0].queue_free()


## Sends a signal to the microgame whenever a beat passes.
func _on_rhythm_notifier_beat(_current_beat: int) -> void:
	passed_beats += 1


func _on_game_over(_score: int) -> void:
	if GlobalFunctions.gamemode == GlobalFunctions.Gamemode.CLASSIC and boss_level == levels_cleared:
		$Subscript/EndScreen/MarginContainer/VBoxContainer/Label.text = "you won!"
	$Subscript/EndScreen/MarginContainer/VBoxContainer/Score.text = str(levels_cleared)
	await await_beats(beats_upon_game_over)
	$Subscript/EndScreen.visible = true
	await await_beats(4)
	$Subscript/EndScreen/MarginContainer/VBoxContainer/Score.visible = true
	await await_beats(2)
	$Subscript/EndScreen/MarginContainer/VBoxContainer/Exit.visible = true
	$Subscript/EndScreen/MarginContainer/VBoxContainer/Exit.grab_focus()
