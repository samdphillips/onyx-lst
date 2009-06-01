COMMENT --- Start Association Methods ---
METHOD MetaAssociation
key: k
		"key is set once, value is resettable"
	^ self in: self new at: 1 put: k
!
METHOD MetaAssociation
key: k value: v | ret |
		"key is set once, value is resettable"
	ret <- self new.
	self in: ret at: 1 put: k.
	self in: ret at: 2 put: v.
	^ ret
!
METHOD Association
= k
		"compare both with keys and associations"
	(k class == Association)
		ifTrue: [ ^ key = k key ]
		ifFalse: [ ^ key = k ]
!
METHOD Association
< k
		"compare both with keys and associations"
	(k class == Association)
		ifTrue: [ ^ key < k key ]
		ifFalse: [ ^ key < k ]
!
METHOD Association
value: v
	value <- v
!
METHOD Association
value
	^ value
!
METHOD Association
key
	^ key
!
METHOD Association
hash
	^ key hash
!
METHOD Association
printString
	^ '(' + key printString + ' -> ' + value printString + ')'
!
