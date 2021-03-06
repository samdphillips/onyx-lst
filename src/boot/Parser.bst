COMMENT --- Start Parser Methods ---
METHOD Parser
text: aString instanceVars: anArray
	text <- aString.
	index <- 1.
	lineNum <- 1.
	argNames <- Array new: 1.
	argNames at: 1 put: #self.
	instNames <- anArray.
	tempNames <- Array new: 0.
	maxTemps <- 0
!
METHOD Parser
parse: c with: encoderClass	| encoder meth name |
	" note -- must call text:instanceVars: first "
	errBlock <- [ ^ nil ].
	self nextLex.
	encoder <- encoderClass new.
	name <- self readMethodName.
	(c ~= Undefined) ifTrue: [
		'Compiling ' print. c print. ':' print.
		name print. '... ' print
	].
	encoder name: name.
	self readMethodVariables.
	self readBody compile: encoder block: false.
	meth <- encoder method: maxTemps class: c text: text.
	meth args: argNames inst: instNames temp: tempNames.
	^ meth
!
METHOD Parser
parse: c
	^ self parse: c with: Encoder
!
METHOD Parser
error: aString
	'Compile error near line ' print.
	lineNum printString print.
	': ' print.
	aString printNl.
	errBlock value
!
METHOD Parser
currentChar
	^ text at: index ifAbsent: [ nil ]
!
METHOD Parser
nextChar
	(self currentChar = Char newline) ifTrue: [
		lineNum <- lineNum + 1
	].
	index <- index + 1.
	^ self currentChar
!
METHOD Parser
nextLex	
	self skipBlanks.
	tokenType <- self currentChar.
	tokenType isNil   " end of input "
		ifTrue: [ tokenType <- $  . token <- nil. ^ nil ].
	tokenType isDigit ifTrue: [ ^ self lexInteger ].
	tokenType isAlphabetic ifTrue: [ ^ self lexAlnum ].
	^ self lexBinary
