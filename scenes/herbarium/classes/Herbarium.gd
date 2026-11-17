class_name Herbarium 
extends GameBase


var POPUPS = preload("res://assets/text/levels/herbarium/popups.gd").new()
var TEXT = preload("res://assets/text/levels/herbarium/lexicon.gd").new()

var Rosemary = {
	"name"	:	"rosemary",
	"parts" :	{
		"bloom" : load("res://scenes/herbarium/herbs/rosemary/bloom.tscn"),
		"stem": load("res://scenes/herbarium/herbs/rosemary/stem.tscn"),
		"leaves" : load("res://scenes/herbarium/herbs/rosemary/leave.tscn")
	},
	"set": load("res://scenes/herbarium/herbs/rosemary/rosemary.tscn"),
	"info"	:	TEXT.rosemary
}

var HerbList = [Rosemary]
