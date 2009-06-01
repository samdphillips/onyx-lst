COMMENT --- Start List Methods ---
METHOD MetaList
with: elemA	| newList |
	newList <- self new.
	newList add: elemA.
	^ newList
!
METHOD MetaList
with: elemA with: elemB	| newList |
	newList <- self new.
	newList add: elemB.  newList add: elemA.
	^ newList
!
METHOD MetaList
with: elemA with: elemB with: elemC	| newList |
	newList <- self new.
	newList add: elemC.  newList add: elemB.  newList add: elemA.
	^ newList
!
METHOD List
add: anElement
	elements <- Link value: anElement next: elements.
	^ anElement
!
METHOD List
addLast: anElement
	elements isNil
		ifTrue: [ self add: anElement]
		ifFalse: [ elements addLast: anElement ].
	^ anElement
!
METHOD List
addAll: aCollection
	aCollection do: [ :element | self addLast: element ]
!
METHOD List
+ aCollection
	^ self addAll: aCollection
!
METHOD List
copy
	^ self asList
!
METHOD List
badIndex
	self error: 'Invalid List index'
!
METHOD List
findLink: index ifAbsent: aBlock | idx link |
	link <- elements.
	idx <- index.
	link isNil ifTrue: [ ^ aBlock value ].
	[ link notNil ] whileTrue: [
		idx <- idx-1.
		(idx = 0) ifTrue: [ ^ link ].
		link <- link next
	].
	^ aBlock value
!
METHOD List
at: index | link |
	link <- self findLink: index ifAbsent: [ self badIndex ].
	^ link value
!
METHOD List
at: index ifAbsent: aBlock | link |
	link <- self findLink: index ifAbsent: [nil].
	link isNil ifTrue: [ ^ aBlock value ].
	^ link value
!
METHOD List
at: index put: value | link |
	link <- self findLink: index.
	link value: value
!
METHOD List
first
	^ self at: 1
!
METHOD List
isEmpty
	^ elements isNil
!
METHOD List
removeFirst
	elements isNil
		ifTrue: [ self emptyCollection ]
		ifFalse: [ elements <- elements next ]
!
METHOD List
remove: anElement
	self remove: anElement
		ifAbsent: [ self emptyCollection ]
!
METHOD List
reverse | newList |
	newList <- List new.
	self do: [ :element | newList add: element ].
	^ newList
!
METHOD List
remove: anElement ifAbsent: exceptionBlock
	elements isNil
		ifTrue: [ exceptionBlock value ]
		ifFalse: [ elements remove: anElement ifAbsent: exceptionBlock ]
!
METHOD List
do: aBlock
	^ elements notNil ifTrue: [ elements do: aBlock ]
!
METHOD List
reverseDo: aBlock
	^ elements notNil ifTrue: [ elements reverseDo: aBlock ]
!
METHOD List
select: testBlock | newList |
	newList <- List new.
	self reverseDo: [:element | (testBlock value: element)
		ifTrue: [ newList add: element ] ].
	^ newList
!
