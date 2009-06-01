COMMENT --- Start PrimitiveNode Methods ---
METHOD PrimitiveNode
number: n arguments: a
	number <- n.
	arguments <- a.
!
METHOD PrimitiveNode
compile: encoder block: inBlock | argsize |
	argsize <- arguments size.
	super compile: encoder.
	encoder pushArgs: argsize.
	arguments reverseDo: [ :a | a compile: encoder block: inBlock ].
	encoder genHigh: 13 low: argsize.
	encoder genCode: number.
	encoder popArgs: argsize
!
