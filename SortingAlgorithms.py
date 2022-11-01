import sys
import numpy

arr = [61, 66, 63, 42, 41, 16, 19, 1, 3, 2]
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

# Quick Sort
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

# Counting Sort
def countingSort(arr):
    passes=0
    comps=0
    arrOut = [0 for i in range(len(arr))]
    count = [0 for i in range(100)]
    for v in arr:
        passes+=1
        count[v] += 1
    for p in range(len(count)):
        passes+=1
        count[p] += count[p-1]
    for o in range(len(arr)):
        passes+=1
        arrOut[count[arr[o]]-1] = arr[o]
        count[arr[o]] -= 1
    print("Sorted list:\t",arrOut)
    print("Passes:", passes, "\tComparisons:", comps)

# Radix Sort
def radixSort(arr):
    passes=0
    comps=0
    def radixCountSort(arr, exp):
        nonlocal passes
        arrOut = [0]*len(arr)
        count = [0]*(10)
        for v in arr:
            passes+=1
            count[(v//exp)%10] +=1
        for p in range(1,10):
            passes+=1
            count[p] += count[p-1]
        for c in range((len(arr)-1), -1, -1):
            passes+=1
            t = ((arr[c]//exp)%10)
            arrOut[count[t]-1] = arr[c]
            count[t] -= 1
        for i in range(len(arr)):
            arr[i] = arrOut[i]
    
    maxVal = max(arr)
    exp = 1
    while exp <= maxVal:
        radixCountSort(arr, exp)
        exp *= 10
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)

# Bucket Sort
def bucketSort(arr):
    passes=0
    comps=0
    def insertion(arr):
        nonlocal comps
        nonlocal passes
        for i in range(1, len(arr)):
            passes+=1
            j = i-1
            while j >= 0 and arr[i] < arr[j]:
                comps+=1
                arr[i], arr[j] = arr[j], arr[i]
    
    bucket = []
    slot = 10
    for c in range(slot):
        bucket.append([])
    for v in arr:
        passes+=1
        index = v//10
        bucket[index].append(v)
    for p in range(slot):
        insertion(bucket[p])
    x=0
    for i in range(slot):
        for j in range(len(bucket[i])):
            arr[x] = bucket[i][j]
            x+=1
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)

# Shell Sort
def shellSort(arr):
    passes=0
    comps=0
    gap = len(arr)//2
    while gap > 0:
        for i in range(gap, len(arr)):
            passes+=1
            temp = arr[i]
            j = i
            while (j >= gap and arr[j-gap] > temp):
                comps+=1
                arr[j] = arr[j-gap]
                j -= gap
            arr[j] = temp
        gap = gap//2
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)

# Cocktail Shaker Sort
def cocktailSort(arr):
    passes=0
    comps=0
    sorting = True
    while(sorting):
        passes+=1
        sorting = False
        for i in range(0, len(arr)-1):
            comps+=2
            if (arr[i] > arr[i+1]):
                arr[i], arr[i+1] = arr[i+1], arr[i]
                sorting = True
            t = len(arr)-i
            if (arr[t-2] > arr[t-1]):
                arr[t-2], arr[t-1] = arr[t-1], arr[t-2]
                sorting = True
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)

# Odd Even Sort
def oddEvenSort(arr):
    passes=0
    comps=0
    swapping = True
    while(swapping):
        passes+=1
        swapping = False
        for i in range(0, len(arr)-1, 2):
            comps+=1
            if (arr[i] > arr[i+1]): 
                arr[i], arr[i+1] = arr[i+1], arr[i]
                swapping = True
        for i in range(1, len(arr)-1, 2):
            comps+=1
            if (arr[i] > arr[i+1]):
                arr[i], arr[i+1] = arr[i+1], arr[i]
                swapping = True
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)

# Gnome Sort
def gnomeSort(arr):
    passes=0
    comps=0
    pos = 0
    while (pos < len(arr)):
        passes+=1
        if (pos == 0 or arr[pos] >= arr[pos-1]):
            pos+=1
        else:
            comps+=1
            arr[pos], arr[pos-1] = arr[pos-1], arr[pos]
            pos-=1
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)

# Tree Sort
def treeSort(arr):
    passes=0
    comps=0
    root = None
    arrOut = []
    class Node:
        def __init__(self, item=0):
            self.key = item
            self.left,self.right = None,None
    
    def buildTree(key, root):
        nonlocal comps
        comps+=1
        if (root == None): return Node(key)
        elif(key < root.key): root.left = buildTree(key, root.left)
        else: root.right = buildTree(key, root.right)
        return root
    
    def readTree(root):
        nonlocal arrOut
        nonlocal passes
        passes+=1
        if (root != None):
            readTree(root.left)
            arrOut.append(root.key)
            readTree(root.right)

    for v in arr:
        root = buildTree(v, root)
    readTree(root)
    arr = arrOut
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)
        
# Cycle Sort
def cycleSort(arr):
    passes=0
    comps=0
    for start in range(len(arr)-1):
        active = arr[start]
        pos = start
        for i in range(start+1, len(arr)):
            comps+=1
            if (arr[i] < active): pos += 1
        if (pos != start):
            while(arr[pos] == active): pos += 1
            passes+=1
            arr[pos], active = active, arr[pos]
            while pos != start:
                pos = start
                for i in range(start+1, len(arr)):
                    comps+=1
                    if (arr[i] < active): pos += 1
                while (arr[pos] == active): pos += 1
                passes+=1
                arr[pos], active = active, arr[pos]
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)

