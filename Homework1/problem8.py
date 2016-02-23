import numpy as np
import matplotlib.pyplot as plt
from mpmath import j
from mpmath import plot


plot(lambda n: 3.0/(2*np.pi) - 1.0/(2*np.pi*(j*n)**2), [-10, 10])
plot(lambda n: 3.0/(2*np.pi) - 1.0/(2*np.pi*(j*2*n)**2), [-10, 10])
plot(lambda n: 3.0/(2*np.pi) - 1.0/(2*np.pi*(j*4*n)**2), [-10, 10])
plot(lambda n: 3.0/(2*np.pi) - 1.0/(2*np.pi*(j*(n/2.0))**2), [-10, 10])
plot(lambda n: 3.0/(2*np.pi) - 1.0/(2*np.pi*(j*(n/4.0))**2), [-10, 10])
