> * 原文地址：[Announcing TypeScript 3.7 Beta](https://devblogs.microsoft.com/typescript/announcing-typescript-3-7-beta/)
> * 原文作者：[Daniel](https://devblogs.microsoft.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/announcing-typescript-3-7-beta.md](https://github.com/xitu/gold-miner/blob/master/TODO1/announcing-typescript-3-7-beta.md)
> * 译者：
> * 校对者：

# Announcing TypeScript 3.7 Beta

We’re pleased to announce TypeScript 3.7 Beta, a feature-complete version of TypeScript 3.7. Between now and the final release, we’ll be fixing bugs and further improving performance and stability.

To get started using the beta, you can get it [through NuGet](https://www.nuget.org/packages/Microsoft.TypeScript.MSBuild), or use npm with the following command:

```
npm install typescript@beta
```

You can also get editor support by

* [Downloading for Visual Studio 2019/2017](https://marketplace.visualstudio.com/items?itemName=TypeScriptTeam.typescript-37beta)
* Following directions for [Visual Studio Code](https://code.visualstudio.com/Docs/languages/typescript#_using-newer-typescript-versions) and [Sublime Text](https://github.com/Microsoft/TypeScript-Sublime-Plugin/#note-using-different-versions-of-typescript).

TypeScript 3.7 Beta includes some of our most highly-requested features! Let’s dive in and see what’s new, starting with the highlight feature of 3.7: Optional Chaining.

## Optional Chaining

TypeScript 3.7 implements one of the most highly-demanded ECMAScript features yet: optional chaining! Our team has been heavily involved in TC39 to champion the feature to Stage 3 so that we can bring it to all TypeScript users.

So what is optional chaining? Well at its core, optional chaining lets us write code where we can immediately stop running some expressions if we run into a `null` or `undefined`. The star of the show in optional chaining is the new `?.` operator for **optional property accesses**. When we write code like

```
let x = foo?.bar.baz();
```

this is a way of saying that when `foo` is defined, `foo.bar.baz()` will be computed; but when `foo` is `null` or `undefined`, stop what we’re doing and just return `undefined`.”

More plainly, that code snippet is the same as writing the following.

```
let x = (foo === null || foo === undefined) ?
    undefined :
    foo.bar.baz();
```

Note that if `bar` is `null` or `undefined`, our code will still hit an error accessing `baz`. Likewise, if `baz` is `null` or `undefined`, we’ll hit an error at the call site. `?.` only checks for whether the value on the left of it is `null` or `undefined` – not any of the subsequent properties.

You might find yourself using `?.` to replace a lot of code that performs intermediate property checks using the `&&` operator.

```
// Before
if (foo && foo.bar && foo.bar.baz) {
    // ...
}

// After-ish
if (foo?.bar?.baz) {
    // ...
}
```

Keep in mind that `?.` acts differently than those `&&` operations since `&&` will act specially on “falsy” values (e.g. the empty string, `0`, `NaN`, and, well, `false`).

Optional chaining also includes two other operations. First there’s **optional element access** which acts similarly to optional property accesses, but allows us to access non-identifier properties (e.g. aribtrary strings, numbers, and symbols):

```
/**
 * Get the first element of the array if we have an array.
 * Otherwise return undefined.
 */
function tryGetFirstElement<T>(arr?: T[]) {
    return arr?.[0];
    // equivalent to
    //   return (arr === null || arr === undefined) ?
    //       undefined :
    //       arr[0];
}
```

There’s also **optional call**, which allows us to conditionally call expressions if they’re not `null` or `undefined`.

```
async function makeRequest(url: string, log?: (msg: string) => void) {
    log?.(`Request started at ${new Date().toISOString()}`);
    // equivalent to
    //   if (log !== null && log !== undefined) {
    //       log(`Request started at ${new Date().toISOString()}`);
    //   }

    const result = (await fetch(url)).json();

    log?.(`Request finished at at ${new Date().toISOString()}`);

    return result;
}
```

The “short-circuiting” behavior that optional chains have is limited to both “ordinary” and optional property accesses, calls, element accesses – it doesn’t expand any further out from these expressions. In other words,

```
let result = foo?.bar / someComputation()
```

doesn’t stop the division or `someComputation()` call from occurring. It’s equivalent to

```
let temp = (foo === null || foo === undefined) ?
    undefined :
    foo.bar;

let result = temp / someComputation();
```

That might result in dividing `undefined`, which is why in `strictNullChecks`, the following is an error.

```
function barPercentage(foo?: { bar: number }) {
    return foo?.bar / 100;
    //     ~~~~~~~~
    // Error: Object is possibly undefined.
}
```

More more details, you can [read up on the proposal](https://github.com/tc39/proposal-optional-chaining/) and [view the original pull request](https://github.com/microsoft/TypeScript/pull/33294).

## Nullish Coalescing

The **nullish coalescing operator** is another upcoming ECMAScript feature that goes hand-in-hand with optional chaining, and which our team has been deeply involved in championing.

You can think of this feature – the `??` operator – as a way to “fall back” to a default value when dealing with `null` or `undefined`. When we write code like

```
let x = foo ?? bar();
```

this is a new way to say that the value `foo` will be used when it’s “present”; but when it’s `null` or `undefined`, calculate `bar()` in its place.

Again, the above code is equivalent to the following.

```
let x = (foo !== null && foo !== undefined) ?
    foo :
    bar();
```

The `??` operator can replace uses of `||` when trying to use a default value. For example, the following code snippet tries to fetch the volume that was last saved in [`localStorage`](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage) (if it ever was); however, it has a bug because it uses `||`.

```
function initializeAudio() {
    let volume = localStorage.volume || 0.5

    // ...
}
```

When `localStorage.volume` is set to `0`, the page will set the volume to `0.5` which is unintended. `??` avoids some unintended behavior from `0`, `NaN` and `""` being treated as falsy values.

We owe a large thanks to community members [Wenlu Wang](https://github.com/Kingwl) and [Titian Cernicova Dragomir](https://github.com/dragomirtitian) for implementing this feature! For more details, [check out their pull request](https://github.com/microsoft/TypeScript/pull/32883) and [the nullish coalescing proposal repository](https://github.com/tc39/proposal-nullish-coalescing/).

## Assertion Functions

There’s a specific set of functions that `throw` an error if something unexpected happened. They’re called “assertion” functions. As an example, Node.js has a dedicated function for this called `assert`.

```
assert(someValue === 42);
```

In this example if `someValue` isn’t equal to `42`, then `assert` will throw an `AssertionError`.

Assertions in JavaScript are often used to guard against improper types being passed in. For example,

```
function multiply(x, y) {
    assert(typeof x === "number");
    assert(typeof y === "number");

    return x * y;
}
```

Unfortunately in TypeScript these checks could never be properly encoded. For loosely-typed code this meant TypeScript was checking less, and for slightly conservative code it often forced users to use type assertions..

```
function yell(str) {
    assert(typeof str === "string");

    return str.toUppercase();
    // Oops! We misspelled 'toUpperCase'.
    // Would be great if TypeScript still caught this!
}
```

The alternative was to instead rewrite the code so that the language could analyze it, but this isn’t convenient.

```
function yell(str) {
    if (typeof str !== "string") {
        throw new TypeError("str should have been a string.")
    }
    // Error caught!
    return str.toUppercase();
}
```

Ultimately the goal of TypeScript is to type existing JavaScript constructs in the least disruptive way. For that reason, TypeScript 3.7 introduces a new concept called “assertion signatures” which model these assertion functions.

The first type of assertion signature models the way that Node’s `assert` function works. It ensures that whatever condition is being checked must be true for the remainder of the containing scope.

```
function assert(condition: any, msg?: string): asserts condition {
    if (!condition) {
        throw new AssertionError(msg)
    }
}
```

`asserts condition` says that whatever gets passed into the `condition` parameter must be true if the `assert` returns (because otherwise it would throw an error). That means that for the rest of the scope, that condition must be truthy. As an example, using this assertion function means we **do** catch our original `yell` example.

```
function yell(str) {
    assert(typeof str === "string");

    return str.toUppercase();
    //         ~~~~~~~~~~~
    // error: Property 'toUppercase' does not exist on type 'string'.
    //        Did you mean 'toUpperCase'?
}

function assert(condition: any, msg?: string): asserts condition {
    if (!condition) {
        throw new AssertionError(msg)
    }
}
```

The other type of assertion signature doesn’t check for a condition, but instead tells TypeScript that a specific variable or property has a different type.

```
function assertIsString(val: any): asserts val is string {
    if (typeof val !== "string") {
        throw new AssertionError("Not a string!");
    }
}
```

Here `asserts val is string` ensures that after any call to `assertIsString`, any variable passed in will be known to be a `string`.

```
function yell(str: any) {
    assertIsString(str);

    // Now TypeScript knows that 'str' is a 'string'.

    return str.toUppercase();
    //         ~~~~~~~~~~~
    // error: Property 'toUppercase' does not exist on type 'string'.
    //        Did you mean 'toUpperCase'?
}
```

These assertion signatures are very similar to writing type predicate signatures:

```
function isString(val: any): val is string {
    return typeof val === "string";
}

function yell(str: any) {
    if (isString(str)) {
        return str.toUppercase();
    }
    throw "Oops!";
}
```

And just like type predicate signatures, these assertion signatures are incredibly expressive. We can express some fairly sophisticated ideas with these.

```
function assertIsDefined<T>(val: T): asserts val is NonNullable<T> {
    if (val === undefined || val === null) {
        throw new AssertionError(
            `Expected 'val' to be defined, but received ${val}`
        );
    }
}
```

To read up more about assertion signatures, [check out the original pull request](https://github.com/microsoft/TypeScript/pull/32695).

## Better Support for `never`-Returning Functions

As part of the work for assertion signatures, TypeScript needed to encode more about where and which functions were being called. This gave us the opportunity to expand support for another class of functions: functions that return `never`.

The intent of any function that returns `never` is that it never returns. It indicates that an exception was thrown, a halting error condition occurred, or that the program exited. For example, [`process.exit(...)` in `@types/node`](https://github.com/DefinitelyTyped/DefinitelyTyped/blob/5299d372a220584e75a031c13b3d555607af13f8/types/node/globals.d.ts#L874) is specified to return `never`.

In order to ensure that a function never potentially returned `undefined` or effectively returned from all code paths, TypeScript needed some syntactic signal – either a `return` or `throw` at the end of a function. So users found themselves `return`-ing their failure functions.

```
function dispatch(x: string | number): SomeType {
    if (typeof x === "string") {
        return doThingWithString(x);
    }
    else if (typeof x === "number") {
        return doThingWithNumber(x);
    }
    return process.exit(1);
}
```

Now when these `never`-returning functions are called, TypeScript recognizes that they affect the control flow graph and accounts for them.

```
function dispatch(x: string | number): SomeType {
    if (typeof x === "string") {
        return doThingWithString(x);
    }
    else if (typeof x === "number") {
        return doThingWithNumber(x);
    }
    process.exit(1);
}
```

As with assertion functions, you can [read up more at the same pull request](https://github.com/microsoft/TypeScript/pull/32695).

## (More) Recursive Type Aliases

Type aliases have always had a limitation in how they could be “recursively” referenced. The reason is that any use of a type alias needs to be able to replace substitute itself with whatever it aliases. In some cases, that’s not not possible, so the compiler rejects certain recursive aliases like the following:

```
type Foo = Foo;
```

This is a reasonable restriction because any use of `Foo` would need to be replaced with `Foo` which would need to be replaced with `Foo` which would need to be replaced with `Foo` which… well, hopefully you get the idea! In the end, there isn’t a type that makes sense in place of `Foo`.

This is fairly [consistent with how other languages treat type aliases](https://en.wikipedia.org/w/index.php?title=Recursive_data_type&oldid=913091335#In_type_synonyms), but it does give rise to some slightly surprising scenarios for how users leverage the feature. For example, in TypeScript 3.6 and prior, the following causes an error.

```
type ValueOrArray<T> = T | Array<ValueOrArray<T>>;
//   ~~~~~~~~~~~~
// error: Type alias 'ValueOrArray' circularly references itself.
```

This is strange because there is technically nothing wrong with any use users could always write what was effectively the same code by introducing an interface.

```
type ValueOrArray<T> = T | ArrayOfValueOrArray<T>;

interface ArrayOfValueOrArray<T> extends Array<ValueOrArray<T>> {}
```

Because interfaces (and other object types) introduce a level of indirection and their full structure doesn’t need to be eagerly built out, TypeScript has no problem working with this structure.

But workaround of introducing the interface wasn’t intuitive for users. And in principle there really wasn’t anything wrong with the original version of `ValueOrArray` that used `Array` directly. If the compiler was a little bit “lazier” and only calculated the type arguments to `Array` when necessary, then TypeScript could express these correctly.

That’s exactly what TypeScript 3.7 introduces. At the “top level” of a type alias, TypeScript will defer resolving type arguments to permit these patterns.

This means that code like the following that was trying to represent JSON…

```
type Json =
    | string
    | number
    | boolean
    | null
    | JsonObject
    | JsonArray;

interface JsonObject {
    [property: string]: Json;
}

interface JsonArray extends Array<Json> {}
```

can finally be rewritten without helper interfaces.

```
type Json =
    | string
    | number
    | boolean
    | null
    | { [property: string]: Json }
    | Json[];
```

This new relaxation also lets us recursively reference type aliases in tuples as well. The following code which used to error is now valid TypeScript code.

```
type VirtualNode =
    | string
    | [string, { [key: string]: any }, ...VirtualNode[]];

const myNode: VirtualNode =
    ["div", { id: "parent" },
        ["div", { id: "first-child" }, "I'm the first child"],
        ["div", { id: "second-child" }, "I'm the second child"]
    ];
```

For more information, you can [read up on the original pull request](https://github.com/microsoft/TypeScript/pull/33050).

## `--declaration` and `--allowJs`

The `--declaration` flag in TypeScript allows us to generate `.d.ts` files (declaration files) from source TypeScript files like `.ts` and `.tsx` files. These `.d.ts` files are important because they allow TypeScript to type-check against other projects without re-checking/building the original source code. For the same reason, this setting is **required** when using project references.

Unfortunately, `--declaration` didn’t work with settings like `--allowJs` to allow mixing TypeScript and JavaScript input files. This was a frustrating limitation because it meant users couldn’t use `--declaration` when migrating codebases, even if they were JSDoc-annotated. TypeScript 3.7 changes that, and allows the two features to be mixed!

When using `allowJs`, TypeScript will use its best-effort understanding of JavaScript source code and save that to a `.d.ts` file in an equivalent representation. That includes all of its JSDoc smarts, so code like the following:

```
/**
 * @callback Job
 * @returns {void}
 */

/** Queues work */
export class Worker {
    constructor(maxDepth = 10) {
        this.started = false;
        this.depthLimit = maxDepth;
        /**
         * NOTE: queued jobs may add more items to queue
         * @type {Job[]}
         */
        this.queue = [];
    }
    /**
     * Adds a work item to the queue
     * @param {Job} work 
     */
    push(work) {
        if (this.queue.length + 1 > this.depthLimit) throw new Error("Queue full!");
        this.queue.push(work);
    }
    /**
     * Starts the queue if it has not yet started
     */
    start() {
        if (this.started) return false;
        this.started = true;
        while (this.queue.length) {
            /** @type {Job} */(this.queue.shift())();
        }
        return true;
    }
}
```

will currently be transformed into the following implementation-less `.d.ts` file:

```
/**
 * @callback Job
 * @returns {void}
 */
/** Queues work */
export class Worker {
    constructor(maxDepth?: number);
    started: boolean;
    depthLimit: number;
    /**
     * NOTE: queued jobs may add more items to queue
     * @type {Job[]}
     */
    queue: Job[];
    /**
     * Adds a work item to the queue
     * @param {Job} work
     */
    push(work: Job): void;
    /**
     * Starts the queue if it has not yet started
     */
    start(): boolean;
}
export type Job = () => void;
```

For more details, you can [check out the original pull request](https://github.com/microsoft/TypeScript/pull/32372).

## Build-Free Editing with Project References

TypeScript’s project references provide us with an easy way to break codebases up to give us faster compiles. Unfortunately, editing a project whose dependencies hadn’t been built (or whose output was out of date) meant that the editing experience wouldn’t work well.

In TypeScript 3.7, when opening a project with dependencies, TypeScript will automatically use the source `.ts`/`.tsx` files instead. This means projects using project references will now see an improved editing experience where semantic operations are up-to-date and “just work”. You can disable this behavior with the compiler option `disableSourceOfProjectReferenceRedirect` which may be appropriate when working in very large projects where this change may impact editing performance.

You can [read up more about this change by reading up on its pull request](https://github.com/microsoft/TypeScript/pull/32028).

## Uncalled Function Checks

A common and dangerous error is to forget to invoke a function, especially if the function has zero arguments or is named in a way that implies it might be a property rather than a function.

```
interface User {
    isAdministrator(): boolean;
    notify(): void;
    doNotDisturb?(): boolean;
}

// later...

// Broken code, do not use!
function doAdminThing(user: User) {
    // oops!
    if (user.isAdministrator) {
        sudo();
        editTheConfiguration();
    }
    else {
        throw new AccessDeniedError("User is not an admin");
    }
}
```

Here, we forgot to call `isAdministrator`, and the code incorrectly allows non-adminstrator users to edit the configuration!

In TypeScript 3.7, this is identified as a likely error:

```
function doAdminThing(user: User) {
    if (user.isAdministrator) {
    //  ~~~~~~~~~~~~~~~~~~~~
    // error! This condition will always return true since the function is always defined.
    //        Did you mean to call it instead?t
```

This check is a breaking change, but for that reason the checks are very conservative. This error is only issued in `if` conditions, and it is not issued on optional properties, if `strictNullChecks` is off, or if the function is later called within the body of the `if`:

```
interface User {
    isAdministrator(): boolean;
    notify(): void;
    doNotDisturb?(): boolean;
}

function issueNotification(user: User) {
    if (user.doNotDisturb) {
        // OK, property is optional
    }
    if (user.notify) {
        // OK, called the function
        user.notify();
    }
}
```

If you intended to test the function without calling it, you can correct the definition of it to include `undefined`/`null`, or use `!!` to write something like `if (!!user.isAdministrator)` to indicate that the coercion is intentional.

We owe a big thanks to GitHub user [@jwbay](https://github.com/jwbay) who took the initiative to create a [proof-of-concept](https://github.com/microsoft/TypeScript/pull/32802) and iterated to provide us with with [the current version](https://github.com/microsoft/TypeScript/pull/33178).

## `// @ts-nocheck` in TypeScript Files

TypeScript 3.7 allows us to add `// @ts-nocheck` comments to the top of TypeScript files to disable semantic checks. Historically this comment was only respected in JavaScript source files in the presence of `checkJs`, but we’ve expanded support to TypeScript files to make migrations easier for all users.

## Semicolon Formatter Option

TypeScript’s built-in formatter now supports semicolon insertion and removal at locations where a trailing semicolon is optional due to JavaScript’s automatic semicolon insertion (ASI) rules. The setting is available now in [Visual Studio Code Insiders](https://code.visualstudio.com/insiders/), and will be available in Visual Studio 16.4 Preview 2 in the Tools Options menu.

![New semicolon formatter option in VS Code](https://devblogs.microsoft.com/typescript/wp-content/uploads/sites/11/2019/10/semicolons-options-3.7.png)

Choosing a value of “insert” or “remove” also affects the format of auto-imports, extracted types, and other generated code provided by TypeScript services. Leaving the setting on its default value of “ignore” makes generated code match the semicolon preference detected in the current file.

## Breaking Changes

### DOM Changes

[Types in `lib.dom.d.ts` have been updated](https://github.com/microsoft/TypeScript/pull/33627). These changes are largely correctness changes related to nullability, but impact will ultimately depend on your codebase.

### Function Truthy Checks

As mentioned above, TypeScript now errors when functions appear to be uncalled within `if` statement conditions. An error is issued when a function type is checked in `if` conditions unless any of the following apply:

* the checked value comes from an optional property
* `strictNullChecks` is disabled
* the function is later called within the body of the `if`

### Local and Imported Type Declarations Now Conflict

Due to a bug, the following construct was previously allowed in TypeScript:

```
// ./someOtherModule.ts
interface SomeType {
    y: string;
}

// ./myModule.ts
import { SomeType } from "./someOtherModule";
export interface SomeType {
    x: number;
}

function fn(arg: SomeType) {
    console.log(arg.x); // Error! 'x' doesn't exist on 'SomeType'
}
```

Here, `SomeType` appears to originate in both the `import` declaration and the local `interface` declaration. Perhaps surprisingly, inside the module, `SomeType` refers exclusively to the `import`ed definition, and the local declaration `SomeType` is only usable when imported from another file. This is very confusing and our review of the very small number of cases of code like this in the wild showed that developers usually thought something different was happening.

In TypeScript 3.7, [this is now correctly identified as a duplicate identifier error](https://github.com/microsoft/TypeScript/pull/31231). The correct fix depends on the original intent of the author and should be addressed on a case-by-case basis. Usually, the naming conflict is unintentional and the best fix is to rename the imported type. If the intent was to augment the imported type, a proper module augmentation should be written instead.

## What’s Next?

The final release of TypeScript 3.7 will be released near the start of November, with a release candidate available a few weeks earlier. We hope you give the beta a shot and let us know how things work. If you have any suggestions or run into any problems, [don’t be afraid to drop by the issue tracker and open up an issue](https://github.com/microsoft/TypeScript/issues/new/choose)!

Happy Hacking!

– Daniel Rosenwasser and the TypeScript Team

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
