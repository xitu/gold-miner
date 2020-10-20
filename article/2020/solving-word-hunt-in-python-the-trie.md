> * 原文地址：[Solving Word Hunt in Python: The Trie](https://codeburst.io/solving-word-hunt-in-python-the-trie-9acedc1f2637)
> * 原文作者：[Citizen Upgrade](https://medium.com/@citizenupgrade)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/solving-word-hunt-in-python-the-trie.md](https://github.com/xitu/gold-miner/blob/master/article/2020/solving-word-hunt-in-python-the-trie.md)
> * 译者：
> * 校对者：

# Solving Word Hunt in Python: The Trie

![Photo by [John Jennings](https://unsplash.com/@john_jennings?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/photos/B6yDtYs2IgY?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/2800/0*_x8QAcEWRmerd9-_)

Word Hunt is a popular game in which you’re given a list of letters and told to find as many words as possible from those letters. In variations of the game, you can reuse the letters as many times as possible (this game is known as Word Hunt) or use them only once (in a game called Word Scrambles). You get more points for longer words and maximum points for using all the letters.

This kind of game is **great** for computers to solve, and can highlight a pretty useful data structure known as the “Trie”.

## Solution Strategy

Let’s say we have the word “**MAINE**”.

The first thing to do is decide how we’ll tackle the problem. If the problem were a Scramble then we could try making all possible combinations of letters and seeing if those were words. That could be a decent solution for a Scramble, but it doesn’t help us for a Word Hunt because letters can be reused. So while you might find the word “name”, you would never find the word “nine”. We obviously can’t try every possible combination of letters because we don’t know how many times a letter might repeat. Because of this, we’re reduced to searching a dictionary to see if the word uses only the letters we have in our input. With a big dictionary, that could take a very long time and it would have to be repeated every time you changed the word!

Instead, we need a way to search a dictionary very quickly to tell us if a word is there. This is where a predictive text structure, the Trie, comes in.

## What is a Trie?

A Trie is a tree data structure where — instead of the node storing a value associated with the key — the node is associated with the key itself. Values in the node could be used to assign rankings to certain leaves or probabilities based on numbers of traversals.

![**Example Trie from the Wikipedia article: [https://en.wikipedia.org/wiki/Trie](https://en.wikipedia.org/wiki/Trie)**](https://cdn-images-1.medium.com/max/2000/0*x-cKHQ4czDsgHsxP)

The above example of a Trie was generated with the keys “A”, “to”, “tea”, “ted”, “ten”, “i”, “in”, and “inn”. Once a Trie structure like this is generated, it is an O(n) operation to see if any word is in the Trie. If I’m searching for “ted”, I find “t” in O(1), then “e” from the “t” node in O(1), and then “d” from the “te” node in O(1).

This makes for a **very** fast solution to the question “is this jumble of letters in the dictionary?” All we have to do first is first build the dictionary.

In Python, that step is easy. What this looks like is a dictionary at each node. So we need to start with an empty dictionary, then for every word in the dictionary, go letter by letter and check that the next letter is in our Trie structure and — if not — add it in! Now, this sounds pretty time intensive, and it is in some ways, but it only has to be done once. After the Trie is built, you can continue to use it without any extra overhead.

## Building the Trie

We need to start with a list of all possible words (there are many to be found online), and then our dictionary loading function might start something like this:

```Python
def load():
    with open('words.txt') as wordFile:
        wordList = wordFile.read().split()
 
    trie = {}
    for word in wordList:
        addWordToTrie(trie, word)
   
    return trie
```

We need a function that will add a word to the Trie. We need to run through the Trie and check at every letter whether we need to add our new key or not. Because we’re indexing through the Python dictionary **by** keys though, we don’t even need to store a value at each node. It’s a new dictionary that can have its own keys.

```Python
def addWordToTrie(trie, word, idx = 0):
    if idx >= len(word):
        return       
    if word[idx] not in d:
        d[word[idx]] = {}
    addWordToTrie(d[word[idx]], word, idx+1)
```

Here’s a quick idea. We take in the current Trie we’re pointed at (note that **any** node in the Trie is itself a Trie in this case), the word, and the index of the letter of the word we’re looking at.

If the index is more than the length of the word, we’re done! If not, we need to check whether the letter is already in this Trie. If the letter isn’t in this Trie’s lowest layer then we add a new dictionary at this level using that letter as the key. Then, we pass the dictionary (Trie) of our letter, the word, and the next index recursively back into this function.

Using these two functions, we’d build the Trie shown above. But we have a problem. How do we know when we’ve found a **word** rather than the first **part** of a real word? For example, in the Trie example above, we want “in” to return true as “inn” would, but we don’t want “te” to return that it’s a word in the dictionary.

To do this, we **do** need to store a value at our nodes when we have a complete word. Let’s revisit our addWordToTrie function and set the key “leaf” to “True” if this node represents a complete word.

```Python
def addWordToTrie(d, word, idx):
    if idx >= len(word):
        d['leaf']=True
        return
    if word[idx] not in d:
        d[word[idx]] = {'leaf':False}
    addWordToTrie(d[word[idx]], word, idx+1)
```

Now, any time we finish a word, we either set the current dictionary node’s “leaf” value to True, or we add a new node with a “leaf” value of “False”.

We should also initialize “trie” in our loading function with the same {‘leaf’:False} so we don’t later return an empty string as a valid word.

That’s it! We’ve built our Trie structure and it’s time to use it.

## Testing Words

Here’s a method to try: start with an empty list. For every letter in our word, we’ll check our Trie and see if it’s in the Trie. If so, get the sub-trie and start over (so we can check duplicate letters). Keep walking until we either find a leaf or we don’t find any letters in the word that are in the next sub-trie. If we found a leaf, add that word to the list. If there aren’t any more sub-tries, we break and go on to the next letter.

```Python
def findWords(trie, word, currentWord):
    myWords = [];
    for letter in word:
        if letter in trie:
            newWord = currentWord + letter
            if (trie[letter]['leaf']):
                myWords.append(newWord)
            myWords.extend(findWords(trie[letter], word, newWord))
    return myWords
```

Note here that we’re building up a current word to pass to our list, but we’re also using recursion and extending our list with whatever we find in subsequent calls with those new words.

Some of you may have already spotted the problem with this. What if we have repeated letters? For example, if our word is “**TEEN**” and we were at the node “TE”, we’d check for “t” in our sub-trie, which is fine, then we’d check for “e” in our sub-trie and find “tee” is a word. We’d add “tee” to our list. But the next letter in the word is “e” again, so we’d once again find “tee”. There are a couple of ways to solve this but one of the easier ways is to use a set instead of a list.

```Python
def findWords(trie, word, currentWord):
    myWords = set()      
    for letter in word:
        if letter in trie:
            newWord = currentWord + letter
            if trie[letter]['leaf']:
                myWords.add(newWord)
            myWords = myWords.union(findWords(trie[letter], word, newWord))
    return myWords

```

Now we’ll guarantee uniqueness in our list no matter how many times we find the same word. We could also make sure to eliminate duplicate letters in our incoming word and potentially save some processing time.

So that’s it! Those three functions find us all the words in the dictionary that can be made from the letters we pass in. Let’s wrap all that up in the main function that takes some input and we’re done.

```Python
def main():
    print('Loading dictionary...')
    wordTrie = load()
    print('Done\n')
 
    word = raw_input("What letters should we use: ")
    minLength = int(raw_input("What is the minimum word length: "))
    print("")
 
    count = 0;
    for word in sorted(findWords(wordTrie, word, "")):
        if len(word) >= minLength:
            count = count+1
            print(word)
    print(str(count) + " words found.")
```

Since this isn’t a word scramble, we find a **lot** more words. Using our example of “**MAINE**” from above and a dictionary I found that — with about 370,000 words — the program finds 208 words. That’s why I added a minimum word length input as well. Limiting to words with seven letters or more, we get this:

```
Loading dictionary…

Done

What letters should we use: maine

What is the minimum word length: 7

amninia

anaemia

anamnia

animine

emmenia

enamine

manienie

mannaia

meminna

miminae

minaean

11 words found.
```

Loading the dictionary takes about half a second, and finding the words after that takes no noticeable time at all.

It’s inefficient to recreate this Trie each time for a single word, so it would be better to re-use it, either by saving the structure or by looping to try multiple word hunts at the same time.

## Conclusion

Hopefully, this article provided you with a basic introduction to using a Trie to solve word problems. Tries are a great structure to use when you need any kind of autocomplete. Text messaging, searches, even directions, can use a Trie built from data in the system to help predict what a user wants to input next. As we’ve seen here, they’re also a great structure to use to search a large number of existing paths; in this case, the path being valid words.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
