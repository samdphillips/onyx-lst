COMMENT --- Start ArgumentNode Methods ---
METHOD ArgumentNode
position: p
	position <- p
!
METHOD ArgumentNode
isSuper
	^ position = 0
!
METHOD ArgumentNode
compile: encoder block: inBlock
	super compile: encoder.
	position = 0
		ifTrue: [ encoder genHigh: 2 low: 0 ]
		ifFalse: [ encoder genHigh: 2 low: position - 1 ]
!
