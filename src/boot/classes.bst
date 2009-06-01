COMMENT
COMMENT         Source for the initial image
COMMENT
COMMENT         must be compiled by the image builder
COMMENT 
COMMENT-----------------------------------------------------------
COMMENT RAWCLASS name   instanceOf subclassOf  (instance variable names)
COMMENT  or... CLASS name subclassOf (instance vars)
COMMENT RAWCLASS doesn't automatically build Meta class; CLASS does
COMMENT-----------------------------------------------------------
COMMENT         The strange circular world at the beginning
COMMENT RAWCLASS Object MetaObject nil
RAWCLASS Class      MetaClass Object      name parentClass methods size variables
RAWCLASS MetaObject Class     Class
RAWCLASS MetaClass  Class     MetaObject
COMMENT--------------------------------------------------------
COMMENT-------then, the remaining classes in the initial image
COMMENT----------------------------
CLASS Undefined         Object
CLASS Boolean           Object
CLASS True              Boolean
CLASS False             Boolean
CLASS Process           Object          context state result
CLASS Context           Object          method arguments temporaries stack bytePointer stackTop previousContext
CLASS Block             Context         argumentLocation creatingContext oldBytePointer exceptionHandler
CLASS Exception         Object          messageText tag signalledContext handlerContext
CLASS Method            Object          name byteCodes literals stackSize temporarySize class text
CLASS Magnitude         Object
RAWCLASS MetaSymbol     Class           MetaMagnitude     symbols
RAWCLASS Symbol         MetaSymbol      Magnitude
RAWCLASS MetaChar       Class           MetaMagnitude     chars
RAWCLASS Char           MetaChar        Magnitude
CLASS Collection        Magnitude
CLASS List              Collection      elements
CLASS Dictionary        Collection      keys values
CLASS Array             Collection
CLASS OrderedArray      Array
CLASS ByteArray         Array
COMMENT
COMMENT Not sure what is up with this one?
CLASS MetaString        Class           MetaArray
CLASS String            Array
CLASS Set               Collection      members growth
CLASS IdentitySet       Set
CLASS Number            Magnitude
CLASS Integer           Number
CLASS SmallInt          Number
RAWCLASS MetaSmallInt   Class           MetaNumber seed
RAWCLASS SmallInt       MetaSmallInt    Number
CLASS Link              Object          value next
CLASS Node              Object          value left right
CLASS Interval          Collection      low high step
CLASS File              Object          fileID
CLASS Association       Magnitude       key value
CLASS Tree              Collection      root
COMMENT ---------- Classes having to do with parsing ------------
CLASS Parser Object text index tokenType token argNames tempNames instNames maxTemps errBlock lineNum
CLASS ParserNode Object lineNum
CLASS Encoder Object name byteCodes index literals stackSize maxStack
CLASS BodyNode ParserNode statements
CLASS ReturnNode ParserNode expression
CLASS AssignNode ParserNode target expression
CLASS LiteralNode ParserNode value
CLASS ArgumentNode ParserNode position
CLASS TemporaryNode ParserNode position
CLASS InstNode ParserNode position
CLASS PrimitiveNode ParserNode number arguments
CLASS BlockNode ParserNode statements temporaryLocation
CLASS CascadeNode ParserNode head list
CLASS MessageNode ParserNode receiver name arguments
CLASS ThisContextNode ParserNode
COMMENT
COMMENT ---------- method bodies ------------
COMMENT
