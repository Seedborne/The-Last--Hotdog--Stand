extends Node2D

var customer_positions = [Vector2(-30, 10), Vector2(350, 10), Vector2(730, 10)]
var order_ticket_positions = [Vector2(40, 30), Vector2(420, 30), Vector2(800, 30)]
var current_customers = []

var dragging_tray = false
var holding_ketchup = false
var holding_mustard = false
var holding_relish = false
var holding_onions = false
var holding_jalapenos = false
var holding_shredded_cheese = false
var holding_nacho_cheese = false
var holding_chili = false
var holding_white_bun = false
var holding_wheat_bun = false
var holding_gf_bun = false
var holding_hotdog = false
var holding_veggie_dog = false
var holding_bratwurst = false
var holding_potato_chips = false
var holding_coleslaw = false
var holding_french_fries = false
var holding_mac_cheese = false
var holding_bowl = false
var holding_paper = false

var background_textures = [
	preload("res://assets/backgrounds/communitypark.png"),
	preload("res://assets/backgrounds/communitypark.png"),
	preload("res://assets/backgrounds/communitypark.png"),
]

var order_ticket_scene = preload("res://scenes/order_ticket.tscn")
var customer_scene = preload("res://scenes/customer.tscn")

func _ready():
	Globals.update_money()
	Globals.update_reputation(0)
	$CustomerFlow.start()
	print("Customer Flow timer started")

func _process(_delta):
	if dragging_tray:
		$OrderTray.position = get_global_mouse_position()
		$TrayArea.position = get_global_mouse_position()
	if holding_bowl:
		$OrderTray/SideBowl.position = get_global_mouse_position() + Vector2(-566, -375)
	if holding_paper:
		$OrderTray/WrapPaper.position = get_global_mouse_position() + Vector2(-566, -375)
	if holding_ketchup:
		$Ketchup/KetchupSprite.position = get_global_mouse_position() + Vector2(-780, -336)
	if holding_mustard:
		$Mustard/MustardSprite.position = get_global_mouse_position() + Vector2(-844, -346)
	
func _create_order():
	var order_ticket = order_ticket_scene.instantiate()
	var customer = customer_scene.instantiate()
	
	var index = current_customers.size()
	customer.position = customer_positions[index]
	order_ticket.position = order_ticket_positions[index]
	
	var order = Globals.generate_order()
	
	order_ticket.sausage_type = order["sausage"]
	order_ticket.bun_type = order["bun"]
	order_ticket.toppings = order["toppings"]
	order_ticket.side = order["side"]
	
	add_child(order_ticket)
	add_child(customer)
	
	customer.order_ticket = order_ticket
	current_customers.append(customer)
	
	customer.connect("order_requested", Callable(order_ticket, "_show_order_ticket"))
	customer.connect("customer_left", Callable(self, "_on_customer_left"))

func _on_customer_flow_timeout():
	_create_order()
	print("Order created")

func _on_order_requested(order_ticket):
	order_ticket._show_order_ticket()

func _on_customer_left(customer):
	if customer in current_customers:
		current_customers.erase(customer)
		var order_ticket = customer.order_ticket
		if order_ticket:
			order_ticket.queue_free()
		#customer.queue_free() maybe not need because redundant in customer.gd
	_update_customer_positions()
	
func _update_customer_positions():
	for i in range(current_customers.size()):
		current_customers[i].position = customer_positions[i]
		current_customers[i].order_ticket.position = order_ticket_positions[i]

func unlock_ingredient(type: String, ingredient_name: String):
	if Globals.unlock_ingredient(type, ingredient_name):
		print("Unlocked: " + ingredient_name)
	else:
		print("Not enough money to unlock " + ingredient_name)

func _on_ketchup_pressed():
	if not Globals.held_item:
		print("Picked up Ketchup")
		Globals.held_item = "Ketchup"
		holding_ketchup = true
		$Ketchup/KetchupSprite.position = get_global_mouse_position() + Vector2(-780, -336)
		$Ketchup/KetchupSprite.rotation = deg_to_rad(45)
	elif "Ketchup" in Globals.held_item:
		print("Put ketchup back")
		holding_ketchup = false
		Globals.held_item = null
		$Ketchup/KetchupSprite.position = Vector2(0, 0)
		$Ketchup/KetchupSprite.rotation = deg_to_rad(0)
	else:
		print("Hands already full with ", Globals.held_item)

func _on_mustard_pressed():
	if not Globals.held_item:
		print("Picked up Mustard")
		Globals.held_item = "Mustard"
		holding_mustard = true
		$Mustard/MustardSprite.position = get_global_mouse_position() + Vector2(-844, -346)
		$Mustard/MustardSprite.rotation = deg_to_rad(45)
	elif "Mustard" in Globals.held_item:
		print("Put mustard back")
		holding_mustard = false
		Globals.held_item = null
		$Mustard/MustardSprite.position = Vector2(0, 0)
		$Mustard/MustardSprite.rotation = deg_to_rad(0)
	else:
		print("Hands already full with ", Globals.held_item)

