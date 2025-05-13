extends Sprite2D


var cleaned : int 


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var newpos :Vector2 = get_window().get_mouse_position()
		var oldpos :Vector2 = newpos - event.relative
		area_clean(Geometry2D.bresenham_line(newpos,oldpos))
		
		if cleaned > 6900:
			win()


func area_clean(positions : Array[Vector2i]):
	var stroke : Array[Vector2i]
	for pos : Vector2i in positions:
		stroke.append_array( Geometry2D.bresenham_line(pos+Vector2i(2,8),pos-Vector2i(2,8)) )
	clean(stroke)


func clean(positions : Array[Vector2i]):
		
		var img : Image = texture.get_image()
		img.decompress() ## https://forum.godotengine.org/t/cannot-get-pixel-on-compressed-image-formats/52554
		
		for pos in positions:
			pos.x = clamp(pos.x, 0, 255)
			pos.y = clamp(pos.y, 0, 191)
			if img.get_pixel(pos.x, pos.y).a != 0.0:
				cleaned += 1
				img.set_pixelv(pos,Color.TRANSPARENT) ## https://docs.godotengine.org/en/stable/classes/class_image.html#class-image-method-set-pixelv
			
		texture = ImageTexture.create_from_image(img) ## https://docs.godotengine.org/en/stable/classes/class_imagetexture.html#class-imagetexture-method-create-from-image


func win():
	if not get_parent().win:
		get_parent().win = true
		create_tween().tween_property(self, "modulate", Color.TRANSPARENT, .5/get_parent().speed).set_trans(Tween.TRANS_CUBIC)
