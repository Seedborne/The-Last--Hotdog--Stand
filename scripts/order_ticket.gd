extends Panel

var sausage_type: String
var bun_type: String
var toppings: Array
var side: String

func _ready():
	_show_order_ticket()

func _show_order_ticket():
	$VBoxContainer/SausageType.text = sausage_type
	$VBoxContainer/BunType.text = bun_type
	for child in $VBoxContainer/Toppings.get_children():
		child.queue_free()
	for topping in toppings:
		var topping_label = Label.new()
		topping_label.text = topping
		var font = load("res://assets/IndieFlower-Regular.ttf") as Font
		topping_label.add_theme_font_override("font", font)
		#topping_label.add_theme_font_size_override("font_size", 18)
		topping_label.add_theme_color_override("font_color", Color(0, 0, 0))
		topping_label.add_theme_constant_override("outline_size", 1)
		topping_label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
		$VBoxContainer/Toppings.add_child(topping_label)
	if side != "":
		$VBoxContainer/Side.text = side
	else:
		$VBoxContainer/Side.text = ""
	self.visible = true
	$HideTimer.start()
	
func _on_hide_timer_timeout():
	self.visible = false
	print("Order hidden")
