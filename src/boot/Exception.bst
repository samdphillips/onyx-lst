COMMENT --- Start Exception Methods ---
METHOD Exception
signal
    self signalInContext: thisContext
!
METHOD MetaException
foo
    [ Exception new signal ]
        on: Exception
        do: [ 'got it' printNl ]
!
METHOD Exception
signalInContext: aContext
    signalledContext <- aContext.
    handlerContext <- self findHandler: aContext.

    handlerContext notNil 
        ifTrue: [ handlerContext value: self ].

    self defaultAction
!
METHOD Exception
findHandler: startContext
    | ctx |
    ctx <- startContext.
    [ ctx notNil ] whileTrue: 
        [ ctx method name printNl.
          (ctx handles: self)
            ifTrue: [ ^ ctx ].
          ctx <- ctx previousContext ].
    ^ nil
!
METHOD Exception
messageText
    messageText isNil ifTrue: [ ^'' ].
    ^ messageText
!
METHOD Exception
defaultAction
    'Exception: ' print.
    self messageText printNl.
    <19>
!
