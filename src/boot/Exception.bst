COMMENT --- Start Exception Methods ---
METHOD MetaException
handles: anException
    ^ anException isKindOf: self
!
METHOD MetaException
signal
    ^ self new signal
!
METHOD MetaException
signal: aString
    ^ self new signal: aString
!
METHOD Exception
signal
    ^ self signalInContext: thisContext
!
METHOD Exception
signal: aString
    self messageText: aString.
    ^ self signal
!
METHOD Exception
messageText: aString
    messageText <- aString
!
METHOD Exception
signalInContext: aContext
    signalledContext <- aContext.
    handlerContext <- self findHandler: aContext.

    handlerContext notNil
        ifTrue: [ ^ handlerContext value: self ].

    self defaultAction
!
METHOD Exception
findHandler: startContext
    | ctx |
    ctx <- startContext.
    [ ctx notNil ] whileTrue: 
        [ (ctx handles: self)
            ifTrue: [ ^ ctx exceptionHandler ].
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
    self class print. ': ' print.
    self messageText printNl.
    <19>
!
