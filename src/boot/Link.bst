COMMENT --- Start Link Methods ---
METHOD MetaLink
value: v
		" return a new link with given value field "
		" and empty link field "
	^ self in: self new at: 1 put: v
!
METHOD MetaLink
value: v next: n	| new |
		" return a new link with the given fields "
	new <- self new.
	self in: new at: 1 put: v.
	self in: new at: 2 put: n.
	^ new
!
METHOD Link
value
	^ value
!
METHOD Link
value: val
	value <- val
!
METHOD Link
next
	^ next
!
METHOD Link
do: aBlock
	aBlock value: value.
	next notNil ifTrue: [ ^ next do: aBlock ]
!
METHOD Link
remove: anElement ifAbsent: exceptionBlock
	value = anElement
		ifTrue: [ ^ next ]
		ifFalse: [ next notNil
			ifTrue: [ next <- next remove: anElement
				ifAbsent: exceptionBlock. ^ self ]
			ifFalse: [ ^ exceptionBlock value ] ]
!
METHOD Link
reverseDo: aBlock
	next notNil ifTrue: [ next reverseDo: aBlock ].
	aBlock value: value
!
METHOD Link
addLast: anElement
	next notNil
		ifTrue: [ ^ next addLast: anElement ]
		ifFalse: [ next <- Link value: anElement ]
!
