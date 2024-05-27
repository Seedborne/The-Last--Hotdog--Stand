extends Control

var current_slide = 0
var slides = []

func _ready():
	slides = [$VBoxContainer/slide_1, $VBoxContainer/slide_2, $VBoxContainer/slide_3]
	_update_slides()
	$VBoxContainer/Button.pressed.connect(_on_next_pressed)

func _update_slides():
	for i in range(slides.size()):
		slides[i].visible = (i == current_slide)

func _on_next_pressed():
	if current_slide < slides.size() - 1:
		current_slide += 1
		_update_slides()
	else:
		_go_to_first_location()

func _go_to_first_location():
	get_tree().change_scene_to_file("res://scenes/community_park.tscn")
