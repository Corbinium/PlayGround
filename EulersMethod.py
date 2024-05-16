import math


def f(x, t):
    return 32-1.6*x

def y(t):
    return -1/(math.log(t) - 1)

def eulersMethod(step, x0, t0, tf):
    print("Euler's Method")
    n = int((tf - t0)/step) + 1
    x = x0
    t = t0
    a = x0
    for i in range(n):
        # print(str(t) + "\t" + str(x) + "\t" + str(a) + "\t" + str(round(abs(a-x)/a*100, 1)) + "%")
        # print(str(x) + "\t" + str(round(abs(a-x)/a*100, 1)) + "%")
        print(str(t) + "\t" + str(x))
        x = round(x + step*f(x, t), 4)
        t = round(t + step, 4)
        a = round(y(t), 4)

eulersMethod(0.005, 0, 0, 2)