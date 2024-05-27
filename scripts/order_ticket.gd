extends Panel

var sausage_type: String
var bun_type: String
var toppings: Array
var side: String

func _ready():
	_show_order_ticket()
	$VBoxContainer/SausageType.text = sausage_type
	$VBoxContainer/BunType.text = bun_type
	for topping in toppings:
		var topping_label = Label.new()
		topping_label.text = topping
		$VBoxContainer/Toppings.add_child(topping_label)
		if side != "":
			$VBoxContainer/Side.text = side
		else:
			$VBoxContainer/Side.text = ""

func _show_order_ticket():
	self.visible = true
	$HideTimer.start()
	
func _on_hide_timer_timeout():
	self.visible = false
	print("Order hidden")
