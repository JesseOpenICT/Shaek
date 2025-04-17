extends Node2D

@export var focus : Control

func _ready() -> void:
	visible = true
	await get_tree().process_frame
	await get_tree().process_frame
	focus.grab_focus()
	if not GlobalFunctions.is_connected("close_settings", _ready):
		GlobalFunctions.close_settings.connect(_ready)
