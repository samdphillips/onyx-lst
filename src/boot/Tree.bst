COMMENT --- Start Tree Methods ---
METHOD Tree
add: anElement
	root isNil
		ifTrue: [ root <- Node new: anElement ]
		ifFalse: [ root add: anElement ].
	^anElement
!
METHOD Tree
addAll: aCollection
	aCollection do: [:element| self add: element ]
!
METHOD Tree
at: key ifAbsent: exceptionBlock
	root isNil
		ifTrue: [ ^ exceptionBlock value ]
		ifFalse: [ ^ root at: key ifAbsent: exceptionBlock ]
!
METHOD Tree
copy
	^Tree new addAll: self
!
METHOD Tree
collect: transformBlock | newTree |
	newTree <- Tree new.
	self do: [:element| newTree add: (transformBlock value: element)]
	^newTree
!
METHOD Tree
do: aBlock
	root notNil ifTrue: [ root do: aBlock ]
!
METHOD Tree
select: testBlock | newTree |
	newTree <- Tree new.
	self do: [:element|
		(testBlock value: element)
			ifTrue: [newTree add: element]
	].
	^newTree
!
METHOD Tree
reverseDo: aBlock
	root notNil ifTrue: [ root reverseDo: aBlock ]
!
METHOD Tree
removeFirst
	root isNIl ifTrue: [ self emptyCollection ].
	root <- root removeFirst
!
METHOD Tree
remove: key ifAbsent: exceptionBlock
	root isNil
		ifTrue: [ exceptionBlock value ]
		ifFalse: [ root <- root remove: key ifAbsent: exceptionBlock ]
!
METHOD Tree
first
	root notNil
		ifTrue: [ ^root first ]
		ifFalse: [ self emptyCollection ]
!
METHOD Tree
isEmpty
	^ root isNil
!
