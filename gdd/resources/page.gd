extends Resource
class_name PageResource

@export var questions: Array[QuestionResource] = []

func get_question_count() -> int:
	return questions.size()

func get_question(index: int) -> QuestionResource:
	if index >= 0 and index < questions.size():
		return questions[index]
	return null
