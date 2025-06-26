extends Sprite2D


@export var images : Array[CompressedTexture2D]
@export var shards : PackedScene

var HP = 8

func win():
	get_parent().win = true
	var tween : Tween = create_tween()
	tween.tween_property($"../BG/Glow".material, "shader_parameter/density", 1, 1./$"..".speed)

func shatter(amount:int = 10):
	var particles = shards.instantiate() as CPUParticles2D
	particles.amount = amount
	particles.speed_scale = $"..".speed/2
	add_child(particles)
	$"../Crack".stop()
	$"../Crack".play()


var wriggle : Tween

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		if not $"..".win:
			shatter()
			HP -= 1
			
			match HP:
				0 : texture=images[4]
				2 : texture=images[3]
				4 : texture=images[2]
				6 : texture=images[1]
			
			if HP <= 0:
				shatter(300)
				win()
				material.set("shader_parameter/amount", 0)
			else:
				if wriggle:
					wriggle.stop()
				wriggle = create_tween()
				position += Vector2(10,0).rotated(randf_range(-PI,PI))
				wriggle.tween_property(self, "position", Vector2(256,192)/2, 0.05)