# Patience Sort
def patienceSort(arr):
    passes=0
    comps=0
    piles = []
    for i in range(len(arr)):
        passes+=1
        if (len(piles) == 0):
            temp = []
            temp.append(arr[i])
            piles.append(temp)
        else:
            highest = True
            for j in range(len(piles)):
                comps+=1
                if (arr[i] < piles[j][len(piles[j])-1]):
                    piles[j].append(arr[i])
                    highest = False
                    break
            if (highest):
                temp = []
                temp.append(arr[i])
                piles.append(temp)
    for m in range(len(arr)):
        passes+=1
        lowest = 0
        for t in range(len(piles)):
            comps+=1
            if (len(piles[t]) > 0):
                if (piles[t][len(piles[t])-1] < piles[lowest][len(piles[lowest])-1]): lowest = t
        arr[m] = piles[lowest][len(piles[lowest])-1]
        del piles[lowest][len(piles[lowest])-1]
        if (len(piles[lowest]) == 0): del piles[lowest]
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)

# Strand Sort
def strandSort(arr):
    passes=0
    comps=0
    sort = []
    def strand(arr, sort):
        nonlocal passes
        nonlocal comps
        passes+=1
        arrSub = [arr.pop(0)]
        pos = 0
        while (pos < len(arr)):
            comps+=1
            if (arr[pos] > arrSub[len(arrSub)-1]): arrSub.append(arr.pop(pos))
            pos += 1
        if (len(sort) == 0): sort.extend(arrSub)
        else:
            while (len(arrSub) > 0):
                val = arrSub.pop(0)
                for i in range(len(sort)):
                    comps+=1
                    if (sort[i] > val): sort.insert(i,val); break
                else: sort.append(val)
        if (len(arr) > 0): strand(arr, sort)

    strand(arr, sort)
    arr = sort
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)

# Comb Sort
def combSort(arr):
    passes=0
    comps=0
    gap = len(arr)
    unsorted = True
    while (gap != 1 or unsorted):
        passes+=1
        gap = int((gap*10)/13)
        if (gap < 1): gap = 1
        unsorted = False
        for i in range(len(arr)-gap):
            comps+=1
            if (arr[i] > arr[i+gap]):
                arr[i], arr[i+gap] = arr[i+gap], arr[i]
                unsorted = True
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)

# Pigeon Hole Sort
def pigeonHoleSort(arr):
    passes=0
    comps=0
    arrMin = min(arr)
    arrMax = max(arr)
    arrRange = (arrMax-arrMin)+1
    values = [0]*arrRange
    for v in arr: values[v-arrMin] += 1; passes+=1
    m = 0
    for i in range(len(values)):
        comps+=1
        while (values[i] > 0): 
            comps+=1
            arr[m] = i+arrMin
            values[i] -= 1
            m += 1
    print("Sorted list:\t",arr)
    print("Passes:", passes, "\tComparisons:", comps)

# Postman Sort
def postManSort(arr):
    passes=0
    comps=0
    sig = 1
    def sortSig(arr, sig):
        nonlocal passes
        nonlocal comps
        passes+=1
        sepArr = []
        for val in arr:
            isHighest = True
            pos = 0
            while (isHighest and pos < len(sepArr)):
                comps+=1
                if (sepArr[pos][0]//sig == val//sig):
                    sepArr[pos].append(val)
                    isHighest = False
                if (sepArr[pos][0]//sig > val//sig): 
                    sepArr.insert(pos,[])
                    sepArr[pos].append(val)
                    isHighest = False
                pos+=1
            if (isHighest): 
                sepArr.append([])
                sepArr[len(sepArr)-1].append(val)
        arr = []
        for i in range(len(sepArr)): 
            if (sig > 1):
                sepArr[i] = sortSig(sepArr[i], sig//10)
                arr.extend(sepArr[i])
            else:
                arr.extend(sepArr[i])
        return arr

    for val in arr: 
        digits = 1
        while (val/digits > 10):
            digits *= 10
        if (digits > sig): sig = digits
    arr = sortSig(arr, sig)
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

# print("\nIterative Heap Sort")
# iterativeHeapSort(arr.copy())

# print("\nCounting Sort")
# countingSort(arr.copy())

# print("\nRadix Sort")
# radixSort(arr.copy())

# print("\nBucket Sort")
# bucketSort(arr.copy())

# print("\nShell Sort")
# shellSort(arr.copy())

# print("\nCocktail Sort")
# cocktailSort(arr.copy())

# print("\nOdd Even Sort")
# oddEvenSort(arr.copy())

# print("\nGnome Sort")
# gnomeSort(arr.copy())

# print("\nTree Sort")
# treeSort(arr.copy())

# print("\nCycle Sort")
# cycleSort(arr.copy())

# print("\nPatience Sort")
# patienceSort(arr.copy())

# print("\nStrand Sort")
# strandSort(arr.copy())

# print("\nComb Sort")
# combSort(arr.copy())

# print("\nPigeon Hole Sort")
# pigeonHoleSort(arr.copy())

print("\nPostman Sort")
postManSort(arr.copy())