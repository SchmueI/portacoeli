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
	var music = get_music_by_id(id)
	
	if music == null:
		stop_music()
		return
	
	if not music.is_playing():
		stop_music()
		music.play()
	

func stop_music(id:String = "") -> void:
	if id == "":
		for entity in musicPlayer:
			musicPlayer[entity].stop()
	else:
		var music = get_music_by_id(id)
		if music == null:return
		else: music.stop()
