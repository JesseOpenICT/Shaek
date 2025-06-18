extends Sprite2D


@export var startnode : Sprite2D
@export var endnode : Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	scale.x = startnode.position.distance_to(endnode.position) / 64
	position = (startnode.position + endnode.position) / 2
	rotation = startnode.get_angle_to(endnode.position)
	material.set("shader_parameter/repeats", scale.x )
