extends Node2D


@export var guys_sprite : AnimatedSprite2D
@export var score : Control


func _on_gamepack_open(open: bool) -> void:
	var tween = create_tween()
	tween.tween_property($Wave, "position", Vector2(-128, -366 if open else -120), 0.2)


func _ready() -> void:
	$FishCam.reparent($FishViewport)


func _on_gamepack_microgame_end(won: bool) -> void:
	if won:
		guys_sprite.play("Love")
	else:
		guys_sprite.play("Lose")
	await $"..".await_beats(6)
	guys_sprite.play("Default")
	


func _on_gamepack_set_score(value: int) -> void:
	score.text = "[tornado radius=4 freq=2] " + ("0"+str(value)).right(2)


func _on_gamepack_speed_up() -> void:
	$FishCam/SpeedUpLabel.visible = true
	await $"..".await_beats($"..".beats_upon_speedup)
	$FishCam/SpeedUpLabel.visible = false
