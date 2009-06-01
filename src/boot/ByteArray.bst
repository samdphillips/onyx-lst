COMMENT --- Start ByteArray Methods ---
METHOD MetaByteArray
new: size
	<20 self size>
!
METHOD ByteArray
basicAt: index
	<21 self index>
	^nil
!
METHOD ByteArray
at: index
	<21 self index>
	(self includesKey: index) ifFalse: [ self badIndex ].
	self primitiveFailed
!
METHOD ByteArray
at: index ifAbsent: exceptionBlock
	<21 self index>
	exceptionBlock value
!
METHOD ByteArray
at: index put: aValue
	<22 aValue self index>
	(self includesKey: index) ifFalse: [ self badIndex ].
	self primitiveFailed
!
METHOD ByteArray
asString | str sz |
	sz <- self size.
	str <- String new: sz.
	1 to: sz do: [:i| str at: i put: ((self at: i) asChar)].
	^ str
!
