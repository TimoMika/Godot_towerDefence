#declare every wave with a list of dictionarys.
#every dictionary represents one group of enemies
#default values are:
#	amount = 1 (the amount of enemies which will spawn in this group)
#	type = 1 (the type of enemie in this group)
#	pause = 1 (the time in seconds to pause after the wave is done)
#	tick = 1 (the time between each enemie in *this* group)

var waves=[
[{#wave1
	amount = 5,
	type = 1,
	tick = 3,
	pause = 20
}],
[{#wave2
	amount = 2,
	type = 2,
	tick = 1,
	pause = 5
},{
	amount = 2,
	type = 2,
	tick = 1,
	pause = 4
},{
	amount = 2,
	type = 2,
	tick = 0.5,
	pause = 4
},{
	amount = 2,
	type = 2,
	tick = 0.5,
	pause = 40
}],
[{#wave2
	amount = 20,
	type = 2,
	tick = 0.1,
	pause = 5
},{
	amount = 20,
	type = 1,
	tick = 1,
	pause = 10
},{
	amount = 40,
	type = 2,
	tick = 1,
	pause = 10
},{
	amount = 100,
	type = 2,
	tick = 0.3,
	pause = 4
}]
]