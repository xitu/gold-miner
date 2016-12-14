> * 原文地址：[Audio Fingerprinting with Python and Numpy](http://willdrevo.com/fingerprinting-and-audio-recognition-with-python/)
* 原文作者：[Will Drevo](http://willdrevo.com/contact/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Airmacho](https://github.com/Airmacho)
* 校对者：

# Audio Fingerprinting with Python and Numpy

# 用 Python 和 Numpy 实现音频数字指纹特征识别


The first day I tried out Shazam, I was blown away. Next to GPS and surviving the fall down a flight of stairs, being able to recognize a song from a vast corpus of audio was the most incredible thing I'd ever seen my phone do. This recognition works though a process called [audio fingerprinting](http://en.wikipedia.org/wiki/Acoustic_fingerprint). Examples include:

*   [Shazam](http://www.ee.columbia.edu/%7Edpwe/papers/Wang03-shazam.pdf)
*   [SoundHound / Midomi](http://www.midomi.com/)
*   [Chromaprint](http://acoustid.org/chromaprint)
*   [Echoprint](http://echoprint.me/)

我第一次用 Shazam 的时候，简直惊呆了。除了 GPS 功能和从楼梯摔下仍然没坏之外，能用一段音频片段识别歌曲是我所见过我手机能做到的最不可思议的事了。识别是通过一个叫[音频特征识别]的过程来实现的，例子包括：

- [Shazam](http://www.ee.columbia.edu/%7Edpwe/papers/Wang03-shazam.pdf)
- [SoundHound / Midomi](http://www.midomi.com/)
- [Chromaprint](http://acoustid.org/chromaprint)
- [Echoprint](http://echoprint.me/)

After a few weekends of puzzling through academic papers and writing code, I came up with the Dejavu Project, an open-source audio fingerprinting project in Python. You can see it here on Github:

[https://github.com/worldveil/dejavu](https://github.com/worldveil/dejavu)

On my testing dataset, Dejavu exhibits 100% recall when reading an unknown wave file from disk or listening to a recording for at least 5 seconds.

Following is all the knowledge you need to understand audio fingerprinting and recognition, starting from the basics. Those with signals experience should skip to "Peak Finding".

经过几个周末在学术论文和代码中求索，我想出了一个基于Python语言开发的，开源的音频特征识别项目，名字叫 Dejavu。 你可以在 GitHub 上找到它：

[https://github.com/worldveil/dejavu](https://github.com/worldveil/dejavu)

按照我的测试数据集，Dejavu 可以通过从磁盘上读取一段未知的波形文件，或者听取 5 秒以上的录音实现 100% 准确率的识别。

以下是你需要了解的所有关于音频特征识别的知识。对信号处理有研究的读者可以略过，从 “Peak Finding” 开始读。

## Music as a signal

As a computer scientist, my familiarity with the [Fast Fourier Transform (FFT)](http://en.wikipedia.org/wiki/Fast_Fourier_transform) was only that it was a cool way to mutliply polynomials in `O(nlog(n))` time. Luckily it is much cooler for doing signal processing, its canonical usage.

Music, it turns out, is digitally encoded as just a long list of numbers. In an uncompressed .wav file, there are a lot of these numbers - 44100 per second per channel. This means a 3 minute long song has almost 16 million samples.

> 3 min * 60 sec * 44100 samples per sec * 2 channels = 15,876,000 samples

A channel is a separate sequence of samples that a speaker can play. Think of having two earbuds - this is a "stereo", or two channel, setup. A single channel is called "mono". Today, modern surround sound systems can support many more channels. But unless the sound is recorded or mixed with the same number of channels, the extra speakers are redundant and some speakers will just play the same stream of samples as other speakers.

## 把音乐当作信号处理

作为一名计算机科学家，我所了解的[快速傅立叶变换 (FFT)](http://en.wikipedia.org/wiki/Fast_Fourier_transform) ，只是把它当作一种很高效地在`O(nlog(n))` 时间内计算多项式乘法的方法。实际上，它在信号处理方面也有很好的应用场景。

音乐，其实就是与一长串数字相似的数字编码。在未压缩的 .wav 文件里，有很多这样的数字 — 每个声道每秒钟 44100 个数字。这意味着三分钟长的歌曲有近 1600 万个数字。

> 3 分钟 * 60 秒 * 44100 个样本每秒 * 2 声道 = 15,876,000 个信号样本

声道是指，可以用扬声器播放的，独立的信号样本序列。两个耳塞 — 可以想成是立体声，两个声道。一个声道也被称作‘单声道’。现代的环绕音系统可以支持更多的声道。但除非声音在被录制或者混录时已经是多声道，否则多出来没有对应的扬声器就会播放跟其他扬声器一样的信号流。

## Sampling

Why 44100 samples per second? The mysterious choice of 44100 samples per second seems quite arbitrary, but it relates to the [Nyquist-Shannon Sampling Theorum](http://en.wikipedia.org/wiki/Nyquist%E2%80%93Shannon_sampling_theorem). This is a long, mathematical way to say that there is a theoretical limit on the maximum frequency we can capture accurately when recording. This maximum frequency is based on how _fast_ we sample the signal.

If this doesn't make sense, think about watching a fan blade that makes a full revolution at a rate of exactly once per second (1 Hz). Now imagine keeping your eyes closed, but opening them briefly once per second. If the fan still happens to be making exactly a full revolution every 1 second as well, it will appear as though the fan blade hasn't moved! Each time you open your eyes, the blade happens to be in the same spot. But there's a problem. In fact, as far as you know, the fan blade could be making 0, 1, 2, 3, 10, 100, or even 1 million spins per second and you would never know - it would still appear stationary! Thus in order to be assured you are correctly sampling (or "seeing") higher frequencies (or "spins"), you need to sample (or "open your eyes") more frequently. To be exact, we need to sample twice as frequently as the frequency we want to see to make sure we're detecting it.

In the case of recording audio, the accepted rule is that we're OK missing out on frequencies above 22050 Hz since humans can't even hear frequencies above 20,000 Hz. Thus by Nyquist, we have to sample _twice_ that:

> Samples per sec needed = Highest-Frequency * 2 = 22050 * 2 = 44100

The MP3 format compresses this in order to 1) save space on your hard drive, and 2) irritate audiophiles, but a pure .wav formatted file on your computer is just a list of 16 bit integers (with a small header).

## 信号样本

为什么是每秒 44100 个信号样本？这样选择的原因看起来随意，其实与[奈奎斯特-香农采样定理](http://en.wikipedia.org/wiki/Nyquist%E2%80%93Shannon_sampling_theorem)有关。这个很长的，数学推导的方法告诉我们，可以准确采集录音的最大频率是有一个理论上限的。这个最大的频率取决于我们信号采样有多**快**。

如果你没理解，可以想象看一个扇叶每秒转一个整圈(1Hz)的电风扇。现在闭上你的眼睛，精确地每秒钟快速睁开一下。如果扇叶也是精确的每秒转一圈，对你来说扇叶并没有移动！每次你睁开眼睛，扇叶都会转到相同的位置。但这有问题，实际上，如你所知，扇叶每秒钟可以转 0，1，2，3，10，100，甚至100万圈。但你却永远感知不到 — 它看起来是静止的！因此为了保证你可以准确地采样（或者‘看到’）高频率的运动（如‘转圈’），你需要以更高的频率采样（或者说‘睁眼’），准确的说，我们需要用运动两倍的频率采样才能确定我们可以觉察到。

就音频录制来说，广泛接受的规则是可以忽略掉 22050Hz 以上的信号，因为人类的耳朵无法听到 20000Hz 以上的频率。因此根据奈奎斯特定理，我们需要 **加倍地** 采样：

> 每秒需要采样的 = 最高频率 * 2 = 22050 * 2 = 44100

MP3 格式的文件压缩了这个采样率，以 1）节省你的硬盘空间，2）惹恼音乐发烧友，但其实纯 .wav 格式文件不过是一串 16 比特的数字序列（加上一个小小的文件头）。

## Spectrograms

## 频谱图

Since these samples are a signal of sorts, we can repeatedly use an FFT over small windows of time in the song's samples to create a [spectrogram](http://en.wikipedia.org/wiki/Spectrogram) of the song. Here's a spectrogram of the first few seconds of "Blurred Lines" by Robin Thicke.

因为这些音频样本其实就是信号，我们可以不断地在一小段时间窗口内的歌曲样本上，用快速傅立叶变换生成歌曲的[频谱图](http://en.wikipedia.org/wiki/Spectrogram)。下面就是 Robin Thicke 的 “Blurred Lines” 这首歌开始几秒的频谱图。

![Blurred Lines](http://willdrevo.com/public/images/dejavu-post/spectrogram_no_peaks.png)

As you can see, it's just a 2D array with amplitude as a function of time and frequency. The FFT shows us the strength (amplitude) of the signal at that particular frequency, giving us a column. If we do this enough times with our sliding window of FFT, we put them together and get a 2D array spectrogram.

It's important to note that the frequency and time values are discretized, each representing a "bin", while the amplitudes are real valued. The color shows the real value (red -> higher, green -> lower) of the amplitude at the discretized (time, frequency) coordinate.

As a thought experiment, if we were to record and create a spectrogram of a single tone, we'd get a straight horizontal line at the frequency of the tone. This is because the frequency does not vary from window to window.

Great. So how does this help us recognize audio? Well, we'd like to use this spectrogram to identify this song uniquely. The problem is that if you have your phone in your car and you try to recognize the song on the radio, you'll get noise - someone is talking in the background, another car honking its horn, etc. We have to find a robust way to capture unique "fingerprints" from the audio signal.

如你所见，这是一个用横轴表示时间，纵轴表示频率，以颜色表示振幅大小的矩阵。快速傅立叶变换展示给我们信号在特定频率的的强度（振幅）。如果我们计算足够次数的滑动窗口 FFT，我们可以把它们拼在一起组成一个矩阵频谱。

重要的是要注意，频率和时间的值是离散的，每对代表一个 “bin”，振幅是实值。颜色表示在离散化（时间，频率）的坐标系中的振幅的实值（红 -> 较高，绿 -> 较低）。

现在思考，如果我们记录一个单音并创建频谱，我们会在单音的频率上得到一条直的水平线的。这是因为频率不随窗口变化而变化。

很好，那么这如何帮我们识别音频呢？我们想用这个频谱图来唯一地标记这首歌。问题是如果你当车上使用手机，识别的还是收音机上播放的歌曲时，会有噪音 — 背景音里有说话声，另一辆车按喇叭等。我们不得不找一个稳健的方法来获取音频信号的“数字指纹”。

## Peak Finding

Now that we've got a specrogram of our audio signal, we can start by finding "peaks" in amplitude. We define a peak as a (time, frequency) pair corresponding to an amplitude value which is the greatest in a local "neighborhood" around it. Other (time, frequency) pairs around it are lower in amplitude, and thus less likely to survive noise.

Finding peaks is an entire problem itself. I ended up treating the spectrogram as an image and using the image processing toolkit and techniques from `scipy` to find peaks. A combination of a high pass filter (accentuating high amplitudes) and `scipy` local maxima structs did the trick.

Once we've extracted these noise-resistant peaks, we have found points of interest in a song that identify it. We are effectively "squashing" the spectrogram down once we've found the peaks. The amplitudes have served their purpose, and are no longer needed.

Let's plot them to see what it looks like:

现在我们有了根据音频信号生成的频谱图，我们可以从在振幅里面寻找‘峰值’开始。我们这里定义峰值为振幅在附近“临域”极大值对应的时频。周围的时频对应的振幅都比它小，更有可能是背景噪音。

查找峰值本身就是个问题。我最后把频谱图当作图片处理，用图片处理工具和`scipy`库里的技术查找峰值。用一组高通滤波器（强调高振幅）和 `scipy`查找局部极大值的算法可以实现。

一旦我们提取出这些抗噪声峰值，我们就发现了可以识别一首歌曲的关键点。一旦我们找到峰值，我们就可以有效地“压缩”频谱图。振幅已经完成了它们的使命，我可以不再关注。

让我们来绘制下，看看它是什么样：

![Blurred Lines](http://willdrevo.com/public/images/dejavu-post/spectrogram_peaks.png)

You'll notice there are a lot of these. Tens of thousands per song, actually. The beauty is that since we've done away with amplitude, we only have two things, time and frequency, which we've conviently made into discrete, integer values. We've binned them, essentially.

We have a somewhat schizophrenic situation: on one hand, we have a system that will bin peaks from a signal into discrete (time, frequency) pairs, giving us some leeway to survive noise. On the other hand, since we've discretized, we've reduced the information of the peaks from infinite to finite, meaning that peaks found in one song could (hint: will!) collide, emitting the pairs as peaks extracted from other songs. Different songs can and most likely will emit the same peaks! So what now?

你会注意到很多这样的点。实际上，每首歌数以万计。妙处就在，我们已经消除了振幅，只有两个东西要关注，时间和频率，我们可以把它们很方便地转换成离散的整数值。本质上，我们已经将它们合并了。

我们面对的是一个自相矛盾的情况：一方面，我们有一个可以将峰值从信号合并成离散数值对（时间，频率）的系统，让我们避开噪音的干扰。另一方面，因为我们已经离散化，我们将峰值的所包含的信息从无限减少至有限，这意味着一首歌中可以找到的峰值可能（提示：真的会）和其他歌曲中提取的碰撞重合。不同的歌曲可以，并且很可能提取出相同的峰值！现在怎么办呢？

## Fingerprint hashing

So we might have similar peaks. No problem, let's combine peaks into fingerprints! We'll do this by using a hash function.

A [hash function](http://en.wikipedia.org/wiki/Hash_function) takes an integer input and returns another integer as output. The beauty is that a good hash function will not only return the _same_ output integer each time the input is the same, but also that very few different inputs will have the same output.

By looking at our spectrogram peaks and combining peak frequencies along with their time difference between them, we can create a hash, representing a unique fingerprint for this song.



    hash(frequencies of peaks, time difference between peaks) = fingerprint hash value


There are lots of different ways to do this, Shazam has their own, SoundHound another, and so on. You can peruse my source to see how I do it, but the point is that by taking into account more than a single peak's values you create fingerprints that have more entropy and therefore contain more information. Thus they are more powerful identifiers of songs since they will collide less.

You can visualize what is going on with the zoomed in annotated spectrogram snipped below:

## 数字指纹哈希

所以我们可能遇到相似的峰值特征。没问题，让我们把这些峰值转换成数字指纹哈希！我们可以用一个哈希函数来实现。

[哈希函数](http://en.wikipedia.org/wiki/Hash_function)接受一个整数作为输入，返回另一个整数作为输出。奇妙的是，一个好的哈希函数不仅在每次输入相同时返回相同的输出整数，而且极少出现输入不同返回输出相同的情况。

通过观察我们的频谱峰值和合并的峰值频率以及它们之间的时间差，我们可以得到一个可以当作歌曲的唯一数字指纹的的哈希。

~~~
hash(frequencies of peaks, time difference between peaks) = fingerprint hash value
~~~

这有很多种实现方式，Shazam 用自己的算法，SoundHound 用另外的。你可以通过读我的源码来看我是怎样实现的。但是关键是，因为考虑多个单一的峰值，你创建的数字指纹有更多的熵，也就是包含更多的信息。因此它们是歌曲更有说服力的标识符，因为它们碰撞重复的几率更小。

你可以将通过下面这个放大的有注释标记的频谱片段来将这个过程在脑海中可视化：

![Blurred Lines](http://willdrevo.com/public/images/dejavu-post/spectrogram_zoomed.png)

The Shazam whitepaper likens these groups of peaks as a sort of "constellation" of peaks used to identify the song. In reality they use pairs of peaks along with the time delta in between. You can imagine lots of different ways to group points and fingerprints. On one hand, more peaks in a fingerprint means a rarer fingerprint that more strongly would identify a song. But more peaks also means less robust in the face of noise.

Shazam 白皮书把这些峰的组合比做一种用于识别歌曲的峰组成“星座”。实际上，他们使用的是成堆的峰值以及峰值之间的时间增量。你可以想象许多不同方法来给这些点和数字指纹分组。一方面，数字指纹中有更多的峰值意味着更指纹更罕见，可以更准确地识别一首歌。但是峰值采集的更多，也意味着在有噪音的情况下，更不准确。

## Learning a Song

Now we can get started into how such a system works. An audio fingerprinting system has two tasks:

1.  Learn new songs by fingerprinting them
2.  Recognize unknown songs by searching for them in the database of learned songs

For this, we'll use our knowledge thus far and MySQL for the database functionality. Our database schema will contain two tables:

## 学习一首歌曲

现在我们可以开始研究这些系统是怎样工作的了，音频特征系统有两个任务：

1. 通过对音乐的特征识别学习一首歌曲
2. 通过在存储了已学习的歌曲的数据库中查询来识别未知歌曲

为了实现这个，我们用我们的知识和 MySQL 作为数据库。我们的数据库结构包含下面两个表：

## Fingerprints table

The fingerprints table will have the following fields:

## 数字指纹表

表有以下字段：



    CREATE TABLE fingerprints (
         hash binary(10) not null,
         song_id mediumint unsigned not null,
         offset int unsigned not null,
         INDEX(hash),
         UNIQUE(song_id, offset, hash)
    );



First, notice we have not only a hash and a song ID, but an offset. This corresponds to the time window from the spectrogram where the hash originated from. This will come into play later when we need to filter through our matching hashes. Only the hashes that "align" will be from the true signal we want to identify (more on this in the "Fingerprint Alignment" section below).

首先，注意我们不只有哈希值和歌曲 ID，还有偏移量。这对应于哈希源自频谱图的时间窗口。当我们需要过滤匹配的哈希时将要用到。只有“对齐”的哈希值才是源自我们要识别的真实信号的（更多关于“数字指纹对齐”的部分在下面）。

Second, we've made an `INDEX` on our hash - with good reason. All of the queries will need to match that, so we need a really quick retrieval there.

Next, the `UNIQUE` index just insures we don't have duplicates. No need to waste space or unduly weight matching of audio by having duplicates lying around.

If you're scratching your head on why I used a `binary(10)` field for the hash, the reason is that we'll have a _lot_ of these hashes and cutting down space is imperative. Below is a graph of the number of fingerprints for each song:

其次，我们在哈希值这列建一个`索引`，有很好的理由。所有的查询都需要匹配哈希值，所以我们需要在这里有一个真正快速的读取。

接下来，`UNIQUE`所以保证我们不会有重复的项目。不需要浪费空间或过度地匹配重复的音频。

如果你搞不清楚为什么我用`binary(10)`来指定哈希值存储的类型，原因是，我们会存储**很多**这样的哈希值，节省空间是必要的。下面是每首歌曲提取数字指纹数量的图表：



![Fingerprint counts](http://ac-Myg6wSTV.clouddn.com/fce9eb07d200f20846d2.png)

At the front of the pack is "Mirrors" by Justin Timberlake, with over 240k fingerprints, followed by "Blurred Lines" by Robin Thicke with 180k. At the bottom is the acapella "Cups" which is a sparsely instrumented song - just voice and literally a cup. In contract, listen to "Mirrors". You'll notice the obvious "wall of noise" instrumentation and arranging the fills out the frequency spectrum from high to low, meaning that the spectrogram is abound with peaks in high and low frequencies alike. The average is well over 100k fingerprints per song for this dataset.

最前面的是 Justin Timberlake 的 "Mirrors"，有超过 24 万个数字指纹，接着是 Robin Thicke 的 "Blurred Lines"，有 18 万个数字指纹。最下面的是清唱的"Cups"，无伴奏音乐，只有歌声和一个真的杯子伴奏。相对的，听 “Mirrors”时，你会注意到明显的“噪音墙”乐器和编曲，将频谱从高到低填充满，这意味着频谱充斥着高频和低频，对这个数据集，每首歌的平均有超过10万个数字指纹。

With this many fingerprints, we need to cut down on unecessary disk storage from the hash value level. For our fingerprint hash, we'll start by using a `SHA-1` hash and then cutting it down to half its size (just the first 20 characters). This cuts our byte usage per hash in half:

> char(40) => char(20) goes from 40 bytes to 20 bytes

Next we'll take this hex encoding and convert it to binary, once again cutting the space down considerably:

> char(20) => binary(10) goes from 20 bytes to 10 bytes

Much better. We went from 320 bits down to 80 bits for the `hash` field, a reduction of 75%.

有了这么多指纹，我们需要从哈希值的维度上减少不必要的磁盘存储。对于我们的数字指纹哈希，我们可以从用` SHA1`开始，将其减少成一半的尺寸（只是前20个字符）。这可以使我们每个哈希值所占用的字节数减半：

> char(40) => char(20) goes from 40 bytes to 20 bytes

接下来，我们将十六进制编码转还成二进制，再次大幅度地减少了空间：

> char(20) => binary(10) goes from 20 bytes to 10 bytes

好多了，我们将 `hash` 字段从 320 比特减少到 80 比特，减少了75%de空间利用。

My first try at the system, I used a `char(40)` field for each hash - this resulted in over 1 GB of space for fingerprints alone. With `binary(10)` field, we cut down the table size to just 377 MB for 5.2 million fingerprints.

We do lose some of the information - our hashes will, statistically speaking, collide much more often now. We've reduced the "entropy" of the hash considerably. However, its important to remember that our entropy (or information) also includes the `offset` field, which is 4 bytes. This brings the total entropy of each of our fingerprints to:

> 10 bytes (hash) + 4 bytes (offset) = 14 bytes = 112 bits = 2^112 ~= 5.2+e33 possible fingerprints

Not too shabby. We've saved ourself 75% of the space and still managed to have an unimaginably large fingerprint space to work with. Gurantees on the distribution of keys is a hard argument to make, but we certainly have enough entropy to go around.

我第一次试用系统时，我用一个 `char(40)`字段来存储每个哈希 - 这导致仅数字指纹的数据就占了超过 1GB 的空间。通过用 `binary(10)`，存储 520 万个数字指纹仅需要377M 空间。

我们确实丢失了一些信息 - 我们的哈希值，从统计的角度讲，会碰撞的更频繁。我们大大减少了哈希的“熵”。然而，重要的是要记得我们的熵（或者说信息）还包含4 字节的 `offset` 字段。这使我们每个数字指纹的总的熵达到：

> 10 bytes (hash) + 4 bytes (offset) = 14 bytes = 112 bits = 2^112 ~= 5.2+e33 possible fingerprints

还不赖。我们省下了 75% 的空间，但仍有难以想象多的数据指纹需要处理。保证关键点的分配是很难的，但我们肯定有足够的熵来回避。

## Songs table

The songs table will be pretty vanilla, essentially we'll just use it for holding information about songs. We'll need it to pair a `song_id` to the song's string name.



    CREATE TABLE songs (
        song_id mediumint unsigned not null auto_increment,
        song_name varchar(250) not null,
        fingerprinted tinyint default 0,
        PRIMARY KEY (song_id),
        UNIQUE KEY song_id (song_id)
    );



The `fingerprinted` flag is used by Dejavu internally to decide whether or not to fingprint a file. We set the bit to 0 initially and only set it to 1 after the fingerprinting process (usually two channels) is complete.

## 歌曲表

歌曲表就相当普通，我们会用它来查询关于歌曲的信息。我们用`song_id`来匹配出歌曲的字符串形式的名字。

~~~
CREATE TABLE songs (
    song_id mediumint unsigned not null auto_increment,
    song_name varchar(250) not null,
    fingerprinted tinyint default 0,
    PRIMARY KEY (song_id),
    UNIQUE KEY song_id (song_id)
);
~~~

`fingerprinted`标记是 Dejavu 内部用的，来决定是否要提取一个文件的特征值。我们初识设置为0，只有当提取特征过程（一般来说两个声道）完成之后才将它设置为1。

## Fingerprint Alignment

## 指纹对齐

Great, so now we've listened to an audio track, performed FFT in overlapping windows over the length of the song, extracted peaks, and formed fingerprints. Now what?

Assuming we've already performed this fingerprinting on known tracks, ie we have already inserted our fingerprints into the database labeled with song IDs, we can simply match.

Our pseudocode looks something like this:

太棒了，所以现在我们听取了一个音轨，在重叠的时间窗口执行 FFT，提取峰值，形成数字指纹。现在该做什么呢？

假设我们已经在已知的音轨上提取了数字指纹，将其存入数据库，并用歌曲 ID 标记，可以查找直接匹配。

伪代码看起来是这样的：

    channels = capture_audio()

    fingerprints_matching = [ ]
    for channel_samples in channels
        hashes = process_audio(channel_samples)
        fingerprints_matching += find_database_matches(hashes)
    predicted_song = align_matches(fingerprints_matching)



What does it mean for hashes to be aligned? Let's think about the sample that we are listening to as a subsegment of the original audio track. Once we do this, the hashes we extract out of the sample will have an `offset` that is _relative_ to the start of the sample.

The problem of course, is that when we originally fingerprinted, we recorded the _absolute_ offset of the hash. The relative hashes from the sample and the absolute hashes from the database won't ever match unless we started recording a sample from exactly the start of the song. Pretty unlikely.

But while they may not be the same, we do know something about the matches from the real signal behind the noise. We know all the relative offsets will be the same distance apart. This requires the assumption that the track is being played and sampled at the same speed it was recorded and released in the studio. Actually, we'd be out of luck anyway in the case the playback speed was different, since this would affect the frequency of the playback and therefore the peaks in the spectrogram. At any rate, the playback speed assumption is a good (and important) one.

对于哈希来说，对齐是指什么呢？让我们把正在听的样本想成原始音轨的子段落。这样，我们从样本里提取的哈希就会有一个相对于样本开始的`偏移量`。

问题当然是，当我们最初提取数字指纹，我们记录哈希的是**绝对**偏移量。来自样本的相对哈希和数据库里的绝对哈希永远不会匹配。除非我们从歌曲的开头开始记录样本，这不太可能。

但是他们也许不是一样的，我们知道所有相关偏移量都是相隔相同的距离。这需要假定音轨被播放和被采样时速率是一致的。实际上，当录音播放的速率不同时，我们就不这样幸运了，因为这会影响录音的频率，继而影响生成频谱中的峰值。无论如何，录音的速度是一个好的（并且重要的）假设。

Under this assumption, for each match we calculate a difference between the offsets:

> difference = database offset from original track - sample offset from recording

which will always yield a postiive integer since the database track will always be at least the length of the sample. All of the true matches with have this same difference. Thus our matches from the database are altered to look like:

> (song_id, difference)

Now we simply look over all of the matches and predict the song ID for which the largest count of a difference falls. This is easy to imagine if you visualize it as a histogram.

And that's all there is to it!

在这种假设下，对于每个匹配，我们计算偏移量之间的差：

> 偏移量差 = 库中数据相对原音轨的偏移 - 样本相对于录音的偏移

这会产生一个正整数，因为数据库里的音轨始终至少是样本的长度。所有的真正的匹配都有相同的区别，因此，我们从数据库匹配会被改成：

> (song_id, difference)

现在我们只要查看所有的匹配并预测差异数最大的歌曲ID。如果你能把这想象成直方图，就很容易。

大功告成！

## How well it works

To truly get the benefit of an audio fingerprinting system, it can't take a long time to fingerprint. It's a bad user experience, and furthermore, a user may only decide to try to match the song with only a few precious seconds of audio left before the radio station goes to a commercial break.

To test Dejavu's speed and accuracy, I fingerprinted a list of 45 songs from the US VA Top 40 from July 2013 (I know, their counting is off somewhere). I tested in three ways:

1.  Reading from disk the raw mp3 -> wav data, and
2.  Playing the song over the speakers with Dejavu listening on the laptop microphone.
3.  Compressed streamed music played on my iPhone

Below are the results.

## 工作的如何

为了真正的获得音频数字指纹系统带来的好处，它不能耗费很长时间来提取指纹。这是糟糕的用户体验，此外，用户可能只是在广播电台插播广告的前的珍贵几秒，尝试匹配歌曲。

为了测试 Dejavu 的速度和准确度，我提取了 2013 年 7 月的美国 VA Top 40 的 45 首（我知道，他们数错了）歌曲的数字指纹。用三种方式测试：

1. 直接从硬盘读取原始 mp3， wav数据
2. 用 Dejavu 通过笔记本的麦克风听取音乐
3. 在我的 iPhone 上播放压缩流音乐

下面是结果。

## 1\. Reading from Disk

Reading from disk was an overwhelming 100% recall - no mistakes were made over the 45 songs I fingerprinted. Since Dejavu gets all of the samples from the song (without noise), it would be nasty surprise if reading the same file from disk didn't work every time!

## 1. 从磁盘读取

从磁盘读取的准确率是不可阻挡的 100% — 在我提取特征的 45 首歌里面没有错误。因为 Dejavu 获取到歌的全部样本（没有噪音干扰），如果每次从磁盘读取相同文件都不能成功，那就太糟了。

## 2\. Audio over laptop microphone

Here I wrote a script to randomly chose `n` seconds of audio from the original mp3 file to play and have Dejavu listen over the microphone. To be fair I only allowed segments of audio that were more than 10 seconds from the starting/ending of the track to avoid listening to silence.

Additionally my friend was even talking and I was humming along a bit during the whole process, just to throw in some noise.

Here are the results for different values of listening time (`n`):

## 2.通过笔记本的麦克风获取音频

这里我写了一个脚本，可以随机选取原始 mp3 文件的`n`秒的音频，让 Dejavu 通过麦克风听。为了结果可信，我选取的音频片段刨除了距歌曲开始或结束10秒内的部分，以防听取不到声音。

另外，在整个过程中，我朋友在说话，我在跟着哼，以加入噪音。

这是听取的时间不同（`n`)的结果：

![Matching time](http://ac-Myg6wSTV.clouddn.com/193cba5b655f93c89574.png)

This is pretty rad. For the percentages:


| Number of Seconds | Number Correct | Percentage Accuracy |
| ----------------- | -------------- | ------------------- |
| 1                 | 27 / 45        | 60.0%               |
| 2                 | 43 / 45        | 95.6%               |
| 3                 | 44 / 45        | 97.8%               |
| 4                 | 44 / 45        | 97.8%               |
| 5                 | 45 / 45        | 100.0%              |
| 6                 | 45 / 45        | 100.0%              |

Even with only a single second, randomly chosen from anywhere in the song, Dejavu is getting 60%! One extra second to 2 seconds get us to around 96%, while getting perfect only took 5 seconds or more. Honestly when I was testing this myself, I found Dejavu beat me - listening to only 1-2 seconds of a song out of context to identify is pretty hard. I had even been listening to these same songs for two days straight while debugging...

In conclusion, Dejavu works amazingly well, even with next to nothing to work with.

结果很棒，正确率如下：

| Number of Seconds | Number Correct | Percentage Accuracy |
| ----------------- | -------------- | ------------------- |
| 1                 | 27 / 45        | 60.0%               |
| 2                 | 43 / 45        | 95.6%               |
| 3                 | 44 / 45        | 97.8%               |
| 4                 | 44 / 45        | 97.8%               |
| 5                 | 45 / 45        | 100.0%              |
| 6                 | 45 / 45        | 100.0%              |

即使只听取一秒，随机选取歌曲的任意部分，Dejavu 的准确率也达到了 60%！两秒的话准确率可以达到约 96%，5秒或以上，结果就趋近于完美了。老实说，当我测试的时候，我发现 Dejavu 赢了我，只听一两秒就识别出歌曲是相当难的。我甚至已经 debugging 的时候连续听了两天相同的歌。

结论是，即便在提供的数据少到几乎没有的情况下，Dejavu 工作的也非常出色。

## 3\. Compressed streamed music played on my iPhone

### 3. 在我的 iPhone 上播放的压缩音乐流

Just to try it out, I tried playing music from my Spotify account (160 kbit/s compressed) through my iPhone's speakers with Dejavu again listening on my MacBook mic. I saw no degredation in performance; 1-2 seconds was enough to recognize any of the songs.

只是尝试一下，我尝试用我的 iPhone 扬声器从我的 Spotify 账户播放音乐（已压缩160 kbit/s），Dejavu 仍从我的 MacBook 的麦克上听取。正确率没有下降， 1 到 2 秒仍足以识别出任何歌曲。

## Performance: Speed

On my MacBook Pro, matching was done at 3x listening speed with a small constant overhead. To test, I tried different recording times and plotted the recording time plus the time to match. Since the speed is mostly invariant of the particular song and more dependent on the length of the spectrogram created, I tested on a single song, "Get Lucky" by Daft Punk:

## 性能：速度

在我的 MacBook Pro上，以 3 倍速只要很少的开销就可以完成匹配。为了测试，我尝试了不同的录音时长，并记下录音时长加与匹配用时的对应关系。由于匹配速度主要取决于频谱图的长度，和具体哪首歌没有关系，我只测试了一首歌， Daft Punk 的《Get Lucky》:

![Matching time](http://ac-Myg6wSTV.clouddn.com/6d03d080cc00cc5f5e90.png)

As you can see, the relationship is quite linear. The line you see is a least-squares linear regression fit to the data, with the corresponding line equation:

> 1.364757 * record time - 0.034373 = time to match

Notice of course since the matching itself is single threaded, the matching time includes the recording time. This makes sense with the 3x speed in purely matching, as:

> 1 (recording) + 1/3 (matching) = 4/3 ~= 1.364757

if we disregard the miniscule constant term.

The overhead of peak finding is the bottleneck - I experimented with mutlithreading and realtime matching, and alas, it wasn't meant to be in Python. An equivalent Java or C/C++ implementation would most likely have little trouble keeping up, applying FFT and peakfinding in realtime.

An important caveat is of course, the round trip time (RTT) for making matches. Since my MySQL instance was local, I didn't have to deal with the latency penalty of transfering fingerprint matches over the air. This would add RTT to the constant term in the overall calculation, but would not effect the matching process.

如你所见，关系是非常线性相关的。你看到的直线是对数据的最小二乘线性回归拟合。相应的方程是：

> 1.364757 * record time - 0.034373 = time to match

注意， 因为匹配本身是单线程的，匹配时间也包含录音的时间。这解释了用三倍速匹配时：

> 1 (recording) + 1/3 (matching) = 4/3 ~= 1.364757

如果我们忽略微小的常数项。

peak finding 算法的开销是瓶颈 — 我尝试用多线程和实时匹配，这注定不是 Python 的强项。等效的 Java 或 C/C++ 实现应该不难完成实时 FFT 和峰值查找的需求。

重要的警告是，为了匹配数据的往返时间（RTT）。因为我的 MYSQL 实例是本地的，我不用处理无限传输造成的延迟。在计算总的用时时需要加上 RTT，但这不影响匹配的过程。

## Performance: Storage

For the 45 songs I fingerprinted, the database used 377 MB of space for 5.4 million fingerprints. In comparison, the disk usage is given below:



| Audio Information Type | Storage in MB |
| ---------------------- | ------------- |
| mp3                    | 339           |
| wav                    | 1885          |
| fingerprints           | 377           |

There's a pretty direct trade-off between the necessary record time and the amount of storage needed. Adjusting the amplitude threshold for peaks and the fan value for fingerprinting will add more fingerprints and bolster the accuracy at the expense of more space.

It's true, the fingerprints take up a surprising amount of space (slighty more than raw MP3 files). This seems alarming until you consider there are tens and sometimes hundreds of thousands of hashes per song. We've traded off the pure information of the entire audio signal in the wave files for about 20% of that storage in fingerprints. We've also enabled matching songs very reliably in five seconds, so our space / speed tradeoff appears to have paid off.

## 性能：存储

对于我提取了特征的 45 首歌，数据库用 377MB 的空间存了 5400 万个特征标示。为了比较，磁盘用量如下：

| Audio Information Type | Storage in MB |
| ---------------------- | ------------- |
| mp3                    | 339           |
| wav                    | 1885          |
| fingerprints           | 377           |

这是一个相当直接的在记录时间和存储空间之间的折衷。调整峰值的振幅阈值和数字指纹采集时的采样频率，可以增加指纹数量， 并以更多空间占用为代价换取更高的准确度。

真的，数字指纹占用惊人的存储空间（比原始的 MP3 文件稍大）。这似乎令人震惊，直到你考虑到每首歌有成百上千，甚至有时成千上万条哈希值记录。我们已经把波形文件中的整个音频信号折衷成数字指纹占用的20%。我们可以在五秒内非常可靠地匹配到歌曲，所以我们的空间／时间取舍似乎得到了回报。

## Conclusion

Audio fingerprinting seemed magical the first time I saw it. But with a small amount of knowledge about signal processing and basic math, it's a fairly accessible field.

My hope is that anyone reading this will check out the Dejavu Project and drop a few stars on me or, better yet, fork it! Check out Dejavu here:

> [https://github.com/worldveil/dejavu](https://github.com/worldveil/dejavu)

If you liked this post, feel free to [share it with your followers](https://twitter.com/intent/tweet?url=http://willdrevo.com/fingerprinting-and-audio-recognition-with-python&text=Audio%20Fingerprinting%20with%20Python%20and%20Numpy&via=wddrevo) or [follow me on Twitter!](https://twitter.com/wddrevo)

 ## 结论

当我第一次见到音频特征识别的时候，它似乎很神奇。但随着我们掌握一小部分信号处理和基础数学的知识之后，这其实是相当入门的领域。

我希望每一个正在读这篇文章的人都去看下 Dejavu 项目，可以给我加 star，或者更好的是，fork 它。这是 Dejavu 的项目地址：

> https://github.com/worldveil/dejavu

如果你喜欢这篇博客，可以[分享给你的关注者 ](https://twitter.com/intent/tweet?url=http://willdrevo.com/fingerprinting-and-audio-recognition-with-python&text=Audio%20Fingerprinting%20with%20Python%20and%20Numpy&via=wddrevo)或者[在 Twitter 上关注我](https://twitter.com/itsdrevo)!

