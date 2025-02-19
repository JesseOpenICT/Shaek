extends Control

func set_label(gamepack:Gamepack):
	$Sprite2D.texture = gamepack.cover_art
	$Button.text = gamepack.title
	$Button.parameters[0] = gamepack
	$Button.parameters[1] = $Button
