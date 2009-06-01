
AM_CPPFLAGS = -I/usr/include/gc
bin_PROGRAMS = onyx onyx-boot

onyx_SOURCES = interp.c new_memory.c main.c onyx-char.c
onyx_LDADD = -lgc
onyx_boot_SOURCES = imageBuilder.c onyx-char.c

data_DATA = imageSource systemImage

CLEANFILES = systemImage imageSource

imageSource_SOURCES = boot/classes.bst boot/Object.bst boot/Class.bst \
		      boot/Undefined.bst boot/Boolean.bst boot/True.bst \
		      boot/False.bst boot/Process.bst boot/Context.bst \
		      boot/Block.bst boot/Magnitude.bst boot/Symbol.bst \
		      boot/Method.bst boot/Char.bst boot/Collection.bst \
		      boot/Array.bst boot/OrderedArray.bst boot/ByteArray.bst \
		      boot/String.bst boot/List.bst boot/Dictionary.bst \
		      boot/Set.bst boot/Number.bst boot/SmallInt.bst \
		      boot/Integer.bst boot/Node.bst boot/Interval.bst \
		      boot/Link.bst boot/Association.bst boot/Tree.bst \
		      boot/File.bst boot/Parser.bst boot/ParserNode.bst \
		      boot/BodyNode.bst boot/ReturnNode.bst boot/AssignNode.bst \
		      boot/LiteralNode.bst boot/ArgumentNode.bst \
		      boot/TemporaryNode.bst boot/InstNode.bst \
		      boot/PrimitiveNode.bst boot/BlockNode.bst \
		      boot/CascadeNode.bst boot/MessageNode.bst \
		      boot/ThisContextNode.bst boot/Encoder.bst boot/MAIN.bst

imageSource: $(imageSource_SOURCES)
	cat $^ > $@

systemImage: onyx-boot imageSource
	./onyx-boot imageSource
	mv image systemImage
