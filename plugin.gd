@tool
extends EditorPlugin

var control = Button.new()

func _enter_tree():
	add_abdpush_button()

func _exit_tree():
	EditorInterface.get_file_system_dock().remove_child(control)

func add_abdpush_button():
	control.text = "[ Install Apk ]"
	var custom_font_color = Color(0.796, 0.784, 0.980, 1)
	control.add_theme_color_override("font_color", custom_font_color)
	
	control.connect("pressed", _on_abdpush_button_pressed)
	EditorInterface.get_file_system_dock().add_child(control)

func _on_abdpush_button_pressed():
	var command = "pub_adb.bat"
	OS.shell_open(command)
