FILE1='objects/perspectiveElders.txt'
FILE2='objects/needsMinister.txt'

for o1 in $(cat $FILE1)
do
    for o2 in $(cat $FILE2)
    do
        if [[ $o1 == $o2 ]]
        then
            echo "$o1 : $o2"
        fi
    done
done