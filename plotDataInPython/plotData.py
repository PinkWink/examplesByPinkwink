import re
import numpy as np
import matplotlib.pyplot as plt

t = []
y1 = []
y2 = []
y3 = []
y4 = []

data = open('plotData.txt')

for eachLine in data:
	readTmp = data.readline()
	tmp = [float(tmpLine) for tmpLine in re.split('\t', readTmp)]

	t.append(tmp[0])
	y1.append(tmp[1])
	y2.append(tmp[2])
	y3.append(tmp[3])
	y4.append(tmp[4])

data.close()

plt.plot(t, [i*180/np.pi for i in y1],
	t, [i*180/np.pi for i in y2],
	t, [i*180/np.pi for i in y3],
	t, [i*180/np.pi for i in y4])
plt.grid(True)
plt.xlabel('time')
plt.legend(('sin', 'cos', 'sin+cos', 'sin*cos'))
plt.axis([0, 10, -120, 120])
plt.show()