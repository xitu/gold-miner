> * 原文地址：[Importing JSON Modules in TypeScript](https://mariusschulz.com/blog/importing-json-modules-in-typescript)
> * 原文作者：[Marius Schulz](https://mariusschulz.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/importing-json-modules-in-typescript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/importing-json-modules-in-typescript.md)
> * 译者：
> * 校对者：

# Importing JSON Modules in TypeScript

TypeScript 2.9 introduced a new `--resolveJsonModule` compiler option that lets us import JSON modules from within TypeScript modules.

## [#](#importing-json-modules-via-require-calls)Importing JSON Modules via `require` Calls

Let's assume we have a Node application written in TypeScript, and let's say that we want to import the following JSON file:

```
{
  "server": {
    "nodePort": 8080
  }
}
```

In Node, we can use a `require` call to import this JSON file like any other CommonJS module:

```
const config = require("./config.json");
```

The JSON is automatically deserialized into a plain JavaScript object. This allows us to easily access the properties of our config object:

```
"use strict";

const express = require("express");
const config = require("./config.json");

const app = express();

app.listen(config.server.nodePort, () => {
  console.log(`Listening on port ${config.server.nodePort} ...`);
});
```

So far, so good!

## [#](#importing-json-files-via-static-import-declarations)Importing JSON Files via Static `import` Declarations

Let's now say we want to use native ECMAScript modules instead of CommonJS modules. This means we'll have to convert our `require` calls to static `import` declarations:

```
// We no longer need the "use strict" directive since
// all ECMAScript modules implicitly use strict mode.

import * as express from "express";
import * as config from "./config.json";

const app = express();

app.listen(config.server.nodePort, () => {
  console.log(`Listening on port ${config.server.nodePort} ...`);
});
```

Now, we get a type error in line 2. TypeScript doesn't let us import a JSON module out of the box, just like that. This was a conscious design decision made by the TypeScript team: pulling in large JSON files could potentially [consume a lot of memory](https://github.com/Microsoft/TypeScript/pull/22167#issuecomment-385479553), which is why we need to opt into that feature by enabling the `--resolveJsonModule` compiler flag:

> Having people to consciously opt into this would imply the user understands the cost.

Let's head over to our **tsconfig.json** file and enable the `resolveJsonModule` option there:

```
{
  "compilerOptions": {
    "target": "es2015",
    "module": "commonjs",
    "strict": true,
    "moduleResolution": "node",
    "resolveJsonModule": true
  }
}
```

With `--resolveJsonModule` enabled, we no longer get a type error in our TypeScript file. Even better, we now get type checking and autocompletion!

  

If we compile our TypeScript file with the compiler options shown above, we get the following JavaScript output:

```
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express = require("express");
const config = require("./config.json");
const app = express();
app.listen(config.server.nodePort, () => {
    console.log(`Listening on port ${config.server.nodePort} ...`);
});
```

Notice that the output is pretty much identical to our initial `require` version:

```
"use strict";

const express = require("express");
const config = require("./config.json");

const app = express();

app.listen(config.server.nodePort, () => {
  console.log(`Listening on port ${config.server.nodePort} ...`);
});
```

And there you go! This is how to import JSON modules from within TypeScript modules, only one compiler option away.

This post is part of the [TypeScript Evolution](/blog/series/typescript-evolution) series.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
