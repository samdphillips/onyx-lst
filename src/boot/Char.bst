COMMENT --- Start Char Methods ---
METHOD MetaChar
initialize
	chars isNil ifTrue: [
		chars <- Array new: 257.
		1 to: 257 do: [:idx|
			chars at: idx put: (Char basicNew: idx-1)
		]
	]
!
METHOD MetaChar
basicNew: value
    " return unique Char for ASCII value "
    <42 value>
    self primitiveFailed
!
METHOD MetaChar
new: value
    (value between: 0 and: 255) 
        ifTrue: [ ^ self basicNew: value ].
    value printNl.
    self error: 'invalid value'
!
METHOD MetaChar
newline
		" return newline character "
	^ self new: 10
!
METHOD MetaChar
tab
		" return tab character "
	^ self new: 9
!
METHOD MetaChar
doInput
	<9>
!
METHOD MetaChar
input	| c |
	" read a single char from input stream "
	c <- self doInput.
	(c notNil)
		ifTrue: [ ^self new: c ]
		ifFalse: [ ^nil ]
!
METHOD Char
value
		" return our ascii value as an integer "
	<41 self>
!
METHOD Char
hash
	^ self value
!
METHOD Char
isDigit
	^ self between: $0 and: $9
!
METHOD Char
isLowerCase
	^ self between: $a and: $z
!
METHOD Char
isUpperCase
	^ self between: $A and: $Z
!
METHOD Char
isAlphabetic
	^ self isLowerCase or: [ self isUpperCase ]
!
METHOD Char
lowerCase
	self isUpperCase
		ifTrue: [ ^ Char new: (self value - 65) + 97 ]
!
METHOD Char
upperCase
	self isLowerCase
		ifTrue: [ ^ Char new: (self value - 97) + 65 ]
!
METHOD Char
isAlphanumeric
		" are we a letter or a digit? "
	^ self isAlphabetic or: [ self isDigit ]
!
METHOD Char
isBlank
    | value |
    "spaces, tabs and newlines are all blank"
    value <- self value.
    ^ value = 32 or: [ value = 9 or: [ value = 10 ] ]
!
METHOD Char
print
	<3 self>
!
METHOD Char
asString
	" return char as a string value "
	^ String new: 1; at: 1 put: self
!
METHOD Char
printString
	^ String new: 2; at: 1 put: $$ ; at: 2 put: self
!
METHOD Char
= aChar
	^ self value = aChar value
!
METHOD Char
< aChar
	^ self value < aChar value
!
METHOD Char
baseValue: base
    "Answer the value of a ""digit"" in base."
    | v |
    self isDigit ifTrue: [ v <- self value - 48 ].
    self isAlphabetic ifTrue: [ v <- self upperCase value - 55 ].

    v isNil ifTrue: [ ^ nil ].
    base <= v ifTrue: [ ^ nil ].
    ^ v
!
