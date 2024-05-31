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

var paper_on_tray = false
var bowl_on_tray = false
var bun_on_paper = false
var sausage_on_bun = false
var side_in_bowl = false

var background_textures = [
	preload("res://assets/backgrounds/communitypark.png"),
	preload("res://assets/backgrounds/communitypark.png"),
	preload("res://assets/backgrounds/communitypark.png"),
]

var order_ticket_scene = preload("res://scenes/order_ticket.tscn")
var customer_scene = preload("res://scenes/customer.tscn")

func _ready():
	Globals.update_money()
	Globals.update_reputation()
	$DayTimer.start()
	$CustomerFlow.start()
	Globals.customers_served = 0
	Globals.customers_lost = 0
	$UI/DayTracker.text = "Day: " + str(Globals.current_day)
	print("Day ", Globals.current_day, " started")
	if Globals.toppings["Relish"].unlocked:
		$Relish.text = "Relish"
	if Globals.toppings["Onions"].unlocked:
		$Onions.text = "Onions"
	if Globals.toppings["Jalapeños"].unlocked:
		$Jalapenos.text = "Jalapeños"
	if Globals.toppings["Shredded Cheese"].unlocked:
		$ShreddedCheese.text = "Shredded
	Cheese"
	if Globals.toppings["Nacho Cheese"].unlocked:
		$NachoCheese.text = "Nacho
	Cheese"
	if Globals.toppings["Chili"].unlocked:
		$Chili.text = "Chili"
	if Globals.buns["Whole Wheat Bun"].unlocked:
		$WheatBun.text = "Whole Wheat
	Bun"
	if Globals.buns["Gluten Free Bun"].unlocked:
		$GFBun.text = "Gluten Free
	Bun"
	if Globals.sausages["Veggie Dog"].unlocked:
		$VeggieDog.text = "Veggie Dog"
	if Globals.sausages["Bratwurst"].unlocked:
		$Bratwurst.text = "Bratwurst"
	if Globals.sides["Potato Chips"].unlocked:
		$PotatoChips.text = "Potato Chips"
	if Globals.sides["Coleslaw"].unlocked:
		$Coleslaw.text = "Coleslaw"
	if Globals.sides["French Fries"].unlocked:
		$FrenchFries.text = "French Fries"
	if Globals.sides["Mac and Cheese"].unlocked:
		$MacCheese.text = "Mac & Cheese"

func _process(_delta):
	$UI/Clock.text = String("%0.2f" % $DayTimer.time_left)
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
	if holding_white_bun:
		$OrderTray/WhiteBunOnSprite.position = get_global_mouse_position() + Vector2(-566, -375)
	if holding_wheat_bun:
		$OrderTray/WheatBunOnSprite.position = get_global_mouse_position() + Vector2(-566, -375)
	if holding_gf_bun:
		$OrderTray/GFBunOnSprite.position = get_global_mouse_position() + Vector2(-566, -375)
	if holding_hotdog:
		$OrderTray/HotdogOnSprite.position = get_global_mouse_position() + Vector2(-566, -375)
	if holding_veggie_dog:
		$OrderTray/VeggieDogOnSprite.position = get_global_mouse_position() + Vector2(-566, -375)
	if holding_bratwurst:
		$OrderTray/BratwurstOnSprite.position = get_global_mouse_position() + Vector2(-566, -375)

func _on_day_timer_timeout():
	$CustomerFlow.stop()
	Globals.current_day += 1
	get_tree().change_scene_to_file("res://scenes/daily_report.tscn")
	print("Day finished")

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
		
	$CustomerServedTimer.start()

func _on_customer_served_timer_timeout():
	_update_customer_positions()

func _update_customer_positions():
	for i in range(current_customers.size()):
		current_customers[i].position = customer_positions[i]
		current_customers[i].order_ticket.position = order_ticket_positions[i]

