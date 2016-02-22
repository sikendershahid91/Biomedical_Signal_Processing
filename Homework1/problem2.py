import numpy as np
import matplotlib.pyplot as plt


# problem 2
class Function:
    def __init__(self, x_axis, y_axis):
        self.xAxis = x_axis
        self.yAxis = y_axis


def length_of_convolution(input_function, transfer_function):
    return len(input_function.xAxis) + len(transfer_function.xAxis) - 1


def print_convolution(input_function, transfer_function, output_function):
    # save a convolution plot and also return new convoluted product
    pass


input_x = Function(np.array(np.arange(1, 5 + 1, 1)), np.array(np.ones(5)))
transferFunction = input_x

# i)
output_w = Function(np.array(np.arange(1, length_of_convolution(input_x, transferFunction) + 1, 1)),
                    np.convolve(input_x.yAxis, transferFunction.yAxis))
print_convolution(input_x, transferFunction, output_w)

# ii)
output_y = Function(np.array(np.arange(1, length_of_convolution(output_w, transferFunction)+1, 1)),
                    np.convolve(output_w.yAxis, transferFunction.yAxis))
print_convolution(output_w, transferFunction, output_y)

# iii)
output_z = Function(np.array(np.arange(1, length_of_convolution(output_y, transferFunction)+1, 1)),
                    np.convolve(output_y.yAxis, transferFunction.yAxis))
print_convolution(output_y, transferFunction, output_z)










