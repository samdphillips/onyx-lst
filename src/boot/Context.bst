COMMENT --- Start Context Methods ---
METHOD Context
setup: aMethod withArguments: a
	method <- aMethod.
	arguments <- Array new: 1.
	bytePointer <- 0.
	stack <- Array new: method stackSize.
	stackTop <- 0.
	temporaries <- Array new: method temporarySize.
!
METHOD Context
perform: aMethod withArguments: a | proc |
	self setup: aMethod withArguments: a.
	proc <- Process new.
	proc context: self.
	^ proc execute
!
METHOD Context
backtrace | narg |
		" backtrace context calls "
	narg <- 0.
	method name print.
	'(' print.
	arguments do: [:a |
		(narg > 0) ifTrue: [ ', ' print ].
		a class print.
		narg <- narg+1
	].
	')' printNl.
	previousContext notNil
		ifTrue: [ previousContext backtrace ]
!
METHOD Context
previousContext
	^ previousContext
!
