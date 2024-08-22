extends Resource
class_name ColorsResource

@export var colors: Array[Color] = []

var color_dict = {
	"Red": Color("#FF6F61"),
	"Yellow": Color("#FDFD96"),
	"Blue": Color("#AEC6CF"),
	"Purple": Color("#CBAACB"),
	"Green": Color("#77DD77"),
	"Pink": Color("#FFB7B2"),
	"Black": Color("#555555"),
	"White": Color("#FDFDFD"),
	"Every color": Color("#F0EAD6") # Меняет цвет при нажатии 
}


func _init():
	for color in color_dict.values():
		colors.append(color)
