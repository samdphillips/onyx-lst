COMMENT --- Start False Methods ---
METHOD MetaFalse
new
	" there is only one false value "
	^ false
!
METHOD False
not
	^ true
!
METHOD False
printString
	^ 'false'
!
METHOD False
ifTrue: trueBlock ifFalse: falseBlock
	^ falseBlock value
!
METHOD False
or: aBlock
	^ aBlock value
!
METHOD False
and: aBlock
	^ false
!
