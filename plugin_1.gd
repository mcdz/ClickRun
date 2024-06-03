@tool
extends EditorPlugin

var control = Button.new()
var cont_expl = Button.new()
var cont_git = Button.new()

func _enter_tree():
	add_buttons()

func _exit_tree():
	control.queue_free()
	cont_expl.queue_free()
	cont_git.queue_free()
	
func add_buttons():
	var custom_font_color = Color(0.796, 0.784, 0.980, 1)
	var custom_font_color_db = Color(0.79191237688065, 0.42199629545212, 0.61062890291214)

	control.text = "  📱  "
	control.add_theme_color_override("font_color", custom_font_color)
	control.connect("pressed", _on_abdpush_button_pressed)
	
	cont_expl.text = " 📁 "
	cont_expl.add_theme_color_override("font_color", custom_font_color_db)
	cont_expl.connect("pressed", _on_explr_button_pressed)

	cont_git.text = " 💫 "
	cont_git.add_theme_color_override("font_color", custom_font_color_db)
	cont_git.connect("pressed", _on_git_button_pressed)

	#EditorInterface.get_file_system_dock().add_child(control)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, control)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, cont_expl)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, cont_git)

func _on_abdpush_button_pressed():
	var command = "pub_adb.bat"
	OS.shell_open(command)

func _on_explr_button_pressed():
	var command = "db_explore.bat"
	OS.shell_open(command)

func _on_git_button_pressed():
	var command = "pushgit.bat"
	OS.shell_open(command)
