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

var Black_cummin = {
	"name"	:	"blackcummin",
	"parts" :	{
		"bloom" : load("res://scenes/herbarium/herbs/black_cummin/bloom.tscn"),
		"stem": load("res://scenes/herbarium/herbs/black_cummin/stem.tscn"),
		"leaves" : load("res://scenes/herbarium/herbs/black_cummin/leave.tscn")
	},
	"set": load("res://scenes/herbarium/herbs/black_cummin/black_cummin.tscn"),
	"info"	:	TEXT.black_cumin
}

var Dog_rose = {
	"name"	:	"dogrose",
	"parts" :	{
		"bloom" : load("res://scenes/herbarium/herbs/dog_rose/bloom.tscn"),
		"stem": load("res://scenes/herbarium/herbs/dog_rose/stem.tscn"),
		"leaves" : load("res://scenes/herbarium/herbs/dog_rose/leave.tscn")
	},
	"set": load("res://scenes/herbarium/herbs/dog_rose/dog_rose.tscn"),
	"info"	:	TEXT.dog_rose
}

var HerbList = [Rosemary, Black_cummin, Dog_rose]
