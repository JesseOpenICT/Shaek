extends Node

var LOADING_TIME = 0.5
signal close

# settings:
var reverse_responsive : bool = true


func load_scene(scene:String):
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