func unlock_ingredient(type: String, ingredient_name: String):
	if Globals.unlock_ingredient(type, ingredient_name):
		print("Unlocked: " + ingredient_name)
		if Globals.toppings["Relish"].unlocked:
			$Relish.text = "Relish"
		if Globals.toppings["Onions"].unlocked:
			$Onions.text = "Onions"
		if Globals.toppings["Jalapeños"].unlocked:
			$Jalapenos.text = "Jalapeños"
		if Globals.toppings["Shredded Cheese"].unlocked:
			$ShreddedCheese.text = "Shredded
		Cheese"
		if Globals.toppings["Nacho Cheese"].unlocked:
			$NachoCheese.text = "Nacho
		Cheese"
		if Globals.toppings["Chili"].unlocked:
			$Chili.text = "Chili"
		if Globals.buns["Whole Wheat Bun"].unlocked:
			$WheatBun.text = "Whole Wheat
		Bun"
		if Globals.buns["Gluten Free Bun"].unlocked:
			$GFBun.text = "Gluten Free
		Bun"
		if Globals.sausages["Veggie Dog"].unlocked:
			$VeggieDog.text = "Veggie Dog"
		if Globals.sausages["Bratwurst"].unlocked:
			$Bratwurst.text = "Bratwurst"
		if Globals.sides["Potato Chips"].unlocked:
			$PotatoChips.text = "Potato Chips"
		if Globals.sides["Coleslaw"].unlocked:
			$Coleslaw.text = "Coleslaw"
		if Globals.sides["French Fries"].unlocked:
			$FrenchFries.text = "French Fries"
		if Globals.sides["Mac and Cheese"].unlocked:
			$MacCheese.text = "Mac & Cheese"
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
		$Relish/RelishUnlock.show()
	elif not Globals.held_item:
		print("Picked up Relish")
		Globals.held_item = "Relish"
		holding_relish = true
	elif "Relish" in Globals.held_item:
		print("Put relish back")
		holding_relish = false
		Globals.held_item = null
	else:
		print("Hands already full with ", Globals.held_item)
		
func _on_relish_unlock_pressed():
	unlock_ingredient("topping", "Relish")
	$Relish/RelishUnlock.hide()

func _on_onions_pressed():
	if not Globals.toppings["Onions"].unlocked:
		$Onions/OnionsUnlock.show()
	elif not Globals.held_item:
		print("Picked up Onions")
		Globals.held_item = "Onions"
		holding_onions = true
	elif "Onions" in Globals.held_item:
		print("Put onions back")
		holding_onions = false
		Globals.held_item = null
	else:
		print("Hands already full with ", Globals.held_item)
		
func _on_onions_unlock_pressed():
	unlock_ingredient("topping", "Onions")
	$Onions/OnionsUnlock.hide()
	
func _on_jalapenos_pressed():
	if not Globals.toppings["Jalapeños"].unlocked:
		$Jalapenos/JalapenosUnlock.show()
	elif not Globals.held_item:
		print("Picked up Jalapeños")
		Globals.held_item = "Jalapeños"
		holding_jalapenos = true
	elif "Jalapeños" in Globals.held_item:
		print("Put jalapenos back")
		holding_jalapenos = false
		Globals.held_item = null
	else:
		print("Hands already full with ", Globals.held_item)
		
func _on_jalapenos_unlock_pressed():
	unlock_ingredient("topping", "Jalapeños")
	$Jalapenos/JalapenosUnlock.hide()
	
func _on_shredded_cheese_pressed():
	if not Globals.toppings["Shredded Cheese"].unlocked:
		$ShreddedCheese/ShreddedCheeseUnlock.show()
	elif not Globals.held_item:
		print("Picked up Shredded Cheese")
		Globals.held_item = "Shredded Cheese"
		holding_shredded_cheese = true
	elif "Shredded Cheese" in Globals.held_item:
		print("Put shredded cheese back")
		holding_shredded_cheese = false
		Globals.held_item = null
	else:
		print("Hands already full with ", Globals.held_item)

func _on_shredded_cheese_unlock_pressed():
	unlock_ingredient("topping", "Shredded Cheese")
	$ShreddedCheese/ShreddedCheeseUnlock.hide()
	
func _on_nacho_cheese_pressed():
	if not Globals.toppings["Nacho Cheese"].unlocked:
		$NachoCheese/NachoCheeseUnlock.show()
	elif not Globals.held_item:
		print("Picked up Nacho Cheese")
		Globals.held_item = "Nacho Cheese"
		holding_nacho_cheese = true
	elif "Nacho Cheese" in Globals.held_item:
		print("Put nacho cheese back")
		holding_nacho_cheese = false
		Globals.held_item = null
	else:
		print("Hands already full with ", Globals.held_item)
		
