extends Node3D

var is_lerping_go_screen := false
var go_screen_alpha := 0

# Hide the game over screen by default
func _ready():
	$GameOverScreen.visible = false

# Handle player death
func _on_death_region_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	print("death region entered")
	$GameOverScreen.visible = true
	is_lerping_go_screen = true
	$GameOverScreen/Background.color = Color.from_rgba8(0, 0, 0, 0)


func _physics_process(delta: float) -> void:

	# Fade in the game over screen
	if is_lerping_go_screen:
		go_screen_alpha = lerp(go_screen_alpha, 255, delta * 10.0)

		if go_screen_alpha >= 255:
			go_screen_alpha = 255
			is_lerping_go_screen = false

		$GameOverScreen/Background.color = Color.from_rgba8(0, 0, 0, go_screen_alpha)
