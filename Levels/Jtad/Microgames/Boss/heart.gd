extends Sprite2D


func dismiss():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color("FF000000"), 1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT_IN)
