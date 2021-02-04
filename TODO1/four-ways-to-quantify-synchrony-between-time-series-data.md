> * 原文地址：[Four ways to quantify synchrony between time series data](https://towardsdatascience.com/four-ways-to-quantify-synchrony-between-time-series-data-b99136c4a9c9)
> * 原文作者：[Jin Hyun Cheong](https://medium.com/@jinhyuncheong)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/four-ways-to-quantify-synchrony-between-time-series-data.md](https://github.com/xitu/gold-miner/blob/master/TODO1/four-ways-to-quantify-synchrony-between-time-series-data.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[zhmhhu](https://github.com/zhmhhu)

# 时间序列数据间量化同步的四种方法

> 用于计算同步指标的示例代码和数据包括：皮尔逊相关，时间滞后互相关，动态时间扭曲和瞬时相位同步。

![Airplanes flying in synchrony, photo by [Gabriel Gusmao](https://unsplash.com/@gcsgpp?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8544/0*R3l4mQ_ZMwLSqqkE)

在心理学当中，人与人之间的同步性是能提供社会动态和潜在社交产出的重要信息。它可以体现于众多领域，包括肢体动作（[Ramseyer & Tschacher, 2011](https://s3.amazonaws.com/academia.edu.documents/32743702/Nonverbal_synchrony_in_psychotherapy_Coordinated_body_movement_reflects_relationship_quality_and_out.pdf?AWSAccessKeyId=AKIAIWOWYYGZ2Y53UL3A&Expires=1557726122&Signature=bv5tXK0IqERSosMJUm4Rz9%2F71w4%3D&response-content-disposition=inline%3B%20filename%3DNonverbal_synchrony_in_psychotherapy_Coo.pdf)）、面部表情（[Riehle, Kempkensteffen, & Lincoln, 2017](https://link.springer.com/article/10.1007/s10919-016-0246-8)）、瞳孔的扩张（[Kang & Wheatley, 2015](https://www.dropbox.com/s/8sfzjaqqkb6996h/Pupils_ConscAttn_CC2015.pdf?dl=0)）以及神经信号（[Stephens, Silbert, & Hasson, 2010](https://docs.wixstatic.com/ugd/b75639_82d46e0fa03a4f9290835c5db3888b8c.pdf)）。无论如何，**同步性**可以提供多种的意义，同时，量化两个信号的同步性也有很多方法。

在本篇文章中，我调研了一些最常用的同步指标的利弊，并衡量了包括：皮尔逊相关，时间滞后互相关（TLCC）以及加窗的 TLCC，动态时间扭曲和瞬时相位同步这几种技术。为了更好的说明，同步指标会使用样本数据计算，样本数据是一段三分钟且包含两个参与者对话的视频，我们将从中提取面部微笑表情（下图是一个截屏）。为了让你能更好的跟上文章的内容，可以免费下载[从样本中提取的面部数据](https://gist.github.com/jcheong0428/c6d6111ee1b469cf39683bd70fab1c93)以及包括了所有示例代码的[Jupyter 笔记](https://gist.github.com/jcheong0428/4a74f801e770c6fdb08e81a906902832)。

### 目录

1. 皮尔逊相关
2. 时间滞后互相关（TLCC）以及加窗的 TLCC
3. 动态时间扭曲（DTW）
4. 瞬时相位同步

![Sample data is the smiling facial expression between two participants having a conversation.](https://cdn-images-1.medium.com/max/2600/1*YyIlN7rspyQmKpHXF67-zQ.png)

***

## 1. 皮尔逊相关 —— 最简单也是最好的方法

[皮尔逊相关](https://en.wikipedia.org/wiki/Pearson_correlation_coefficient)可以衡量两个连续信号如何随时间共同变化，并且可以以数字 -1（负相关）、0（不相关）和 1（完全相关）表示出它们之间的线性关系。它很直观，容易理解，也很好解释。但是当使用皮尔逊相关的时候，有两件事情需要注意，它们分别是：第一，异常数据可能会干扰相关评估的结果；第二，它假设数据都是[同方差](https://en.wikipedia.org/wiki/Homoscedasticity)的，这样的话，数据方差在整个数据范围内都是同质的。通常情况下，相关性是全局同步性的快照测量法。所以，它不能提供关于两个信号间方向性的信息，例如，哪个信号是引导信号，哪个信号是跟随信号。

很多包都应用了皮尔逊相关，包括 Numpy、Scipy 和 Pandas。如果你的数据中包含了空值或者缺失值，Pandas 中的相关性方法将会在计算前把这些行丢弃，而如果你想使用 Numpy 或者 Scipy 对于皮尔逊相关的应用，你则必须手动清除掉这些数据。

如下的代码加载的就是样本数据（它和代码位于同一个文件夹下），并使用 Pandas 和 Scipy 计算皮尔逊相关，然后绘制出了中值滤波的数据。

```Python
import pandas as pd
import numpy as np
%matplotlib inline
import matplotlib.pyplot as plt
import seaborn as sns
import scipy.stats as stats

df = pd.read_csv('synchrony_sample.csv')
overall_pearson_r = df.corr().iloc[0,1]
print(f"Pandas computed Pearson r: {overall_pearson_r}")
# 输出：使用 Pandas 计算皮尔逊相关结果的 r 值：0.2058774513561943

r, p = stats.pearsonr(df.dropna()['S1_Joy'], df.dropna()['S2_Joy'])
print(f"Scipy computed Pearson r: {r} and p-value: {p}")
# 输出：使用 Scipy 计算皮尔逊相关结果的 r 值：0.20587745135619354，以及 p-value：3.7902989479463397e-51

# 计算滑动窗口同步性
f,ax=plt.subplots(figsize=(7,3))
df.rolling(window=30,center=True).median().plot(ax=ax)
ax.set(xlabel='Time',ylabel='Pearson r')
ax.set(title=f"Overall Pearson r = {np.round(overall_pearson_r,2)}");
```

![](https://cdn-images-1.medium.com/max/2000/1*90Wv5LqTNoLqQE23P1KeGA.png)

再次重申，所有的皮尔逊 r 值都是用来衡量**全局**同步的，它将两个信号的关系精简到了一个值当中。尽管如此，使用皮尔逊相关也有办法观察每一刻的状态，即**局部**同步性。计算的方法之一就是测量信号局部的皮尔逊相关，然后在所有滑动窗口重复该过程，直到所有的信号都被窗口覆盖过。由于可以根据你想要重复的次数任意定义窗口的宽度，这个结果会因人而异。在下面的代码中，我们使用 120 帧作为窗口宽度（4 秒左右），然后在下图展示出我们绘制的每一刻的同步结果。

```Python
# 设置窗口宽度，以计算滑动窗口同步性
r_window_size = 120
# 插入缺失值
df_interpolated = df.interpolate()
# 计算滑动窗口同步性
rolling_r = df_interpolated['S1_Joy'].rolling(window=r_window_size, center=True).corr(df_interpolated['S2_Joy'])
f,ax=plt.subplots(2,1,figsize=(14,6),sharex=True)
df.rolling(window=30,center=True).median().plot(ax=ax[0])
ax[0].set(xlabel='Frame',ylabel='Smiling Evidence')
rolling_r.plot(ax=ax[1])
ax[1].set(xlabel='Frame',ylabel='Pearson r')
plt.suptitle("Smiling data and rolling window correlation")
```

![Sample data on top, moment-to-moment synchrony from moving window correlation on bottom.](https://cdn-images-1.medium.com/max/2000/1*NfwPdnOptoSWQDSQHfUlNg.png)

总的来说，皮尔逊相关是很好的入门学习教程，它提供了一个计算全局和局部同步性的很简单的方法。但是，它不能提供信号动态信息，例如哪个信号先出现，而这个可以用互相关来衡量。

## 2. 时间滞后互相关 —— 评估信号动态性

时间滞后互相关（TLCC）可以定义两个信号之间的方向性，例如引导-追随关系，在这种关系中，引导信号会初始化一个响应，追随信号则重复它。还有一些其他方法可以探查这类关系，包括[格兰杰因果关系](https://en.wikipedia.org/wiki/Granger_causality)，它常用于经济学，但是要注意这些仍然不一定能反映真正的因果关系。但是，通过查看互相关，我们还是可以提取出哪个信号首先出现的信息。

![[http://robosub.eecs.wsu.edu/wiki/ee/hydrophones/start](http://robosub.eecs.wsu.edu/wiki/ee/hydrophones/start)](https://cdn-images-1.medium.com/max/2000/1*mWsGTGVdAsy6KoF3n3MyLA.gif)

如上图所示，TLCC 是通过逐步移动一个时间序列向量（红色线）并反复计算两个信号间的相关性而测量得到的。如果相关性的峰值位于中心（offset=0），那就意味着两个时间序列在此时相关性最高。但是，如果一个信号在引导另一个信号，相关性的峰值就可能位于不同的坐标值上。下面这段代码应用了一个使用了 pandas 提供功能的互相关函数。同时它也可以将数据**打包**，这样相关性边界值也能通过添加信号另一边的数据而计算出来。

```Python
def crosscorr(datax, datay, lag=0, wrap=False):
    """ Lag-N cross correlation. 
    Shifted data filled with NaNs 
    
    Parameters
    ----------
    lag : int, default 0
    datax, datay : pandas.Series objects of equal length

    Returns
    ----------
    crosscorr : float
    """
    if wrap:
        shiftedy = datay.shift(lag)
        shiftedy.iloc[:lag] = datay.iloc[-lag:].values
        return datax.corr(shiftedy)
    else: 
        return datax.corr(datay.shift(lag))

d1 = df['S1_Joy']
d2 = df['S2_Joy']
seconds = 5
fps = 30
rs = [crosscorr(d1,d2, lag) for lag in range(-int(seconds*fps-1),int(seconds*fps))]
offset = np.ceil(len(rs)/2)-np.argmax(rs)
f,ax=plt.subplots(figsize=(14,3))
ax.plot(rs)
ax.axvline(np.ceil(len(rs)/2),color='k',linestyle='--',label='Center')
ax.axvline(np.argmax(rs),color='r',linestyle='--',label='Peak synchrony')
ax.set(title=f'Offset = {offset} frames\nS1 leads <> S2 leads',ylim=[.1,.31],xlim=[0,300], xlabel='Offset',ylabel='Pearson r')
ax.set_xticklabels([int(item-150) for item in ax.get_xticks()])
plt.legend()
```

![Peak synchrony is not at the center, suggesting a leader-follower signal dynamic.](https://cdn-images-1.medium.com/max/2000/1*-EC1sqCatnSSCXN3cO-uRg.png)

上图中，我们可以从负坐标推断出，Subject 1（S1）信号在引导信号间的相互作用（当 S2 被推进了 47 帧的时候相关性最高）。但是，这个评估信号在全局层面会动态变化，例如在这三分钟内作为引导信号的信号就会如此。另一方面，我们认为信号之间的相互作用也许会波动得**更加**明显，信号是引导还是跟随，会随着时间而转换。

为了评估粒度更细的动态变化，我们可以计算**加窗**的时间滞后互相关（WTLCC）。这个过程会在信号的多个时间窗内反复计算时间滞后互相关。然后我们可以分析每个窗口或者取窗口上的总和，来提供比较两者之间领导者跟随者互动性差异的评分。

```Python
# 加窗的时间滞后互相关
seconds = 5
fps = 30
no_splits = 20
samples_per_split = df.shape[0]/no_splits
rss=[]
for t in range(0, no_splits):
    d1 = df['S1_Joy'].loc[(t)*samples_per_split:(t+1)*samples_per_split]
    d2 = df['S2_Joy'].loc[(t)*samples_per_split:(t+1)*samples_per_split]
    rs = [crosscorr(d1,d2, lag) for lag in range(-int(seconds*fps-1),int(seconds*fps))]
    rss.append(rs)
rss = pd.DataFrame(rss)
f,ax = plt.subplots(figsize=(10,5))
sns.heatmap(rss,cmap='RdBu_r',ax=ax)
ax.set(title=f'Windowed Time Lagged Cross Correlation',xlim=[0,300], xlabel='Offset',ylabel='Window epochs')
ax.set_xticklabels([int(item-150) for item in ax.get_xticks()]);

# 滑动窗口时间滞后互相关
seconds = 5
fps = 30
window_size = 300 #样本
t_start = 0
t_end = t_start + window_size
step_size = 30
rss=[]
while t_end < 5400:
    d1 = df['S1_Joy'].iloc[t_start:t_end]
    d2 = df['S2_Joy'].iloc[t_start:t_end]
    rs = [crosscorr(d1,d2, lag, wrap=False) for lag in range(-int(seconds*fps-1),int(seconds*fps))]
    rss.append(rs)
    t_start = t_start + step_size
    t_end = t_end + step_size
rss = pd.DataFrame(rss)

f,ax = plt.subplots(figsize=(10,10))
sns.heatmap(rss,cmap='RdBu_r',ax=ax)
ax.set(title=f'Rolling Windowed Time Lagged Cross Correlation',xlim=[0,300], xlabel='Offset',ylabel='Epochs')
ax.set_xticklabels([int(item-150) for item in ax.get_xticks()]);
```

![Windowed time lagged cross correlation for discrete windows](https://cdn-images-1.medium.com/max/2000/1*BHfDJ8naQmCDeqg136uYwQ.png)

如上图所示，是将时间序列分割成了 20 个等长的时间段，然后计算每个时间窗口的互相关。这给了我们更细粒度的视角来观察信号的相互作用。例如，在第一个窗口内（第一行），右侧的红色峰值告诉我们 S2 开始的时候在引导相互作用。但是，在第三或者第四窗口（行），我们可以发现 S1 开始更多的引导相互作用。我们也可以继续计算下去，那么就可以得出下图这样平滑的图像。

![Rolling window time lagged cross correlation for continuous windows](https://cdn-images-1.medium.com/max/2000/1*NTAbN0EpFWqNChcABsZA7Q.png)

时间滞后互相关和加窗时间滞后互相关是查看两信号之间更细粒度动态相互作用的很好的方法，例如引导-追随关系以及它们如何随时间改变。但是，这样的对信号的计算的前提是假设事件是同时发生的，并且具有相似的长度，这些内容将会在下一部分涵盖。

## 3. 动态时间扭曲 —— 同步长度不同的信号

动态时间扭曲（DTW）是一种计算两信号间路径的方法，它能最小化两信号之间的距离。这种方法最大的优势就是他能处理不同长度的信号。最初它是为了进行语言分析而被发明出来（在[这段视频](https://www.youtube.com/watch?v=_K1OsqCicBY)中你可以了解更多），DTW 通过计算每一帧对于其他所有帧的欧几里得距离，计算出能匹配两个信号的最小距离。一个缺点就是它无法处理缺失值，所以如果你的数据点有缺失，你需要提前插入数据。

![XantaCross [CC BY-SA 3.0 ([https://creativecommons.org/licenses/by-sa/3.0](https://creativecommons.org/licenses/by-sa/3.0))]](https://cdn-images-1.medium.com/max/2000/1*LXQSbLyr_d_IkiDjiWx5nA.jpeg)

为了计算 DTW，我们将会使用 Python 的 `dtw` 包，它将能够加速运算。

```Python
from dtw import dtw,accelerated_dtw

d1 = df['S1_Joy'].interpolate().values
d2 = df['S2_Joy'].interpolate().values
d, cost_matrix, acc_cost_matrix, path = accelerated_dtw(d1,d2, dist='euclidean')

plt.imshow(acc_cost_matrix.T, origin='lower', cmap='gray', interpolation='nearest')
plt.plot(path[0], path[1], 'w')
plt.xlabel('Subject1')
plt.ylabel('Subject2')
plt.title(f'DTW Minimum Path with minimum distance: {np.round(d,2)}')
plt.show()
```

![](https://cdn-images-1.medium.com/max/2000/1*Jg6QtRHd7VCZR-YPtgvLyQ.png)

如图所示我们可以看到白色凸形线绘制出的最短距离。换句话说，较早的 Subject2 数据和较晚的 Subject1 数据的同步性能够匹配。最短路径代价是 **d**=.33，可以用来和其他信号的该值做比较。

## 4. 瞬时相位同步

最后，如果你有一段时间序列数据，你认为它可能有振荡特性（例如 EEG 和 fMRI），此时你也可以测量瞬时相位同步。它也可以计算两个信号间每一时刻的同步性。这个结果可能会因人而异因为你需要过滤数据以获得你感兴趣的波长信号，但是你可能只有未经实践的某些原因来确定这些波段。为了计算相位同步性，我们需要提取信号的相位，这可以通过使用希尔伯特变换来完成，希尔波特变换会将信号的相位和能量拆分开（[你可以在这里学习更多关于希尔伯特变换的知识](https://www.youtube.com/watch?v=VyLU8hlhI-I)）。这让我们能够评估两个信号是否同相位（两个信号一起增强或减弱）。

![Gonfer at English Wikipedia [CC BY-SA 3.0 ([https://creativecommons.org/licenses/by-sa/3.0](https://creativecommons.org/licenses/by-sa/3.0))]](https://cdn-images-1.medium.com/max/2000/1*Bo0LsXy6kq1oWcw2RAkRCA.gif)

```Python
from scipy.signal import hilbert, butter, filtfilt
from scipy.fftpack import fft,fftfreq,rfft,irfft,ifft
import numpy as np
import seaborn as sns
import pandas as pd
import scipy.stats as stats
def butter_bandpass(lowcut, highcut, fs, order=5):
    nyq = 0.5 * fs
    low = lowcut / nyq
    high = highcut / nyq
    b, a = butter(order, [low, high], btype='band')
    return b, a


def butter_bandpass_filter(data, lowcut, highcut, fs, order=5):
    b, a = butter_bandpass(lowcut, highcut, fs, order=order)
    y = filtfilt(b, a, data)
    return y

lowcut  = .01
highcut = .5
fs = 30.
order = 1
d1 = df['S1_Joy'].interpolate().values
d2 = df['S2_Joy'].interpolate().values
y1 = butter_bandpass_filter(d1,lowcut=lowcut,highcut=highcut,fs=fs,order=order)
y2 = butter_bandpass_filter(d2,lowcut=lowcut,highcut=highcut,fs=fs,order=order)

al1 = np.angle(hilbert(y1),deg=False)
al2 = np.angle(hilbert(y2),deg=False)
phase_synchrony = 1-np.sin(np.abs(al1-al2)/2)
N = len(al1)

# 绘制结果
f,ax = plt.subplots(3,1,figsize=(14,7),sharex=True)
ax[0].plot(y1,color='r',label='y1')
ax[0].plot(y2,color='b',label='y2')
ax[0].legend(bbox_to_anchor=(0., 1.02, 1., .102),ncol=2)
ax[0].set(xlim=[0,N], title='Filtered Timeseries Data')
ax[1].plot(al1,color='r')
ax[1].plot(al2,color='b')
ax[1].set(ylabel='Angle',title='Angle at each Timepoint',xlim=[0,N])
phase_synchrony = 1-np.sin(np.abs(al1-al2)/2)
ax[2].plot(phase_synchrony)
ax[2].set(ylim=[0,1.1],xlim=[0,N],title='Instantaneous Phase Synchrony',xlabel='Time',ylabel='Phase Synchrony')
plt.tight_layout()
plt.show()
```

![Filtered time series (top), angle of each signal at each moment in time (middle row), and instantaneous phase synchrony measure (bottom).](https://cdn-images-1.medium.com/max/2000/1*na7RbielmedgyqvqRzfk-g.png)

瞬时相位同步测算是计算两个信号每一刻同步性的很好的方法，并且它不需要我们像计算滑动窗口相关性那样任意规定窗口宽度。如果你想要知道瞬时相位同步和窗口相关性的比对，[可以在这里查看我更早些的博客](http://jinhyuncheong.com/jekyll/update/2017/12/10/Timeseries_synchrony_tutorial_and_simulations.html)。

***

## 总结

我们讲解了四种计算时间序列数据相关性的方法：皮尔逊相关，时间滞后互相关，动态时间扭曲及瞬时相位同步。基于你的信号类型，你对信号作出的假设，以及你想要从数据中寻找什么样的同步性数据的目标，来决定使用那种相关性测量，有任何问题都可以向我提出，并欢迎在下方留言。

完整的代码在 Jupyter 笔记上，它使用的[样本数据在这里](https://gist.github.com/jcheong0428/c6d6111ee1b469cf39683bd70fab1c93/archive/b2546c195e6793e00ed23c97a982ce439f4f95aa.zip)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
