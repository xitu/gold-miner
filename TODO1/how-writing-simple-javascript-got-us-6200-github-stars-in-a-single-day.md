> * 原文地址：[How We Write Full Stack JavaScript Apps](https://medium.com/@eliezer/how-writing-simple-javascript-got-us-6200-github-stars-in-a-single-day-420b17b4cff4)
> * 原文作者：[Elie Steinbock](https://medium.com/@eliezer)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-writing-simple-javascript-got-us-6200-github-stars-in-a-single-day.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-writing-simple-javascript-got-us-6200-github-stars-in-a-single-day.md)
> * 译者：[cyz980908](https://github.com/cyz980908)
> * 校对者：[Moonliujk](https://github.com/Moonliujk)，[sin7777](https://github.com/sin7777)

# 如何编写全栈 JavaScript 应用

我们的 GitHub 仓库最近在 GitHub 上获得了 10,000 颗星。它在 HackerNews、GitHub Trending 上排名第一，并在 Reddit 上获得了 2 万个赞。

这篇文章是我这一段时间以来一直想写的，随着我们的仓库快速上升，我认为现在是写它的最佳时间。

![No. 1 Trending on GitHub](https://cdn-images-1.medium.com/max/5760/1*Sx7fPiSnvJFFnK7bwJ1B_w.png)

我是[自由职业者](https://elie.tech)团队的一员，我们使用 React/React Native、Node.js、GraphQL 等典型项目。这篇文章既是写给那些有兴趣了解我们如何构建完整的全栈应用程序的人，也是那些将来打算加入我们的人的入职工具。

以下是我们的核心原则。

## 保持简单易读

说起来容易做起来难。大多数开发人员都明白简单易读是一个重要的原则，但是这并不那么容易就做到的。简单易读的代码使维护更容易，还使所有团队成员更容易做出贡献。它还将帮助您在日后管理自己的代码。

我看到的一些错误：

* 过于聪明。复制粘贴代码有时是挺好的。您不需要抽象每两段看起来有些相似的代码。我自己就犯过这个错误。人人都这样。DRY（Don't Repeat Yourself）是一个很好的原则，但是选择错误的抽象可能会很糟糕，并使代码库复杂化。如果您想了解更多相关内容，我推荐：[AHA Programming](https://kentcdodds.com/blog/aha-programming).
* 拒绝使用现成的工具。比如放着 `map` 和 `filter` 不用，反而去用 `reduce`。当然您**可以**用 `map` 和 `reduce`，但它可能会有更多的代码行数，而且其他人也更难理解。
当然，简单易读是主观的。您将看到经验丰富的开发人员在他们不需要使用 `reduce` 的地方使用 `reduce`。
有时您需要使用 `reduce`，如果您曾经束缚于 `map` 和 `filter`，`reduce` 可能会有更好的表现，因为您只需要将集合传递一次而不是两次。这是一个性能与简单易懂性的抉择。总的来说，我倾向于简单易读，避免过早的优化。如果使用两层的 `map`/`filter` 成为了您的瓶颈，您可以将代码切换为使用 `reduce`。

下面的许多原则也旨在使代码库尽可能简单易读。

## 物以类聚（主机托管）

这一原则适用于应用程序的许多部分。客户端和服务器文件夹结构，以及在每个文件中的代码，保持在相同的仓库。

#### 仓库

将客户端和服务器文件夹保存在同一个 Monorepo 中。（译者注：Monorepo 是用一个仓库来管理所有的源代码，Multirepo 是用多个仓库来管理自己的源代码）这很简单。别把事情复杂化。人人都是用这种方式同步的。在使用 Multirepo 的项目中工作，也并不是世界末日，但是使用 Monorepo 会让生活变得更简单。您不会意外地拥有不同步的客户端和服务器。

#### 客户端结构

一个常见的客户端文件夹结构是按文件类型分组。该结构使用不同的文件夹：components，containers，actions，reducers 和 routes（actions 和 reducers 是使用 redux 才有的，而我会尽量避免用它）。components 文件夹将包含 `BlogPost` 和 `Profile` 之类的内容，而 containers 文件夹将包含 `BlogPostContainer` 和 `ProfileContainer` 文件。容器将从服务器获取数据并将其传递给 Dumb 子组件，Dumb 子组件的工作是将数据呈现到屏幕上。（译者注：React 中可以将组件分为 Smart 和 Dumb 两类，方便组件复用）

这个结构是可行的。至少它是一致的，这是很重要的，一个新加入代码库的人会明白发生了什么，在哪发生的。但这种结构的缺点，也是我个人现在避免使用它的原因是，您必须经常跳转代码库。比如，`ProfileContainer` 和 `BlogPostContainer` 它们之间没有任何关系，但是文件就在彼此的旁边，并且远离它们实际要使用的地方。

我更喜欢将要一起使用的文件分为一组 —— 一种基于功能的方法。将 Smart 父组件和 Dumb 子组件放在同一个文件夹中。这会让您的生活更容易。

我们通常使用 `routes` / `screens` 文件夹和 `components` 文件夹。组件将包含可以在应用程序的任何页面上使用的 `Button` 或 `Input` 等内容。route 文件夹中的每个文件夹代表着应用程序的不同页面，与该路由相关的所有组件和业务逻辑都放在该文件夹中。在多个屏幕上使用的组件放在 `components` 文件夹中。

在每个 route 文件夹中，您可以在其中创建更多文件夹，对页面的某些部分进行分组。所以如果 route 文件夹中包含了很多内容，这是可以理解的。但是我要警告的一件事是，不要嵌得太深。这将使我们这个项目在这个项目中更难地跳转。这是不必要的事情过于复杂的另一个迹象（顺便说一句，使用 command-p 和搜索也是在项目找到所需内容的好方法，但文件结构会有所影响）。

类似的方法是按功能分组，而不是按路由分组。在一个使用 Mobx State Tree 并且包含许多特性的单页面的项目中，这种方法对我非常有效。按常规方法分组很简单，而且不需要花费太多脑力来找出应该分组的内容和在哪里找到项目。按功能分组的一个麻烦之处在于决定它属于哪里。功能的边界可能很模糊。

更进一步，您甚至可能喜欢将容器和组件放在同一个文件中。或者更进一步，把两部分合为一。我知道您在想什么。“这家伙在说些什么？这是亵渎。”实际上，它并不像听起来那么糟糕，实际上非常好，如果您正在使用 React Hook 和/或生成的代码，我推荐使用这种方法。

真正的问题是，为什么要将组件分成 Smart 和 Dumb 组件？对此有几个答案：

1. 易于测试
2. 易于工具的使用，如 Storybook
3. 可以使用相同的 Dumb 组件 与多个不同的 Smart 组件（反之亦然）。
4. 可以跨平台共享 Smart 组件（例如 React 和 React Native）。

这些都是正当的理由，但往往无关紧要。在我们的代码库中，我们经常使用带有 hook 的 [Apollo Client](https://www.apollographql.com/)。它用来进行测试，您可以模拟 Apollo 响应，也可以模拟 hook。Storybook 也是如此。至于混合和匹配 Smart 和 Dumb 组件，我从未在实践中看到过这种情况。至于跨平台使用，有一个项目我打算这么做，但最终没有实践。那个项目应该是 [Lerna](https://lerna.js.org/) 管理的一个 Monorepo。今天，无论如何您都很可能选择 React Native Web 而不是这种方法。

因此，区分 Smart 组件和 Dumb 组件是有正当理由的。这是一个需要注意的重要概念，但通常不需要像您想象的那样担心，特别是最近 React 添加了 hook 新特性。

在同一个组件中组合 Smart 组件和 Dumb 组件的好处是，它加快了开发时间，而且更简单。

此外，如果将来有需要，您也是可以将组件分成两个单独的组件的。

**样式**

我们使用 [emotion](https://emotion.sh)/[styled components](https://www.styled-components.com/) 进行样式管理。人们倾向于将样式拆分为单独的文件。我见过有人这样做，但在尝试了这两种方法之后，我认为没有任何理由将样式放在不同的文件中。与这里列出的其他所有内容一样，如果您将样式与它们所关联的组件放在同一个文件中，那么您的生活会更容易。

[React 官方文档](https://reactjs.org/docs/faq-structure.html)中包含了一些关于结构的简明说明，我也推荐大家通读一遍。其中最大的收获：

> 一般来说，将经常更改的文件放在一起是一个好主意。这一原则被称为“托管”。

#### 服务器结构

服务器也是如此。我个人避免使用的典型结构是[这样的](https://dev.to/santypk4/bulletproof-node-js-project-architecture-4epf)：

> src
>  │ app.js # App 入口点
>  └───api # 表示 app 的所有后端路由控制器 
>  └───config # 环境变量和配置相关的东西
>  └───jobs # agenda.js 的作业定义
>  └───loaders # 将启动过程分成模块
>  └───models # 数据库模型
>  └───services # 所有的业务逻辑都在这里
>  └───subscribers # 异步任务的事件处理程序
>  └───types # Typescript 的类型声明文件（d.ts） 

我们通常在我们的项目中使用 GraphQL。有模型、服务和解析器文件。与其把这三个文件分散在应用程序中，不如把它们都放在同一个文件夹中。绝大多数情况下，它们会一起使用，如果它们放在一起，您会更容易找到它们。

在这里看一个示例服务器结构：[**elie222/bike-sharing**](https://github.com/elie222/bike-sharing)

## 不重写类型

我们在项目中使用了很多类型系统：TypeScript，GraphQL，数据库模式，有时候还有 Mobx State Tree。

您可能会写同样的类型 3 或 4 次。避免这种情况。使用自动生成类型的工具。

在服务器上，您可以使用 TypeORM/Typegoose 和 TypeGraphQL 的组合来覆盖所有类型。TypeORM/Typegoose 将定义数据库模式 以及它们的 TypeScript 类型。TypeGraphQL 将生成 GraphQL 类型和 TypeScript 类型。

在一个文件中定义 TypeORM（MongoDB）和 TypeGraphQL 类型的一个例子:

```TypeScript
import { Field, ObjectType, ID } from 'type-graphql'
import {
  Entity,
  ObjectIdColumn,
  ObjectID,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm'

@ObjectType()
@Entity()
export default class Policy {
  @Field(type => ID)
  @ObjectIdColumn()
  _id: ObjectID

  @Field()
  @CreateDateColumn({ type: 'timestamp' })
  createdAt: Date

  @Field({ nullable: true })
  @UpdateDateColumn({ type: 'timestamp', nullable: true })
  updatedAt?: Date

  @Field()
  @Column()
  name: string

  @Field()
  @Column()
  version: number
}
```

[GraphQL Code Generator](https://graphql-code-generator.com/) 能够生成许多不同类型。我们使用它在客户端上生成 TypeScript 类型，并使用 React Hook 调用服务器。

如果您使用 Mobx State Tree，可以通过添加 2 行代码自动从中获取 TypeScript 类型，如果将它与 GraphQL 一起使用，则会有一个名为 [MST-GQL](https://github.com/mobxjs/mst-gql) 的新包，它将从 GQL 模式中生成状态树。

将这些包一起使用将节省您重写大量代码并帮助您避免潜在的 bug。

其他解决方案 [Prisma](https://www.prisma.io/)，[Hasura](https://hasura.io/) 和 [AWS AppSync](https://aws.amazon.com/appsync/) 也可以帮助避免类型复制。使用这些工具有利有弊。对于我们所做的项目，这些也不总是一个选项，因为我们需要将代码部署到提前预置好的服务器上。

## 尽可能地生成代码

除了使用上面的代码生成工具，您还会发现自己一次又一次地编写相同的代码。我在这里可以给您的第一个技巧是为您经常使用的所有东西添加 snippet。如果您写了大量的 `console.log`，确保您有一个 `cl` snippet 将 `cl` 展开为 `console.log()`。如果您不这样做，还请我帮忙调试您的代码，我会生气的。

尽管有很多 snippet 的包，但是您也可以很容易地在这里生成您自己的：[**snippet generator**](https://snippet-generator.app/)

一些我喜欢的 snippet：

* `cl` — console.log
* React component/hooks snippets
* `imes` — import emotion/styled
* `sc` — emotion/styled component
* `fn` — 打印当前所在文件的文件名。

如果您想手动将它们添加到 VS Code 中，下面是代码：

```JSON
{
  "Export default": {
    "scope": "javascript,typescript,javascriptreact,typescriptreact",
    "prefix": "eid",
    "body": [
      "export { default } from './${TM_DIRECTORY/.*[\\/](.*)$$/$1/}'",
      "$2"
    ],
    "description": "Import and export default in a single line"
  },
  "Filename": {
    "prefix": "fn",
    "body": ["${TM_FILENAME_BASE}"],
    "description": "Print filename"
  },

  "Import emotion styled": {
    "prefix": "imes",
    "body": ["import styled from '@emotion/styled'"],
    "description": "Import Emotion js as styled"
  },
  "Import emotion css only": {
    "prefix": "imec",
    "body": ["import { css } from '@emotion/styled'"],
    "description": "Import Emotion css only"
  },
  "Import emotion styled and css only": {
    "prefix": "imesc",
    "body": ["import styled, { css } from ''@emotion/styled'"],
    "description": "Import Emotion js and css"
  },
  "Styled component": {
    "prefix": "sc",
    "body": ["const ${1} = styled.${2}`", "  ${3}", "`"],
    "description": "Import Emotion js and css"
  },

  "TypeScript React Function Component": {
    "prefix": "rfc",
    "body": [
      "import React from 'react'",
      "",
      "interface ${1:ComponentName}Props {",
      "}",
      "",
      "const ${1:ComponentName}: React.FC<${1:ComponentName}Props> = props => {",
      "  return (",
      "    <div>",
      "      ${1:ComponentName}",
      "    </div>",
      "  )",
      "}",
      "",
      "export default ${1:ComponentName}",
      ""
    ],
    "description": "TypeScript React Function Component"
  },
  
  "console.log": {
    "prefix": "clg",
    "body": [
      "console.log('$1', $1)"
    ],
    "description": "console.log"
  },
  "console.log JSON": {
    "prefix": "clgj",
    "body": [
      "console.log('$1', JSON.stringify($1, null, 2))"
    ],
    "description": "console.log JSON"
  }
}
```

除了 snippet，编写代码生成器也可以节省大量时间。我喜欢使用 [plop](https://plopjs.com/)。

Angular 有自己的生成器，可以通过命令行创建一个新的组件，每个 Angular 组件都有 4 个文件。很遗憾 React 没有这样开箱即用的功能，但是您可以使用 `plop` 自己创建它。如果您创建的每个新组件都应该是一个包含组件、测试和 Storybook 文件的文件夹，那么生成器可以在一行中为您创建。在很多情况下，这会让我们的生活变得轻松。例如，在服务器上添加新特性是命令行中的一行，它创建一个实体、服务和解析器文件，所有核心部分都自动填写。

生成器的另一个好处是它推动您的团队以一致的方式工作。如果每个人都使用相同的 plop 生成器，代码将具有非常一致的感觉。

看一下在这个项目中我们使用的生成器的例子：[**elie222/bike-sharing**](https://github.com/elie222/bike-sharing)

## 自动格式化代码

这很简单，但不幸的是并不总是这样。不要浪费时间在缩进代码和添加或删除分号上。在每次提交时，使用 Prettier 自动格式化代码：[**azz/pretty-quick**](https://github.com/azz/pretty-quick)

---

## 总结

我们讨论了多年来我们从尝试不同方法中学到的一些技巧。有很多方法可以构造代码库，但是没有一种方法是绝对“正确的”。

核心思想是保持事物的简单、一致、结构化和易于遍历。这将方便许多人参与到项目中工作，而且马上就有种在读自己代码的感觉。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
