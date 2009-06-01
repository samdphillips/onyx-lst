COMMENT --- Start Array Methods ---
METHOD MetaArray
new
	^ self new: 0
!
METHOD MetaArray
new: sz
	<7 self sz>
!
METHOD MetaArray
with: elemA | ret |
	ret <- self new: 1.
	ret at: 1 put: elemA.
	^ ret
!
METHOD MetaArray
with: elemA with: elemB | ret |
	ret <- self new: 2.
	ret at: 1 put: elemA.
	ret at: 2 put: elemB.
	^ ret
!
METHOD MetaArray
with: elemA with: elemB with: elemC | ret |
	ret <- self new: 3.
	ret at: 1 put: elemA.
	ret at: 2 put: elemB.
	ret at: 3 put: elemC.
	^ ret
!
METHOD Array
badIndex
	self error: 'array indexing error'
!
METHOD Array
at: index
	<24 self index>
	(self includesKey: index) ifFalse: [ self badIndex ].
	self primitiveFailed
!
METHOD Array
at: index ifAbsent: exceptionBlock
	<24 self index>
	exceptionBlock value
!
METHOD Array
includes: aValue
	self do: [ :element | element = aValue ifTrue: [ ^ true ]].
	^ false
!
METHOD Array
indexOf: aValue
	1 to: self size do: [:idx|
		((self at: idx) == aValue) ifTrue: [ ^ idx ]
	].
	^ nil
!
METHOD Array
indexOfVal: aValue
	1 to: self size do: [:idx|
		((self at: idx) = aValue) ifTrue: [ ^ idx ]
	].
	^ nil
!
METHOD Array
copy
	^ self asArray
!
METHOD Array
with: newItem	| newArray size |
	size <- self size.
	newArray <- self class new: size + 1.
	newArray replaceFrom: 1 to: size with: self.
	newArray at: size + 1 put: newItem
	^ newArray
!
METHOD Array
+ aValue	| size1 size2 newValue |
	" catenate two strings together "
	size1 <- self size.
	size2 <- aValue size.
	newValue <- self class new: (size1 + size2).
	newValue replaceFrom: 1 to: size1 with: self.
	newValue replaceFrom: size1+1 to: size1+size2 with: aValue.
	^ newValue
!
METHOD Array
size
	" compute number of elements "
	<4 self>
!
METHOD Array
at: index put: value
	<5 value self index>
	(self includesKey: index) ifFalse: [ self badIndex ].
	self primitiveFailed
!
METHOD Array
do: aBlock
	1 to: self size do: [:i | aBlock value: (self at: i)]
!
METHOD Array
< arg		| selfsize argsize |
	selfsize <- self size. argsize <- arg size.
	1 to: (selfsize min: argsize)
		do: [:i | (self at: i) ~= (arg at: i)
			ifTrue: [ ^ (self at: i) < (arg at: i) ]].
	^ selfsize < argsize
!
METHOD Array
= anArray
	self size = anArray size ifFalse: [ ^ false ].
	1 to: self size do:
		[:i | (self at: i) = (anArray at: i)
			ifFalse: [ ^ false ]].
	^ true
!
METHOD Array
includesKey: index
	^ index between: 1 and: self size
!
METHOD Array
insert: value at: position | newArray newSize |
	newSize <- self size + 1.
	newArray <- self class new: newSize.
	newArray replaceFrom: 1 to: position-1 with: self.
	newArray at: position put: value.
	newArray replaceFrom: position+1 to: newSize with:
		self startingAt: position.
	^ newArray
!
METHOD Array
removeIndex: position  | newArray newSize |
	newSize <- self size - 1.
	newArray <- self class new: newSize.
	newArray replaceFrom: 1 to: position-1 with: self.
	newArray replaceFrom: position to: newSize with: self
		startingAt: position+1.
	^ newArray
!
METHOD Array
first
	^self at: 1
!
METHOD Array
from: low to: high | start stop size obj |
	start <- low max: 0.
	stop <- high min: self size.
	size <- (stop + 1 - start) max: 0.
	obj <- (self species) new: size.
	1 to: size do: [ :i |
		obj at: i put: (self at: start).
		start <- start + 1 ].
	^ obj
!
METHOD Array
hash | sz |
	sz <- self size.
	(sz < 2) ifTrue: [
		(sz = 1) ifTrue: [ ^ (self at: 1) hash + sz ].
		^ 0
	].
	^ (self at: 1) hash + (self at: sz) hash
!
METHOD Array
elementsExchangeIdentityWith: otherArray
	<35 self otherArray>.
	self primitiveFailed
!
METHOD Array
replaceFrom: start to: stop with: replacement
	^ self replaceFrom: start to: stop with: replacement startingAt: 1
!
METHOD Array
replaceFrom: start to: stop with: replacement startingAt: repStart | base |
	<38 start stop replacement repStart self>.
	base <- repStart-1.
	0 to: (stop - start) do: [:idx|
		self at: (idx + start) put:
			(replacement at: (idx + repStart))
	]
!
