extends Area2D


var hover : bool
var placed : bool
var held : bool
const CENTRE : Vector2 = Vector2(128, 96)

@export var sprites_front : Array[CompressedTexture2D]
@export var sprites_back : Array[CompressedTexture2D]

@export var emitter : CPUParticles2D

var startpos : Vector2


func set_art(index:int):
	$FrontArticle.texture = sprites_front[index]
	$BackArticle.texture = sprites_back[index]
	startpos = position


func _on_mouse_entered() -> void:
	hover = true


func _on_mouse_exited() -> void:
	hover = false


func _input(event: InputEvent) -> void:
	if placed:
		return
	if event.is_action_pressed("left_mouse") and hover:
		held = true
		z_index = 2
	elif event.is_action_released("left_mouse") and held:
		held = false
		z_index = 1
		position = startpos
	elif held and event is InputEventMouseMotion:
		position += event.relative
		if position.distance_to(CENTRE) < 22:
			$Place.play()
			held = false
			z_index = 0
			position = CENTRE
			placed = true
			get_parent().place()
			if emitter:
				emitter.emitting = true
