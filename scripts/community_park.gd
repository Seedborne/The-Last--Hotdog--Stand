extends Node2D

var customer_positions = [Vector2(-70, 150), Vector2(130, 150), Vector2(330, 150)] # Adjust positions as needed
var order_ticket_positions = [Vector2(150, 0), Vector2(350, 0), Vector2(550, 0)] # Adjust positions as needed
var current_customers = []

var order_ticket_scene = preload("res://scenes/order_ticket.tscn")
var customer_scene = preload("res://scenes/customer.tscn")

func _ready():
	Globals.update_money(0)
	Globals.update_reputation(0)
	$CustomerFlow.start()
	print("Customer Flow timer started")

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
	
	$UI/Orders.add_child(order_ticket)
	$UI.add_child(customer)
	
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
