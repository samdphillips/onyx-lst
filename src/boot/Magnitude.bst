COMMENT --- Start Magnitude Methods ---
METHOD Magnitude
<= arg
	^ self < arg or: [ self = arg ]
!
METHOD Magnitude
> arg
	^ arg < self
!
METHOD Magnitude
>= arg
	^ (self > arg) or: [ self = arg ]
!
METHOD Magnitude
min: arg
	^ self < arg ifTrue: [ self ] ifFalse: [ arg ]
!
METHOD Magnitude
max: arg
	^ self < arg ifTrue: [ arg ] ifFalse: [ self ]
!
METHOD Magnitude
between: low and: high
	^ low <= self and: [ self <= high ]
!
