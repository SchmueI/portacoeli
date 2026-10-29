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

var Sage = {
	"name"	:	"sage",
	"parts" :	{
		"bloom" : load("res://scenes/herbarium/herbs/sage/bloom.tscn"),
		"corpus": load("res://scenes/herbarium/herbs/sage/corpus.tscn"),
		"roots" : load("res://scenes/herbarium/herbs/sage/roots.tscn")
	},
	"info"	:	TEXT.sage
}

var Thyme = {
	"name"	:	"thyme",
	"parts" :	{
		"bloom" : load("res://scenes/herbarium/herbs/thyme/bloom.tscn"),
		"corpus": load("res://scenes/herbarium/herbs/thyme/corpus.tscn"),
		"roots" : load("res://scenes/herbarium/herbs/thyme/roots.tscn")
	},
	"info"	:	TEXT.thyme
}

var HerbList = [Rosemary, Sage, Thyme]
