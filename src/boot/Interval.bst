COMMENT --- Start Interval Methods ---
METHOD MetaInterval
from: l to: h step: s | newInterval |
	newInterval <- self in: self new at: 1 put: l.
	self in: newInterval at: 2 put: h.
	self in: newInterval at: 3 put: s.
	^ newInterval
!
METHOD Interval
do: aBlock	| current |
	current <- low.
	(step < 0)
		ifTrue: [
			[ current >= high ] whileTrue:
				[ aBlock value: current.
				current <- current + step ] ]
		ifFalse: [
			[ current <= high ] whileTrue:
				[ aBlock value: current.
				current <- current + step ] ]
!
METHOD Interval
low: l
	low <- l
!
METHOD Interval
high: h
	high <- h
!
METHOD Interval
low
	^ low
!
METHOD Interval
high
	^ high
!
METHOD Interval
includes: val
	" Check within range first "
	((val < low) or: [val > high]) ifTrue: [ ^ false ].
	" Then check if in equivalence class of interval "
	^ ((val - low) rem: step) = 0
!
METHOD Interval
printString | s |
	s <- (self class printString) + ' <' +
		low printString + '..' + high printString.
	(step ~= 1) ifTrue: [ s <- s + ' by ' + step printString ].
	^ s + '>'
!
METHOD Interval
atRandom | ret |
	" Return a random element from our sequence "
	ret <- (SmallInt atRandom) rem: ((high - low + 1) quo: step).
	^ low + (ret * step)
!
