extends Sprite2D


var cleaned : int 
var cleared : bool

var to_clear : int

var img : Image


func _ready() -> void:
	var select = randi_range(0,3)
	$"../Shell".texture = [
		preload("res://Levels/Jtad/Microgames/Snail Wash/Shells/s1.png"),
		preload("res://Levels/Jtad/Microgames/Snail Wash/Shells/s2.png"),
		preload("res://Levels/Jtad/Microgames/Snail Wash/Shells/s3.png"),
		preload("res://Levels/Jtad/Microgames/Snail Wash/Shells/s4.png"),
	][select]
	$"../Stain".texture = [
		preload("res://Levels/Jtad/Microgames/Snail Wash/Stains/s1.png"),
		preload("res://Levels/Jtad/Microgames/Snail Wash/Stains/s2.png"),
		preload("res://Levels/Jtad/Microgames/Snail Wash/Stains/s3.png"),
		preload("res://Levels/Jtad/Microgames/Snail Wash/Stains/s4.png"),
	][select]
	to_clear = [2200, 2200, 1800, 1900][select]
	img = texture.get_image()
	img.decompress() ## https://forum.godotengine.org/t/cannot-get-pixel-on-compressed-image-formats/52554
		

func _process(delta: float) -> void:
	$"../Bar/Bubbles".amount_ratio = move_toward($"../Bar/Bubbles".amount_ratio, 0, 4 * delta)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var newpos :Vector2 = get_window().get_mouse_position()
		var oldpos :Vector2 = newpos - event.relative
		if !cleared:
			area_clean(Geometry2D.bresenham_line(newpos,oldpos))
		
		$"../Bar".position = Vector2i(newpos)
		
		if cleaned > to_clear:
			win()


func area_clean(positions : Array[Vector2i]):
	var stroke : Array[Vector2i]
	for pos : Vector2i in positions:
		stroke.append_array( Geometry2D.bresenham_line(pos-Vector2i(5,-12),pos-Vector2i(1,12)) )
		stroke.append_array( Geometry2D.bresenham_line(pos-Vector2i(-18,8),pos-Vector2i(1,12)) )
		stroke.append_array( Geometry2D.bresenham_line(pos-Vector2i(-18,8),pos-Vector2i(-5,-16)) )
		stroke.append_array( Geometry2D.bresenham_line(pos-Vector2i(5,-12),pos-Vector2i(-5,-16)) )
	clean(stroke)


func clean(positions : Array[Vector2i]):
		for pos in positions:
			pos.x = clamp(pos.x, 0, 255)
			pos.y = clamp(pos.y, 0, 191)
			if img.get_pixelv(pos).a != 0.0:
				cleaned += 1
				$"../Bar/Bubbles".amount_ratio = min(1, $"../Bar/Bubbles".amount_ratio +.1)
				img.set_pixelv(pos,Color.TRANSPARENT) ## https://docs.godotengine.org/en/stable/classes/class_image.html#class-image-method-set-pixelv
			
		texture = ImageTexture.create_from_image(img) ## https://docs.godotengine.org/en/stable/classes/class_imagetexture.html#class-imagetexture-method-create-from-image


func win():
	if not get_parent().win:
		get_parent().win = true
		$"../Sparkles".visible = true
		create_tween().tween_property($"../Shell".material, "shader_parameter/amount", 1.0, .5/get_parent().speed).set_trans(Tween.TRANS_CUBIC)
		await create_tween().tween_property(self, "modulate", Color.TRANSPARENT, .5/get_parent().speed).set_trans(Tween.TRANS_CUBIC).finished
		cleared = true
		
