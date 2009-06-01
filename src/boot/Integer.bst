COMMENT --- Start Integer Methods ---
METHOD MetaInteger
new: low
	<32 low>
	low <- low asSmallInt.
	<32 low>
	self primitiveFailed
!
METHOD Integer
asInteger
	^self
!
METHOD Integer
asSmallInt
	<33 self>.
	self overflow
!
METHOD Integer
truncSmallInt
	<40 self>.
	self primitiveFailed
!
METHOD Integer
hash
	<33 self>.
	^ (self rem: 65536) asSmallInt
!
METHOD Integer
quo: arg
	<25 self arg>
	(arg isMemberOf: Integer) ifFalse: [^self quo: arg asInteger].
	(0 = arg) ifTrue: [^ self error: 'division by zero'].
	self primitiveFailed
!
METHOD Integer
rem: arg
	<26 self arg>
	(arg isMemberOf: Integer) ifFalse: [^self rem: arg asInteger].
	(0 = arg) ifTrue: [^ self error: 'division by zero'].
	self primitiveFailed
!
METHOD Integer
+ arg
	<27 self arg>
	(arg isMemberOf: Integer) ifFalse: [^self + arg asInteger].
	self primitiveFailed
!
METHOD Integer
* arg
	<28 self arg>
	(arg isMemberOf: Integer) ifFalse: [^self * arg asInteger].
	self primitiveFailed
!
METHOD Integer
- arg
	<29 self arg>
	(arg isMemberOf: Integer) ifFalse: [^self - arg asInteger].
	self primitiveFailed
!
METHOD Integer
< arg
	<30 self arg>
	(arg isMemberOf: Integer) ifFalse: [^self < arg asInteger].
	self primitiveFailed
!
METHOD Integer
= arg
	<31 self arg>
	(arg isMemberOf: Integer) ifFalse: [^self = arg asInteger].
	self primitiveFailed
!
