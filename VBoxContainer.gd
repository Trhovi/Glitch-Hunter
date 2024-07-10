extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
	


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://world.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
func _on_Quitbutton_pressed():
	get_tree().quit()
