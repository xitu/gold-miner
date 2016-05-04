>* 原文链接 : [Turbocharged JavaScript refactoring with codemods](https://medium.com/airbnb-engineering/turbocharged-javascript-refactoring-with-codemods-b0cae8b326b9#.tjerodd52)
* 原文作者 :[Joe Lencioni](https://medium.com/u/e52389684329)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:



![](http://ww2.sinaimg.cn/large/005SiNxygw1f3j86n6dapj30m80gk43b.jpg)

### Turbocharged JavaScript refactoring with codemods

It is fun to plant and harvest new crops in my garden, but I’ll eventually wake up to a mess if I don’t regularly weed. While each weed isn’t a problem by itself, they combine forces to choke the system. Working in a weed-free garden is a productive pleasure. Codebases are like this too.

I also don’t enjoy weeding, so I forget to and end up in trouble. Thankfully, in coding, we have great tools like [ESLint](http://eslint.org/) and [SCSS-Lint](https://github.com/brigade/scss-lint) to ensure that we weed as we go. However, if we find large chunks of legacy code that deserve attention, we can be overwhelmed by the thought of manually tweaking a million spaces here and a gazillion dangling commas there.

Millions of lines of JavaScript have been checked into source control at Airbnb over the past 8 years; meanwhile, frontend Web development has evolved dramatically. Features, frameworks, and even JavaScript itself are moving targets — although following [a good style guide](https://github.com/airbnb/javascript) from the get-go will help minimize this kind of pain, it is easy to end up with a codebase that no longer follows current “best practices”. Each small inconsistency is like a little weed, waiting to be plucked to make room for something beneficial and pave the way for a more productive team. Look at the shape our garden was in:

![](http://ww1.sinaimg.cn/large/005SiNxygw1f3j83hmmrij30jk0dvjsn.jpg)

I’m obsessed with making the team faster and know that consistent code and information from linters tightens up feedback loops and reduces communication overhead. We recently started a weeding project to prepare a lot of old JavaScript to follow our style guide and enable our linters in more places. Doing all of the work by hand is pretty tedious and time-consuming, so we looked for tools to automate some of it. Although `_eslint_ —_fix_` is a great starting point, [it is currently limited in what it can fix](https://github.com/eslint/eslint/issues/5329). They’ve [recently started accepting pull requests for auto fixing any rule](https://twitter.com/geteslint/status/723909416957829122), and efforts are underway to [implement a Concrete Syntax Tree (CST) for JavaScript](https://github.com/cst/cst), but it will take some time before that is well-integrated. Thankfully, we found Facebook’s [jscodeshift](https://github.com/facebook/jscodeshift), which is a toolkit for codemods (codemods are tools that assist large-scale, partially automatable codebase refactoring). If a codebase is a garden, jscodeshift is a robo gardener.

This tool parses JavaScript into an [Abstract Syntax Tree (AST)](https://en.wikipedia.org/wiki/Abstract_syntax_tree), applies transformations, and writes out the modified JavaScript while matching local coding style. The transformations themselves are written in JavaScript, which makes this tool pretty accessible for our team. Finding or inventing the transformations we need accelerates mundane refactoring, which helps our team focus on more meaningful work.

After running a few codemods, our garden looks a little better:

![](http://ww4.sinaimg.cn/large/a490147fjw1f3j9ybpgazj20je0flwfm.jpg)

### Tactics

Since most codemods take less than a minute with thousands of files, I find that codemodding is a great side-task while I wait for something on my main thread (e.g. code review). This helps maximize my productivity while making progress on bigger or more important projects.

The main challenges I’ve run into while working on large-scale refactorings usually revolve around the 4 C’s: Communication, Correctness, Code reviews, and (merge) Conflicts. I’ve used some of the following tactics to help minimize these challenges.

Not all codemods produce the exact result I want in every case, so it is important to review and tweak the changes. I’ve found the following commands to be useful after running a codemod:

    git diff  
    git add --patch  
    git checkout --patch

Small commits and pull requests are best, and codemods are no exception. I usually work on one codemod at a time to ease reviewing and resolving merge conflicts. I also often commit the codemod result by itself, followed by a manual cleanup commit if necessary. This makes resolving merge conflicts while rebasing my branch easier, since I can usually

    git checkout --ours path/to/conflict

and run the codemod on that file again without messing with my manual changes.

Sometimes, the codemod produces a very large diff. For these cases, I’ve found that it is helpful to use separate commits or pull requests for slices of the codebase based on path or filename. For instance, one commit fixes _.js files and another commit fixes_ .jsx files. This makes reviewing easier and smooths out merge conflict resolution. Thanks to adherence to the [Unix philosophy](https://en.wikipedia.org/wiki/Unix_philosophy), running codemods on different slices is as straightforward as adjusting a call to `_find_`:

    find app/assets/javascripts -name *.jsx -not -path */vendor/* | \  
      xargs jscodeshift -t ~/path/to/transform.js

To avoid stepping on others’ toes, it has worked well for me to push codemod commits to review early on Friday, and then rebase and merge early on Monday before most people have started working again. This gives folks a chance to wrap up whatever they were working on before the weekend without your codemod getting in their way.

### Codemods that worked well for us

Although this tool is pretty young, there are a number of useful codemods already available to use. Here are some that we’ve had success with so far.

#### Lightweight codemods

These codemods were useful and relatively painless to apply, giving us quick wins.

[**js-codemod/arrow-function**](https://github.com/cpojer/js-codemod#arrow-function)**:** conservatively convert functions to arrow functions

Before:

    [1, 2, 3].map(function(x) {  
      return x * x;  
    }.bind(this));

After:

    [1, 2, 3].map(x => x * x);

[**js-codemod/no-vars**](https://github.com/cpojer/js-codemod#no-vars)**:** conservatively convert `_var_` to `_const_` or `_let_`

Before:

    var belong = 'anywhere';

After:

    const belong = 'anywhere';

[**js-codemod/object-shorthand**](https://github.com/cpojer/js-codemod#object-shorthand)**:** transform object literals to use ES6 shorthand for properties and methods

Before:

    const things = {  
      belong: belong,  
      anywhere: function() {},  
    };

After:

    const things = {  
      belong,  
      anywhere() {},  
    };

[**js-codemod/unchain-variables**](https://github.com/cpojer/js-codemod#unchain-variables)**:** unchain chained variable declarations

Before:

    const belong = 'anywhere', welcome = 'home';

After:

    const belong = 'anywhere';  
    const welcome = 'home';

[**js-codemod/unquote-properties**](https://github.com/cpojer/js-codemod#unquote-properties)**:** remove quotes from object properties

Before:

      'belong': 'anywhere',  
    };

After:

    const things = {  
      belong: 'anywhere',  
    };

#### Heavyweight codemods

These codemods either produced bigger diffs, which were more challenging to merge and avoid conflicts, or they required more follow-up tweaking to ensure that the code still looked good.

[**react-codemod/class**](https://github.com/reactjs/react-codemod#class)**:** transform `_React.createClass_` calls into ES6 classes

This codemod avoids the transformation when mixins are in play, and it does a good job of making other necessary conversions like how `_propTypes_`, default props, and initial state are defined, and binding callbacks in the constructor.

Before:

    const BelongAnywhere = React.createClass({  
      // ...   
    });

After:

    class BelongAnywhere extends React.Component {  
      // ...  
    }

[**react-codemod/sort-comp**](https://github.com/reactjs/react-codemod#sort-comp)**:** reorder React component methods to match the [ESLint react/sort-comp rule](https://github.com/yannickcr/eslint-plugin-react/blob/master/docs/rules/sort-comp.md)

Because this moves lots of large chunks of code around, git won’t automatically resolve most merge conflicts. I found it best to communicate well before running this transformation, and run it at a time that is least likely to step on toes (e.g. over a weekend). When I ran into conflicts while rebasing this one,

    git checkout --ours path/to/conflict

and running the codemod again was the best approach.

Before:

    class BelongAnywhere extends React.Component {  
      render() {  
        return <div>Belong Anywhere</div>;  
      }

<pre>  componentWillMount() {  
    console.log('Welcome home');  
  }  
}</pre>

After:

    class BelongAnywhere extends React.Component {  
      componentWillMount() {  
        console.log('Welcome home');  
      }

     render() {  
        return <div>Belong Anywhere</div>;  
      }  
    }

[**js-codemod/template-literals**](https://github.com/cpojer/js-codemod#template-literals)**:** transform string concatenation to template literals

Since we had a lot of string concatenation, and this codemod transforms as much of it as it can to template literals, I ended up with a number of cases that ended up being less readable. I’ve listed this codemod under the “heavyweight” section simply because it touched so many files and required a lot of manual choosing and tweaking to get the best results.

Before:

    const belong = 'anywhere '+ welcomeHome;

After:

    const belong = `anywhere ${welcomeHome}`;

### Resources

Whether you want to write your own codemods, or just learn about what is possible, here are some useful resources:

*   [Evolving Complex Systems Incrementally](https://www.youtube.com/watch?v=d0pOgY8__JM) by Christoph Pojer. Talk at JSConf EU 2015 about codemods at Facebook (see also [Effective JavaScript Codemods](https://medium.com/@cpojer/effective-javascript-codemods-5a6686bb46fb)).
*   [How to write a codemod](https://vramana.github.io/blog/2015/12/21/codemod-tutorial/): tutorial that walks you through writing a codemod to transform string concatenation to template literals.
*   [AST Explorer](https://astexplorer.net/): web tool to explore the AST generated by various parsers. This is a great place to play around and see what the AST looks like for some code you want to transform.
*   [NFL ♥ Codemods: Migrating a Monolith](https://medium.com/nfl-engineers/nfl-codemods-migrating-a-monolith-1e3363571707): case study of how the NFL used codemods.
*   [react-codemod](https://github.com/reactjs/react-codemod): collection of React-specific codemods.
*   [js-codemod](https://github.com/cpojer/js-codemod): collection of general JavaScript codemods.

### Impact

Using available codemods and a few that we wrote and contributed back, we quickly made big improvements to old code. I have modified 40,000 lines via codemod with little effort, which brings a lot of old code into better compliance with our ES6 style guide. Our garden is in much better shape, and we are ready for happier and more productive harvests going forward.

Running codemods that are already available only scratches the surface — true power is unlocked when you pick up a keyboard and start writing your own. Codemods are great for modifications ranging from style refactorings to support breaking API changes, so let your imagination run wild. These techniques are well worth investing in and may save you and the people who use your projects a lot of time and effort.
