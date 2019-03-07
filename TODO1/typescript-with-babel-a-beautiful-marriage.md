> * 原文地址：[TypeScript With Babel: A Beautiful Marriage](https://iamturns.com/typescript-babel/)
> * 原文作者：[Matt Turnbull](https://iamturns.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/.md](https://github.com/xitu/gold-miner/blob/master/TODO1/.md)
> * 译者：
> * 校对者：

# TypeScript With Babel: A Beautiful Marriage

![Babel and TypeScript](https://iamturns.com/static/babel-typescript-36d1d3a0edfdd9f9391a86a4503c75a2-bea90.png)

[TypeScript](https://www.typescriptlang.org/) has never been easier thanks to the [TypeScript plugin for Babel](https://babeljs.io/docs/en/babel-preset-typescript.html) (`@babel/preset-typescript`), an official year-long collaboration between the TypeScript and Babel teams. Discover 4 reasons why TypeScript and Babel are a perfect pair, and follow a step-by-step guide to upgrade to TypeScript in 10 minutes.

## Huh? What? Why?

I didn’t understand the need for this new preset at first.

Aren’t Babel and TypeScript two completely different things? How can Babel handle the TypeScript type checking? TypeScript can already output to ES5 just like Babel can, so what’s the point? Isn’t merging Babel and TypeScript complicating things?

After hours of research, my conclusion:

**TypeScript and Babel are a beautiful marriage.**

Let me show you.

## 1) You already use Babel (or should)

You’re in one of these three categories:

1. You already use Babel. If not directly, then your Webpack config feeds `*.js` files into Babel (this is the case for most boilerplates, including [create-react-app](https://github.com/facebook/create-react-app)).
2. You use Typescript *without* Babel. Consider adding Babel to your arsenal, it provides many unique features. Read on.
3. You don’t use Babel? It’s time to jump on board.

### Write modern JavaScript without breaking anything

Your JavaScript code needs to run in an old browser? No problem, Babel converts the code and makes everything a-okay. Use the latest and greatest features without worry.

The TypeScript compiler has a similar feature, enabled by setting `target` to something like `ES5` or `ES6`. But the Babel configuration improves on this with [babel-preset-env](https://babeljs.io/docs/en/babel-preset-env/). Instead of locking in a specific set of JavaScript features (ES5, ES6, etc), you list the environments you need to support:

```json
"targets": {
  "browsers": ["last 2 versions", "safari >= 7"],
  "node": "6.10"
}
```

Babel uses [compat-table](https://kangax.github.io/compat-table/) to check which JavaScript features to convert and polyfill for those specific target environments.

![compat-table](https://iamturns.com/static/compat-table-4011bf23893b052a3c08c9a89da0548e-bea90.png)

Take a moment to appreciate the genius who named this project ‘[compat-table](https://kangax.github.io/compat-table/)’.

An interesting technique used by [create-react-app](https://github.com/facebook/create-react-app/blob/96ba7bddc1600d6f5dac9da2418ee69793c22eca/packages/react-scripts/package.json#L82-L94): compile with the latest browsers during development (for speed), and compile with a larger range of browsers in production (for compatibility). Nice.

### Babel is super configurable

Want JSX? Flow? TypeScript? Just install a plugin and Babel can handle it. There’s a huge selection of [official plugins](https://babeljs.io/docs/en/plugins), mostly covering upcoming JavaScript syntax. And there’s plenty of third-party plugins too: [improve lodash imports](https://github.com/lodash/babel-plugin-lodash), [enhance console.log](https://github.com/mattphillips/babel-plugin-console), or [strip console.log](https://github.com/betaorbust/babel-plugin-groundskeeper-willie). Find more on the [awesome-babel](https://github.com/babel/awesome-babel) list.

But be careful. If the plugin alters the syntax significantly, then TypeScript may be unable to parse it. For example, the highly anticipated [optional chaining proposal](https://github.com/tc39/proposal-optional-chaining) has a Babel plugin:

![Optional chaining](https://iamturns.com/static/optional-chaining-4e8453e2d02f36a6771957310609d1c5-605fa.png)

[@babel/plugin-proposal-optional-chaining](https://babeljs.io/docs/en/babel-plugin-proposal-optional-chaining.html)

But unfortunately TypeScript is unable to understand this updated syntax.

Don’t stress, there’s an alternative…

### Babel Macros

You know [Kent C Dodds](https://twitter.com/kentcdodds)? He’s created a game-changing Babel plugin: [babel-plugin-macros](https://github.com/kentcdodds/babel-plugin-macros).

Instead of adding plugins to your Babel config file, you install the macro as a dependency and import it within your code. The macro kicks in when Babel is compiling, and modifies the code however it likes.

Here’s an example. Using [idx.macro](https://www.npmjs.com/package/idx.macro) to scratch our itch until [optional chaining proposal](https://github.com/tc39/proposal-optional-chaining) arrives.

```js
import idx from 'idx.macro';

const friends = idx(
  props,
  _ => _.user.friends[0].friends
);
```

Compiles to:

```js
const friends =
  props.user == null ? props.user :
  props.user.friends == null ? props.user.friends :
  props.user.friends[0] == null ? props.user.friends[0] :
  props.user.friends[0].friends
```

Macros are pretty new, but quickly gaining traction. Especially since landing in [create-react-app v2.0](https://reactjs.org/blog/2018/10/01/create-react-app-v2.html). CSS in JS is covered: [styled-jsx](https://www.npmjs.com/package/styled-jsx#using-resolve-as-a-babel-macro), [styled-components](https://www.styled-components.com/docs/tooling#babel-macro), and [emotion](https://emotion.sh/docs/babel-plugin-emotion#babel-macros). Webpack plugins are being ported over: [raw-loader](https://github.com/pveyes/raw.macro), [url-loader](https://github.com/Andarist/data-uri.macro), and [filesize-loader](https://www.npmjs.com/package/filesize.macro). And many more listed on [awesome-babel-macros](https://github.com/jgierer12/awesome-babel-macros).

Here’s the best part: unlike Babel plugins, *all* Babel macros are compatible with TypeScript. They can also help reduce run-time dependencies, avoid client-side computation, and catch errors earlier at build-time. Check out [this post](https://babeljs.io/blog/2017/09/11/zero-config-with-babel-macros) for more details.

![Improved console.log](https://iamturns.com/static/console.72e0a8b3.gif)

A better console.log: [scope.macro](https://github.com/mattphillips/babel-plugin-console#macros)

## 2) It’s easier to manage ONE compiler

TypeScript requires it’s own compiler — it’s what provides the amazing type checking superpowers.

### In the gloomy days (before Babel 7)

Chaining together two separate compilers (TypeScript and Babel) is no easy feat. The compilation flow becomes: `TS > TS Compiler > JS > Babel > JS (again)`.

Webpack is often used to solve this problem. Tweak your Webpack config to feed `*.ts` into TypeScript, and then feed the result into Babel. But which TypeScript loader do you use? Two popular choices are [ts-loader](https://github.com/TypeStrong/ts-loader) and [awesome-typescript-loader](https://github.com/s-panferov/awesome-typescript-loader). The `README.md` for [awesome-typescript-loader](https://github.com/s-panferov/awesome-typescript-loader) mentions it might be slower for some workloads, and recommends [ts-loader](https://github.com/TypeStrong/ts-loader) with [HappyPack](https://github.com/amireh/happypack) or [thread-loader](https://webpack.js.org/loaders/thread-loader/). The `README.md` for [ts-loader](https://github.com/TypeStrong/ts-loader) recommends combining with [fork-ts-checker-webpack-plugin](https://github.com/Realytics/fork-ts-checker-webpack-plugin), [HappyPack](https://github.com/amireh/happypack), [thread-loader](https://github.com/webpack-contrib/thread-loader), and / or [cache-loader](https://github.com/webpack-contrib/cache-loader).

Eugh. No. This is where most people get overwhelmed and put TypeScript in the “too hard” basket. I don’t blame them.

![One does not simply configure TypeScript](https://iamturns.com/static/simply-configure-typescript-1933ffec04eb2221fd05695a070016a5-27dc3.jpg)

### The bright sunny days (with Babel 7)

Wouldn’t it be nice to have *one* JavaScript compiler? Whether your code has ES2015 features, JSX, TypeScript, or something crazy custom — the compiler knows what to do.

I just described Babel. Cheeky.

By allowing Babel to act as the single compiler, there’s no need to manage, configure, or merge two compilers with some convoluted Webpack sorcery.

It also simplifies the entire JavaScript ecosystem. Instead of linters, test runners, build systems, and boilerplates supporting different compilers, they just need to support Babel. You then configure Babel to handle your specific needs. Say goodbye to [ts-node](https://github.com/TypeStrong/ts-node), [ts-jest](https://github.com/kulshekhar/ts-jest), [ts-karma](https://github.com/monounity/karma-typescript), [create-react-app-typescript](https://github.com/wmonk/create-react-app-typescript), etc, and use the Babel support instead. Support for Babel is everywhere, checkout the [Babel setup](https://babeljs.io/en/setup) page:

![Babel and TypeScript](https://iamturns.com/static/babel-support-83d89cdf00af707da859a373ff56dbf5-b1cd8.png)

[Babel has you covered.](https://babeljs.io/en/setup)

## 3) It’s faster to compile

Warning! You might want to sit down for this bit.

How does Babel handle TypeScript code? **It removes it.**

Yep, it strips out all the TypeScript, turns it into “regular” JavaScript, and continues on its merry way.

This sounds ridiculous, but this approach has two strong advantages.

The first advantage: ️⚡️*IT’S LIGHTNING FAST* ⚡️.

Most Typescript developers experience slow compilation times during development / watch mode. You’re coding away, you save a file, and… then… here it comes… annnnd… *finally*, you see your change. Oops, made a typo, fix that, save it, annnnd… eugh. It’s *just* slow enough to be annoying and break your momentum.

It’s hard to blame the TypeScript compiler, it’s doing a lot of work. It’s scanning for type definition files (`*.d.ts`), including within `node_modules`, and ensuring your code is used correctly. This is why many fork the Typescript type checking into a separate process. However the Babel + TypeScript combo still provides faster compilation thanks to Babel’s superior caching and single-file emit architecture.

So, if Babel strips out TypeScript code, what’s the point in writing TypeScript? That brings us to the second advantage…

## 4) Check for type errors only when you’re ready

You’re hacking some code together, quickly bashing out a solution to see if your idea has legs. You save the file, and TypeScript screams at you:

> "No! I won’t compile this! Your code is broken in 42 different files!"

Yeah, you *know* it’s broken. You’ve probably broken a few unit tests too. But you’re just experimenting at this point. It’s infuriating to continuously ensure *all* your code is type safe *all* the time.

This is the second advantage of Babel stripping out TypeScript code during compilation. You write code, you save, and it compiles (very quickly) *without* checking for type safety. Keep experimenting with your solution until you’re ready to check the code for errors. This workflow keeps you in the zone as you’re coding.

So how do you check for type errors? Add a `npm run check-types` script that invokes the TypeScript compiler. I tweak my `npm test` command to first check types, and then continue running unit tests.

## It’s not a perfect marriage

According to the [announcement post](https://blogs.msdn.microsoft.com/typescript/2018/08/27/typescript-and-babel-7/), there are four TypeScript features that do not compile in Babel due to its single-file emit architecture.

Don’t worry, it ain’t so bad. And TypeScript will warn against these issues when the `isolatedModules` flag is enabled.

**1) Namespaces.**

Solution: don’t use them! They’re outdated. Use the industry standard ES6 modules (`import` / `export`) instead. The [recommended tslint rules](https://github.com/palantir/tslint/blob/21358296ad11a857918b45e6a9cc628290dc3f96/src/configs/recommended.ts#L89) ensure namespaces are *not* used.

**2) Casting a type with the**`<newtype>x` **syntax.**

Solution: Use `x as newtype` instead.

**3) [Const enums](https://www.typescriptlang.org/docs/handbook/enums.html#const-enums).**

This is a shame. Need to resort to regular enums for now.

**4) Legacy-style import / export syntax.**

Examples: `import foo = require(...)` and `export = foo`.

In all my years of TypeScriptin’ I’ve never come across this. Who codes this way? Stop it!

## Ok, I’m ready to try TypeScript with Babel!

![Yeah!](https://iamturns.com/static/yeah-6e69b732a6647969c78b6249f42ca636-f6c13.jpg)

Photo by [rawpixel.com](https://www.rawpixel.com/image/384992/yeah-text-paper-and-colorful-party-confetti-background-party-concept)

Let’s do this! It should only take about 10 minutes.

I’m assuming you have Babel 7 setup. If not, see the [Babel Migration Guide](https://babeljs.io/docs/en/v7-migration.html).

**1) Rename .js files to .ts**

Assuming your files are in `/src`:

```bash
find src -name "*.js" -exec sh -c 'mv "$0" "${0%.js}.ts"' {} ;
```

**2) Add TypeScript to Babel**

A few dependencies:

```bash
npm install --save-dev @babel/preset-typescript @babel/plugin-proposal-class-properties @babel/plugin-proposal-object-rest-spread
```

In your Babel config file (`.babelrc` or `babel.config.js`):

```json
{
	"presets": [
			"@babel/typescript"
	],
	"plugins": [
			"@babel/proposal-class-properties",
			"@babel/proposal-object-rest-spread"
	]
}
```

TypeScript has a couple of extra features which Babel needs to know about (via those two plugins listed above).

Babel looks for .js files by default, and sadly this is not configurable within the Babel config file.

If you use Babel CLI, add `--extensions '.ts'`

If you use Webpack, add `'ts'` to `resolve.extensions` array.

**3) Add ‘check-types’ command**

In `package.json`:

```json
"scripts": {
	"check-types": "tsc"
}
```

This command simply invokes the TypeScript compiler (`tsc`).

Where does `tsc` come from? We need to install TypeScript:

```bash
npm install --save-dev typescript
```

To configure TypeScript (and `tsc`), we need a `tsconfig.json` file in the root directory:

```json
{
	"compilerOptions": {
		// Target latest version of ECMAScript.
		"target": "esnext",
		// Search under node_modules for non-relative imports.
		"moduleResolution": "node",
		// Process & infer types from .js files.
		"allowJs": true,
		// Don't emit; allow Babel to transform files.
		"noEmit": true,
		// Enable strictest settings like strictNullChecks & noImplicitAny.
		"strict": true,
		// Disallow features that require cross-file information for emit.
		"isolatedModules": true,
		// Import non-ES modules as default imports.
		"esModuleInterop": true
	},
	"include": [
		"src"
	]
}
```

**Done.**

Well, the *setup* is done. Now run `npm run check-types` (watch mode: `npm run check-types -- --watch`) and ensure TypeScript is happy with your code. Chances are you’ll find a few bugs you didn’t know existed. This is a good thing! The [Migrating from Javascript](https://www.typescriptlang.org/docs/handbook/migrating-from-javascript.html) guide will help here.

Microsoft’s [TypeScript-Babel-Starter](https://github.com/Microsoft/TypeScript-Babel-Starter) guide contains additional setup instructions, including installing Babel from scratch, generating type definition (d.ts) files, and using it with React.

## What about linting?

Use [tslint](https://palantir.github.io/tslint/).

**Update** (Feb 2019): Use ESlint! The TypeScript team are [focusing on ESLint integration](https://github.com/Microsoft/TypeScript/issues/29288) since January. It’s easy to configure ESLint thanks to the [@typesript-eslint](https://github.com/typescript-eslint/typescript-eslint) project. For inspiration, check out my [mega ESLint config](https://github.com/iamturns/create-exposed-app/blob/master/.eslintrc.js) which includes TypeScript, Airbnb, Prettier, and React.

## Babel + TypeScript = Beautiful Marriage.

![Love hearts](data:image/jpeg;base64,/9j/2wBDABALDA4MChAODQ4SERATGCgaGBYWGDEjJR0oOjM9PDkzODdASFxOQERXRTc4UG1RV19iZ2hnPk1xeXBkeFxlZ2P/2wBDARESEhgVGC8aGi9jQjhCY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2P/wgARCAANABQDASIAAhEBAxEB/8QAFwABAAMAAAAAAAAAAAAAAAAAAAECBf/EABYBAQEBAAAAAAAAAAAAAAAAAAECBP/aAAwDAQACEAMQAAAB04DRUFf/xAAWEAADAAAAAAAAAAAAAAAAAAAAASD/2gAIAQEAAQUCHP8A/8QAFBEBAAAAAAAAAAAAAAAAAAAAEP/aAAgBAwEBPwE//8QAFBEBAAAAAAAAAAAAAAAAAAAAEP/aAAgBAgEBPwE//8QAFBABAAAAAAAAAAAAAAAAAAAAIP/aAAgBAQAGPwJf/8QAFxABAAMAAAAAAAAAAAAAAAAAAQAQEf/aAAgBAQABPyENYq2LX//aAAwDAQACAAMAAAAQB+//xAAWEQEBAQAAAAAAAAAAAAAAAAARARD/2gAIAQMBAT8QK5//xAAUEQEAAAAAAAAAAAAAAAAAAAAQ/9oACAECAQE/ED//xAAYEAEBAQEBAAAAAAAAAAAAAAABACERMf/aAAgBAQABPxDIgDx27YZORf/Z)![Love hearts](/static/love-6816a7c4005415586f0da1a9fea5407b-f6c13.jpg)

![Love hearts](/static/love-6816a7c4005415586f0da1a9fea5407b-f6c13.jpg)

Photo by [Akshar Dave](https://unsplash.com/photos/1GRvY9WUu08)

Babel is the one-and-only JavaScript compiler you need. It can be configured to handle anything.

There’s no need to battle with two competing JavaScript compilers. Simplify your project configuration and take advantage of Babel’s amazing integration with linters, test runners, build systems, and boilerplates.

The Babel and TypeScript combo is lightning fast to compile, and allows you to stay in the zone as you code, and check types only when you’re ready.

## Prediction: TypeScript will rise.

According to the most recent [Stack Overflow Developer Survey](https://insights.stackoverflow.com/survey/2018/#technology-programming-scripting-and-markup-languages), JavaScript is the most popular language, with TypeScript trailing at #12. This is still a great achievement for TypeScript, beating out Ruby, Swift, and Go.

![Developer survey results](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAVCAIAAADJt1n/AAAACXBIWXMAAAsSAAALEgHS3X78AAABjklEQVQ4y5VUa2+jMBDk///CXqVr1fbCOWDj9Wv9iGG7pmmbKGlIR4P4AKP1zCx0zrndbmesdRa0ErRkmtMdjLTUbp5npaR1Ppi92T9SHikN24yCKnZEFLwHY7wZ9fBMB6CitwiUpzaZxTknYx3awcu/FPdbFIQ9HTwL18khsGV0k5GvVCwV8wPXRxVpmWlZjuKccwgYvXbqbX0JrjNrSlMTN6zilNLE0OBh0IIDU5TkBccmvkAHAEIIH/AzbQ5zf0Y2ycc5Tvvgp5ivcRzYszdyTfvSM9Bc6BqamKtGjOzZ6921nG6Kc0oajAcB4mHdga8zr/swZ/oBTZxS5LDRSSefKJ0Exm7XPk99XkzOOcYUrDLy5bsqLmY+0E10H7da5+AmN/07C2ypG2LuWWvNgfF6gvjzvfrHem6KEbHvewBT0Dj12g7MbmukO3D8qrjngtpzYPzRnG/ChjhGNMZGD2j+t5/B3ehKKeM48uTkVVDPtJRfiDkwKZs4o/G6v/PAJ+tZqw8xO4HyYbOeU7wDtMrL+79r9ugAAAAASUVORK5CYII=)![Developer survey results](/static/dev-survey-7e7416c3e24796eb8de66d34164a8777-aef05.png)

![Developer survey results](/static/dev-survey-7e7416c3e24796eb8de66d34164a8777-aef05.png)

I predict TypeScript will crack the top 10 by next year.

The TypeScript team are working hard to spread the love. This Babel preset was a year long collaboration, and their new focus is on [improving ESLint integration](https://github.com/Microsoft/TypeScript/issues/29288). This is a smart move — leverage the features, community, and plugins of existing tools. To develop competing compilers and linters is wasted effort.

The path to TypeScript is paved by simply tweaking the config of our favourite tools. The barrier to entry has been smashed.

With the rise in popularity of [VS Code](https://code.visualstudio.com/), developers are already setup with an amazing TypeScript environment. Autocomplete on steroids will bring tears of joy.

It’s also now integrated into [create-react-app v2.0](https://reactjs.org/blog/2018/10/01/create-react-app-v2.html), exposing TypeScript to an audience of 200k downloads per month.

If you’ve been put off by TypeScript because it’s difficult to setup, it’s no longer an excuse. It’s time to give it a go.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
