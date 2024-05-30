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
