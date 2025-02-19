extends Node2D

func _process(delta: float) -> void:
	$Sprite2D.scale.x = move_toward($Sprite2D.scale.x, 1, delta)



func _on_rhythm_notifier_beat(_current_beat: int) -> void:
	$Sprite2D.scale.x = 1.5


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		$AudioStreamPlayer.pitch_scale += 0.1
	elif event.is_action_pressed("ui_down"):
		$AudioStreamPlayer.pitch_scale -= 0.1
	
