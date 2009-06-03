COMMENT --- Start Block Methods ---
METHOD Block
argCount
    self error: 'Incorrect argument passing to Block'
!
METHOD Block
value
    " start block execution "
    <8 self>
    (self argCount)
!
METHOD Block
value: a
    " start block execution "
    <8 a self>
    (self argCount)
!
METHOD Block
value: a value: b
    " start block execution "
    <8 a b self>
    (self argCount)
!
METHOD Block
exceptionHandler
    ^ exceptionHandler
!
METHOD Block
whileTrue: aBlock
    self value ifTrue: [ aBlock value. ^ self whileTrue: aBlock ]
!
METHOD Block
whileFalse: aBlock
    self value ifFalse: [ aBlock value. ^ self whileFalse: aBlock ]
!
METHOD Block
on: exceptionSet do: exceptionBlock
    exceptionHandler <- 
        ExceptionHandler on: exceptionSet do: exceptionBlock.
    ^ self value
!
METHOD Block
handles: anException
    ^ exceptionHandler notNil and: [ exceptionHandler handles: anException ]
!
METHOD Block
backtrace | narg |
    " backtrace context calls "
    'block from ' print. method name print.
    '(' print.
    narg <- 0.
    arguments 
        do: [:a |
            (narg > 0) ifTrue: [', ' print ].
            a class print.
            narg <- narg+1
        ].
    ')' printNl.
    previousContext notNil
        ifTrue: [ previousContext backtrace ]
!
