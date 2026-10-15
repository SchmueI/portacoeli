extends Node

@onready var music = $MusicPlayer
@onready var ambientMusic = $AmbientMusicPlayer


func play_menu_music() -> void:
	ambientMusic.stop()

	if not music.playing:
		music.play()
		


func play_exploration_music() -> void:
	music.stop()

	if not ambientMusic.playing:
		ambientMusic.play()


func stop_music() -> void:
	music.stop()
	ambientMusic.stop()
