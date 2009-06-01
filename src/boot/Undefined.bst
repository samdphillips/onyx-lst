COMMENT --- Start Undefined Methods ---
METHOD MetaUndefined
new
	" there is only one nil object "
	^ nil
!
METHOD Undefined
printString
	^ 'nil'
!
METHOD Undefined
isNil
	" yes, we are nil "
	^ true
!
METHOD Undefined
notNil
	" no, we are not not-nil "
	^ false
!
METHOD Undefined
main	| command |
	" main execution loop "
	[ '-> ' print. command <- String input. command notNil ]
		whileTrue: [ command isEmpty
			ifFalse: [ command doIt printNl ] ]
!
