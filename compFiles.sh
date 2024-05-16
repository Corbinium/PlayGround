FILE1='objects/newMembers2.txt'
FILE2='objects/hasMinister.txt'

for o1 in $(cat $FILE1)
do
    for o2 in $(cat $FILE2)
    do
        if [[ $(echo $o1 | cut -d '_' -f 2 | cut -d '-' -f 1) == $(echo $o2 | cut -d '_' -f 1 | cut -d '-' -f 1) ]]
        then
            if [[ $(echo $o1 | cut -d '_' -f 1 | cut -d '-' -f 1) == $(echo $o2 | cut -d '_' -f 2 | cut -d '-' -f 1) ]]
            then
                echo "$o1 : $o2"
            else
                echo "    $o1 : $o2"
            fi
        fi
    done
done