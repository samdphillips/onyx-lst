COMMENT --- Start TemporaryNode Methods ---
METHOD TemporaryNode
position: p name: aSymbol
    self position: p.
    self name: aSymbol
!
METHOD TemporaryNode
position: p
	position <- p
!
METHOD TemporaryNode
name: aSymbol
    name <- aSymbol
!
METHOD TemporaryNode
compile: encoder block: inBlock
	super compile: encoder.
	encoder genHigh: 3 low: position - 1
!
METHOD TemporaryNode
assignable
	^ true
!
METHOD TemporaryNode
assign: encoder
	encoder genHigh: 7 low: position - 1
!
