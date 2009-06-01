COMMENT --- Start AssignNode Methods ---
METHOD AssignNode
target: t expression: e
	target <- t.
	expression <- e
!
METHOD AssignNode
compile: encoder block: inBlock
	super compile: encoder.
	expression compile: encoder block: inBlock.
	target assign: encoder
!
