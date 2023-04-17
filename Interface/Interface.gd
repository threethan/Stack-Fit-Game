extends Control

export(NodePath) var game_manager_path
onready var game_manager:GameManager = get_node(game_manager_path)

onready var score_counter = get_node("Score")
onready var next_progress = get_node("Bottom/NextProgress")
onready var next_numeric  = get_node("Bottom/NextNumber")
onready var high_score_label = get_node("Score/CenterContainer/HBoxContainer/Highscore")

var score_count = 0.0
var score_speed = 8.0
var is_gameplay = true
var save_queued = false

var sensitivity := Vector2(0.0, 0.0)
var high_score = 0

func _ready():
	#set_dark_theme(true)
	load_data()
	
	#get_node("AnimationPlayer").play("StartGame")
	#var messages = ["Well played!", "Get perfect fits for bonus points", "Hope you have a great day!"]

var faded = false
func _process(delta):
	
	if score_count < game_manager.score:
		score_count += min(1,delta*score_speed)
	if game_manager.score >= 5 and not faded: # Fade tutorial when n points are got
		AnalyticsManager.increment_currency("GamesStarted", 1)
		get_node("AnimationPlayer").play("FadeElements")
		faded = true
	score_counter.text = str(floor(score_count))
	next_progress.value = game_manager.next_timer
	next_progress.max_value = game_manager.next_thresh
	next_numeric.text = "%ds" % (game_manager.next_thresh-game_manager.next_timer)
	high_score_label.text = str(high_score)

	if game_manager.collapsed and is_gameplay:
		log_score()
		get_node("AnimationPlayer").play("EndGame")
		is_gameplay = false
	
	if not is_gameplay and save_queued:
		save_data()
		
	if game_manager.score > high_score:
		high_score = game_manager.score
		save_queued = true
		if not is_gameplay:
			log_bonus()

func _on_RestartButton_pressed():
	get_tree().paused = false
	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func save_data():
	save_queued = false
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var data = {"high_score": high_score, "dark_theme":game_manager.dark_theme, "sensitivity":var2str(sensitivity), "battery_saver": var2str(game_manager.battery_saver)}
	save_game.store_line(to_json(data))
	save_game.close()
	
func load_data():
	save_queued = false
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	save_game.open("user://savegame.save", File.READ)
	var data = parse_json(save_game.get_line())
	high_score = data.high_score
	if "dark_theme" in data:
		set_dark_theme(data.dark_theme)
	if "sensitivity" in data:
		sensitivity = str2var(data.sensitivity)
		get_node("PauseBg/SensSliderH").value = sensitivity.x
		get_node("PauseBg/SensSliderV").value = sensitivity.y
	if "battery_saver" in data:
		game_manager.set_battery_saver(str2var(data.battery_saver))
	else:
		game_manager.set_battery_saver(false)

func set_dark_theme(dark):
	theme = preload("res://Asset/main_theme_dark.tres") if dark else preload("res://Asset/main_theme.tres")
	game_manager.dark_theme=dark
	#game_manager.play_sound("snap"+str(randi()%3)) #Sound broken on pause, not worth fixing


func _on_PauseButton_pressed():
	get_tree().paused = true
	get_node("PauseBg").visible = true
	game_manager.play_sound("snap"+str(randi()%3))


func _on_ResumeButton_button_down():
	get_tree().paused = false
	get_node("PauseBg").visible = false
	game_manager.play_sound("snap"+str(randi()%3))


func _on_NextWord_pressed():
	game_manager.next_timer = game_manager.next_thresh


func _on_SensSliderH_value_changed(value):
	sensitivity.x = value
	game_manager.sensitivity = sensitivity
	save_data()
	log_set()


func _on_SensSliderV_value_changed(value):
	sensitivity.y = value
	game_manager.sensitivity = sensitivity
	save_data()
	log_set()

func _on_EndGameOptions_pressed():
	get_node("PauseBg/RestartButton").visible = false
	get_node("PauseBg/ResumeButton").text = "Go Back"
	
	_on_PauseButton_pressed()

func log_score():
	AnalyticsManager.event_progression("Complete", game_manager.score)
	#AnalyticsManager.event_progression("Score", [game_manager.score])
	#if game_manager.score >= high_score:
	#	AnalyticsManager.event_progression("New High Score", [high_score])
	AnalyticsManager.increment_currency("LifetimeScore", score_count)
	AnalyticsManager.increment_currency("GamesFinished", 1)
func log_bonus():
	pass # Causes instability (Maybe?) :(
	#if Engine.has_singleton("AnalyticsManager"):
	#	AnalyticsManager.increment_currency("lifetime_bonus", 1)
	#	AnalyticsManager.event_progression("Bonus Point", [game_manager.score])
func log_set():
	pass
	#if Engine.has_singleton("AnalyticsManager"):
	#	AnalyticsManager.event_progression("Changed Sensitivity", [sensitivity.x, sensitivity.y])	

# Catch pause
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		# comes to foreground
		pass
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		# goes to background
		_on_PauseButton_pressed()