func _on_nacho_cheese_unlock_pressed():
	unlock_ingredient("topping", "Nacho Cheese")
	$NachoCheese/NachoCheeseUnlock.hide()
	
func _on_chili_pressed():
	if not Globals.toppings["Chili"].unlocked:
		$Chili/ChiliUnlock.show()
	elif not Globals.held_item:
		print("Picked up Chili")
		Globals.held_item = "Chili"
		holding_chili = true
	elif "Chili" in Globals.held_item:
		print("Put chili back")
		holding_chili = false
		Globals.held_item = null
	else:
		print("Hands already full with ", Globals.held_item)

func _on_chili_unlock_pressed():
	unlock_ingredient("topping", "Chili")
	$Chili/ChiliUnlock.hide()
	
func _on_white_bun_pressed():
	if not Globals.held_item and not bun_on_paper:
		print("Picked up White Bun")
		Globals.held_item = "White Bun"
		holding_white_bun = true
		$OrderTray/WhiteBunOnSprite.position = get_global_mouse_position() + Vector2(-566, -375)
		$OrderTray/WhiteBunOnSprite.visible = true
	elif Globals.held_item == "White Bun":
		print("Put white bun back")
		holding_white_bun = false
		Globals.held_item = null
		$OrderTray/WhiteBunOnSprite.visible = false
	else:
		print("Hands already full with ", Globals.held_item)

func _on_wheat_bun_pressed():
	if not Globals.buns["Whole Wheat Bun"].unlocked:
		$WheatBun/WheatUnlock.show()
	elif not Globals.held_item and not bun_on_paper:
		print("Picked up Whole Wheat Bun")
		Globals.held_item = "Whole Wheat Bun"
		holding_wheat_bun = true
		$OrderTray/WheatBunOnSprite.position = get_global_mouse_position() + Vector2(-566, -375)
		$OrderTray/WheatBunOnSprite.visible = true
	elif Globals.held_item == "Whole Wheat Bun":
		print("Put wheat bun back")
		holding_wheat_bun = false
		Globals.held_item = null
		$OrderTray/WheatBunOnSprite.visible = false
	else:
		print("Hands already full with ", Globals.held_item)

func _on_wheat_unlock_pressed():
	unlock_ingredient("bun", "Whole Wheat Bun")
	$WheatBun/WheatUnlock.hide()

func _on_gf_bun_pressed():
	if not Globals.buns["Gluten Free Bun"].unlocked:
		$GFBun/GFBunUnlock.show()
	elif not Globals.held_item and not bun_on_paper:
		print("Picked up Gluten Free Bun")
		Globals.held_item = "Gluten Free Bun"
		holding_gf_bun = true
		$OrderTray/GFBunOnSprite.position = get_global_mouse_position() + Vector2(-566, -375)
		$OrderTray/GFBunOnSprite.visible = true
	elif Globals.held_item == "Gluten Free Bun":
		print("Put gf bun back")
		holding_gf_bun = false
		Globals.held_item = null
		$OrderTray/GFBunOnSprite.visible = false
	else:
		print("Hands already full with ", Globals.held_item)

func _on_gf_bun_unlock_pressed():
	unlock_ingredient("bun", "Gluten Free Bun")
	$GFBun/GFBunUnlock.hide()

func _on_hotdog_pressed():
	if not Globals.held_item and not sausage_on_bun:
		print("Picked up Hotdog")
		Globals.held_item = "Hotdog"
		holding_hotdog = true
		$OrderTray/HotdogOnSprite.position = get_global_mouse_position() + Vector2(-566, -375)
		$OrderTray/HotdogOnSprite.visible = true
	elif Globals.held_item == "Hotdog":
		print("Put hotdog back")
		holding_hotdog = false
		Globals.held_item = null
		$OrderTray/HotdogOnSprite.visible = false
	else:
		print("Hands already full with ", Globals.held_item)

