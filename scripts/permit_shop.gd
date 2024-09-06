extends Control

var campus_cost = 100
var market_cost = 200
var boardwalk_cost = 400
var plaza_cost = 600
var carnival_cost = 1000
var arena_cost = 2000

func _ready():
	if Globals.money >= campus_cost:
		$PermitPanel/VBoxContainerCampus/ButtonCampus.disabled = false
	if Globals.money >= market_cost and Globals.unlocked_campus:
		$PermitPanel/VBoxContainerMarket/ButtonMarket.disabled = false
	if Globals.money >= boardwalk_cost and Globals.unlocked_market:
		$PermitPanel/VBoxContainerBoardwalk/ButtonBoardwalk.disabled = false
	if Globals.money >= plaza_cost and Globals.unlocked_boardwalk:
		$PermitPanel/VBoxContainerPlaza/ButtonPlaza.disabled = false
	if Globals.money >= carnival_cost and Globals.unlocked_plaza:
		$PermitPanel/VBoxContainerCarnival/ButtonCarnival.disabled = false
	if Globals.money >= arena_cost and Globals.unlocked_carnival:
		$PermitPanel/VBoxContainerArena/ButtonArena.disabled = false
	if Globals.unlocked_campus:
		$PermitPanel/VBoxContainerCampus.visible = false
		$PermitPanel/PanelCampus.visible = false
	if Globals.unlocked_market:
		$PermitPanel/VBoxContainerMarket.visible = false
		$PermitPanel/PanelMarket.visible = false
	if Globals.unlocked_boardwalk:
		$PermitPanel/VBoxContainerBoardwalk.visible = false
		$PermitPanel/PanelBoardwalk.visible = false
	if Globals.unlocked_plaza:
		$PermitPanel/VBoxContainerPlaza.visible = false
		$PermitPanel/PanelPlaza.visible = false
	if Globals.unlocked_carnival:
		$PermitPanel/VBoxContainerCarnival.visible = false
		$PermitPanel/PanelCarnival.visible = false
	if Globals.unlocked_arena:
		$PermitPanel/VBoxContainerArena.visible = false
		$PermitPanel/PanelArena.visible = false
	if not Globals.tutorial14 and not Globals.tutorial_complete:
		$PermitPanel/Tutorial.show()
		
func _on_button_campus_pressed():
	if Globals.money >= campus_cost:
		Globals.money -= campus_cost
		Globals.current_location = "College Campus"
		Globals.unlocked_campus = true
		$PermitPanel/VBoxContainerCampus.visible = false
		$PermitPanel/PanelCampus.visible = false
		$PermitPurchaseSound.play()

func _on_button_market_pressed():
	if Globals.money >= market_cost:
		Globals.money -= market_cost
		Globals.current_location = "Farmers Market"
		Globals.unlocked_market = true
		$PermitPanel/VBoxContainerMarket.visible = false
		$PermitPanel/PanelMarket.visible = false
		$PermitPurchaseSound.play()

func _on_button_boardwalk_pressed():
	if Globals.money >= boardwalk_cost:
		Globals.money -= boardwalk_cost
		Globals.current_location = "Beach Boardwalk"
		Globals.unlocked_boardwalk = true
		$PermitPanel/VBoxContainerBoardwalk.visible = false
		$PermitPanel/PanelBoardwalk.visible = false
		$PermitPurchaseSound.play()

func _on_button_plaza_pressed():
	if Globals.money >= plaza_cost:
		Globals.money -= plaza_cost
		Globals.current_location = "City Plaza"
		Globals.unlocked_plaza = true
		$PermitPanel/VBoxContainerPlaza.visible = false
		$PermitPanel/PanelPlaza.visible = false
		$PermitPurchaseSound.play()

func _on_button_carnival_pressed():
	if Globals.money >= carnival_cost:
		Globals.money -= carnival_cost
		Globals.current_location = "Carnival"
		Globals.unlocked_carnival = true
		$PermitPanel/VBoxContainerCarnival.visible = false
		$PermitPanel/PanelCarnival.visible = false
		$PermitPurchaseSound.play()

func _on_button_arena_pressed():
	if Globals.money >= arena_cost:
		Globals.money -= arena_cost
		Globals.current_location = "Sports Arena"
		Globals.unlocked_arena = true
		$PermitPanel/VBoxContainerArena.visible = false
		$PermitPanel/PanelArena.visible = false
		$PermitPurchaseSound.play()
	
func _on_back_button_pressed():
	if not Globals.tutorial14 and not Globals.tutorial_complete:
		Globals.tutorial14 = true
		$PermitPanel/Tutorial.hide()
	get_tree().change_scene_to_file("res://scenes/daily_report.tscn")
