COMMENT --- Start SmallInt Methods ---
METHOD MetaSmallInt
atRandom
	" Set up seed one time.  TBD: init from something external;
	  getpid() or time() "
	seed isNil ifTrue: [ seed <- 17 ].

	" Rotate the random number generator. "
	seed <- ((seed * 1103515245 + 12345) truncSmallInt)
		bitAnd: 268435455.
	^ seed
!
METHOD SmallInt
asSmallInt
	^self
!
METHOD SmallInt
truncSmallInt
	^self
!
METHOD SmallInt
asInteger
	^Integer new: self
!
METHOD SmallInt
quo: arg
	<11 self arg>
	(arg isMemberOf: SmallInt) ifFalse: [^self quo: arg asSmallInt].
	(0 = arg) ifTrue: [^ self error: 'division by zero'].
	self primitiveFailed
!
METHOD SmallInt
rem: arg
	<12 self arg>
	(arg isMemberOf: SmallInt) ifFalse: [^self rem: arg asSmallInt].
	(0 = arg) ifTrue: [^ self error: 'division by zero'].
	self primitiveFailed
!
METHOD SmallInt
+ arg
	<10 self arg>
	(arg isMemberOf: SmallInt) ifFalse: [^self + arg asSmallInt].
	self primitiveFailed
!
METHOD SmallInt
* arg
	<15 self arg>
	(arg isMemberOf: SmallInt) ifFalse: [^self * arg asSmallInt].
	self primitiveFailed
!
METHOD SmallInt
- arg
	<16 self arg>
	(arg isMemberOf: SmallInt) ifFalse: [^self - arg asSmallInt].
	self primitiveFailed
!
METHOD SmallInt
< arg
	<13 self arg>
	(arg isMemberOf: SmallInt) ifFalse: [^self < arg asSmallInt].
	self primitiveFailed
!
METHOD SmallInt
= arg
	<14 self arg>
	(arg isMemberOf: SmallInt) ifFalse: [^self = arg asSmallInt].
	self primitiveFailed
!
METHOD SmallInt
hash
	^ self
!
METHOD SmallInt
bitOr: arg
	<36 self arg>.
	^ (self bitOr: arg asSmallInt)
!
METHOD SmallInt
bitAnd: arg
	<37 self arg>.
	^ (self bitAnd: arg asSmallInt)
!
METHOD SmallInt
bitShift: arg
	<39 self arg>.
	(arg isKindOf: SmallInt) ifTrue: [ self overflow ].
	^ (self bitShift: arg asSmallInt)
!
