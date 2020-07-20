> * 原文地址：[How to Hide Secrets in Strings— Modern Text hiding in JavaScript](https://blog.bitsrc.io/how-to-hide-secrets-in-strings-modern-text-hiding-in-javascript-613a9faa5787)
> * 原文作者：[Mohan Sundar](https://medium.com/@itsmohanpierce)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-hide-secrets-in-strings-modern-text-hiding-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-hide-secrets-in-strings-modern-text-hiding-in-javascript.md)
> * 译者：
> * 校对者：

# How to Hide Secrets in Strings — Modern Text hiding in JavaScript

![**All Hallows’ Eve — Illustrated by [Kaiseir](https://dribbble.com/kaiseir)**](https://cdn-images-1.medium.com/max/2000/1*HOGI5cdt1MJ9MBo1qTc1zA.jpeg)

> Sometimes the best hiding place is the one that’s in plain sight.

If you were a spy in a hostile country, merely sending a message back to the US would be incriminating. If that message was encrypted, it’d probably be a whole bunch more incriminating, and things would only get worse when you, the spy, refused to decrypt the message for the authorities. **Steganography**, which literally means “hidden writing”, is about hiding the existence of a message.

Chet Hosmer, founder of [**Python Forensics**](http://python-forensics.org/) pointed out that

> Steganography hides the mere existence of the communication. Unlike its cousin cryptography, which is easy to detect but difficult to break, steganography provides the most interesting element of all ‘To Hide in Plain sight’.

![Cloak of invisibility](https://cdn-images-1.medium.com/max/2000/1*Ze0Yy0Op7kqT8fJ3Le5FSg.gif)

**Did you know that the steganography quote above, has a hidden secret that is invisible?** Would you have been able to detect its existence if I hadn’t mentioned it? Well, check out the rest of the article, to make sense out of it.

## Invisible characters in Unicode

Zero Width Characters are non-printing characters, a part of the Unicode table. As the name suggests they don’t even show their presence. They are used to enable line wrapping in long words, joining emojis, combine two characters into a ligature, keep them from joining, etc.

![The characters `zwj` join the emoji’s but they are not visible](https://cdn-images-1.medium.com/max/2000/1*ATrlUYwomSvUtygin5ndIA.png)

These characters have increasingly found their way in-text hiding, their complete invisibility being a remarkable selling point. They cannot be blocked as they are integral in multiple languages and emojis. And it also turns out that ZWCs aren’t the only characters which are invisible, eg. Invisible separator — U+2063.

![The table that contains mostly used invisible characters](https://cdn-images-1.medium.com/max/2000/1*eP3yPonDN-Px68R1gO0PXw.png)

One small problem with this table tho! Gmail blocks U+200B ( Zero width space ). Not to mention, Twitter is known for blacklisting unnecessary invisible characters, none of the characters in the table except U+200C, U+200D and U+180e works. So we now have three characters!

![](https://cdn-images-1.medium.com/max/2160/1*pnl_e3gWWQ3z1l58LTxaBg.jpeg)

Oh, wait, U+180e is not invisible and renders weirdly in iOS devices. We are now down to only 2 characters.

So we tore apart the Unicode table and started to test each possible Invisible character for its cross-platform / web invisibility. Fortunately, we were able to add 4 more characters to our arsenal, a total of 6 invisible characters that we can now use to hide our secrets in strings. All set! Ready to strike ..!

![Assemble!](https://cdn-images-1.medium.com/max/2000/1*HSPg4C9SGIT9-O6GWK0img.gif)

## What is StegCloak and how it works?

StegCloak is a pure JavaScript steganography module that can be used to hide secrets inside plain text after going through two layers of maximum possible compression and a layer of encryption. So not only does it cloak the secret, but it also protects it with a password of your choice along with an array of other features. **[Check out our demo here](https://www.youtube.com/watch?v=RBDqZwcGvQk).**

#### Hide

![Hiding secrets in tweets](https://cdn-images-1.medium.com/max/2000/1*i-woBuZ902ZSMsrj9xSnoA.gif)

#### Reveal

![Extracting hidden secret from the tweet](https://cdn-images-1.medium.com/max/2000/1*DqpMYkBY5NUdbw5wUKXliw.gif)

#### A brief idea of how StegCloak hides your secrets and compresses it

Step 1: **Compress and Encrypt** the secret.

![](https://cdn-images-1.medium.com/max/2000/1*ALhxrbOw6UBJf858ckg9ew.png)

Security never played a role in these kinds of “hacks” and with StegCloak we wanted it to satisfy [**Kerckhoff’s principle](https://en.wikipedia.org/wiki/Kerckhoffs%27s_principle)** which states:

> An ideal crypto-system should be secure even if everything about the system is exposed to the public except the secret key.

Even if the attacker identifies how the algorithm works, it should not be possible to reveal the secret message.

#### Satisfying the principle

![](https://cdn-images-1.medium.com/max/2000/1*Bqj9PFww4K_VhaWfODqgMg.png)

For this, we need password-based symmetric encryption. Considering human tendencies to use small and weak passwords and also their preference to use the same password multiple times, we decided to derive a strong key from the given password and also increase the randomness of the key by introducing random salts. Randomness in the key is required to prevent attacks based on the analysis of multiple ciphertexts generated with the same key. Now, the usual block cipher modes in AES like ECB or CBC resulted in additional padding of a minimum of 16 bytes block. So to send “Hi” CBC mode pads 0’s to make it 16 in length, and removes them during extraction. This is bad. Therefore, we used the stream cipher mode CTR (padding less cipher)to generate the ciphertext.

![](https://cdn-images-1.medium.com/max/2000/1*b_0-voMOjqM2Jk1EKCZ1Fw.png)

Step 2: **Encode and compress again** with the extra two characters.

![](https://cdn-images-1.medium.com/max/2000/1*FEstcl9rEF0eX8Q3n0u4pg.png)

![](https://cdn-images-1.medium.com/max/2000/1*HfXp1u543ZaLCC5MaQ05_w.png)

As shown in the above figure, even though we had six ZWC characters only 4 were used as 6 is not a power of 2.The two extra characters (U+2063, U+2064) are used to do an additional layer of abstracted Huffman compression reducing redundancy. After the secret has been converted to ZWCs, the two most repeating ZWCs in the stream are determined, say U+200D and U+200C. Now every two consecutive occurrences of U+200Ds and U+200Cs are replaced with one U+2063 or U+2064. This saves a lot as redundancy was frequently observed.

Step 3: **Embed the invisible stream** to the first space of the cover text.

![](https://cdn-images-1.medium.com/max/2000/1*23avUCEVPdvmQr62z1eCzw.gif)

`Hi` is now hidden in hello world as 6 characters, so now the total length of this string is

10 + 6 = 16 characters

#### Extraction

![](https://cdn-images-1.medium.com/max/2000/1*19IYY7Rw7rL76YX0NnmL5Q.gif)

Just the vice versa, nothing complicated but given that the payload’s length increases when we add features like encryption and invisibility, we do two layers of compression ( before and after ) to minimize the cost as much as we can. So it’s just a small price to pay for salvation.

![](https://cdn-images-1.medium.com/max/2000/1*p2dPqMPTmSxW9ndw7OjMKw.gif)

You can at any point of time turn off certain features to reduce the payload length, we designed StegCloak to be flexible to user needs.

## Style of the module

> Life is much more easier when you can visualise your functions as a curve in a graph — Kyle simpson

StegCloak follows the functional programming paradigm and as a whole consists of only two functions: hide and reveal. These two functions are built using multiple small Lego pieces. These pieces are nothing but Pure functions or Different versions of the same pure function that was curried etc. StegCloak has only one impure function which is `encrypt()` as it generates a random salt for increasing the security of the cipher.

#### Flow

![How it works!](https://cdn-images-1.medium.com/max/2000/1*krNVCV3uhVJ2QTHKczM43w.png)

In my perspective, having a functional approach makes your program look more like a flow chart thus increasing its readability.

![**Hide( )** in stegcloak.js](https://cdn-images-1.medium.com/max/3940/1*Vn7gxNmZVkVPQqgZuwOIOQ.png)

![**Reveal( )** in stegcloak.js](https://cdn-images-1.medium.com/max/4096/1*aN2AczUqvlXG6XtijJPNfA.png)

StegCloak uses a functional programming library called RamdaJS. The R.Pipe takes in functions and passes the arguments to the first function where its output is given as the input to the next function in the pipe. You can see that the pieces can be proxied to another pipe or operated on before being sent to the next pipe. Readability and point-free style were one of the biggest focus of the design

## Unfolding the mystery of the quote

* Copy Chet Hosmer’s quote above and visit [stegcloak.surge.sh](https://stegcloak.surge.sh)
* Type the password — “Aparecium” in Reveal

![](https://cdn-images-1.medium.com/max/2000/1*k5OSMLvm-vZesGylNImJEA.png)

* Paste the copied quote in the STEGCLOAKED MESSAGE text box

![](https://cdn-images-1.medium.com/max/2000/1*9Qd64_Y8acVK4uP9E9e9fg.png)

* Click **GET SECRET** and Voila!

## Conclusion

This was built by [myself](https://www.linkedin.com/in/mohan-sundar-9881a7180/) and two of my friends [Jyothishmathi CV](https://www.linkedin.com/in/c-v-jyothishmathi-791578181/), [Kandavel](https://www.linkedin.com/in/ak5123/)

We hope you enjoy it as much as we did building it!

Checkout [StegCloak](https://stegcloak.surge.sh/) in [Github](https://github.com/KuroLabs/stegcloak) or visit [https://stegcloak.surge.sh](https://stegcloak.surge.sh).

Thank you for reading this article 🖤.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
