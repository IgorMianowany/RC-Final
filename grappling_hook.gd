extends Node3D
class_name GrapplingHook

var can_fire : bool = true
var direction : Vector3 = Vector3.ZERO
var lifetime : float = 1.5
var player : Player
var collided : bool = false

@export var speed : float = 100

@onready var raycast : RayCast3D = $RayCast3D

func _ready():
	raycast.enabled = false

func _physics_process(delta: float) -> void:
	transform.origin += direction
	lifetime -= delta
	#if (raycast.is_colliding()):
		#print("colliding")
	if (raycast.is_colliding() and not collided):
		lifetime = 3
		direction = Vector3.ZERO
		collided = true
		
	if lifetime < 0:
		reset_hook()
		
		

func fire(_direction : Vector3):
	if (not can_fire):
		return
	raycast.enabled = true
	direction = _direction
	can_fire = false
	lifetime = 1.5
	#await(get_tree().create_timer(lifetime).timeout)

func reset_hook():
	reparent(player)
	direction = Vector3.ZERO
	can_fire = true
	transform.origin = Vector3.ZERO
	collided = false
	

	
