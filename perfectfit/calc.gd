extends Control
@onready var weight_input: LineEdit = %WeightInput
@onready var height_input: LineEdit = %HeightInput
@onready var age_input: LineEdit = %AgeInput
@onready var gender_input: OptionButton = %GenderInput
@onready var physical_activity_level_input: OptionButton = %PhysicalActivityLevelInput
@onready var target_weight_input: LineEdit = %TargetWeightInput
@onready var duration_input: LineEdit = %DurationInput
@onready var result_text: Label = %ResultText
@onready var warning_text: Label = %WarningText
const MIN_CALORIES_MALE = 1500
const MIN_CALORIES_FEMALE = 1300


func _ready():
	weight_input.text_changed.connect(_on_input_changed)
	height_input.text_changed.connect(_on_input_changed)
	age_input.text_changed.connect(_on_input_changed)
	gender_input.item_selected.connect(_on_input_changed)
	physical_activity_level_input.item_selected.connect(_on_input_changed)
	target_weight_input.text_changed.connect(_on_input_changed)
	duration_input.text_changed.connect(_on_input_changed)

	_calculate()

	_calculate()


func _on_input_changed(_arg = null):
	_calculate()


func _calculate():
	if not _validate_inputs():
		result_text.text = "Please fill in all fields."
		warning_text.text = ""
		return

	var weight = weight_input.text.to_float()
	var height = height_input.text.to_float()
	var age = age_input.text.to_int()
	var target_weight = target_weight_input.text.to_float()
	var duration = duration_input.text.to_int()

	if not _validate_values(weight, height, age, target_weight, duration):
		result_text.text = "All values must be positive."
		warning_text.text = ""
		return

	var final_calories = _calculate_final_calories(weight, height, age, gender_input.selected, physical_activity_level_input.selected, target_weight, duration)

	# Проверка на минимальную калорийность
	if (gender_input.selected == 0 and final_calories < MIN_CALORIES_MALE) or (gender_input.selected == 1 and final_calories < MIN_CALORIES_FEMALE):
		result_text.text = "Warning: Caloric intake is too low. " % (MIN_CALORIES_MALE if gender_input.selected == 0 else MIN_CALORIES_FEMALE)
		warning_text.text = ""
		return

	result_text.text = "Calories per day: %d" % final_calories

	_update_warning(weight, target_weight, duration)


func _validate_inputs() -> bool:
	return weight_input.text != "" and height_input.text != "" and age_input.text != "" and target_weight_input.text != "" and duration_input.text != ""


func _validate_values(weight: float, height: float, age: int, target_weight: float, duration: int) -> bool:
	return weight > 0 and height > 0 and age > 0 and target_weight > 0 and duration > 0


func _calculate_bmr(weight: float, height: float, age: int, gender: int) -> float:
	if gender == 0:  # Мужской
		return (10 * weight) + (6.25 * height) - (5 * age) + 5
	else:  # Женский
		return (10 * weight) + (6.25 * height) - (5 * age) - 161


func _calculate_activity_coefficient(activity_level: int) -> float:
	var activity_levels = [1.2, 1.375, 1.55, 1.725]
	return activity_levels[activity_level]


func _calculate_final_calories(weight: float, height: float, age: int, gender: int, activity_level: int, target_weight: float, duration: int) -> float:
	var bmr = _calculate_bmr(weight, height, age, gender)
	var activity_coefficient = _calculate_activity_coefficient(activity_level)
	var daily_calories = bmr * activity_coefficient

	var weight_difference = weight - target_weight
	var total_calories_needed = weight_difference * 7700
	var daily_caloric_adjustment = total_calories_needed / duration

	return daily_calories - daily_caloric_adjustment


func _update_warning(weight: float, target_weight: float, duration: int):
	var weight_loss_percentage_per_week = ((weight - target_weight) / weight) / duration * 7 * 100  # Процент потери веса в неделю

	if weight_loss_percentage_per_week <= 0.75:
		warning_text.text = "Healthy and gradual weight change."
		%WarningColor.color = Color(0, 1, 0)  # Зеленый цвет
	elif weight_loss_percentage_per_week > 0.75 and weight_loss_percentage_per_week <= 1.25:
		warning_text.text = "Caution: Noticeable weight change"
		%WarningColor.color = Color(1, 1, 0)  # Желтый цвет
	else:
		warning_text.text = "Warning: Significant weight change"
		%WarningColor.color = Color(1, 0, 0)  # Красный цвет
