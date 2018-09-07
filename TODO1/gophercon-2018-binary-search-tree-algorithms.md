> * 原文地址：[GopherCon 2018 - Demystifying Binary Search Tree Algorithms](https://about.sourcegraph.com/go/gophercon-2018-binary-search-tree-algorithms/)
> * 原文作者：[Kaylyn Gibilterra](https://twitter.com/kgibilterra)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/gophercon-2018-binary-search-tree-algorithms.md](https://github.com/xitu/gold-miner/blob/master/TODO1/gophercon-2018-binary-search-tree-algorithms.md)
> * 译者：
> * 校对者：

# GopherCon 2018 - Demystifying Binary Search Tree Algorithms

By Geoffrey Gilmore for the GopherCon Liveblog on August 30, 2018

Presenter: [Kaylyn Gibilterra](https://twitter.com/kgibilterra)

Liveblogger: [Geoffrey Gilmore](https://github.com/ggilmore)

Learning algorithms can be overwhelming and demoralizing, but it doesn't have to be. In this talk, Kaylyn explains binary search tree algorithms in a simple and straightforward manner with code examples in Go.

* * *

## Introduction

Kaylyn started writing algorithms for fun over the last year. This might seem strange to you, but it's especially weird for her. She hated her algorithms class in college. Her professor would use complicated jargon and refuse to explain "obvious" concepts. As a result, she only picked up enough knowledge to be able to pass her job interviews and move on with the rest of her life.

Her attitude towards algorithms changed once she started to implement them in Go. Converting algorithms written C or Java into Go was surprisingly easy, and she understood them better afterward than she did back in college.

Kaylyn will explain why that is and show you how to do it with binary search trees, but before we do that: Why exactly is learning algorithms so awful?

## Learning algorithms is horrible

![](https://user-images.githubusercontent.com/9022011/44757761-fdfd3100-aaed-11e8-8efb-bcac3d9aebb4.png)

This screenshot is from the binary search tree section of Introduction to Algorithms (a.k.a. CLRS). CLRS is considered to be the "gospel" of algorithms books. To the authors' credit, there hadn't been a great algorithms textbook written before it came out in 1989. However, anyone reading CLRS can tell that it was written by professors whose primary audience was academically minded.

Some examples of this:

*   This page references lots of terms that the book defines elsewhere. So you need to know things like
    
    *   what satellite data is
    *   what a linked list is
    *   what "pre-order" and "post-order" tree traversal mean
    
    You won't know what those things are if you haven't taken notes on every single page in the book.
    
*   If you're anything like Kaylyn, the first thing that you scan the page for is for something that looks like code. However, the only code that's on the page explains one way to walk through a binary search tree - not what a binary search tree _actually_ is.
    
*   The entire bottom quarter of this page is a theorem and a proof. This is probably well-intentioned. Many textbook authors feel that it's essential to prove to you that their statements are true; otherwise, you won't be able to trust them. The irony here is that CLRS is supposed to be an introductory textbook. However, a beginner doesn't need to know all of the exact details of why the algorithm is correct - they'll take your word for it.
    
*   To their credit, they do have a two-sentence area (highlighted in green) explaining what a binary search tree algorithm is. But it's buried in a barely visible sentence that calls it a binary search tree "property", which is confusing terminology for a beginner.

Takeaways:

1.  Academic textbook authors aren't necessarily great teachers. The best teachers often don't write textbooks.
    
2.  But most people copy the teaching style/format that the standard textbooks use. Even online resources reference jargon that they think you should know before looking at a binary search tree. In reality, most of this "required knowledge" isn't necessary.

The rest of this talk will cover what a binary search tree is. You'll find it useful if you're new to Go or new to algorithms. If you're neither, it could still be an excellent refresher and something that you can pass on to other people who are curious about these things.

## Guess the Number Game

This is the only thing that you need to know to understand the rest of this talk.

![](https://user-images.githubusercontent.com/9022011/44758592-a01f1800-aaf2-11e8-9225-00c9d88ccaf9.png)

This is the "Guess the Number Game", a game that many of you played when you were kids. You'd ask your friends to guess a number within a specific range, like 1-100. Your friend would throw out a number like "57". Their first guess was generally wrong since the range is so broad, but you were allowed to tell them if their guess was higher or lower than the answer. They'd keep guessing new numbers, taking into account the hints that you'd give them, and eventually they'd guess the right answer.

![](https://user-images.githubusercontent.com/9022011/44758764-7b777000-aaf3-11e8-92d4-ebb4e92c2832.png)

This guessing game is pretty much exactly what goes on during binary search. If you understand this guessing game, you also understand the core principal behind binary search tree algorithms. The numbers that they guessed are the numbers in the tree, and the "higher"/"lower" hints tell you the direction that you need to move: either to the right or left child node.

## Rules of Binary Search Trees

1.  Each node contains one unique key. You use this to make comparisons between nodes. A key can be any comparable type: a string, integer, etc.
2.  Each node has 0, 1, or at most 2 “children” it points to.
3.  The keys to the right of any node are greater than that node
4.  The keys to the left of any node are less than that node
5.  You cannot have duplicate keys

Binary search trees have three major operations:

*   Search
*   Insert
*   Delete

Binary search trees make the above operations fast––that's why they are so popular.

## Search

![](https://cl.ly/dd19a7225c09/Screen%252520Recording%2525202018-08-29%252520at%25252009.03%252520PM.gif)

The above GIF is an example of searching for the number `39` in the tree.

![](https://cl.ly/908ecf0f3854/Image%2525202018-08-29%252520at%2525209.31.02%252520PM.png)

An important point to note is that every node to the right of the node that you are currently looking at is going to be _greater_ than the value of the current node. The nodes to the right of the green line are greater than `57`. All the nodes to the left are smaller than `57`.

![](https://cl.ly/61dfb3a92722/Image%2525202018-08-29%252520at%2525209.33.32%252520PM.png)

This property is true for every node in the tree, not just the root node. In the above picture, all the numbers to the right of the green line are greater than `32`, all the numbers to the left of the red line are smaller than `32`.

So, now that we know the fundamentals, let's start writing some code.

```
type Node struct {
    Key   int
    Left  *Node
    Right *Node
}
```

The fundamental structure that we are going to use is a `struct`. If you are new to `struct`s, they are essentially just a collection of fields. The three fields that you need are `Key` (used for comparisons with other nodes), and the `Left` and `Right` child nodes.

When you want to define a `Node`, you can do it using a struct literal:

```
tree := &Node{Key: 6}
```

This creates a `Node` with a `Key` value `6`. You might be wondering where the `Left` and `Right` fields are. Nothing is stopping you from providing all the fields:

```
tree := &Node{
    Key:   6,
    Left:  nil,
    Right: nil,
}
```

However, you are allowed to specify only a subset of the `struct`'s fields if you a provide field names (e.g., `Key` in this case).

You can also instantiate a `Node` without named fields:

```
tree := &Node{6, nil, nil}
```

In this case: the first argument is `Key`, the second argument is `Left`, and the third argument is `Right`.

After you instantiate your `Node`, you can access your struct's fields using dot notation like this:

```
tree := &Node{6, nil, nil}
fmt.Println(tree.Key)
```

So, let's write the algorithm for `Search`:

```
func (n *Node) Search(key int) bool {
    // This is our base case. If n == nil, `key`
    // doesn't exist in our binary search tree. 
    if n == nil {
        return false
    }

    if n.Key < key { // move right
        return n.Right.Search(key)
    } else if n.Key > key { // move left
        return n.Left.Search(key)
    }

    // n.Key == key, we found it!
    return true
}
```

## Insert

![](https://cl.ly/aaa1f718d537/Screen%252520Recording%2525202018-08-29%252520at%25252010.17%252520PM.gif)

The above GIF is an example of inserting `81` into the tree. Insert is very similar to search. We want to find where `81` should go inside the tree, so we walk the tree using the same rules that we used in `search`, and insert `81` once we find an empty spot.

```
func (n *Node) Insert(key int) {
    if n.Key < key {
        if n.Right == nil { // we found an empty spot, done!
            n.Right = &Node{Key: key}
        } else { // look right 
            n.Right.Insert(key)
        }
    } else if n.Key > key {
        if n.Left == nil { // we found an empty spot, done!
            n.Left = &Node{Key: key}
        } else { // look left
            n.Left.Insert(key)
        }
    }
   // n.Key == key, don't need to do anything
}
```

[If you haven't seen the `(n *Node)` syntax before, it's known as a pointer receiver.](https://tour.golang.org/methods/4)

## Delete

![](https://cl.ly/e261dd30e743/Screen%252520Recording%2525202018-08-29%252520at%25252010.33%252520PM.gif)

The above GIF is an example of deleting `78` from the tree. We search for `78` like we've done before, and in this case, we're able to just "snip" `78` from the tree by directly connecting `85` as the right child of `57`.

```
func (n *Node) Delete(key int) *Node {
    // search for `key`
    if n.Key < key {
        n.Right = n.Right.Delete(key)
    } else if n.Key > key {
        n.Left = n.Left.Delete(key)   
    // n.Key == `key`
    } else {
        if n.Left == nil { // just point to opposite node 
            return n.Right
        } else if n.Right == nil { // just point to opposite node 
            return n.Left
        }

        // if `n` has two children, you need to 
        // find the next highest number that 
        // should go in `n`'s position so that
        // the BST stays correct 
        min := n.Right.Min()
 
        // we only update `n`'s key with min
        // instead of replacing n with the min
        // node so n's immediate children aren't orphaned
        n.Key = min
        n.Right = n.Right.Delete(min)
    }
    return n
}
```

## Min value

![](https://cl.ly/9f703767f7c9/Image%2525202018-08-29%252520at%25252011.20.37%252520PM.png)

If you move to the left over and over, you get the smallest number (`24` in this case).

```
func (n *Node) Min() int {
    if n.Left == nil {
        return n.Key
    }
    return n.Left.Min()
}
```

## Max value

![](https://cl.ly/6e4021ed62d9/Image%2525202018-08-29%252520at%25252011.22.20%252520PM.png)

```
func (n *Node) Max() int {
    if n.Right == nil {
        return n.Key
    }
    return n.Right.Max()
}
```

If you move to the right over and over, you get the largest number (`96` in this case).

## Testing

Since we've written the code for each of the primary functions of binary search trees, let's actually test our code! Testing was the most fun part of the process for Kaylyn: testing in Go is _much_ more straightforward than a lot of other languages like Python and C.

```
// You only need to import one library!
import "testing"

// This is called a test table. It's a way to easily 
// specify tests while avoiding boilerplate. 
// See https://github.com/golang/go/wiki/TableDrivenTests
var tests = []struct {
    input  int
    output bool
}{
    {6, true},
    {16, false},
    {3, true},
}

func TestSearch(t *testing.T) {
    //     6
    //    /
    //   3
    tree := &Node{Key: 6, Left: &Node{Key: 3}}
    
    for i, test := range tests { 
        if res := tree.Search(test.input); res != test.output {
            t.Errorf("%d: got %v, expected %v", i, res, test.output)
        }
    }

}
```

All you have to do to run this is:

```
> go test
```

Go runs your tests and will print a nicely formatted result that tells you if your tests passed, error messages from your test failures, and how long your tests took.

## Benchmarking

But wait––there's more! Go also makes it easy to do some very simple benchmarking. This is all the code that you need:

```
import "testing"

func BenchmarkSearch(b *testing.B) {
    tree := &Node{Key: 6}

    for i := 0; i < b.N; i++ {
        tree.Search(6)
    }
}
```

`b.N` will run `tree.Search()` over and over again until it observes a stable execution time for `tree.Search()`.

You can run this test with just the following command:

```
> go test -bench=
```

and your output will look like this:

```
goos: darwin
goarch: amd64
pkg: github.com/kgibilterra/alGOrithms/bst
BenchmarkSearch-4       1000000000               2.84 ns/op
PASS
ok      github.com/kgibilterra/alGOrithms/bst   3.141s
```

The line that you want to pay attention to is this:

```
BenchmarkSearch-4       1000000000               2.84 ns/op
```

This line tells you the speed of the function you have. In this case `test.Search()` took ~2.84 nanoseconds to execute.

Since it's easy to run benchmarks, you can start running some experiments such as:

*   What happens if I use a much larger / deeper tree?
*   What happens if I change the key that I am searching for?

Kaylyn found it particularly helpful for things like understanding the performance characteristics between maps and slices. It's nice to get quick, tactile feedback about things that you read about online.

## Binary Search Tree Terminology

The last thing that we're going to take a look at is some binary search tree terminology. If you decide to learn more about binary search trees on your own, it'll be useful for you know to about these terms:

**Tree height**: Number of edges on the longest path from the root to the base. This determines the speed of your algorithm.

![](https://cl.ly/705355d982d4/Image%2525202018-08-30%252520at%25252012.05.11%252520AM.png)

This tree has a height of `5`.

**Node depth**: Number of edges from the root to that node

`48` is `2` edges away from the root.

![](https://cl.ly/a0058d294af0/Image%2525202018-08-30%252520at%25252012.08.04%252520AM.png)

**Full binary tree**: Each node has exactly 0 or 2 children

![](https://cl.ly/3bd94a056d8d/Image%2525202018-08-30%252520at%25252012.10.53%252520AM.png)

**Complete binary tree**: The tree is entirely filled, except for the bottom row, which can be filled from left to right

![](https://cl.ly/d78de1699704/Image%2525202018-08-30%252520at%25252012.12.03%252520AM.png)

**An unbalanced tree**

![](https://cl.ly/1669851131fe/Screen%252520Recording%2525202018-08-30%252520at%25252012.14%252520AM.gif)

Imagine that you're searching for `47` in this tree. Do you see how that takes `7` steps while searching for `24` only takes three? This problem becomes more exacerbated the more "unbalanced" the tree is. The way to fix it is to "balance" the tree:

**A balanced tree**:

![](https://cl.ly/8ba095d064c8/Image%2525202018-08-30%252520at%25252012.20.17%252520AM.png)

This tree contains the same nodes as the unbalanced tree, but searches on balanced trees are faster (on average) than on unbalanced trees.

## Contact Information

Twitter: [@kgibilterra](https://twitter.com/kgibilterra)
Email: [kgibilterra@gmail.com](mailto:kgibilterra@gmail.com)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
