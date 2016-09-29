#!/bin/local/bin/python2.7

import matplotlib
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np

img=mpimg.imread("cat.png")
imgplot = plt.imshow(img)
plt.show()
plt.savefig("cat_out.png")

