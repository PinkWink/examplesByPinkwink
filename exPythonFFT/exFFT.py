import numpy as np
import matplotlib.pyplot as plt
import sinClass

test1 = sinClass.sinWaveForm(amp = 1, freq=1, endTime = 5)
test2 = sinClass.sinWaveForm(amp = 2, freq=5, endTime = 5)
test3 = sinClass.sinWaveForm(amp = 4, freq=10, endTime = 5)

t = test1.calcDomain()
resultTest1 = test1.calcSinValue(t)
resultTest2 = test2.calcSinValue(t)
resultTest3 = test3.calcSinValue(t)

Ts = test1.sampleTime 						# sampling interval
Fs = 1/Ts 									# sampling rate
t = test1.calcDomain()					 	# time vector

y = resultTest1 + resultTest2 + resultTest3

n = len(y) 									# length of the signal
k = np.arange(n)
T = n/Fs
freq = k/T 									# two sides frequency range
freq = freq[range(int(n/2))] 				# one side frequency range

Y = np.fft.fft(y)/n 						# fft computing and normalization
Y = Y[range(int(n/2))]

fig, ax = plt.subplots(2, 1)
ax[0].plot(t, y)
ax[0].set_xlabel('Time')
ax[0].set_ylabel('Amplitude')
ax[0].grid(True)
ax[1].plot(freq, abs(Y), 'r', linestyle=' ', marker='^') 					
ax[1].set_xlabel('Freq (Hz)')
ax[1].set_ylabel('|Y(freq)|')
ax[1].vlines(freq, [0], abs(Y))
ax[1].grid(True)
plt.show()