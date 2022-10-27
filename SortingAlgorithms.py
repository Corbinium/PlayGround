import sys
args = [100, 15, 76, 22, 9, 53, 31]

print("unsorted list:\t", args)

# Selection Sort
for i in range(len(args)):
    lowest = i
    for j in range(i+1, len(args)):
        if (args[j] < args[lowest]): lowest = j
    args[i], args[lowest] = args[lowest], args[i]

print("Sorted list:\t", args)

    