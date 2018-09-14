> - 原文地址：[JavaScript’s Filter Function Explained By Applying To College](https://codeburst.io/javascripts-filter-function-explained-by-applying-to-college-a21bceeba041)
> - 原文作者：[Kevin Kononenko](https://codeburst.io/@kevink?source=post_header_lockup)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascripts-filter-function-explained-by-applying-to-college.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascripts-filter-function-explained-by-applying-to-college.md)
> - 译者： [Calpa](https://calpa.me)
> - 校对者：

# 以申请大学流程来解释 JavaScript 的 filter 方法

## 如果你熟悉申请大学流程的话，你也可以理解 JavaScript 的 filter 方法。

![](https://cdn-images-1.medium.com/max/800/1*c4dbmD3a3hDCxLXte3taTw.jpeg)

相对于 JavaScript 里面的 map() 和 reduce() 方法来说，filter() 方法也许是最一目了然的方法。

_你输入一个数组，以特定方法过滤它们，並返回一个新的数组_

这个看起来很简单，不过我总是想把它换成 for() 循环。因此，我选择一种更加好的方法去理解 filter() 是如何运行的。

我发现， filter 方法就类似大学入学审批官。它们用一堆的参数来决定哪些学生可以进入他们特定的学院。是的，我们希望学院都可以更加灵活，全面地考察我们过去的成就，不过在实际情况中，很多硬性数字指标例如 SAT，ACT，GPA 绩点才是考量的决定因素。

就让我们一起探讨这个流程吧。

![](https://cdn-images-1.medium.com/max/800/0*PWtOoSbsLMCAcXmC.png)

### 使用 For 循环而不是 Filter 函数

好的，我们假设这里有四个同学，并列出他们的名字和 GPA。有一个学院只想要拥有 3.2 GPA 以上的学生进入学院。下面是你可能的做法。

```
let students = [
  {
    name: "david",
    GPA: 3.3
  },
  {
    name: "sheila",
    GPA: 3.1
  },
  {
    name: "Alonzo",
    GPA: 3.65
  },
  {
    name: "Mary",
    GPA: 3.8
  }
]

let admitted =[];

for (let i=0; i < students.length; i++){
  if(students[i].gpa > 3.2)
    admitted.push(students[i]);
}

/*admitted = [
  {
    name: "david",
    GPA: 3.3
  },
  {
    name: "Alonzo",
    GPA: 3.65
  },
  {
    name: "Mary",
    GPA: 3.8
  }
];*/
```

哇！这个是一个过于复杂的例子。如果有人阅读你的代码，他们可能需要追踪多个数组，才意识到你的一个简单过滤数组方法。同时，你需要仔细地追踪 _i_ 来避免发生错误。就让我们学习如何利用 filter 方法来达到相同效果吧。

### 使用 Filter() 方法

就让我们使用 filter() 方法来达到相同效果吧。

1. Filter 是一个数组方法，所以我们会从学生数组开始。
2. 对于每一个数组里面的元素，它会调用一个回调 (callback) 方法
3. 它用 return 来声明哪些元素会出现在最终的数组里面，也就是被录取的学生。

```
let students = [
  {
    name: "david",
    GPA: 3.3
  },
  {
    name: "sheila",
    GPA: 3.1
  },
  {
    name: "Alonzo",
    GPA: 3.65
  },
  {
    name: "Mary",
    GPA: 3.8
  }
]

let admitted = students.filter(function(student){
   return student.gpa > 3.2;
})

/*admitted = [
  {
    name: "david",
    GPA: 3.3
  },
  {
    name: "Alonzo",
    GPA: 3.65
  },
  {
    name: "Mary",
    GPA: 3.8
  }
];*/
```

输入和输出都是一样的，这里是我们做法不一样的地方：

1. 我们不需要定义一个 admitted 数组，然后填充它。我们可以在同一个代码块里面同时定义，並填充它的元素。
2. 我们实际上是在 return 语句中使用了一个条件判断式！这代表我们只需要返回那些符合条件的元素。
3. 我们现在可以用 _student_ 而不是在 _for_ 循环里面的 student[i] 来循环每个数组里面的元素，

![](https://cdn-images-1.medium.com/max/800/0*0TEOSb8MRGdi_lDb)

![](https://cdn-images-1.medium.com/max/800/0*oV583nYxvCID3r_G)

你可能注意到一件事，與直觉相反 - 我们只会在最后一步获得录取资格，不过在我们的代码里面，变量 _admitted_ 是首先出现在 statement 里面！你可能会预期在这个函数的最后去寻找最终的数组。取而代之，我们用返回来表示哪个元素会结束在 _admitted_。

![](https://cdn-images-1.medium.com/max/800/0*VvRQ32vesw8bJsn3)

### 例子 2 - 在 Filter 里面用两个条件判断式

直至现在，在我们的 filter 方法内，我们只用了一个条件判断式。不过这并不代表全部的大学入学流程！通常，入学审查官会观察超过 10 个因素。

让我们看一下这两个因素 - GPA 和 SAT 分数。学生必须拥有 GPA 绩点超过 3.2 及 SAT 分数超过 1900。下面是函数应该出现的样子。

```
let students = [
  {
    name: "david",
    GPA: 3.3,
    SAT: 2000
  },
  {
    name: "sheila",
    GPA: 3.1,
    SAT: 1600
  },
  {
    name: "Alonzo",
    GPA: 3.65,
    SAT: 1700
  },
  {
    name: "Mary",
    GPA: 3.8,
    SAT: 2100
  }
]

let admitted = students.filter(function(student){
   return student.gpa > 3.2 && student.SAT > 1900;
})

/*admitted = [
  {
    name: "david",
    GPA: 3.3,
    SAT: 2000
  },
  {
    name: "Mary",
    GPA: 3.8,
    SAT: 2100
  }
];*/
```

看起来很像，对吧？现在我们有两个条件判断式在 _return_ statement 里面。让我们把这段代码再拆分一下。

```
let admitted = students.filter(function(student){
   let goodStudent = student.gpa > 3.2 && student.SAT > 1900
   return goodStudent;
})
```

啊！所以与 _for_ 循环相比的话，这里就是另外一个重要的差异处。如果你观察一下 goodStudent 变量的话，就会发现它只会得出 true 或者是 false 值，然后，这个布尔值被赋值给返回语句。

所以， _true_ 或者 false 真的决定了，原始数组里面每个的元素是包含还是排除，然后放到结果的数组， _admitted_。

![](https://cdn-images-1.medium.com/max/800/0*OVFaI775MKnz6jrQ)

![](https://cdn-images-1.medium.com/max/800/0*9_aVs54EmW0P5UnJ)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 ** 本文永久链接 ** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner# 前端)、[后端](https://github.com/xitu/gold-miner# 后端)、[区块链](https://github.com/xitu/gold-miner# 区块链)、[产品](https://github.com/xitu/gold-miner# 产品)、[设计](https://github.com/xitu/gold-miner# 设计)、[人工智能](https://github.com/xitu/gold-miner# 人工智能) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
