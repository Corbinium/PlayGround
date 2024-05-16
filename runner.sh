while IFS= read -r line
do
    echo -n ".param S=table(i" >> tmp3.txt
    arr=($line)
    for i in {0..30}
    do
        echo -n ",$i,${arr[i]}" >> tmp3.txt
    done
    echo ")" >> tmp3.txt
done < tmp2.txt