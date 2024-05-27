extends Node2D

signal order_requested()
signal customer_left(customer)

var order_ticket = preload("res://scenes/order_ticket.tscn")
var park_patience = 18.0

var customer_textures = [
	preload("res://assets/customers/blueguy.png"),
	preload("res://assets/customers/redguy.png"),
	preload("res://assets/customers/purpleguy.png")
]

func _ready():
	$CustomerPatience.wait_time = park_patience
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
	Globals.update_reputation(-5)
	print("Showing order again")
	emit_signal("order_requested")

func _on_customer_patience_timeout():
	emit_signal("customer_left", self)
	print("Customer left")
	queue_free()


