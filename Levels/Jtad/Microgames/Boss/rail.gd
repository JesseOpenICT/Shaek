extends Camera2D

var returning : bool = false
var moving : bool = false
var distance_start = 128
var distance_end = 1128

@export var pain : PackedScene

@onready var player = $PlayerFish

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await $"../../../StartTimer".timeout
	moving = true
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(player) and moving:
		position.x += (-50 if returning else 50) *delta
		position.x = clamp(position.x, distance_start, distance_end)
		if position.x == distance_end:
			returning = true 
			$"../WinArea/CollisionShape2D".disabled = false
		
		player.scale.x = -1 if returning else 1


func spawn():
	var upper = randi_range(0,1)
	for n in 2:
		var scene = pain.instantiate()
		scene.position = Vector2(130, 75)
		if randi_range(0,1) == 1:
			scene.position.x = -scene.position.x
		if upper == n:
			scene.position.y = -scene.position.y
		if is_instance_valid(player) and player.position.distance_to(scene.position) < 50 :
			scene.position.x = -scene.position.x
		scene.speed = -scene.position.x * .5/(n+1)
		add_child(scene)


func _on_player_fish_end(_won: bool) -> void:
	$Timer.stop()
