extends Button

@export var target_global : bool
@export var function : String
@export var parameters : Array


func _on_pressed() -> void:
	var target = GlobalFunctions if target_global else get_tree().current_scene
	var callable = Callable(target, function)
	if callable.is_valid():
		callable.callv(parameters)
