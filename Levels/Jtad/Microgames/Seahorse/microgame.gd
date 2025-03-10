extends Microgame

var start_horse : Vector2i = Vector2i(5,5)
var start_king : Vector2i = Vector2i(0,0)
var horse_pos : Vector2i


const BASE : Vector2i = Vector2i(58, 26) ## The 0,0 position of the board in screen pos
const STEP : int = 20

var tween : Tween # The tween used to move the horse
var king_progress : float = 0

@export var horse_meeple : Sprite2D
@export var king_meeple : Sprite2D


func _ready() -> void:
	super()
	
	start_horse.x = randi_range(0,2)
	start_horse.y = randi_range(0,2)
	
	start_king.x = randi_range(3,4)
	start_king.y = 6 #7- randi_range(0,2-start_horse.y)
	
	if randi_range(0,1) == 0:
		start_king.x = 7 - start_king.x
		start_horse.x = 7 - start_horse.x
	
	if randi_range(0,1) == 0:
		start_king.y = 7 - start_king.y
		start_horse.y = 7 - start_horse.y
		
	
	move_horse(start_horse)
	set_tiles()


func _process(delta: float) -> void:
	super(delta)
	var y = -(4*king_progress - 1)**2 + 1
	king_meeple.position = (Vector2(BASE + start_king*STEP) + Vector2(50*king_progress, -25*y))
	king_meeple.rotation = king_progress*8


func set_tiles():
	for spot in $Board/TileMapLayer.get_children():
		spot.queue_free()
	for x in 8:
		for y in 8:
			$Board/TileMapLayer.set_tile(Vector2i(x, y), false)
	
	## Create new yellow squares
	if !win:
		for vec2 : Vector2i in [
			Vector2i(2,1), 
			Vector2i(-2,1),
			Vector2i(2,-1),
			Vector2i(-2,-1),
			Vector2i(1,2),
			Vector2i(-1,2),
			Vector2i(1,-2),
			Vector2i(-1,-2),
		]:
			$Board/TileMapLayer.set_tile(horse_pos+vec2, true)
		


func move_horse(targetspot : Vector2i):
	tween = create_tween()
	tween.tween_property(horse_meeple, "position", Vector2(BASE + targetspot*STEP), 0.05)
	#horse_meeple.position = BASE + targetspot*STEP
	horse_pos = targetspot
	if horse_pos == start_king:
		var tween2 = create_tween()
		tween2.tween_property(self, "king_progress", 1., 1.4/speed)
		win = true
		$King/GPUParticles2D.emitting = true
	set_tiles()
