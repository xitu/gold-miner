> * 原文地址：[Spotify’s Discover Weekly: How machine learning finds your new music](https://hackernoon.com/spotifys-discover-weekly-how-machine-learning-finds-your-new-music-19a41ab76efe)
> * 原文作者：[Sophia Ciocca](https://hackernoon.com/@sophiaciocca?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/spotifys-discover-weekly-how-machine-learning-finds-your-new-music.md](https://github.com/xitu/gold-miner/blob/master/TODO/spotifys-discover-weekly-how-machine-learning-finds-your-new-music.md)
> * 译者：
> * 校对者：

# Spotify’s Discover Weekly: How machine learning finds your new music: The science behind personalized music recommendations

This Monday — just like every Monday— over 100 million Spotify users found a fresh new playlist waiting for them. It’s a custom mixtape of 30 songs they’ve never listened to before but will probably love. It’s called Discover Weekly_,_ and it’s pretty much magic.

I’m a huge fan of Spotify, and particularly Discover Weekly. Why? It makes me feel _seen._ It knows my musical tastes better than any person in my life ever has, and I am consistently delighted by how it satisfies me _just right_ every week, with tracks I myself would never have found or known I would like.

For those of you who live under a musically soundproof rock, let me introduce you to my virtual best friend:

![A Spotify Discover Weekly playlist — specifically, mine.](https://cdn-images-1.medium.com/max/800/0*zl0-pZtZzslGC-R8.)

As it turns out, I’m not alone in my obsession with Discover Weekly—the user base went crazy for it, which has driven Spotify to completely rethink its focus, investing more resources into algorithm-based playlists.

Ever since Discover Weeklydebuted in 2015, I’ve been dying to know how it worked (plus I’m a fangirl of the company, so sometimes I like to pretend I work there and research their products.) After three weeks of mad googling, I feel grateful to have finally gotten a glimpse behind the curtain.

So how does Spotify do such an amazing job of choosing those 30 songs for each person each week? Let’s zoom out for a second to look at how other music services have done music recommendations, and how Spotify’s doing it better.

* * *

![](https://cdn-images-1.medium.com/max/800/1*lys6vccczPSJiyOTiMEp8g.png)

Back in the 2000s, Songza kicked off the online music curation scene using **manual curation** to create playlists for users. “Manual curation” meant that some team of “music experts” or other curators would put together playlists by hand that they thought sounded good, and then listeners would just listen to their playlists. (Later, Beats Music would employ this same strategy.) Manual curation worked okay, but it was manual and simple, and therefore **it couldn’t take into account the nuance of each listener’s individual music taste.**

Like Songza, Pandora was also one of the original players in the music curation scene. It employed a slightly more advanced approach, instead **manually _tagging attributes_**of songs. This meant a group of people listened to music, chose a bunch of descriptive words for each track, and tagged the tracks with those words. Then, Pandora’s code could simply filter for certain tags to make playlists of similar-sounding music.

Around that same time, a music intelligence agency from the MIT Media Lab called The Echo Nest was born, which took a radically more advanced approach to personalized music. The Echo Nest used **algorithms to analyze the audio and textual content** of music, allowing it to perform music identification, personalized recommendation, playlist creation, and analysis.

Finally, taking yet another different approach is Last.fm, which still exists today and uses a process called **collaborative filtering** to identify music its users might like_._ More on that in a moment.

* * *

So if that’s how _other_ music curation services have done recommendations, how does Spotifycome up with _their_ magic engine, which seems to nail individual users’ tastes so much more accurately than any of the other services?

## Spotify’s 3 Types of Recommendation Models

Spotify actually doesn’t use a single revolutionary recommendation model — instead, **they mix together some of the best strategies used by other services to create its own uniquely powerful Discovery engine.**

To create Discover Weekly, there are three main types of recommendation models that Spotify employs:

1. **Collaborative Filtering**models (i.e. the ones that Last.fm originally used), which work by analyzing *your* behavior and *others’* behavior.
2. **Natural Language Processing (NLP)** models, which work by analyzing *text.*
3. **Audio** models, which work by analyzing the *raw audio tracks* *themselves*.

![Image credit: Chris Johnson, Spotify](https://cdn-images-1.medium.com/max/800/1*cp07MRMUjndZsvV7QElSXg.png)

Let’s take a dive into how each of these recommendation models work!

* * *

## Recommendation Model #1: Collaborative Filtering

![](https://cdn-images-1.medium.com/max/800/1*Lfl5nMKUwGjhZvC_3vPCKQ.png)

First, some background: When many people hear the words “collaborative filtering”, they think of **Netflix**, as they were one of the first companies to use collaborative filtering to power a recommendation model, using users’ star-based movie ratings to inform their understanding of what movies to recommend to *other “*similar” users.

After Netflix used it successfully, its use spread quickly, and now it’s often considered the starting point for anyone trying to make a recommendation model.

Unlike Netflix, though, Spotify doesn’t have those stars with which users rate their music. Instead, Spotify’s data is **implicit feedback** — specifically, the **stream counts** of the tracks we listen to, as well as additional streaming data, including whether a user saved the track to his/her own playlist, or visited the Artist page after listening.

But what *is* collaborative filtering, and how does it work? Here’s a high-level rundown, as encapsulated in a quick conversation:

![Image by Erik Bernhardsson](https://cdn-images-1.medium.com/max/800/1*shZ8Pwo8_OqDw2Udjb12XA.png)

What’s going on here? Each of these two guys has some track preferences — the guy on the left likes tracks P, Q, R, and S; the guy on the right likes tracks Q, R, S, and T.

Collaborative filtering then uses that data to say,

*“Hmmm. You both like three of the same tracks — Q, R, and S — so you are probably similar users. Therefore, you’re each likely to enjoy other tracks that the other person has listened to, that you haven’t heard yet.”*

It therefore suggests that the guy on the right check out track P, and the guy on the left check out track T. Simple, right?

But how does Spotify actually usethat concept in practice to calculate *millions* of users’ suggested tracks based on _millions_ of other users’ preferences?

**…matrix math, done with Python libraries!**

![](https://cdn-images-1.medium.com/max/800/1*oGub3-TXJSNvKz1GQtbJxQ.png)

In actuality, this matrix you see here is *gigantic*. **Each row represents one of Spotify’s 140 million users** (if you use Spotify, you yourself are a row in this matrix) and **each column represents one of the 30 million songs** in Spotify’s database.

Then, the Python library runs this long, complicated matrix factorization formula:

![Some complicated math…](https://cdn-images-1.medium.com/max/800/1*a1a_pG-shrVnvMZefrC-hg.png)</div>

When it finishes, we end up with two types of vectors, represented here by X and Y. **X is a *user* vector**, representing one single user’s taste, and **Y is a *song* vector**, representing one single song’s profile.

![The User/Song matrix produces two types of vectors: User vectors and Song vectors.](https://cdn-images-1.medium.com/max/800/1*cs6FT4dt3sujiauIKF_HYg.png)

Now we‘ve got 140 million user vectors — one for each user — and 30 million song vectors. The actual content of these vectors is just a bunch of numbers that are essentially meaningless on their own, but they are hugely useful for comparison.

To find which users have taste most similar to mine, collaborative filtering compares my vector with all of the other users’ vectors, ultimately revealing the most similar users to me. The same goes for the Y vector, _songs _— you can compare a song’s vector with all the other song vectors, and find which songs are most similar to the one you’re looking at.

Collaborative filtering does a pretty good job, but Spotify knew they could do even better by adding another engine. Enter NLP.

* * *

## Recommendation Model #2: Natural Language Processing (NLP)

The secondtype of recommendation model that Spotify employs are **Natural Language Processing (NLP) models**. These models’ source data, as the name suggests, are regular ol’ *words* — track metadata, news articles, blogs, and other text around the internet.

![](https://cdn-images-1.medium.com/max/800/0*NXVODvFr8yVL4_fv.)

Natural Language Processing — the ability of a computer to understand human speech as it is spoken — is a whole vast field unto itself, often harnessed through sentiment analysis APIs.

The exact mechanisms behind NLP are beyond the scope of this article, but here’s what happens on a very high level: Spotify crawls the web constantly looking for blog posts and other written texts about music, and figures out what people are saying about specific artists and songs — what adjectives and language is frequently used about those songs, and which *other* artists and songs are also discussed alongside them.

While I don’t know the specifics of how Spotify chooses to then process their scraped data, I can give you an understanding of how the Echo Nest used to work with them. They would bucket them up into what they call “cultural vectors” or “top terms.” Each artist and song had thousands of daily-changing top terms. Each term had a weight associated, which reveals how important the description is (roughly, the probability that someone will describe music as that term.)

![](https://cdn-images-1.medium.com/max/800/1*srOKaVeDN8i5uqEQepjPPw.png)

“Cultural vectors”, or “top terms”, as used by the Echo Nest. Table from Brian Whitman

Then, much like in collaborative filtering, the NLP model uses these terms and weights to create a vector representation of the song that can be used to determine if two pieces of music are similar. Cool, right?

* * *

## Recommendation Model #3: Raw Audio Models

![](https://cdn-images-1.medium.com/max/800/1*F0YJ1c2tBbCIjP13llMqTg.png)

First, a question. You might be thinking:

> *But, Sophia, we already have so much data from the first two models! Why do we need to analyze the audio itself, too?*

Well, first of all, including a third model further improves the accuracy of this amazing recommendation service. But actually, this model serves a secondary purpose, too: Unlike the first two model types, **raw audio models take into account *new* songs.**

Take, for example, the song your singer-songwriter friend put up on Spotify. Maybe it only has 50 listens, so there are few other listeners to collaboratively filter it against. It also isn’t mentioned anywhere on the internet yet, so NLP models won’t pick up on it. Luckily, raw audio models don’t discriminate between new tracks and popular tracks, so with their help, your friend’s song can end up in a Discover Weekly playlist alongside popular songs!

Ok, so now for the “how” — How can we analyze *raw audio data*, which seems so abstract?

…with **convolutional neural networks**!

Convolutional neural networks are the same technology behind facial recognition. In Spotify’s case, they’ve been modified for use on audio data instead of pixels. Here’s an example of a neural network architecture:

![Image credit: Sander Dieleman](https://cdn-images-1.medium.com/max/800/0*KS_nvbVyvOdQzjyI.)

This particular neural network has four _convolutional layers_, seen as the thick bars on the left, and three dense layers, seen as the more narrow bars on the right. The input are time-frequency representations of audio frames, which are then concatenated to form the spectrogram.

The audio frames go through these convolutional layers, and after the last convolutional layer, you can see a “global temporal pooling” layer, which pools across the entire time axis, effectively computing statistics of the learned features across the time of the song.

After processing, the neural network spits out an understanding of the song, including characteristics like estimated **time signature, key, mode, tempo,** and **loudness.** Below is a plot of this data for a 30-second excerpt of “Around the World” by Daft Punk.

![](https://cdn-images-1.medium.com/max/800/1*_EU2Q9hPaxtKyzt_KS85FA.png)

Image Credit: [Tristan Jehan & David DesRoches (The Echo Nest)](http://docs.echonest.com.s3-website-us-east-1.amazonaws.com/_static/AnalyzeDocumentation.pdf)

Ultimately, this understanding of the song’s key characteristics allows Spotify to understand fundamental similarities between songs and therefore which users might enjoy them based on their own listening history.

* * *

That covers the basics of the three major types of recommendation models feeding the Recommendations pipeline, and ultimately powering the Discover Weekly playlist!

![](https://cdn-images-1.medium.com/max/800/1*kJTtf1i3W2VrWG782_gCFw.png)

Of course, these recommendation models are all connected to Spotify’s much larger ecosystem, which includes giant amounts of data storage and uses _lots_ of Hadoop clusters to scale recommendations and make these engines work on giant matrices, endless internet music articles, and huge numbers of audio files.

I hope this was informative and tickled your curiosity like it did mine. For now, I’ll be working my way through my own Discover Weekly, finding my new favorite music, knowing and appreciating all the machine learning that’s going on behind the scenes. 🎶

---

*If you enjoyed this piece, I’d love it if you hit the clap button* 👏 *so others might stumble upon it. You can find my own code on* [*GitHub*](https://github.com/sophiaciocca)*, and more of my writing and projects at* [*http://www.sophiaciocca.com*](http://www.sophiaciocca.com)*.*

**Sources:
- [From Idea to Execution: Spotify’s Discover Weekly](https://www.slideshare.net/MrChrisJohnson/from-idea-to-execution-spotifys-discover-weekly/31-1_0_0_0_1) (Chris Johnson, ex-Spotify)
- [Collaborative Filtering at Spotify](https://www.slideshare.net/erikbern/collaborative-filtering-at-spotify-16182818/10-Supervised_collaborative_filtering_is_pretty) (Erik Bernhardsson, ex-Spotify)
- [Recommending music on Spotify with deep learning](http://benanne.github.io/2014/08/05/spotify-cnns.html) (Sander Dieleman)
- [ How music recommendation works — and doesn’t work](https://notes.variogr.am/2012/12/11/how-music-recommendation-works-and-doesnt-work/) (Brian Whitman, co-founder of The Echo Nest)
- [Ever Wonder How Spotify Discover Weekly Works? Data Science](http://blog.galvanize.com/spotify-discover-weekly-data-science/) (Galvanize)
- [The magic that makes Spotify’s Discover Weekly playlists so damn good](https://qz.com/571007/the-magic-that-makes-spotifys-discover-weekly-playlists-so-damn-good/) (Quartz)
- [The Echo Nest’s Analyzer Documentation](http://docs.echonest.com.s3-website-us-east-1.amazonaws.com/_static/AnalyzeDocumentation.pdf)

*Thanks also to* [*ladycollective*](https://medium.com/@ladycollective) *for reading this article over and suggesting edits.*

*Also, if you work at Spotify or know someone who does, I’d love to connect! I’m putting my dream to work at Spotify out into the world* 😊


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
