COMMENT --- Start Node Methods ---
METHOD MetaNode
new: value
	" creation, left left and right empty "
	^ self in: self new at: 1 put: value
!
METHOD Node
do: aBlock
	left notNil ifTrue: [ left do: aBlock ].
	aBlock value: value.
	^ right notNil ifTrue: [ right do: aBlock ]
!
METHOD Node
reverseDo: aBlock
	right notNil ifTrue: [ right do: aBlock ].
	aBlock value: value.
	left notNil ifTrue: [ left do: aBlock ]
!
METHOD Node
first
	left notNil
		ifTrue: [ ^ left first ]
		ifFalse: [ ^ value ]
!
METHOD Node
removeFirst
	left notNil
		ifTrue: [ left <- left removeFirst. ^ self ]
		ifFalse: [ ^ right ]
!
METHOD Node
add: anElement
	value < anElement
		ifTrue: [ right notNil
			ifTrue: [ right add: anElement ]
			ifFalse: [ right <- Node new: anElement ] ]
		ifFalse: [ left notNil
			ifTrue: [ left add: anElement ]
			ifFalse: [ left <- Node new: anElement ] ]
!
METHOD Node
remove: key ifAbsent: exceptionBlock
	value = key
		ifTrue: [ right notNil
			ifTrue: [ value <- right first.
			right <- right removeFirst.
			^ self ]
			ifFalse: [ ^ left ] ].
	value < key
		ifTrue: [ right notNil
			ifTrue: [ right <- right remove: key ifAbsent: exceptionBlock ]
			ifFalse: [ ^ exceptionBlock value ] ]
		ifFalse: [ left notNil
			ifTrue: [ left <- left removeL key ifAbsent: exceptionBlock ]
			ifFalse: [ ^ exceptionBlock value ] ]
!
METHOD Node
value
	^ value
!
METHOD Node
at: key ifAbsent: exceptionBlock
	value = key ifTrue: [ ^ value ].
	value < key
		ifTrue: [ right notNil
			ifTrue: [ ^ right at: key ifAbsent: exceptionBlock ]
			ifFalse: [ ^ exceptionBlock value ] ]
		ifFalse: [ left notNil
			ifTrue: [ ^ left at: key ifAbsent: exceptionBlock ]
			ifFalse: [ ^ exceptionBlock value ] ]
!
