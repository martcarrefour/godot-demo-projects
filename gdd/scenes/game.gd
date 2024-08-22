extends Control

@onready var saves_container: VBoxContainer = $VBoxContainer/SavesContainer
const SAVE_BUTTON = preload("res://scenes/components/save_button/save_button.tscn")


func _ready() -> void:
	render_save_buttons()


func _on_start_pressed() -> void:
	new_file()
	start()


func render_save_buttons() -> void:
	for child in saves_container.get_children():
		child.queue_free()

	var saved_files = Globals.get_saved_files()
	if not saved_files:
		return

	for path in saved_files:
		var button = SAVE_BUTTON.instantiate()
		saves_container.add_child(button)

		button.save_button.text = path
		button.save_button.connect("pressed", Callable(self, "_on_save_button_pressed").bind(path))
		button.delete_button.connect("pressed", Callable(self, "_on_delete_button_pressed").bind(path))


func _on_save_button_pressed(path: String) -> void:
	load_selected_save(path)


func _on_delete_button_pressed(path: String) -> void:
	Globals.delete_save_file(path)
	render_save_buttons()


func load_selected_save(path: String) -> void:
	var file: GDDResource = Globals.get_save_file(path)

	if file:
		Globals.load_game(file)
	else:
		print("Failed to load save file: ", path)

	start()


func start() -> void:

	get_tree().change_scene_to_file("res://scenes/page/Page.tscn")


func new_file() -> void:
	Globals.init_save()
