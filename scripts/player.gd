extends CharacterBody3D

const SPEED_WALK = 8
const SPEED_RUN = 16
const JUMP_VELOCITY = 8

const MOUSE_SENSTIVITY_X = 0.008
const MOUSE_SENSTIVITY_Y = 0.001

const CAMERA_LERP_SPEED = 10
const PIVOT_LERP_SPEED = 25

# Camera rotation lerping
var camera_lerp_weight := 0.0
var is_camera_lerping = false
var camera_lerp_init_rot: Quaternion
var camera_lerp_targ_rot: Quaternion

# Pivot rotation lerping
var pivot_lerp_weight := 0.0
var is_pivot_lerping = false
var pivot_lerp_init_rot: Quaternion
var pivot_lerp_targ_rot: Quaternion

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	# Get movement direcction: input_dir to Vector3, normalized, rotated to the camera.
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized().rotated(Vector3.UP, $CameraTTPPivot.rotation.y)


	if is_pivot_lerping:
		pivot_lerp_weight = pivot_lerp_weight + delta * PIVOT_LERP_SPEED
		if pivot_lerp_weight > 1:
			pivot_lerp_weight = 1
			is_pivot_lerping = false
		$Pivot.basis = Basis(pivot_lerp_init_rot.slerp(pivot_lerp_targ_rot, pivot_lerp_weight))
		$HorseCollision.basis = $Pivot.basis
		$HorseCollision.rotate_y(PI)


	if is_camera_lerping:
		camera_lerp_weight = camera_lerp_weight + delta * CAMERA_LERP_SPEED
		if camera_lerp_weight > 1:
			camera_lerp_weight = 1
			is_camera_lerping = false

		$CameraTTPPivot.basis = Basis(camera_lerp_init_rot.slerp(camera_lerp_targ_rot, camera_lerp_weight))

	var speed := SPEED_WALK
	if Input.is_action_pressed("move_sprint"):
		speed = SPEED_RUN
		$Pivot/HorseModel/AnimationPlayer.speed_scale = -2
	else:
		$Pivot/HorseModel/AnimationPlayer.speed_scale = 1

	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

		pivot_lerp_init_rot = Quaternion($Pivot.basis)
		pivot_lerp_targ_rot = Quaternion(Basis.looking_at(direction))

		if pivot_lerp_init_rot.angle_to(pivot_lerp_targ_rot) > PI / 6:
			is_pivot_lerping = true
			pivot_lerp_weight = 0


		$Pivot/HorseModel/AnimationPlayer.play("walk")

	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		$Pivot/HorseModel/AnimationPlayer.stop()


	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var ang: float = -event.relative.x * MOUSE_SENSTIVITY_X
		$CameraTTPPivot.rotate_y(ang)
		$Pivot.rotate_y(ang)
		$HorseCollision.rotate_y(ang)

	if event is InputEventKey:
		if not Input.is_action_just_pressed("camera_recenter"):
			return

		camera_lerp_weight = 0
		is_camera_lerping = true
		camera_lerp_init_rot = $CameraTTPPivot.quaternion
		camera_lerp_targ_rot = $Pivot.quaternion
