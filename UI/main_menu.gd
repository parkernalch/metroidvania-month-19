extends Control

onready var root_menu = $RootMenu
onready var credits_menu = $CreditsMenu
onready var stats_menu = $StatsMenu
onready var options_menu = $OptionsMenu

var play_button
var credits_button
var stats_button
var options_button

var credits_back_button
var options_back_button
var stats_back_button

func _ready():
	play_button = get_node("%PlayButton")
	credits_button = get_node("%CreditsButton")
	stats_button = get_node("%StatsButton")
	options_button = get_node("%OptionsButton")
	
	play_button.connect("pressed", self, "go_to_game")
	credits_button.connect("pressed", self, "go_to_credits")
	stats_button.connect("pressed", self, "go_to_stats")
	options_button.connect("pressed", self, "go_to_options")
	
	credits_back_button = get_node("%CreditsBackButton")
	options_back_button = get_node("%OptionsBackButton")
	stats_back_button = get_node("%StatsBackButton")
	
	credits_back_button.connect("pressed", self, "go_back")
	options_back_button.connect("pressed", self, "go_back")
	stats_back_button.connect("pressed", self, "go_back")
	
func go_to_game():
	get_tree().change_scene_to(load("res://Gameplay/Stages/TestStage/TestStage.tscn"))
	pass
	
func go_back():
	credits_menu.visible = false
	stats_menu.visible = false
	options_menu.visible = false
	root_menu.visible = true
	
func go_to_credits():
	root_menu.visible = false
	credits_menu.visible = true
	
func go_to_stats():
	root_menu.visible = false
	stats_menu.visible = true
	
func go_to_options():
	root_menu.visible = false
	options_menu.visible = true
