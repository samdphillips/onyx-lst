COMMENT --- Start InstNode Methods ---
METHOD InstNode
position: p name: aSymbol
    self position: p.
    self name: aSymbol
!
METHOD InstNode
position: p
	position <- p
!
METHOD InstNode
name: aSymbol
    name <- aSymbol
!
METHOD InstNode
compile: encoder block: inBlock
	super compile: encoder.
	encoder genHigh: 1 low: position - 1
!
METHOD InstNode
assign: encoder
	encoder genHigh: 6 low: position - 1
!
METHOD InstNode
assignable
	^ true
!
