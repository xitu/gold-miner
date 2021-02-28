> * 原文地址：[Typescript 4.2 Released, Improves Types and Developer Experience](https://www.infoq.com/news/2021/02/typescript-4-2-released/)
> * 原文作者：[Bruno-Couriol](https://www.infoq.com/profile/Bruno-Couriol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Typescript-4-2-Released,-Improves-Types-and-Developer-Experience.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Typescript-4-2-Released,-Improves-Types-and-Developer-Experience.md)
> * 译者：
> * 校对者：

# Typescript 4.2 Released, Improves Types and Developer Experience


The TypeScript team announced the release of [TypeScript 4.2](https://devblogs.microsoft.com/typescript/announcing-typescript-4-2/), which features more flexible type annotations, stricter checks, extra configuration options, and a few breaking changes. Tuple types now allow rest arguments in any position (instead of only in last position). Type aliases are no longer expanded in type error messages, providing a better developer experience.

TypeScript 4.2 [supports rest arguments in any position in tuple types](https://github.com/microsoft/TypeScript/pull/41544):

```
type T1 = [...string[], number];  // Zero or more strings followed by a number
type T2 = [number, ...boolean[], string, string];  // Number followed by zero or more booleans followed by two strings

```

In previous versions, the rest arguments had to be in last position (e.g., **`type T1 = [number, ...string[]];`**. It was thus not possible to strongly type functions with a variable number of parameters that ended with a fixed set of parameters:

```
function f1(...args: [...string[], number]) {
    const strs = args.slice(0, -1) as string[];
    const num = args[args.length - 1] as number;
    // ...
}

f1(5);
f1('abc', 5);
f1('abc', 'def', 5);
f1('abc', 'def', 5, 6);  // Error

```

The function **`f1`** has an indefinite number of arguments of type **`string`**, followed by a parameter of type **`number`**. **`f1`** can now be typed accurately. Multiple rest elements are not permitted. An optional element cannot precede a required element or follow a rest element. Types are normalized as follows:

```
type Tup3<T extends unknown[], U extends unknown[], V extends unknown[]> = [...T, ...U, ...V];

type TN1 = Tup3<[number], string[], [number]>;  // [number, ...string[], number]
// Optional element following required element
type TN2 = Tup3<[number], [string?], [boolean]>;  // [number, string | undefined, boolean]
type TN3 = Tup3<[number], string[], [boolean?]>;  // [number, ...(string | boolean | undefined)[]]
type TN4 = Tup3<[number], string[], boolean[]>;  // [number, ...(string | boolean)[]]
type TN5 = Tup3<string[], number[], boolean[]>;  // (string | number | boolean)[] 

```

TypeScript 4.2 provides a better developer experience when using type aliases:

![https://imgur.com/rQkqilu.png](https://imgur.com/rQkqilu.png)

The previous example shows that the type alias **`BasicPrimitive`** that was previously expanded (normalized) in some contexts (i.e. to **`number | string | boolean`**) is no longer so. The release note emphasized the improved developer experience in several parts of the TypeScript experience:

> You can avoid some unfortunately humongous types getting displayed, and that often translates to getting better .d.ts file output, error messages, and in-editor type displays in quick info and signature help. This can help TypeScript feel a little bit more approachable for newcomers.

The **`abstract`** modifier can now be used on constructor signatures.

instance.

```
abstract  class  Shape  {
  abstract  getArea():  number;
}  
// Error! Can't instantiate an abstract class.  
new  Shape();

interface  HasArea  {  
getArea():  number;  
}  
// Error! Cannot assign an abstract constructor type to a non-abstract constructor type.  
let  Ctor:  new  ()  =>  HasArea  =  Shape;

// Works!
let  Ctor:  abstract  new  ()  =>  HasArea  =  Shape;  
//          ^^^^^^^^

```

The new semantics for the **`abstract`** modifier allows [writing *mixin factories* in a way that supports abstract classes](https://github.com/microsoft/TypeScript/pull/36392).

Destructured variables can now be explicitly marked as unused. Some developers would previously write:

```
const [Input, /* state */ , /* actions */, meta] = input 

```

for better maintainability and readability instead of

```
const [Input, , , meta] = input 

```

Those developers can now prefix unused variables with an underscore:

```
const [Input, _state , _actions, meta] = input

```

The new version of TypeScript also adds stricter checks for the **`in`** operator: **`"foo" in 42`** will trigger a type error. TypeScript’s uncalled function checks now apply within **`&&`** and **`||`** expressions. Setting the **`noPropertyAccessFromIndexSignature`** flag no longer makes it possible to use [property access with the dot operator (e.g., **`person.name`**) when a type had a string index signature](https://devblogs.microsoft.com/typescript/announcing-typescript-4-2/#no-property-access-index-signature). The **`explainFiles`** compiler flag (e.g., **`tsc --explainFiles`**) has the compiler produce detailed information about resolved and processed files:

```
TS_Compiler_Directory/4.2.2/lib/lib.es5.d.ts
  Library referenced via 'es5' from file 'TS_Compiler_Directory/4.2.2/lib/lib.es2015.d.ts'
TS_Compiler_Directory/4.2.2/lib/lib.es2015.d.ts
  Library referenced via 'es2015' from file 'TS_Compiler_Directory/4.2.2/lib/lib.es2016.d.ts'

... More Library References...

foo.ts
  Matched by include pattern '**/*' in 'tsconfig.json'

```

TypeScript 4.2 also contains a few breaking changes. Type arguments in JavaScript [are not parsed as type arguments](https://devblogs.microsoft.com/typescript/announcing-typescript-4-2/#type-arguments-in-javascript-are-not-parsed-as-type-arguments), meaning that the valid TypeScript code **`f<T>(100)`** will be parsed in a JavaScript file as per the JavaScript spec, i.e. as **`(f < T) > (100)`**. **`.d.ts`** extensions [cannot be used In import paths](https://devblogs.microsoft.com/typescript/announcing-typescript-4-2/#d-ts-extensions-cannot-be-used-in-import-paths): **`import { Foo } from "./foo.d.ts";`** may be replaced with any of the following:

```
import  {  Foo  }  from  "./foo.js";
import  {  Foo  }  from  "./foo";
import  {  Foo  }  from  "./foo/index.js";

```

TypeScript 4.2 gets TypeScript ever closer to its goal of accurately typing JavaScript at any scale, anywhere JavaScript runs. With every release, however, TypeScript increases its complexity. One developer [noted](https://blog.bitsrc.io/typescript-4-2-is-here-what-is-new-good-and-bad-b734a3aa0050):

> With so many updates to TypeScript, people start wondering if there will be a point [… when] it becomes too complicated to know it all, just like C++.

TypeScript contains additional features and breaking changes. Developers are invited to read the [full release note](https://devblogs.microsoft.com/typescript/announcing-typescript-4-2). TypeScript is open-source software available under the Apache 2 license. Contributions and feedback are encouraged via the [TypeScript GitHub project](https://github.com/Microsoft/TypeScript/) and should follow the [TypeScript contribution guidelines](https://github.com/Microsoft/TypeScript/blob/master/CONTRIBUTING.md) and [Microsoft open-source code of conduct](https://opensource.microsoft.com/codeofconduct/).
> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
