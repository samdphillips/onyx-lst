COMMENT --- Start CascadeNode Methods ---
METHOD CascadeNode
head: h
	head <- h
!
METHOD CascadeNode
list: l
	list <- l
!
METHOD CascadeNode
compile: encoder block: inBlock
	super compile: encoder.
	head compile: encoder block: inBlock.
	list reverseDo: [ :stmt |
		encoder genHigh: 15 low: 4. " duplicate "
		stmt compile: encoder block: inBlock.
		encoder genHigh: 15 low: 5 "pop from stack " ]
!
