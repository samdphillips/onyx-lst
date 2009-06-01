COMMENT --- Start Number Methods ---
METHOD MetaNumber
new
	" can't create this way, return zero "
	^ 0
!
METHOD Number
negative
	^self < 0
!
METHOD Number
absolute
	(self negative) ifTrue: [ ^ self negated ]
!
METHOD Number
negated
	^0-self
!
METHOD Number
factorial
	self <= 1 ifTrue: [ ^ 1 ]
	ifFalse: [ ^ (self - 1) factorial * self ]
!
METHOD Number
asDigit
	(self < 10) ifTrue:
		[ ^(Char new: (self asSmallInt + 48)) asString ].
	^(Char new: (self asSmallInt + 55)) asString
!
METHOD Number
printWidth: width base: base | res n dig wasNeg wide |
	res <- ''.
	(self negative) ifTrue: [
		wasNeg <- true.
		wide <- width-1.
		n <- self negated
	] ifFalse: [
		wasNeg <- false.
		wide <- width.
		n <- self
	].
	[true] whileTrue: [
		res <- ((n rem: base) asDigit) + res.
		n <- n quo: base.
		(n = 0) ifTrue: [
			((res size)+1) to: wide do: [:ignore|
				res <- '0' + res
			].
			wasNeg ifTrue: [ res <- '-' + res ].
			^res
		]
	]
!
METHOD Number
printWidth: width
	^self printWidth: width base: 10
!
METHOD Number
printString
	^self printWidth: 1 base: 10
!
METHOD Number
to: limit
	^ Interval from: self to: limit step: 1
!
METHOD Number
to: limit by: step
	^ Interval from: self to: limit step: step
!
METHOD Number
to: limit do: aBlock  | i |
		" optimize arithmetic loops "
	i <- self.
	[ i <= limit ] whileTrue: [ aBlock value: i. i <- i + 1 ]
!
METHOD Number
to: limit by: step do: aBlock  | i |
	i <- self.
	[ i <= limit ] whileTrue: [ aBlock value: i. i <- i + step ]
!
METHOD Number
overflow
	self error: 'Numeric overflow'
!
METHOD Number
bitAnd: arg
	^ (self asSmallInt bitAnd: arg)
!
METHOD Number
bitOr: arg
	^ (self asSmallInt bitOr: arg)
!
METHOD Number
bitShift: arg
	^ (self asSmallInt bitShift: arg)
!
METHOD Number
atRandom
	" Return random number from 1 to self "
	(self < 2) ifTrue: [ ^ self ].
	^ ((1 to: self) atRandom)
!
METHOD Number
asChar
	^ Char new: (self asSmallInt)
!
