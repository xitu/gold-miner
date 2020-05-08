> * 原文地址：[Understand the DEFLATE Compression behind the zip and gzip Formats](https://codeburst.io/understand-the-deflate-compression-behind-the-zip-and-gzip-formats-47e88b13bf3f)
> * 原文作者：[Dornhoth](https://medium.com/@dornhoth)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/understand-the-deflate-compression-behind-the-zip-and-gzip-formats.md](https://github.com/xitu/gold-miner/blob/master/article/2020/understand-the-deflate-compression-behind-the-zip-and-gzip-formats.md)
> * 译者：
> * 校对者：

# Understand the DEFLATE Compression behind the zip and gzip Formats

![Photo by [JJ Ying](https://unsplash.com/@jjying?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/compress?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/10944/1*-epDKh4om1nhGYKdJJN_qw.jpeg)

Whether stored or sent over some network, every bit counts and costs money. There are tens, probably hundreds of compression algorithms available, but the most popular one is probably zip. gzip, even though it has a similar name, is a different algorithm. It is one of the three standard formats used in HTTP compression, making it also a broadly used algorithm. These algorithms are best at different things but share their compression method: DEFLATE \*. DEFLATE is a lossless compression algorithm combining LZ77 and Huffman Coding.

## LZ77

DEFLATE starts with LZ77, which is a lossless compression technique used for text compression.

#### Compression

LZ77 compresses a text by replacing repeated occurrences of data by a pointer to a previous occurrence.

We are not looking for doublons in the whole text at once. We define the size of a search buffer, for example 20 (in real life the size of this buffer is in the tens of kB order). When encoding a letter, we check if the same letter appears in the previous 20 characters. If we find a match, we save the distance of our current letter to that match, `d`. That will be the first part of our encoding. Second, we check if we can match more than just one letter. It can be that the letter following our match is the same as the one following our current letter, in which case we compress them together. We check the next letter, then the next if that one matches too, until it doesn’t match anymore. We save the amount of letters we could match at once as `l`, this is the second part of our encoding.

Let’s see how it works using an example:

```
ERTOORTORR
```

The basic idea is to replace the second occurring `O` by a pointer to the first `O`, or the second occurring `RTO` by a pointer to the first one.

More concretely, we have a sliding window going through the text. For example with a buffer size of 4:

```
1) [....E]RTOORTORR
2) [...ER]TOORTORR
3) [..ERT]OORTORR
4) [.ERTO]ORTORR
5) [ERTOO]RTORR -> ERTO(1, 1)RTOORR
6) E[RTOOR]TORR -> ERTO(1, 1)(4, 3)RR
7) ERTO[ORTOR]R -> ERTO(1, 1)(4, 3)(3, 1)R
8) ERTOO[RTORR] -> ERTO(1, 1)(4, 3)(3, 1)(1, 1)
```

At each iteration, we make the window slide. Until the fourth step, we are only doing that, as there are no match in the search buffer for the letters we are checking. Then on the fifth step, we get a letter that we already have in the search buffer: `O` . The next letter is `R` , we check if by any chance we already have `OR` in the search buffer, this is not the case, so we just replace `O` by `(1, 1)` (one position away, one letter). At the sixth step, we check `R` and find that we already have it in the search buffer. We check with the next letter, `T` , and see that we have `RT` as well. We check with the next one, `O` , yes again, with `RTO` . It stops there. We can therefore replace this 3 letter group by `(4, 3)`, 4 because we are pointing 4 positions before and 3 because we are pointing to a 3 letter group. Finally, in the seventh iteration we find a `R` 3 positions away but no `RR` , and in the eight iteration with find a `R` just before. The final result is :

```
ERTO(1, 1)(4, 3)(3, 1)(1, 1)
```

#### Decompression

A compressed text is a succession of unmatched letters and `(d, l)` pairs. When decompressing, letters stay letters and pairs are replaced by the occurrences they indicate. Let’s take a short example:

```
abc(3, 2)(1, 1)
```

`abc` stays `abc` . Then we have the pair `(3, 2)` , meaning that we have to go 3 positions back, to `a` and take 2 letters, so `ab` . We now have `abcab(1, 1)` . The last pair tells us to take one letter from one position away, so the previous letter `b` . Finally we have `abcabb` .

## Huffman Coding

After having eliminated duplicated series of letters with LZ77, a second compression is done using Huffman coding. This method replaces commonly used symboles by shorter encodings and more rare symboles by longer ones, reducing the total length of the text.

Let’s see with a simple example text how this works.

#### Compression

```
EFTUPOEERRREOOPRRUTUTTEEE
```

We want to make this text smaller without losing any information. Normally, each letter is coded over 8 bits, making this text 200 bits long. Here, like in any real text, letters have different frequencies. `F` appears only once, while `E` appears 7 times. Huffman coding takes advantage of this to optimise the total bit length, by reducing the bit length of more frequent letters.

To compress this file using Huffman coding, we first need to count how often each character appears, in our case:

```
Frequencies: 
E: 7, R: 5, T: 4, U: 3, O: 3, P: 2, F: 1
```

From there, we need to build a tree in which the letters are the leaves. This tree will tell us how to code each letter. We start with the two less frequent letters: `P` and `F`. For each letter we create a node with a weight, the weight being their frequency or number of occurrences in the text to compress. We give them a parent whose weight is the sum of their weights, and obtain a first tree:

```
                                (3)
                               /   \
                             P(2)  F(1)
```

We repeat this with the two next letters, `U` and `O`, then the next ones `R` and `T`, and we finally have a lonely `E` with the weight `7`.

```
       (6)                      (9)                      E(7)
      /   \                    /   \
    U(3)  O(3)               R(5)  T(4)
```

We then combine these little trees to make a bigger tree, starting with the trees whose root nodes have the lowest weight, here the tree made by `P` and `F` on one side and `U` and `O` on the other side:

```
                                (9)
                               /   \
                              /     \
                            (6)     (3)
                           /   \   /   \
                          U     O P     F
```

The next subtree with the lowest weight is now the lonely `E`, we combine it to our tree:

```
                               (16)
                              /    \
                             (9)    E
                            /   \
                           /     \
                         (6)     (3)
                        /   \   /   \
                       U     O P     F
```

And finally we combine our two last subtrees to obtain the complete Huffman tree.

```
                                   (25)
                                  /    \
                                 /      \
                               (16)     (9)
                              /    \   /   \
                             (9)    E R     T
                            /   \
                           /     \
                         (6)     (3)
                        /   \   /   \
                       U     O P     F
```

We now only have to use this tree to code our text in a compressed way. Let’s assign the bit `0` to all left branches and the bit `1` to all right branches and code each letter using the path in the tree to reach them. For example to reach `E` we go once left and once right, so `E` is `10` . To code `U` we go four times left so `U` is `1111` . For F, we go twice left and twice right so `F` is `1100` . You can see on our small example that frequent letters, like `E`, have a smaller code than less frequent letters, like `F`. Finally, our compressed text looks like this:

```
10110000111111011110101001010110111011101101010111110011110000101010
```

It takes 68 bits, instead of 200 originally.

#### Decompression

Now let’s say we receive such a text and want to decompress it to read it. For an uncompress text we know that a character correspond to 8 bits but how do we do now if `011` is one, two or even three characters?

There is no miracle, we need the tree. We can whether save the tree with the compress text, which, in cases like ours, could make the compressed file even bigger than the uncompressed one. Another solution would be to use a common tree that has been decided in advance. We know the frequencies of letters in the English language and could build such a tree based on them. Applying a common tree would not give results as good as by building the tree for a given text, but you would spare having to save the tree with the file. Once again, both solutions have advantages and drawbacks.

---

Even though we didn’t go into the details of the algorithms and their implementations, you now have an idea of how text is being compressed in the zip and gzip formats. I hope your curiosity is satisfied :)

---

\* **Technically, other methods are allowed for the zip format, but DEFLATE is the most common one.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
