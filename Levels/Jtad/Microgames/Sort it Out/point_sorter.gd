extends Node2D


@export var sortables : Array[Node2D]
@export var points : Array[Marker2D]
var order : Array[int]

const ORDER_OPTIONS = [[1,3,0,2], [2,0,1,3], [0,3,1,2]]

@export var off : CompressedTexture2D = preload("res://Levels/Jtad/Microgames/Sort it Out/bgoff.png")
@export var on : CompressedTexture2D = preload("res://Levels/Jtad/Microgames/Sort it Out/bgon.png")
@onready var bg = $"../Bg"

func _ready() -> void:
	order.append_array( ORDER_OPTIONS[randi_range(1,ORDER_OPTIONS.size())-1] )
	var index = 0
	for fish : Node2D in sortables:
		fish.id = index
		fish.order_position = order[index]
		fish.position = points[order[index]].position
		fish.snapto = points[order[index]].position
		index +=1


func _process(_delta: float) -> void:
	for fish in sortables:
		if fish.grabbed:
			for point in points:
				if points.find(point)!= fish.order_position and abs(point.position.y - fish.position.y) < 20:
					var old_order_position = fish.order_position
					fish.order_position = points.find(point)
					for other_fish in sortables:
						if other_fish!= fish and other_fish.order_position == fish.order_position:
							other_fish.order_position = old_order_position
					await get_tree().process_frame
					await get_tree().process_frame
					$"..".win = (order in [[0,1,2,3], [3,2,1,0]])
					bg.texture = on if $"..".win else off
