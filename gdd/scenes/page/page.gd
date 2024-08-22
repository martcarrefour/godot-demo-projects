extends Control
class_name Page

const LIST = preload("res://scenes/list/List.tscn")

@onready var list_container: Control = $MarginContainer/Container/ListContainer
@onready var previous_page: Button = %PreviousPage
@onready var next_page: Button = %NextPage

var current_page_index := 0
var gdd: GDDResource


func _ready() -> void:
	gdd = Globals.gdd
	if gdd and gdd.get_page_count() > 0:
		load_page(current_page_index)
	else:
		print("No pages found in gdd or gdd is null")


func _on_next_page_button_pressed() -> void:
	if current_page_index < gdd.get_page_count() - 1:
		current_page_index += 1
		load_page(current_page_index)


func _on_previous_page_pressed() -> void:
	if current_page_index > 0:
		current_page_index -= 1
		load_page(current_page_index)


func load_page(index: int) -> void:
	clear_page_children(list_container)
	var list = LIST.instantiate()
	list.page = gdd.get_page(index)
	list.name = "List"
	list_container.add_child(list)
	update_buttons()


func clear_page_children(node: Node):
	for child in node.get_children():
		if child.name == "List":
			node.remove_child(child)
			child.queue_free()


func update_buttons() -> void:
	next_page.disabled = current_page_index >= gdd.get_page_count() - 1
	previous_page.disabled = current_page_index <= 0


func _on_exit_button_pressed() -> void:
	clear_page_children(list_container)

	get_tree().change_scene_to_file("res://scenes/Game.tscn")
