extends AnimatedSprite2D

@export var gamepack : Gamepack

func _ready() -> void:
	print($"../../..".music_BPM)

func dismiss():
	var tween = create_tween()
	var speed = 1.0 * (float(gamepack.music_BPM)/60) / gamepack.speed
	tween.tween_property(self, "scale", Vector2(0,0), 120 / 1 / 60)
