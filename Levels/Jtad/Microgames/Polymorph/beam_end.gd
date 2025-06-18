extends Node2D


var real_position : Vector2


func _ready() -> void:
	real_position = position

func _process(delta: float) -> void:
	if $"..".win:
		return
	var direction : Vector2 = Input.get_vector("left","right","up","down").normalized()
	real_position += direction * delta * 75*$"..".speed
	position.x = real_position.x + 3*sin(real_position.y/6+PI/2)
	position.y = real_position.y + 3*sin(real_position.x/6)


func reduce() -> void:
	$Sprite2D.visible = false
	$Magic.emitting = false
	$Burst.emitting = true
	var tween : Tween = create_tween()
	tween.tween_property($"../Beam".material, "shader_parameter/variation", 0, .8/$"..".speed)
	tween.parallel().tween_property($"../Beam".material, "shader_parameter/translucent", 0, .8/$"..".speed)