!
METHOD Parser
skipBlanks  | cc |
	cc <- self currentChar.
        cc isNil ifTrue: [ ^ self ].
	[ cc notNil and: [ cc isBlank ] ] 
            whileTrue: [ cc <- self nextChar ].
	( cc = $" ) ifTrue: [ self skipComment ]
!
METHOD Parser
skipComment  | cc |
	[ cc <- self nextChar.
	  cc isNil ifTrue: [ ^ self error: 'unterminated comment'].
	  cc ~= $" ] whileTrue: [ nil ].
	self nextChar. self skipBlanks
!
METHOD Parser
lexInteger	
    | start |
    start <- index.
    [ self currentChar notNil 
        and: [ self currentChar isDigit ] ] 
            whileTrue: [ self nextChar ].

    token <- text from: start to: index - 1.

    self currentChar = $r
        ifTrue: [ self lexBaseInteger ]
!
METHOD Parser
lexBaseInteger
    | start |
    start <- index.
    self nextChar.
    [ self currentChar notNil
        and: [ self currentChar isAlphanumeric ] ]
            whileTrue: [ self nextChar ].

    token <- token + (text from: start to: index - 1)
!
METHOD Parser
lexAlnum | cc start |
	start <- index.
	[ (cc <- self nextChar) notNil and:
            [ cc isAlphanumeric or: [ cc = $: ] ] ]
			whileTrue: [ nil ].
		" add any trailing colons "
	token <- text from: start to: index - 1
!
METHOD Parser
lexBinary	| c d |
	c <- self currentChar.
	token <- c asString.
	d <- self nextChar.
        d isNil ifTrue: [ ^ nil ].
	(self charIsSyntax: c) ifTrue: [ ^ token ].
	(((d isBlank
		or: [ d isDigit])
		or: [ d isAlphabetic ])
		or: [ self charIsSyntax: d])
			ifTrue: [ ^ token ].
	token <- token + d asString.
	self nextChar
!
METHOD Parser
charIsSyntax: c
	^ ('.()[]#^$;' includes: c) or: [ c = $' ]
!
METHOD Parser
readMethodName   | name |
	self tokenIsName	" unary method "
		ifTrue: [ name <- token. self nextLex. ^ name ].
	self tokenIsBinary	" binary method "
		ifTrue: [ name <- token. self nextLex.
			self tokenIsName
				ifFalse: [ self error: 'missing argument'].
				self addArgName: token asSymbol.
				self nextLex. ^ name ].
	self tokenIsKeyword
		ifFalse: [ self error: 'invalid method header'].
	name <- ''.
	[ self tokenIsKeyword ]
		whileTrue: [ name <- name + token. self nextLex.
			self tokenIsName
				ifFalse: [ self error: 'missing argument'].
				self addArgName: token asSymbol.
				self nextLex ].
	^ name
!
METHOD Parser
addArgName: name
	((instNames includes: name)
		or: [ argNames includes: name ])
		ifTrue: [ self error: 'doubly defined argument name: ' +
			name asString].
	argNames <- argNames with: name
!
METHOD Parser
tokenIsName
	tokenType isAlphabetic ifFalse: [ ^ false ].
	^ (token at: token size) isAlphanumeric
!
METHOD Parser
tokenIsKeyword
	tokenType isAlphabetic ifFalse: [ ^ false ].
	^ (token at: token size) = $:
!
METHOD Parser
tokenIsBinary
	(((token isNil
		or: [ self tokenIsName])
		or: [ self tokenIsKeyword])
		or: [ self charIsSyntax: tokenType ]) ifTrue: [ ^ false ].
	^ true
!
METHOD Parser
readMethodVariables
	tokenType = $| ifFalse: [ ^ nil ].
	self nextLex.
	[ self tokenIsName ]
		whileTrue: [ self addTempName: token asSymbol. self nextLex ].
	tokenType = $|
		ifTrue: [ self nextLex ]
		ifFalse: [ self error: 'illegal method variable declaration']
!
METHOD Parser
addTempName: name
	(((argNames includes: name)
		or: [ instNames includes: name ] )
		or: [ tempNames includes: name ] )
		ifTrue: [ self error: 'doubly defined name '].
	tempNames <- tempNames with: name.
	maxTemps <- maxTemps max: tempNames size
!
METHOD Parser
readBody | lnum |
	lnum <- lineNum.
    ^ self bodyNodeAt: lnum statements: self readStatementList
!
METHOD Parser
readStatementList   | list |
	list <- List new.
	[ list add: self readStatement.
	  tokenType notNil and: [ tokenType = $. ] ]
		whileTrue: [ self nextLex.
			(token isNil or: [ tokenType = $] ] )
				ifTrue: [ ^ list ] ].
	^ list
!
METHOD Parser
readStatement | lnum |
	tokenType = $^
		ifTrue: [ lnum <- lineNum. self nextLex.
            ^ self returnNodeAt: lnum expression: self readExpression ].
	^ self readExpression
!
METHOD Parser
readExpression   | node lnum |
	self tokenIsName ifFalse: [ ^ self readCascade: self readTerm ].
	node <- self nameNode: token asSymbol. self nextLex.
	self tokenIsArrow
		ifTrue: [ node assignable
				ifFalse: [ self error: 'illegal assignment'].
			lnum <- lineNum.
			self nextLex.
			^ self 
                assignNodeAt: lnum 
                target: node 
                expression: self readExpression ].
	^ self readCascade: node
!
METHOD Parser
tokenIsArrow
	(token isKindOf: String) ifFalse: [ ^ false ].
	^ token = '<-'
!
METHOD Parser
readTerm   | node lnum |
	token isNil
		ifTrue: [ self error: 'unexpected end of input' ].
	tokenType = $(
		ifTrue: [ self nextLex. node <- self readExpression.
			tokenType = $)
				ifFalse: [ self error: 'unbalanced parenthesis' ].
			self nextLex. ^ node ].
	tokenType = $[ ifTrue: [ ^ self readBlock ].
	tokenType = $< ifTrue: [ ^ self readPrimitive ].
	self tokenIsName
		ifTrue: [ node <- self nameNode: token asSymbol.
			self nextLex. ^ node ].
	lnum <- lineNum.
	^ self literalNodeAt: lnum value: self readLiteral
!
METHOD Parser
nameNode: name
	" make a new name node "
	name == #super
		ifTrue: [ ^ self argumentNodeAt: lineNum position: 0 name: name ].
	(1 to: tempNames size) do: [:i |
		(name == (tempNames at: i))
			ifTrue: [ ^ self temporaryNodeAt: lineNum
				             position: i 
                             name: name ] ].
	(1 to: argNames size) do: [:i |
		(name == (argNames at: i))
			ifTrue: [ ^ self argumentNodeAt: lineNum position: i name: name ] ].
	(1 to: instNames size) do: [:i |
		(name == (instNames at: i))
			ifTrue: [ ^ self instNodeAt: lineNum position: i name: name ] ].
	^ self literalNodeAt: lineNum
		   value: (globals at: name
			               ifAbsent: [ ^ self error: 
                                         'unrecognized name: ' + name printString 
                                     ])
!
METHOD Parser
readLiteral   | node |
	tokenType = $$
		ifTrue: [ node <- self currentChar.
			self nextChar. self nextLex. ^ node ].
	tokenType isDigit
		ifTrue: [ ^ self readInteger ].
	token = '-'
		ifTrue: [ self nextLex. ^ self readInteger negated ].
	tokenType = $'
		ifTrue: [ ^ self readString ].
	tokenType = $#
		ifTrue: [ ^ self readSymbol ].
	self error: 'invalid literal: ' + token
!
METHOD Parser
readInteger  | value |
	value <- token asNumber.
	value isNil ifTrue: [ self error: 'integer expected' ].
	self nextLex.
	^ value
!
METHOD Parser
readString  | first last cc |
	first <- index.
	[ cc <- self currentChar.
	  cc isNil ifTrue: [ self error: 'unterminated string constant'].
	  cc ~= $' ] whileTrue: [ index <- index + 1 ].
	last <- index - 1.
	self nextChar = $'
		ifTrue: [ self nextChar.
			^ (text from: first to: index - 2) + self readString ].
	self nextLex.
	^ text from: first to: last
!
METHOD Parser
readSymbol   | cc |
	cc <- self currentChar.
	(cc isNil or: [ cc isBlank])
		ifTrue: [ self error: 'invalid symbol'].
	cc = $( ifTrue: [ ^ self readArray ].
	(self charIsSyntax: cc)
		ifTrue: [ self error: 'invalid symbol'].
	self nextLex.
	cc <- Symbol new: token. self nextLex.
	^ cc
!
METHOD Parser
readArray	| value |
	self nextChar. self nextLex. value <- Array new: 0.
	[ tokenType ~= $) ]
		whileTrue: [ value <- value with: self arrayLiteral ].
	self nextLex.
	^ value
!
METHOD Parser
arrayLiteral	| node |
	tokenType isAlphabetic
		ifTrue: [ node <- Symbol new: token. self nextLex. ^ node ].
	^ self readLiteral
!
METHOD Parser
readPrimitive  | num args lnum |
	lnum <- lineNum.
	self nextLex.
	num <- self readInteger.
	args <- List new.
	[ tokenType ~= $> ]
		whileTrue: [ args add: self readTerm ].
	self nextLex.
	^ self primitiveNodeAt: lnum number: num arguments: args
!
METHOD Parser
readBlock    | stmts saveTemps lnum |
	saveTemps <- tempNames.
	lnum <- lineNum.
	self nextLex.
	tokenType = $:
		ifTrue: [ self readBlockTemporaries ].
	stmts <- self readStatementList.
	tempNames <- saveTemps.
	tokenType = $]
		ifTrue: [ self nextLex.
			^ self blockNodeAt: lnum 
                   statements: stmts
				   temporaryLocation: saveTemps size ]
		ifFalse: [ self error: 'unterminated block']
!
METHOD Parser
readBlockTemporaries
	[ tokenType = $: ]
		whileTrue: [ self currentChar isAlphabetic
			ifFalse: [ self error: 'ill formed block argument'].
			self nextLex.
			self tokenIsName
				ifTrue: [ self addTempName: token asSymbol ]
				ifFalse: [ self error: 'invalid block argument list '].
			self nextLex ].
	tokenType = $|
		ifTrue: [ self nextLex ]
		ifFalse: [ self error: 'invalid block argument list ']
!
METHOD Parser
readCascade: base   | node list |
	node <- self keywordContinuation: base.
	tokenType = $;
		ifTrue: [ node <- self cascadeNodeAt: lineNum head: node.
			list <- List new.
			[ tokenType = $; ]
				whileTrue: [ self nextLex.
					list add:
						(self keywordContinuation: nil ) ].
			node list: list ].
	^ node
!
METHOD Parser
keywordContinuation: base  | receiver name args lnum |
	receiver <- self binaryContinuation: base.
	self tokenIsKeyword
		ifFalse: [ ^ receiver ].
	name <- ''.
	args <- List new.
	lnum <- lineNum.
	[ self tokenIsKeyword ]
		whileTrue: [ name <- name + token. self nextLex.
			args add:
				(self binaryContinuation: self readTerm) ].
	^ self messageNodeAt: lnum 
           receiver:  receiver 
           name:      name asSymbol 
           arguments: args
!
METHOD Parser
binaryContinuation: base | receiver name lnum |
	receiver <- self unaryContinuation: base.
	[ self tokenIsBinary]
		whileTrue: [ lnum <- lineNum.
			name <- token asSymbol. self nextLex.
			receiver <- self messageNodeAt: lnum
				             receiver:  receiver 
                             name:      name 
                             arguments:
					             (List with:
						             (self unaryContinuation: self readTerm)) ].
	^ receiver
!
METHOD Parser
unaryContinuation: base | receiver lnum |
	receiver <- base.
	[ self tokenIsName ]
		whileTrue: [ lnum <- lineNum.
			receiver <- self messageNodeAt: lnum
				             receiver:  receiver 
                             name:      token asSymbol
					         arguments: (List new).
				self nextLex ].
	^ receiver
!
METHOD Parser
bodyNodeAt: n statements: stmts
    ^ (BodyNode at: n) statements: stmts
!
METHOD Parser
returnNodeAt: n expression: expr
    ^ (ReturnNode at: n) expression: expr
!
METHOD Parser
assignNodeAt: n target: var expression: expr
    ^ (AssignNode at: n)
        target: var
        expression: expr
!
METHOD Parser
literalNodeAt: n value: val
    ^ (LiteralNode at: n) value: val
!
METHOD Parser
argumentNodeAt: n position: i name: name
    ^ (ArgumentNode at: n) position: i name: name
!
METHOD Parser
temporaryNodeAt: n position: i name: name
    ^ (TemporaryNode at: n) position: i name: name
!
METHOD Parser
instNodeAt: n position: i name: name
    ^ (InstNode at: n) position: i name: name
!
METHOD Parser
primitiveNodeAt: n number: val arguments: args
    ^ (PrimitiveNode at: n) number: val arguments: args
!
METHOD Parser
blockNodeAt: n statements: stmts temporaryLocation: i
    ^ (BlockNode at: n) statements: stmts temporaryLocation: i
!
METHOD Parser
cascadeNodeAt: n head: h
    ^ (CascadeNode at: n) head: h
!
METHOD Parser
messageNodeAt: n receiver: r name: msg arguments: args
    ^ (MessageNode at: n)
        receiver:  r
        name:      msg
        arguments: args
!
