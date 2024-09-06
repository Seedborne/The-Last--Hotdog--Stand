extends Control

func _ready():
	Globals.play_main_theme()

func _on_new_game_mouse_entered():
	$Click.play()

func _on_load_game_mouse_entered():
	$Click.play()

func _on_quit_mouse_entered():
	$Click.play()

func _on_new_game_pressed():
	print("New Game selected")
	get_tree().change_scene_to_file("res://scenes/opening_scene.tscn")

func _on_load_game_pressed():
	Globals.load_game()
	print("Load Game selected")

func _on_settings_pressed():
	print("Settings selected")
	get_tree().change_scene_to_file("res://scenes/settings.tscn")

func _on_quit_pressed():
	print("Quit selected")
	get_tree().quit()