func _on_veggie_dog_pressed():
	if not Globals.sausages["Veggie Dog"].unlocked:
		$VeggieDog/VeggieDogUnlock.show()
	elif not Globals.held_item and not sausage_on_bun:
		print("Picked up Veggie Dog")
		Globals.held_item = "Veggie Dog"
		holding_veggie_dog = true
		$OrderTray/VeggieDogOnSprite.position = get_global_mouse_position() + Vector2(-566, -375)
		$OrderTray/VeggieDogOnSprite.visible = true
	elif Globals.held_item == "Veggie Dog":
		print("Put veggie dog back")
		holding_veggie_dog = false
		Globals.held_item = null
		$OrderTray/VeggieDogOnSprite.visible = false
	else:
		print("Hands already full with ", Globals.held_item)

func _on_veggie_dog_unlock_pressed():
	unlock_ingredient("sausage", "Veggie Dog")
	$VeggieDog/VeggieDogUnlock.hide()

func _on_bratwurst_pressed():
	if not Globals.sausages["Bratwurst"].unlocked:
		$Bratwurst/BratwurstUnlock.show()
	elif not Globals.held_item and not sausage_on_bun:
		print("Picked up Bratwurst")
		Globals.held_item = "Bratwurst"
		holding_bratwurst = true
		$OrderTray/BratwurstOnSprite.position = get_global_mouse_position() + Vector2(-566, -375)
		$OrderTray/BratwurstOnSprite.visible = true
	elif Globals.held_item == "Bratwurst":
		print("Put bratwurst back")
		holding_bratwurst = false
		Globals.held_item = null
		$OrderTray/BratwurstOnSprite.visible = false
	else:
		print("Hands already full with ", Globals.held_item)

func _on_bratwurst_unlock_pressed():
	unlock_ingredient("sausage", "Bratwurst")
	$Bratwurst/BratwurstUnlock.hide()

func _on_potato_chips_pressed():
	if not Globals.sides["Potato Chips"].unlocked:
		$PotatoChips/ChipsUnlock.show()
	elif not Globals.held_item:
		print("Picked up Potato Chips")
		Globals.held_item = "Potato Chips"
		holding_potato_chips = true
	elif "Potato Chips" in Globals.held_item:
		print("Put potato chips back")
		holding_potato_chips = false
		Globals.held_item = null
	else:
		print("Hands already full with ", Globals.held_item)

func _on_chips_unlock_pressed():
	unlock_ingredient("side", "Potato Chips")
	$PotatoChips/ChipsUnlock.hide()

func _on_coleslaw_pressed():
	if not Globals.sides["Coleslaw"].unlocked:
		$Coleslaw/ColeslawUnlock.show()
	elif not Globals.held_item:
		print("Picked up Coleslaw")
		Globals.held_item = "Coleslaw"
		holding_coleslaw = true
	elif "Coleslaw" in Globals.held_item:
		print("Put coleslaw back")
		holding_coleslaw = false
		Globals.held_item = null
	else:
		print("Hands already full with ", Globals.held_item)

func _on_coleslaw_unlock_pressed():
	unlock_ingredient("side", "Coleslaw")
	$Coleslaw/ColeslawUnlock.hide()

func _on_french_fries_pressed():
	if not Globals.sides["French Fries"].unlocked:
		$FrenchFries/FriesUnlock.show()
	elif not Globals.held_item:
		print("Picked up French Fries")
		Globals.held_item = "French Fries"
		holding_french_fries = true
	elif "French Fries" in Globals.held_item:
		print("Put french fries back")
		holding_french_fries = false
		Globals.held_item = null
	else:
		print("Hands already full with ", Globals.held_item)

func _on_fries_unlock_pressed():
	unlock_ingredient("side", "French Fries")
	$FrenchFries/FriesUnlock.hide()

func _on_mac_cheese_pressed():
	if not Globals.sides["Mac and Cheese"].unlocked:
		$MacCheese/MacUnlock.show()
	elif not Globals.held_item:
		print("Picked up Mac and Cheese")
		Globals.held_item = "Mac and Cheese"
		holding_mac_cheese = true
	elif "Mac and Cheese" in Globals.held_item:
		print("Put mac and cheese back")
		holding_mac_cheese = false
		Globals.held_item = null
	else:
		print("Hands already full with ", Globals.held_item)

func _on_mac_unlock_pressed():
	unlock_ingredient("side", "Mac and Cheese")
	$MacCheese/MacUnlock.hide()

