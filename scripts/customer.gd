extends Node2D

signal order_requested()
signal customer_left(customer)

var order_ticket = preload("res://scenes/order_ticket.tscn")

var customer_textures = [
	preload("res://assets/customers/blueguy.png"),
	preload("res://assets/customers/redguy.png"),
	preload("res://assets/customers/purpleguy.png")
]

func _ready():
	if Globals.current_location == "Community Park":
		$CustomerPatience.wait_time = Globals.park_patience
	elif Globals.current_location == "College Campus":
		$CustomerPatience.wait_time = Globals.campus_patience
	elif Globals.current_location == "Farmers Market":
		$CustomerPatience.wait_time = Globals.market_patience
	elif Globals.current_location == "Beach Boardwalk":
		$CustomerPatience.wait_time = Globals.boardwalk_patience
	elif Globals.current_location == "City Plaza":
		$CustomerPatience.wait_time = Globals.plaza_patience
	elif Globals.current_location == "Carnival":
		$CustomerPatience.wait_time = Globals.carnival_patience
	elif Globals.current_location == "Sports Arena":
		$CustomerPatience.wait_time = Globals.arena_patience
	print("Customer waiting for ", $CustomerPatience.wait_time, " seconds")
	$CustomerPatience.start()
	$CustomerSprite.set_process_input(true)
	var random_texture = customer_textures[randi() % customer_textures.size()]
	$CustomerSprite.texture = random_texture

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_on_customer_clicked()

func _on_customer_clicked():
	Globals.reputation -= 5
	Globals.update_reputation()
	Globals.reputation_points_lost += 5
	$OrderRepTimer.start()
	set_label_color($OrderReputation, Color(1, 0, 0))
	$OrderReputation.text = "-5pts"
	$OrderReputation.position = Vector2(350, 140)
	$OrderReputation.show()
	print("Showing order again, -5")
	print("Current rep points: ", Globals.reputation)
	emit_signal("order_requested")

func _on_order_rep_timer_timeout():
	$OrderReputation.hide()

func _on_customer_patience_timeout():
	Globals.customers_lost += 1
	Globals.reputation -= 10
	Globals.reputation_points_lost += 10
	Globals.update_reputation()
	print("Customer left, -10")
	print("Current rep points: ", Globals.reputation)
	$CustomerSprite.hide()
	set_label_color($CustomerLeft, Color(1, 0, 0))
	$CustomerLeft.show()
	set_label_color($OrderReputation, Color(1, 0, 0))
	$OrderReputation.text = "-10pts"
	$OrderReputation.position = Vector2(328, 209)
	$OrderReputation.show()
	$CustomerLeftTimer.start()
	emit_signal("customer_left", self)
	
func _on_customer_served():
	$CustomerSprite.hide()
	$CustomerServedTimer.start()
	$CustomerPatience.stop()
	emit_signal("customer_left", self)
	var ticket_order = {
		"sausage": order_ticket.sausage_type,
		"bun": order_ticket.bun_type,
		"toppings": order_ticket.toppings,
		"side": order_ticket.side
	}
	var order_value = Globals.get_order_value(Globals.tray_contents)
	var reputation_points = Globals.get_order_reputation(ticket_order)
	var tip_amount = Globals.add_tip(order_value)
	if not Globals.order_correct:
		set_label_color($OrderReputation, Color(1, 0, 0))
		$OrderReputation.text = "-" + str(reputation_points) + "pts"
		$OrderReputation.position = Vector2(328, 209)
		$OrderReputation.show()
		set_label_color($OrderMoney, Color(1, 0, 0))
		$OrderMoney.text = "+$0.00"
		$OrderMoney.show()
	if Globals.order_correct:
		set_label_color($OrderReputation, Color(0, 1, 0))
		$OrderReputation.text = "+" + str(reputation_points) + "pts"
		$OrderReputation.position = Vector2(328, 209)
		$OrderReputation.show()
		set_label_color($OrderMoney, Color(0, 1, 0))
		$OrderMoney.text = "+$" + str("%.2f" % order_value)
		$OrderMoney.show()
		set_label_color($OrderTip, Color(0, 1, 0))
		$OrderTip.text = "+$" + str("%0.2f" % tip_amount) + " tip"
		$OrderTip.show()

func _on_customer_left_timer_timeout():
	queue_free()

func set_label_color(label: Label, color: Color):
	var theme_override = Theme.new()
	theme_override.set_color("font_color", "Label", color)
	label.theme = theme_override

func _on_customer_served_timer_timeout():
	queue_free()

