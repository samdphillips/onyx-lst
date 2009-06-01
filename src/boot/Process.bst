COMMENT --- Start Process Methods ---
METHOD Process
doExecute: ticks
	<6 self ticks>
!
METHOD Process
context: aContext
	context <- aContext
!
METHOD Process
context
	^ context
!
METHOD Process
execute | r |
	r <- self doExecute: 0.
	(r = 3) ifTrue: [
		" Note: state field is filled in with arguments on error "
		(state at: 1) print. ' (class ' print.
		(state at: 1) class print. ') ' print.
		'does not understand: ' print.  result printNl
	].
	(r = 4) ifTrue: [ ^ result ]
		ifFalse: [ 'Backtrace:' printNl.
			context backtrace. ^ nil ]
!
