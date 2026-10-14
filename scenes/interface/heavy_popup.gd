extends NotificationPopup


func _on_button_next_clicked() -> void:
	next.emit()
	
func _on_button_previous_clicked() -> void:
	previous.emit()

func _on_button_back_clicked() -> void:
	close.emit()

func _on_clicked() -> void:
	close.emit()
	
	
func toggle_ui(toggle:bool=true) -> void:
	previous_button_visible(toggle)
	next_button_visible(toggle)
	back_button_visible(toggle)
	touch_enabled = not toggle

func previous_button_visible(toggle:bool=true) -> void:
	$ButtonPrevious.touch_enabled = toggle
	$ButtonPrevious.visible = toggle
	
func next_button_visible(toggle:bool=true) -> void:
	$ButtonNext.touch_enabled = toggle
	$ButtonNext.visible = toggle
	
func back_button_visible(toggle:bool=true) -> void:
	$ButtonBack.touch_enabled = toggle
	$ButtonBack.visible = toggle
	
func get_previous_button() -> ClickableObject:
	return $ButtonPrevious

func get_next_button() -> ClickableObject:
	return $ButtonNext
	
func get_back_button() -> ClickableObject:
	return $ButtonBack
