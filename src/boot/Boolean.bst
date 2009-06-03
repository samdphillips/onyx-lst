COMMENT --- Start Boolean Methods ---
METHOD Boolean
and: aBlock
	^ self
		ifTrue: [ aBlock value ]
		ifFalse: [ false ]
!
METHOD Boolean
or: aBlock
	^ self
		ifTrue: [ true ]
		ifFalse: [ aBlock value ]
!
METHOD Boolean
not
	^ self
		ifTrue: [ false ]
		ifFalse: [ true ]
!
COMMENT ImageBuilder needs to be more flexible with binary selectors
COMMENT METHOD Boolean
COMMENT && aBoolean
COMMENT     ^ self and: [ aBoolean ]
COMMENT !
COMMENT METHOD Boolean
COMMENT || aBoolean
COMMENT     ^ self or: [ aBoolean ]
COMMENT !
METHOD Boolean
ifFalse: falseBlock ifTrue: trueBlock
	^ self ifTrue: [ trueBlock  value ] ifFalse: [ falseBlock value ]
!
METHOD Boolean
ifTrue: aBlock
	^ self ifTrue: [ aBlock value ] ifFalse: [ nil ]
!
METHOD Boolean
ifFalse: aBlock
	^ self ifTrue: [ nil ] ifFalse: [ aBlock value ]
!
