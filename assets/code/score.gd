extends Label

var score = 0
var time_passed = 0.0
var started = false
var frozen := false

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
		text = "Score: %d" % score
