
uu () { uuidgen -r | sed 's/-//g'; }
uudir () { echo "$1" | sed 's/^\(..\).*$/\1/'; }
uubase () { echo "$1" | sed 's/^..\(.*\)$/\1/'; }

grep -v '^ \*$' $1 |
    while read DESC; do
        UU="`uu`"
        DIR="new/`uudir $UU`"
        FILE="$DIR/`uubase $UU`"
        [ -d "$DIR" ] || mkdir -p $DIR
        echo -e "Description: $DESC" > $FILE
    done
