> * 原文地址：[JavaScript’s Filter Function Explained By Applying To College](https://codeburst.io/javascripts-filter-function-explained-by-applying-to-college-a21bceeba041)
> * 原文作者：[Kevin Kononenko](https://codeburst.io/@kevink?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascripts-filter-function-explained-by-applying-to-college.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascripts-filter-function-explained-by-applying-to-college.md)
> * 译者：
> * 校对者：

# JavaScript’s Filter Function Explained By Applying To College

## If you are familiar with the college application process, then you can understand JavaScript’s filter functions.

![](https://cdn-images-1.medium.com/max/800/1*c4dbmD3a3hDCxLXte3taTw.jpeg)

Compared to the map() and reduce() methods in JavaScript, the filter()method has probably the most straightforward name.

_You input an array, and you filter out the elements that fulfill a specific condition into a new array._

This seems simple, but I always seemed to find myself reverting to for() loops. So, I decided to find a better way to understand how filter() functions worked.

I realized that filter functions are kind of like a college admissions officer. They use a set of parameters to decide which students should be admitted to their particular college. Yes, we all wish that colleges were a little more flexible and judged our accomplishments holistically, but in reality, most still have hard numbers around SAT, ACT and GPA scores that determine who will be considered.

Let’s get into it!

![](https://cdn-images-1.medium.com/max/800/0*PWtOoSbsLMCAcXmC.png)

### Using A For Loop Instead of Filter Function

Okay, let’s say that we have an array of 4 students with names and GPAs. This particular college only wants to admit students with a 3.2 GPA or higher. Here is how you might do that.

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

Wow! That was way more complicated than it needed to be. If someone was reading over your code, they would need to track multiple arrays just to learn that you were simply filtering one array into another. And, you need to carefully track _i_ as you go in order to avoid any bugs. Let’s learn how to use the filter method to accomplish the same thing.

### Using the Filter() Method

Let’s learn how to accomplish the same goal with the filter() method.

1.  Filter is an array method, so we will start with the array of students.
2.  It uses a callback function that runs on each element in the array.
3.  It uses a return statement to show which elements will actually end up in the final array, in this case, the admitted students.

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

The inputs and outputs are the same, so here’s what we did differently:

1.  We didn’t need to declare the admitted array and then fill it later. We declared it and then filled it with elements in the same code block
2.  We actually used a condition within the return statement! That means that we only return elements that pass a certain condition.
3.  We can now use _student_ for each element in the array, rather than students[i] like we did in the _for_ loop.

![](https://cdn-images-1.medium.com/max/800/0*0TEOSb8MRGdi_lDb)

![](https://cdn-images-1.medium.com/max/800/0*oV583nYxvCID3r_G)

You may notice that one thing is counterintuitive- getting admitted to college is the last step, but in our code, the variable _admitted_ is the first part of the statement! You might usually expect to find the final array as the last statement within the function. Instead, we use return to indicate which elements will end up in _admitted_.

![](https://cdn-images-1.medium.com/max/800/0*VvRQ32vesw8bJsn3)

### Example 2- Using Two Conditions Within Filter

So far, we have just used one condition in our filter methods. But that does not represent the college admission process at all! Usually, admissions officers are looking at 10+ factors.

Let’s look at two factors- GPA and SAT scores. Students must have a GPA over 3.2 and an SAT score over 1900. Here is what the same function would look like.

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

Looks pretty similar, right? Now we just have two conditions within the _return_ statement. But let’s break that code down a bit further.

```
let admitted = students.filter(function(student){
   let goodStudent = student.gpa > 3.2 && student.SAT > 1900
   return goodStudent;
})
```

Aha! So here is another important difference when compared to _for_ loops. If you check out the goodStudent variable, you can see that it will only evaluate to _true_ or _false_. Then, that boolean is fed into the return statement.

So, that _true_ or false really just decides if each member of the original array will be included or not in the resulting array, _admitted_.

![](https://cdn-images-1.medium.com/max/800/0*OVFaI775MKnz6jrQ)

![](https://cdn-images-1.medium.com/max/800/0*9_aVs54EmW0P5UnJ)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
