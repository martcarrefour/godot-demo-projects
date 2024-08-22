extends Resource
class_name GDDResource

@export var pages: Array[PageResource] = []

func get_page_count() -> int:
	return pages.size()

func get_page(index: int) -> PageResource:
	if index >= 0 and index < pages.size():
		return pages[index]
	return null
