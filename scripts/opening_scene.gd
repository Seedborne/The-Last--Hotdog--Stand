extends Control

var current_slide = 0
var slides = []

func _ready():
	Globals.play_main_theme()
	slides = [$VBoxContainer/slide_1, $VBoxContainer/slide_2, $VBoxContainer/slide_3, $VBoxContainer/slide_4,
	$VBoxContainer/slide_5, $VBoxContainer/slide_6, $VBoxContainer/slide_7, $VBoxContainer/slide_8,
	$VBoxContainer/slide_9, $VBoxContainer/slide_10, $VBoxContainer/slide_11, $VBoxContainer/slide_12, 
	$VBoxContainer/slide_13, $VBoxContainer/slide_14, $VBoxContainer/slide_15, $VBoxContainer/slide_16,
	$VBoxContainer/slide_17, $VBoxContainer/slide_18, $VBoxContainer/slide_19, $VBoxContainer/slide_20,
	$VBoxContainer/slide_21, $VBoxContainer/slide_22, $VBoxContainer/slide_23, $VBoxContainer/slide_24, 
	$VBoxContainer/slide_25, $VBoxContainer/slide_26, $VBoxContainer/slide_27, $VBoxContainer/slide_28,
	$VBoxContainer/slide_29, $VBoxContainer/slide_30, $VBoxContainer/slide_31, $VBoxContainer/slide_32]
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
	get_tree().change_scene_to_file("res://scenes/hotdog_cart.tscn")
