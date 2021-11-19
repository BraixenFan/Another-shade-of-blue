extends Control

var transparency : float = 255
var step : float

func _ready():
	$VBoxContainer/Play.grab_focus()
	$VBoxContainer/Play.set_text_align(1)
	$VBoxContainer/Quit.set_text_align(0)

func _on_Play_pressed():
	get_tree().change_scene("res://Scenes/Level.tscn")
	print("It worked!")

func _on_Quit_pressed():
	get_tree().quit()

func _on_Play_focus_entered():
	$VBoxContainer/Play.set_text_align(1)

func _on_Play_focus_exited():
	$VBoxContainer/Play.set_text_align(0)


func _on_Quit_focus_entered():
	$VBoxContainer/Quit.set_text_align(1)

func _on_Quit_focus_exited():
	$VBoxContainer/Quit.set_text_align(0)
