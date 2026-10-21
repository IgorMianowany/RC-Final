extends CharacterBody3D
class_name Player


const SPEED = 50
const JUMP_VELOCITY = 10

@export var sensitivity : float = 1000

@onready var camera_pivot : Node3D = $CameraPivot
@onready var right_hook : GrapplingHook = $GrapplingHookRight
@onready var left_hook : GrapplingHook = $GrapplingHookLeft

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	right_hook.player = self
	left_hook.player = self

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	#look_at(direction)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("quit")):
		get_tree().quit()
	if (event is InputEventMouseMotion):
		#camera_pivot.rotation.y -= event.relative.x / sensitivity
		rotation.y -= event.relative.x / sensitivity
		camera_pivot.rotation.x -= event.relative.y / sensitivity
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-45), deg_to_rad(90))

	if (event.is_action_pressed("fire_right_hook")):
		fire_right_hook()
		
func fire_right_hook():
	var dir = get_aimed_at_direction()
	right_hook.reparent(get_parent())
	#right_hook.transform.origin = get_aimed_at_direction()
	#right_hook.rotation = rotation
	right_hook.look_at(transform.origin + dir)
	right_hook.fire(dir)
	
func get_aimed_at_direction() -> Vector3:
	var cam = get_viewport().get_camera_3d()
	var mousepos = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * 100
	return origin.direction_to(end)
	#var query = PhysicsRayQueryParameters3D.create(origin, end)
	#query.collide_with_areas = true
	#query.collision_mask = 1
	#
	#var result = space_state.intersect_ray(query) # raycast result
	#return result.get("position")
