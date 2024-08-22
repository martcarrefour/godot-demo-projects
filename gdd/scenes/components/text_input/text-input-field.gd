extends TextEdit


enum InputMode { ALL, DIGITS_ONLY }

var input_mode := InputMode.ALL

func set_input_mode(mode):
	input_mode = mode

#func _input(event):
	#if event.is_action_pressed("ui_focus_prev") and has_focus():
		#if focus_previous != null:
			#get_node(focus_previous).grab_focus()
		#get_viewport().set_input_as_handled()
#
	#if event.is_action_pressed("ui_focus_next") and has_focus():
		#if focus_next != null:
			#get_node(focus_next).grab_focus()
		#get_viewport().set_input_as_handled()


func _on_text_changed():
	var current_text = text
	var caret_position = get_caret_column()
	var filtered_text = ""
	match input_mode:
		InputMode.ALL:
			filtered_text = current_text
		InputMode.DIGITS_ONLY:
			for character in current_text:
				if character.is_valid_float():
					filtered_text += character

	if current_text != filtered_text:
		text = filtered_text
	
		set_caret_column(caret_position)
