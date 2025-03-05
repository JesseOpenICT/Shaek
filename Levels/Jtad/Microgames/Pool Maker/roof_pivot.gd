extends Marker2D

var grabbed : bool ## Whether the object is grabbed
var hovered : bool ## Whether the mouse is above this
## Connect the main scene to this one
var scene : Microgame
var active ## is true if you're winning
@export var spark : AnimatedSprite2D

@export_range(-360, 360, 1, "radians_as_degrees") var rotate_min : float
@export_range(-360, 360, 1, "radians_as_degrees") var rotate_max : float

var pivotpoint : int = 0

signal overwrite_grab
signal kissed


func _on_grab_mouse_entered() -> void:
	hovered = true

func _on_grab_mouse_exited() -> void:
	hovered = false
	


func ungrab():
	grabbed = false


func _process(delta: float) -> void:
	if grabbed and rotation < rotate_max/2:
		if is_instance_valid(spark):
			spark.queue_free()
		rotation = move_toward(rotation, position.angle_to_point(get_viewport().get_mouse_position()) - pivotpoint, 9* delta)
	else:
		rotation = move_toward(rotation, (0 if rotation < rotate_max/2 else rotate_max), 5* delta)
	rotation = clamp(rotation, rotate_min, rotate_max)
	if rotation > rotate_max/2:
		active = true


func _input(event: InputEvent) -> void:
	if hovered and event.is_action_pressed("left_mouse"):
		grabbed = true
		pivotpoint = position.angle_to_point(get_viewport().get_mouse_position())
		
		overwrite_grab.emit()
		
		
	elif event.is_action_released("left_mouse"):
		grabbed = false