func _on_side_bowls_pressed():
	if not Globals.held_item and not bowl_on_tray:
		print("Picked up bowl")
		Globals.held_item = "bowl"
		$OrderTray/SideBowl.position = get_global_mouse_position() + Vector2(-566, -375)
		$OrderTray/SideBowl.visible = true
		holding_bowl = true
	elif Globals.held_item == "bowl":
		$OrderTray/SideBowl.visible = false
		print("Put bowl back")
		holding_bowl = false
		Globals.held_item = null
	else:
		print("Hands already full with ", Globals.held_item)

func _on_wrap_papers_pressed():
	if not Globals.held_item and not paper_on_tray:
		print("Picked up papers")
		Globals.held_item = "papers"
		$OrderTray/WrapPaper.position = get_global_mouse_position() + Vector2(-566, -375)
		$OrderTray/WrapPaper.visible = true
		holding_paper = true
	elif Globals.held_item == "papers":
		$OrderTray/WrapPaper.visible = false
		print("Put paper back")
		holding_paper = false
		Globals.held_item = null
	else:
		print("Hands already full with ", Globals.held_item)

func _on_tray_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and Globals.held_item:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if holding_bowl and not bowl_on_tray:
				Globals.held_item = null
				$OrderTray/SideBowl.position = Vector2(80, 0)
				holding_bowl = false
				bowl_on_tray = true
			elif holding_paper and not paper_on_tray:
				Globals.held_item = null
				$OrderTray/WrapPaper.position = Vector2(-50, 0)
				holding_paper = false
				paper_on_tray = true
			elif holding_ketchup:
				if sausage_on_bun:
					Globals.held_item = null
					Globals.add_to_tray("Ketchup", "topping")
					Globals.update_daily_ingredients_cost("topping", "Ketchup")
					$Ketchup/KetchupSprite.position = Vector2(0, 0)
					$Ketchup/KetchupSprite.rotation = deg_to_rad(0)
					$OrderTray/KetchupOnSprite.visible = true
					holding_ketchup = false
			elif holding_mustard:
				if sausage_on_bun:
					Globals.held_item = null
					Globals.add_to_tray("Mustard", "topping")
					Globals.update_daily_ingredients_cost("topping", "Mustard")
					$Mustard/MustardSprite.position = Vector2(0, 0)
					$Mustard/MustardSprite.rotation = deg_to_rad(0)
					$OrderTray/MustardOnSprite.visible = true
					holding_mustard = false
			elif holding_relish:
				if sausage_on_bun:
					Globals.held_item = null
					Globals.add_to_tray("Relish", "topping")
					Globals.update_daily_ingredients_cost("topping", "Relish")
					$OrderTray/RelishOnSprite.visible = true
					holding_relish = false
			elif holding_onions:
				if sausage_on_bun:
					Globals.held_item = null
					Globals.add_to_tray("Onions", "topping")
					Globals.update_daily_ingredients_cost("topping", "Onions")
					$OrderTray/OnionsOnSprite.visible = true
					holding_onions = false
			elif holding_jalapenos:
				if sausage_on_bun:
					Globals.held_item = null
					Globals.add_to_tray("Jalapeños", "topping")
					Globals.update_daily_ingredients_cost("topping", "Jalapeños")
					$OrderTray/JalapenosOnSprite.visible = true
					holding_jalapenos = false
			elif holding_shredded_cheese:
				if sausage_on_bun:
					Globals.held_item = null
					Globals.add_to_tray("Shredded Cheese", "topping")
					Globals.update_daily_ingredients_cost("topping", "Shredded Cheese")
					$OrderTray/ShreddedCheeseOnSprite.visible = true
					holding_shredded_cheese = false
			elif holding_nacho_cheese:
				if sausage_on_bun:
					Globals.held_item = null
					Globals.add_to_tray("Nacho Cheese", "topping")
					Globals.update_daily_ingredients_cost("topping", "Nacho Cheese")
					$OrderTray/NachoCheeseOnSprite.visible = true
					holding_nacho_cheese = false
			elif holding_chili:
				if sausage_on_bun:
					Globals.held_item = null
					Globals.add_to_tray("Chili", "topping")
					Globals.update_daily_ingredients_cost("topping", "Chili")
					$OrderTray/ChiliOnSprite.visible = true
					holding_chili = false
			elif holding_white_bun:
				if paper_on_tray and not bun_on_paper:
					Globals.held_item = null
					Globals.add_to_tray("White Bun", "bun")
					Globals.update_daily_ingredients_cost("bun", "White Bun")
					$OrderTray/WhiteBunOnSprite.visible = true
					$OrderTray/WhiteBunOnSprite.position = Vector2(-55, -18)
					holding_white_bun = false
					bun_on_paper = true
			elif holding_wheat_bun and not bun_on_paper:
				if paper_on_tray:
					Globals.held_item = null
					Globals.add_to_tray("Whole Wheat Bun", "bun")
					Globals.update_daily_ingredients_cost("bun", "Whole Wheat Bun")
					$OrderTray/WheatBunOnSprite.visible = true
					$OrderTray/WheatBunOnSprite.position = Vector2(-55, -18)
					holding_wheat_bun = false
					bun_on_paper = true
			elif holding_gf_bun:
				if paper_on_tray and not bun_on_paper:
					Globals.held_item = null
					Globals.add_to_tray("Gluten Free Bun", "bun")
					Globals.update_daily_ingredients_cost("bun", "Gluten Free Bun")
					$OrderTray/GFBunOnSprite.visible = true
					$OrderTray/GFBunOnSprite.position = Vector2(-55, -18)
					holding_gf_bun = false
					bun_on_paper = true
			elif holding_hotdog:
				if bun_on_paper and not sausage_on_bun:
					Globals.held_item = null
					Globals.add_to_tray("Regular Hot Dog", "sausage")
					Globals.update_daily_ingredients_cost("sausage", "Regular Hot Dog")
					$OrderTray/HotdogOnSprite.visible = true
					$OrderTray/HotdogOnSprite.position = Vector2(-55, -18)
					holding_hotdog = false
					sausage_on_bun = true
			elif holding_veggie_dog:
				if bun_on_paper and not sausage_on_bun:
					Globals.held_item = null
					Globals.add_to_tray("Veggie Dog", "sausage")
					Globals.update_daily_ingredients_cost("sausage", "Veggie Dog")
					$OrderTray/VeggieDogOnSprite.visible = true
					$OrderTray/VeggieDogOnSprite.position = Vector2(-55, -18)
					holding_veggie_dog = false
					sausage_on_bun = true
			elif holding_bratwurst:
				if bun_on_paper and not sausage_on_bun:
					Globals.held_item = null
					Globals.add_to_tray("Bratwurst", "sausage")
					Globals.update_daily_ingredients_cost("sausage", "Bratwurst")
					$OrderTray/BratwurstOnSprite.visible = true
					$OrderTray/BratwurstOnSprite.position = Vector2(-55, -18)
					holding_bratwurst = false
					sausage_on_bun = true
			elif holding_potato_chips:
				if bowl_on_tray and not side_in_bowl:
					Globals.held_item = null
					Globals.add_to_tray("Potato Chips", "side")
					Globals.update_daily_ingredients_cost("side", "Potato Chips")
					$OrderTray/PotatoChipsOnSprite.visible = true
					holding_potato_chips = false
					side_in_bowl = true
			elif holding_coleslaw:
				if bowl_on_tray and not side_in_bowl:
					Globals.held_item = null
					Globals.add_to_tray("Coleslaw", "side")
					Globals.update_daily_ingredients_cost("side", "Coleslaw")
					$OrderTray/ColeslawOnSprite.visible = true
					holding_coleslaw = false
					side_in_bowl = true
			elif holding_french_fries:
				if bowl_on_tray and not side_in_bowl:
					Globals.held_item = null
					Globals.add_to_tray("French Fries", "side")
					Globals.update_daily_ingredients_cost("side", "French Fries")
					$OrderTray/FriesOnSprite.visible = true
					holding_french_fries = false
					side_in_bowl = true
			elif holding_mac_cheese:
				if bowl_on_tray and not side_in_bowl:
					Globals.held_item = null
					Globals.add_to_tray("Mac and Cheese", "side")
					Globals.update_daily_ingredients_cost("side", "Mac and Cheese")
					$OrderTray/MacCheeseOnSprite.visible = true
					holding_mac_cheese = false
					side_in_bowl = true

