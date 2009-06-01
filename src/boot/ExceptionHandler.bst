COMMENT --- Start ExceptionHandler Methods ---
METHOD MetaExceptionHandler
on: exceptionSet do: exceptionBlock
    ^ self new
        exceptionSet: exceptionSet;
        exceptionBlock: exceptionBlock
!
METHOD ExceptionHandler
exceptionSet: anExceptionSet
    exceptionSet <- anExceptionSet
!
METHOD ExceptionHandler
exceptionBlock: aBlock
    exceptionBlock <- aBlock
!
