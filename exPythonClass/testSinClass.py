import matplotlib.pyplot as plt
import sinClass

test1 = sinClass.sinWaveForm(amp = 1, endTime = 1)
test1.plotWave()

test2 = sinClass.sinWaveForm(amp = 1, freq=1, endTime = 10)
test3 = sinClass.sinWaveForm(amp = 2, freq=10, endTime = 10)

time = test2.calcDomain()
resultTest2 = test2.calcSinValue(time)
resultTest3 = test3.calcSinValue(time)

plt.plot(time, resultTest2, time, resultTest2+resultTest3)
plt.grid(True)
plt.xlabel('time')
plt.ylabel        
plt.show()
