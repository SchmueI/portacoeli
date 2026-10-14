class_name NotificationPopup
extends ClickableObject

signal closed		# emits as soon as the popup is closed
signal close		# emits as soon as the popup requests to be closed


signal next
signal previous

var sourcePos : Vector2 = Vector2(0,0)
var heavy : bool = false 
