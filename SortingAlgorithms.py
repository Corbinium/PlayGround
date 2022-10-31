import sys
import numpy

arr = [7, 6, 5, 4, 3, 2, 1]
arr = []
random = numpy.random.randint(0,100,7)
for i in range(0, len(random)): arr.append(random[i])


print("Unsorted list:\t", arr, "\n")

# Selection Sort
def selectionSort(arr):
    passes = 0
    comps = 0
    for i in range(len(arr)):
        lowest = i
        passes+=1
        for j in range(i+1, len(arr)):
            comps+=1
            if (arr[j] < arr[lowest]): lowest = j
        arr[i], arr[lowest] = arr[lowest], arr[i]
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)

# Bubble Sort
def bubbleSort(arr):
    passes=0
    comps=0
    for x in range(len(arr)):
        changes = 0
        passes+=1
        for i in range(len(arr)-1):
            comps+=1
            if (arr[i] > arr[i+1]): 
                arr[i], arr[i+1] = arr[i+1], arr[i]
                changes += 1
        if (changes == 0): break
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)

# Insertion Sort
def insertionSort(arr):
    passes=0
    comps=0
    for i in range(0, len(arr)):
        passes+=1
        for j in reversed(range(1, i+1)):
            comps+=1
            if (arr[j] < arr[j-1]): arr[j], arr[j-1] = arr[j-1], arr[j]
            else: break
        print(arr)
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)

# Merge Sort
def MergeSort(arr):
    mergePasses = 0
    mergeComps = 0
    def merge(arr):
        nonlocal mergePasses
        mergePasses+=1
        if (len(arr) > 1):
            mid = len(arr)//2
            arrL = arr[:mid]
            arrR = arr[mid:]

            merge(arrL)
            merge(arrR)
            L = R = M = 0
            while(L < len(arrL) and R < len(arrR)):
                nonlocal mergeComps
                mergeComps+=1
                if (arrL[L] <= arrR[R]):
                    arr[M] = arrL[L]
                    L += 1
                else:
                    arr[M] = arrR[R]
                    R += 1
                M += 1
            while (L < len(arrL)):
                arr[M] = arrL[L]
                L += 1
                M += 1
            while (R < len(arrR)):
                arr[M] = arrR[R]
                R += 1
                M += 1
    
    merge(arr)
    print("Sorted list:\t",arr)
    print("Passes:", mergePasses, "\tComparisons:", mergeComps)

#Quick Sort
def quickSort(arr):
    passes=0
    comps=0
    def sort(arr, low, high):
        nonlocal passes
        passes+=1
        def partition(arr, low, high):
            nonlocal comps
            piv = arr[high]
            pos = low-1
            for s in range(low, high):
                comps+=1
                if (arr[s] < piv): 
                    pos += 1
                    arr[pos], arr[s] = arr[s], arr[pos]
            pos += 1
            arr[pos], arr[high] = arr[high], arr[pos]
            return pos
    
        if(low < high):
            piv = partition(arr, low, high)
            sort(arr, low, piv-1)
            sort(arr, piv+1, high)
    
    sort(arr, 0, len(arr)-1)
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)

# Heap Sort
def heapSort(arr):
    passes=0
    comps=0
    def heapify(arr, n, p):
        nonlocal comps
        comps+=1
        largest = p
        c1 = p*2+1
        c2 = p*2+2
        if (c1 < n and arr[largest] < arr[c1]):
            largest = c1
        if (c2 < n and arr[largest] < arr[c2]):
            largest = c2
        if (largest != p):
            arr[largest], arr[p] = arr[p], arr[largest]
            heapify(arr, n, largest)

    for p in range(len(arr)//2-1, -1, -1):
        heapify(arr, len(arr), p)
        passes+=1
    for n in range(len(arr)-1, 0, -1):
        arr[n], arr[0] = arr[0], arr[n]
        heapify(arr, n, 0)
        passes+=1
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)

# Iterative Heap Sort
def iterativeHeapSort(arr):
    passes=0
    comps=0
    for current in range(len(arr)):
        passes+=1
        c = current
        p = int((current-1)/2)
        while(arr[c] > arr[p]):
            comps+=1
            arr[c], arr[p] = arr[p], arr[c]
            c = p
            p = int((c-1)/2)
    for t in range(len(arr)-1, 0, -1):
        passes+=1
        arr[0], arr[t] = arr[t], arr[0]
        p = 0
        c = p*2+1
        while c < t:
            comps+=1
            if (c < (t-1) and arr[c] < arr[c+1]): c+=1
            if (arr[p] < arr[c]): arr[c], arr[p] = arr[p], arr[c]
            p = c
            c = p*2+1
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)




#################################################################################
# print("\nSelection Sort")
# selectionSort(arr.copy())

# print("\nBubble Sort")
# bubbleSort(arr.copy())

# print("\nInsertion Sort")
# insertionSort(arr.copy())

# print("\nMerge Sort")
# MergeSort(arr.copy())

# print("\nQuick Sort")
# quickSort(arr.copy())

# print("\nHeap Sort")
# heapSort(arr.copy())

print("\nIterative Heap Sort")
iterativeHeapSort(arr.copy())