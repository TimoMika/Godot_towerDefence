extends Node

var lvl = 1
var gameType = 1 #Kampain = 1, Survival = 2
var mapNum = 1

func setLvl(lv):
	lvl = lv
	
func getLvl():
	return lvl

func setMapNum(map):
	mapNum = map

func getMapNum():
	return mapNum

func setGameType(type):
	gameType = type

func getGameType():
	return gameType
 