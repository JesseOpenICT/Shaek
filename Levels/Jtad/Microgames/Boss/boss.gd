extends Microgame

var delay_endlessly : bool = true
var delay_ticker : int = 4

@onready var player = $SubViewportContainer/SubViewport/Rail/PlayerFish
@onready var rail = $SubViewportContainer/SubViewport/Rail
@onready var shine = $SubViewportContainer/SubViewport/Shine

func _ready() -> void:
	shine.emitting = true
	super()
	await $StartTimer.timeout
	$SubViewportContainer/SubViewport/Dudes.play("default")
	player.loose = true
	player.visible = true
	shine.emitting = false


func _process(delta: float) -> void:
	super(delta)
	if rail.returning and is_instance_valid(player) and player.global_position.x < 60:
		$SubViewportContainer/SubViewport/Dudes.play("toss")


func _on_player_fish_end(won: bool) -> void:
	win = won
	delay_endlessly = false
	if remaining_beats > 8:
		remaining_beats -= 8


func tick_down(beat : int):
	if delay_endlessly:
		delay_ticker -= 1
		if delay_ticker == 0:
			delay_ticker = 4
			remaining_beats += 4
	super(beat)
