#declare every wave with a list of dictionarys.
#every dictionary represents one group of enemies
#default values are:
#	amount = 1 (the amount of enemies which will spawn in this group)
#	type = 1 (the type of enemie in this group)
#	pause = 1 (the time in seconds to pause after the wave is done)
#	tick = 1 (the time between each enemie in *this* group)

var waves=[
[{#wave1
	amount = 3,
	type = 1,
	pause = 1,
	tick = 1
}],
[{#wave2
	amount = 2,
	type = 1,
	pause = 10,
	tick = 0.2
},{
	amount = 10,
	type = 1,
	pause = 1,
	tick = 1
}]
]