COMMENT --- Start Class Methods ---
METHOD Class
name: n parent: c variables: v
	" create a new class with the given characteristics "
	name <- n.
	parentClass <- c.
	methods <- Dictionary new.
	size <- v size + c size.
	variables <- v
!
METHOD Class
size
	^ size
!
METHOD Class
superclass
	^ parentClass
!
METHOD Class
variables
	^ variables
!
METHOD Class
subclasses
	self subclasses: 0
!
METHOD Class
subclasses: indent
	globals do: [ :obj |
		((obj isKindOf: Class) and: [ obj superclass == self])
			ifTrue: [
				1 to: indent do: [:ignore| $  print ].
				obj printNl.
				obj subclasses: indent + 4 ] ]
!
METHOD Class
listMethods
	methods keysDo:
		[ :name | name printNl ]
!
METHOD Class
allMethods | allMethods |
	parentClass isNil
		ifTrue: [ allMethods <- Dictionary new ]
		ifFalse: [ allMethods <- parentClass allMethods ].
	methods binaryDo: [ :n :m | allMethods at: n put: m ].
	^ allMethods
!
METHOD Class
listAllMethods
	self allMethods keysDo: [:n| n printNl ]
!
METHOD Class
viewMethod: nm  | meth |
	meth <- self allMethods at: nm
		ifAbsent: [ ^ self error: 'no such method'].
	meth text print.
	^ ''
!
METHOD Class
editMethod: nm	| meth text |
	meth <- methods at: nm
		ifAbsent: [ ^ self error: 'no such method'].
	text <- meth text edit.
	(self question: 'compile method?')
		ifTrue: [ self addMethod: text ]
!
METHOD Class
subclass: nm
	^ self subclass: nm variables: (Array new: 0)
		classVariables: (Array new: 0)
!
METHOD Class
subclass: nm variables: v
	^ self subclass: nm variables: v classVariables: (Array new: 0)
!
METHOD Class
subclass: nm variables: v classVariables: cv | meta |
	meta <- Class new name: ('Meta' + nm asString) asSymbol
		parent: self class
		variables: cv.
	globals at: nm put: ( meta new name: nm
		parent: self
		variables: v ).
	^ 'subclass created: ' + nm printString
!
METHOD Class
addMethod	| text |
	text <- ' ' edit.
	(self question: 'compile method?')
		ifTrue: [ self addMethod: text ]
!
METHOD Class
addMethod: text | meth |
	meth <- self parseMethod: text.
	meth notNil ifTrue: [
		methods at: meth name put: meth.
		Method flushCache.
		'ok' printNl.
		^ meth
	].
	^ nil
!
METHOD Class
removeMethod: methName
	methods removeKey: methName ifAbsent: [
		self error: 'Method not present: ' + (methName printString)
	].
	Method flushCache.
!
METHOD Class
view: methodName
		" print the text of the given method "
	(methods at: methodName
		ifAbsent: [ ^ self error: 'no such method'])
			text print
!
METHOD Class
parseMethod: text
	^ (Parser new
		text: text instanceVars: self instanceVariables) parse: self
!
METHOD Class
new
	" return a new instance of ourselves "
	<7 self size>
!
METHOD Class
basicNew
	" Like new "
	<7 self size>
!
METHOD Class
instanceVariables	| names |
		" return all our variable names "
	parentClass notNil
		ifTrue: [ names <- parentClass instanceVariables ]
		ifFalse: [ names <- Array new: 0 ].
	(variables isNil or: [ variables isEmpty ])
		ifFalse: [ names <- names + variables ].
	^ names
!
METHOD Class
methods
	" return the tree of methods "
	^ methods
!
METHOD Class
printString
	" just return our name "
	^ name printString
!
METHOD Class
isMeta
	^ (name asString from: 1 to: 4) = 'Meta'
!
METHOD Class
fileOut: f | tag |
	self isMeta ifTrue: [
		tag <- '=' + (name asString from: 5 to: 99)
	] ifFalse: [
		tag <- '!' + name asString
	].
	tag <- tag + String newline.
	methods do: [:m|
		f write: tag.
		f write: (m text printString).
		f write: ('!' + String newline)
	]
!
METHOD Class
fileOut | f |
	f <- File openWrite: (name printString + '.st').
	f isNil ifTrue: [ self error: 'File creation failed' ].
	self isMeta ifFalse: [
		self class fileOut: f
	].
	self fileOut: f.
	f close
!
