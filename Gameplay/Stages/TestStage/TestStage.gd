extends Node2D

var music = preload("res://Assets/sounds/4-19.mp3")

func _ready():
	$AudioStreamPlayer2D.stream = music
	$AudioStreamPlayer2D.play()