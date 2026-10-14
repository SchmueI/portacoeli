extends ClickableObject


func _on_clicked() -> void:
	
	$Sprite2D.texture = load("res://assets/textures/levels/herbarium/interface/check_pressed.png")
	
	get_parent().get_node("ButtonTimer").start()
	
	pass # Replace with function body.


func _on_button_timer_timeout() -> void:
	$Sprite2D.texture = load("res://assets/textures/levels/herbarium/interface/check.png")
	pass # Replace with function body.
