> * 原文地址：[Representing music with Word2vec?](https://towardsdatascience.com/representing-music-with-word2vec-c3c503176d52)
> * 原文作者：[Dorien Herremans](https://medium.com/@dorien.herremans)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/representing-music-with-word2vec.md](https://github.com/xitu/gold-miner/blob/master/TODO1/representing-music-with-word2vec.md)
> * 译者：
> * 校对者：

![](https://cdn-images-1.medium.com/max/1600/0*5vTITPYMya0GrTaN)

# Representing music with Word2vec?

Machine learning algorithms have transformed the field of vision and NLP. But what about music? These last few years, the field of music information retrieval (MIR) has been experiencing a rapid growth. We will be looking at how some of these techniques from NLP can be ported to the field of music. In a recent paper by [Chuan, Agres, & Herremans (2018)](http://link.springer.com/article/10.1007/s00521-018-3923-1), they explore how a popular technique from NLP, namely word2vec, can be used to represent polyphonic music. Let's dive into how this was done...

## Word2vec

Word embedding models make it possible for us to represent words in a meaningful way such that machine learning models can more easily process them. They allow us to represent words by a vector that represents semantic meaning. Word2vec is a popular vector embedding model developed by Mikolov et al. (2013), that can create semantic vector spaces in a very efficient manner.

The essence of word2vec is a simple one-layer neural network, built in two possible ways: 1) using continuous bag-of-words (CBOW); or 2) using a skip-gram architecture. Both architectures are quite efficient and can be trained relatively quickly. In this study, we use a skip-gram model, as Mikolov et al. (2013) has hinted at them being more efficient for smaller datasets. Skip-gram architectures take a current word w_t (input layer) and try to predict the surrounding words in the context window (output layer):

![](https://cdn-images-1.medium.com/max/1600/0*sl2WQJQUaD6WoU-w.png)

Figure from [Chuan et al (2018)](http://link.springer.com/article/10.1007/s00521-018-3923-1). Illustration of a word t and its surrounding context window.

There is some confusion about how a skip-gram architecture looks like due to some [popular images](https://cdn-images-1.medium.com/max/800/1*SR6l59udY05_bUICAjb6-w.png) floating around the internet. The network output does not consist of multiple words, but of one single word from the context window. How can it learn to represent the entire context window? While training the network, we use sampled pairs, consisting of the input word with a random word from the context window.

The traditional training objective of this type of network includes a softmax function to calculate 𝑝(𝑤_{𝑡+𝑖}|𝑤_𝑡), whose gradient is expensive to calculate. Luckily, techniques such as noise contrastive estimation (Gutmann & Hyvärine, 2012) and negative sampling (Mikolov et al, 2013b) offer a solution. We used negative sampling to basically define a new objective: maximise the probability of real words and minimise that of noise samples. A simple binary logistic regression classifies noise samples from real words.

Once a word2vec model is trained, the weights of the hidden layer basically represent the learned, multidimensional, embeddings.

## Music as words?

Music and language are intrinsically related. Both consist of a series of sequential events that follow a set of grammatical rules. More importantly, they both create expectation. Imagine that I say: "I am going to the pizzeria to buy a ...". This generates a clear expectation... pizza. Now imagine I hum you the melody line of Happy Birthday, but I stop just before the last note... Just like a sentence, melodies generate expectations. So much expectatio, that it can be measured by EEGs as, for instance, N400 event-related potentials in the brain (Besson & Schön, 2002).

Given the similarity between language and words, let's see if a popular model for language can be used as a meaningful representation of music. To convert a midi file to 'language', we define 'slices' of music (which will be our equivalent to words). Each musical piece in our dataset is segmented into equal duration, non-overlapping, slices of a beat long. The duration of a beat can differ for each piece and is estimated by [MIDI toolbox](about:invalid#zSoyz). For each of these slices, we keep a list of all pitch classes, i.e., pitches without octave information.

The figure below shows an example of how slices are determined for the first bars of Chopin's Mazurka Op. 67 №4. A beat is a quarter note long here.

![](https://cdn-images-1.medium.com/max/1600/0*Ho_dJEmlWHsAjLow.png)

Figure from [Chuan et al (2018) ](http://link.springer.com/article/10.1007/s00521-018-3923-1)--- Creating words from slices of music

## Word2vec learns tonality --- distributional semantics hypothesis for music

In language, the distributional semantics hypothesis drives the motivation behind vector embeddings. It states that "words that appear in the same contexts tend to have similar meanings" (Harris, 1954). Translated to vector spaces, this means that these words will be geometrically close to each other. Let's discover if the word2vec model learns a similar representation for music.

### Dataset

Chuan et al. use a [MIDI dataset](https://www.reddit.com/r/datasets/comments/3akhxy/the_largest_midi_collection_on_the_internet) that contains a mix of eight different genres (from classical to metal). From a total of 130,000 pieces, only 23,178 pieces were selected based on the presence of a genre label. Within these pieces, there were 4,076 unique slices

### Hyperparameters

The model was trained using only the 500 most occurring slices (or words), a dummy word was used to replace the others. This procedure augments the accuracy of the model as more information (occurrences) is available of the included words. Other hyperparameters include a learning rate of 0.1, skip window size of 4, number of training steps (1,000,000), and 256 as the size of the embeddings.

### Chords

To evaluate whether semantic meaning of the musical slices is captured by the model, let's look at chords.

In the slice vocabulary, all of the slices containing triads were identified. These were then labeled with their scale degree in Roman numerals (as often done in music theory). For instance, in the key of C, the chord C is I, the G chord on the other hand is represented as V. Cosine distance was then used to calculate how far chords of different scale degrees were from each other in the embedding.

The Cosine distance Ds(A, B) between two non-zero vectors A and B, in an *n-*dimensional space,is calculated as:

D𝑐(A,B)=1-cos(𝜃)=1-D𝑠(A,B)

Whereby 𝜃 is the angle between A and B, and Ds is the cosine similarity:

![](https://cdn-images-1.medium.com/max/1600/1*QgZYudn4WhqfTVk0cQPgsw.png)

From a music theory perspective, the 'tonal' distance between a I chord and V should be smaller than say, a I chord and III. The figure below shows the distances between a C major triad and other chords.

![](https://cdn-images-1.medium.com/max/1600/1*Rmfm-Tt8rF_g_tRE8pgABA.png)

Figure from [Chuan et al (2018)](http://link.springer.com/article/10.1007/s00521-018-3923-1) --- Cosine distance between triads and the tonic chord = C major triad.

The distance between a I triad to V, IV, and vi are smaller! This corresponds to how they are perceived as 'tonally closer' in music theory, and indicates that the word2vec model learns meaningful relationships between our slices.

*It seems that the cosine distance between chords in word2vec space reflects the functional roles of chords in music theory!*

### Keys

Looking at Bach's Well-Tempered Clavier (WTC)'s 24 preludes, which contain a piece in each of the 24 keys (major and minor), we can study if the new embedding space captured information about key.

The augment the dataset, each of the pieces was transposed to each of the other major or minor keys (depending on the original key), this resulted in 12 versions of each piece. The slices of each of these keys were mapped onto the previously trained vector space and clustered using k-means, such that we get a centroid for each piece in the new dataset. By transposing the pieces to each key, we make sure that the cosine distance between centroids is only affected by 1 element: key.

The resulting cosine distances between each centroid of pieces in different keys are shown in the figure below. As expected, fifths apart are tonally close and are represented as the darker areas next to the diagonal. Tonally far apart keys (e.g. F and F#) have an orange colour, which confirms our hypothesis that the word2vec space reflects tonal distances between keys!

![](https://cdn-images-1.medium.com/max/1600/0*TdjQRpqCOLu6ilBf.png)

Figure from [Chuan et al (2018)](http://link.springer.com/article/10.1007/s00521-018-3923-1)--- similarity matrix based on cosine distance between pairs of preludes in different keys.

### Analogy

One of the striking examples of word2vec is the [image](https://www.distilled.net/uploads/word2vec_chart.jpg) that shows translations between king → queen, and man → women, in the vector space (Mikolov et al., 2013c). This shows that meaning can be brought forward through a vector translation. Does this work for music too?

We first detect the chords from polyphonic slices, and look at a chord-pair vectors, going from C major to G major (I-V). The angle between different I-V vectors is shown to be very similar (see figure on the right), and can even be thought of as a multidimensional circle of fifths. This again confirms that the concept of analogy may be present inmusical word2vec spaces, although more investigation is needed to uncover clearer examples.

![](https://cdn-images-1.medium.com/max/1600/0*qUbokC9N7ZEmV3js.png)

Figure from [Chuan et al (2018)](http://link.springer.com/article/10.1007/s00521-018-3923-1) --- angle between chord-pair vectors.

### Other applications --- music generation?

Chuan et al. (2018) briefly look at how the model can be used to replace slices of music to form new music. They indicate that this is just a preliminary test, but the system could be used as a representation method in a more comprehensive system, e.g. LSTM. More details are given in the scientific paper, but the figure below gives an impression of the result.

![](https://cdn-images-1.medium.com/max/1600/0*MTsizhLreNTZ9UC6.png)

Figure from [Chuan et al (2018)](http://link.springer.com/article/10.1007/s00521-018-3923-1) --- Replacing slices with geometrically close slices.

## Conclusion

Chuan, Agres, and Herremans (2018) built a word2vec model that captures tonal properties of polyphonic music, without ever feeding the actual notes into the model. The article shows convincing evidence that information about chords and keys can be found in the novel embeddings, so to answer the question i the title: Yes we can represent polyphonic music with word2vec! Now the road is open for embedding this representation into other models that also capture time aspects of music.

## References

- Besson M, Schön D (2001) Comparison between language and music. Ann N Y Acad Sci 930(1):232--258.
- Chuan, C. H., Agres, K., & Herremans, D. (2018). From context to concept: exploring semantic relationships in music with word2vec. *Neural Computing and Applications --- Special issue on Deep Learning for Music and Audio*, 1--14. [Arxiv preprint](https://arxiv.org/abs/1811.12408).
- Gutmann MU, Hyvärinen A (2012) Noise-contrastive estimation of unnormalized statistical models, with applications to natural image statistics. J Mach Learn Res 13(Feb):307--361
- Harris ZS (1954) Distributional structure. Word 10(2--3):146--162.
- Mikolov, T., Chen, K., Corrado, G., & Dean, J. (2013). Efficient estimation of word representations in vector space. *arXiv preprint arXiv:1301.3781.*
- Mikolov T, Sutskever I, Chen K, Corrado GS, Dean J (2013b) Distributed representations of words and phrases and their compositionality. In: Proceedings of advances in neural information processing systems (NIPS), pp 3111--3119
- Mikolov T, Yih Wt, Zweig G (2013c) Linguistic regularities in continuous space word representations. In: Proceedings of the 2013 conference of the North American chapter of the association for computational linguistics: human language technologies, pp 746--751

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
