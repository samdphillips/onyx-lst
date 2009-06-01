COMMENT --- Start ParserNode Methods ---
METHOD MetaParserNode
new
	self error: 'Must use at: for creation'
!
METHOD MetaParserNode
at: l | ret |
	ret <- super new.
	self in: ret at: 1 put: l.
	^ ret
!
METHOD ParserNode
isSuper
	^ false
!
METHOD ParserNode
isBlock
	^ false
!
METHOD ParserNode
assignable
	^ false
!
METHOD ParserNode
compile: encoder
	encoder lineNum: lineNum
!
