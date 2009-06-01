COMMENT --- Start Symbol Methods ---
METHOD MetaSymbol
intern: string
	<23 string Symbol>
!
METHOD MetaSymbol
new: fromString | sym |
	^ symbols at: fromString
		ifAbsent: [ symbols add: (self intern: fromString) ]
!
METHOD Symbol
printString
	<23 self String>
!
METHOD Symbol
asString
	^self printString
!
METHOD Symbol
hash
	^self printString hash
!
METHOD Symbol
asSymbol
	^self
!
METHOD Symbol
= aString
		" works with either symbol or string arguments "
	^ self printString = aString printString
!
METHOD Symbol
< arg
		" works with either symbol or string arguments "
	^ self printString < arg printString
!