func _on_tray_area_gui_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		$DragTimer.start()
	elif event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if dragging_tray:
			dragging_tray = false
			$OrderTray.position = Vector2(566, 375)
			if $GarbageArea.get_overlapping_areas().has($TrayArea):
				print("Tray discarded")
				Globals.clear_tray()
				$TrayArea.position = Vector2(567, 374)
				$OrderTray/SideBowl.visible = false
				$OrderTray/WrapPaper.visible = false
				$OrderTray/HotdogOnSprite.visible = false
				$OrderTray/VeggieDogOnSprite.visible = false
				$OrderTray/BratwurstOnSprite.visible = false
				$OrderTray/WhiteBunOnSprite.visible = false
				$OrderTray/WheatBunOnSprite.visible = false
				$OrderTray/GFBunOnSprite.visible = false
				$OrderTray/KetchupOnSprite.visible = false
				$OrderTray/MustardOnSprite.visible = false
				$OrderTray/RelishOnSprite.visible = false
				$OrderTray/OnionsOnSprite.visible = false
				$OrderTray/JalapenosOnSprite.visible = false
				$OrderTray/ShreddedCheeseOnSprite.visible = false
				$OrderTray/NachoCheeseOnSprite.visible = false
				$OrderTray/ChiliOnSprite.visible = false
				$OrderTray/PotatoChipsOnSprite.visible = false
				$OrderTray/ColeslawOnSprite.visible = false
				$OrderTray/FriesOnSprite.visible = false
				$OrderTray/MacCheeseOnSprite.visible = false
				bowl_on_tray = false
				paper_on_tray = false
				bun_on_paper = false
				sausage_on_bun = false
				side_in_bowl = false
			elif not current_customers:
				print("Invalid drop location")
				$TrayArea.position = Vector2(567, 374)
			else:
				for customer in current_customers:
					if customer.get_node("Area2D").get_overlapping_areas().has($TrayArea):
						check_order(customer)
						print("Order served to customer")
						$TrayArea.position = Vector2(567, 374)
						$OrderTray/SideBowl.visible = false
						$OrderTray/WrapPaper.visible = false
						$OrderTray/HotdogOnSprite.visible = false
						$OrderTray/VeggieDogOnSprite.visible = false
						$OrderTray/BratwurstOnSprite.visible = false
						$OrderTray/WhiteBunOnSprite.visible = false
						$OrderTray/WheatBunOnSprite.visible = false
						$OrderTray/GFBunOnSprite.visible = false
						$OrderTray/KetchupOnSprite.visible = false
						$OrderTray/MustardOnSprite.visible = false
						$OrderTray/RelishOnSprite.visible = false
						$OrderTray/OnionsOnSprite.visible = false
						$OrderTray/JalapenosOnSprite.visible = false
						$OrderTray/ShreddedCheeseOnSprite.visible = false
						$OrderTray/NachoCheeseOnSprite.visible = false
						$OrderTray/ChiliOnSprite.visible = false
						$OrderTray/PotatoChipsOnSprite.visible = false
						$OrderTray/ColeslawOnSprite.visible = false
						$OrderTray/FriesOnSprite.visible = false
						$OrderTray/MacCheeseOnSprite.visible = false
						bowl_on_tray = false
						paper_on_tray = false
						bun_on_paper = false
						sausage_on_bun = false
						side_in_bowl = false
						# Add logic to serve the order to the customer
						break
					else:
						print("Invalid drop location")
						$TrayArea.position = Vector2(567, 374)
		else:
			$DragTimer.stop()

