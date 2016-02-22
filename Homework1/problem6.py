import numpy as np
import matplotlib.pylab as plt


frequency = [8, 16, 64, 224, 240, 248]
fs = 256
t = np.array(np.arange(0, 2, (1.0/fs)))

for f in frequency:
    plt.plot(t, np.cos(2*np.pi*t*f))
    plt.title("Graph for f = {:d}".format(f))
    plt.xlabel("Time(sec)")
    plt.ylabel("Power")
    plt.ylim([-1.5, 1.5])
    plt.savefig("Problem_6_f={:d}.tiff".format(f))


