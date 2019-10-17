> * 原文地址：[Fountain codes and animated QR](https://divan.dev/posts/fountaincodes/)
> * 原文作者：[Ivan Daniluk](https://github.com/divan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/fountaincodes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/fountaincodes.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[40m41h42t](https://github.com/40m41h42t)，[Ultrasteve](https://github.com/Ultrasteve)

# 喷泉码和动态二维码

![fountain](https://divan.dev/images/fountain.jpg)  
（图像来源：[Anders Sune Berg](https://olafureliasson.net/archive/artwork/WEK110140/waterfall)）

在[前一篇文章](https://divan.dev/posts/animatedqr/)中，我讲解了一个我在周末完成的项目：[txqr](https://github.com/divan/txqr)，它使用了动态二维码序列，可以用于单向的状态传输。最简单直接的方法就是不停重复的编码数据序列，直到接收者获取到了完整的数据。这样简单的重复代码足够初学者用于起步学习，并且很容易执行，但方案还同时引入一定的延迟来防止接收者遗漏任何一帧的信息，在实际应用过程中，错失信息的情况经常出现。

对于如何解决以上这种在有噪信道中传输数据的问题，已经有十分完整的理论研究，那就是编码理论。

在前一篇文章的评论中，[Bojtos Kiskutya](https://disqus.com/by/bojtoskiskutya/) 提到了 LT 码，它可以让 **txqr** 得出更佳结果。这正是我乐意看到的评论 —— 不仅是优化的建议，同时也让我能发现一些新的有趣的内容。由于我从没有接触过 LT 编码，在接下来的几天内我尽我所能的学习了相关的内容。

于是我知道了，[LT codes](https://en.wikipedia.org/wiki/Luby_transform_code)（**LT** 是 卢比变换（**L**uby **T**ransform）的简写）是一个更大的编码方式：[喷泉码](https://en.wikipedia.org/wiki/Fountain_code)的一种实现方式。它是[纠删码](https://en.wikipedia.org/wiki/Erasure_codes)中的一类，它可以从源信息块（K 个）中产生无限数量的数据块，并且它接收比 K 个编码块稍多的信息就足以正确解码信息。接收者可以从任意位置开始接收数据块，也可以按任意顺序接收，并可以设置任意的擦除概率 —— 当你接收到 K 个以上不同的数据块，喷泉码就可以开始工作。这实际上就是“喷泉”这个名字的由来 —— 我们将装满水桶这个行为比作接收信息，喷泉喷出水滴这个行为比作发送一系列编码块，换句话说，你可以在不知晓你当前接收到的是哪一个水滴的情况下，装满你的水桶。

将它用于我的项目简直再合适不过了，所以我快速的搜索了基于 Go 的实现方式：[google/gofountain](https://github.com/google/gofountain)，并将我之前的初级版重复编码的代码替换成了卢比变换的实现。代码替换后的测试结果非常优秀，于是在这篇文章中，我将会分享一些 LT 算法的细节，以及使用 **gofountain** 包容易犯错的地方，最后我还会给出两种代码最终测试结果的对比。

# 喷泉码牛逼！

如果你和我一样，还从未听说过喷泉码，也不用担心 —— 因为喷泉码还属于比较新的技术，目前只能解决一小部分很专业的问题。但是喷泉码其实非常酷。它完美的结合了随机性、数学逻辑以及概率分布，从而达成了它的最终目的。

虽然我主要介绍 LT 编码，但是在这个编码系统中其实还有很多其他算法 —— 比如 [Online codes](https://en.wikipedia.org/wiki/Online_codes)、[Tornado codes](https://en.wikipedia.org/wiki/Tornado_codes)、[Raptor codes](https://en.wikipedia.org/wiki/Raptor_code#Legal_complexity) 等等，这其中 Raptor codes 在除了合法性之外的几乎所有方面都更胜一筹。但是它们似乎都受到严格的专利保护，所以并未得到广泛的应用。

LT 编码的原理相对简单 —— 编码器将信息分割为多个**源信息块**，然后持续的创建**编码块**，这些编码块包含了 1 个或 2 个源信息块，或者更随机的选择**源信息块**并将所有被选择的源信息块作异或操作，得到一个输出。用于创建每个新的**编码块**的 ID 被随机的保存在其中。

![lt encoder](https://divan.dev/images/ltcodes.gif)

在这一轮计算中，编码器会收集所有的**编码块**（就像喷泉中的水珠）—— 它们有的仅包含一个**源信息块**，有的包含两个或者更多 —— 然后将它们和已经解码的块做异或操作来解码还原成新的信息块。

所以，当解码器接收到了仅由一个**源信息块**组成的**编码块** —— 它就将它添加到解码块队列中，不需要其他操作。而如果它接收到了使用两个**源信息块**异或组成的编码快，解码器会检查它们传输时附带的 ID，如果其中一个已经在解码队列中了 —— 那么根据异或操作的性质，恢复这个编码快也就非常简单了。解码两个以上**源信息块**组成的**编码块**也同理 —— 一旦你能获取到一个解码块 —— 只需要继续做异或操作就可以了。

### 孤子分布

最酷的地方在于如何选择多少编码块仅由一个**源信息块**编码而来，以及多少是用两个或更多**源信息块**编码而来。如果有太多的单源信息块编码包，你可能会损失需要的冗余度。而如果太多的多源信息块编码包 —— 那么在一个有噪信道获取单源信息块会花费过多的时间。因此 Luby 编码的命名者，[Michael Luby](https://en.wikipedia.org/wiki/Michael_Luby) 称[孤子分布](https://en.wikipedia.org/wiki/Soliton_distribution)几乎是解决这个问题最完美的分布方式，它能保证你得到足够多的单源信息块编码包，同时也有**很多**的双源信息块编码包，它还有一个很长的尾数，可用于多源信息块编码包直到 N 源信息块编码包，其中 N 是**源信息块**的数量。

![solition distribution](https://divan.dev/images/solition.png)

这是对分布头部数据的更清晰的展示：

![solition distribution zoom](https://divan.dev/images/solition_zoom.png)

你可以看到，这里有一些非零数量的单源信息编码包，其中双源信息编码包占据了分布总量的很大一部分（精确地来说是一半），余下的数量被递减的分布在多源信息编码包中，一个块中包含的源信息块数量越多，这样的编码块就越少。

所有这些特性，让 LT 编码具有了不依赖于发送频率或模式通信信道丢包率的特性。

对于我的 txqr 项目这就意味着，无论使用何种编码和传输参数，使用喷泉码都能够减少平均编码时间。

# google 的 gofountain

谷歌研发的 gofountain 包使用 Go 语言实现了几个喷泉编码，其中包括 Luby 变换码。它的 [API 都很轻量](https://godoc.org/github.com/google/gofountain)（对于库来说，这是一个好兆头）—— 基本只包含了 `Codec` 接口以及一些实现代码、`EncodeLTBlocks()` 函数，和一些作为伪随机生成器的帮助函数。

但是，在试图理解 `EncodeLTBlocks()` 的第二个参数是什么意义的时候，我有些迷惑了：

```
func EncodeLTBlocks(message []byte, encodedBlockIDs []int64, c Codec) []LTBlock
```

为什么我需要将数据块 ID 提供给编码器，我甚至不希望关注数据块的其他属性，因为实现算法应该是库本身而不是使用库用户需要关注的问题。所以最开始我猜测只需传输所有数据块 ID —— `1..N`。

我猜测的和事实很接近 —— 测试的调试输出编码块正如我想要的，但解码过程却总不能正确的执行。

我查看了 [gofountain 的文档页](https://godoc.org/github.com/google/gofountain)，想看看还有什么其他包使用了它，结果发现了一个开源的用于在有损网络环境下传输大型文件的库 —— [pump](https://github.com/sudhirj/pump)，其作者是 [Sudhir Jonathan](https://github.com/sudhirj)，于是我决定借助一下友好的 Gopher 社区的力量，并试着在 Gopher slack 上联系了 Sudhir，询问他是否能帮助我弄明白这些 ID 的用途。

后来我成功的联系到了 Sudhir，他给了我很缜密的答案并解除了我所有的疑惑，这对我帮助非常大。使用这个库正确的方式是将数据块 ID 以递增的顺序连续的发送 —— 例如，`1..N`、`N..2N`、`2N..3N` 等等。因为一般情况下，我们并不知道信道的噪声级别，所以总要生成新的数据块，这是非常重要的。

所以这些 ID 正确的用途应该是循环生成 ID 块，并在一个循环中调用 `EncodeLTBlocks` 函数。但是为了实现这个功能，我必须确保二维码编码速度足够快，能在运行中及时生成新的数据块。对于每秒 15 帧的速率，编码下一个数据块以及生成新的二维码的总时间应小于 1/15 秒，也就是 66ms。很明显这是可行的，但是需要仔细地进行基准测试并优化，以保证对于浏览器上的单核 GopherJS-transpiled 版本也满足这个条件。

另外，目前还有一些设计方面的限制 —— `txqr.Encode()` API 期望能返回一个具体的数字，它表示了将有多少个块会被编码为二维码帧，还有 `txqr-tester` 会生成动态 GIF 文件，确保在浏览器运行时帧率的可靠性，所以我决定现在还是不要打破 API 的限制，使用有冗余因子的方法。

冗余因子方法基于假设：在我的项目中，噪音多少是可以预测的 —— 跳帧不会多于 20%。我们可以生成 `N*redundancyFactor` 个帧，然后像循环代码方法那样做循环，在常规案例中，这是个次优的方案，但是对于我的项目需求和受掌控外部条件，这已经足够了。所以关于 `encodedBlockIDs` 参数，我是用了一个简单的帮助函数：

```
// ids 函数使用 0..n 中的值生成多个 ID 切片
func ids(n int) []int64 {
    ids := make([]int64, n)
    for i := int64(0); i < int64(n); i++ {
        ids[i] = i
    }
    return ids
}
```

通过如下方式调用：

```
    codec := fountain.NewLubyCodec(N, rand.New(fountain.NewMersenneTwister(200)), solitonDistribution(N))

    idsToEncode := ids(int(N * e.redundancyFactor))
    lubyBlocks := fountain.EncodeLTBlocks(msg, idsToEncode, codec)
```

对于不感兴趣 `gofountain` 的读者，这部分可能是一个非必需并且有些无聊的部分，但是我希望对那些也被这个 API 所迷惑的人有帮助，这样他们就可以通过搜索结果找到这篇文章了。

# 测试结果

由于我保存了原始包的 API，余下的工作就非常容易了。你也许记得在[前一篇文章](https://divan.dev/posts/animatedqr/)中，我在 web 端的应用使用了名为 `txqr-tester` 的 txqr 项目的 Go 语言包，它可以在浏览器中运行。在这里，Go 的可跨平台的特性又一次让我感到很兴奋！我只需要切换到包含有新的编码和解码实现的 `fountain-codes` 分支，运行 `go generate` 来执行 `gomobile` 和 `gopherjs` 命令，然后只需要几秒钟，喷泉码应用就可以在 Swift 和浏览器中使用了。

我想，恐怕没有其他的语言能够做到了吧？

接下来我启动了测试程序，包括启动三脚架上的手机以及外界显示器，配置测试参数，以及启动自动测试，这个过程会持续将近半天的时间。这次我没有为了节省时间而修改二维码错误级别，因为似乎这个参数对结果的影响基本可以忽略。

结果让我非常震撼。

测试传输大概 13KB 数据所记录的时间现在只有半秒，准确的说是 **501ms** —— 传输速率就接近 25kbps。这组记录配置的是 12FPS、每个二维码 1850 字节信息，以及低错误矫正等级。解码所需要的时间差异显著下降，因为“需要循环迭代”以及重复代码的部分在这一版本中都没有了。如下是对比**重复代码**和**喷泉码**的解码时间直方图：

[![time_histogram](https://plot.ly/~divan0/15.png?share_key=t8DizOL9dynI6NTcLA88Xi)](https://plot.ly/~divan0/15/?share_key=t8DizOL9dynI6NTcLA88Xi "time_histogram") 

如你所见，大多数配置了不同 FPS 和数据块大小的值的解码测试时间都集中在时间轴上数字比较小的位置 —— 大多数都小于 4 秒。

这是一个更加详细的结果：

[![time_vs_size](https://plot.ly/~divan0/16.png?share_key=t8DizOL9dynI6NTcLA88Xi)](https://plot.ly/~divan0/16/?share_key=t8DizOL9dynI6NTcLA88Xi "time_vs_size") 

测试结果非常优秀，所以我决定使用大于 1000 字节的块来运行测试 —— 块大小最高可以达到 2000 字节。这为我呈现了非常有趣的结果：很多块大小在 1400 到 1700 字节的测试超时了，但是 1800-2000 字节的块的结果确是目前来说最好的：

[![time_vs_size_2k](https://plot.ly/~divan0/7.png?share_key=t8DizOL9dynI6NTcLA88Xi)](https://plot.ly/~divan0/7/?share_key=t8DizOL9dynI6NTcLA88Xi "time_vs_size_2k") 

在这次测试中，FPS 的影响似乎显得更加微不足道了，但是却可以得出所有配置中最好的结果，我甚至可以将其提升到 15FPS：

[![time_vs_fps](https://plot.ly/~divan0/9.png?share_key=t8DizOL9dynI6NTcLA88Xi)](https://plot.ly/~divan0/9/?share_key=t8DizOL9dynI6NTcLA88Xi "time_vs_fps") 

如下是测试结果的完整的可交互 3D 图：

[![3d_results](https://plot.ly/~divan0/18.png?share_key=t8DizOL9dynI6NTcLA88Xi)](https://plot.ly/~divan0/18/?share_key=t8DizOL9dynI6NTcLA88Xi "3d_results") 

# 结论

使用喷泉码绝对是一件让人兴奋的事情。它很出色但是又很简单，虽然应用的范围比较小，但却非常实用、巧妙和快捷，它们绝对是“超酷算法”中的一份子。而当你一旦明白了它们的工作原理，它们就是那些让你敬佩的算法之一了。

对于 txqr 项目，它们也为之带来了性能和可靠性的提升，我期待着可以使用比 LT 编码还要有效率的算法，并实现能适用于喷泉码流线特性的 API。

而 Gomobile 和 Gopherjs 则通过最大可能的减少了使用在浏览器和移动平台中已经编写和测试过的代码的麻烦，又一次展现了它们惊人的一面。

# 参考链接

* [Wikipedia: LT Codes](https://en.wikipedia.org/wiki/Luby_transform_code)
* [Wikipedia: Fountain Codes](https://en.wikipedia.org/wiki/Fountain_code)
* [Damn Cool Algorithms: Fountain Codes by Nick Johnson](http://blog.notdot.net/2012/01/Damn-Cool-Algorithms-Fountain-Codes)
* [Introduction to fountain codes: LT codes with Python by François Andrieux](https://franpapers.com/en/algorithmic/2018-introduction-to-fountain-codes-lt-codes-with-python/)
* [Michael Luby - Fountain Codes (video, 2004)](https://www.youtube.com/watch?v=s3lrmBczBTc)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
