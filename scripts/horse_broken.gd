extends Node3D

func _ready():

	for c in $Pivot.get_children():
		if c is RigidBody3D:
			c.apply_impulse(
				Vector3(
					randf_range(-1, 1),
					randf_range(5, 10),
					randf_range(-1, 1)
				)
			)
			c.linear_velocity = Vector3(
				0,
				16,
				0
			)
