
"
!Block
whileTrue
    ^ self whileTrue: [ nil ]
!

!Block
whileFalse
    ^ self whileFalse: [ nil ]
!
"

!Char
baseValue: base
    "Answer the value of this character in base-n"
    | v |
    self isDigit ifTrue: [ v <- self value - 48 ].
    self isAlphabetic ifTrue: [ v <- self upperCase value - 55 ].

    v isNil ifTrue: [ ^ nil ].

    base <= v ifTrue: [ ^ nil ].
    ^ v
!

!String
asNumber: base
    | val v |
    val <- 0.
    self do: [:c | 
        v <- c baseValue: base.
        v isNil ifTrue: [ ^ nil ].
        val <- (val * base) + v
    ].
    ^ val
!

!String
asNumber
    | i base |
    i <- self indexOf: $r.
    i isNil ifTrue: [ ^ self asNumber: 10 ].

    base <- (self from: 1 to: i - 1) asNumber: 10.
    ^ (self from: i + 1) asNumber: base
!

!Parser
lexInteger
    | start |
    start <- index.
    [ self nextChar isDigit ] whileTrue: [ nil ].

    token <- text from: start to: index - 1.

    self currentChar = $r
        ifTrue: [ self lexBaseInteger ]
!

!Parser
lexBaseInteger
    | start |
    start <- index.
    [ self nextChar isAlphanumeric ] whileTrue: [ nil ].
    token <- token + (text from: start to: index - 1).
!