func _on_drag_timer_timeout():
	dragging_tray = true
	$OrderTray.position = get_global_mouse_position()
	print("Dragging tray")

func check_order(customer):
	var order_ticket = customer.order_ticket
	print("Checking order for customer...")
	print("Order ticket - Sausage:", order_ticket.sausage_type, "Bun:", order_ticket.bun_type, "Toppings:", order_ticket.toppings, "Side:", order_ticket.side)
	print("Tray contents - Sausage:", Globals.tray_contents["sausage"], "Bun:", Globals.tray_contents["bun"], "Toppings:", Globals.tray_contents["toppings"], "Side:", Globals.tray_contents["side"])
	var ticket_order = {
		"sausage": order_ticket.sausage_type,
		"bun": order_ticket.bun_type,
		"toppings": order_ticket.toppings,
		"side": order_ticket.side
	}
	var reputation_points = Globals.get_order_reputation(ticket_order)
	if order_ticket.sausage_type == Globals.tray_contents["sausage"] and order_ticket.bun_type == Globals.tray_contents["bun"] and order_ticket.side == Globals.tray_contents["side"] and array_equals(order_ticket.toppings, Globals.tray_contents["toppings"]):
		print("Order is correct!")
		Globals.order_correct = true
		var order_value = Globals.get_order_value(Globals.tray_contents)
		Globals.money += order_value
		Globals.reputation += reputation_points
		Globals.add_tip(Globals.get_order_value(Globals.tray_contents))
		print("+$",order_value)
		print("Current money: $", Globals.money)
		print("+", reputation_points)
		print("Current rep points: ", Globals.reputation)
		Globals.update_money()
		Globals.update_reputation()
		Globals.customers_served += 1
		Globals.daily_sales += order_value
		Globals.reputation_points_earned += reputation_points
		# Calculate tips if applicable
	else:
		print("Order is incorrect!")
		Globals.order_correct = false
		Globals.reputation -= reputation_points
		Globals.update_reputation()
		Globals.customers_lost += 1
		Globals.reputation_points_lost += reputation_points
		print("-", reputation_points)
		print("Current rep points: ", Globals.reputation)
	customer._on_customer_served()
	Globals.clear_tray()
	customer.emit_signal("customer_left", customer)

