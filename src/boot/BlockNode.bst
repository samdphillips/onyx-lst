COMMENT --- Start BlockNode Methods ---
METHOD BlockNode
statements: s temporaryLocation: t
	statements <- s.
	temporaryLocation <- t
!
METHOD BlockNode
compileInLine: encoder block: inBlock
	statements reverseDo:
		[ :stmt | stmt compile: encoder block: inBlock.
			encoder genHigh: 15 low: 5 " pop top " ].
	encoder backUp
!
METHOD BlockNode
isBlock
	^ true
!
METHOD BlockNode
compile: encoder block: inBlock | patchLocation |
	super compile: encoder.
	encoder genHigh: 12 low: temporaryLocation.
	patchLocation <- encoder genVal: 0.
	self compileInLine: encoder block: true.
	encoder genHigh: 15 low: 2. " return top of stack "
	encoder patch: patchLocation
!
