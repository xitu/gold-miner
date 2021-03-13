> * 原文地址：[Snowpack: An Alternative Build Tool to Webpack](https://blog.bitsrc.io/snowpack-an-alternative-build-tool-to-webpack-9e8da197071d)
> * 原文作者：[Nathan Sebhastian](https://medium.com/@nathansebhastian)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/snowpack-an-alternative-build-tool-to-webpack.md](https://github.com/xitu/gold-miner/blob/master/article/2021/snowpack-an-alternative-build-tool-to-webpack.md)
> * 译者：
> * 校对者：

# Snowpack: An Alternative Build Tool to Webpack

![](https://cdn-images-1.medium.com/max/2024/1*XElS7rQXRta2vXlqLti4VQ.png)

[Webpack](https://webpack.js.org/) is the most popular JavaScript build tool for the last few years because of its flexible bundling configuration and the large amount of custom plugins it officially supports for different file types.

The main purpose of using Webpack is to take all of your JavaScript files, along with modules imported from NPM, images, CSS, and other web assets, and bundle them all together into one build file that can be run by the browser.

![Webpack bundling in a nutshell. [Source](https://www.snowpack.dev/concepts/how-snowpack-works)](https://cdn-images-1.medium.com/max/3840/1*XRoIfAWL1JkSECMDC6n5Hw.png)

But Webpack is also a complicated tool with a steep learning curve because its flexibility means it has so many features and fits so many use cases. Furthermore, Webpack needs to rebundle and rebuild your entire JavaScript application even when you make just a small change on a single file. Without a good understanding of how Webpack works, it might take [more than 30 minutes](https://stackoverflow.com/questions/56431031/why-does-npm-run-build-take-30-minutes-on-development-server-and-less-than-a) in order to build an application.

But then again, Webpack was released in 2014. At that time, the browser support for the EcmaScript Module (ESM) `import` and `export` syntax is virtually non-existent, so the only way to run modern JavaScript in the browser was to grab all modules in your project and bundle them as one.

There are other processes involved along the way, such as transpiling JavaScript from a newer version into an older version with Babel so that the browser can run the application. But the main idea for using Webpack was to help create the best developer experience while enabling JavaScript developers to use modern features (ES6 and up).

ESM syntax is widely supported by all major browsers today, so bundling your JavaScript files together is no longer mandatory for running the application on the browser.

## Unbundled development with Snowpack

[Snowpack](https://www.snowpack.dev/) is a JavaScript build tool that takes advantage of the browser support for ESM so that you can build and ship individual files to the browser. Each file built will be cached, and when you change a single file, only that file will be rebuild by Snowpack.

![Snowpack serve your files unbundled. [Source](https://www.snowpack.dev/concepts/how-snowpack-works)](https://cdn-images-1.medium.com/max/3840/1*Ep5bOeYn1t-Y0XnSRUD2mA.png)

Snowpack development server is also optimized to only build a file once it’s requested by the browser, which allows Snowpack to start instantly (**\< 50ms**) and scale up to large projects without slowing down. I’ve tried it myself and my server started in 35ms:

![Snowpack dev server startup](https://cdn-images-1.medium.com/max/2906/1*EpNPrzN0EeeEYlMM3SLIWw.png)

## Snowpack build process

Snowpack will deploy your unbundled application to production by default, but you probably want to implement build optimization techniques like minification, code-splitting, tree-shaking, lazy loading, and more.

Snowpack also has support for bundling your application for production build by connecting to [Webpack using a plugin](https://www.npmjs.com/package/@snowpack/plugin-webpack). Now since Snowpack already handles the process of transpiling your code, your bundler (Webpack) will only build common HTML, CSS, and JavaScript files. This is why you don’t need complicated Webpack configuration for the bundling process.

Finally, you can also set the list of browser versions you’d like to support by setting the `browserslist` property of your `package.json` file:

```
/* package.json */
"browserslist": ">0.75%, not ie 11, not UCAndroid >0, not OperaMini all",
```

The property will be picked up automatically when you run the `snowpack build` command to build the project for production environment. Snowpack doesn’t perform any transpilation when building for development, but this shouldn’t be a problem because most of the time you will develop using the latest browser version.

## Getting started with Snowpack

To start using Snowpack, you can immediately create a Snowpack application using Create Snowpack App (CSA)and NPX. For example, you can create a starter React application with CSA with the following command:

```sh
npx create-snowpack-app react-snowpack --template @snowpack/app-template-react
```

A new `react-snowpack` folder will be created and bootstrapped with minimum dependencies:

```json
{
  "scripts": {
    "start": "snowpack dev",
    "build": "snowpack build",
    "test": "web-test-runner \"src/**/*.test.jsx\"",
    "format": "prettier --write \"src/**/*.{js,jsx}\"",
    "lint": "prettier --check \"src/**/*.{js,jsx}\""
  },
  "dependencies": {
    "react": "^17.0.0",
    "react-dom": "^17.0.0"
  },
  "devDependencies": {
    "@snowpack/plugin-dotenv": "^2.0.5",
    "@snowpack/plugin-react-refresh": "^2.4.0",
    "@snowpack/web-test-runner-plugin": "^0.2.0",
    "@testing-library/react": "^11.0.0",
    "@web/test-runner": "^0.12.0",
    "chai": "^4.2.0",
    "prettier": "^2.0.5",
    "snowpack": "^3.0.1"
  }
}
```

You can immediately run the application with `npm start` command. The local development server will be opened at port 8080. The CSA template for React is very similar to Create React App’s default template:

![React default page for CSA](https://cdn-images-1.medium.com/max/3104/1*j3OQj_TV0ODHJZZpiaTzew.png)

Snowpack supports [many official templates](https://github.com/snowpackjs/snowpack/tree/main/create-snowpack-app/cli#official-app-templates) for popular libraries like React, Vue, and Svelte. You only need to add the `--template` option to the command.

## Conclusion

> **You should be able to use a bundler because you want to, and not because you need to - **[Snowpack documentation](https://www.snowpack.dev/concepts/build-pipeline#bundle-for-production)

Webpack and Snowpack was created years apart, and although Webpack has been the most popular choice for bundling JavaScript modules, the browser support for ESM modules has opened a new way to develop web applications.

With the power to enable unbundled development and quickly rebuild the application in development, Snowpack is an exciting alternative to Webpack that’s easier to use for building JavaScript applications. It also allows you to use Webpack for bundling your production build, enabling build optimization techniques to be implemented for your project.

Be sure to checkout [Snowpack documentation](https://www.snowpack.dev/) for more information.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
