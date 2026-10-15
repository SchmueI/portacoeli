extends Node

func play_menu_music() -> void:
	$AmbientMusicPlayer.stop()

	if not $MusicPlayer.playing:
		$MusicPlayer.play()


func play_exploration_music() -> void:
	$MusicPlayer.stop()

	if not $AmbientMusicPlayer.playing:
		$AmbientMusicPlayer.play()


func stop_music() -> void:
	$MusicPlayer.stop()
	$AmbientMusicPlayer.stop()
