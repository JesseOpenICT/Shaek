extends ColorRect
class_name Loader

func _ready() -> void:
	progress(true)
	GlobalFunctions.close.connect(progress)

func progress(unhide:bool) -> void:
	visible = true
	
	var tween : Tween = create_tween()
	tween.tween_property(material, "shader_parameter/circle", float(unhide), GlobalFunctions.LOADING_TIME)
	await tween.finished
	
	visible = !unhide
	GlobalFunctions
