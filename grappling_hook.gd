extends Node3D
class_name GrapplingHook

var can_fire : bool = true
var direction : Vector3 = Vector3.ZERO
var lifetime : float = 1.5
var player : Player
var hooked : bool = false

@export var speed : float = 250

@onready var raycast : RayCast3D = $RayCast3D

func _ready():
	raycast.enabled = false

func _physics_process(delta: float) -> void:
	transform.origin += direction
	lifetime -= delta
	#if (raycast.is_colliding()):
		#print("colliding")
	if (raycast.is_colliding()):
		grapple()
		
	if lifetime < 0:
		reset_hook()
		
func grapple():
	#reparent(player)
	hooked = true
	lifetime = 999
	direction = Vector3.ZERO

func fire(_direction : Vector3):
	if (not can_fire):
		return
	raycast.enabled = true
	direction = _direction
	can_fire = false
	lifetime = 1.5
	#await(get_tree().create_timer(lifetime).timeout)

func reset_hook():
	hooked = false
	reparent(player)
	direction = Vector3.ZERO
	can_fire = true
	transform.origin = Vector3.ZERO
	

	
