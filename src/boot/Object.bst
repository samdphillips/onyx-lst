COMMENT --- Start Object Methods ---
METHOD MetaObject
in: object at: index put: value
	" change data field in object, used during initialization "
	" returns the intialized object "
	<5 value object index>
!
METHOD Object
in: object at: index
	" browse instance variable via debugger "
	<24 object index>.
	self primitiveFailed
!
METHOD Object
isNil
	^ false
!
METHOD Object
notNil
	^ true
!
METHOD Object
== arg
	<1 self arg>
!
METHOD Object
= arg
	^ self == arg
!
METHOD Object
~= arg
	^ (self = arg) not
!
METHOD Object
~~ arg
	^ (self == arg) not
!
METHOD Object
class
	<2 self>
!
METHOD Object
printString
	^ self class printString
!
METHOD Object
isMemberOf: aClass
	^ self class == aClass
!
METHOD Object
isKindOf: aClass	| clas |
	clas <- self class.
	[ clas notNil ] whileTrue:
		[ clas == aClass ifTrue: [ ^ true ].
		  clas <- clas superclass ].
	^ false
!
METHOD Object
respondsTo: aMessage
	^ self class allMethods includes: aMessage
!
METHOD Object
print
	self printString do: [ :c | c print ]
!
METHOD Object
printNl
	self print. Char newline print
!
METHOD Object
question: text	| answer |
	text print.
	answer <- String input.
	(answer notNil)
		ifTrue: [ answer <- answer at: 1 ifAbsent: [ $n ] ].
	^ answer = $y or: [ answer = $Y]
!
METHOD Object
error: str
		" print the message "
	str printNl.
		" then halt "
	<19>
!
METHOD Object
debug
	<18>
!
METHOD Object
primitiveFailed
	self error: 'Primitive failed'
!
METHOD Object
species
	" By default, we re-instantiate ourselves as our own Class "
	^ self class
!
METHOD Object
hash
	" Most objects should generate something based on their value "
	^ self class printString hash
!
METHOD Object
become: other
	" Exchange identity with another object "
	(Array with: self) elementsExchangeIdentityWith: (Array with: other)
!
METHOD Object
doesNotUnderstand: aSel
	self error: (self printString + ' (class '+
		(self class printString) +
		'): does not understand ' + aSel printString)
!
METHOD Object
basicSize
	<4 self>.
	self primitiveFailed
!
METHOD Object
subclassResponsibility
	self error: 'Subclass responsibility'
!
METHOD Object
basicDo: aBlock
	^ self do: aBlock
!
