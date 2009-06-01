COMMENT --- Start String Methods ---
METHOD MetaString
new: size
	<20 self size>
!
METHOD MetaString
input	| value c nl |
	" read a line from input "
	value <- ''. nl <- Char newline.
	[ c <- Char input.
	  c isNil ifTrue: [ ^ nil ]. c ~= nl ] whileTrue:
		[ value <- value + c asString ].
	^ value
!
METHOD MetaString
newline
	^ Char newline asString
!
METHOD MetaString
tab
	^ Char tab asString
!
METHOD String
edit
	<105 self>
!
METHOD String
break: separators  | words word |
	" break string into words, using separators "
	word <- ''.
	words <- List new.
	self do: [:c |
		(separators includes: c)
			ifTrue: [
				(word size > 0) " found a word "
					ifTrue: [ words addLast: word.
							word <- '' ] ]
			ifFalse: [ word <- word + c asString ] ].
		" maybe a last word "
	(word size > 0) ifTrue: [ words addLast: word ].
	^ words
!
METHOD String
collect: transformationBlock
	^ (super collect: transformationBlock) asString
!
METHOD String
reverse
	^ self asList reverse asString
!
METHOD String
select: testBlock
	^ (super select: testBlock) asString
!
METHOD String
printString
	^ self
!
METHOD String
printWidth: width | ret |
	(self size >= width absolute) ifTrue: [ ^ self ].
	ret <- self.
	(width negative) ifTrue: [
			(self size + 1) to: (width negated) do:
				[:ignore| ret <- ' ' + ret].
		]
		ifFalse: [
			(self size + 1) to: width do:
				[:ignore| ret <- ret + ' ' ].
		].
	^ret
!
METHOD String
asSymbol
	^ Symbol new: self
!
METHOD String
doIt	| meth |
	meth <- Undefined parseMethod: 'doItCommand ^' + self.
	^ meth notNil
		ifTrue: [ ^ Context new
			  perform: meth withArguments: (Array new: 1) ]
!
METHOD String
basicAt: index
	<21 self index>
	^nil
!
METHOD String
at: index
	^self at: index ifAbsent: [ self badIndex ]
!
METHOD String
at: index ifAbsent: exceptionBlock | c |
	c <- self basicAt: index.
	(c isNil)
	     ifTrue: [ ^ exceptionBlock value ]
	     ifFalse: [ ^ Char new: c ]
!
METHOD String
basicAt: index put: value
	<22 value self index>
	^nil
!
METHOD String
at: index put: aValue
	(self basicAt: index put: aValue value) isNil ifTrue: [
		self badIndex
	]
!
METHOD String
copy
	" make a clone of ourself "
	<23 self String>
!
METHOD String
asNumber: base
    | charValue value |
    value <- 0.
    self do: [:char | 
        charValue <- char baseValue: base.
        charValue isNil ifTrue: [ ^ nil ].
        value <- value * base + charValue
    ].
    ^ value
!
METHOD String
asNumber
	" parse a base-10 ASCII number, return nil on failure "
    | index base | 
    index <- self indexOf: $r.
    index isNil ifTrue: [ ^ self asNumber: 10 ].
    base <- (self from: 1 to: index - 1) asNumber: 10.
    ^ (self from: index + 1) asNumber: base
!
METHOD String
hash | sz |
	sz <- self size.
	(sz < 2) ifTrue: [
		(sz = 1) ifTrue: [ ^ (self at: 1) value ].
		^ 0
	].
	^ (self at: 1) value + (self at: sz) value
!
METHOD String
lowerCase | ret c |
	ret <- String new: (self size).
	1 to: self size do: [:x|
		c <- self at: x.
		c isUpperCase ifTrue: [c <- c lowerCase].
		ret at: x put: c
	].
	^ ret
!
METHOD String
indexOf: val | c s |
	" For non-strings, search scalar Array elements "
	(val isKindOf: String) ifFalse: [ ^ super indexOf: val ].

	" Otherwise look for substring match "
	c <- val at: 1.
	s <- val size.
	1 to: (self size - s + 1) do: [:idx|
		" Cheap check for initial char equality "
		((self at: idx) = c) ifTrue: [
			((self from: idx to: (idx + s - 1)) = val)
				ifTrue: [ ^ idx ]
		]
	].
	^ nil
!
