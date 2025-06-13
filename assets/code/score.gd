extends Label

var score = 0
var time_passed = 0.0
var started = false  # flag to track if delay has passed

func _process(delta):
	time_passed += delta

	if not started:
		if time_passed >= 2.0:
			started = true
			time_passed = 0.0  # reset for scoring
	else:
		if time_passed >= 1.25:
			score += 1
			time_passed = 0.0
			text = "Score: %d" % score
