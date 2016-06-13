>* 原文链接 : [PostCSS – What It Is And What It Can Do](https://web-design-weekly.com/2016/06/04/postcss-what-it-is-and-what-it-can-do/)
* 原文作者 : Jake Bresnehan
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Zheaoli](https://github.com/Zheaoli)
* 校对者:


[PostCSS](http://postcss.org) 起源于2013年9月，发展到现在，已经有很多开发者为其贡献代码。 这篇文章是写给那些，还没有来得及花一点时间去了解PostCSS是什么，可以用来干什么的人。
> PostCSS是一种利用**JavaScript**来生成**CSS**的工具

PostCSS 主体非常精简。主体只包含**CSS**生成器，操作**CSS**结构的API，资源生成器，以及一个字符串化节点树的工具。所有的黑魔法都是通过利用插件实现的。

截止目前，**PostCSS** 的生态圈内已经拥有超过100种[插件](http://postcss.parts/ "PostCSS Plugins")。这些插件可以做太多的事情，比如**lint**（译者注1：一种用来检测CSS代码的工具），添加**vendor prefixes**（译者注2：添加浏览器内核前缀，可以使用浏览器的一些独有特性），允许使用最新的CSS特性，在你的**CSS**里提供统计数据，或者是允许你使用Sass，Less或者是Stylus等一系列事情。

### 让我们看看以下十种插件

[Autoprefixer](https://github.com/postcss/autoprefixer "Autoprefixer")

> 根据用户的使用场景来解析**CSS**和添加**vendor prefixes**（前文注2）。

[PostCSS Focus](https://github.com/postcss/postcss-focus "PostCSS Focus")

> 一种利用键盘操作为每个**:hover**添加**:focus**选择器的**PostCSS**插件。

[PreCSS](https://github.com/jonathantneal/precss "PreCSS")

>一个允许你在代码中使用类似**Sass**标记的插件。

[Stylelint](https://github.com/stylelint/stylelint "Stylelint")

> 一种强大的，先进的可以使你在**CSS**样式中保持一致性，避免错误的**CSS linter**工具。

[PostCSS CSS Variables](https://github.com/MadLittleMods/postcss-css-variables "PostCSS CSS Vatiables")

> 一种将用户自定义**CSS**属性（**CSS variables**）转化为静态样式的插件。

[PostCSS Flexbugs Fixes](https://github.com/luisrudge/postcss-flexbugs-fixes "PostCSS Flexbug FIxes")

> 一种试图修复**flexbug**的bug的插件。

[PostCSS CSSnext](https://github.com/MoOx/postcss-cssnext "PostCSS CSSnext")

> 一种可以让你使用**CSS**最新特性的插件。它通过最新的**CSS**特性转变为现阶段浏览器所兼容的特性，这样你不用再等待浏览器对某一特定新特性的支持。

[PostCSS CSS Stats](https://github.com/cssstats/postcss-cssstats "PostCSS CSSStats")

> 一种支持[cssstats](https://github.com/cssstats/cssstats "CSS Stats")的插件。这个插件将会返回一个**cssstatus** 对象，这样你可以利用它来进行**CSS**分析。

[PostCSS SVGO](https://github.com/ben-eb/postcss-svgo "PostCSS SVGO")

> 优化在**PostCSS**中内置的SVG。

[PostCSS Style Guide](https://github.com/morishitter/postcss-style-guide "PostCSS Style Guide")

> 一种可以自动生成风格知道的插件。将会在**Markdown**中生成**CSS**注释，并在生成的**HTML**文档中显示。

如果你想编写自己的插件，并希望将其贡献给社区的话，请确保你是先看过[guidelines](https://github.com/postcss/postcss/blob/master/docs/guidelines/plugin.md "PostCSS Guidelines")这篇文档还有[PostCSS Plugin Boilerplate](https://github.com/postcss/postcss-plugin-boilerplate "PostCSS Boilerplate")这篇官方文档。

### 在你的工作中使用**PostCSS**

**PostCSS** 是用**JavaScript**所编写的，这使得其通过利用[Grunt](http://gruntjs.com/), [Gulp](http://gulpjs.com/) 或者 [Webpack](https://webpack.github.io/)来添加。

下面是我们使用 [Autoprefixer](https://github.com/postcss/autoprefixer "Autoprefixer") 插件的示例。

`npm install autoprefixer --save-dev`

**Gulp**  
如果你使用**Gulp**，那么你需要安装[gulp-postcss](https://github.com/postcss/gulp-postcss) 这个包。

`npm install --save-dev gulp-postcss`

    gulp.task('autoprefixer', function () {
        var postcss      = require('gulp-postcss');
        var autoprefixer = require('autoprefixer');

        return gulp.src('./src/*.css')
        .pipe(postcss([ autoprefixer({ browsers: ['last 2 versions'] }) ]))
        .pipe(gulp.dest('./dest'));
    });

**Grunt**  
如果你使用**Grunt**，那么你需要安装[grunt-postcss](https://github.com/nDmitry/grunt-postcss) 这个包。

`npm install grunt-postcss --save-dev`

    module.exports = function(grunt) {
        grunt.loadNpmTasks('grunt-postcss');

        grunt.initConfig({
            postcss: {
                options: {
                        map: true,
                    processors: [
                        require('autoprefixer')({
                            browsers: ['last 2 versions']
                        })
                    ]
                },
                dist: {
                    src: 'css/*.css'
                }
            }
        });

        grunt.registerTask('default', ['postcss:dist']);

    };

**Webpack**  
如果你使用**Webpack**，那么你需要安装 [postcss-loader](https://github.com/postcss/postcss-loader) 这个包。

`npm install postcss-loader --save-dev`

    var autoprefixer = require('autoprefixer');

    module.exports = {
        module: {
            loaders: [
                {
                    test:   /\.css$/,
                    loader: "style-loader!css-loader!postcss-loader"
                }
            ]
        },
        postcss: function () {
            return [autoprefixer];
        }
    }

关于怎么整合**PostCSS**，你可以从这里 [PostCSS repo](https://github.com/postcss/postcss#usage)获取到帮助。

### 写在最后的话

在有些时候，在新技术，新工具，新框架发布的时候，去使用并观察其发展趋势无疑是一种明智的行为。 现在，**PostCSS** 已经发展到一个相当成熟的阶段，我强烈建议你在你的工作中使用它。 虽然我在我的工作中已经使用**PostCSS**一段时间，但是并不意味着我将会广泛的使用它。
