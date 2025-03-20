extends Sprite2D

var grabbed : bool ## Whether the object is grabbed
var hovered : bool ## Whether the mouse is above this
var max_dist : float
const MAXIMUM = 6
## Connect the main scene to this one
@export var scene : Microgame


func _on_grab_mouse_entered() -> void:
	hovered = true

func _on_grab_mouse_exited() -> void:
	hovered = false


func _process(delta:float) -> void:
	if position.x > 140:
		if not scene.win:
			scene.win = true
			win()
		grabbed = false
		position.x += delta * 820 * scene.speed
		position.y = -.6* (position.x-128) +96


func win():
	$Pop.play(0.09)
	$Timer.start(1.2/scene.speed)
	await $Timer.timeout
	$"../WinScreen".visible = true
	$"../GPUParticles2D".speed_scale = scene.speed
	$"../GPUParticles2D".emitting = true
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and grabbed:
		if event.relative.x > 0:
			var travel = min(event.relative.x/10, MAXIMUM-max_dist)
			position.x += travel
			max_dist += travel
			position.x = clamp(position.x, 128, 200)
			position.y = -.6* (position.x-128) +96
		
		
	elif hovered and event.is_action_pressed("left_mouse"):
		grabbed = true
	elif event.is_action_released("left_mouse"):
		grabbed = false
		position = Vector2i(position)
		max_dist = 0
