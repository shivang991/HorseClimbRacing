extends CharacterBody3D


const SPEED = 15
const JUMP_VELOCITY = 10

const MOUSE_SENSTIVITY_X = 0.0005
const MOUSE_SENSTIVITY_Y = 0.0001

var w: float = 0
var initial_rot: Quaternion
var target_rot: Quaternion

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()

	# print(lerp_angle(0, PI, w))

	w = w+delta*25


	$Pivot.basis = Basis(initial_rot.slerp(target_rot, min(w, 1)))
	$HoriseCollision.basis = $Pivot.basis
	$HoriseCollision.rotate_y(PI)

	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED


		initial_rot = Quaternion($Pivot.basis)
		target_rot = Quaternion(Basis.looking_at(direction))


		if initial_rot.angle_to(target_rot) > PI / 6:
			w = 0

	
		$Pivot/HorseModel/AnimationPlayer.play("walk")

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		$Pivot/HorseModel/AnimationPlayer.stop()


	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$CameraTTPPivot.rotation.y = clampf(
			$CameraTTPPivot.rotation.y + event.relative.x * MOUSE_SENSTIVITY_X,
			-PI / 2,
			PI / 2
		)

		$CameraTTPPivot.rotation.x = clampf(
			$CameraTTPPivot.rotation.x + event.relative.y * MOUSE_SENSTIVITY_Y,
			-PI / 2,
			PI / 2
		)
