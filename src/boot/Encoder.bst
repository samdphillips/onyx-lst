COMMENT --- Start Encoder Methods ---
METHOD Encoder
name: n
	name <- n asSymbol.
	byteCodes <- ByteArray new: 20.
	index <- 0.
	literals <- Array new: 0.
	stackSize <- 0.
	maxStack <- 1.
!
METHOD Encoder
lineNum: l
	" Don't care, except in DebugEncoder subclass "
!
METHOD Encoder
pushArgs: n
	stackSize <- stackSize + n.
	maxStack <- stackSize max: maxStack
!
METHOD Encoder
popArgs: n
	stackSize <- stackSize - n.
!
METHOD Encoder
genLiteral: aValue | idx |
	idx <- literals indexOf: aValue.
	idx notNil ifTrue: [ ^ idx - 1 ].
	literals <- literals with: aValue.
	^ literals size - 1
!
METHOD Encoder
genHigh: high low: low
	(low >= 16)
		ifTrue: [ self genHigh: 0 low: high. self genCode: low ]
		ifFalse: [ self genCode: high * 16 + low ]
!
METHOD Encoder
genCode: byte
	index <- index + 1.
	(index >= byteCodes size)
		ifTrue: [ self expandByteCodes].
	byteCodes at: index put: byte.
	^ index
!
METHOD Encoder
genVal: byte
	self genCode: (byte rem: 256).
	self genCode: (byte quo: 256).
	^ index-1
!
METHOD Encoder
expandByteCodes	| newarray size |
	size <- byteCodes size.
	newarray <- ByteArray new: size + 8.
	1 to: size do: [:i | newarray at: i put: (byteCodes at: i)].
	byteCodes <- newarray
!
METHOD Encoder
patch: loc
		" patch a goto from a block "
	byteCodes at: loc put: (index rem: 256).
	byteCodes at: (loc + 1) put: (index quo: 256)
!
METHOD Encoder
currentLocation
	^ index
!
METHOD Encoder
backUp
	" back up one instruction "
	index <- index - 1
!
METHOD Encoder
method: maxTemps class: c text: text
	^ Method name: name byteCodes: byteCodes literals: literals
		stackSize: maxStack temporarySize: maxTemps class: c
		text: text
!
