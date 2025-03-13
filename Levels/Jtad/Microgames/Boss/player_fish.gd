extends Area2D

var velocity : float = 3.8
var time : float = -0.85

var loose : bool = false
var above : bool = true

const ACCELLERATION = 10
const SPEED = 2
const CENTRE = 0

var damage_invincibility : bool
signal end(won:bool)


@export var health_nodes : Array[Node2D]
var health : int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y = 0 + sin(time*PI)*80
	if !loose:
		return
	time += delta
	
	var direction : float = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	velocity = move_toward(velocity, direction*SPEED, ACCELLERATION*delta)
	#position.x += velocity
	position.x = clamp(position.x + velocity, CENTRE-115, CENTRE+115)
	$AnimatedSprite2D.play(set_sprite(time*PI))
	if (position.y < 0) != above:
		emit_particles()


func emit_particles():
	above = (position.y < 0)
	($ParticlesUp if above else $ParticlesDown).emitting = true
	

func set_sprite(x:float) -> String:
	if damage_invincibility:
		return "dmg"
	if (sin(x) > 0.87):
		return "dip"
	elif (sin(x) < -0.87):
		return "peak"
	if (cos(x)>0):
		return "fall"
	return "rise"


func take_damage():
	if damage_invincibility:
		return
	health -= 1
	damage_invincibility = true
	$Hurtsfx.play()
	$DamageTimer.start()
	if health > -1:
		health_nodes[health].dismiss()


func _on_damage_timer_timeout() -> void:
	if health <= 0:
		die()
	else:
		damage_invincibility = false


func die():
	queue_free()
	end.emit(false)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("pain"):
		take_damage()
	elif area.is_in_group("win"):
		loose = false
		var tween1 = create_tween()
		var tween2 = create_tween()
		end.emit(true)
		tween1.tween_property(self, "global_position", area.global_position, 1.5)
		tween2.tween_property(self, "scale", Vector2(0,0), 1.5)
