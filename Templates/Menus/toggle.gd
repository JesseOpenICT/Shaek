extends CheckButton

@export var target_global : bool
@export var function : String
@export var parameters : Array


@export var attached_global_variable : String


func _ready() -> void:
	if attached_global_variable:
		button_pressed = ( GlobalFunctions.get(attached_global_variable))


func _on_toggled(toggled_on: bool) -> void:
	var target = GlobalFunctions if target_global else get_tree().current_scene
	var callable = Callable(target, function)
	if callable.is_valid():
		var parameters_plus_toggle = []
		parameters_plus_toggle.append_array(parameters)
		parameters_plus_toggle.append(toggled_on)
		callable.callv(parameters_plus_toggle)
