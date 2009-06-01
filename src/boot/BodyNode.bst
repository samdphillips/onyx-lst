COMMENT --- Start BodyNode Methods ---
METHOD BodyNode
statements: s
	statements <- s
!
METHOD BodyNode
compile: encoder block: inBlock
	super compile: encoder.
	statements reverseDo:
		[ :stmt | stmt compile: encoder block: inBlock.
			encoder genHigh: 15 low: 5 " pop "].
	encoder genHigh: 15 low: 1 " return self "
!
