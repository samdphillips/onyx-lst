COMMENT --- Start True Methods ---
METHOD MetaTrue
new
	" there is only one true value "
	^ true
!
METHOD True
not
	^ false
!
METHOD True
printString
	^ 'true'
!
METHOD True
ifTrue: trueBlock ifFalse: falseBlock
	^ trueBlock value
!
METHOD True
or: aBlock
	^ true
!
METHOD True
and: aBlock
	^ aBlock value
!
