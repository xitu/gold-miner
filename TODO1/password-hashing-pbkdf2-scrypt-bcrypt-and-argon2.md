> * 原文地址：[Password Hashing: PBKDF2, Scrypt, Bcrypt and ARGON2](https://medium.com/@mpreziuso/password-hashing-pbkdf2-scrypt-bcrypt-and-argon2-e25aaf41598e)
> * 原文作者：[Michele Preziuso](https://medium.com/@mpreziuso)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/password-hashing-pbkdf2-scrypt-bcrypt-and-argon2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/password-hashing-pbkdf2-scrypt-bcrypt-and-argon2.md)
> * 译者：
> * 校对者：

# Password Hashing: PBKDF2, Scrypt, Bcrypt and ARGON2

There’s always a lot of debate in regards to how to safely store passwords and what algorithm to use: MD5, SHA1, SHA256, PBKDF2, Bcrypt, Scrypt, Argon2, plaintext??

So I tried to analyse and summarise the most recent and reasonable choices: Scrypt, Bcrypt and Argon2. …and yes, MD5, SHA1, SHA256 are not suitable for storing passwords! 😉

![](https://cdn-images-1.medium.com/max/3840/1*6AmtTHis9u0viVhIzg9tsA.png)

#### A summary

In 2015, I’ve published ‘[Password Hashing: PBKDF2, Scrypt, Bcrypt](https://medium.com/@mpreziuso/password-hashing-pbkdf2-scrypt-bcrypt-1ef4bb9c19b3)’ intended as an extended reply to a friend’s question.

Summarily saying that:

> Attackers have usually different and more specialised (powerful) hardware than ours;
>
> Attackers use specialized hardware because it can be tailored to the algorithm, the different hardware architecture allows certain algorithm to run faster than on non-specialised hardware (CPU) and - overall - certain algorithms can be parallelised;
>
> We rely on slow-hashing functions to hash passwords in order to fight the attacker on equal grounds: your power unit (CPU/GPU) against his GPU/FPGA/ASIC

**All of the above is still true**, however the race to cryptocurrencies added another facet to it: with multi-billion dollar market caps, the fastest software/hardware implementation of the underlying crypto algorithm of a cryptocurrency is also the one with an advantage against other miners and thus the most profitable one.

Whilst Bitcoin uses SHA256 as the underlying crypto function (which can therefore be greatly optimised on optimised hardware making it an ‘unfair’ coin for miners) other creators have tried to make new cryptocurrencies more fair to mine by relying on memory-hard: [Litecoin](https://litecoin.org/) ([Scrypt](https://en.wikipedia.org/wiki/Scrypt)) as an early example and [Zcash](https://z.cash/) ([Equihash](https://en.wikipedia.org/wiki/Equihash)) as a more recent one.

This means that the same slow-functions that are used for password hashing are being used to protect millions or even billions of dollars in cryptocurrencies, making the building of the fastest implementation of the slow hashing function even more rewarding and usually [publicly available](https://github.com/tpruvot/ccminer)!

#### What’s safe today then?

The principle is still the same: we need a slow function that’s been vetted by the crypto community and remains unbroken.

**PBKDF2** has been out there for a long time and hasn’t aged very well as discussed in [the previous article](https://medium.com/@mpreziuso/password-hashing-pbkdf2-scrypt-bcrypt-1ef4bb9c19b3): easily parallelised on multi-core systems (GPUs) and trivial for tailored systems (FPGAs/ASICs). So it’s a No from me.

**BCrypt** has been out there since 1999 and does a better job at being GPU/ASIC resistant than PBKDF2 but I wouldn’t recommend it for new systems as it doesn’t shine in a threat model with offline cracking.
While some cryptocurrencies rely on it (i.e. NUD), it hasn’t gained a lot of popularity and - consequentially - enough interest from the FPGA/ASIC community to build a hardware implementation of it.
That being said, [Solar Designer](https://twitter.com/solardiz) (OpenWall), Malvoni and Knezovic (University of Zagreb) have written [a paper in 2014](https://www.usenix.org/system/files/conference/woot14/woot14-malvoni.pdf) describing a hybrid a system of ARM/FPGA SOCs to attack the algorithm.

**SCrypt** is a better choice today: better design than BCrypt (especially in regards to memory hardness) and has been in the field for 10 years.
On the other hand, it has been used for many cryptocurrencies and we have a few hardware (both FPGA and ASIC) implementation of it.
Even though they’re specifically for mining they can be repurposed for cracking.

## Argon2

Shortly after writing [my initial article](https://medium.com/@mpreziuso/password-hashing-pbkdf2-scrypt-bcrypt-1ef4bb9c19b3), Argon2 won the [PHC](https://password-hashing.net/) in July 2015.

#### The competition

The competition was initiated in fall 2012, in Q1 2013 the board published a call for submissions and the deadline was end of March 2014. As part of the competition, the panelists thoroughly reviewed the submissions and published an initial [short report](https://password-hashing.net/report-finalists.html) where they describe their selection criteria and rationale.

#### An introduction

There are two main versions of Argon2: **Argon2i** which is the safest option against side-channel attacks and **Argon2d** which is the safest option against GPU cracking attacks.

Source code is available on [GitHub](https://github.com/p-h-c/phc-winner-argon2), written in C89-compliant C, licensed under CC0 and compiles on most ARM, x86 and x64 architectures.

#### AES based

Argon2 is based on [AES](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) which modern x64 and ARM processors implement in their instruction set extensions, thus greatly closing the performance gap between common systems and the attackers’.

#### Parameters for fine-tuning

Both versions of the algorithm can be parameterised by:

* A **time** cost, which defines the execution time
* A **memory** cost, which defines the memory usage
* A **parallelism** degree, which defines the number of threads

this means that you can separately tune these parameters and tailor the security bound to your use case, threat model and hardware specifications.

#### Tradeoff attacks

On top of this, Argon2 is particularly resistant to **ranking tradeoff attacks** making it much more difficult to cheaply optimise on FPGAs: even though recent FPGAs have embedded RAM blocks, memory bandwidth is still a constrain and in order to reduce the memory bandwidth requirements, the attacker must use more computational resources with Argon2.

This and similar attacks are discussed in the [specs](https://github.com/P-H-C/phc-winner-argon2/blob/master/argon2-specs.pdf) (see chapter 5) as well as in a [separate paper](https://orbilu.uni.lu/bitstream/10993/20043/1/Tradeoff%20Cryptanalysis.pdf) by the same authors where they also compare it with scrypt.

#### Argon2id

The below is a quote/paraphrase from [the Argon2 IETF Draft](https://datatracker.ietf.org/doc/draft-irtf-cfrg-argon2/).

> **Argon2d** uses data-depending memory access, which makes it suitable for cryptocurrencies and PoW applications with no threats from side-channel timing attacks. **Argon2i** uses data-independent memory access, which is preferred for password hashing. **Argon2id** works as Argon2i for the first half of the first iteration over the memory and as Argon2d for the rest, thus providing both side-channel attack protection and bruteforce cost savings due to time-memory tradeoffs. Argon2i makes more passes over the memory to protect from tradeoff attacks.

![Source: news.mit.edu](https://cdn-images-1.medium.com/max/2000/1*KqtiDTgnOuf5S0WTA6vsqQ.png)

If you fear side-channel attacks (i.e. [Meltdown/Spectre](https://meltdownattack.com/) which allow reading private memory of other processes running on the same hardware via cache-based side channels) you should use Argon2i, otherwise Argon2d.
If you are unsure or if you’re comfortable with a hybrid approach you can use Argon2id to have the best of two worlds.

## Conclusion

In 2019 I’d recommend **not to use** PBKDF2 or BCrypt in the future and highly recommend Argon2 (preferrably Argon2id) for newer systems.

Scrypt can be a second choice on systems where Argon2 is not available, but keep in mind that it has the same issues with respect to side-channel leakage.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
