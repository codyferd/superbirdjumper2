extends Label

var score = 0
var time_passed = 0.0
var started = false
var frozen := false
var high_score := 0
const SAVE_PATH = "user://high_score.save"

func _ready():
	load_high_score()
	text = "High Score: %d" % high_score

func _process(delta):
	if frozen:
		return

	time_passed += delta

	if not started and time_passed >= 0.66:
		started = true
		time_passed = 0.0
	elif started and time_passed >= 1:
		score += 1
		time_passed = 0.0
		if score > high_score:
			high_score = score
			save_high_score()
		text = "High Score: %d" % high_score

func save_high_score():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_32(high_score)

func load_high_score():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			high_score = file.get_32()
