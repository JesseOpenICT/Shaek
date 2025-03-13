extends AnimatedSprite2D

var grabbed : bool ## Whether the object is grabbed
var hovered : bool ## Whether the mouse is above this
var joint_node : Node2D ## If this is connected to the other node
## Connect the main scene to this one
var scene : Microgame

signal overwrite_grab
signal kissed


func _on_grab_mouse_entered() -> void:
	hovered = true

func _on_grab_mouse_exited() -> void:
	hovered = false


func ungrab():
	grabbed = false


func _on_snoot_area_entered(area: Area2D) -> void:
	if grabbed and area.is_in_group("snoot") and !joint_node:
		joint_node = area.get_parent()
		joint_node.joint_node = self
		kissed.emit()
		
		play("win")
		joint_node.play("win")
		$GPUParticles2D.emitting = true
		$Kiss.pitch_scale = speed_scale
		$Kiss.play()
		
		if self.scale.x > 0:
			joint_node.position = Vector2(self.position.x + $Snoot/CollisionShape2D.position.x*2, self.position.y)
		else:
			joint_node.position = Vector2(self.position.x - $Snoot/CollisionShape2D.position.x*2, self.position.y)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and grabbed:
		position += event.relative
		if joint_node:
			joint_node.position += event.relative
	elif hovered and event.is_action_pressed("left_mouse"):
		grabbed = true
		overwrite_grab.emit()
	elif event.is_action_released("left_mouse"):
		grabbed = false