func array_equals(arr1, arr2):
	if arr1.size() != arr2.size():
		return false
	var sorted_arr1 = arr1.duplicate()
	var sorted_arr2 = arr2.duplicate()   
	sorted_arr1.sort()
	sorted_arr2.sort()
	for i in range(sorted_arr1.size()):
		if sorted_arr1[i] != sorted_arr2[i]:
			return false
	return true

func update_location_to_campus():
	$Background.texture = background_textures[1]

func _on_garbage_area_input_event(_viewport, _event, _shape_idx):
	pass #Disabled due to adding ability to put ingredients back
#	if event is InputEventMouseButton and event.pressed and Globals.held_item:
#		if event.button_index == MOUSE_BUTTON_LEFT:
#			print("Discarded ", Globals.held_item)
#			Globals.held_item = null
#			if holding_bowl:
#				$OrderTray/SideBowl.visible = false
#				holding_bowl = false
#			elif holding_paper:
#				$OrderTray/WrapPaper.visible = false
#				holding_paper = false
#			elif holding_ketchup:
#				$Ketchup/KetchupSprite.position = Vector2(0, 0)
#				$Ketchup/KetchupSprite.rotation = deg_to_rad(0)
#				holding_ketchup = false
#			elif holding_mustard:
#				$Mustard/MustardSprite.position = Vector2(0, 0)
#				$Mustard/MustardSprite.rotation = deg_to_rad(0)
#				holding_mustard = false
#			elif holding_relish:
#				holding_relish = false
#			elif holding_onions:
#				holding_onions = false
#			elif holding_jalapenos:
#				holding_jalapenos = false
#			elif holding_shredded_cheese:
#				holding_shredded_cheese = false
#			elif holding_nacho_cheese:
#				holding_nacho_cheese = false
#			elif holding_chili:
#				holding_chili = false
#			elif holding_white_bun:
#				holding_white_bun = false
#			elif holding_wheat_bun:
#				holding_wheat_bun = false
#			elif holding_gf_bun:
#				holding_gf_bun = false
#			elif holding_hotdog:
#				holding_hotdog = false
#			elif holding_veggie_dog:
#				holding_veggie_dog = false
#			elif holding_bratwurst:
#				holding_bratwurst = false
#			elif holding_potato_chips:
#				holding_potato_chips = false
#			elif holding_coleslaw:
#				holding_coleslaw = false
#			elif holding_french_fries:
#				holding_french_fries = false
#			elif holding_mac_cheese:
#				holding_mac_cheese = false
