/ eight queens exercise
+Object subclass: #NullQueen 
!NullQueen
first
	^ true
!
!NullQueen
next
	^ false
!
!NullQueen
checkRow: row column: column
	^ false
!
!NullQueen
result
	^ List new
!
+Object subclass: #Queen variables: #(row column neighbor)
!Queen
setColumn: aNumber neighbor: aQueen
	column <- aNumber.
	neighbor <- aQueen
!
!Queen
checkRow: testRow column: testColumn | columnDifference |
	columnDifference <- testColumn - column.
	(((row = testRow) or:
		[ row + columnDifference = testRow]) or:
		[ row - columnDifference = testRow])
			ifTrue: [ ^ true ].
	^ neighbor checkRow: testRow column: testColumn
!
!Queen
first
	neighbor first.
	row <- 1.
	^ self testPosition
!
!Queen
next
	^ self advance and: [ self testPosition ]
!
!Queen
advance
	(row = 8)
		ifTrue: [ neighbor next ifFalse: [ ^ false ].
			row <- 0 ].
	row <- row + 1.
	^ true
!
!Queen
testPosition
	[ neighbor checkRow: row column: column ]
		whileTrue: [ self advance ifFalse: [ ^ false ]].
	^ true
!
!Queen
result	
	^ neighbor result; addLast: row
!
+Object subclass: #Main
!Main
run	| lastQueen |
	lastQueen <- NullQueen new.
	1 to: 8 do: [:i | lastQueen <- Queen new; 
		setColumn: i neighbor: lastQueen ].
	lastQueen first.
	'got a result' print.
	lastQueen result do: [:x | x print. ' ' print ].
	Char newline print.
	[ lastQueen next ] whileTrue:
		[
	lastQueen result do: [:x | x print. ' ' print ].
	Char newline print ]
!
+Main new run
/end
