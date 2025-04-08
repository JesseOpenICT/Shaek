extends Microgame


var botched : int = 0:
	set(value):
		botched = value
		if value >= 3:
			$SubViewportContainer/SubViewport/Camera3D/Fishpivot/Fishtrumpet/Eye1.play("cry")
			$SubViewportContainer/SubViewport/Camera3D/Fishpivot/Fishtrumpet/Eye2.play("cry")


@export var notes : Array[Node2D]
var current_note : int

@export var note_sets : Array[PackedStringArray]
@export var tone_ladders : Array[PackedInt32Array]
var nset


var fishspin : Dictionary[String, Vector3] = {
	"right" = Vector3(0, 0.2, 0.2),
	"left" = Vector3(0, -0.2, -0.2),
	"up" = Vector3(-0.2, 0, 0.1),
	"down" = Vector3(0.2, 0, 0.1),
	"wrong" = Vector3(0.3,0, -0.2)
}
var tween : Tween
var audience_height : float = 0

func _ready() -> void:
	super()
	nset = randi_range(0,4)
	for note in notes:
		note.direction = note_sets[nset][note.index]


func _process(delta: float) -> void:
	super(delta)
	audience_height += delta * 3*speed
	$Spark/Audience.position.y = 12 - abs(sin(audience_height)) * 12


func is_direction(input: InputEvent) -> bool:
	for dir in ["left", "right", "up", "down"]:
		if input is InputEventKey:
			if input.is_action_pressed(dir):
				return true
	return false


func _unhandled_input(event: InputEvent) -> void:
		if botched < 3 and not win and is_direction(event):
			print(notes[current_note].direction)
			if Input.is_action_just_pressed(notes[current_note].direction):
				spin(notes[current_note].direction)
				notes[current_note].tone = tone_ladders[nset][current_note]
				notes[current_note].play_note(true)
				await get_tree().process_frame
				current_note += 1
				if current_note >= 4:
					win = true
					playwin()
			else:
				spin("wrong")
				notes[current_note].tone = -9
				notes[current_note].play_note(false)
				botched +=1


func spin(direction : String):
	if tween:
		tween.kill()
	tween = create_tween()
	$SubViewportContainer/SubViewport/Camera3D/Fishpivot/Fishtrumpet.rotation = -fishspin[direction]*2
	tween.tween_property($SubViewportContainer/SubViewport/Camera3D/Fishpivot/Fishtrumpet, "rotation", fishspin[direction]*1.5, 0.1005)


func playwin() -> void:
	$BG.play("won")
	$Applause.play()
	$Spark.visible = true


func _on_end(_win) -> void:
	$Applause.stop()
