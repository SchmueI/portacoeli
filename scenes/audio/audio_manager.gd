extends Node

@onready var menuMusic = $MenuMusicPlayer
@onready var ambientMusic = $AmbientMusicPlayer

@onready var musicPlayer:Dictionary = {
	"menu":menuMusic,
	"ambient":ambientMusic
}

func get_music_by_id(id:String) -> AudioStreamPlayer:
	var output = musicPlayer.get(id, null)
	return output

func play_music(id:String) -> void:
	stop_music()
	var music = get_music_by_id(id)
	
	if music == null:
		return
		
	music.play()

func stop_music() -> void:
	for entity in musicPlayer:
		musicPlayer[entity].stop()
