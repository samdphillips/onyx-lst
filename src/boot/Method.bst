COMMENT --- Start Method Methods ---
METHOD MetaMethod
name: n byteCodes: b literals: l stackSize: s temporarySize: ts class: c text: t
	| newMethod |
	newMethod <- self new.
	super in: newMethod at: 1 put: n.
	super in: newMethod at: 2 put: b.
	super in: newMethod at: 3 put: l.
	super in: newMethod at: 4 put: s.
	super in: newMethod at: 5 put: ts.
	super in: newMethod at: 6 put: c.
	super in: newMethod at: 7 put: t.
	^ newMethod
!
METHOD MetaMethod
flushCache
	<34>.
	self primitiveFailed
!
METHOD Method
byteCodes
	^ byteCodes
!
METHOD Method
literals
	^ literals
!
METHOD Method
text
	^ text
!
METHOD Method
name
	^ name
!
METHOD Method
stackSize
	^ stackSize
!
METHOD Method
temporarySize
	^temporarySize
!
METHOD Method
args: argNames inst: instNames temp: tempNames
	" Hook for recording symbolic debug "
!