func _on_relish_pressed():
	if not Globals.toppings["Relish"].unlocked:
		unlock_ingredient("topping", "Relish")
	elif not Globals.held_item:
		print("Picked up Relish")
		Globals.held_item = "Relish"
		holding_relish = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_onions_pressed():
	if not Globals.toppings["Onions"].unlocked:
		unlock_ingredient("topping", "Onions")
	elif not Globals.held_item:
		print("Picked up Onions")
		Globals.held_item = "Onions"
		holding_onions = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_jalapenos_pressed():
	if not Globals.toppings["Jalapeños"].unlocked:
		unlock_ingredient("topping", "Jalapeños")
	elif not Globals.held_item:
		print("Picked up Jalapeños")
		Globals.held_item = "Jalapeños"
		holding_jalapenos = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_shredded_cheese_pressed():
	if not Globals.toppings["Shredded Cheese"].unlocked:
		unlock_ingredient("topping", "Shredded Cheese")
	elif not Globals.held_item:
		print("Picked up Shredded Cheese")
		Globals.held_item = "Shredded Cheese"
		holding_shredded_cheese = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_nacho_cheese_pressed():
	if not Globals.toppings["Nacho Cheese"].unlocked:
		unlock_ingredient("topping", "Nacho Cheese")
	elif not Globals.held_item:
		print("Picked up Nacho Cheese")
		Globals.held_item = "Nacho Cheese"
		holding_nacho_cheese = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_chili_pressed():
	if not Globals.toppings["Chili"].unlocked:
		unlock_ingredient("topping", "Chili")
	elif not Globals.held_item:
		print("Picked up Chili")
		Globals.held_item = "Chili"
		holding_chili = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_white_bun_pressed():
	if not Globals.held_item:
		print("Picked up White Bun")
		Globals.held_item = "White Bun"
		holding_white_bun = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_wheat_bun_pressed():
	if not Globals.buns["Whole Wheat Bun"].unlocked:
		unlock_ingredient("bun", "Whole Wheat Bun")
	elif not Globals.held_item:
		print("Picked up Whole Wheat Bun")
		Globals.held_item = "Whole Wheat Bun"
		holding_wheat_bun = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_gf_bun_pressed():
	if not Globals.buns["Gluten Free Bun"].unlocked:
		unlock_ingredient("bun", "Gluten Free Bun")
	elif not Globals.held_item:
		print("Picked up Gluten Free Bun")
		Globals.held_item = "Gluten Free Bun"
		holding_gf_bun = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_hotdog_pressed():
	if not Globals.held_item:
		print("Picked up Hotdog")
		Globals.held_item = "Hotdog"
		holding_hotdog = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_veggie_dog_pressed():
	if not Globals.sausages["Veggie Dog"].unlocked:
		unlock_ingredient("sausage", "Veggie Dog")
	elif not Globals.held_item:
		print("Picked up Veggie Dog")
		Globals.held_item = "Veggie Dog"
		holding_veggie_dog = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_bratwurst_pressed():
	if not Globals.sausages["Bratwurst"].unlocked:
		unlock_ingredient("sausage", "Bratwurst")
	elif not Globals.held_item:
		print("Picked up Bratwurst")
		Globals.held_item = "Bratwurst"
		holding_bratwurst = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_potato_chips_pressed():
	if not Globals.sides["Potato Chips"].unlocked:
		unlock_ingredient("side", "Potato Chips")
	elif not Globals.held_item:
		print("Picked up Potato Chips")
		Globals.held_item = "Potato Chips"
		holding_potato_chips = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_coleslaw_pressed():
	if not Globals.sides["Coleslaw"].unlocked:
		unlock_ingredient("side", "Coleslaw")
	elif not Globals.held_item:
		print("Picked up Coleslaw")
		Globals.held_item = "Coleslaw"
		holding_coleslaw = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_french_fries_pressed():
	if not Globals.sides["French Fries"].unlocked:
		unlock_ingredient("side", "French Fries")
	elif not Globals.held_item:
		print("Picked up French Fries")
		Globals.held_item = "French Fries"
		holding_french_fries = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_mac_cheese_pressed():
	if not Globals.sides["Mac and Cheese"].unlocked:
		unlock_ingredient("side", "Mac and Cheese")
	elif not Globals.held_item:
		print("Picked up Mac and Cheese")
		Globals.held_item = "Mac and Cheese"
		holding_mac_cheese = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_side_bowls_pressed():
	if not Globals.held_item:
		print("Picked up bowl")
		Globals.held_item = "bowl"
		$OrderTray/SideBowl.position = get_global_mouse_position() + Vector2(-566, -375)
		$OrderTray/SideBowl.visible = true
		holding_bowl = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_wrap_papers_pressed():
	if not Globals.held_item:
		print("Picked up papers")
		Globals.held_item = "papers"
		$OrderTray/WrapPaper.position = get_global_mouse_position() + Vector2(-566, -375)
		$OrderTray/WrapPaper.visible = true
		holding_paper = true
	else:
		print("Hands already full with ", Globals.held_item)

