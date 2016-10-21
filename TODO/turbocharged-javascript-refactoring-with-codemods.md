* 原文链接 : [Turbocharged JavaScript refactoring with codemods](https://medium.com/airbnb-engineering/turbocharged-javascript-refactoring-with-codemods-b0cae8b326b9#.tjerodd52)
* 原文作者 :[Joe Lencioni](https://medium.com/u/e52389684329)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Hikerpig](https://github.com/hikerpig)
* 校对者: [Jack-Kingdom](https://github.com/Jack-Kingdom)，[godofchina](https://github.com/godofchina)

# 使用重构件（Codemod）加速 JavaScript 开发和重构

![](http://ww2.sinaimg.cn/large/005SiNxygw1f3j86n6dapj30m80gk43b.jpg)

### 使用重构件（Codemod）加速 JavaScript 开发

在花园里耕耘乐趣无穷，但如果除草不勤，最后收获可能是一团揪心。漏掉一次除草本身可能并无大碍，但积少成多最后会毁掉整座花园。没有杂草的花园让维护工作神清气爽。这个道理对代码库也类似。

我通常讨厌除草，经常忘记这事的结果就是一团糟。谢天谢地在编程界有像 [ESLint](http://eslint.org/) 和 [SCSS-Lint](https://github.com/brigade/scss-lint) 这样的好东西提醒我们勤理代码。但是如果面对的是大段大段的历史代码，光是想想要手动调整成百十千万的空格和逗号，悲伤便逆流成河。

8年来有几百万行 JavaScript 代码进入 Airbnb 的版本控制系统中。同时，前端界风起云涌。新功能，新框架，甚至 JavaScript 本身都在快速进化。尽管遵循[良好的代码风格](https://github.com/airbnb/javascript)会让变革少些疼痛，但还是很容易累积出不再遵循最新"最佳实践"的巨大代码库。每一处代码风格的不一致都是一棵杂草，唯一归宿就是被铲掉，化作春泥更护花，好让开发团队保持高效。来看看我们花园现在的样子：

![](http://ww1.sinaimg.cn/large/005SiNxygw1f3j83hmmrij30jk0dvjsn.jpg)

我执着于增加团队效率，也深知保持一致性的代码能增速团队反馈和减少无效沟通。我们最近开始了一个整理代码的项目，准备把许多陈旧的 JavaScript 代码转化得符合我们的代码风格，亦使我们的代码检验器有更多用武之地。若全都手动完成，会是件十分无聊和耗时的苦差，所以我们借助工具帮我们自动化此工作。虽说使用 _`eslint -fix`_ 是个不错的开始，但[它现在所能有限](https://github.com/eslint/eslint/issues/5329)。尽管他们[最近开始接受修复所有规则的PR](https://twitter.com/geteslint/status/723909416957829122)，也准备[构建 JavaScript 的具体语法树](https://github.com/cst/cst)，但等这些功能完成还需要些时间。感谢上苍我们发现了 Facebook 的 [jscodeshift](https://github.com/facebook/jscodeshift)，这是一个重构工具（协助大型代码库的自动化重构）。如果代码库是个花园，那么 jscodeshift 就像个除草机器人。

此工具将 JavaScript 解析为一棵 [抽象语法树](https://en.wikipedia.org/wiki/Abstract_syntax_tree)，并在其上进行变换，然后输出符合指定代码风格的新 JavaScript 代码。转换过程是用 JavaScript 本身实现的，所以我们团队很乐意使用此工具。寻找或是创建转换代码能加速我们乏味的重构，让我们团队能够专注于更有意义的工作。

运行几个代码重构件后，我们的花园整洁了点：

![](http://ww4.sinaimg.cn/large/a490147fjw1f3j9ybpgazj20je0flwfm.jpg)

### 策略

鉴于多数重构件能在一分钟内处理上千文件，我发现它是我打发主要工作的等待间隙（例如等代码审查）的不错选择。它帮我最大化提升了工作效率从而让我能在更大和更重要的项目中有所建树。

大规模重构主要面临四大挑战。沟通、正确性、代码审查以及冲突合并。我采取以下策略来应对这些挑战。

重构件不总是能产出我需要的结果，因此对其结果的审查和改动十分重要。以下命令在跑完重构件后很有用：

    git diff
    git add --patch
    git checkout --patch

保持每个提交和 PR 在小的体量是好的做法，对于重构件也不例外。我通常一段时间内进行一类重构，减少代码审查和冲突合并的麻烦。我亦经常让重构件自动提交重构结果，而后若有必要，再手动清理。这样在衍合分支时解决冲突会轻松点，因为我可以使用

    git checkout --ours path/to/conflict

然后在那个文件上再运行一次重构件，之后也不会弄乱我自己的手动提交。

有时重构件生成了很大的变动，我觉得在此情况下根据目录或文件名来分成数次提交或 PR 会比较好。例如，一个提交重构 .js 文件，另一个提交重构.jsx 文件。这样之后代码审查和冲突合并会相对轻松一点。谨遵 [Unix 哲学](https://en.wikipedia.org/wiki/Unix_philosophy)，分批进行文件重构简单到仅需调整 _`find`_ 命令的参数：

    find app/assets/javascripts -name *.jsx -not -path */vendor/* | \
      xargs jscodeshift -t ~/path/to/transform.js

为避免和别人的代码冲突，我通常在周五早上才推送我的重构件生成的提交，然后周一赶在大家开始工作之前进行衍合和合并。这样其他人周末放假前不被你的重构件阻碍，能好好整理自己的工作成果。

### 我们用得顺手的重构件

虽然此工具还比较新，已然有了一些实用的重构件。以下是一些我们成功上手了的。

#### 轻量级重构件

以下是些用着不那么痛苦的，立刻上手感受成效。

[**js-codemod/arrow-function**](https://github.com/cpojer/js-codemod#arrow-function)**:** 谨慎地把函数转为箭头函数

使用前:

    [1, 2, 3].map(function(x) {
      return x * x;
    }.bind(this));

使用后:

    [1, 2, 3].map(x => x * x);

[**js-codemod/no-vars**](https://github.com/cpojer/js-codemod#no-vars)**:** 将 _`var'_ 安全转化为 _`const`_ 或 _`let`_。

使用前:

    var belong = 'anywhere';

使用后:

    const belong = 'anywhere';

[**js-codemod/object-shorthand**](https://github.com/cpojer/js-codemod#object-shorthand)**:** 把对象字面量转为 ES6 的简写表示。

使用前:

    const things = {
      belong: belong,
      anywhere: function() {},
    };

使用后:

    const things = {
      belong,
      anywhere() {},
    };

[**js-codemod/unchain-variables**](https://github.com/cpojer/js-codemod#unchain-variables)**:** 分离连续声明的变量。

使用前:

    const belong = 'anywhere', welcome = 'home';

使用后:

    const belong = 'anywhere';
    const welcome = 'home';

[**js-codemod/unquote-properties**](https://github.com/cpojer/js-codemod#unquote-properties)**:** 移除对象属性的引号。

使用前:

    const things = {
      'belong': 'anywhere',
    };

使用后:

    const things = {
      belong: 'anywhere',
    };

#### 重量级重构件

以下重构件或是改动很多代码引发合并和冲突之痛，或是需要更多后续的手动更改以保证代码还能看得下去。

[**react-codemod/class**](https://github.com/reactjs/react-codemod#class)**:** 把 _`React.createClass`_ 转为 ES6 class 的实现。

此重构件在有 mixin 的时候不会变换，在类似于 _`propTypes`_、默认 props 和 initial state 定义这样的必要转换做得很好，还能将事件回调函数绑定到构造器上。

使用前:

    const BelongAnywhere = React.createClass({
      // ...
    });

使用后:

    class BelongAnywhere extends React.Component {
      // ...
    }

[**react-codemod/sort-comp**](https://github.com/reactjs/react-codemod#sort-comp)**:** 根据 [ESLint react/sort-comp rule](https://github.com/yannickcr/eslint-plugin-react/blob/master/docs/rules/sort-comp.md) 重新组织 React component 的方法声明顺序。

这个会调整大量代码，git 不会自动合并冲突。我觉得在使用此重构件前最好最好跟队友打个招呼，在不太容易发生冲突的时候（例如周末）进行重构。当我衍合此重构的提交且遇上冲突的时候，我会：

    git checkout --ours path/to/conflict

然后再运行一次重构件。

使用前:

    class BelongAnywhere extends React.Component {
      render() {
        return <div>Belong Anywhere</div>;
      }

      componentWillMount() {
          console.log('Welcome home');
        }
      }

使用后:

    class BelongAnywhere extends React.Component {
      componentWillMount() {
        console.log('Welcome home');
      }

     render() {
        return <div>Belong Anywhere</div>;
      }
    }

[**js-codemod/template-literals**](https://github.com/cpojer/js-codemod#template-literals)**:** 把字符串的串联转换为字符串模板字面量表示。

因为我们多处用到字符串串联，而且这个重构件尽其所能把所有字符串都转成模板，我发现很多转换结果其实并不合理。我之所以这个重构件放到"重量级"列表里，是因为它会改动很多文件，而且之后我们还得进行大量的手动修改才能得到满意的结果。

使用前:

    const belong = 'anywhere '+ welcomeHome;

使用后:

    const belong = `anywhere ${welcomeHome}`;

### 资源

若你想写自己的重构件，或是看看它能做什么，可以看下下面的资源。

*   [逐步改进复杂系统](https://www.youtube.com/watch?v=d0pOgY8__JM)：来自 Christoph Pojer 于 JSConf EU 2015 上关于 Facebook 的重构件的演讲。（亦可见[高效的 JavaScript 重构件](https://medium.com/@cpojer/effective-javascript-codemods-5a6686bb46fb)）。
*   [如何写重构件](https://vramana.github.io/blog/2015/12/21/codemod-tutorial/): 带你写一个把字符串串联转化为字符串模板字面量的重构件的教程。
*   [AST 探索](https://astexplorer.net/): 可查看由多种语法分析程序产生的 AST 的工具。好东西，可以查看你想转换的代码的 AST。
*   [NFL ♥ C重构件: 海量代码迁移](https://medium.com/nfl-engineers/nfl-codemods-migrating-a-monolith-1e3363571707): 关于 NFL 如何使用重构件的一个使用案例。
*   [react-codemod](https://github.com/reactjs/react-codemod): 一系列关于 React 的重构件。
*   [js-codemod](https://github.com/cpojer/js-codemod): 一系列常用的 JavaScript 重构件。

### 影响

在使用了一些现成的和我们自己写的并贡献给社区的重构件之后，我们的旧代码质量获得很大的提升。我不费吹灰之力便重构了40000行代码，将旧代码调整至符合 ES6 代码风格。花园焕然一新，我们之后的工作也更有效率和乐趣。

使用已有的重构件仅是牛刀小试，只有在你拿起键盘写出自己的重构件时，真正的能量才会释放。无论是对代码风格重构，或是对失效 API 的调整，重构件都能大显身手，你可以尽情想象发挥。这些技术值得学习投入，能省下你和使用你的项目使用者很多时间精力。
