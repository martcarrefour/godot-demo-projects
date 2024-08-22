extends Node

const SAVE_FILE_PATH = "user://save/"
const FILE_BASE_NAME = "savegame"
const FILE_EXTENSION = ".tres"
const DEFAULT_FILE_PATH = "res://resources/presets/first_document.tres"
var gdd: GDDResource
var current_save_file: String = ""

func _ready() -> void:
	var dir = DirAccess.open(SAVE_FILE_PATH)
	if dir == null:
		DirAccess.make_dir_absolute(SAVE_FILE_PATH)
	show_save_files()

func save_game() -> void:
	var save_file: GDDResource = gdd.duplicate()  # Duplicate the current game data
	var file_index = 1
	var save_file_name = FILE_BASE_NAME + str(file_index) + FILE_EXTENSION

	while FileAccess.file_exists(SAVE_FILE_PATH + save_file_name):
		file_index += 1
		save_file_name = FILE_BASE_NAME + str(file_index) + FILE_EXTENSION

	var save_path = SAVE_FILE_PATH + save_file_name
	var error = ResourceSaver.save(save_file, save_path)
	if error == OK:
		current_save_file = save_file_name
		print("Game saved as: ", save_path)
		show_save_files()  # Update the list of saved files
	else:
		print("Failed to save game:", error)

func update_current_save() -> void:
	if current_save_file == "":
		print("No current save file to update.")
		return
	var save_file: GDDResource = gdd.duplicate()  # Duplicate the current game data
	var save_path = SAVE_FILE_PATH + current_save_file
	var error = ResourceSaver.save(save_file, save_path)
	if error == OK:
		print("Game updated in: ", save_path)
		show_save_files()
	else:
		print("Failed to update game:", error)

func load_game(saved_data: GDDResource) -> void:
	gdd = saved_data.duplicate()  # Duplicate the loaded data to avoid modifying the original save file

func init_save() -> void:
	print("Initializing new save from default file.")
	var new_file: GDDResource = preload(DEFAULT_FILE_PATH).duplicate() as GDDResource
	gdd = new_file.duplicate()  # Duplicate to ensure a fresh copy
	save_game()

func get_saved_files() -> Array:
	var dir = DirAccess.open(SAVE_FILE_PATH)
	var saved_files = []
	if dir != null:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(FILE_EXTENSION):
				saved_files.append(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	return saved_files

func get_save_file(file_name: String) -> GDDResource:
	var file_path = SAVE_FILE_PATH + file_name
	if FileAccess.file_exists(file_path):
		var saved_data = ResourceLoader.load(file_path) as GDDResource
		return saved_data
	return null

func show_save_files() -> void:
	var saved_files = get_saved_files()
	var file_list = ""
	for file in saved_files:
		file_list += file + "\n"
	print("Saved files:\n" + file_list)

func delete_save_file(path: String) -> void:
	var file_path = SAVE_FILE_PATH + path
	if FileAccess.file_exists(file_path):
		var error = DirAccess.remove_absolute(file_path)
		if error == OK:
			print("Save file deleted: ", file_path)
			show_save_files()  # Update the list of saved files after deletion
		else:
			print("Failed to delete save file: ", file_path)
	else:
		print("Save file not found: ", file_path)