func _on_tray_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and Globals.held_item:
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("Placed ", Globals.held_item, " on the tray")
			Globals.held_item = null
			if holding_bowl:
				$OrderTray/SideBowl.position = Vector2(80, 0)
				holding_bowl = false
			elif holding_paper:
				$OrderTray/WrapPaper.position = Vector2(-50, 0)
				holding_paper = false
			elif holding_ketchup:
				$Ketchup/KetchupSprite.position = Vector2(0, 0)
				$Ketchup/KetchupSprite.rotation = deg_to_rad(0)
				holding_ketchup = false
			elif holding_mustard:
				$Mustard/MustardSprite.position = Vector2(0, 0)
				$Mustard/MustardSprite.rotation = deg_to_rad(0)
				holding_mustard = false
			elif holding_relish:
				holding_relish = false
			elif holding_onions:
				holding_onions = false
			elif holding_jalapenos:
				holding_jalapenos = false
			elif holding_shredded_cheese:
				holding_shredded_cheese = false
			elif holding_nacho_cheese:
				holding_nacho_cheese = false
			elif holding_chili:
				holding_chili = false
			elif holding_white_bun:
				holding_white_bun = false
			elif holding_wheat_bun:
				holding_wheat_bun = false
			elif holding_gf_bun:
				holding_gf_bun = false
			elif holding_hotdog:
				holding_hotdog = false
			elif holding_veggie_dog:
				holding_veggie_dog = false
			elif holding_bratwurst:
				holding_bratwurst = false
			elif holding_potato_chips:
				holding_potato_chips = false
			elif holding_coleslaw:
				holding_coleslaw = false
			elif holding_french_fries:
				holding_french_fries = false
			elif holding_mac_cheese:
				holding_mac_cheese = false

func _on_tray_area_gui_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		$DragTimer.start()
	elif event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if dragging_tray:
			dragging_tray = false
			$OrderTray.position = Vector2(566, 375)
			if $GarbageArea.get_overlapping_areas().has($TrayArea):
				print("Tray discarded")
				$TrayArea.position = Vector2(567, 374)
				$OrderTray/SideBowl.visible = false
				$OrderTray/WrapPaper.visible = false
				# Add logic to clear the tray and discard the order
			elif not current_customers:
				print("Invalid drop location")
				$TrayArea.position = Vector2(567, 374)
			else:
				for customer in current_customers:
					if customer.get_node("Area2D").get_overlapping_areas().has($TrayArea):
						print("Order served to customer")
						$TrayArea.position = Vector2(567, 374)
						$OrderTray/SideBowl.visible = false
						$OrderTray/WrapPaper.visible = false
						# Add logic to serve the order to the customer
						break
					else:
						print("Invalid drop location")
						$TrayArea.position = Vector2(567, 374)
		else:
			$DragTimer.stop()

func _on_garbage_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and Globals.held_item:
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("Discarded ", Globals.held_item)
			Globals.held_item = null
			if holding_bowl:
				$OrderTray/SideBowl.visible = false
				holding_bowl = false
			elif holding_paper:
				$OrderTray/WrapPaper.visible = false
				holding_paper = false
			elif holding_ketchup:
				$Ketchup/KetchupSprite.position = Vector2(0, 0)
				$Ketchup/KetchupSprite.rotation = deg_to_rad(0)
				holding_ketchup = false
			elif holding_mustard:
				$Mustard/MustardSprite.position = Vector2(0, 0)
				$Mustard/MustardSprite.rotation = deg_to_rad(0)
				holding_mustard = false
			elif holding_relish:
				holding_relish = false
			elif holding_onions:
				holding_onions = false
			elif holding_jalapenos:
				holding_jalapenos = false
			elif holding_shredded_cheese:
				holding_shredded_cheese = false
			elif holding_nacho_cheese:
				holding_nacho_cheese = false
			elif holding_chili:
				holding_chili = false
			elif holding_white_bun:
				holding_white_bun = false
			elif holding_wheat_bun:
				holding_wheat_bun = false
			elif holding_gf_bun:
				holding_gf_bun = false
			elif holding_hotdog:
				holding_hotdog = false
			elif holding_veggie_dog:
				holding_veggie_dog = false
			elif holding_bratwurst:
				holding_bratwurst = false
			elif holding_potato_chips:
				holding_potato_chips = false
			elif holding_coleslaw:
				holding_coleslaw = false
			elif holding_french_fries:
				holding_french_fries = false
			elif holding_mac_cheese:
				holding_mac_cheese = false

func _on_drag_timer_timeout():
	dragging_tray = true
	$OrderTray.position = get_global_mouse_position()
	print("Dragging tray")

func update_location_to_campus():
	$Background.texture = background_textures[1]
