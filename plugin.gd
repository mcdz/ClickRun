@tool
extends EditorPlugin

var control = Button.new()
var cont_expl = Button.new()
var cont_git = Button.new()
#var cont_XPT = Button.new()

var submenu_item: PopupMenu
const TITLE_TOOL_MENU_SWITCH := "ADB Push"
const TITLE := "ClickRun"

var wait_window: Window
var label: Label

func _enter_tree():
		## ------- CUSTOMIZE SHORTCUT ------- ##
	var shortcut_switch := InputEventKey.new() 	## ADB (alt + w)
	shortcut_switch.alt_pressed = true
	#shortcut_switch.ctrl_pressed = true
	shortcut_switch.keycode = KEY_W

	var shortcut_show := InputEventKey.new()	## DB_EXPLORE (ctrl + e)
	shortcut_show.ctrl_pressed = true
	shortcut_show.keycode = KEY_E

	var shortcut_gitpush := InputEventKey.new()	## GIT PUSH (alt + e)
	shortcut_gitpush.alt_pressed = true
	shortcut_gitpush.keycode = KEY_E

	var shortcut_build := InputEventKey.new()	## BUILD+ (alt + b)
	shortcut_build.alt_pressed = true
	shortcut_build.keycode = KEY_B
	## ------- CUSTOMIZE SHORTCUT ------- ##
	
	# add switch / toggle to control FileSystem docking position
	submenu_item = PopupMenu.new()
	submenu_item.add_item(
		TITLE_TOOL_MENU_SWITCH,
		0,
		shortcut_switch.get_keycode_with_modifiers()
	)
	submenu_item.add_item(
		"DB Explore",
		1,
		shortcut_show.get_keycode_with_modifiers()
	)
	submenu_item.add_item(
		"Git Push",
		2,
		shortcut_gitpush.get_keycode_with_modifiers()
	)
	submenu_item.add_item(
		"Build Run",
		3,
		shortcut_build.get_keycode_with_modifiers()
	)
	submenu_item.index_pressed.connect(abdpush_func)

	make_output_window()
	add_buttons()
	add_tool_submenu_item(TITLE, submenu_item)

func make_output_window():
	  # Create wait window
	wait_window = Window.new()
	wait_window.title = "Please Wait"
	wait_window.size = Vector2(300, 100)
	wait_window.set_position(DisplayServer.window_get_size() / 2 - wait_window.size / 2)  # Center the window

	label = Label.new()
	label.text = "Exporting, Installing & Running..."
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	wait_window.add_child(label)
	wait_window.hide()
	add_child(wait_window)  # ✅ Add to tree first
	call_deferred("hide_wait_window")

func _exit_tree():
	control.queue_free()
	cont_expl.queue_free()
	cont_git.queue_free()
	#cont_XPT.queue_free()
	wait_window.queue_free()
	remove_tool_menu_item(TITLE)

func add_buttons():
	var custom_font_color = Color(0.796, 0.784, 0.980, 1)
	var custom_font_color_db = Color(0.79191237688065, 0.42199629545212, 0.61062890291214)

	control.text = "  📱  "
	control.add_theme_color_override("font_color", custom_font_color)
	control.tooltip_text = "Alt + W (ADB) \nCtrl + E (Open Folder) \nAlt + E (Git Push)" # Tooltip for hover
	control.connect("pressed", _on_abdpush_button_pressed)
	
	cont_expl.text = " 📁 "
	cont_expl.add_theme_color_override("font_color", custom_font_color_db)
	cont_expl.tooltip_text = "Ctrl + E (Open Folder)" # Tooltip for hover
	cont_expl.connect("pressed", _on_explr_button_pressed)

	cont_git.text = " 💫 "
	cont_git.add_theme_color_override("font_color", custom_font_color_db)
	cont_git.tooltip_text = "Alt + E (Git Push)" # Tooltip for hover
	cont_git.connect("pressed", _on_git_button_pressed)

	#cont_XPT.text = " ♊ "
	#cont_XPT.add_theme_color_override("font_color", custom_font_color_db)
	#cont_XPT.tooltip_text = "Alt + B (APK BLD)" # Tooltip for hover
	#cont_XPT.connect("pressed", _on_export_pressed)

	#EditorInterface.get_file_system_dock().add_child(control)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, control)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, cont_expl)
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, cont_git)
	#add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, cont_XPT)

#func abdpush_func(value: int = OK) -> void:
	#var command = "pub_adb.bat"
	#if value != OK: command = "db_explore.bat"
	#if value != OK: command = "db_explore.bat"
	#OS.shell_open(command)

func abdpush_func(value: int = 0) -> void:
	var command = "pub_adb.bat"		## ALT + W
	
	if value == 0: 
		command = "pub_adb.bat"
	if value == 1: 
		command = "db_explore.bat" ## CTRL + E
	if value == 2: 
		command = "pushgit.bat" ## ALT + E
	if value == 3: 
		_on_export_pressed(); ## ALT + B

	if value<3:
		OS.shell_open(command)

func _on_abdpush_button_pressed():
	var command = "pub_adb.bat"
	OS.shell_open(command)

func _on_abd_auto():var command = "pub_adb_auto.bat";OS.shell_open(command)

func _on_explr_button_pressed():
	var command = "db_explore.bat"
	OS.shell_open(command)

func _on_git_button_pressed():
	var command = "pushgit.bat"
	OS.shell_open(command)
"""
## WORKING 2
func _on_export_pressed():
	print("Saving all scenes before export...")
	get_editor_interface().get_resource_filesystem().scan()

	print("Locating Godot executable...")
	var godot_exe = OS.get_executable_path()
	print("Godot path: ", godot_exe)

	var project_path = ProjectSettings.globalize_path("res://")
	var export_path = ProjectSettings.globalize_path("res://Penguin.apk")

	print("Project Path: ", project_path)
	print("Exporting project to: ", export_path)

	var export_command = [
		"--headless",
		"--path", project_path,
		"--export-release", "Android", export_path
	]

	print("Running export in the background...")

	var process_id = OS.create_process(godot_exe, export_command)
	if process_id > 0:
		print("ℹ Export started in background. Process ID: ", process_id)
	else:
		print("❌ Failed to start export process!")
"""


## WORKING ONE
func show_wait_window():	wait_window.popup_centered()
func hide_wait_window():	wait_window.hide()

func _on_export_pressed():
	wait_window.call_deferred("popup_centered")
	await get_tree().process_frame
	wait_window.set_visible(true)  # Show wait window
	await get_tree().process_frame
	#get_editor_interface().set_output_panel_visible(true)

	print("Saving all scenes before export...")
	get_editor_interface().get_resource_filesystem().scan()

	print("Locating Godot executable...")
	var godot_exe = OS.get_executable_path()
	print("Godot path: ", godot_exe)

	var project_path = ProjectSettings.globalize_path("res://")
	var export_path = ProjectSettings.globalize_path("res://FF21.apk")

	print("Project Path: ", project_path)
	print("Exporting project to: ", export_path)

	var export_command = [
		"--headless",
		"--path", project_path,
		"--export-debug", "Android", export_path
	]
	
	var output = []
	var exit_code = OS.execute(godot_exe, export_command, output, true, true)

	print("Output: ", output)
	call_deferred("hide_wait_window")

	if exit_code == 0:
		print("✅ Export successful!")
		print("🔄 Pushing APK to device via ADB...")
		_on_abd_auto()
	else:
		print("❌ Export failed with code:", exit_code)
