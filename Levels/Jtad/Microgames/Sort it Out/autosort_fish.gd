extends Sprite2D

var grabbed : bool ## Whether the object is grabbed
var hovered : bool ## Whether the mouse is above this
var snapto : Vector2

var id : int
var order_position : int


func _process(_delta: float) -> void:
	z_index = grabbed
	$"../PointSorter".order[order_position] = id
	snapto = $"../PointSorter".points[order_position].position
	if !grabbed:
		var modified_delta = _delta * get_parent().speed
		position = position.move_toward(snapto, modified_delta*200)


func _on_grab_mouse_entered() -> void:
	hovered = true

func _on_grab_mouse_exited() -> void:
	hovered = false


func ungrab():
	grabbed = false


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and grabbed:
		position.y += event.relative.y
	elif hovered and event.is_action_pressed("left_mouse"):
		grabbed = true
	elif event.is_action_released("left_mouse"):
		grabbed = false
