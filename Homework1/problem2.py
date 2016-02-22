import numpy as np
import matplotlib.pyplot as plt


# problem 2
class Function:
    def __init__(self, x_axis, y_axis):
        self.xAxis = x_axis
        self.yAxis = y_axis


def length_of_convolution(input_function, transfer_function):
    return len(input_function.xAxis) + len(transfer_function.xAxis) - 1


def print_convolution(input_function, transfer_function, output_function, label):
    plt.figure("Graph for {:s}".format(label))
    plt.subplot(2, 2, 1)
    plt.title("Input of {:s}".format(label))
    plt.plot(input_function.xAxis, input_function.yAxis, '-o', label='Input')
    plt.xlabel("Integer")
    plt.ylabel("Power")
    plt.legend(loc=0, fontsize=18)
    plt.subplot(2, 2, 2)
    plt.title("Transfer function h[n]")
    plt.plot(transfer_function.xAxis, transfer_function.yAxis, '-o', label='Transfer Function')
    plt.xlabel("Integer")
    plt.ylabel("Power")
    plt.legend(loc=0, fontsize=18)
    plt.subplot(2, 2, 3)
    plt.title("Output {:s}".format(label))
    plt.plot(output_function.xAxis, output_function.yAxis, '-o', label='Output')
    plt.xlabel("Integer")
    plt.ylabel("Power")
    plt.legend(loc=0, fontsize=18)
    plt.savefig("Problem_2_{:s}.tiff".format(label))


input_x = Function(np.array(np.arange(1, 5 + 1, 1)), np.array(np.ones(5)))
transferFunction = input_x

# i)
output_w = Function(np.array(np.arange(1, length_of_convolution(input_x, transferFunction) + 1, 1)),
                    np.convolve(input_x.yAxis, transferFunction.yAxis))
print_convolution(input_x, transferFunction, output_w, "w[n]=x[n]*h[n]")

# ii)
output_y = Function(np.array(np.arange(1, length_of_convolution(output_w, transferFunction)+1, 1)),
                    np.convolve(output_w.yAxis, transferFunction.yAxis))
print_convolution(output_w, transferFunction, output_y, "y[n]=w[n]*h[n]")

# iii)
output_z = Function(np.array(np.arange(1, length_of_convolution(output_y, transferFunction)+1, 1)),
                    np.convolve(output_y.yAxis, transferFunction.yAxis))
print_convolution(output_y, transferFunction, output_z, "z[n]=y[n]*h[n]")










