extends Node

var LOADING_TIME = 0.5
signal close


var pause_object : Node2D
# settings:
var settings_object : Node2D
var reverse_responsive : bool = true
var fullscreen : bool = false
var music_on : bool = true
var music_volume : int = 50
var effects_on : bool = true
var effects_volume : int = 90

enum Gamemode {CLASSIC=0, ENDLESS=1}
var gamemode : int = Gamemode.CLASSIC


const SAVEABLE = [
	"setting_objects",
	"reverse_responsive",
	"fullscreen",
	"music_on",
	"music_volume",
	"effects_on",
	"effects_volume",
]
const PATH : String = "user://Settings.json"


signal close_settings


var loading : bool


func _ready() -> void:
	load_save()


func _unhandled_input(event: InputEvent) -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	if get_window().gui_get_focus_owner():
		if event.is_action_pressed("scroll_down"):
			get_window().gui_get_focus_owner().find_next_valid_focus().grab_focus()
		elif event.is_action_pressed("scroll_up"):
			get_window().gui_get_focus_owner().find_prev_valid_focus().grab_focus()
		
	if event.is_action_pressed("ui_cancel"):
		if settings_object:
			exit_settings()
		elif get_tree().current_scene is Gamepack:
			pause()
		elif get_tree().current_scene.name == "Main":
			load_scene("res://Menus/OpeningScreen/home.tscn")
		elif get_tree().current_scene.name == "StartScreen":
			get_tree().quit()


func pause():
	if is_instance_valid(pause_object):
		get_tree().paused = false
		pause_object.queue_free()
		pause_object = null
	else:
		get_tree().paused = true
		pause_object = preload("res://Menus/Settings/pause.tscn").instantiate()
		get_tree().current_scene.add_child(pause_object)


func load_gamepack(scene : Gamepack, mode = Gamemode):
	if loading:
		return
	
	gamemode = mode
	print(gamemode)
	loading = true
	close.emit(false)
	await get_tree().create_timer(LOADING_TIME).timeout
	
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(scene)
	get_tree().current_scene = scene
	loading = false
	close.emit(true)


func load_scene(scene:String):
	get_tree().paused = false
	close.emit(false)
	await get_tree().create_timer(LOADING_TIME).timeout
	get_tree().change_scene_to_file(scene)
	close.emit(true)


func _process(_delta: float) -> void:
	# 256,192
	if reverse_responsive and get_window().mode == 0:
		var window_size = get_window().size 
		if (window_size.x-2) * 192 > window_size.y * 256:
			var ideal_size = floori(window_size.y / 192 * 256) +1
			get_window().size.x = min(window_size.x, lerp(window_size.x, ideal_size, .02) )
		if (window_size.x+2) * 192 < window_size.y * 256:
			var ideal_size = floori(window_size.x / 256 * 192) +1
			get_window().size.y = min(window_size.y, lerp(window_size.y, ideal_size, .02) )


func set_setting(variable, value):
	set(variable, value)
	interpret_settings()


func interpret_settings():
	get_window().mode = Window.Mode.MODE_FULLSCREEN if fullscreen else 0 if get_window().mode == 3 else get_window().mode
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		linear_to_db(float(music_volume)*.01) if music_on else -80.
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Effects"),
		linear_to_db(float(effects_volume)*.01) if effects_on else -80.
	)


func settings():
	settings_object = preload("res://Menus/Settings/settings.tscn").instantiate()
	get_tree().current_scene.add_child(settings_object)

func exit_settings():
	settings_object.queue_free()
	close_settings.emit()
	save_settings()
	settings_object = null


func save_settings():
	var save : Dictionary = {} # Empty dictionary to store all settings
	
	for setting in SAVEABLE:
		save[setting] = get(setting)
		
	# Save the settings to a JSON file
	var savedata = JSON.stringify(save)
	var save_game = FileAccess.open(PATH, FileAccess.WRITE)
	save_game.store_line(savedata)
	print('saved')


func load_save():
	var save : Dictionary = {} # Empty dictionary to store all settings
	
	if FileAccess.file_exists(PATH):
		var savetext = FileAccess.get_file_as_string(PATH)
		var savedata = JSON.parse_string(savetext)
		if savedata:
			save = savedata
	
	if save:
		for setting in save.keys():
			set(setting, save[setting])
	interpret_settings()
