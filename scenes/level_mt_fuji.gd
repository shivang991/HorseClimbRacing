extends Node3D

var is_lerping_go_screen := false
var go_screen_alpha := 0

signal restart_pressed

# Hide the game over screen by default
func _ready():
	$GameOverScreen.visible = false
	$GameOverScreen/ButtonContainer/RestartButton.visible = true

# Handle player death
func _on_death_region_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	$Player.die()
	$GameOverScreen.visible = true
	is_lerping_go_screen = true
	$GameOverScreen/Background.color = Color.from_rgba8(0, 0, 0, 0)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _physics_process(delta: float) -> void:

	# Fade in the game over screen
	if is_lerping_go_screen:
		go_screen_alpha = lerp(go_screen_alpha, 200, delta)

		if go_screen_alpha >= 200:
			go_screen_alpha = 200
			is_lerping_go_screen = false
			$GameOverScreen/ButtonContainer/RestartButton.visible = false

		$GameOverScreen/Background.color = Color.from_rgba8(0, 0, 0, go_screen_alpha)
	

func _on_restart_button_pressed():
	restart_pressed.emit()
