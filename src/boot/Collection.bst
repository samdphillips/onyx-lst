COMMENT --- Start Collection Methods ---
METHOD Collection
noElement
	self error: 'Element not present'
!
METHOD Collection
size	| tally |
	tally <- 0.
	self do: [:i | tally <- tally + 1].
	^ tally
!
METHOD Collection
isEmpty
		" empty if there are no elements "
	^ self size = 0
!
METHOD Collection
at: value ifAbsent: exceptionBlock
	self do: [ :element | element = value ifTrue: [ ^ element ]].
	^ exceptionBlock value
!
METHOD Collection
at: value
	^ self at: value ifAbsent: [ self noElement ]
!
METHOD Collection
includes: value
	self at: value ifAbsent: [ ^ false ].
	^ true
!
METHOD Collection
asArray		| newArray index |
	newArray <- Array new: self size.
	index <- 1.
	self do: [ :element | newArray at: index put: element.
		index <- index + 1 ].
	^ newArray
!
METHOD Collection
from: argLow to: argHigh | ret idx size base low high |
	low <- argLow max: 1.
	high <- argHigh min: self size.
	size <- (high - low) + 1.
	(size < 1) ifTrue: [ ^ Array new: 0 ].
	ret <- Array new: size.
	base <- idx <- 1.
	self do: [:elem|
		((idx >= low) and: [idx <= high]) ifTrue: [
			ret at: base put: elem.
			base <- base + 1.
			(base > size) ifTrue: [ ^ ret ]
		].
		idx <- idx + 1.
	].
	^ ret
!
METHOD Collection
from: argLow
	^ self from: argLow to: (self size)
!
METHOD Collection
asString	| newString index |
	newString <- String new: self size.
	index <- 1.
	self do: [ :element | newString at: index put: element.
		index <- index + 1 ].
	^ newString
!
METHOD Collection
asList
	^ List new addAll: self
!
METHOD Collection
collect: transformBlock	| newList |
	newList <- List new.
	self do: [:element | newList addLast: (transformBlock value: element)].
	^ newList
!
METHOD Collection
select: testBlock	| newList |
	newList <- List new.
	self do: [:x | (testBlock value: x) ifTrue: [newList addLast: x]].
	^ newList
!
METHOD Collection
< aCollection
	self do: [ :element | (aCollection includes: element)
		ifFalse: [ ^ false ] ].
	^ true
!
METHOD Collection
= aCollection
	^ self < aCollection and: [ aCollection < self ]
!
METHOD Collection
reject: testBlock
		" select the things that do not match predicate "
	^ self select: [:x | (testBlock value: x) not ]
!
METHOD Collection
printString | count res |
	res <- super printString.
	(self respondsTo: #do:) ifFalse: [ ^ res ].
	count <- 0.
	res <- res + ' ('.
	self basicDo: [:elem| 
		(count = 0) ifFalse: [ res <- res + ' ' ].
		res <- res + elem printString.
		count <- count + 1.
		(count >= 20) ifTrue: [ ^ res + ' ...)' ]
	].
	^ res + ')'
!
METHOD Collection
occurencesOf: obj | count |
	count <- 0.
	self do: [:o| (o = obj) ifTrue: [ count <- count + 1]].
	^ count
!
METHOD Collection
anyOne
	self do: [:it| ^ it].
	self emptyCollection
!
METHOD Collection
emptyCollection
	self error: (self class printString + ' is empty')
!
METHOD Collection
do: aBlock
	self subclassResponsibility
!
