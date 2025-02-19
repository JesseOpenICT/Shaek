extends Control

var tween : Tween
@onready var cover : MeshInstance3D = $LevelStarter/AlbumCover/SubViewport/Cover
@onready var title = $LevelStarter/VBoxContainer/VBoxContainer/NegativeMargin/LevelName
@onready var author = $LevelStarter/VBoxContainer/VBoxContainer/Author
@onready var buttons = [
	$LevelStarter/VBoxContainer/VBoxContainer/Button,
	$LevelStarter/VBoxContainer/VBoxContainer/Button2
]

var selected_pack : PackedScene
var previous_button : Control


func rewrite_album(gamepack:Gamepack, return_button:Control):
	previous_button = return_button
	
	$LevelList.visible = false
	$LevelStarter.visible = true
	
	for button in buttons:
		button.parameters[0] = gamepack
	
	title.text = gamepack.title if gamepack.title else "Microgame Pack"
	author.text = "by "+ gamepack.author if gamepack.author else "anonymous"
	
	cover.get_surface_override_material(0).set ("albedo_texture", gamepack.cover_art)
	cover.rotation.z = deg_to_rad(-90 + 360)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(cover, "rotation", Vector3(0,0,deg_to_rad(-50)), 0.8).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await tween.finished
	buttons[0].grab_focus()


func _ready() -> void:
	var level_container = $LevelList/ScrollContainer/VBoxContainer
	
	for gamepack in List.gamepacks:
		var loaded_gamepack : Gamepack = load(gamepack).instantiate()
		var label = load("res://Templates/Menus/gamepack_label.tscn").instantiate()
		label.set_label(loaded_gamepack)
		level_container.add_child(label)
	
	await get_tree().process_frame
	level_container.get_children()[1].get_child(1).grab_focus()
	
	GlobalFunctions.close_settings.connect(reopen_levels)


func reopen_levels():
	$LevelList.visible=true
	$LevelStarter.visible=false
	if previous_button:
		previous_button.grab_focus()
	else:
		$LevelList/ScrollContainer/VBoxContainer.get_children()[0].find_child("Button").grab_focus()
