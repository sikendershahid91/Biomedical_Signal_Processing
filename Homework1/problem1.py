import numpy as np
import matplotlib.pyplot as plt
from operator import neg


# problem1
def print_scatter_plot(x_axis, y_axis, label):
    plt.figure()
    plt.title(label)
    plt.xlabel("Integers")
    plt.ylabel("Power")
    plt.scatter(x_axis, y_axis, s=25, c='b', label='{:s}'.format(label))
    plt.legend(loc=0, fontsize=18)
    plt.savefig("Problem_1_{:s}.tiff".format(label))

# i)
n = np.array(np.arange(-1, 2+1, 1))
input_x = np.array([1, 2, 3, 1])
print_scatter_plot(n, input_x, "x[n]")

# ii)
plt.subplot(3, 2, 2)
print_scatter_plot(neg(n), input_x, "x[-n]")

# iii)
output_y = input_x
output_n = n-2
print_scatter_plot(output_n, output_y, "y[n]=x[n-2]")

# iv)
output_n = n+2
print_scatter_plot(output_n, output_y, "y[n]=x[n+2]")

# v)
output_n = n/2.0
print_scatter_plot(output_n, output_y, "y[n]=x[n_divided_2]")

# vi)
output_n = n*2
print_scatter_plot(output_n, output_y, "y[n]=x[2n]")



