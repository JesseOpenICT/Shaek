extends Node2D


@export var guys_sprite : AnimatedSprite2D
@export var score : Control

@export var hint_image : Sprite2D
@export var hint_text : RichTextLabel


func _on_gamepack_open(open: bool) -> void:
	if !open:
		hint_image.get_parent().scale = Vector2(0,0)
	var tween = create_tween()
	tween.tween_property($Wave, "position", Vector2(-128, -366 if open else -120), 0.2)


func _ready() -> void:
	hint_image.get_parent().scale = Vector2(0,0)
	$FishCam.reparent($FishViewport)
	for i in $"..".lives:
		i.play("Default")


func _on_gamepack_microgame_end(won: bool) -> void:
	if won:
		guys_sprite.play("Love")
		for i in $"..".lives:
			i.play("Win")
	else:
		guys_sprite.play("Lose")
		for i in $"..".lives:
			i.play("Lose")
	await $"..".await_beats(6)
	guys_sprite.play("Default")
	for i in $"..".lives:
		i.play("Default")
	


func _on_gamepack_set_score(value: int) -> void:
	score.text = "[tornado radius=4 freq=2] " + ("0"+str(value)).right(2)

@export var speedup_label : Node 

func _on_gamepack_speed_up() -> void:
	speedup_label.visible = true
	await $"..".await_beats($"..".beats_upon_speedup)
	speedup_label.visible = false


func _on_gamepack_show_microgame_preparation_hint(preparation_text: String, preparation_image: Gamepack.Controls) -> void:
	hint_image.texture = get_parent().preparation_images[preparation_image]
	hint_text.text = "[center][shake=5 rate=4] "+ preparation_text
	var tween = create_tween()
	tween.tween_property(hint_image.get_parent(), "scale", Vector2(1,1), 
		0.5 / get_parent().speed )
