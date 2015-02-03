import numpy as np
import matplotlib.pyplot as plt

class sinWaveForm:
    def __init__(self, **kwargs) :
        self.endTime = kwargs.get('endTime', 1)
        self.sampleTime = kwargs.get('sampleTime', 0.01)
        self.amp = kwargs.get('amp', 1)
        self.freq = kwargs.get('freq', 1)
        self.startTime = kwargs.get('startTime', 0)
        self.bias = kwargs.get('bias', 0)

    def calcDomain(self) :
        return np.arange(0.0, self.endTime, self.sampleTime)

    def calcSinValue(self, time) :
        return self.amp * np.sin(2*np.pi*self.freq*time + self.startTime) + self.bias

    def plotWave(self) :
        time = self.calcDomain()
        result = self.calcSinValue(time)
    
        plt.plot(time, result)
        plt.grid(True)
        plt.xlabel('time')
        plt.ylabel('sin')
        plt.show()

if __name__ == "__main__" :
    test = sinWaveForm(amp = 2, endTime = 1)
    test.endTime = 2
    print(test.calcDomain())
    print(test.calcSinValue(test.calcDomain()))
    test.plotWave()