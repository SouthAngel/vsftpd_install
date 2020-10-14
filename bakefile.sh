#!/bin/bash

asets=""
sfile=""
tfile=""
aags=()

endscript(){
    unset sfile
    unset tfile
    unset asets
    unset aags
    exit
}

for e in $@
do
    if [ ${e#-} == $e ]
    then
        aags[${#aags[@]}]+=${e}
    else
        asets+=${e#-}
    fi
done

if [ ${#aags[@]} -lt 1 ]
then
    echo "ERROR:Args is empty"
    endscript
fi

_copyfile(){
    if [[ "$3" == "-f" ]]
    then
        cp -f $1 $2
    else
        if [ -e $2 ]
        then
            echo "FAILED: Target file is exists '$2'"
        else
            cp $1 $2
        fi
    fi
}

if [[ "$asets" == *"u"* ]]
then
    if [[ "${aags[0]}" == *".bake" ]]
    then
        sfile=${aags[0]}
        tfile=${aags[0]:0:${#aags[0]}-5}
    else
        sfile="${aags[0]}.bake"
        tfile="${aags[0]}"
    fi
    echo "Unbake file from '$sfile' to '$tfile'"
    if [[ "$asets" == *"f"* ]]
    then
        _copyfile "$sfile" "$tfile" "-f"
    else
        _copyfile "$sfile" "$tfile" "-n"
    fi
else
    sfile=${aags[0]}
    tfile="${aags[0]}.bake"
    echo "Bake file '${aags[0]}' to '$tfile'"
    if [[ "$asets" == *"f"* ]]
    then
        _copyfile "$sfile" "$tfile" "-f"
    else
        _copyfile "$sfile" "$tfile" "-n"
    fi
fi

endscript



