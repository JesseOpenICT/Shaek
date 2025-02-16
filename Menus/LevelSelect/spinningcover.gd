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


func rewrite_album(gamepack:Gamepack):

	for button in buttons:
		button.parameters[0] = gamepack
	
	title.text = gamepack.title if gamepack.title else "Microgame Pack"
	author.text = "by "+ gamepack.author if gamepack.author else "anonymous"
	
	cover.get_surface_override_material(0).set ("albedo_texture", gamepack.cover_art)
	cover.rotation.z = deg_to_rad(-90 + 360)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(cover, "rotation", Vector3(0,0,deg_to_rad(-50)), 0.8).set_trans(9).set_ease(1) # TRANS BOUNCE EASE OUT
	await tween.finished


func _ready() -> void:
	await get_tree().create_timer(0).timeout
	rewrite_album( load(List.gamepacks[0]).instantiate() )
