> * 原文地址：[CSS Architecture for Multiple Websites](https://medium.com/@elad/css-architecture-for-multiple-websites-ad696c9d334)
> * 原文作者：[Elad Shechter](https://medium.com/@elad)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/css-architecture-for-multiple-websites.md](https://github.com/xitu/gold-miner/blob/master/TODO1/css-architecture-for-multiple-websites.md)
> * 译者：
> * 校对者：

# CSS Architecture for Multiple Websites

> CSS Architecture — Part 3

Complex CSS architecture is not something you learn in any formal institution.

My fourth job in the web industry was as a CSS/HTML expert, in one of the leading media news companies in my country, and my primary mission was to write reusable and scalable CSS for multiple websites.

![](https://cdn-images-1.medium.com/max/2000/1*WreGgi4zIgKz_cb5vRjGTA.png)

In this post, I will share with you the knowledge and experience I gained in this field of constructing a multiple website architecture.

Side note: nowadays, a proper project uses a CSS preprocessor. In this post, I will be using the SASS preprocessor.

This post is the third in a series of articles I’m writing about CSS architecture. To understand this post better, I recommend that you read at least the second post in this series, “[CSS Architecture — Folders & Files Structure](https://medium.com/@elad/css-architecture-folders-files-structure-f92b40c78d0b)”.

## Layers World

Starting a large-scale project requires thinking globally and defining what things the sites have in common. It begins with little things, like normalize, mixins, shared icons, and the partials layer (elements, components, sequences, entities, pages, and more).

For the projects (sites) to work correctly, you have to decide which styles appear in enough of the sites to warrant defining them in the base layer, and which styles aren’t, and therefore should be defined in the specific project in which they appear. It’s a practice you will achieve by trial and error. It often happens that you move styles from layer to layer when your perspective changes, until you get them balanced in a way that suits you.

After understanding this principle, you can begin making the underlying global layer. This global layer will be the starting point for all the projects (sites).

Here’s an example of a diagram that demonstrates the requirements of the company I worked for at that time.

![Layer Structures](https://cdn-images-1.medium.com/max/2000/1*zYZV-QHyYrA_1XwxibQw2A.png)

The base layer should be thin, only containing CSS resets, base SASS mixins, shared icons, general font (if needed), utility classes, and maybe shared grids if it suits all projects. For the `_partials.scss` layer (elements, components, etc.), you will mostly use the `_elements.scss` layer which has partials like common-popup, common forms, and common titles. You only add styles that are shared by all, or most, of the lower layers. ([More about Folders & Files Structure is detailed in my previous post](https://medium.com/@elad/css-architecture-folders-files-structure-f92b40c78d0b))

#### How to Structure the Layers

In our architecture, each layer has at least three files; 2 private files (local and config; I call them private because they don’t get compiled into a CSS file) and one public file (the primary layer file). The layer’s configuration file, `**_config.scss**` usually contains variables. The `**_local.scss**` file includes the content styles and acts as a kind of controller or a package manager for the layer. **The third** file **calls** those first two files **(layer-name.scss**).

**layer-name.scss file:**

```
@import "config";
@import "local";
```

Another principle that we should set for ourselves is to try and divide everything into the smallest parts (small files) possible. This principle will become very handy when you get to refactoring.

In every layer, **compile only the layer-name.scss** file. You should do this even in layers representing a ‘Virtual Project’ like the ‘Base Layer Framework’ in the above diagram.

For the private files, which aren’t compiled to a separate CSS file, we use an underscore (“`_`”) as a prefix in all file names. The underscore symbols a file which can’t stand on its own.

**Notice:** When importing private files, you can write their names without the underscore prefix.

**Example of layer structure:**

![The **_local.scss file includes all *.scss files in the local folder**, which, in turn, calls **all *.scss files in the private folders**. The **_config.scss file calls all files in the config folders**.](https://cdn-images-1.medium.com/max/2000/1*0hwUrfXGWkZR-aTVfoojyA.png)

**How it looks in the folders**

```
sass/ 
 |
 |- base-layer/
     |- config/     
     |- local/
     |- _config.scss
     |- _local.scss
     |- base-layer.css  (compiled layer style)
     |- base-layer.scss
```

## Inheritance

Imagine we want to create a project from the base layer. We will have to build a parallel folder with the project’s name. In the following example, we’ll call it **inherited-project**.

**Note**: Locate all layers and projects in the SASS root folder.

The project has at least one `**_config.scss**` file, one `**_local.scss**` file, and the layer’s central sass file named, in our example, `**inherited-project.scss**`.

All layers/projects sit in the root folder of SASS.

```
sass/ 
 |
 |- base-layer
 |   |- config/     
 |   |- local/
 |   |- _config.scss
 |   |- _local.scss
 |   |- base-layer.css  (compiled layer style)
 |   |- base-layer.scss 
 |
 |- inherited-project
     |- config/     
     |- local/
     |- _config.scss
     |- _local.scss
     |- inherited-project.css  (compiled layer style)
     |- inherited-project.scss
```

The **inherited-project**’s config file imports the **base-layer**’s config file. This way, we can add new variables, or override existing ones from the layer above (**base-layer**).

Here’s an **example** of the- **inherited-project/_config.scss**:

```
/*load base-layer configuration */
@import "../base-layer/config.scss";

/** local Config layer (add or override variables if needed)**/
@import "config/directions.scss";
```

The same goes for the **inherited-project/_local.scss** content files of the layer.

```
/* import base-layer local components  */
@import "../base-layer/local.scss";

/* local font */
@import "local/font-almoni.scss";

/* local components*/
@import "local/elements.scss";
@import "local/components.scss";
```

Inheriting from the base-project folder is the right way to build a new layer that has its unique style, based on the inheritance from the base layer.

This layer will create one CSS file, called `**inherited-project.css**`.

#### Override variable in inner layer

It’s straightforward to override variables using the ‘layers’ method.

Let’s say we have a variable named `**$base-color**` in the base layer and its value is blue (`**$base-color: blue**`;). Overriding this variable requires updating its value in the **local** `_config.scss`. Now all the components that use this variable — whether inherited from the **base layer** or defined in the **local layer** — will be updated with the value of the overridden color.

## Global Story

Some partials aren’t used in all layers, and therefore if you define them in the base layer, the other projects will import unnecessary code. To solve this problem, I implemented another idea of **global partials** concept.

This concept is that partials which are used only in some layers will be placed in another new root folder (`_partials`) outside of any layer. Then, any layer that needs these partials can import them from the `_partials` global folder.

**This diagram** illustrates **an example** of separated partials:

![](https://cdn-images-1.medium.com/max/2000/1*F43F_4fEqXCCTLNz07nrqg.png)

Every layer can call a single partial or multiple ones from the global `**_partials**` folder, as needed.

**Example of a global _partials folder:**

```
sass/ 
 |
 |- _partials/ 
 |- base-layer/ 
 |- inherited-project/
```

**local.scss file view of — import global partial:**

```
/* import base-layer local components */
@import "../base-layer/local.scss";

/*local components*/
@import "local/partials.scss";

/* add global partial */
@import "../_partials/last-connection";
```

**Few extra guidelines**

* **Be well organized**. Always organize your projects and maintain the best structure in a way that fits your needs.
* **Don’t repeat yourself**. You can import other layers’ components by simply `@import`ing them directly. For example, let’s say some components are defined in the ‘sports’ project, and they’re relevant to the ‘news’ site of another project. We can `@import` those components to the ‘news’ site. (site = layer = project)
* **Utilize IDE shortcuts**. Use a code editor that enables easy refactoring without causing errors or bugs.
* **Make sure you don’t break anything while you work**. Compile all root SASS files while working and continuously refactor the code to see that nothing breaks.

## To Summarize

In this post, I showed my CSS Architecture approach for a multiple-websites architecture, based on the knowledge and experience I’ve gained over the years.

This post is the third in a **new series of articles on CSS Architecture** I have written, and I will share with you every few weeks.

If it is interesting you , you are welcome to follow me on [**twitter**](https://twitter.com/eladsc) or [**medium**](https://medium.com/@elad).

## My CSS Architecture Series:

1. [Normalize CSS or CSS Reset?!](https://medium.com/@elad/normalize-css-or-css-reset-9d75175c5d1e)
2. [CSS Architecture — Folders & Files Structure](https://medium.com/@elad/css-architecture-folders-files-structure-f92b40c78d0b)
3. [CSS Architecture for Multiple Websites](https://medium.com/@elad/css-architecture-for-multiple-websites-ad696c9d334)

## Final Words

That’s all;
I hope you’ve enjoyed this article and learned from my experience.
If you like this post, I would appreciate applause and sharing :-)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
