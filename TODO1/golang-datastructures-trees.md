> * 原文地址：[Golang Datastructures: Trees](https://ieftimov.com/golang-datastructures-trees)
> * 原文作者：[Ilija Eftimov](https://ieftimov.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/golang-datastructures-trees.md](https://github.com/xitu/gold-miner/blob/master/TODO1/golang-datastructures-trees.md)
> * 译者：[steinliber](https://github.com/steinliber)
> * 校对者：[Endone](https://github.com/Endone)，[LeoooY](https://github.com/LeoooY)

# Golang 数据结构：树

在你编程生涯的大部分时间中你都不用接触到树这个数据结构，或者即使并不理解这个结构，你也可以轻易地避开使用它们（这就是我过去一直在做的事）。

现在，不要误会我的意思 —— 数组，列表，栈和队列都是非常强大的数据结构，可以帮你在带你在编程之路上走的很远，但是它们无法解决所有的问题，且不论如何去使用它们以及效率如何。当你把哈希表放入这个组合中时，你就可以解决相当多的问题，但是对于许多问题而言，如果你能掌握了树结构，那它将是一个强大的（或许也是唯一的）工具。

那么让我们来看看树结构，然后我们可以通过一个小练习来学习如何使用它们。

## 一点理论

数组，列表，队列，栈把数据储存在有头和尾的集合中，因此它们被称作“线性结构”。但是当涉及到树和图这种数据结构时，这就会变得让人困惑，因为数据并不是以线性方式储存到结构中的。

树被称作非线性结构。实际上，你也可以说树是一种层级数据结构因为它的数据是以分层的方式储存的。

为了你阅读的乐趣，下面是维基百科对树结构的定义：

> 树是由节点（或顶点）和边组成不包含任何环的数据结构。没有节点的树被称为空树。一颗非空的树是由一个根节点和可能由多个层级的附加节点形成的层级结构组成。

这个定义所要表示的意思就是树只是节点（或者顶点）和边（或者节点之间的连接）的集合，它不包含任何循环。

![](https://ieftimov.com/img/posts/golang-datastructures-trees/invalid-tree.png)

比如说，图中表示的数据结构就是节点的组合，依次从 A 到 F 命名，有六条边。虽然它的所有元素都使它们看起来像是构造了一棵树，但节点 A，D，F 都有一个循环，因此这个数据结构并不是树。

如果我们打断节点 F 和 E 之间的边并且增加一个节点 G，把 G 和 F 用边连起来，我们会得到像下图这样的结构：

![](https://ieftimov.com/img/posts/golang-datastructures-trees/valid-tree.png)

现在，因为我们消除了在图中的循环，可以说我们现在有了一个有效的树结构。它有一个称作 A 的**根部节点**，一共有 7 个**节点**。节点 A 有 3 个**子节点**（B，D 和 F）以及这些节点下一层的节点（分别为 C，E 和 G）。因此，节点 A 有 6 个**子孙节点**。此外，这个树有 3 个叶节点（C，E 和 G）或者把它们叫做没有子节点的节点。

B，D 和 F 节点有什么共同之处？因为它们有同一个父节点（节点 A）所以它们是**兄弟节点**。它们都位于第一层因为其中的每一个要到达根节点都只需要一步。例如，节点 G 位于第二层，因为从 G 到 A 的**路径**为：G -> F -> A，我们需要走两条边来才能到达节点 A。

现在我们已经了解了树的一点理论，让我们来看看如何用树来解决一些问题。

## 为 HTML 文档建模

如果你是一个从没写过任何 HTML 的软件开发者， 我会假设你已经看到过（或者知道）HTML 是什么样子的。如果你还是不知道，那么我建议你右键单击当前正在阅读的页面，然后单击“查看源代码”就可以看到。

说真的，去看看吧，我会在这等着的。。。

浏览器有个内置的东西，叫做 DOM —— 一个跨平台且语言独立的应用程序编程接口，它会将这些 网络文档视为一个树结构，其中的每个节点都是表示文档其中一部分的对象。这意味着当浏览器读取你文档中的 HTML 代码时它将会加载这个文档并基于此创建一个 DOM。

所以，让我们短暂的设想一下，我们是 Chrome 或者 Firefox 浏览器的开发者，我们需要来为 DOM 建模。好吧，为了让这个练习更简单点，让我们来看一个小的 HTML 文档：

```
<html>
  <h1>Hello, World!</h1>
  <p>This is a simple HTML document.</p>
</html>
```

所以，如果我们把这个文档建模成一个树结构，它看起将会是这样：

![](https://ieftimov.com/img/posts/golang-datastructures-trees/html-document-tree.png)

现在，我们可以把文本节点视为单独的`Node`，但是简单起见，我们可以假设任何 HTML 元素都可以包含文本。

`html`节点将会有两个子节点，`h1` 和 `p` 节点，这些节点包含字段 `tag`，`text` 和 `children` 。让我们把这些放到代码里：

```
type Node struct {
    tag      string
    text     string
    children []*Node
}
```

一个 `Node` 将只有标签名和子节点可选。让我们通过上面看到的 `Node` 树来亲手尝试创建这个 HTML 文档：

```
func main() {
        p := Node{
                tag:  "p",
                text: "This is a simple HTML document.",
                id:   "foo",
        }

        h1 := Node{
                tag:  "h1",
                text: "Hello, World!",
        }

        html := Node{
                tag:      "html",
                children: []*Node{&p, &h1},
        }
}
```

这看起来还可以，我们建立了一个基础的树结构并且运行了。

## 构建 MyDOM - DOM 的直接替代😂

现在我们已经有了一些树结构，让我们退一步来看看 DOM 有哪些功能。比如说，如果在真实环境中用 MyDOM（TM）替代 DOM，那么我们应该可以使用 JavaScript 访问其中的节点并修改它们。

使用 JavaScript 执行这个操作的最简单方法是使用如下代码

```
document.getElementById('foo')
```

这个函数将会在 `document` 树中查找以 `foo` 作为 ID 的节点。让我们更新我们的 `Node` 结构来获得更多的功能，然后为我们的树结构编写一个查询函数：

```
type Node struct {
  tag      string
  id       string
  class    string
  children []*Node
}
```

现在，我们的每个 `Node` 结构将会有 `tag`，`children`，它是指向该 `Node` 子节点的指针切片，`id` 表示在该 DOM 节点中的 ID，`class` 指的是可应用于该 DOM 节点的类。

现在回到我们之前的 `getElementById` 查询函数。来如何去实现它。首先，让我们构造一个可用于测试我们查询算法的树结构：

```
<html>
  <body>
    <h1>This is a H1</h1>
    <p>
      And this is some text in a paragraph. And next to it there's an image.
      <img src="http://example.com/logo.svg" alt="Example's Logo"/>
    </p>
    <div class='footer'>
      This is the footer of the page.
      <span id='copyright'>2019 &copy; Ilija Eftimov</span>
    </div>
  </body>
</html>
```

这是一个非常复杂的 HTML 文档。让我们使用 `Node` 作为 Go 语言中的结构来表示其结构：

```
image := Node{
        tag: "img",
        src: "http://example.com/logo.svg",
        alt: "Example's Logo",
}

p := Node{
        tag:      "p",
        text:     "And this is some text in a paragraph. And next to it there's an image.",
        children: []*Node{&image},
}

span := Node{
        tag:  "span",
        id:   "copyright",
        text: "2019 &copy; Ilija Eftimov",
}

div := Node{
        tag:      "div",
        class:    "footer",
        text:     "This is the footer of the page.",
        children: []*Node{&span},
}

h1 := Node{
        tag:  "h1",
        text: "This is a H1",
}

body := Node{
        tag:      "body",
        children: []*Node{&h1, &p, &div},
}

html := Node{
        tag:      "html",
        children: []*Node{&body},
}
```

我们开始自下而上构建这个树结构。这意味着从嵌套最深的结构起来构建这个结构，一直到 `body` 和 `html` 节点。让我们来看一下这个树结构的图形：

![](https://ieftimov.com/img/posts/golang-datastructures-trees/mydom-tree.png)

## 实现节点查询🔎

让我们来继续实现我们的目标 —— 让 JavaScript 可以在我们的 `document` 中调用 `getElementById` 并找到它想找到的 `Node`。

为此，我们需要实现一个树查询算法。搜索（或者遍历）图结构和树结构最流行的方法是广度优先搜索（BFS）和深度优先搜索（DFS）。

### 广度优先搜素⬅➡

顾名思义，BFS 采用的遍历方式会首先考虑探索节点的“宽度”再考虑“深度”。下面是 BFS 算法遍历整个树结构的可视化图：

![](https://ieftimov.com/img/posts/golang-datastructures-trees/mydom-tree-bfs-steps.png)

正如你所看到的，这个算法会先在深度上走两步（通过 `html` 和 `body` 节点），然后它会遍历 `body` 的所有子节点，最后深入到下一层从而访问到 `span` 和 `img` 节点。

如果你想要一步一步的说明，它将会是：

1.  我们从根部 `html` 节点开始
2.  我们把它推到 `queue`
3.  我们开始进入一个循环，如果 `queue` 不为空，这个循环会一直运行
4. 我们检查 `queue` 中的下一个元素是否与查询的匹配。如果匹配上了，我们就返回这个节点然后整个就结束了
5. 当找不到匹配项时，我们把被检查节点的子节点都放入队列中，这样就可以在之后检查它们了
6. `GOTO` 第四步

让我们看看在 Go 里面这个算法的简单实现，我将会分享一些如何可以轻松记住算法的建议。

```
func findById(root *Node, id string) *Node {
        queue := make([]*Node, 0)
        queue = append(queue, root)
        for len(queue) > 0 {
                nextUp := queue[0]
                queue = queue[1:]
                if nextUp.id == id {
                        return nextUp
                }
                if len(nextUp.children) > 0 {
                        for _, child := range nextUp.children {
                                queue = append(queue, child)
                        }
                }
        }
        return nil
}
```

这个算法有 3 个关键点：

1. `queue` —— 它将包含算法访问的所有节点
2. 获取 `queue` 中的第一个元素，检查它是否匹配，如果该节点未匹配，则继续下一个节点
3. 在查看 `queue` 的下一个元素之前把节点的所有子节点都**入队列**。

从本质上讲，整个算法围绕着在队列中推入子节点和检测已经在队列中的节点实现。当然，如果在队列的末尾还是找不到匹配项的话我们就返回 `nil` 而不是指向 `Node` 的指针。

### 深度优先搜索 ⬇

为了完整起见，让我们来看看 DFS 是如何工作的。

如前所述，深度优先搜索首先会在深度上访问尽可能多的节点，直到到达树结构中的一个叶节点。当这种情况发生时，它就会回溯到上面的节点并在树结构中找到另一个分支再继续向下访问。

让我们看下这看起来意味着什么：

![](https://ieftimov.com/img/posts/golang-datastructures-trees/mydom-tree-dfs-steps.png)

如果这让你觉得困惑，请不要担心——我在讲述步骤中增加了更多的细节支持我的解释。

这个算法开始就像 BFS 一样 —— 它从 `html` 到 `body` 再到 `div` 节点。然后，与之不同的是，该算法并没有继续遍历到 `h1` 节点，它往叶节点 `span` 前进了一步。一旦它发现 `span` 是个叶节点，它就会返回 `div` 节点以查找其它分支去探索。因为在 `div` 也找不到，所以它会移回 `body` 节点，在这个节点它找到了一个新分支，它就会去访问该分支中的 `h1` 节点。然后，它会继续之前同样的步骤 —— 返回 `body` 节点然后发现还有另一个分支要去探索 —— 最后会访问到 `p` 和 `img` 节点。

如果你想要知道“我们如何在没有指向父节点指针情况下返回到父节点的话”，那么你已经忘了在书中最古老的技巧之一 —— 递归。让我们来看下这个算法在 Go 中的简单递归实现：

```
func findByIdDFS(node *Node, id string) *Node {
        if node.id == id {
                return node
        }

        if len(node.children) > 0 {
                for _, child := range node.children {
                        findByIdDFS(child, id)
                }
        }
        return nil
}
```

## 通过类名搜索🔎

MyDOM（TM）应该具有的另一个功能是通过类名来查找节点。基本上，当 JavaScript 脚本执行 `getElementsByClassName` 时，MyDOM 应该知道如何收集具有某个特定类名的所有节点。

可以想像，这也是一种必须探寻整个 MyDOM（TM）结构树从中获取符合特定条件的节点的算法。

简单起见，我们先来实现一个 `Node` 结构的方法，叫做 `hasClass`：


```
func (n *Node) hasClass(className string) bool {
        classes := strings.Fields(n.classes)
        for _, class := range classes {
                if class == className {
                        return true
                }
        }
        return false
}
```

`hasClass` 获取 `Node` 结构的 classes 字段，通过空格字符来分割它们，然后再循环这个 classes 的切片并尝试查找到我们想要的类名。让我们来写几个测试用例来验证这个函数：


```
type testcase struct {
        className      string
        node           Node
        expectedResult bool
}

func TestHasClass(t *testing.T) {
        cases := []testcase{
                testcase{
                        className:      "foo",
                        node:           Node{classes: "foo bar"},
                        expectedResult: true,
                },
                testcase{
                        className:      "foo",
                        node:           Node{classes: "bar baz qux"},
                        expectedResult: false,
                },
                testcase{
                        className:      "bar",
                        node:           Node{classes: ""},
                        expectedResult: false,
                },
        }

        for _, case := range cases {
                result := case.node.hasClass(test.className)
                if result != case.expectedResult {
                        t.Error(
                                "For node", case.node,
                                "and class", case.className,
                                "expected", case.expectedResult,
                                "got", result,
                        )
                }
        }
}
```

如你所见，`hasClass` 函数会检测 `Node` 的类名是否在类名列表中。现在，让我们继续完成对 MyDOM 的实现，即通过类名来查找所有匹配的 `Node`。


```
func findAllByClassName(root *Node, className string) []*Node {
        result := make([]*Node, 0)
        queue := make([]*Node, 0)
        queue = append(queue, root)
        for len(queue) > 0 {
                nextUp := queue[0]
                queue = queue[1:]
                if nextUp.hasClass(className) {
                        result = append(result, nextUp)
                }
                if len(nextUp.children) > 0 {
                        for _, child := range nextUp.children {
                                queue = append(queue, child)
                        }
                }
        }
        return result
}
```

这个算法是不是看起来很熟悉？那是因为你正在看的是一个修改过的 `findById` 函数。`findAllByClassName` 的运作方式和 `findById` 类似，但是它不会在找到匹配项后就直接返回，而是将匹配到的 `Node` 加到 `result` 切片中。它将会继续执行循环操作，直到遍历了所有的 `Node`。

如果没有找到匹配项，那么 `result` 切片将会是空的。如果其中有任何匹配到的，它们都将作为 `result` 的一部分返回。

最后要注意的是在这里我们使用的是广度优先的方式来遍历树结构 —— 这种算法使用队列来储存每个 `Node` 结构，在这个队列中进行循环如果找到匹配项就把它们加入到 `result` 切片中。

## 删除节点 🗑

另一个在 Dom 中经常使用的功能就是删除节点。就像 DOM 可以做到这个一样，我们的MyDOM（TM）也应该可以进行这种操作。

在 Javascript 中执行这个操作的最简单方法是：


```
var el = document.getElementById('foo');
el.remove();
```

尽管我们的 `document` 知道如何去处理 `getElementById`（在后面通过调用 `findById`），但我们的 `Node` 并不知道如何去处理一个 `remove` 函数。从 MyDOM（TM）中删除 `Node` 将会需要两个步骤：

1.  我们找到 `Node` 的父节点然后把它从父节点的子节点集合中删去；
2.  如果要删除的 `Node` 有子节点，我们必须从 DOM 中删除这些子节点。这意味着我们必须删除所有指向这些子节点的指针和它们的父节点（也就是要被删除的节点），这样 Go 里的垃圾收集器才可以释放这些被占用的内存。

这是实现上述的一个简单方式：

```
func (node *Node) remove() {
        // Remove the node from it's parents children collection
        for idx, sibling := range n.parent.children {
                if sibling == node {
                        node.parent.children = append(
                                node.parent.children[:idx],
                                node.parent.children[idx+1:]...,
                        )
                }
        }

        // If the node has any children, set their parent to nil and set the node's children collection to nil
        if len(node.children) != 0 {
                for _, child := range node.children {
                        child.parent = nil
                }
                node.children = nil
        }
}
```


一个 `*Node` 将会拥有一个 `remove` 函数，它会执行上面所描述的两个步骤来实现 `Node` 的删除操作。

在第一步中，我们把这个节点从 `parent` 节点的子节点列表中取出来，通过遍历这些子节点，合并这个节点前面的元素和后面的元素组成一个新的列表来删除这个节点。

在第二步中，在检查这个节点是否存在子节点之后，我们将所有子节点中的 `parent` 引用删除，然后把这个 `Node` 的子节点字段设为 `nil`。

## 接下来呢？

显然，我们的 MyDOM（TM）实现永远不可能替代 DOM。但是，我相信这是一个有趣的例子可以帮助你学习，这也是一个很有趣的问题。我们每天都与浏览器交互，因此思考它们暗地里是如何工作的会是一个有趣的练习。

如果你想使用我们的树结构并为其写更多的功能，你可以访问 WC3 的 JavaScript HTML DOM [文档](https://www.w3schools.com/js/js_htmldom_document.asp)然后考虑为 MyDOM 增加更多的功能。

显然，本文的主旨是为了让你了解更多关于树（图）结构的信息，了解目前流行的搜索/遍历算法。但是，无论如何请保持探索和实践，如果对你的 MyDOM 实现有任何改进请在文章下面留个评论。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
