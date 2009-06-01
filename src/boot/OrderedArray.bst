COMMENT --- Start OrderedArray Methods ---
METHOD OrderedArray
add: value
	^ self insert: value at: (self location: value)
!
METHOD OrderedArray
includes: value | position |
	position <- self location: value.
	^ (position <= self size) and: [ value = (self at: position)]
!
METHOD OrderedArray
location: value | low high mid |
	low <- 1.
	high <- self size + 1.
	[ low < high ] whileTrue:
		[ mid <- (low + high) quo: 2.
		(self at: mid) < value
			ifTrue: [ low <- mid + 1 ]
			ifFalse: [ high <- mid ] ].
	^ low
!
