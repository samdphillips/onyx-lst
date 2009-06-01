COMMENT --- Start ReturnNode Methods ---
METHOD ReturnNode
expression: e
	expression <- e
!
METHOD ReturnNode
compile: encoder block: inBlock
	super compile: encoder.
	expression compile: encoder block: inBlock.
	inBlock
		ifTrue: [ encoder genHigh: 15 low: 3 " block return " ]
		ifFalse: [ encoder genHigh: 15 low: 2 " stack return " ]
!
