extends Area2D

@export var positioni : Vector2i
var hover : bool
var microgame : Node

func _ready() -> void:
	microgame = get_parent()

func _on_mouse_entered() -> void:
	hover = true


func _on_mouse_exited() -> void:
	hover = false


func _input(event: InputEvent) -> void:
	if event.is_action_released("left_mouse") and hover:
		microgame.move_horse(positioni)
