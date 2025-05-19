extends Node

const splash_screen = preload("res://scenes/splash_screen.tscn")

# levels
const lvlMtFuji = preload("res://scenes/level_mt_fuji.tscn")

func start_lvl(level: PackedScene):
	var lvl = level.instantiate()
	remove_child(get_node("SplashScreen"))
	add_child(lvl)

var start_lvl_mt_fuji := start_lvl.bind(lvlMtFuji)

func _ready():
	var splash = splash_screen.instantiate()
	splash.get_node("ButtonContainer/StartButton").pressed.connect(start_lvl_mt_fuji)
	add_child(splash)
