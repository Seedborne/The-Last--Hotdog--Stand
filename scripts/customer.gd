extends Node2D

signal order_requested()
signal customer_left(customer)

var order_ticket = preload("res://scenes/order_ticket.tscn")

var customer_textures = [
	preload("res://assets/customers/redguy.png"),
	preload("res://assets/customers/orangeguy.png"),
	preload("res://assets/customers/yellowguy.png"),
	preload("res://assets/customers/greenguy.png"),
	preload("res://assets/customers/tealguy.png"),
	preload("res://assets/customers/blueguy.png"),
	preload("res://assets/customers/violetguy.png"),
	preload("res://assets/customers/purpleguy.png"),
	preload("res://assets/customers/pinkguy.png"),
	preload("res://assets/customers/plumguy.png")
]

var customer_voices = [
	preload("res://assets/audio/gibberish1.mp3"),
	preload("res://assets/audio/gibberish2.mp3"),
	preload("res://assets/audio/gibberish3.mp3"),
	preload("res://assets/audio/gibberish4.mp3"),
	preload("res://assets/audio/gibberish5.mp3"),
	preload("res://assets/audio/gibberish6.mp3")
]

var customer_voice = null

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
	customer_voice = customer_voices[randi() % customer_voices.size()]
	$CustomerVoice.stream = customer_voice
	$CustomerVoice.play()

func _process(_delta):
	var remaining_time = $CustomerPatience.time_left
	var total_time = $CustomerPatience.wait_time
	if remaining_time >= total_time / 2:
		$HappyFace.visible = true
		$NeutralFace.visible = false
		$AngryFace.visible = false
	elif remaining_time >= total_time / 4:
		$HappyFace.visible = false
		$NeutralFace.visible = true
		$AngryFace.visible = false
	elif $CustomerSprite.visible:
		$HappyFace.visible = false
		$NeutralFace.visible = false
		$AngryFace.visible = true

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
	$OrderReputation.text = "-5 Rep"
	$OrderReputation.show()
	$CustomerVoice.stream = customer_voice
	$CustomerVoice.play()
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
	$HappyFace.visible = false
	$NeutralFace.visible = false
	$AngryFace.visible = false
	set_label_color($CustomerLeft, Color(1, 0, 0))
	$CustomerLeft.show()
	set_label_color($OrderReputation, Color(1, 0, 0))
	$OrderReputation.text = "-10pts"
	$OrderReputation.show()
	$CustomerLeftTimer.start()
	emit_signal("customer_left", self)
	
func _on_customer_served():
	$CustomerSprite.hide()
	$HappyFace.visible = false
	$NeutralFace.visible = false
	$AngryFace.visible = false
	$CustomerServedTimer.start()
	$CustomerPatience.stop()
	$Area2D.monitoring = false
	$Area2D.input_pickable = false
	emit_signal("customer_left", self)
	var ticket_order = {
		"sausage": order_ticket.sausage_type,
		"bun": order_ticket.bun_type,
		"toppings": order_ticket.toppings,
		"side": order_ticket.side
	}
	var order_value = Globals.get_order_value(Globals.tray_contents)
	var reputation_points = Globals.get_order_reputation(ticket_order)
	var speed_bonus = Globals.current_speed_bonus
	if not Globals.order_correct:
		set_label_color($OrderReputation, Color(1, 0, 0))
		$OrderReputation.text = "-" + str(reputation_points) + " Rep"
		$OrderReputation.show()
		set_label_color($OrderMoney, Color(1, 0, 0))
		$OrderMoney.text = "+$0.00"
		$OrderMoney.show()
	if Globals.order_correct:
		var tip_amount = Globals.add_tip(order_value)
		set_label_color($OrderReputation, Color(0, 1, 0))
		$OrderReputation.text = "+" + str(reputation_points) + " Rep"
		$OrderReputation.show()
		set_label_color($OrderMoney, Color(0, 1, 0))
		$OrderMoney.text = "+$" + str("%.2f" % order_value)
		$OrderMoney.show()
		set_label_color($OrderTip, Color(0, 1, 0))
		$OrderTip.text = "+$" + str("%0.2f" % tip_amount) + " tip"
		$OrderTip.show()
		set_label_color($OrderSpeedBonus, Color(0, 1, 0))
		$OrderSpeedBonus.text = "+" + str(speed_bonus) + " bonus"
		$OrderSpeedBonus.show()

func _on_customer_left_timer_timeout():
	queue_free()

func set_label_color(label: Label, color: Color):
	var theme_override = Theme.new()
	theme_override.set_color("font_color", "Label", color)
	label.theme = theme_override

func _on_customer_served_timer_timeout():
	queue_free()

func get_speed_bonus() -> int:
	var remaining_time = $CustomerPatience.time_left
	var total_time = $CustomerPatience.wait_time
	if remaining_time >= total_time / 2:
		Globals.current_speed_bonus = 10
		return 10
	elif remaining_time >= total_time / 4:
		Globals.current_speed_bonus = 4
		return 4
	else:
		Globals.current_speed_bonus = 0
		return 0
