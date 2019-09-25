> * 原文地址：[How We Write Full Stack JavaScript Apps](https://medium.com/@eliezer/how-writing-simple-javascript-got-us-6200-github-stars-in-a-single-day-420b17b4cff4)
> * 原文作者：[Elie Steinbock](https://medium.com/@eliezer)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-writing-simple-javascript-got-us-6200-github-stars-in-a-single-day.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-writing-simple-javascript-got-us-6200-github-stars-in-a-single-day.md)
> * 译者：
> * 校对者：

# How We Write Full Stack JavaScript Apps

Our GitHub repo recently received 10,000 stars on GitHub. It hit number one on HackerNews, GitHub Trending, and received 20,000 upvotes on Reddit.

This is a post I’ve been meaning to write for a while and with our repo blowing up I figured this would be as good a time as any to write it.

![No. 1 Trending on GitHub](https://cdn-images-1.medium.com/max/5760/1*Sx7fPiSnvJFFnK7bwJ1B_w.png)

I work as part of a team of [freelancers](https://elie.tech) and the typical projects we do use React/React Native, NodeJS, GraphQL. This post is aimed at those interested to learn how we full stack build apps, and as an on boarding tool for those that join us in the future.

These are our core principles.

## Keep It Simple

Easier said than done. Most developers understand simplicity is an important principle, but it’s not always easy to do. Simple code makes maintenance easier and makes it easier for all team members to contribute. It will also help you manage your own code half a year down the line.

Some mistakes I see:

* Being too clever. Copy paste code is sometimes okay. You don’t need to abstract every 2 pieces of code that look somewhat similar. I have made this mistake myself. We all do it. DRY is a good principal to follow, but choosing the wrong abstraction can be worse and complicates your codebase. If you’d like to read more on this, I recommend: [AHA Programming](https://kentcdodds.com/blog/aha-programming).
* Not using the tools available. One example is using `reduce` instead of `map` or `filter`. Of course you **can** write your `map` using `reduce` instead, but it will likely be more lines of code, and harder for others to understand.  
Granted, simplicity is subjective. You will see experienced developers using `reduce` in places they don’t have to.
There are times you will need to use `reduce`, and if you ever chain `map` and `filter`, `reduce` will likely be more performant as you can pass over the collection once instead of twice. This is a question of performance versus simplicity. In general I’d favour simplicity and avoid premature optimisation. If somehow the 2 pass `map`/`filter` becomes a bottleneck you can switch the code to use `reduce` instead.

Many of the following principles also aim to keep the codebase as simple as possible.

## Keep Similar Items Nearby (Colocation)

This principle applies to many parts of the app. Both client and server folder structure, keeping things in the same repo, and what code goes in each file.

#### Repo

Keep your client and server folder in the same repo. It’s easy. Don’t complicate things. Everyone will be in sync this way. Having worked on projects that used multiple repos, it’s not the end of the world, but life is easier with a monorepo. You won’t accidentally have a client and server that aren’t in sync.

#### Client Structure

One common client folder structure is to group by file type. This structure uses a different folder for: components, containers, actions, reducers, and routes. (Actions and reducers for those that use redux. I try to avoid it.) The components folder will hold something like `BlogPost` and `Profile` and the containers folder contain files called `BlogPostContainer` and `ProfileContainer`. The container will grab the data from the server and pass it to the dumb child component whose job it is to render the data to screen.

This structure works. At the least it’s consistent which is important and a new person that joins the codebase will understand what’s going on and what goes where. The downside of this approach, and why I personally avoid it nowadays, is that you have to jump around the codebase a lot. `ProfileContainer` and `BlogPostContainer` have nothing to do with each other, but the files are located right next to each other and far away from where they’re actually going to be used.

I far prefer grouping files that will be used together next to each other — a feature based approach. Stick the smart parent component and the dumb child component in the same folder. It will make your life a lot easier.

We typically use a `routes` / `screens` folder and a `components` folder. Components will hold things like `Button` or `Input` that could be used on any page of the app. Each folder within the routes folder represents a different page of the app and all components and business logic specific to that route are placed within that folder. Components that are used on multiple screens go in the `components` folder.

Within each route you can create more folders inside it that group certain parts of the page. If route contains a lot this makes sense. One thing I’d warn against is nesting too deeply. It will make it harder to jump around the project. This is another sign of overcomplicating things that don’t need to be. (On a side note, using command-p and search are a great way to jump around a project and find what you need, but file structure also has an impact.)

A somewhat similar approach is grouping by feature rather than by route. This approach worked well for me on a project that used Mobx State Tree and was a single page with lots of features on it. Grouping by routes is easy and doesn’t take a lot of brain power to figure out what should be grouped together and where to find items. An annoyance of grouping by feature can be deciding what belongs where. The boundaries of a feature can be blurry.

Taking this a step further, you may even like to stick your containers and components in the same file. Or even further, just the two components into one. I know what you’re thinking. “WTF is this guy on about? That’s blasphemy.” In reality, it’s not as bad as it sounds, it’s actually quite good, and if you’re using React Hooks and/or generated code I’d recommend this approach.

The real question is why you would even want to split your components into smart and dumb components? There are a few answers to this:

1. Easier to test
2. Easier to use with a tool like Storybook
3. Can use the same dumb component with multiple different smart components (or vice-versa).
4. Can share smart components across platforms (e.g. React and React Native).

These are all valid reasons, but often not relevant. In our codebases we often use [Apollo Client](https://www.apollographql.com/) with hooks. To test you can either mock Apollo responses or mock the hook. Same goes for Storybook. As for mixing and matching smart and dumb components, I’ve never actually seen this happen in practice. As for cross platform usage, there was one project I was going to do this, but it didn’t end up happening. It would have been a [Lerna](https://lerna.js.org/) monorepo. Today you may well choose React Native Web instead of this approach in any case.

So there are legitimate reasons to separate between smart and dumb components. It is an important concept to be aware of, but often you don’t need to be as worried about it as you think, especially with the recent addition of hooks to React.

The upside of combining smart and dumb components in the same component is that it speeds up development time and it’s more simple.

Furthermore, you can always split your component into two separate components in the future if the need arises.

**Styling**

We use [emotion](https://emotion.sh)/[styled components](https://www.styled-components.com/) for styling. There’s a temptation to split the styles into a separate file. I’ve seen people do it, but having tried both approaches, I don’t see any reason to put your styles in a different file. As with everything else listed here, your life will be easier if you colocate your styles in the same file as the components they relate to.

The [React docs](https://reactjs.org/docs/faq-structure.html) include some concise notes on structure that I recommend reading over too. The biggest takeaway:

> In general, it is a good idea to keep files that often change together close to each other. This principle is called “colocation”.

#### Server Structure

The same goes for the server. A typical structure that I personally avoid would look something like [this](https://dev.to/santypk4/bulletproof-node-js-project-architecture-4epf):

> src  
>  │ app.js # App entry point  
>  └───api # Express route controllers for all the endpoints of the app  
>  └───config # Environment variables and configuration related stuff  
>  └───jobs # Jobs definitions for agenda.js  
>  └───loaders # Split the startup process into modules  
>  └───models # Database models  
>  └───services # All the business logic is here  
>  └───subscribers # Event handlers for async task  
>  └───types # Type declaration files (d.ts) for Typescript

We typically use GraphQL for our projects. There are models, services and resolvers files. Instead of splitting these 3 files across the app, stick them all in the same folder. The vast majority of the time they’ll be used together and it will be much easier for you to find them if they’re colocated.

Take a look at a sample server structure here:[**elie222/bike-sharing**](https://github.com/elie222/bike-sharing)

## Don’t Rewrite Types

We use a lot of type systems in our projects: TypeScript, GraphQL, database schema, and sometimes Mobx State Tree types.

You could end up writing the same type 3 or 4 times over. Avoid this. Use tools that auto generate the types for you.

On the server, you can use a combination of TypeORM/Typegoose and TypeGraphQL to cover all your types. TypeORM/Typegoose will define your database schema as well as the TypeScript typings for them. TypeGraphQL will generate the GraphQL types and TypeScript typings.

An example of defining both TypeORM (MongoDB) and TypeGraphQL types in a single file:

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

[GraphQL Code Generator](https://graphql-code-generator.com/) is able to generate lots of different types. We use it to generate TypeScript types on the client as well as the React hooks to make calls to the server.

If you use Mobx State Tree, you can automatically get TS types from it by adding 2 lines of code, and if you use it with GraphQL, there’s a new package called [MST-GQL](https://github.com/mobxjs/mst-gql) that will generate the state tree from the GQL schema.

Using these packages together will save you rewriting a lot of code and help you avoid potential bugs.

Other solutions such as [Prisma](https://www.prisma.io/), [Hasura](https://hasura.io/) and [AWS AppSync](https://aws.amazon.com/appsync/) can also help avoid type duplication. There are pros and cons to using these. For the projects we do these aren’t always an option either as we need to deploy the code to on premise servers.

## Generate Code Wherever Possible

Beyond using the code generation tools above, you will find yourself writing the same code again and again. The number one tip I can give you here is to add snippets for everything you use often. If you write `console.log` a lot, make sure you have a `cl` snippet that will expand `cl` into `console.log()` for you. If you don’t and ask me to help debug your code I’ll be pissed off.

There are lots of snippet packages, but you can also generate your own very easily here:[**snippet generator**](https://snippet-generator.app/)

Some of my favourite snippets:

* `cl` — console.log
* React component/hooks snippets
* `imes` — import emotion/styled
* `sc` — emotion/styled component
* `fn` — print the filename of the file you’re currently in.

And here’s the code if you’d like to manually add them to VS Code:

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

Beyond snippets, something that can save you a tonne of time is writing code generators. I like using [plop](https://plopjs.com/).

Angular has its own generators built in and through the command line you can create a new component with 4 files present that every Angular component is expected to have. It’s a pity that React doesn’t have a feature like this out the box, but you can create it yourself using `plop`. If each new component you create should be a folder containing a component, test, and Storybook file, the generator can create this for you in one line. This makes our life a breeze in many instances. For example, adding a new feature on the server is one line in the command line that creates an entity, services and resolvers file with all the core pieces filled out automatically.

Another nice thing about generators is that it pushes your team to work in a consistent manner. If everyone is using the same plop generator the code will have an extremely consistent feel to it.

Take a look at this project for examples of generators we use:[**elie222/bike-sharing**](https://github.com/elie222/bike-sharing)

## Autoformat Code

This is an easy one, but not always done unfortunately. Don’t waste time indenting code and adding or removing semi colons. Use Prettier to autoformat the code on every commit:[**azz/pretty-quick**](https://github.com/azz/pretty-quick)

---

## Summary

We discussed some of the tricks we’ve learnt over the years from trying different approaches. There are lots of ways to structure your codebase and there is no one “right” way of doing things.

The core ideas are to keep things simple, consistent, structured and easy to traverse. This will make it easy for multiple people to work on the project and feel at home right away.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
